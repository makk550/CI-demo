//trigger to enforce Rejection Reason required during approval process for MDF Request.

trigger MDF_Request_beforeUpdate on SFDC_MDF__c (before update) {
    
    if(Trigger.isBefore && Trigger.Isupdate){ 
      MDF_RejectionReasonMandatoryOnRequest ClassVar= new MDF_RejectionReasonMandatoryOnRequest();
     // ClassVar.validateRejectionReason(Trigger.old,Trigger.new);   
        
    //US498557 : Fund request - validations - amili01
    ClassVar.validationMDFId_PoID(Trigger.newMap,Trigger.oldMap);
    
    // US505382: Currency conversion and validations - amili01
    ClassVar.BfUpdate_CurrVal(Trigger.newMap,Trigger.oldMap);
    }
    

}