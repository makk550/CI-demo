trigger CommitApexSharing on Commit_Revenue__c (after insert , after update) 
    {
        
        if(trigger.isInsert)
        {
            List<Id> commitRevOrgIdList = new List<Id>();
            List<Id> commitRevIdList = new List<Id>();
            
            for(Commit_Revenue__c commitrev :trigger.new)
            {
                System.debug('In Trigger : commitOrg = ' +commitrev.Commit_Org__c);
                commitRevOrgIdList.add(commitrev.Commit_Org__c);
                commitRevIdList.add(commitrev.Id);
            }
            //List<Commit_Org__c> cOrgList = [Select c.Id , c.name ,c.Parent_Org__c, c.Owner_User__c, c.OwnerId From Commit_Org__c c where c.Commit_Org__c in : commitOrgIdList];
            CommitApexSharingHelper.lookParentOrgsUsers(commitRevOrgIdList , commitRevIdList);
        }
        if(trigger.isUpdate)
        {
            List<Id> commitRevOrgIdListOld = new List<Id>();
            List<Id> commitRevIdListOld = new List<Id>();

            List<Id> commitRevOrgIdList = new List<Id>();
            List<Id> commitRevIdList = new List<Id>();

            for(Integer i = 0 ; i < trigger.new.size() ; i++ )
            {
                if(trigger.new[i].Id == trigger.old[i].Id)
                  {
                      if(trigger.new[i].Commit_Org__c != trigger.old[i].Commit_Org__c)
                      { 
                          commitRevOrgIdListOld.add(trigger.old[i].Commit_Org__c);
                          commitRevIdListOld.add(trigger.old[i].Id);
                      
                     
                          commitRevOrgIdList.add(trigger.new[i].Commit_Org__c);
                          commitRevIdList.add(trigger.new[i].Id);   
                      }

                  }
              
            }
            CommitApexSharingHelper.removePreviousOrgAccess(commitRevOrgIdListOld , commitRevIdListOld);
            CommitApexSharingHelper.lookParentOrgsUsers(commitRevOrgIdList , commitRevIdList);
            
        }
    }