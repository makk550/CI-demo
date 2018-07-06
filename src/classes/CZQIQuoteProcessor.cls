public class CZQIQuoteProcessor {
    /**
     * This is called by the CZQuoteInterfaceTrigger when Input Quote Header Status is 12.
     */
    @future
    public static void processQuotes(Set<Id> headerIds) {
        List<Input_Quote_Header__c> headers = CZQuoteInterfaceUtility.getInputHeaders(headerIds);
        try {
            processQuotesImpl(headers);
        } catch (Exception e) {
            String errorMessage = CZQuoteInterfaceUtility.generateErrorMessage(e);
            CZQuoteInterfaceUtility.setFailure(errorMessage, headers);
            
            update headers;
        }
    }
    
    public static void processQuotesImpl(List<Input_Quote_Header__c> headersToProcess) {
        SystemIdUtility.SkipOpportunityTriggers = true;
        
        System.debug('==> Processesing ' + headersToProcess.size() + ' input headers.');
        
        Map<String,Id> quoteIdMap = new Map<String,Id>();
        Map<String,Input_Quote_Header__c> headerMap = new Map<String,Input_Quote_Header__c>();
        Map<String,SBQQ__Quote__c> quoteMap = new Map<String,SBQQ__Quote__c>();
        Set<String> productCodes = new Set<String>();
        Set<String> maintenanceProductCodes = new Set<String>();
        Set<String> requiredProductCodes = new Set<String>();
        
        for (Input_Quote_Header__c header : headersToProcess) {
            System.debug('header.Quote_Number__c= [' + header.Quote_Number__c + ']');
            headerMap.put(header.Quote_Number__c, header);
            quoteIdMap.put(header.Quote_Number__c, header.Quote__c);
        }

        List<SBQQ__Quote__c> quotes = [SELECT Id, Name, SBQQ__Status__c, SBQQ__StartDate__c, SAP_Quote_Number__c, SBQQ__PricebookId__c from SBQQ__Quote__c where Id in : quoteIdMap.values()];
        System.debug('query result returned ' + quotes.size() + ' records.');
        for (SBQQ__Quote__c quote : quotes) {
            System.debug('quote.SAP_Quote_Number__c= [' + quote.SAP_Quote_Number__c + ']');
            quoteMap.put(quote.SAP_Quote_Number__c, quote);
        }

        List<Input_Quote_Line__c> linesToProcess = [SELECT
                                                    Id,
                                                    Name,
                                                    Auth_Use_Mode__c,
                                                    Business_Type__c,
                                                    Discount__c,
                                                    Error_Reason__c,
                                                    ProductCode__c,
                                                    Product_Instance_Id__c,
                                                    Maintenance_Discount__c,
                                                    Quantity__c,
                                                    Quote_Line_Number__c,
                                                    Quote_Number__c,
                                                    Status__c,
                                                    Reason_for_Disc__c,
                                                    Competitor_name__c,
                                                    Product_Discount_Reason__c
                                                    from Input_Quote_Line__c
                                                    where Quote_Number__c in : quoteIdMap.keySet() order by Quote_Number__c, Quote_Line_Number__c];

        Map<String,List<Input_Quote_Line__c>> lineListMap = new Map<String,List<Input_Quote_Line__c>>();
        
        Map<String,Input_Quote_Line__c> bundleQuoteLineMap = new Map<String,Input_Quote_Line__c>();
        Map<String,Integer> lowestQuoteLineNumberMap = new Map<String,Integer>(); 

        for (Input_Quote_Line__c line : linesToProcess) {
            Integer lowestQuoteLineNumber = lowestQuoteLineNumberMap.get(line.Quote_Number__c);
            Integer currentQuoteLineNumber = Integer.valueOf(line.Quote_Line_Number__c);
            
            if (lowestQuoteLineNumber == null) {
                lowestQuoteLineNumberMap.put(line.Quote_Number__c, currentQuoteLineNumber);
	            bundleQuoteLineMap.put(line.Quote_Number__c, line);
            } else if (lowestQuoteLineNumber > currentQuoteLineNumber) {
	            bundleQuoteLineMap.put(line.Quote_Number__c, line);
            }
            
            List<Input_Quote_Line__c> lineList = lineListMap.get(line.Quote_Number__c);

            if (lineList == null) {
                lineList = new List<Input_Quote_Line__c>();
                lineListMap.put(line.Quote_Number__c, lineList);
            }

            lineList.add(line);

            String productCode = CZQuoteInterfaceUtility.generateProductCode(line);
            productCodes.add(productCode);
            if (line.Auth_Use_Mode__c == CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE) {
                maintenanceProductCodes.add(productCode);
            } else {
                requiredProductCodes.add(productCode);
            }
        }
        
        System.debug('There are ' + lineListMap.size() + ' entries in the line list map.');

        CZQILookupHelper lookupHelper = new CZQILookupHelper();
        lookupHelper.initializeProducts(productCodes);
        lookupHelper.initializeMaintenanceProductOptions(maintenanceProductCodes);
        lookupHelper.initializeRequiredProductOptions(requiredProductCodes);
        lookupHelper.initializeBundles();
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        
        Map<String,List<SBQQ__QuoteLine__c>> quoteLineMap = new Map<String,List<SBQQ__QuoteLine__c>>();
        
        for (Input_Quote_Header__c header : headersToProcess) {
            try {
                quoteLineMap.put(header.Quote_Number__c, processQuote(quoteMap.get(header.Quote_Number__c), lookupHelper, header, lineListMap.get(header.Quote_Number__c)));
                quoteLines.addAll(quoteLineMap.get(header.Quote_Number__c));

            } catch (Exception e) {
                String errorMessage = CZQuoteInterfaceUtility.generateErrorMessage(e);
                CZQuoteInterfaceUtility.setFailure(errorMessage, header);
                CZQuoteInterfaceUtility.setFailure(errorMessage, lineListMap.get(header.Quote_Number__c));
            }
        }
        
        SBQQ.TriggerControl.disable();
        if (!quoteLines.isEmpty()) {
            insert quoteLines;
        }
        
        for (String quoteNumber: quoteLineMap.keySet()) {
            List<SBQQ__QuoteLine__c> curLines = quoteLineMap.get(quoteNumber);
            Id bundleLineId;
            Id previousLineId;
            
            if (curLines == null || curLines.isEmpty()) {
                continue;
            }
            
            if (curLines.get(0).SBQQ__Bundle__c == true) {
                bundleLineId = curLines.get(0).Id;
            }

            for (SBQQ__QuoteLine__c cur : curLines) {
                if (cur.SBQQ__ProductOption__c != null) {
                    if (cur.Maintenance_Product__c == 'Yes') {
                        cur.SBQQ__RequiredBy__c = previousLineId;
                    } else if (bundleLineId != null) {
                        cur.SBQQ__RequiredBy__c = bundleLineId;
                    }
                }
                previousLineId = cur.Id;
            }
        }
        
        if (!quoteLines.isEmpty()) {
            update quoteLines;
        }

        
        update quoteMap.values();
        
        SBQQ.TriggerControl.enable();
        
        update headersToProcess;

        update linesToProcess;
        
        
        SystemIdUtility.SkipOpportunityTriggers = false;
    }
    
    public static List<SBQQ__QuoteLine__c> processQuote(SBQQ__Quote__c quote, CZQILookupHelper lookupHelper, Input_Quote_Header__c header, List<Input_Quote_Line__c> inputLines) {
		List<Input_Quote_Line__c> errsToUpdate = new List<Input_Quote_Line__c>();
        if (quote == null) {
            throw new CZQuoteInterfaceException('Quote is null for input header with quote number ' + header.Quote_Number__c);
        }

        if (inputLines == null || inputLines.isEmpty()) {
            throw new CZQuoteInterfaceException('No inputlines for quote with id ' + quote.Id);
        }
        
        if (!String.isBlank(header.StartDate__c)) {
            quote.SBQQ__StartDate__c = Date.parse(header.StartDate__c);
            System.debug('Setting start date: ' + quote.SBQQ__StartDate__c);
        }
        
        String bundleProductCode = CZQuoteInterfaceUtility.generateProductCode(inputLines.get(0));
        Id bundleId = lookupHelper.getBundleProductId(bundleProductCode);
        Boolean isSubscriptionBundle = lookupHelper.isSubscriptionBundle(bundleId);
        System.debug('quote number = ' + header.Quote_Number__c);
        System.debug('input lines size=' + inputLines.size());
        System.debug('==> bundleId = [' + bundleId + ']');
        
        List<SBQQ__QuoteLine__c> retVal = new List<SBQQ__QuoteLine__c>();
        
        if (bundleId != null) {
            Integer index = 1;
            
            //This is a bundle
            SBQQ__QuoteLine__c bundleQuoteLine = new SBQQ__QuoteLine__c();

            bundleQuoteLine.SBQQ__Product__c = bundleId;
            bundleQuoteLine.SBQQ__Quantity__c = Integer.valueOf(inputLines.get(0).Quantity__c);
            bundleQuoteLine.SBQQ__Quote__c = quote.Id;
            bundleQuoteLine.SBQQ__Bundle__c = true;
            bundleQuoteLine.SBQQ__Number__c = index;
            
            retVal.add(bundleQuoteLine);
            
            index++;
            
            for (Input_Quote_Line__c line : inputLines) {
                if (line.Status__c == 99) {
                    continue;
                }
                if (line.Auth_Use_Mode__c != 'I' && line.Auth_Use_Mode__c != 'D') {
                    //throw new CZQuoteInterfaceException('Unsupported Auth Use Mode ' + line.Auth_Use_Mode__c + '.');
					line.Error_Reason__c =  'Unsupported Auth Use Mode ' + line.Auth_Use_Mode__c + '.';
					line.Status__c = CZQuoteInterfaceConstants.FAILURE_STATUS;
					errsToUpdate.add(line);
                    continue;
                }
                Product2 lineProduct = lookupHelper.getProduct(CZQuoteInterfaceUtility.generateProductCode(line));
                if (lineProduct == null) {
                    continue;
                }
                SBQQ__QuoteLine__c curQuoteLine = new SBQQ__QuoteLine__c();

                retVal.add(curQuoteLine);
                curQuoteLine = CZQuoteInterfaceUtility.copyQuoteLineInformation(lookupHelper, curQuoteLine, line);

                Id lineId = lineProduct.Id;
                curQuoteLine.SBQQ__ProductOption__c = lookupHelper.getProductOptionId(bundleId, lineId);
                if (curQuoteLine.SBQQ__ProductOption__c == null) {
                    line.Error_Reason__c = 'Quote Line with Product Code ' + line.ProductCode__c + ' has no product option for bundle with Product Code ' + bundleProductCode + '.';
					line.Status__c = CZQuoteInterfaceConstants.FAILURE_STATUS;
					errsToUpdate.add(line);
					continue;
					//throw new CZQuoteInterfaceException('Quote Line with Product Code ' + line.ProductCode__c + ' has no product option for bundle with Product Code ' + bundleProductCode + '.');
                }
                
                System.debug('==> curQuoteLine.SBQQ__ProductOption__c = [' + curQuoteLine.SBQQ__ProductOption__c + ']');
                curQuoteLine.SBQQ__Quote__c = quote.Id;
                curQuoteLine.SBQQ__OptionLevel__c = 1;
                curQuoteLine.SBQQ__Number__c = index;

                //add maintenance line
                if (line.Auth_Use_Mode__c == CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE && !isSubscriptionBundle) {
                    SBQQ__QuoteLine__c maintenance = addMaintenanceLine(lookupHelper, line, quote, true);
                    maintenance.SBQQ__Number__c = index;
                    retVal.add(maintenance);
                    index++;
                }
                
                index++;
            }
        } else {
            //Consider these independent quote lines.
            Integer index = 1;
            for (Input_Quote_Line__c line : inputLines) {
                if (line.Status__c == 99) {
                    continue;
                }
                
                String lineProductCode = CZQuoteInterfaceUtility.generateProductCode(line);
                Product2 lineProduct = lookupHelper.getProduct(lineProductCode);
                
                if (lineProduct == null) {
                    CZQuoteInterfaceUtility.setFailure('No Product Found with Product Code ' + lineProductCode, line);
                    
                    continue;
                }
                
                SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();

                quoteLine = CZQuoteInterfaceUtility.copyQuoteLineInformation(lookupHelper, quoteLine, line);
                quoteLine.SBQQ__Product__c = lineProduct.Id;
                quoteLine.SBQQ__Quote__c = quote.Id;
                quoteLine.SBQQ__Number__c = index;
                
                retVal.add(quoteLine);

                //add maintenance line
                if (line.Auth_Use_Mode__c == CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE) {
                    SBQQ__QuoteLine__c maintenance = addMaintenanceLine(lookupHelper, line, quote, false);
                    maintenance.SBQQ__Number__c = index;
                    retVal.add(maintenance);
                    index++;
                } else {
                    SBQQ__QuoteLine__c required = addRequiredLine(lookupHelper, line, quote, false);
                    required.SBQQ__Number__c = index;
                    retVal.add(required);
                    index++;
                }
                
                index++;
            }
        }
        
        if (retVal.isEmpty()) {
            throw new CZQuoteInterfaceException('No quote lines were generated.');
        }
        
        CZQuoteInterfaceUtility.setReadyForQuoteCalculation(header);
		update errsToUpdate;
        return retVal;
    }
    
    public static SBQQ__QuoteLine__c addMaintenanceLine(CZQILookupHelper lookupHelper, Input_Quote_Line__c line, SBQQ__Quote__c quote, Boolean bundle) {
        System.debug('Adding maintenance line.');
        
        SBQQ__QuoteLine__c maintenance = new SBQQ__QuoteLine__c();


        String productCode = CZQuoteInterfaceUtility.generateProductCode(line);
        maintenance.SBQQ__ProductOption__c = lookupHelper.getMaintenanceProductOptionId(productCode);
        maintenance.SBQQ__Product__c = lookupHelper.getMaintenanceProductId(productCode);
        System.debug('maintenance.SBQQ__ProductOption__c=' + maintenance.SBQQ__ProductOption__c);
        maintenance.SBQQ__OptionLevel__c = 1;

        if (bundle) {
            maintenance.SBQQ__OptionLevel__c = 2;
        }
        
        maintenance.SBQQ__Quantity__c = 1;
        maintenance.SBQQ__Quote__c = quote.Id;
        maintenance.Maintenance_Product__c = 'Yes';
        
        if (!String.isEmpty(line.Maintenance_Discount__c) && ('NULL' != line.Maintenance_Discount__c)) {
            maintenance.SBQQ__Discount__c = Double.valueOf(line.Maintenance_Discount__c);
        }

        return maintenance;
    }
    
    public static SBQQ__QuoteLine__c addRequiredLine(CZQILookupHelper lookupHelper, Input_Quote_Line__c line, SBQQ__Quote__c quote, Boolean bundle) {
        System.debug('Adding required line.');
        
        SBQQ__QuoteLine__c required = new SBQQ__QuoteLine__c();

        String productCode = CZQuoteInterfaceUtility.generateProductCode(line);
        required.SBQQ__ProductOption__c = lookupHelper.getRequiredProductOptionId(productCode);
        required.SBQQ__Product__c = lookupHelper.getRequiredProductId(productCode);
        System.debug('required.SBQQ__ProductOption__c=' + required.SBQQ__ProductOption__c);
        required.SBQQ__OptionLevel__c = 1;
        required.Maintenance_Product__c = 'Yes';

        if (bundle) {
            required.SBQQ__OptionLevel__c = 2;
        }
        
        required.SBQQ__Quantity__c = 1;
        required.SBQQ__Quote__c = quote.Id;
        
        return required;
    }

    /**
     * This is called by the Quote Calculator Batch
     */
    public static void calculate(Set<Id> headerIds) {
        List<Input_Quote_Header__c> headersToProcess = CZQuoteInterfaceUtility.getInputHeaders(headerIds);
        
        List<Id> quoteIds = new List<Id>();
        List<Id> oppIds = new List<Id>();
        
        for (Input_Quote_Header__c header : headersToProcess) {
            quoteIds.add(header.Quote__c);
            oppIds.add(header.Opportunity_Id__c);

            CZQuoteInterfaceUtility.setReadyForOppContracting(header);
        }
        
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        
        List<Opportunity> opps = [Select Id, SBQQ__PrimaryQuote__c from Opportunity where Id in : oppIds];

        for (Opportunity opportunity : opps) {
            oppMap.put(opportunity.Id, opportunity);
        }
        
        List<SBQQ__Quote__c> quotes = [Select Id, SBQQ__Opportunity2__c, SBQQ__Primary__c from SBQQ__Quote__c where Id in : quoteIds];
        
        for (SBQQ__Quote__c quote : quotes) {
            
            quote.SBQQ__Primary__c = true;
            oppMap.get(quote.SBQQ__Opportunity2__c).SBQQ__PrimaryQuote__c = quote.Id;
        }
        
        update quotes;
        
        update opps;

        update headersToProcess;
    }
    
    private static void callQuoteCalculator(Id quoteId) {
        QuoteModel quote = new QuoteReader().read(quoteId);
        System.debug(quote);
        
        CZQIQuoteCalculator calculator = new CZQIQuoteCalculator();
        calculator.calculate(quote, 'CZQICalculatorCallback');
    }
    
    /**
     * This is called by the Contracted Batch.
     */
    public static void contractOpps(Set<Id> headerIds) {
        List<Input_Quote_Header__c> headersToProcess = CZQuoteInterfaceUtility.getInputHeaders(headerIds);
        
        List<Id> oppIds = new List<Id>();
        for (Input_Quote_Header__c header : headersToProcess) {
            oppIds.add(header.Opportunity_Id__c);
            CZQuoteInterfaceUtility.setReadyForClosing(header);
        }

        List<Opportunity> opps = [Select Id, SBQQ__Contracted__c from Opportunity where Id in : oppIds];
        
        for (Opportunity opp : opps) {
            opp.SBQQ__Contracted__c = true;
        }
        
        update opps;

        update headersToProcess;
    }
    
    /**
     * This is called by the Finisher Batch.
     */
    public static void closeQuoteAndOpp(Set<Id> headerIds) {
        List<Input_Quote_Header__c> headersToProcess = CZQuoteInterfaceUtility.getInputHeaders(headerIds);
        
        SBQQ.TriggerControl.disable();

        try {
            closeQuoteAndOppImpl(headersToProcess);
        } catch (Exception e) {
            String errorMessage = CZQuoteInterfaceUtility.generateErrorMessage(e);
            CZQuoteInterfaceUtility.setFailure(errorMessage, headersToProcess);
            
            update headersToProcess;
        }
        
        SBQQ.TriggerControl.enable();
    }
    
    public static void closeQuoteAndOppImpl(List<Input_Quote_Header__c> headersToProcess) {
        
        List<Id> quoteIds = new List<Id>();
        List<Id> oppIds = new List<Id>();
        for (Input_Quote_Header__c header : headersToProcess) {
            quoteIds.add(header.Quote__c);
            oppIds.add(header.Opportunity_Id__c);
            CZQuoteInterfaceUtility.setSuccess(header);
        }
        
        List<Opportunity> opps = [Select Id, SBQQ__PrimaryQuote__c, StageName, ReasonField__c from Opportunity where Id in : oppIds];

        for (Opportunity opportunity : opps) {
            opportunity.StageName = CZQuoteInterfaceConstants.OPPORTUNITY_STAGE_FINAL;
            opportunity.ReasonField__c = CZQuoteInterfaceConstants.OPPORTUNITY_STAGE_REASON;
            //opportunity.SBQQ__Contracted__c = true;
        }
        
        List<SBQQ__Quote__c> quotes = [Select Id, SBQQ__Status__c, SBQQ__Opportunity2__c, Sales_Attestation_Agreement__c, Concession_offered_due_to_a_prior_deal__c, SBQQ__Primary__c from SBQQ__Quote__c where Id in : quoteIds];
        
        for (SBQQ__Quote__c quote : quotes) {
            quote.SBQQ__Status__c = CZQuoteInterfaceConstants.QUOTE_FINAL_STATUS;
            quote.Sales_Attestation_Agreement__c = true;
            quote.Concession_offered_due_to_a_prior_deal__c = 'No';
        }
        
        
        try {
            update quotes;
            update opps;
        } catch (Exception e) {
            System.debug('we have an error reason.' + CZQuoteInterfaceUtility.generateErrorMessage(e));
            throw e;
        }
        
        update headersToProcess;
    }
    
}