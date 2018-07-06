trigger CA_SBPaymentPlanTrigger on Payment_Plan__c (before insert, after insert, before update, after update, before delete, after delete) {
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
            CA_SBQPaymentPlanTriggerHandler.createAgrPaymentPlan(Trigger.new);
        }
        if (Trigger.isUpdate) {
            if(CA_SBQPaymentPlanTriggerHandler.runOnce())
            CA_SBQPaymentPlanTriggerHandler.deleteAgreementPaymentPlans(Trigger.new);
           // CA_PaymentPlanTriggerHandler.updateAgreementPaymentPlans(Trigger.new);
          // CA_SBQPaymentPlanTriggerHandler.updateAgreementLineItems(Trigger.new);
        }
        if (Trigger.isDelete) {
            CA_SBQPaymentPlanTriggerHandler.deleteAgreementPaymentPlans(Trigger.old);
        }
    }

}