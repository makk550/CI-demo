trigger au_ContactNameToHVNName on Contact (after update) {
if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15)))
       return;
    //create a variable of the class to update the partner account on accreditations.
    PAD_UpdateAccountOnAccreditation classVar = new PAD_UpdateAccountOnAccreditation();
    //code corrected by Heena to avoid querying in for loop
    /*for (Contact con : Trigger.new) {
        Contact cntNew = [select Name from contact where id=:con.Id];
        if (con.HVN_ID__c != null)
        {
            HVN__c hvn = [select Name, Id from HVN__c where id=:con.HVN_ID__c];
            if(hvn!=null){
                if (hvn.name <> cntNew.name){
                hvn.Name = cntNew.Name;
                update hvn;
                }
            }
        }        
    }*/
    
    //heena code changes begin 
    Set<Id> contactHVNIDs= new Set<Id>();
    Set<Id> IdOFUsers=new Set<Id>();
    Set<Id> ContactIds=new Set<Id>();
    for(Contact con : Trigger.new){
        if (con.HVN_ID__c != null)
        {
             contactHVNIDs.add(con.HVN_ID__c);
        }
        
        //code change by sandeep for PRM user story 15 start.       
        if(con.AccountId!=null && Trigger.oldMap.get(con.Id).AccountId !=con.AccountId && con.Is_Partner_Acc__c=='true'){       
           // System.debug('****Contact ID:'+con.Id);
            ContactIds.add(con.Id);
        }  
    }
    
    if(ContactIds.size()>0) {
  
       List<user> usrLst = [Select Id from user where ContactId IN:ContactIds];
       for(user usr: usrLst){
          IdOFUsers.add(usr.Id);        
       }
    }

    if(IdOFUsers.size()>0)        
       CreatePartnerUserDataOnUserUpdate.createPartnerUserData(IdOFUsers);
    
    //code change by sandeep for PRM user story 15 End. 

        
    Map<Id,HVN__c> hvn = new Map<Id,HVN__c>([select Id, Name from HVN__c where id IN :contactHVNIDs]);
    List<HVN__c> updateHVNList = new List<HVN__c>();
   
    for(Contact con : Trigger.new)
    {
        if (con.HVN_ID__c != null){
            if(hvn.get(con.HVN_ID__c).Name <> con.name){
                hvn.get(con.HVN_ID__c).Name= con.firstname + ' ' + con.lastname;
                updateHVNList.add(hvn.get(con.HVN_ID__c));
            }    
            
        }
    }
    if(updateHVNList.size()>0)
       Database.update(updateHVNList, false);
    //heena code changes end
    
    //Chnaged by Siddharth for PRM R2-Call the method in class to update the partner account on accreditation
    classVar.updateAccreditationPartner(Trigger.old,Trigger.new);
}