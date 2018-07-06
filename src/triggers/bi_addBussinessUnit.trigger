trigger bi_addBussinessUnit on QuoteLineItem (before insert) {
    
    List<QuoteLineItem> qList = Trigger.new;
    List<Id> pricebookentryIdList = new List<Id>();
    Map<Id,String> priceBook_businessUnit_Map = new Map<Id,String>(); 
    for(QuoteLineItem temp : Trigger.new) {
        if(temp.PricebookEntryId != null)
            pricebookentryIdList.add(temp.PricebookEntryId);
    }
    
    List<PricebookEntry> pricebooksList = [Select p.Product2.Product_Group__c, p.Id From PricebookEntry p where p.Id IN :pricebookentryIdList];
    for(PricebookEntry temp : pricebooksList) {
        priceBook_businessUnit_Map.put(temp.Id, temp.Product2.Product_Group__c);
    }
    for(QuoteLineItem temp : Trigger.new) {
        if(temp.PricebookEntryId != null)
            temp.Business_Unit__c = priceBook_businessUnit_Map.get(temp.PricebookEntryId); 
       
        if( temp.Is_Co_Term_LineItem__c == false){
            temp.MSRP_Unit_Cost__c = temp.UnitPrice;
            temp.MSRP_total__c = temp.UnitPrice * temp.Quantity;
        }
    }
 
}