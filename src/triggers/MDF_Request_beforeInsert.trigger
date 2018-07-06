//trigger to populate the approvers on MDF Request.

trigger MDF_Request_beforeInsert on SFDC_MDF__c (before insert) {

    if(Trigger.IsBefore && Trigger.IsInsert){
    //US498557: Before insertion validations - amili01
     MDF_BfInsertValidations valrec=new MDF_BfInsertValidations();
     valrec.Validate_Bfins(trigger.new);
    }
    
      MDF_PopulateApproversForRequest ClassVar=new MDF_PopulateApproversForRequest();
      ClassVar.PopulateApproversOnMDFRequest(Trigger.new);   
    
}