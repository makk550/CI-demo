trigger UpdatePortalChamp on User (after insert,after update) {
    
    Set<Id> contacts = new Set<Id>();
    Set<Id> contactPartnerUsers = new Set<Id>();
    
    Map<Id,Id> contactPortalChampMap = new Map<Id,Id>();
    Set<string> emails = new Set<String>();
    
    for(User usr : Trigger.new)
    {
        if(usr.ContactId != null && (Trigger.isInsert || 
                                     Trigger.oldMap.get(usr.Id).Is_Portal_Champion__c != usr.Is_Portal_Champion__c || 
                                     Trigger.oldMap.get(usr.Id).Is_Partner_User__c != usr.Is_Partner_User__c))
        {
            contacts.add(usr.ContactId);
        
            if(usr.Is_Partner_User__c)
                contactPartnerUsers.add(usr.ContactId);
                    
            if(usr.Is_Portal_Champion__c)
            {
                contactPortalChampMap.put(usr.ContactId, usr.AccountId);
                emails.add(usr.Contact_Email__c);
            }
            
        }
    }
    
    if(!contacts.isEmpty())
        CreatePartnerUserDataOnUserUpdate.updateContacts(contacts, contactPartnerUsers, contactPortalChampMap.keySet());

    if(!contactPortalChampMap.isEmpty())              
        CreatePartnerUserDataOnUserUpdate.createPartnerLocations(contactPortalChampMap,emails);

/*
   This trigger is to update portal champion field on Contact.
   Portal Champion Should be true if user role contains “Executive” and profile contains “admin”.

*/

/*
    Set<Id> chkContacts= new Set<Id>();
    Set<Id> unChkContactsIds = new Set<Id>();

    Set<Id> chkActiveUsers= new Set<Id>();
    Set<Id> ChkInActiveUsers = new Set<Id>();
       
    for(User usr: Trigger.new){
      system.debug('IsActive********'+usr.IsActive+ usr.ContactId +usr.IsPortalEnabled);
     
      if(Trigger.isInsert && usr.UserType=='PowerPartner' && usr.IsActive && usr.ContactId!=null )
       {
            chkContacts.add(usr.ContactId);
       }
      
      if(Trigger.isInsert && usr.IsActive && usr.ContactId!=null )
       {
            chkActiveUsers.add(usr.ContactId);
       }
              
      if(Trigger.isUpdate){
        
        if(usr.UserType=='PowerPartner' && usr.ContactId!=null && (Trigger.oldMap.get(usr.Id).IsActive != usr.IsActive
           || Trigger.oldMap.get(usr.Id).UserRoleId != usr.UserRoleId || Trigger.oldMap.get(usr.Id).ProfileId != usr.ProfileId))
           
            chkContacts.add(usr.ContactId);
         
       //Uncheck partner champion if Contact is disabled.
       if(usr.ContactId!=null && Trigger.oldMap.get(usr.Id).IsPortalEnabled == true && usr.IsPortalEnabled==false && usr.UserType=='PowerPartner'){    
          unChkContactsIds.add(usr.ContactId);
        }   
          
        if(usr.ContactId !=null)           
            chkActiveUsers.add(usr.ContactId);
         
       //Uncheck partner champion if Contact is disabled.
       if(usr.ContactId!=null){    
          chkInActiveUsers.add(usr.ContactId);

       }
      
        
       
     }
     
    if(!chkContacts.isEmpty()){
                system.debug('chkContacts********'+chkContacts);
                CreatePartnerUserDataOnUserUpdate.updatePortalChampion(chkContacts);
    }
     
    if(!unChkContactsIds.isEmpty()){
            system.debug('unChkContactsIds********'+unChkContactsIds);
            CreatePartnerUserDataOnUserUpdate.unCheckPortalChampion(unChkContactsIds);
    }
    
   if(!chkActiveUsers.isEmpty() || !chkInActiveUsers.isEmpty()){
                system.debug('chkContacts********'+chkContacts);
                CreatePartnerUserDataOnUserUpdate.updateActiveUserOnContact(chkActiveUsers,chkInActiveUsers);
    }
*/     
    /*if(!chkInActiveUsers.isEmpty()){
            system.debug('unChkContactsIds********'+unChkContactsIds);
            CreatePartnerUserDataOnUserUpdate.updateActiveUserOnContact(chkActiveUsers,chkInActiveUsers);
    }*/
// }                              
}