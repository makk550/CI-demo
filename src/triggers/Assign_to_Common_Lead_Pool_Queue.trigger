/************************************************************************************************************************
Name : Assign_to_Common_Lead_Pool_Queue

Type : Apex Trigger

Desc : If "Eligible to accept leads" field is checked, the user will be added to the "Common Partner Lead Pool" queue.
 Similarly, when the checkbox is unchecked then remove the user from the queue. The trigger should also add the lead champion to the queue.

Auth : Deloitte Consulting LLP

*************************************************************************************************************************

LastMod                Developed By                 Desc

5/1/2012               Diti Mansata           If "Eligible to accept leads" field is checked, the user will be added to the "Common Partner Lead Pool" queue.
                                              Similarly, when the checkbox is unchecked then remove the user from the queue. The trigger should also add the lead champion to the queue.

************************************************************************************************************************/

trigger Assign_to_Common_Lead_Pool_Queue on User (before update)
{
// Do not execute this trigger if the Update on the user record hapenned from CC JIT process.
 if(Label.CC_JIT_User.contains(userinfo.getUserId().substring(0,15)))
        return;
        
  Set<Id> UserIds = new Set<Id>();
  Set<Id> PartnerAccId = new Set<Id>();
  
  List<GroupMember> GroupMemberList = new List<GroupMember>();
  List<GroupMember> GroupMemberDelList = new List<GroupMember>();  
  List<Account> accs = new  List<Account>();
  GroupMember GM; 
  // Getting the queue values from Custom Setting
  QueueCust__c que = QueueCust__c.getvalues('Common Partner Lead Pool');
   
  for (User u : Trigger.new){PartnerAccId.add(u.Related_Partner_Account__c);}
  // Getting the Lead Champion from the related Partner Account
  accs = [Select Id, Lead_Champion__c from Account where Id IN : PartnerAccId ];
  List<Id> leadChamp = new List<Id>();
  
  //Checking if Eligible_to_receive_leads__c is checked then add it to the Queue else adding to the Delete list to remove from the queue
  for (User u : Trigger.new)
  {
        GM = new GroupMember();  
        if(u.Eligible_to_receive_leads__c == TRUE) 
        {     
            GM.GroupId =  que.Queue_ID__c;
            GM.UserOrGroupId = u.id;
            GroupMemberList.add(GM);        
        }
        else if(u.Eligible_to_receive_leads__c!=TRUE && Trigger.oldMap.get(u.Id).Eligible_to_receive_leads__c != u.Eligible_to_receive_leads__c )
        UserIds.add(u.Id);
        
  }
   for(Integer i =0 ; i < accs.size(); i++)
    {
        leadChamp.add(accs[i].Lead_Champion__c) ; 
    }
    // If Lead Champion exists then adding it to the Queue
   if(leadChamp.size()>0)
    {
        for(Integer j =0 ; j<leadChamp.size(); j++)
        {   GM = new GroupMember(); GM.GroupId =  que.Queue_ID__c; GM.UserOrGroupId = leadChamp[j];
            if(leadChamp[j] <> null)
            GroupMemberList.add(GM); 
        } } 
    
 // Adding to the delete list if Eligible_to_receive_leads__c is unchecked         
 if(UserIds.size() > 0)
 GroupMemberDelList = [select id from GroupMember where UserOrGroupId IN: UserIds AND GroupId =:  que.Queue_ID__c ];
 
 if(GroupMemberList.size() > 0 )
 insert GroupMemberList;
 if(GroupMemberDelList.size() > 0) 
 delete GroupMemberDelList ;
 
     
}