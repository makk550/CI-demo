/*
 * Test Class = testSbQuoteLineTrigger 
 * Created by = BAJPI01
 * Coverage = 100%
 * 
*/
trigger sbQuoteLineItemTrigger on SBQQ__QuoteLine__c (before insert, before update,After update) {
    
    TriggerFactory.createHandler(SBQQ__QuoteLine__c.sObjectType);

}