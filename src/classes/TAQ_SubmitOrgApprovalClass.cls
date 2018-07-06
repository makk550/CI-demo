public class TAQ_SubmitOrgApprovalClass 
{
  public static boolean isExecuted = false; 
  public static List<TAQ_Organization__c> orgRecs;
  public static List<TAQ_Organization__c> allOrgRecs = new List<TAQ_Organization__c>();
   
  public void submitforApproval(List<TAQ_Org_Quota__c> orgQuotaIds){
    isExecuted = true;
    try{
     
     List<Id> orgIds = new List<Id>();
     for(TAQ_Org_Quota__c toq:orgQuotaIds){
        orgIds.add(toq.TAQ_Organization__c);
     }
     orgRecs = [SELECT Id,Approval_Process_Status__c, CBU__c from TAQ_Organization__c where Id in: orgIds and Approval_Process_Status__c != 'Send For Approval'];   
     Map<Id,TAQ_Organization__c> statusMap = new Map<Id,TAQ_Organization__c>();
     for(TAQ_Organization__c tOrg:orgRecs)
     {
     System.debug('________1111____dddd____'+tOrg.Id);
      System.debug('________1111____eeee____'+CA_TAQ_Account_Approval_Class.SELECTED_STATUS.containsKey(tOrg.Id));
     //  System.debug('________1111____ffff____'+tOrg.Id);
        //statusMap.put(torg.Id,tOrg);
       // CHECKING CONDITION TO BYPASS STATUS CHANGE FOR ALREADY REJECTED RECORDS.
        if(!CA_TAQ_Account_Approval_Class.SELECTED_STATUS.containsKey(tOrg.Id))
              tOrg.Approval_Process_Status__c = 'Send For Approval';
        else if(CA_TAQ_Account_Approval_Class.SELECTED_STATUS.containsKey(tOrg.Id)   && 
            CA_TAQ_Account_Approval_Class.SELECTED_STATUS.get(tOrg.Id) != 'Rejected')
        tOrg.Approval_Process_Status__c = 'Send For Approval';
        allOrgRecs.add(tOrg);
     }
   //  database.update(orgRecs, false);
     
     /*   List<TAQ_Organization__c> orgs2Update = new List<TAQ_Organization__c>();
        for(TAQ_Org_Quota__c eachQuota: orgQuotaIds)
        {
            try{    
                if(eachQuota.Submit_for_Approval__c == true)
                    if(statusMap.containsKey(eachQuota.TAQ_Organization__c))
                        if(statusMap.get(eachQuota.TAQ_Organization__c).Approval_Process_Status__c != 'Send For Approval')
                            statusMap.get(eachQuota.TAQ_Organization__c).Approval_Process_Status__c = 'Send For Approval';
                
                orgs2Update.add(statusMap.get(eachQuota.TAQ_Organization__c));
              }catch(Exception e){
                  System.debug('___Exception while sending appropriate Org record for approval__'+e.getMessage());
              }
       }
        database.update(orgs2Update, false);
       */ 
    }catch(Exception e){
        System.debug('____Exception while changing approval status on TAQ Org records.'+e.getMessage());
    } 
  }
}