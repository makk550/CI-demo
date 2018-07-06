/* class to validate the rejection reason during MDF Claim approval process
Created by - Jon Holato
PRM R2 UAT Enhancement to add Rejection Reason to Fund Claim
# of SOQL/DML - 0
*/
public with sharing class MDF_RejectionReasonMandatoryOnClaim {
    SFDC_MDF_Claim__c OldClaim=new SFDC_MDF_Claim__c();
    SFDC_MDF_Claim__c NewClaim=new SFDC_MDF_Claim__c();
    public void validateRejectionReason(List<SFDC_MDF_Claim__c> OldClaimList,List<SFDC_MDF_Claim__c> NewClaimList){
        for(Integer i=0;i<NewClaimList.size();i++){
            OldClaim = OldClaimList[i];
            NewClaim = NewClaimList[i];
            
            //If Status is rejected, the Rejection Reason should be mandatory
            if(NewClaim.Status__c=='Rejected' && (NewClaim.Rejection_Reason__c=='' || NewClaim.Rejection_Reason__c == null))
                NewClaim.Rejection_Reason__c.addError('Rejection Reason can not be blank, when Approval Status is Rejected'); 
        }
    }
}