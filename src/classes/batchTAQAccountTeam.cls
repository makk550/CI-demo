//Implemented Stateful as part of AR 3841, to store the TAQ Account records across multiple batches
global class batchTAQAccountTeam implements Database.Batchable<sObject>, Database.Stateful
{

   string query ;
   string query1  ;
    String Ids ; 
    Map<string,string> mPMF_Position;
    Map<string,Date> mPMF_EffectiveDate;
    public List<TAQ_Account_Team__c> updateTeamList1;
    public set<id> taqOrgIds;
    Map<string,string> pmfManagerMap;
    Map<string,string> positionManagerMap;
    Map<id,TAQ_Account__c> mapTaqAccRec = new Map<id,TAQ_Account__c>();
    
 global void execute(Database.BatchableContext BC, List<TAQ_Account_Team__c> updateTeamList)
    {
    //Locking TAQ ORG.      
                 try
                    {
                        TAQ_Organization__c listTaqOrg = [select id,position_id__c,Position_ID_Status__c,Employee_Status__c,Employee_Status_Date__c from TAQ_organization__c where (PMFKey__c in: mPMF_Position.keyset() or Position_Id__c in: mPMF_Position.keyset()) and Batch_Number__c = Null and  Position_ID_Status__c ='Open'];
                        if(listTaqOrg != null)  
                        {
                        listTaqOrg.Batch_Number__c = BC.getJobId();
                            //SystemIdUtility.skipTAQ_Organization = true ;        
                            //    update listTaqOrg ; 
                            //SystemIdUtility.skipTAQ_Organization = false ; 
                        }
                    }
                    catch(Exception ex)
                    {
                       system.debug('Exception when retrieving TAQ ORg.');                      
                    }   
                    
          try
          {                                           
           updateTeamDetails(updateTeamList,mPMF_Position,mPMF_EffectiveDate);
          }
          catch(Exception ex)
          {
              resetTAQOrg();
          }
 
    }
    
    global batchTAQAccountTeam(List<TAQ_Account_Team__c> updateTeamList, Map<string,string> mPMF_Position_copy, Map<string,Date> mPMF_EffectiveDate_copy, set<id> taqOrgIds1, Map<string,string> pmfManagerMap_copy, Map<string,string> positionManagerMap_copy)
    {
    pmfManagerMap = pmfManagerMap_copy;
    positionManagerMap = positionManagerMap_copy;
    updateTeamList1 = new List<TAQ_Account_Team__c>();
            updateTeamList1  = updateTeamList;
     
    taqOrgIds = new set<id>();    
    taqOrgIds= taqOrgIds1 ;  
    
     ids = '';
       for(TAQ_Account_Team__c a : updateTeamList)
         {
            ids = ids + '\'' + a.id+ '\',' ;       
         }
         ids = ids + '\'\'';
         query1  = ids ;
         
         mPMF_Position = mPMF_Position_copy;
         mPMF_EffectiveDate = mPMF_EffectiveDate_copy;
         
                 
        query = 'SELECT taq_account__r.recordtypeid,taq_account__r.Process_Step__c,taq_account__r.Approval_Process_Status__c,taq_account__r.Approval_Status__c,  taq_account__c,taq_account__r.View_Acc_Record__c,  PMFKey__c, Is_Account_Owner__c from TAQ_Account_Team__c where  taq_account__r.Process_Step__c != \'Account Release\' and taq_account__r.Process_Step__c != \'Account Merge\' and Id in (' + ids +')'; 

    }
    
     global Database.QueryLocator start(Database.BatchableContext BC)
    {                    
                        
            /*if(updateTeamList1 !=null && updateTeamList1.size() > 200)
            {
               system.debug('updateTeamList1  -->' + updateTeamList1 );
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
                String[] toAddresses = new String[] {UserInfo.getUserEmail() };       
                mail.setToAddresses(toAddresses );
                mail.setSubject('Batch For Team Update Started');
                mail.setPlainTextBody
                ('The batch started with batch number ' + BC.getJobId() );     
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }   */
                     
          return Database.getQueryLocator(query);       
    }
    
     global void finish(Database.BatchableContext BC)
     {  
            
             try
                    {  
                        //AR 3841 Approving the TAQ Account records at the end of the Batch Process
                        if(mapTaqAccRec!=null){
                            database.update(mapTaqAccRec.values(),false);  //re-submit the TAQ Account for Approval
                        }
                     system.debug('');                   
                        List<TAQ_Organization__c> listTaqOrg = new List<TAQ_Organization__c>();
                         listTaqOrg = [select id,position_id__c,Position_ID_Status__c,Employee_Status__c,Employee_Status_Date__c from TAQ_organization__c where batch_number__c =: BC.getJobId()];
                                                                system.debug('listTaqOrg -->' + listTaqOrg );
                        if(listTaqOrg != null)  
                        {
                         for(TAQ_Organization__c t: listTaqOrg)
                             {
                                t.Batch_Number__c = Null;                                                               
                             }
                            SystemIdUtility.skipTAQ_Organization = true ;        
                                update listTaqOrg ; 
                            SystemIdUtility.skipTAQ_Organization = false ; 
                        }                     
                    }
                    catch(Exception ex)
                    {
                        system.debug('Exception when retrieving TAQ ORg.');
                    }      
   
       }
           
    public void resetTAQOrg()
    {
        try
        {
           TAQ_Organization__c listTaqOrg = [select id,position_id__c,Position_ID_Status__c,Employee_Status__c,Employee_Status_Date__c from TAQ_organization__c where (PMFKey__c in: mPMF_Position.keyset() or Position_Id__c in: mPMF_Position.keyset()) and Batch_Number__c != Null and  Position_ID_Status__c ='Open'  LIMIT 1];
            if(listTaqOrg != null)  
            {
                listTaqOrg.Batch_Number__c = Null;
                SystemIdUtility.skipTAQ_Organization = true ;        
                  update listTaqOrg ; 
                SystemIdUtility.skipTAQ_Organization = false ; 
            }
        }
        catch(Exception ex)
        {
          system.debug('Exception when retrieving TAQ ORg.');
        }
    }
   public void updateTeamDetails(List<TAQ_Account_Team__c> updateTeamList, Map<string,string> mPMF_Position, Map<string,Date> mPMF_EffectiveDate )
   {        
        
       Map<String,Id> useridMap = new Map<String,Id>();
       List<User> userlist = [Select id, pmfkey__c from User where isactive=true and pmfkey__c!=null ];
       for(User usr : userlist)
       {
           useridmap.put(usr.pmfkey__c.touppercase(), usr.id);
       }
        
     if(updateTeamList.SIZE() > 0)
     {
         for(TAQ_Account_Team__c at: updateTeamList)
           {
           System.debug('__________yyyy__________________'+at.Id);
               /*System.debug('useridmap.get(pmfManagerMap.get(at.PMFKey__c.toUpperCase())):'+useridmap.get(pmfManagerMap.get(at.PMFKey__c.toUpperCase())));
               if(at.PMFKey__c <> null && pmfManagerMap.containskey(at.PMFKey__c.toUpperCase()))
               if(useridmap.containskey(pmfManagerMap.get(at.PMFKey__c.toUpperCase())))
                at.User__c = useridmap.get(pmfManagerMap.get(at.PMFKey__c.toUpperCase()));
                  else
                  System.debug('cannot update user__c of taq account team');*/
              if(at.PMFKey__c <> null && mPMF_Position.containsKey(at.PMFKey__c.toUpperCase()))
              {
                      if( mPMF_EffectiveDate.get(at.PMFKey__c.toUpperCase()) != null)
                           at.Effective_Date__c = mPMF_EffectiveDate.get(at.PMFKey__c.toUpperCase()).toStartOfMonth();
                      else
                           at.Effective_Date__c =system.today().toStartOfMonth();
                      at.PMFKey__c = mPMF_Position.get(at.PMFKey__c.toUpperCase());                       
                      at.PMF_Key_Modified__c = true;
              }
              if(at.taq_account__r.Approval_Process_Status__c != 'Send for Approval' && at.taq_account__r.Approval_Status__c != 'Send for Approval'){
                 taq_account__c t = at.taq_account__r;
                 if(t.Approval_Process_Status__c == 'Approved' ||  t.Approval_Status__c == 'Approved' || t.Approval_Process_Status__c == 'Rejected' ||  t.Approval_Status__c == 'Rejected')
                 {
                   t.Approval_Process_Status__c = 'Approved'; 
                    mapTaqAccRec.put(t.id, t); 
                 }
                 
              }
           }
         

           if(SystemIdUtility.isneeded==true)
               SystemIdUtility.skipTAQAccountTeam = true;
           database.update(updateTeamList, false);//Update the TAQ Account Team
           System.debug('updateTeamList'+updateTeamList);
           
            
            List<TAQ_Account_Team__c> taqActTeams_owners = [SELECT Id,pmfkey__c, TAQ_Account__r.View_Acc_Record__r.ownerid, TAQ_Account__r.View_Acc_Record__c, User__c from TAQ_Account_Team__c
                                                        where TAQ_Account__c in: mapTaqAccRec.keyset() and Is_Account_Owner__c = true];
           List<Account> latAcc = new List<account>();
         
           Map<Id,Id> AccountUserMap = new Map<Id,Id>();
           for(TAQ_Account_Team__c tatm: taqActTeams_owners){
               if(!AccountUserMap.containsKey(tatm.TAQ_Account__r.View_Acc_Record__c)){
                   if(tatm.User__c!=null)
                        AccountUserMap.put(tatm.TAQ_Account__r.View_Acc_Record__c,tatm.User__c);
                   else if(useridmap.get(positionManagerMap.get(tatm.pmfkey__c))!=null)
                   {
                       System.debug('positionManagerMap:'+positionManagerMap);
                       System.debug('tatm.pmfkey__c:'+tatm.pmfkey__c);
                       System.debug('positionManagerMap.get(tatm.pmfkey__c):'+positionManagerMap.get(tatm.pmfkey__c));
                       System.debug('useridmap.get(positionManagerMap.get(tatm.pmfkey__c)):'+useridmap.get(positionManagerMap.get(tatm.pmfkey__c)));                       
                       AccountUserMap.put(tatm.TAQ_Account__r.View_Acc_Record__c,useridmap.get(positionManagerMap.get(tatm.pmfkey__c)));
                   }
                   else
                     AccountUserMap.put(tatm.TAQ_Account__r.View_Acc_Record__c,Label.Generic_Owner);  
                        
               }
               
           }
         System.debug('AccountUserMap:'+AccountUserMap);
           for(Id accId:AccountUserMap.keySet()){
               latAcc.add(new Account(id=accId,ownerid=AccountUserMap.get(accId)));
           }
           
           if(SystemIdUtility.isneeded==true)
               SystemIdUtility.skipAccount = true;
           database.update(latAcc,false); //Update the Standard Account  
         
           }
           
     } 
}