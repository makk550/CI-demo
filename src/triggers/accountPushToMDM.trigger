/*
 * uses test class - accountPushandDeletetoMDMTestClass
 */
trigger accountPushToMDM on Account (before insert,before update, after insert, after update) 
{
    if(SystemIdUtility.isneeded==true)//---****---TO SKIP THIS TRIGGER WHEN TRYING TO UPDATE SUBORDINATE'S RECORDS IF THEIR RESPECTIVE MANAGER IS TERMINATED OR  HIRED
        return;
     if(SystemIdUtility.skipAccount == true)
        return;  
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    
   	if(Label.isAccountPushToMDMTriggerActive=='FALSE')		//label used to activate/inactivate trigger - will be skipped when value = TRUE
      	return;
        
     if(trigger.isBefore && trigger.isUpdate){
        SystemIdUtility.mapAccountsOld = trigger.oldMap;
     }
    
    
     if(trigger.isBefore){
        /*PRM 5.5 - REQ-PRM16-PL-013 - Copying each RTM Type and Designation into Partner Type  
         * and Partner Designation fields for Partner Locator search results use.
         */
        
        try{
             String partnerTypeAssgn;
             String partnerDesgnAssgn;
             Set<String> partnerTypes;
             Set<String> partnerDesgns;
            for(Account acc: trigger.new){
                // PRM5.5 - For populating Partner_Type__c with concatenated RTM Type values.
                if(acc.Partner_Type__c == null && (acc.Alliance_Type__c != null || acc.Velocity_Seller_Type__c != null || 
                   acc.Service_Provider_Type__c != null || acc.Solution_Provider_Type__c != null)){
                partnerTypeAssgn = null;
                
                partnerTypes = new Set<String>();
                
                if(acc.Alliance_Type__c != null)          partnerTypes.add(acc.Alliance_Type__c);
                if(acc.Velocity_Seller_Type__c != null)   partnerTypes.add(acc.Velocity_Seller_Type__c);
                if(acc.Service_Provider_Type__c != null)  partnerTypes.add(acc.Service_Provider_Type__c);
                if(acc.Solution_Provider_Type__c != null) partnerTypes.add(acc.Solution_Provider_Type__c);
                Integer i=0;
                for(String pt:partnerTypes){
                    if(i == 0) 
                        partnerTypeAssgn = pt;
                    else
                        partnerTypeAssgn=partnerTypeAssgn+';'+ pt;
                    i++;
               }
                acc.Partner_Type__c = partnerTypeAssgn;
               }   
               
               
               // PRM5.5 - For populating Partner_Designation__c with concatenated RTM Designation values.
                if(acc.Partner_Designation__c == null && (acc.Alliance_Designation__c != null         || acc.Velocity_Seller_Designation__c != null || 
                   acc.Service_Provider_Designation__c != null || acc.Solution_Provider_Designation__c != null)){
                
                partnerDesgnAssgn= null;
                partnerDesgns = new Set<String>();
                
                if(acc.Alliance_Designation__c != null)          partnerDesgns.add(acc.Alliance_Designation__c);
                if(acc.Velocity_Seller_Designation__c != null)   partnerDesgns.add(acc.Velocity_Seller_Designation__c);
                if(acc.Service_Provider_Designation__c != null)  partnerDesgns.add(acc.Service_Provider_Designation__c);
                if(acc.Solution_Provider_Designation__c != null) partnerDesgns.add(acc.Solution_Provider_Designation__c);
                
                Integer i=0;
                for(String pd:partnerDesgns){
                    if(i == 0) 
                        partnerDesgnAssgn = pd;
                    else
                        partnerTypeAssgn=partnerTypeAssgn+';'+ pd;
                    i++;
               }
             
                acc.Partner_Designation__c = partnerDesgnAssgn ;
               }   
             }
        }catch(Exception e){
             System.debug('_____Exception while updating partner type and partner designation__'+e.getMessage());
        }
      }
    
    
    
    try{
   // 21/02/2012 - FY13 Changes for pushing account updates to MDM - Start
    AccountChangesPushToMDM mdmPushObj = new AccountChangesPushToMDM();
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            mdmPushObj.pushAccountUpdatesToMDM(null,Trigger.newMap);
        }
        if(Trigger.isUpdate) {
            mdmPushObj.pushAccountUpdatesToMDM(Trigger.oldMap,Trigger.newMap);
        }
    }
    // 21/02/2012 - FY13 Changes for pushing account updates to MDM - End
    }
    catch(exception e)
    {
        system.debug('Error Transmitting to MDM' + e.getmessage());
    }
    try {
        
    if(Trigger.isAfter && !System.isFuture() && !System.isBatch())
    //if(PartnerProfileUtil.scheduleDirectAccountSync==0 && ([select count() from AsyncApexJob where JobType='Scheduled Apex' and ApexClass.Name = 'Sch_Batch_ResendDAccountForEAIMDMSync' and Status in ('Processing','Preparing','Queued')] ==0))
   if(PartnerProfileUtil.scheduleDirectAccountSync==0 && (PartnerProfileUtil.findaccScheduleCount() ==0))
    {
        PartnerProfileUtil.scheduleDirectAccountSync ++;
        System.debug('Sch_Batch_ResendDAccountForEAIMDMSync '+PartnerProfileUtil.scheduleDirectAccountSync);
        Sch_Batch_ResendDAccountForEAIMDMSync temp = new Sch_Batch_ResendDAccountForEAIMDMSync();
        Datetime dt = Datetime.now().addMinutes(5);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        System.Schedule('Sch_Batch_ResendDAccountForEAIMDMSync '+timeForScheduler,timeForScheduler,temp);
        
    }
    }
     catch(exception e)
     {
         system.debug('Schedule Apex Error ' + e.getmessage());
     }
    
  }