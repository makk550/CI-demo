trigger CA_SteelBrickQuoteTrigger on SBQQ__Quote__c (after insert,after update) {
    if(userinfo.getuserid()=='00530000003rQuJAAU') return;
    if(trigger.isAfter){
        if(Trigger.isInsert) {
            
        }
        
        if(Trigger.isUpdate) {
            CA_SteelBrickQuoteTriggerHandler.updateQuoteDataonAgreement(Trigger.newMap, Trigger.oldMap);
        }
    }

}