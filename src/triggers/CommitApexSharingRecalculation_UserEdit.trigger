trigger CommitApexSharingRecalculation_UserEdit on Commit_Org_User__c (after insert , after update , after delete) 
{
  if(trigger.IsDelete)
  {
        //Delete all records from respective sharing object for this User
        List<Id> userIds = new List<Id>();
        List<Id> commitOrgIdList = new List<Id>();
        for(Commit_Org_User__c commitUser: trigger.old)
        {
            userIds.add(commitUser.User__c);
            commitOrgIdList.add(commitUser.Commit_Org__c);
        }
        CommitApexSharingHelper.removeUserFromGroup(commitOrgIdList,userIds);
  }
  if(trigger.IsInsert)
  {
      List<Id> commitOrgIdList = new List<Id>();
      List<Id> commitOrgUserIdList = new List<Id>();
      for(Commit_Org_User__c commitUser: trigger.new)
        {
            commitOrgIdList.add(commitUser.Commit_Org__c);
            commitOrgUserIdList.add(commitUser.User__c);
        }
        CommitApexSharingHelper.addUsertoGroup(commitOrgIdList , commitOrgUserIdList);
  }
  Boolean updateFlag = false ;
  if(trigger.IsUpdate)
  {
       List<Id> userIdsOld = new List<Id>();
       List<Id> commitOrgIdListOld = new List<Id>();
       List<Id> commitOrgIdList = new List<Id>();
       List<Id> commitOrgUserIdList = new List<Id>();
      for(Integer i = 0 ; i < trigger.new.size() ; i++ )
        {
            if(trigger.new[i].Id == trigger.old[i].Id)
            {
                if((trigger.new[i].User__c != trigger.old[i].User__c) || (trigger.new[i].Commit_Org__c != trigger.old[i].Commit_Org__c))
                {
                    userIdsOld.add(trigger.old[i].User__c);
                    commitOrgIdListOld.add(trigger.old[i].Commit_Org__c);
                
                    commitOrgIdList.add(trigger.new[i].Commit_Org__c);
                    commitOrgUserIdList.add(trigger.new[i].User__c);
                }
            }
        }
       CommitApexSharingHelper.removeUserFromGroup(commitOrgIdListOld , userIdsOld);
       CommitApexSharingHelper.addUsertoGroup(commitOrgIdList , commitOrgUserIdList);
  }
}