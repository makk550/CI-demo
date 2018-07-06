/************************************************************************************************************************
Name : Add_and_Remove_Partner_Users
 
Type : Apex Trigger
 
Desc : 1.  Add partner user to Shark Tank queue when “Eligible to accept leads” checkbox is checked
       2.  Remove partner user from Shark Tank queue when “Eligible to accept leads” checkbox is unchecked
 
Auth : Deloitte Consulting LLP
 
*************************************************************************************************************************
 
LastMod                Developed By                 Desc
 
5/1/2012               Diti Mansata           1.  Add partner user to Shark Tank queue when “Eligible to accept leads” checkbox is checked
                                              2.  Remove partner user from Shark Tank queue when “Eligible to accept leads” checkbox is unchecked
************************************************************************************************************************/
 
trigger Add_and_Remove_Partner_Users on Account (after update,after insert) {
    
    if(SystemIdUtility.skipAccount == true)
        return;
    List<Account> checkNowList = new List<Account>();
    List<Account> uncheckNowList = new List<Account>();
    
    Set<String> checkNowSet = new Set<string>();
    Set<String> uncheckNowSet = new Set<string>();
    Set<Id> partnRegAccnts = new Set<Id>();
    Set<Id> chngedAddAccnts = new Set<Id>();
    Map<Id,set<String>> cams = new Map<Id,set<String>>(); 
 
 
 
 
   List<Account> accID = new List<Account>();
   List<User> usr = new List<User>();
   //Set<id> AccountId= new Set<Id>();
   set<String> filterAcc = new Set<String>();
   Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
   Map<string,Schema.RecordTypeInfo> AccRtMap = d.getRecordTypeInfosByName();
   Id accrectypeid= AccRtMap.get('Reseller/Distributor Account').getRecordTypeId();
   
   // Getting the queue from Custom Setting
    QueueCust__c que = QueueCust__c.getvalues('Common Partner Lead Pool');
   
   // Checking if the record type is matching and not eligible to shark tank leads is checked or not
    for(Integer i=0; i< trigger.new.size(); i++)
    {
        if(trigger.new[i].recordtypeid == accrectypeid)
        {
            String ids = trigger.new[i].Id;
            ids = ids.substring(0,15);
            //List<String> emailIds = new List<String>();
           
            if((Trigger.isUpdate && (trigger.new[i].Not_eligible_for_Shark_tank_Leads__c && !trigger.old[i].Not_eligible_for_Shark_tank_Leads__c))||(Trigger.isInsert && Trigger.new[i].Not_eligible_for_Shark_tank_Leads__c ))
            {
                checkNowSet.add(ids);
                checkNowList.add(trigger.new[i]);
            
            }
            else if((Trigger.isUpdate && (trigger.old[i].Not_eligible_for_Shark_tank_Leads__c && !trigger.new[i].Not_eligible_for_Shark_tank_Leads__c))|| (Trigger.isInsert && !Trigger.new[i].Not_eligible_for_Shark_tank_Leads__c))
            {
                uncheckNowSet.add(ids);
                uncheckNowList.add(trigger.new[i]);
            
            }
            
            //create partner user and contacts for the accounts generated through Partner on boarding.                  
          /*  if((Trigger.isUpdate && trigger.new[i].Partner_On_boarding__c && trigger.old[i].CPMS_ID__c == null && 
                  trigger.new[i].CPMS_ID__c <> trigger.old[i].CPMS_ID__c && !SystemIdUtility.isAccntUpdated ) ||    
                 (Trigger.isInsert && trigger.new[i].CPMS_ID__c != null) ){
                     partnRegAccnts.add(ids);   
                 }*/
                 
             //Send an email to CAM's if the account is created through on boarding process. 
                 
             if(Trigger.isInsert && trigger.new[i].Partner_On_boarding__c){
                   
                 Set<String> pmfKeys = new Set<String>();
                                  
                if(trigger.new[i].Alliance_CAM_PMFKey__c!=null)
                  pmfKeys.add(trigger.new[i].Alliance_CAM_PMFKey__c);
               if(trigger.new[i].Velocity_Seller_CAM_PMFKey__c!=null)
                  pmfKeys.add(trigger.new[i].Velocity_Seller_CAM_PMFKey__c);
               if(trigger.new[i].Service_Provider_CAM_PMFKey__c!=null)
                  pmfKeys.add(trigger.new[i].Service_Provider_CAM_PMFKey__c);
               if(trigger.new[i].Solution_Provider_CAM_PMFKey__c!=null)
                  pmfKeys.add(trigger.new[i].Solution_Provider_CAM_PMFKey__c);   
                                            
                  cams.put(trigger.new[i].Id,pmfKeys);             
             }    
             
             
             //Notify Partner champion if there is an address change to remind to verify and update location information.
             
             if(Trigger.isUpdate && !SystemIdUtility.hasPrtnChampNotifiedOnAddChanage && (trigger.new[i].billingstreet != trigger.old[i].billingstreet ||    
                trigger.new[i].billingstate != trigger.old[i].billingstate ||
                trigger.new[i].Billingcity != trigger.old[i].Billingcity ||
                trigger.new[i].billingpostalcode != trigger.old[i].billingpostalcode ||
                trigger.new[i].Country_Picklist__c != trigger.old[i].Country_Picklist__c ||
                trigger.new[i].Website != trigger.old[i].Website)                
                ){                  
                    chngedAddAccnts.add(ids);                   
                }
            
        }
    }
   // Calling class Remove_Partner_Users and its methods
    if(checkNowList != null && !checkNowList.isEmpty())
    {
        Remove_Partner_Users.callTriggerInsert(checkNowSet);
        
        
    }
    
    if(uncheckNowList != null && !uncheckNowList.isEmpty())
    {
    
          SET<Id>      Group_ids = new Set<Id>();
        List<GroupMember> GroupMemberDelList = new List<GroupMember>();
        
        List<User> uncheckedusr = [Select id ,Related_Partner_Account__c from User where Related_Partner_Account__c IN : uncheckNowSet];
     
        if(uncheckedusr!=null && uncheckedusr.size() > 0)
            GroupMemberDelList = [select id from GroupMember where UserOrGroupId IN : uncheckedusr AND GroupId =:  que.Queue_ID__c ];
       
        if(GroupMemberDelList.size() > 0)
        {
            
            for (GroupMember GM : GroupMemberDelList )
                Group_ids.add(GM.Id);
            
            Remove_Partner_Users.callTrigger(Group_ids);
        }   
    }   
    
    if(partnRegAccnts.size()>0 || cams.size()>0 || chngedAddAccnts.size()>0){
        
        CreatePartnerOpptySalesTeam obj = new CreatePartnerOpptySalesTeam(); 
        
        if(cams.size()>0)
           obj.sendNotification(cams);
        //if(partnRegAccnts.size()>0)      
           //.createPartner(partnRegAccnts);
        if(chngedAddAccnts.size()>0)    
           obj.notifyPartChmapionAddChange(chngedAddAccnts);
    }   
    
   
}