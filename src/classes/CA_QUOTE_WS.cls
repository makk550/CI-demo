@RestResource(urlMapping='/CPQ/')
global class CA_QUOTE_WS
{
    @HttpPost
    global static string upsertDirectRegiQuote(scpq__SciQuote__c sterlingQuote, List<Quote_Product_Report__c> quoteProductLines, List<PaymentPlan__c> paymentPlans)
    {
        String newStatus = '';
        String newSAPStatus = '';
        boolean isUpdate= false;
        if(sterlingQuote != null)
        {
            List<scpq__SciQuote__c> quotes = [Select Id, CA_CPQ_Quote_Status__c, CA_SAP_Status__c from scpq__SciQuote__c where scpq__OrderHeaderKey__c =: sterlingQuote.scpq__OrderHeaderKey__c LIMIT 1];
            if(!quotes.isEmpty())
            {
                isUpdate = true;
                scpq__SciQuote__c retrievedQuote = quotes[0];

                newStatus = sterlingQuote.CA_CPQ_Quote_Status__c;
                newSAPStatus = sterlingQuote.CA_SAP_Status__c;
                
                sterlingQuote.CA_CPQ_Quote_Status__c = retrievedQuote.CA_CPQ_Quote_Status__c;  
                sterlingQuote.CA_SAP_Status__c = retrievedQuote.CA_SAP_Status__c;              
            }

            upsert sterlingQuote scpq__OrderHeaderKey__c;
        }
    
        List<paymentPlan__c> paymentPlansToDelete = [SELECT Id FROM paymentPlan__c WHERE Sterling_Quote__c = :sterlingQuote.Id];
        if(!paymentPlansToDelete.isEmpty())
            delete paymentPlansToDelete;
        if(paymentPlans != null && !paymentPlans.isEmpty())
        {
            for(PaymentPlan__c pp : paymentPlans)
                pp.Sterling_quote__c = sterlingQuote.Id;
        
            insert paymentPlans;
        }
        
        Set<Id> upsertedQuoteProductLineIds = new Set<Id>();
        if(quoteProductLines != null && !quoteProductLines.isEmpty())
        {
            for(Quote_Product_Report__c qpl : quoteProductLines)
                qpl.Sterling_Quote__c = sterlingQuote.Id;
                   
            upsert quoteProductLines Quote_Product_Line_Item_Unique_Key__c;
            
            for(Quote_Product_Report__c qpl : quoteProductLines)
                upsertedQuoteProductLineIds.add(qpl.Id);
        }
        Set<Id> quoteProductLinesToDelete = new Set<Id>();
        
        Map<Id, Quote_Product_Report__c> qplMap = New Map<Id, Quote_Product_Report__c>([SELECT Id FROM Quote_Product_Report__c WHERE Sterling_Quote__c = :sterlingQuote.Id]);
        for(Id qplId : upsertedQuoteProductLineIds)
            qplMap.remove(qplId);
        
        if(!qplMap.isEmpty())
            delete qplMap.values();
        
        if(isUpdate)
        {
            scpq__SciQuote__c myQuote = new scpq__SciQuote__c(Id=sterlingQuote.Id, CA_CPQ_Quote_Status__c=newStatus, CA_SAP_Status__c=newSAPStatus);
            update myQuote;
        }
        
        return 'Success';
    } 
    
    @HttpGet
    global static string getStuff()
    {
        return 'GET: Success!';
    }
}