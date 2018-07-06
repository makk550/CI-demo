/* 
 * Controller for OnGoingSync_QuoteInterface VF Page
 * Created By : merha02
*/

public class OnGoingSync_QuoteInterface {
    
    public SAP_Quote_Utility.HeaderDetails InputQuoteHeader{get;set;} // to store Header details
    public List<SAP_Quote_Utility.Item> InputQuoteLines{get;set;} // to store line item details
    Public Boolean ShowInputvalueFlag{get;set;} // to render InputText Box
    public String inputValue{get;set;} // stores Contract/Quote Number
    public String inputType{get;set;} // stores Contract Number / Quote Number Type
    public SAP_Quote_Utility SAPQuoteUtilityObj;
    public Id RecordId{get;set;}
    public String RecordName{get;set;}
    public List<SterlingQuote> SterlingQuotes {get;set;}
    public string SterlingQuoteNumber {get;set;}
    public integer sterlingQuotesTotal {get;set;}
    public boolean ShowList {get;set;}
    @TestVisible
    private Boolean isUserMigrationUser; 
    @TestVisible
    private List<PermissionSetAssignment> permSetID;

    public boolean isMigrationUser{ 
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, adding another flag check. Only display when it's "1 Tier" or "Direct" 
        get{
            return (isUserMigrationUser);
        }                                    
    }

    public OnGoingSync_QuoteInterface(){
        InputQuoteHeader = new SAP_Quote_Utility.HeaderDetails();
        InputQuoteLines = new List<SAP_Quote_Utility.Item>();
        ShowInputvalueFlag = false; // by default does not show the text box
        sterlingQuotesTotal = 0;
        ShowList = false;
        isUserMigrationUser = false;

        //sun - US484619 - Tensor H2 Quote Interface Automation Screen, only users in permissino set has access to migrate quotes.
        permSetID = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() 
                         AND PermissionSet.Name = 'Sterling_to_Salesforce_CPQ_Migration_User'];
            
        if(permSetID!=null && permSetID.size()==1)
            isUserMigrationUser = true; 
    }
	// on selection of value from Picklist shows the TextBox to enter the value
    public void onInputNumberChange(){
        if(inputType==null || inputType==''){
            ShowInputvalueFlag = false;
        }else{
            ShowInputvalueFlag = true;
        }
        return;
    }
    // pick list value options
    public List<SelectOption> getOptions() {
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-None-'));
        Options.add(new SelectOption('Quote Number','Quote Number'));
        Options.add(new SelectOption('Contract Number','Contract Number'));
        return Options;
    }
	
    public void migrate(String type,String value){
        System.debug('----inside else all values are there-----');
            
            // sends input value and input type request to SAP
            SAPQuoteUtilityObj =new SAP_Quote_Utility();
            SAP_Quote_Utility.SAPQuoteResponse Responseobj = new SAP_Quote_Utility.SAPQuoteResponse();
            // receives response from SAP with Header and Line details
            Responseobj=SAPQuoteUtilityObj.getQuoteData(type,value);
            
            System.debug('*********Responseobj*********'+Responseobj);
            // if the response is not null gets other details, else throws error message
            if(Responseobj.Message == ''){
                if(Responseobj.QuoteHeaderDetails!=null && Responseobj.QuoteLineDetails!=null && Responseobj.QuoteLineDetails.size()>0 ){
                   
                    InputQuoteHeader=Responseobj.QuoteHeaderDetails; 
                    InputQuoteLines = Responseobj.QuoteLineDetails;
                    // returns Success if the header and line items are successfully inserted
                    RecordId = QuoteInterface_Data.getAllDetails(InputQuoteHeader,InputQuoteLines); 
                    RecordName = InputQuoteHeader.SALES_DOCUMENT.substring(2);
                   
                    if(RecordId!=null){
                        
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, 'Record Inserted successfully'));
                    }
                    else{
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Record Insertion failed'));
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No records found'));
                }
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Responseobj.Message));
            }
        
    }
    public void ConvertLine()
    {
        system.debug(' sun line number is ' + SterlingQuoteNumber);
     //   migrate('Quote Number',SterlingQuoteNumber); //merha02
    }
    // on click of convert button this method is called
    public void convert(){
        System.debug('--------inputValue-------'+inputValue);
        // displays error message if no value is selected, else sends number to SAP
        if(inputValue==null || inputValue=='')
        { 
            System.debug('--------inputType-------'+inputType);
            if(inputType=='Quote Number')
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Quote number must be entered')); 
            else if(inputType=='Contract Number')
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Contract number must be entered')); 
            else
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Select number is required')); 
        }
        else{
            migrate(inputType,inputValue);
        }
        return;
        
    }

    //sunji03 - US484619 - Tensor H2 Quote Interface Automation Screen
    public void GetSerlingQuoteList()
    {
        ShowList = true;

        //Step 1: find all the product codes (sku level) in all Salesforce CPQ products (non-bundle)
        //       exclude maintaiance as it has "- Maintenance" in product code, and it always comes with another real product which has product code
        List<Product2> sfCPQProdList = new List<Product2>([Select Id, Name, ProductCode, Partner_Quoting_Eligible_SFDC_CPQ__c, Volume_Price_Curve_Quantity_Criteria__c  
                                                            from product2 where salesforce_cpq_product__c = true and ProductCode <> null and (not productcode like '%- Maintenance')]);

        //Step 2: find all the Sterling Quote items matching these product code at "product material" level, retrieve opp's transation type for later use.
        List<string> prodCodes = new List<string>();

        //temp comment this out for testing one prod, which is faster
        //for (product2 prod : sfCPQProdList){
        //   prodCodes.add(prod.ProductCode);
        //}

        //This is just for testing: 
        prodCodes.add('AGIGAS990'); //Agile central sample
        //prodcodes.add('PPMCCL990'); //PPM core user
        //prodcodes.add('PPMTMU990'); // PPM restrictred user

        system.debug('sfCPQProdList size ' + sfCPQProdList.size());

        //Where clause limit is 4000, each product code is 9 character, so roughly 330 skus, enough for H2, but for future need to batch it up
        List<List<string>> prodCodesInChunks = SplitIntoChunks(prodcodes,integer.valueof(label.Tensor_Quote_Interface_String_Chunk_Size)); 
        prodCodes.clear();

        system.debug('prodCodesInChunks is ' + prodCodesInChunks.size());

        List<Quote_Product_Report__c> quoteLineItems;

        List<List<Quote_Product_Report__c>> quoteItemsList = new List<List<Quote_Product_Report__c>>();

        for (list<string> prodList : prodCodesInChunks)
        {

            Date migrationDate = Date.valueOf(Label.Tensor_Quote_Interface_Contract_End_Date_Since); //format in 2018-06-11

            //For each smaller chuncks, run the query with "in" clause
            quoteLineItems = new List<Quote_Product_Report__c>([select id, Sterling_Quote__r.id, 
            Sterling_Quote__r.CA_CPQ_Quote_Number__c,Sterling_Quote__r.name,Sterling_Quote__r.scpq__OpportunityId__r.id, Sterling_Quote__r.scpq__OpportunityId__r.Type, 
            Product_Material__r.name from Quote_Product_Report__c where ( 
            Sterling_Quote__r.scpq__OpportunityId__r.Type = 'Direct' or Sterling_Quote__r.scpq__OpportunityId__r.Type = '1 Tier') 
            and (Sterling_Quote__r.scpq__OpportunityId__r.stagename = 'Closed - Won' or Sterling_Quote__r.scpq__OpportunityId__r.stagename = '100% - Contract Signed') 
            and Sterling_Quote__r.CA_Primary_Flag__c = true  and Sterling_Quote__r.In_STAGING_for_Salesforce_CPQ_Conversion__c <> true 
            and (Sterling_Quote__r.Salesforce_Quote_Number__c = null or Sterling_Quote__r.Salesforce_Quote_Number__c = '')
            and Sterling_Quote__r.CA_Contract_End_Date__c >: migrationDate
            and Product_Material__r.name in: prodList]);

            quoteItemsList.add(quoteLineItems);
        }
        
        system.debug('quoteItemsList size ' + quoteItemsList.size());

        //Step 3: Group data better for later use: 
        //        Group the quote lines into quotes (quoteMap), set the opp transation type on quote level. 
        //        Group the quote lines into quotes, (quotesWithItemsMap) set the SupportPartner and SupportGlobalSeatCount at quote line level based on product2 attributes retrieved at step 1
        Map<id,SterlingQuote> quoteMap = new Map<id,SterlingQuote>();
        Map<id,List<SterlingQuoteLine>> quotesWithItemsMap = new Map<id,List<SterlingQuoteLine>>(); //quote id and list of quote lines.
        SterlingQuote quote;
        SterlingQuoteLine quoteLine;
        List<SterlingQuoteLine> quoteItemList = new List<SterlingQuoteLine>();

        if (quoteItemsList.size() > 0)
        {
            for (List<Quote_Product_Report__c> lineList : quoteItemsList)
            {
                for (Quote_Product_Report__c line : lineList)
                {
                    quoteLine = new SterlingQuoteLine();
                    quoteline.QuoteLineId = line.id;
                    quoteline.QuoteId = line.Sterling_Quote__r.id;
                    quoteline.ProductMaterialName = line.Product_Material__r.name;

                    quoteline.SupportPartner = false;
                    quoteline.SupportGlobalSeatCount = false;

                    for (Product2 p : sfCPQProdList)
                    {
                        if (p.ProductCode == quoteline.ProductMaterialName)
                        {
                            if (p.Partner_Quoting_Eligible_SFDC_CPQ__c.contains('Partner')) //If it supports partner, the field should have "Partner;Direct"
                            {
                                quoteline.SupportPartner = true;
                            }
                            if (p.Volume_Price_Curve_Quantity_Criteria__c == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats) 
                            {
                                quoteline.SupportGlobalSeatCount = true;
                            }
                            break;
                        }
                    }

                    if (!quotesWithItemsMap.containsKey(line.Sterling_Quote__r.id))
                    {
                        quoteItemList = new List<SterlingQuoteLine>();
                        quoteItemList.add(quoteline);
                        quotesWithItemsMap.put(line.Sterling_Quote__r.id,quoteItemList);

                        quote = new SterlingQuote();
                        quote.QuoteId = line.Sterling_Quote__r.id;
                        quote.QuoteNumber = line.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                        quote.OpportunityId = line.Sterling_Quote__r.scpq__OpportunityId__r.id;
                        quote.QuoteName = Line.Sterling_Quote__r.name;
                        quote.TransactionType = line.Sterling_Quote__r.scpq__OpportunityId__r.Type;

                        quoteMap.put(line.Sterling_Quote__r.id,quote);
                    }
                    else
                    {
                        quotesWithItemsMap.get(line.Sterling_Quote__r.id).add(quoteline);
                    }
                }
            }
        }

        system.debug('quotesWithItemsMap size ' + quotesWithItemsMap.size());
        system.debug('quoteMap size ' + quoteMap.size());

        //Step 4: Get the deal has non-global seat count product only, query with quote id again if it has non-salesforce CPQ product
        //which will determine if it's included in the final list. If it's mixed deal includeing non-global seat count product only, it does not need to included in the conversion list. 
        List<id> quoteIdsToQueryAgain = new List<id>();
        for (id quoteId: quoteMap.keySet())
        {
            List<SterlingQuoteLine> itemsInQuote = quotesWithItemsMap.get(quoteid);
            boolean onlyNonGlobalSeatCountProduct = true;
            for (SterlingQuoteLine q : itemsInQuote)
            {
                if (q.SupportGlobalSeatCount == true)
                {
                    onlyNonGlobalSeatCountProduct = false; //find at least one non-global seat count product, break the loop.
                    break;
                }
            }

            if (onlyNonGlobalSeatCountProduct)
            {
                quoteIdsToQueryAgain.add(quoteId);
            }
        }

        system.debug('quoteIdsToQueryAgain size ' + quoteIdsToQueryAgain.size());

        //Step 5: Query quote line again based on quote ids. then check if there is non-salesforce CPQ product in quote, add the quote to filteredOut list.
        List<Quote_Product_Report__c> quoteLinesRequery;
        List<List<Quote_Product_Report__c>> quoteLinesRequeryList = new List<List<Quote_Product_Report__c>>();
        if (quoteIdsToQueryAgain.size() > 0)
        {
            //Where clause limit is 4000, query ids in "in" clause might be longer than 400, so split into smaller chunks.
            List<List<id>> quoteIdsToQueryAgainInChunks = SplitIntoChunksID(quoteIdsToQueryAgain,integer.valueof(label.Tensor_Quote_Interface_ID_Chunk_Size)); 
                                                         
            system.debug('quoteIdsToQueryAgainInChunks is ' + quoteIdsToQueryAgainInChunks.size());

            quoteIdsToQueryAgain.clear();

            for (list<ID> chunck : quoteIdsToQueryAgainInChunks)
            {
                //For each smaller chuncks, run the query with "in" clause
                quoteLinesRequery = new List<Quote_Product_Report__c>([select id, Sterling_Quote__r.id,  
                Product_Material__r.name from Quote_Product_Report__c where Sterling_Quote__r.id in: chunck]); 

                quoteLinesRequeryList.add(quoteLinesRequery);
            }
        }

         system.debug('quoteLinesRequeryList size ' + quoteLinesRequeryList.size());

        set<id> filterOutQuoteId = new set<id>();
        if (quoteLinesRequeryList.size() > 0)
        {
            for (List<Quote_Product_Report__c> quoteReportList : quoteLinesRequeryList)
            {
                for (Quote_Product_Report__c q : quoteReportList)
                {
                    boolean isSalesforceCPQProduct = false;
                    for (Product2 p : sfCPQProdList)
                    {
                        if (p.productCode == q.Product_Material__r.name)
                        {
                            isSalesforceCPQProduct = true;
                            break;
                        }
                    }

                    if (!isSalesforceCPQProduct)
                    {
                        filterOutQuoteId.add(q.Sterling_Quote__r.id);
                    }
                }
            }
        }

        system.debug('filterOutQuoteId size ' + filterOutQuoteId.size());

        //Step 6: based on filter out list, and Support Parter, come up with the final list and return.
        SterlingQuotes = new List<SterlingQuote>();
        //Loop through map, and set the attribute: support global seat count, support partner.
        for (id quoteId: quoteMap.keySet())
        {
            boolean inFilterOutList = false;
            if (filterOutQuoteId.size() > 0)
            {
                for(id qId : filterOutQuoteId)
                {
                    if (qId == quoteId)
                    {
                        inFilterOutList = true;
                        break;
                    }
                }
            }

            if (!inFilterOutList)
            {
                SterlingQuote currentQuote = quoteMap.get(quoteId);

                List<SterlingQuoteLine> itemsIncurrentQuote = quotesWithItemsMap.get(quoteid);

                boolean includesPartnerProduct = false;
                for (SterlingQuoteLine q : itemsIncurrentQuote)
                {
                    if (q.SupportPartner == true)
                    {
                        includesPartnerProduct = true;
                        break;
                    }
                }

                if (includesPartnerProduct)
                {
                    if (quote.TransactionType == 'Direct' || quote.TransactionType == '1 Tier') 
                    {
                        SterlingQuotes.add(currentQuote);
                    }
                }
                else 
                {
                    if (quote.TransactionType == 'Direct')
                    {
                        SterlingQuotes.add(currentQuote);
                    }
                }
            }
        }

        sterlingQuotesTotal = SterlingQuotes.size();

        system.debug('final SterlingQuotes ' + SterlingQuotes.size());

    }

    public static List<List<string>> SplitIntoChunks(List<string> originalList, integer chunkSize)
    {
        List<List<string>> chunks = new List<List<string>>();

         for(Integer i = 0 ; i < (originalList.size() / chunkSize)+1 ; i++){
            List<string> chunk = new List<string>();
            for(Integer j=(i*chunkSize);(j<(i*chunkSize)+chunkSize) && j<originalList.size() ; j++){
                chunk.add(originalList.get(j));
            }
            chunks.add(chunk);
        }

        return chunks;
    }

    public static List<List<Id>> SplitIntoChunksID(List<Id> originalList, integer chunkSize)
    {
        List<List<Id>> chunks = new List<List<Id>>();

         for(Integer i = 0 ; i < (originalList.size() / chunkSize)+1 ; i++){
            List<Id> chunk = new List<Id>();
            for(Integer j=(i*chunkSize);(j<(i*chunkSize)+chunkSize) && j<originalList.size() ; j++){
                chunk.add(originalList.get(j));
            }
            chunks.add(chunk);
        }

        return chunks;
    }

    private class SterlingQuote {
    
        public ID QuoteId {get; set;}
        public ID OpportunityId {get; set;}
        public string QuoteNumber {get; set;}
        public string QuoteName {get;set;}
        public string TransactionType {get; set;}
    }
    
    private class SterlingQuoteLine {
    
        public ID QuoteLineId {get; set;}
        public ID QuoteId {get; set;}
        public string ProductMaterialName {get; set;}
        public boolean SupportPartner {get; set;}
        public boolean SupportGlobalSeatCount {get; set;}
    }
}