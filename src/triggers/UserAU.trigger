trigger UserAU on User (after update,after insert) {

//  CreatePartnerUserDataOnUserUpdate ClassVar=new CreatePartnerUserDataOnUserUpdate();
    Set<Id> IdOFUsers=new Set<Id>();
    Set<Id> UserIds = new Set<Id>();
    Set<Id> disPartUsrs=new Set<Id>();
    Set<Id> inactiveusersafterupdate = new Set<id>();	//contact intelligence
    List<Contact_Relationship__c> usercontactlist = new List<Contact_Relationship__c>();	//contact intelligence
	List<id> contactrelationid = new List<id>();
   if(Trigger.isInsert){
      for (User u : Trigger.new){ 
                         
        if(u.ContactId!=null && u.UserType=='PowerPartner' && u.LDAP_Id__c==null)
           IdOFUsers.add(u.id);
      }
   }
   else if(Trigger.isUpdate){  

       //commented below lines to bulkify the code.
       /* for (User u : Trigger.new)   
        { 
            if(Trigger.oldMap.get(u.Id).Name!=u.Name) 
            {
                UserIds.add(u.Id);
            } 
        }  
        */    
        //changes added by Siddharth for PRM R2: Calling class to create partner user data records on user update.
        
        for (User u : Trigger.new)   
        {    
           List<String> emailIds = new List<String>();
           	
            //Contact Intelligence POC
            if(u.IsActive==false && u.UserType=='Standard'&&u.IsActive!=Trigger.oldmap.get(u.id).isActive){
                inactiveusersafterupdate.add(u.id);
            }
            //Contact Intelligence POC

            if(Trigger.oldMap.get(u.Id).Name!=u.Name) 
            {
                UserIds.add(u.Id);
            } 
            
 
            if( u.ContactId!=null && u.UserType=='PowerPartner' &&          
                (Trigger.oldMap.get(u.Id).FirstName != u.FirstName || 
                Trigger.oldMap.get(u.Id).LastName != u.LastName ||
                Trigger.oldMap.get(u.Id).LDAP_Id__c != u.LDAP_Id__c ||
                Trigger.oldMap.get(u.Id).ProfileId != u.ProfileId ||
                Trigger.oldMap.get(u.Id).UserRoleId != u.UserRoleId ||
                Trigger.oldMap.get(u.Id).Username != u.Username ||
                Trigger.oldMap.get(u.Id).Education_Access__c != u.Education_Access__c ||
                Trigger.oldMap.get(u.Id).IsActive != u.IsActive)            
               ){
                                
                    IdOFUsers.add(u.id);
               }
               else if(Trigger.oldMap.get(u.Id).IsPortalEnabled == true && u.IsPortalEnabled==false && u.UserType=='PowerPartner'){
                    System.debug('**inside disable partner**');
                    disPartUsrs.add(u.id);
               }
        }
       //contact intelligence
       if(inactiveusersafterupdate.size()>0){
           updateContactRelationshipOnUser.updatecontactuser(inactiveusersafterupdate);
       }
       //contact intelligence
   }
   
   if(UserIds.size()>0)
    {
        List<Account> updatedAccounts = new List<Account>();
        List<Account> lstAccounts = [select Account_Owner_Name__c, Owner.Name from Account where Ownerid in :UserIds];
        for(Account a:lstAccounts){
            a.Account_Owner_Name__c = a.Owner.Name;
            updatedAccounts.add(a);
        }
        update updatedAccounts;
        
    }
           
    if(IdOFUsers.size()>0)  
        CreatePartnerUserDataOnUserUpdate.createPartnerUserData(IdOFUsers);
    
    if(disPartUsrs.size()>0)  
        CreatePartnerUserDataOnUserUpdate.updatePartnerUserData(disPartUsrs);
    
    //end of changes by Siddharth
}