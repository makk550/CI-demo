/*
* Test Class = masterTrackerTestClass
* Updated by - BAJPI01
* Coverage = 100%
*/ 
trigger masterTrackerTrigger on MasterTracker__c (before insert, before update, before delete, after insert,after update,after delete) {
    
    TriggerFactory.createHandler(MasterTracker__c.sObjectType);
    
}