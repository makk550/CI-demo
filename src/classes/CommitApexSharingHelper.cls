public class CommitApexSharingHelper
{
   public static void lookParentOrgsUsers(List<Id> revOrgList , List<Id> revIdList)
    {
       List<Commit_Org__c> cOrgList = [Select c.Id , c.name ,c.Parent_Org__c, c.Owner_User__c, c.OwnerId From Commit_Org__c c];
       List<Commit_Revenue__Share> vCommitShrs = new List<Commit_Revenue__Share>();
       //List<List<Group>> masterGroupList = new List<List<Group>>();
       //for(List<Group> cMasterGroupList :  [Select g.Id , g.Name From Group g where g.Name like 'CG_%'])
       //{
       //  masterGroupList.add(cMasterGroupList);
       //}
       List<Group> cGroupList =  [Select g.Id , g.Name From Group g where g.Name like 'CG_%'] ;
       Id previousOrgId ;
       Set<Id> shareIdList = new Set<Id>();
       for(Integer i=0 ; i < revIdList.size() ; i++)
        {
            Id org = revOrgList[i];
            Id parentId = revIdList[i];
            System.debug('previousOrgId = ' +previousOrgId + ' :: org = ' +org);
            if(org != previousOrgId)
            {
                previousOrgId = org ;
                shareIdList.clear();
                Id tempOrgId = org; 
                List<String> parentOrgNameList = new List<String>();
                System.debug('Commit Org for this revenue record = ' + org);
                //parentOrgIdList.add(org); 
                while(tempOrgId != null)
                {
                    for(Commit_Org__c tCorg :cOrgList)
                    {
                        if(tempOrgId == tCorg.Id)
                        {
                            String orgName = 'CG_'+tCorg.Name;
                            System.debug('Parent Group Found for given commit org = '+orgname);
                            parentOrgNameList.add(orgName);
                            tempOrgId = tCorg.Parent_Org__c;
                        }
                    }    
                }
                System.debug('parentOrgNameList size = ' + parentOrgNameList.size());
                //List<Group> cGroupList =  [Select g.Id From Group g where g.Name in :parentOrgNameList];
            
                for(Group grp : cGroupList)
                {
                    for(String grpName : parentOrgNameList)
                    {
                        if(grp.Name == grpName)
                        {
                            System.debug('Share Group Id : ' + grp.Id);
                            shareIdList.add(grp.Id);
                            break;
                        }
                    }
                }
            }
            
            System.debug('Share Id List size='+shareIdList.size());
            Commit_Revenue__Share vShr;
            for(Id grpId :shareIdList)
            {
                vShr = new Commit_Revenue__Share();
            
                // Set the ID of record being shared
                vShr.ParentId = parentId;
            
                // Set the ID of user or group being granted access
                vShr.UserOrGroupId = grpId;
            
                // Set the access level
                vShr.AccessLevel = 'edit';
            
                // Set the Apex sharing reason for hiring manager and recruiter
                vShr.RowCause = Schema.Commit_Revenue__Share.RowCause.ApexSharing__c;
            
                // Add objects to list for insert
                vCommitShrs.add(vShr);
                if(vCommitShrs.size() >= 999)
                {
                    Database.SaveResult[] lsr = Database.insert(vCommitShrs,false);
                    vCommitShrs.clear();
                }
            }
        }
        
        Database.SaveResult[] lsr = Database.insert(vCommitShrs,false);        
    }
   /*public static void removeUsersSharingAccess(List<Id> userIds)
    {
        for(List<GroupMember> groupMemIdsList : [Select  g.Id  From GroupMember g where g.UserOrGroupId in :userIds and  g.Group.Name like 'CG_%'])
        {
            System.debug('removeUsersSharingAccess: Number of Rev_share records deleted:'+groupMemIdsList.size()+'--- for user :'+user);
            Database.DeleteResult[] lsr = Database.delete(groupMemIdsList);
        }
    } */
    public static void removePreviousOrgAccess(List<Id> orgList , List<Id> revList)
    {
        List<Commit_Org__c> cOrgList = [Select c.Id , c.name ,c.Parent_Org__c, c.Owner_User__c, c.OwnerId From Commit_Org__c c];
        List<Group> cGroupList =  [Select g.Id , g.Name  From Group g where g.Name like 'CG_%'] ;
        List<Commit_Revenue__Share> revShareList = [Select c.UserOrGroupId, c.ParentId, c.Id From Commit_Revenue__Share c where c.ParentId in :revList];
        List<Commit_Revenue__Share> delList = new List<Commit_Revenue__Share>();
        for(Integer i=0 ; i < orgList.size() ; i++)
        {
           String name = '' ;
            for(Commit_Org__c cOrg :cOrgList)
            {
                if(orgList[i] == cOrg.Id)
                {
                    name = 'CG_'+cOrg.Name;
                    for(Group grp :cGroupList)
                    {
                        if(name == grp.Name)
                        {
                            for(Commit_Revenue__Share revShare : revShareList)
                            {
                                if((revShare.UserOrGroupId == grp.Id) && (revShare.ParentId == revList[i]))
                                {
                                    delList.add(revShare);
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    break;
                }
            }
        }

        System.debug('removePreviousOrgAccess: delList Size :'+delList.size());
        Database.DeleteResult[] lsr = Database.delete(delList);
    }
    public static void removeUserFromGroup(List<Id> orgList , List<Id> userList)
    {
       List<Commit_Org__c> cOrgList = [Select c.Id , c.name ,c.Parent_Org__c, c.Owner_User__c, c.OwnerId From Commit_Org__c c];
       List<Group> cGroupList =  [Select g.Id , g.Name  From Group g where g.Name like 'CG_%'] ;
       List<GroupMember> grpMemList = [Select g.Id ,g.GroupId ,g.UserOrGroupId from GroupMember g where g.Group.Name like 'CG_%'];
       List<GroupMember> delList = new List<GroupMember>();
       for(Integer i=0 ; i < orgList.size() ; i++)
        {
           String name = '' ;
            for(Commit_Org__c cOrg :cOrgList)
            {
                if(orgList[i] == cOrg.Id)
                {
                    name = 'CG_'+cOrg.Name;
                    for(Group grp :cGroupList)
                    {
                        if(name == grp.Name)
                        {
                            for(GroupMember grpMem : grpMemList)
                            {
                                if((grpMem.GroupId == grp.Id) && (grpMem.UserOrGroupId == userList[i]))
                                {
                                    delList.add(grpMem);
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    break;
                }
            }
                
        }
        System.debug('removeUserFromGroup: delList Size :'+delList.size());
        Database.DeleteResult[] lsr = Database.delete(delList);
    }
    public static void addUsertoGroup(List<Id> orgList,List<Id> userList)
    {
       List<Commit_Org__c> cOrgList = [Select c.Id , c.name ,c.Parent_Org__c, c.Owner_User__c, c.OwnerId From Commit_Org__c c];
       List<Group> cGroupList =  [Select g.Id , g.Name  From Group g where g.Name like 'CG_%'] ;
       List<GroupMember> insertList = new List<GroupMember>();
       for(Integer i=0 ; i < orgList.size() ; i++)
        {
           String name = '' ;
            for(Commit_Org__c cOrg :cOrgList)
            {
                if(orgList[i] == cOrg.Id)
                {
                    name = 'CG_'+cOrg.Name;
                    for(Group grp :cGroupList)
                    {
                        if(name == grp.Name)
                        {
                            GroupMember grpMem = new GroupMember();
                            grpMem.GroupId = grp.Id;
                            grpMem.UserOrGroupId = userList[i] ; 
                            insertList.add(grpMem);
                            break;
                        }
                    }
                    break;
                }
            }
        }
        System.debug('addUsertoGroup: InsertList Size :'+insertList.size());
        insert(insertList);
    }
}