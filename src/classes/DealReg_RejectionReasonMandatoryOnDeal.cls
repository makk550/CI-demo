/* Class to validate the criterias for Deal Reg Approval.
	#of SOQL=0
	Checks for
		1. Rejection Reason
		2. Other Rejection Reason
		3. Deal Program
		4. Reseller
		5. Ent/Comm Account
*Client: CA Technologies
*Developed By:  Accenture
*/
public with sharing class DealReg_RejectionReasonMandatoryOnDeal {
    Lead oldLead=new Lead();
    Lead newLead=new Lead();
    //Check for validations on Deal.
    public void validateRejectionReason(List<Lead> oldLeadList,List<Lead> newLeadList){
        for(Integer i=0;i<newLeadList.size();i++){
            oldLead = oldLeadList[i];
            newLead = newLeadList[i];
            
        /*  if(OldCampaign.Status!='Rejected' && NewCampaign.Status=='Rejected'){
                if(NewCampaign.Rejection_Reason__c=='--None--' || NewCampaign.Rejection_Reason__c == null)
                    NewCampaign.addError('Rejection Reason can not be blank, when Approval Status is Rejected');
                else if(NewCampaign.Rejection_Reason__c == 'Other' && (NewCampaign.Other_Rejected_Reason__c =='' || NewCampaign.Other_Rejected_Reason__c == null))
                    NewCampaign.addError('Rejection Reason can not be blank, when Approval Status is Rejected');
            }*/
            if(newLead.Deal_Registration_Status__c=='Deal Rejected' && (newLead.Rejection_Reason__c=='--None--' || newLead.Rejection_Reason__c == null))
                newLead.Rejection_Reason__c.addError('Rejection Reason can not be blank, when Approval Status is Rejected');
            else if(newLead.Deal_Registration_Status__c == 'Deal Rejected' && newLead.Rejection_Reason__c == 'Other' && (newLead.Other_Rejection_Reason__c =='' || newLead.Other_Rejection_Reason__c == null))
                newLead.Other_Rejection_Reason__c.addError('Please specify the Other Rejection Reason');
            if(newLead.Deal_Registration_Status__c == 'Sale Approved' && (newLead.Deal_Program__c =='' || newLead.Deal_Program__c == null))
				newLead.Deal_Program__c.addError('Please Specify The Deal Program Before Final Approval');
			if(newLead.Deal_Registration_Status__c == 'Sale Approved' && (newLead.Reseller__c == null))
				newLead.Reseller__c.addError('Please Add a Reseller Before Final Approval');
			if(newLead.Deal_Registration_Status__c == 'Sale Approved' && (newLead.Commercial_Account__c == null))
				newLead.Commercial_Account__c.addError('Please Add a Enterprise/Commercial Account before final approval');
        }
    }
    @isTest(SeeAllData=true)
    public static void DealReg_RejectionReasonMandatoryOnDeal_test() {
    	Lead newLead1 = new Lead(Deal_Registration_Status__c = 'Deal Rejected',Rejection_Reason__c = '--None--');
    	Lead newLead2 = new Lead(Deal_Registration_Status__c = 'Deal Rejected',Rejection_Reason__c = 'Other');
    	Lead newLead3 = new Lead(Deal_Registration_Status__c = 'Sale Approved',Deal_Program__c = '');
    	Lead newLead4 = new Lead(Deal_Registration_Status__c = 'Sale Approved',Reseller__c = null);
    	Lead newLead5 = new Lead(Deal_Registration_Status__c = 'Sale Approved',Commercial_Account__c = null);
    	List<Lead> newLeadList = new List<Lead>();
    	List<Lead> oldLeadList = new List<Lead>();
    	newLeadList.add(newLead1);
    	newLeadList.add(newLead2);
    	newLeadList.add(newLead3);
    	newLeadList.add(newLead4);
    	newLeadList.add(newLead5);
    	oldLeadList.add(newLead1);
    	oldLeadList.add(newLead2);
    	oldLeadList.add(newLead3);
    	oldLeadList.add(newLead4);
    	oldLeadList.add(newLead5);
    	DealReg_RejectionReasonMandatoryOnDeal obj = new DealReg_RejectionReasonMandatoryOnDeal();
    	obj.validateRejectionReason(oldLeadList,newLeadList);
    }
}