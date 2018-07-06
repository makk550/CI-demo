/************************************************************************************************************************
Name : Populate_Last_Accepted_Lead_Date

Type : Apex Trigger

Desc : Create a field “Last Accepted Lead Date” of type Date on partner account. 
       This lead will be auto-populated with current date when a partner user changes value of “Reseller Status” field on lead record to “Accepted"

Auth : Deloitte Consulting LLP

*************************************************************************************************************************

LastMod                Developed By                 Desc

5/1/2012               Diti Mansata           Create a field “Last Accepted Lead Date” of type Date on partner account. 
                                              This lead will be auto-populated with current date when a partner user changes value of “Reseller Status” field on lead record to “Accepted

************************************************************************************************************************/



trigger Populate_Last_Accepted_Lead_Date on Lead (before insert, before update)
{

 set<Id> accIds = new set<Id>();
 set<Id> owners = new set<Id>();
 Map<Lead, Id> leadIdMap  = new Map<Lead, Id>();
 Map<Id,string> OwnerRelAccMap = new Map<Id,string>();
 Map<Id,Account> AccIdAccMap;
 
 //Get lead owners in a set. Generate a map of lead and its related owners
  
    for(Lead ld : trigger.new){
    if((Trigger.isInsert && ld.Reseller_Status__c == 'Accepted') || (Trigger.isUpdate && ld.Reseller_Status__c == 'Accepted' && Trigger.oldmap.get(ld.Id).Reseller_Status__c != 'Accepted'  ))
    {
    owners.add(ld.ownerId);
    leadIdMap.put(ld,ld.ownerId);
    }
    }
  
 //Get partner user and related Accounts in a map. List out all related Accounts
    if(owners.size()>0){
    for(User u : [Select id,Related_Partner_Account__c from User where Id IN :Owners AND Related_Partner_Account__c <> null]){
      OwnerRelAccMap.put(u.Id,u.Related_Partner_Account__c);
      accIds.add(u.Related_Partner_Account__c);
    }
    }
  //Generate a map of related Accounts and thier id  
    if (accIds != null)
    AccIdAccMap = new Map<Id,Account>([Select id, Last_Accepted_Lead_Date__c from Account where id in : accIds]);
       
    // Iterate over the records from trigger , check for the reseller status. If 'Accepted' update the related Account.
    if (AccIdAccMap.size()>0  && OwnerRelAccMap.size()>0 ){
        for(Lead lead : Trigger.New)
       if((Trigger.isInsert && lead.Reseller_Status__c == 'Accepted') || (Trigger.isUpdate && lead.Reseller_Status__c == 'Accepted' && Trigger.oldmap.get(lead.Id).Reseller_Status__c != 'Accepted'  )){          
           AccIdAccMap.get(OwnerRelAccMap.get(leadIdMap.get(lead))).Last_Accepted_Lead_Date__c  = System.today();             
        }
        
       update AccIdAccMap.values();
     }  
}