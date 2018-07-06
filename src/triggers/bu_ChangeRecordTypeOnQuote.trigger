trigger bu_ChangeRecordTypeOnQuote on Quote (before update) {

try{
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Approved Quote');
    Id quoteRecordTypeID = rec.RecordType_Id__c;
    
    RecordTypes_Setting__c rec1 = RecordTypes_Setting__c.getValues('Quote Master Record Type');
    Id quoteRecordTypeID1 = rec1.RecordType_Id__c;
    
    for(Id tempId : Trigger.newMap.keySet()) {
        
        if((Trigger.oldMap.get(tempId).Approval_Status__c == 'Approved') || (Trigger.oldMap.get(tempId).status == 'Approved')) {
            Trigger.newMap.get(tempId).status = 'Modified';
            Trigger.newMap.get(tempId).Approval_Status__c = 'Modified';
            
        }        
        
         if((Trigger.oldMap.get(tempId).status != Trigger.newMap.get(tempId).status) && 
            Trigger.newMap.get(tempId).status != 'Approved'){
                Trigger.newMap.get(tempId).RecordTypeId = null;
            }
        
    }
    
  }
  
  catch(Exception e){
   System.debug('Exception:::::'+e);  
  } 
}