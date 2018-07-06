trigger CA_PaymentPlanTrigger on PaymentPlan__c (before insert, after insert, before update, after update, before delete, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        }
        if (Trigger.isDelete) {
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CA_PaymentPlanTriggerHandler.createAgrPaymentPlan(Trigger.new);
        }
        if (Trigger.isUpdate) {
            //CA_PaymentPlanTriggerHandler.updateAgreementPaymentPlans(Trigger.new);
        }
        if (Trigger.isDelete) {
            CA_PaymentPlanTriggerHandler.deleteAgreementPaymentPlans(Trigger.old);
        }
    }

}