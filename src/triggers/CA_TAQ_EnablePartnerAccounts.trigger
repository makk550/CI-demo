/***
* Description :This trigger will make the partner auto enable On Account  when created through TAQ.
* calls Method enableTechPartnerAccounts  , with List of TAQ_Account__c as input, of
* Class CA_TAQ_EnablePartnerAccounts to handle Enabled Partner Accounts functionality.
* SOQl: 1
* DML Updates: 1
* Client: CA technologies
* Developed By:  Heena Bhatnagar Nov 15,2010
*/

trigger CA_TAQ_EnablePartnerAccounts on TAQ_Account__c (after insert,after update) {
 
Set<Id> partnRegAccnts = new Set<Id>();


  if(SystemIdUtility.skipTAQ_Account) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
  if(SystemIdUtility.skipTAQAccount)//---Added in October'12 Mini release
    return;
// if(CA_TAQ_Account_Approval_Class.lstTAQforATM.size() > 0 && CA_TAQ_Account_Approval_Class.lstTAQforATMApproved.size() > 0 )
  if(CA_TAQ_Account_Approval_Class.lstTAQforATM.size() > 0)
  {
      
     CA_TAQ_Account_Approval_Class.CreateTAQAccountTeams();
  }
 
 if(Trigger.isupdate)
 {
 //reverting the TAQ Account Team from TAQ Account team Approved.-FY13
 try{
        List<Id> rejTAQAccs = new List<id>();
        for(TAQ_Account__c t: trigger.new){
         System.debug('______CCC111AAA_____'+t.Id+'____'+t.Approval_Status__c);
            if(t.Approval_Process_Status__c =='Rejected' || t.Approval_Status__c == 'rejected'){
               rejTAQAccs.add(t.Id);    
            }
            
            //Create partner user for partner onboarding if LDAP id is provided during Add TAQ account approval.
            if(t.Partner_On_boarding__c == True &&
             Trigger.oldMap.get(t.Id).View_Acc_Record__c == null && Trigger.oldMap.get(t.Id).View_Acc_Record__c <> t.View_Acc_Record__c )
              partnRegAccnts.add(t.View_Acc_Record__c);
        }
        CA_TAQ_Trigger_Class ctaq = new CA_TAQ_Trigger_Class();
         System.debug('______CCC111AAABBB_____'+CA_TAQ_Account_Approval_Class.EXECUTED_COUNT);
          CA_TAQ_Account_Approval_Class.EXECUTED_COUNT++;
       if(CA_TAQ_Account_Approval_Class.EXECUTED_COUNT<3){ 
             ctaq.revertTAQAccountTeam(rejTAQAccs);
            
       }      
     
    }catch(Exception e){
        System.debug('____Exception while reverting the TAQ Account Team:'+e.getMessage());
    }
    
    new CA_TAQ_EnablePartnerAccounts().enableTechPartnerAccounts(Trigger.new, Trigger.oldmap);   
}

List<TAQ_Account__c> allApprovedAcc = new List<TAQ_Account__c>(); 

CA_TAQ_Account_Approval_Class obj_CA_TAQ_Account_Approval_Class = new CA_TAQ_Account_Approval_Class();
obj_CA_TAQ_Account_Approval_Class.createOrUpdtTAQAccTeam(Trigger.new,Trigger.oldMap);
 
 try 
 {
 if(partnRegAccnts.size()>0){
        
        System.debug('****************************'+partnRegAccnts);
        CreatePartnerOpptySalesTeam obj = new CreatePartnerOpptySalesTeam();       
        obj.createPartner(partnRegAccnts);
    }
 }
 catch(Exception e)
 {
    System.debug('Exception in createPartner Calling '+ e.getmessage());
 }
     /***
     ****                                         ISTP Partner Profile Wave 1 – PR04659                                                                     ****
     **** Webservice Callout to Sync Partner TAQ Accounts - Accounts, Contacts, TAQ Account Team Approved to EAI When Insert/Update happens on TAQ Account  ****
     ****/
     
      if( !System.isFuture() && WebServiceUtilityClass.accIdToTAQAccountListMap.size()>0)
      if(Trigger.isInsert &&  !WebServiceUtilityClass.taqAccountInsertServCalled)
      {
        system.debug('##### TAQ trgr Call callEAIWebserviceBulkRequest for--'+WebServiceUtilityClass.accIdToTAQAccountListMap.KeySet());
        WebServiceUtilityClass.callEAIWebserviceBulkRequest(WebServiceUtilityClass.accIdToTAQAccountListMap); //Manikandan Raju
        WebServiceUtilityClass.taqAccountInsertServCalled = true;
      }
      else if(Trigger.isupdate && !WebServiceUtilityClass.taqAccountUpdateServCalled)
      {
        system.debug('##### TAQ trgr Call callEAIWebserviceBulkRequest for--'+WebServiceUtilityClass.accIdToTAQAccountListMap.KeySet());
        WebServiceUtilityClass.callEAIWebserviceBulkRequest(WebServiceUtilityClass.accIdToTAQAccountListMap); //Manikandan Raju
        WebServiceUtilityClass.taqAccountUpdateServCalled = true;
      }

    // Mari- Schedule batch job
    try {
    if(!System.isFuture() && !System.isBatch())
    //if( PartnerProfileUtil.schedulePartnerAccountSync==0 &&([select count() from AsyncApexJob where JobType='Scheduled Apex' and ApexClass.Name = 'Sch_Batch_ResendPAccountForEAIMDMSync' and Status in ('Processing','Preparing','Queued')] ==0))
    if(PartnerProfileUtil.schedulePartnerAccountSync==0 && (PartnerProfileUtil.findtaqaccScheduleCount() ==0))  
    {
        PartnerProfileUtil.schedulePartnerAccountSync ++;
        System.debug('Sch_Batch_ResendPAccountForEAIMDMSync '+PartnerProfileUtil.schedulePartnerAccountSync);
        Sch_Batch_ResendPAccountForEAIMDMSync temp = new Sch_Batch_ResendPAccountForEAIMDMSync();
        Datetime dt = Datetime.now().addMinutes(5);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        System.Schedule('Sch_Batch_ResendPAccountForEAIMDMSync '+timeForScheduler,timeForScheduler,temp);
        
    }
    }
    catch(exception e)
    {
         system.debug('Schedule Apex Error ' + e.getmessage());
    }
 
}