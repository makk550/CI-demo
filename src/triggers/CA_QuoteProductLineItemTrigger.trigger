trigger CA_QuoteProductLineItemTrigger on Quote_Product_Report__c(before insert, after insert, before update, after update, before delete, after delete) {
   
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        
        }
        if (Trigger.isDelete) {
        
        }
    }

    if (Trigger.IsAfter) {
        if (Trigger.isInsert) {        
         CA_QuoteProductLineItemTriggerHandler.createAgreementLineItems(Trigger.new);   
        } 
        if (Trigger.isUpdate) {
         //CA_QuoteProductLineItemTriggerHandler.updateAgreementLineItems(Trigger.new);
        }
        if (Trigger.isDelete) {
        CA_QuoteProductLineItemTriggerHandler.deleteAgreementLineItems(Trigger.old);
        }
    }
}