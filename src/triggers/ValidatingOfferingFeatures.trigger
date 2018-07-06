trigger ValidatingOfferingFeatures on Offering_Feature__c (before insert,before update) {
    
    for(Offering_Feature__c aFeatures:Trigger.New){
        Integer totalSize=[SELECT count() FROM Offering_Feature__c WHERE Offering_Business_Rules__c=:aFeatures.Offering_Business_Rules__c
                           AND Case_Severity__c=:aFeatures.Case_Severity__c AND Type__c=:aFeatures.Type__c];
        
        if( Trigger.isBefore && (Trigger.isInsert) ){          
            if( totalSize>0 )
            {
                aFeatures.addError(System.Label.Offering_Feature_Validation);
            }  
        }
        
        if(Trigger.isUpdate){
            if((Trigger.oldMap.get(aFeatures.Id).Case_Severity__c != Trigger.NewMap.get(aFeatures.Id).Case_Severity__c) ||
                (Trigger.oldMap.get(aFeatures.Id).Type__c != Trigger.NewMap.get(aFeatures.Id).Type__c)){
                    //System.debug('In update - sev type block');
                     if( totalSize>0 ){
                        //System.debug('In update - sev type block - totalSize');
                         aFeatures.addError(System.Label.Offering_Feature_Validation);
                     }
            }            
        }      

    }
}