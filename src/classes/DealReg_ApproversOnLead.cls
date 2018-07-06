/* To populate the CAM and CAM Manager on the Lead page for the Deal Reg Approval process*/
/* Total # of SOQL  3*/
/* Populating three Email addresses in Lead records for Notification purpose*/
/*  1.CAM_Manager_s_Email__c
    2.CAM_s_Email__c
    3.Portal_Champion_s_Email__c
Siddharth:
    Added code to populate the 
    1. First Approver   
    2. Second Approver
    3. Third Approver
    4. Finance Email    
Jon:
    Added code to populate Reseller and Reseller Contact Name for deal reg auto conversion
Last Updated by Jon Holato 11 Nov,2010 (Accenture)
 */

public with sharing class DealReg_ApproversOnLead {
    
    set<id> leadOwnerId = new set<id>();
    set<id> accountIds  = new set<id>();
    set<String> rtmPMFKeys  = new set<String>();
    map<String,String> camPMFKeys = new map<String,String>();
    map<String,String> camMgrPMFKeys = new map<String,String>();
    
    // jon
    map<id,id> mapOfContactIds = new map<id,id>();
    // end jon
    set<id> CAMsId=new set <id>();
    map<id,User> mapOfLeadOwners;
    map<id,User> mapOfCAMsManager=new Map<Id,User>();
    map<id,Account> mapOfAccounts;
    private Account partnerAccount;
    map<String,Deal_Program__c> mapOfDealPrograms= new map<String,Deal_Program__c>();
    
    /**Method will populate all notification Email address fields on Lead*/
    /*Added by Balasaheb Wani 24/11/2010*/
    public void populateEmailFields(List<Lead> thisLead)
    {
            for(Integer i=0;i<thisLead.size();i++)
            {
                leadOwnerId.add(thisLead[i].OwnerId);
            }
        mapOfLeadOwners=New Map<id,User>([select id,Email, AccountId, ContactId, name from User where id in: leadOwnerId and ContactId!=null ]);
        //test faled - added if condition PRM5 - aug
        if(mapOfLeadOwners.size() > 0){
            for(User u: mapOfLeadOwners.Values())
                {
                    accountIds.add(u.AccountId); 
                    // jon
                    mapOfContactIds.put(u.id,u.ContactId);
                    //System.debug('Contact ID : ' + u.ContactId);
                 /*   for(Integer i=0;i<thisLead.size();i++){
                        thisLead[i].Reseller_Contact_Name__c=u.ContactId;
                    }*/
                    // end jon, also added ContactId to previous SOQL Query   
                }
        }
        mapOfAccounts=New Map<id,Account>([Select Id,name,Reseller_Type__c,Owner.FirstName,Owner.LastName,Owner.Email,Owner.ManagerId,OwnerId,Portal_Champion__r.Email,Solution_Provider_CAM_PMFKey__c From Account where id in: accountIds]);
        if(mapOfAccounts.Size()>0)
        {
            for(Integer i=0;i<thisLead.size();i++)
                {
                    partnerAccount = new Account();
                    if(mapOfLeadOwners.get(thisLead[i].OwnerId) <> null)
                        partnerAccount=mapOfAccounts.get(mapOfLeadOwners.get(thisLead[i].OwnerId).AccountId);
                    CAMsId.add(partnerAccount.Owner.ManagerId);
                    if(partnerAccount.Solution_Provider_CAM_PMFKey__c!=null)
                       rtmPMFKeys.add(partnerAccount.Solution_Provider_CAM_PMFKey__c);
                }       
                        
            if(CAMsId.size()>0){
               List<User> lstCAMManager=[Select Id,Email,Manager.Email,ManagerId from User where id in :CAMsId];
               if(lstCAMManager.size()>0)
               {
                for(User u :lstCAMManager)
                    {
                        mapOfCAMsManager.put(u.id,u);
                    }
               }
            }  
            
            if(rtmPMFKeys.size()>0){
                List<User> lstCAMMgr=[Select Id,Email,Manager.Email,PMFKey__c from User where PMFKey__c in :rtmPMFKeys];
                if(lstCAMMgr.size()>0){
                  for(User usr :lstCAMMgr){                    
                    System.debug('******usr.PMFKey__c*******'+usr.PMFKey__c+'usr.Email'+usr.Email+'usr.Manager.Email'+usr.Manager.Email);
                    camPMFKeys.put(usr.PMFKey__c,usr.Email);
                    camMgrPMFKeys.put(usr.PMFKey__c,usr.Manager.Email);
                  } 
                    
                }
                
            }
        } system.debug('coming here0');
        if(mapOfAccounts!=null && mapOfAccounts.Size()>0)
        { system.debug('coming here10');
            for(Integer i=0;i<thisLead.size();i++)
            { system.debug('coming here12');
        
                if(mapOfLeadOwners.containsKey(thisLead[i].OwnerId) && mapOfAccounts.ContainsKey(mapOfLeadOwners.get(thisLead[i].OwnerId).AccountId))
                {   system.debug('coming here1');
                    partnerAccount = new Account();
                    partnerAccount=mapOfAccounts.get(mapOfLeadOwners.get(thisLead[i].OwnerId).AccountId);
            
                    if(mapOfCAMsManager.ContainsKey(partnerAccount.Owner.ManagerId))
                    {
                        thisLead[i].CAM_Manager_s_Email__c=mapOfCAMsManager.get(partnerAccount.Owner.ManagerId).Email;
                    }
                    thisLead[i].CAM_s_Email__c=partnerAccount.Owner.Email;
                    thisLead[i].CAM_Name__c=partnerAccount.Owner.FirstName+' '+partnerAccount.Owner.LastName;
                    thisLead[i].Portal_Champion_s_Email__c=partnerAccount.Portal_Champion__r.Email;
                    thisLead[i].Partner_Email_Address__c =mapOfLeadOwners.get(thisLead[i].OwnerId).Email;
                    
                    if(partnerAccount.Solution_Provider_CAM_PMFKey__c!=null && 
                        camPMFKeys.containsKey(partnerAccount.Solution_Provider_CAM_PMFKey__c.toUpperCase())){
                          thisLead[i].RTM_CAM_s_Email__c=camPMFKeys.get(partnerAccount.Solution_Provider_CAM_PMFKey__c.toUpperCase());    
                        }
                 
                    if(partnerAccount.Solution_Provider_CAM_PMFKey__c!=null && 
                        camMgrPMFKeys.containsKey(partnerAccount.Solution_Provider_CAM_PMFKey__c.toUpperCase())){
                          thisLead[i].RTM_CAM_Manager_s_Email__c=camMgrPMFKeys.get(partnerAccount.Solution_Provider_CAM_PMFKey__c.toUpperCase());     
                        }
                    System.debug('*******RTM CAM Email ID*********'+ thisLead[i].RTM_CAM_s_Email__c +'CAM Email:'+ thisLead[i].CAM_s_Email__c + + thisLead[i].RTM_CAM_Manager_s_Email__c);
                   
            if(SystemIdUtility.IsIndirectLeadRecordType(thisLead[i].recordTypeId) && thisLead[i].Reseller__c!=null)
            {   system.debug('coming here2');
            if(thisLead[i].Reseller__c!=partnerAccount.Id)
            thisLead[i].Reseller__c.adderror('The Partner user and the Lead Reseller should be related. Please select '+partnerAccount.name +' Reseller Account associated to '+mapOfLeadOwners.get(thisLead[i].OwnerId).name );
            }
                    // jon
            system.debug('coming here4');
            //heena added condition for indirect for Req # 1460 Release PRM 2.1 on 2/7/2011
                    if(SystemIdUtility.IsDeal_RegistrationRecordType(thisLead[i].recordTypeId) 
            ||SystemIdUtility.IsIndirectLeadRecordType(thisLead[i].recordTypeId)){
                        thisLead[i].Reseller__c=partnerAccount.Id;  system.debug('coming here5');       
                        // end jon
                        if(mapOfContactIds.containskey(thisLead[i].OwnerId))
                            thisLead[i].Reseller_Contact_Name__c=mapOfContactIds.get(thisLead[i].OwnerId); system.debug('coming here5');
                        }
            thisLead[i].Is_Lead_Owner_Partner__c=true;
                }
        else{
            thisLead[i].Is_Lead_Owner_Partner__c=false;
        }
            }                   
        }
    }
    public void populateApprovers(List<Lead> thisLead)
    {
         List<Deal_Program__c> listOfDealPrograms=[select Region__c, Finance__r.Email, First_Approver__c,
                                                Second_Approver__c, Third_Approver__c from Deal_Program__c];
        for(Integer i=0;i<listOfDealPrograms.size();i++)
            {
                mapOfDealPrograms.put(listOfDealPrograms[i].Region__c,listOfDealPrograms[i]);                           
            }           
            //code to populate the approvers and finance email
        if(mapOfDealPrograms!=null && mapOfDealPrograms.Size()>0)
        {
            for(Integer i=0;i<thisLead.size();i++){
                if(thisLead[i].GEO__c!=null && mapOfDealPrograms.ContainsKey(thisLead[i].GEO__c)){
                    thisLead[i].Finance_Email__c = mapOfDealPrograms.get(thisLead[i].GEO__c).Finance__r.Email;
                    thisLead[i].First_Approver__c = mapOfDealPrograms.get(thisLead[i].GEO__c).First_Approver__c;
                    thisLead[i].Second_Approver__c = mapOfDealPrograms.get(thisLead[i].GEO__c).Second_Approver__c;
                    thisLead[i].Third_Approver__c = mapOfDealPrograms.get(thisLead[i].GEO__c).Third_Approver__c;
                }
            }                       
        }
    }
    
    @isTest(SeeAllData=true)
    public static void DealReg_ApproversOnLead_test() {
        List<Account> accList = [select OwnerId from account limit 10];
        List<Id> accOwnerId = new List<Id>();
        for(Account a:accList)
            accOwnerId.add(a.ownerid);
            
        List<Lead> leadList = [Select OwnerId, GEO__c, Finance_Email__c, First_Approver__c, Second_Approver__c, Third_Approver__c, Is_Lead_Owner_Partner__c, Reseller__c, Reseller_Contact_Name__c, recordTypeId, RTM_CAM_Manager_s_Email__c, RTM_CAM_s_Email__c, Partner_Email_Address__c, Portal_Champion_s_Email__c, CAM_Name__c, CAM_s_Email__c, CAM_Manager_s_Email__c from Lead where ownerid in: accownerid Limit 10];
        DealReg_ApproversOnLead cls = new DealReg_ApproversOnLead();
        cls.populateEmailFields(leadList);
        cls.populateApprovers(leadList);
    }
}