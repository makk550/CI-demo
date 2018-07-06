trigger updatePDDEnhanced on PDD_Instance_Enhanced__c (after insert, after update, after delete) {    
      TriggerFactory.createHandler(PDD_Instance_Enhanced__c.sObjectType);
}