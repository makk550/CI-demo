trigger RelatedAgreementTrigger on Apttus__APTS_Related_Agreement__c (after insert) {

    RelatedAgreementTriggerHandler.updateParentAgreement(Trigger.new);
}