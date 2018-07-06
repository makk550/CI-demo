public class ctrlChecklist {

    public string msg{get;set;}
    
    public PageReference submit() {
        upsert lst;
        msg = 'Your entry has been submitted';
        return null;
    }

    
    public string checklistname{get;set;}
    public id checklistid{get;set;}
    public string name{get;set;}
    public string pmfkey{get;set;}
    public string title{get;set;}
    Public List<Checklist_User__c> lst{get;set;}
    
    
    public void initPage()
    {
        //User Info
        User user =[Select Profile.Name, region__c,  Alias, Name, Title, userrole.name from User Where id =: userInfo.getUserId()];
        name = user.name; title=user.title; pmfkey = user.alias;
        string profileName    = user.Profile.Name;
        string profile_start  = profileName +',%',  profile_end= '%,'+profileName,  profile_mid= '%,'+profileName +',%';
      
        string roleName    = user.userrole.Name;
        string role_start  = roleName +',%',  role_end= '%,'+roleName,  role_mid= '%,'+roleName +',%';
      
        string rolePrefix    = user.userrole.Name.split('_')[0] + '*';
        string rolePrefix_start  = rolePrefix +',%',  rolePrefix_end= '%,'+rolePrefix,  rolePrefix_mid= '%,' + rolePrefix + ',%';
        
        
        //End Of User Info
        List<checklist_type__C> chktypes = [Select name, id from Checklist_type__c 
                                     WHERE (Profiles__c like :profile_start OR Profiles__c like :profile_end OR Profiles__c like :profile_mid OR Profiles__c =: profileName OR Profiles__c = '')
                                         AND (
                                                  Roles__c like :role_start OR roles__c like :role_end OR roles__c like :role_mid OR roles__c =: roleName 
                                                               OR
                                                  Roles__c like :rolePrefix_start OR roles__c like :rolePrefix_end OR roles__c like :rolePrefix_mid OR roles__c =: rolePrefix
                                                               OR 
                                                  roles__c = ''
                                                           
                                              )
                                    ORDER BY CREATEDDATE DESC 
                                    limit 1];
        checklist_type__C chktype = new checklist_type__C();
        if(chktypes.size() > 0)
            chktype = chktypes[0];
                                        
        checklistname = chktype.name;
        checklistid = chktype.id; 
        
       List<Checklist_Item__c> lstChecklistItem = [Select id, Name, due_date__c From Checklist_Item__c Where Checklist_type__c =: checklistid 
                                                   AND (Profiles__c like :profile_start OR Profiles__c like :profile_end OR Profiles__c like :profile_mid OR Profiles__c =: profileName OR Profiles__c = '')
                                                   AND (
                                                           Roles__c like :role_start OR roles__c like :role_end OR roles__c like :role_mid OR roles__c =: roleName 
                                                               OR
                                                           Roles__c like :rolePrefix_start OR roles__c like :rolePrefix_end OR roles__c like :rolePrefix_mid OR roles__c =: rolePrefix
                                                               OR 
                                                           roles__c = ''
                                                           
                                                       )
                                                   ORDER BY due_date__c
                                                   ];
                                                   
        List<Checklist_User__c> lstChkUserTemp =  [Select id, name, Checklist_Item__c, item_due_date__c, Checklist_Item__r.Name, Completed__c From Checklist_User__c 
                                                   Where User__c =: userInfo.getUserId() AND Checklist_Item__r.Checklist_Type__c =:checklistid 
                                                   order by item_due_date__c desc 
                                                   ];
  
        boolean newrec = false;
        for(Checklist_Item__c ci: lstChecklistItem)
            {
                    if(!(CheckUserAdded(lstChkUserTemp, ci.Id)))
                        {
                            newrec= true;
                            lstChkUserTemp.add(new Checklist_User__c(name =pmfkey,Checklist_Item__c =ci.Id, user__c=userInfo.getUserId()));
                        }
            }    
        if(newrec)
            upsert lstChkUserTemp;
      
       lst = [Select id, name, Checklist_Item__c, item_due_date__c, Checklist_Item__r.Name, Completed__c From Checklist_User__c 
                                                   Where User__c =: userInfo.getUserId() AND Checklist_Item__r.Checklist_Type__c =:checklistid 
                                                   order by item_due_date__c
                                                   ];
   }
 
   public boolean CheckUserAdded(List<Checklist_User__c> lstChkUserTemp, id ChecklistItemId)
   {
           for(Checklist_User__c cu: lstChkUserTemp)
               if(cu.Checklist_Item__c == ChecklistItemId)
                   return true;
      return false;
   }
    
    
}