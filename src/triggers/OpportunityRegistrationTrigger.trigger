trigger OpportunityRegistrationTrigger on Opportunity_Registration__c (after delete, after insert, after update, 
before delete, before insert, before update) {
    
    TriggerFactory.createHandler(Opportunity_Registration__c.sobjectType);

}