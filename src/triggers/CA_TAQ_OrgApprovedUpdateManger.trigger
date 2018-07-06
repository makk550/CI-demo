/**
* Description  : This trigger will invoke before insert and before update of TAQ Organization Approved 
* It will retrive Its Managers Details (Managers Position Id and Managers Role and update this information in TAQ)
* Also will update all corresponding subordinates records with above data
*              
* Author       : Balasaheb Wani, Heena Bhatnagar
* Company      : Accenture IDC
* Client       : Computer Associates
* Last Update  : Sept, 2010
*/
trigger CA_TAQ_OrgApprovedUpdateManger on TAQ_Organization_Approved__c (before update,before insert)
{
    //Added by Saba FY12
    if(FutureProcessor_TAQ.skiptriggers || SystemIdUtility.skipTAQ_OrganizationApproved) //This trigger is being called from future method for subordinate manager info updation - FutureProcessor_TAQ.UpdateSubordinate
        return;        
    
    if(SystemIdUtility.skipTAQOrgApproved)
        return;    
    //if(SystemIdUtility.isneeded==true)//---****---TO SKIP THIS TRIGGER WHEN TRYING TO UPDATE SUBORDINATE'S RECORDS IF THEIR RESPECTIVE MANAGER IS TERMINATED OR  HIRED
        //return; 

   List<TAQ_Organization_Approved__c> lstNewOrgApproved=Trigger.new;
   List<TAQ_Organization_Approved__c> lstOldOrgApproved=Trigger.old;
   List<TAQ_Organization_Approved__c> lstForUpdate=new List<TAQ_Organization_Approved__c>();
   for(integer i=0; i < lstNewOrgApproved.size();i++)
   {
   // added a static variable check for keeping count of future method calls in same transaction - Heena sept-29
    if(Trigger.isInsert && TAQOrgAdmin.inFutureContext!=true)
    {
    lstForUpdate.add(lstNewOrgApproved[i]);    
    }
    // added a static variable check for keeping count of future method calls in same transaction - Heena sept-29
    else if (Trigger.isUpdate && TAQOrgAdmin.inFutureContext!=true)
    {
    if(CA_TAQ_OrgApproved_UpdateManager.IsRecordEligibleToUpdate(lstNewOrgApproved[i].Manager_Updated_on__c))
    lstForUpdate.add(lstNewOrgApproved[i]);
    }
   }

   if(lstForUpdate.Size() > 0)
   {
    CA_TAQ_OrgApproved_UpdateManager.UpdateManagerInfo(lstForUpdate);
   }
}