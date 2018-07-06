trigger CA_SterlingQuoteTrigger on scpq__SciQuote__c (after insert,after update) {
if(userinfo.getuserid()=='00530000003rQuJAAU') return;
    if(trigger.isAfter){
        if(Trigger.isInsert) {
            
        }
        
        if(Trigger.isUpdate) {
            CA_SterlingQuoteTriggerHandler.updateQuoteDataonAgreement(Trigger.newMap, Trigger.oldMap);
        }
    }
}