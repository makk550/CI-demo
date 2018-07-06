trigger PartnerResourceValidationTrigger on Partner_Resource_Validation__c (before insert,before update) {
    
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            for(Partner_Resource_Validation__c pResValidation: Trigger.New){
                PartnerResourceValidationController.populateLDAPID(pResValidation);
            }
        }
        
        if(Trigger.isUpdate){
            for(Partner_Resource_Validation__c pResValidation: Trigger.New){
                if(Trigger.oldmap.get(pResValidation.Id).Partner_Resource__c != Trigger.newmap.get(pResValidation.Id).Partner_Resource__c){
                    PartnerResourceValidationController.populateLDAPID(pResValidation);
                }                
            }
        }
        
    }
    
}