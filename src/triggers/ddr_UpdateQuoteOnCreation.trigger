trigger ddr_UpdateQuoteOnCreation on Deal_Desk_Review__c (after insert)
{
    List<scpq__SciQuote__c> quoteList = new List<scpq__SciQuote__c>();
    
    for(Deal_Desk_Review__c ddr : Trigger.new)
    {
        if(ddr.Sterling_Quote__c != null && ddr.Deal_Desk_Status__c != 'Request Review -- DD')
        {
            scpq__SciQuote__c quote = new scpq__SciQuote__c(Id=ddr.Sterling_Quote__c);
            quote.CA_DDR_Name__c = ddr.Name;
            quote.Oubound_Status__c = 'Deal Desk';
            
            quoteList.add(quote);
        }
    }
    
    update quoteList;
}