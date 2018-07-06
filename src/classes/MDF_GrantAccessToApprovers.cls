/* To grant read/write access to the approvers during the MDF Request approval process.
   Total # of SOQL  0
   DML= 1
   Last Update on 12/14/2010 (Accenture)
*/

public class MDF_GrantAccessToApprovers {

    //Declaring variable for Fund Request
    List<SFDC_MDF__Share> listOfFundRequestShare =new List<SFDC_MDF__Share>();
    SFDC_MDF__Share RequestShare = new SFDC_MDF__Share();
    
    //method to be called by trigger on MDF Request to grant edit access to MDF Request approvers
    public void giveAccessToMDFRequestApprovers(List<SFDC_MDF__c> fundRequestList){
        
        for(SFDC_MDF__c thisMDFRequest: fundRequestList){
                RequestShare.AccessLevel='Edit';
                RequestShare.ParentId=thisMDFRequest.Id;
            if(thisMDFRequest.MDF_Request_Approval_Status__c=='Submitted')
                RequestShare.UserOrGroupId=thisMDFRequest.Approver_1__c;
            if(thisMDFRequest.MDF_Request_Approval_Status__c=='First Approval'){
                if(thisMDFRequest.Approver_2__c!=null){ RequestShare.UserOrGroupId=thisMDFRequest.Approver_2__c;}
                   
            } 
            if(thisMDFRequest.MDF_Request_Approval_Status__c=='Second Approval'){
                if(thisMDFRequest.Approver_3__c!=null){RequestShare.UserOrGroupId=thisMDFRequest.Approver_3__c;}
                    
            }
            if(RequestShare.UserOrGroupId!=null){listOfFundRequestShare.add(RequestShare);}
                
            
        }
        System.debug('------------'+listOfFundRequestShare );
        if(listOfFundRequestShare!=null && listOfFundRequestShare.size()>0)
            Database.insert(listOfFundRequestShare,false) ;
    }
    
    //method to be called by trigger on MDF Claim to grant edit access to MDF Claim approvers
    public void giveAccessToMDFClaimApprovers(List<SFDC_MDF_Claim__c> fundClaimList){
        
        for(SFDC_MDF_Claim__c thisMDFClaim: fundClaimList){
                RequestShare.AccessLevel='Edit';
                RequestShare.ParentId=thisMDFClaim.Fund_Request__c;
            if(thisMDFClaim.MDF_Claim_Approval_Status__c=='Submitted')
                RequestShare.UserOrGroupId=thisMDFClaim.Approver_1__c;
            if(thisMDFClaim.MDF_Claim_Approval_Status__c=='First Approval'){
                if(thisMDFClaim.Approver_2__c!=null)
                    RequestShare.UserOrGroupId=thisMDFClaim.Approver_2__c;
            } 
            if(thisMDFClaim.MDF_Claim_Approval_Status__c=='Second Approval'){
                if(thisMDFClaim.Approver_3__c!=null)
                    RequestShare.UserOrGroupId=thisMDFClaim.Approver_3__c;
            } 
            if(RequestShare.UserOrGroupId!=null)
                listOfFundRequestShare.add(RequestShare);
            
        }
        System.debug('------------'+listOfFundRequestShare );
        if(listOfFundRequestShare!=null && listOfFundRequestShare.size()>0)
            Database.insert(listOfFundRequestShare,false) ;
    }
}