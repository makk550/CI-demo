trigger CA_FundClaimTrigger on SFDC_MDF_Claim__c (before update) {
    //TriggerFactory.createHandler(SFDC_MDF_Claim__c.sObjectType);
    
    if(Trigger.isbefore && Trigger.IsUpdate){
    //amount should not exceed Fund request amount - fund claim validation - amili01
    //Rejection reason validation and CA Reimbursement CA_Reimbursement__c validation are present in 
     MDF_Utils.ValidateClaimAmt_Update(Trigger.New,Trigger.oldMap);
    }
    
}