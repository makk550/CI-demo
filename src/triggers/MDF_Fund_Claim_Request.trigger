/**
*Description :Trigger to populate the approvers on Fund Claim.
*Trigger will populate Approvers List on request objet
*populate Partner Email address on claim
*Call method from MDF_Utils
*Client: CA technologies
*Developed By Balasaheb Wani Oct 27,2010
*Last Updated On Oct 27,2010
*/

trigger MDF_Fund_Claim_Request on SFDC_MDF_Claim__c (before insert) 
{
    if(Trigger.IsBefore && Trigger.IsInsert){
    //amount should not exceed Fund request amount - amili01
    MDF_Utils.ValidateClaimAmt_Insert(Trigger.New);
    }
    
	List<SFDC_MDF_Claim__c> lstClaims=Trigger.New;
	MDF_Utils.PopulateApproversOnFundClaim(lstClaims);
}