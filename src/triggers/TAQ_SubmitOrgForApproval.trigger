trigger TAQ_SubmitOrgForApproval on TAQ_Org_Quota__c (before insert, before update, before delete, after insert, after update, after delete) {
  
   if(SystemIdUtility.skipTAQ_OrgQuota) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
  
   if(CA_TAQ_Account_Approval_Class.EXECUTED_ORGQUOTA_COUNT > 3)
     return;
  
  if(Trigger.isBefore)
  {
  
  if(TAQ_SubmitOrgApprovalClass.isExecuted ==false)
  {
  
  // FY13 1.1 - SUBMIT TAQ ORG RECORDS FOR APPROVAL WHEN TAQ ORG QUOTA IS MODIFED.-START
   List<TAQ_Org_Quota__c> taqOrgIds = new List<TAQ_Org_Quota__c>();
   List<Id> savedNotApprovedIds = new List<Id>();
   
   if(trigger.isDelete){
     for(TAQ_Org_Quota__c toq: trigger.old)
     {
        if(toq.Submit_for_approval__c == true)
        {
          taqOrgIds.add(toq);
        }
        else
        {
            savedNotApprovedIds.add(toq.TAQ_Organization__c);
        }
     }
    }else{
      for(TAQ_Org_Quota__c toq: trigger.new)
         {
            if(toq.Submit_for_approval__c == true)
            {
              taqOrgIds.add(toq);
            }
            else
            {
                savedNotApprovedIds.add(toq.TAQ_Organization__c);
            }
         }
    } 
   if(taqOrgIds.size()>0){
     TAQ_SubmitOrgApprovalClass submitObj = new TAQ_SubmitOrgApprovalClass();
     submitObj.submitforApproval(taqorgIds);
   }
   if(savedNotApprovedIds.size() > 0)
   {
       List<TAQ_Organization__c> orgRecs;
       orgRecs = [SELECT Id, Approval_Status__c, CBU__c from TAQ_Organization__c where Id in: savedNotApprovedIds]; 
       for(TAQ_Organization__c taqOrg1 : orgRecs)
       {
           taqOrg1.Approval_Status__c = 'Saved - Not Approved';
           TAQ_SubmitOrgApprovalClass.allOrgRecs.add(taqOrg1);
       }
   }
  }
   
   if(!trigger.isDelete){
     for(TAQ_Org_Quota__c toq: trigger.new)
     {
        if(!toq.Submit_for_Approval__c)
          toq.Submit_for_Approval__c = true;
     } 
  }
}
else if(Trigger.isAfter)
{


  //chajo30 changes for US303520 FY18

  //retreive all taq organizations that have had quotas modified
  Set<Id> orgsIds = new Set<Id>();
  if(Trigger.isDelete){
    for(TAQ_Org_Quota__c toq: trigger.old){
      orgsIds.add(toq.TAQ_Organization__c);
    }
  }else{
    for(TAQ_Org_Quota__c toq: trigger.new){
        orgsIds.add(toq.TAQ_Organization__c);
    }
  }  
 
  List<TAQ_Org_Quota__c> quotaList = new List<TAQ_Org_Quota__c>([SELECT Id, CBU__c, TAQ_Organization__c FROM TAQ_Org_Quota__c WHERE TAQ_Organization__c IN: orgsIds]);

  //add all quotas to there corresponding taq org
  Map<Id,List<TAQ_Org_Quota__c>> quotasByOrgMap = new Map<Id,List<TAQ_Org_Quota__c>>();
  for(TAQ_Org_Quota__c q: quotaList){
    if(quotasByOrgMap.containsKey(q.TAQ_Organization__c)){
      quotasByOrgMap.get(q.TAQ_Organization__c).add(q);
    }else{
      quotasByOrgMap.put(q.TAQ_Organization__c, new List<TAQ_Org_Quota__c>());
      quotasByOrgMap.get(q.TAQ_Organization__c).add(q);
    }     
  }

  //For each organization retreive all quotas 
  for(TAQ_Organization__c org: TAQ_SubmitOrgApprovalClass.allOrgRecs){
    Set<String> cbuValuesSet = new Set<String>();
    List<TAQ_Org_Quota__c> retreivedQuotas = new List<TAQ_Org_Quota__c>(quotasByOrgMap.get(org.Id));

    //loop through every quota for an org and add the multi select CBU values to string array
    for(TAQ_Org_Quota__c q: retreivedQuotas){

      String[] cbuValues;
      if(q.CBU__c != null){
        cbuValues = q.CBU__c.split(';');
      }

      //loop through cbu values array and add the values to CBU set 
      if(cbuValues != null){
        for(String cbu: cbuValues){
          cbuValuesSet.add(cbu);
        }
      }
    }

    //add the CBU values set into a list and then convert the list to a comma seperated string 
    List<String> cbuValuesList = new List<String>(cbuValuesSet);
    String cbuString = String.join(cbuValuesList, ', ');
    org.CBU__c = cbuString;
  }

  //update the orgs 
  database.update(TAQ_SubmitOrgApprovalClass.allOrgRecs, false);

  //end changes
  
}


 // TO BYPASS SAVED - NOT APPROVED ON TAQ ORG RECORD.
   if(trigger.isInsert){
      for(TAQ_Org_Quota__c eachQuota: trigger.new){
        if(eachQuota.TAQ_Organization__c != null && 
        !CA_TAQ_Account_Approval_Class.SELECTED_STATUS.containsKey(eachQuota.TAQ_Organization__c)){
               CA_TAQ_Account_Approval_Class.SELECTED_STATUS.put(eachQuota.TAQ_Organization__c,'FROM ORG QUOTA');
        }
      }
   }
      


  CA_TAQ_Account_Approval_Class.EXECUTED_ORGQUOTA_COUNT++;  
  // FY13 1.1 - SUBMIT TAQ ORG RECORDS FOR APPROVAL WHEN TAQ ORG QUOTA IS MODIFED.-END   
}