/* Test Classes : ProductAreaHelper_Test ; CC_AWSMock; */
trigger ProductAreaTrigger on Product_Area__c (after insert, after update, after delete) {
    
     if(Label.SkipProductAreaTrigger == 'true')
       return;
    
    if(Trigger.isInsert){
        ProductAreaHelper.pushPAChangestoDB(Trigger.newMap.keySet(), 'update');   
    }
    
    if(Trigger.isUpdate){        
        Set<Id> updatedRecordsIdSet = new Set<Id>();
        for(Product_Area__c t : Trigger.New){
            if( Trigger.oldMap.get(t.Id).Name != t.Name || Trigger.oldMap.get(t.Id).CA_Product__c != t.CA_Product__c ){
                updatedRecordsIdSet.add(t.Id);
            }
        }
        if(updatedRecordsIdSet != null && updatedRecordsIdSet.size() > 0){
            ProductAreaHelper.pushPAChangestoDB(updatedRecordsIdSet, 'update');
        }
    }  
    
    if(Trigger.isDelete) {
        ProductAreaHelper.pushPAChangestoDB(Trigger.oldMap.keySet(), 'del');  
    }
    
}