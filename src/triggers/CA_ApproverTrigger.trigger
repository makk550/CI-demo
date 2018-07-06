trigger CA_ApproverTrigger on Approver__c (before insert, after insert, before update, after update, before delete, after delete) {
   
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        
        }
        if (Trigger.isDelete) {
            CA_ApproverTriggerHandler.updateApproversonAgreement(Trigger.old);
        }
    }

    if (Trigger.IsAfter) {
        if (Trigger.isInsert) { 
            CA_ApproverTriggerHandler apphandler = new CA_ApproverTriggerHandler();
            apphandler.setApprovers(Trigger.new);     
        } 
        if (Trigger.isUpdate) {
            CA_ApproverTriggerHandler apphandler = new CA_ApproverTriggerHandler();
            apphandler.setApprovers(Trigger.new);    
        }
        if (Trigger.isDelete) {
        // Call class logic here!
        }
    }
    

}