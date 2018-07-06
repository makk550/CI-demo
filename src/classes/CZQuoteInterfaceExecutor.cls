public class CZQuoteInterfaceExecutor {
    public Set<Id> input {get;set;}
    
    private List<Input_Quote_Header__c> headers;

    private String defaultOpportunityTemplateName = 'Test_Opportunity_Template';
    private String defaultQuoteTemplateName = 'Test_Quote_Template';
    private String defaultPricebookId;
        
    private CZQILookupHelper lookupHelper = new CZQILookupHelper();
    
    public CZQuoteInterfaceExecutor() {
    }
    
    public void execute() {
        try {
            executeImpl();
        } catch (Exception e) {
            for (Input_Quote_Header__c header : headers) {
                CZQuoteInterfaceUtility.setFailure(CZQuoteInterfaceUtility.generateErrorMessage(e), header);
            }
            
            update headers;
        }
    }
    
    private void executeImpl() {
        populateInput();
        
        Map<String,Input_Quote_Header__c> headerMap = new Map<String,Input_Quote_Header__c>();
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
        Map<String,SBQQ__Quote__c> quoteMap = new Map<String,SBQQ__Quote__c>();
        
        for (Input_Quote_Header__c header : headers) {
            if (header.Quote_Number__c == null || header.Quote_Number__c == '') {
                throw new CZQuoteInterfaceException('No quote number was provided.');
            }
            
            headerMap.put(header.Quote_Number__c, header);

            try {
                String oppTemplateName = header.Opportunity_Template__c;
                String quoteTemplateName = header.Quote_Template__c;
                
                if (String.isBlank(oppTemplateName)) {
                    oppTemplateName = defaultOpportunityTemplateName;
                }
                
                if (String.isBlank(quoteTemplateName)) {
                    quoteTemplateName = defaultQuoteTemplateName;
                }
                
                Opportunity newOpp = lookupHelper.cloneOpportunityTemplate(oppTemplateName);
                newOpp.Pricebook2Id = defaultPricebookId;
                
                SBQQ__Quote__c newQuote = lookupHelper.cloneQuoteTemplate(quoteTemplateName);
                
                if (newOpp.SBQQ__Contracted__c == true) {
                    //reverse contracted due to cloned opp.
                    newOpp.SBQQ__Contracted__c = false;
                }
                
                newQuote.SBQQ__Status__c = 'Draft';
                newQuote.SBQQ__PricebookId__c = defaultPricebookId;

                if (String.isBlank(newOpp.StageName)) {
                    newOpp.StageName = CZQuoteInterfaceConstants.OPPORTUNITY_STAGE_INITIAL;
                }
                
                newOpp = CZQuoteInterfaceUtility.copyOpportunityInformation(lookupHelper, newOpp, header);
                newQuote = CZQuoteInterfaceUtility.copyQuoteInformation(lookupHelper, newQuote, header);
                
                newOpp.Contract_Type__c = 'SAAS';
                newOpp.Inside_Outside__c = 'Inside';
                
                Contract masterContract = lookupHelper.getMasterContract(header);
                
                if (masterContract != null) {
                    newQuote.SBQQ__MasterContract__c = masterContract.Id;
                    newQuote.SBQQ__EndDate__c = masterContract.EndDate;
                    newOpp.SBQQ__AmendedContract__c = masterContract.Id;
                }
                
                quoteMap.put(header.Quote_Number__c, newQuote);
                oppMap.put(header.Quote_Number__c, newOpp);
                CZQuoteInterfaceUtility.setReadyForProcessing(header);
            } catch (Exception e) {
                CZQuoteInterfaceUtility.setFailure(CZQuoteInterfaceUtility.generateErrorMessage(e), header);
            }
        }
        
        if (!oppMap.isEmpty()) {
            insert oppMap.values();
        }
        
        //connect quotes back to opportunities / connect header to new opportunities
        for (Input_Quote_Header__c header : headers) {
            System.debug('header.Status__c=' + header.Status__c);
            if (header.Status__c == CZQuoteInterfaceConstants.PROCESS_READY_STATUS) {
                SBQQ__Quote__c quote = quoteMap.get(header.Quote_Number__c);
                Opportunity opp = oppMap.get(header.Quote_Number__c);
                quote.SBQQ__Opportunity2__c = opp.Id;
                header.Opportunity_Id__c = opp.Id;
            }
        }

        if (!quoteMap.isEmpty()) {
            insert quoteMap.values();
        }

        for (Input_Quote_Header__c header : headers) {
            if (header.Status__c == CZQuoteInterfaceConstants.PROCESS_READY_STATUS) {
                SBQQ__Quote__c quote = quoteMap.get(header.Quote_Number__c);
                
                header.Quote__c = quote.Id;
            }
        }
        
        update headers;
    }

    private void populateInput() {
        if (!Test.isRunningTest()) {
            CZ_Quote_Interface_Settings__c settings = CZ_Quote_Interface_Settings__c.getInstance();
            
            defaultOpportunityTemplateName = settings.Default_Opportunity_Template_Name__c;
            defaultQuoteTemplateName = settings.Default_Quote_Template_Name__c;
            defaultPricebookId = settings.Default_Pricebook_Id__c;
        }

        headers = [SELECT 
                   Id,
                   Name,
                   AccountId__c,
                   BillingContact_Email__c,
                   BillingContact_FirstName__c,
                   BillingContact_ID__c,
                   BillingContact_IntlFName__c,
                   BillingContact_IntlLName__c,
                   BillingContact_LastName__c,
                   BillingContact_Phone__c,
                   BILL_TO_Address_Lcl__c,
                   BillTo_BPID__c,
                   BillTo_City__c,
                   BillTo_City_Intl__c,
                   BillTo_Country__c,
                   BillTo_Name__c,
                   BillTo_Name_Intl__c,
                   BillTo_PostalCode__c,
                   BillTo_State__c,
                   BillTo_State_Intl__c,
                   BillTo_Street__c,
                   BillTo_Street2__c,
                   BillTo_Street2_Intl__c,
                   BillTo_Street_Intl__c,
                   CloseDate__c,
                   CurrencyIsoCode__c,
                   Description__c,
                   End_Date__c,
                   Error_Reason__c,
                   Opportunity_Template__c,
                   Quote_Description__c,
                   Quote_Effective_Date__c,
                   Quote_Number__c,
                   Quote_Template__c,
                   ShippingContact_Email__c,
                   ShippingContact_FirstName__c,
                   ShippingContact_ID__c,
                   ShippingContact_Intl_FName__c,
                   ShippingContact_Intl_LName__c,
                   ShippingContact_LastName__c,
                   ShippingContact_Phone__c,
                   ShipTo_Address_Lcl__c,
                   ShipTo_BPID__c,
                   ShipTo_City__c,
                   ShipTo_City_Intl__c,
                   ShipTo_Country__c,
                   ShipTo_Name__c,
                   ShipTo_Name_Intl__c,
                   ShipTo_PostalCode__c,
                   ShipTo_State__c,
                   ShipTo_State_Intl__c,
                   ShipTo_Street__c,
                   ShipTo_Street2_Intl__c,
                   ShipTo_Street_Intl__c,
                   ShipTo_Street2__c,
                   SoldTo_Address_Lcl__c,
                   SoldTo_BPID__c,
                   SoldTo_City__c,
                   SoldTo_City_Intl__c,
                   SoldTo_Country__c,
                   SoldTo_Name__c,
                   SoldTo_Name_Intl__c,
                   SoldTo_PostalCode__c,
                   SoldTo_State__c,
                   SoldTo_State_Intl__c,
                   SoldTo_Street__c,
                   SoldTo_Street2__c,
                   SoldTo_Street2_Intl__c,
                   SoldTo_Street_Intl__c,
                   StartDate__c,
                   Status__c,
                   Subscription_Term__c,
                   TechnicalContact_Email__c,
                   TechnicalContact_FirstName__c,
                   TechnicalContact_ID__c,
                   TechnicalContact_Intl_FName__c,
                   TechnicalContact_Intl_LName__c,
                   TechnicalContact_LastName__c,
                   TechnicalContact_Phone__c,
                   Opportunity_Id__c,
                   Mixed_deal_incl_global_seat_count_prod__c,
                   Reseller_BPID__c,
                   Reseller_City_Intl__c,
                   Reseller_City__c,
                   Reseller_Country__c,
                   Reseller_Name_Intl__c,
                   Reseller_Name__c,
                   Reseller_PostalCode__c,
                   Reseller_State_Intl__c,
                   Reseller_State__c,
                   Reseller_Street2_Intl__c,
                   Reseller_Street2__c,
                   Reseller_Street_Intl__c,
                   Reseller_Street__c,
                   EndUser_BPID__c,
                   EndUser_City_Intl__c,
                   EndUser_City__c,
                   EndUser_Country__c,
                   EndUser_Name_Intl__c,
                   EndUser_Name__c,
                   EndUser_PostalCode__c,
                   EndUser_State_Intl__c,
                   EndUser_State__c,
                   EndUser_Street2_Intl__c,
                   EndUser_Street2__c,
                   EndUser_Street_Intl__c,
                   EndUser_Street__c,
                   EndUserContact_Email__c,
                   EndUserContact_FirstName__c,
                   EndUserContact_ID__c,
                   EndUserContact_IntlFName__c,
                   EndUserContact_IntlLName__c,
                   EndUserContact_LastName__c,
                   EndUserContact_Phone__c,
                   Opportunity_Type__c,
                   Partner1__c,
                   Deal_Registration_Status__c,
                   Partner_Engagement__c,        
                   Quote__c
                   from Input_Quote_Header__c 
                   where Id in : input];

        Set<String> opportunityTemplateNames = new Set<String>();
        Set<String> quoteTemplateNames = new Set<String>();
        
        opportunityTemplateNames.add(defaultOpportunityTemplateName);
        quoteTemplateNames.add(defaultQuoteTemplateName);
        
        Set<String> siteIds = new Set<String>();
        
        List<CZQILookupHelper.ContractCriteria> contractCriteria = new List<CZQILookupHelper.ContractCriteria>();
        
        for (Input_Quote_Header__c header : headers) {
            siteIds.add(header.ShipTo_BPID__c);
            siteIds.add(header.SoldTo_BPID__c);
            siteIds.add(header.BillTo_BPID__c);
            opportunityTemplateNames.add(header.Opportunity_Template__c);
            quoteTemplateNames.add(header.Quote_Template__c);
            
            if (!String.isBlank(header.End_Date__c) && !String.isBlank(header.ShipTo_BPID__c) && !String.isBlank(header.SoldTo_BPID__c)) {
                CZQILookupHelper.ContractCriteria criteria = new CZQILookupHelper.ContractCriteria();
                criteria.endDate = Date.parse(header.End_Date__c);
                criteria.shipToSiteId = header.ShipTo_BPID__c;
                criteria.soldToSiteId = header.SoldTo_BPID__c;
                
                contractCriteria.add(criteria);
            }
        }
        
        lookupHelper.initializeAccounts(siteIds);
        lookupHelper.initializeSiteAssociations(siteIds);
        
        lookupHelper.initializeOpportunityTemplates(opportunityTemplateNames);
        lookupHelper.initializeQuoteTemplates(quoteTemplateNames);
        lookupHelper.initializeMasterContracts(contractCriteria);
    }
}