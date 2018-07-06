/* To grant read/write access to the approvers during the Deal Reg approval process.
   Total # of SOQL  0
   DML= 1
   Last Update on 12/14/2010 (Accenture)
 */
public class DealReg_GrantSharingToApprovers {
    
    List<LeadShare> listOfDealShare =new List<LeadShare>();
    LeadShare dealShare = new LeadShare();
    
    //methof to be called by trigger on Lead to grant edit access to Deal Reg approvers
    public void giveAccessToDealApprovers(List<Lead> dealList){
        
        for(Lead thisDeal: dealList){
                dealShare.LeadAccessLevel='Edit';
                dealShare.LeadId=thisDeal.Id;
            if(thisDeal.Deal_Registration_Approval_Status__c=='Submitted')
                dealShare.UserOrGroupId=thisDeal.First_Approver__c;
                
            if(thisDeal.Deal_Registration_Approval_Status__c=='First Approval'){
                if(thisDeal.Second_Approver__c!=null)
                    dealShare.UserOrGroupId=thisDeal.Second_Approver__c;
            } 
            if(thisDeal.Deal_Registration_Approval_Status__c=='Second Approval'){
                if(thisDeal.Third_Approver__c!=null)
                    dealShare.UserOrGroupId=thisDeal.Third_Approver__c;
            }
            if(dealShare.UserOrGroupId!=null) 
                listOfDealShare.add(dealShare);
            System.debug('--------- dealshare'+ dealShare);    
            System.debug('--------- Class List1'+ listOfDealShare);
        }
        System.debug('------------'+listOfDealShare);        
        if(listOfDealShare.size()>0)
            insert listOfDealShare;
    }
    
    @isTest(SeeAllData=true)
    public static void DealReg_GrantSharingToApprovers_test() {
    	List<User> user = [Select Id from User where isActive = true and UserType = 'Standard' LIMIT 3];
    	List<Lead> leadList = new List<Lead>();
    	Lead newLead1 = new Lead(LastName='test1', Company='CA',Deal_Registration_Approval_Status__c = 'Submitted');
    	Lead newLead2 = new Lead(LastName='test2', Company='CA',Deal_Registration_Approval_Status__c = 'First Approval');
    	Lead newLead3 = new Lead(LastName='test3', Company='CA',Deal_Registration_Approval_Status__c = 'Second Approval');
    	leadList.add(newLead1);
    	leadList.add(newLead2);
    	leadList.add(newLead3);
    	insert leadList;
    	DealReg_GrantSharingToApprovers classObj = new DealReg_GrantSharingToApprovers();
    	classObj.giveAccessToDealApprovers(leadList);
    }
    
}