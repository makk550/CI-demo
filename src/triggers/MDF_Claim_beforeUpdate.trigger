//trigger to enforce Rejection Reason required during approval process for MDF Claim.

trigger MDF_Claim_beforeUpdate on SFDC_MDF_Claim__c (before update) {

      MDF_RejectionReasonMandatoryOnClaim ClassVar= new MDF_RejectionReasonMandatoryOnClaim();
      ClassVar.validateRejectionReason(Trigger.old,Trigger.new); 

}