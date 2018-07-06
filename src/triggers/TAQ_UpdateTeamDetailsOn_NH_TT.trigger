/*
        * DESC: To modify the PMFKey in Account Team Members records,
        * whenever new-hire/Term/Transfer occured @ TAQ Org level.
        */
    
    trigger TAQ_UpdateTeamDetailsOn_NH_TT on TAQ_Organization__c (after insert, after update) {
       
       if(SystemIdUtility.skipTAQ_Organization) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
        
       if(SystemIdUtility.isneeded==true)//---****---TO SKIP THIS TRIGGER WHEN TRYING TO UPDATE SUBORDINATE'S RECORDS IF THEIR RESPECTIVE MANAGER IS TERMINATED OR  HIRED
        return; 
        
        if( FutureProcessor_TAQ.skiporgtriggers)
            return;
        TAQ_UpdateTeamDetails_NH_TT.isExecuting = true; 
     //FY13- Copying back the TAQ Org Quota Approved records to TAQ Org Quota.
     if(trigger.isUpdate){
          try{
            if(CA_TAQ_Trigger_class.lstOldDelete_orgQuota.size()>0)
               database.delete(CA_TAQ_Trigger_class.lstOldDelete_orgQuota);//used to delete TAQOrg quota record when it is rejected.
          
          }catch(Exception e){
               System.debug('____Exception while reverting the TAQ Account Team:'+e.getMessage());
          }
      }
      
       // Verification and Confirmation to invoke future annotated execution or normal execution.
        Map<string,string> mPMF_Position = new Map<string,string>();
        Map<string,Date> mPMF_EffectiveDate = new Map<string,Date>();   
        Map<String,String> positionIdsMap = new Map<String,String>();
        Map<String,String> pmfManagerName = new Map<String,String>();
        Map<String,String> pmfManagerMap = new Map<String,String>();
        Map<String,String> positionManagerMap = new Map<String,String>();
        
            Set<String> terminatedPMFKeys = new Set<String>();//---*****---
            Set<String> newHirePositionIds = new Set<String>();
    
              Map<String,TAQ_Organization__c> PositionMap = new Map<String,TAQ_Organization__c>();
              for(TAQ_Organization__c t:Trigger.New)
              {    
                    System.debug('______adSx1____'+t.Approval_Process_Status__c); 
                   if(t.Approval_Process_Status__c!=NULL && t.Approval_Process_Status__c.contains('Approved')&&(t.process_Step__c=='Term / Transfer' || ( trigger.IsInsert || t.process_Step__c=='Employee Change' && (t.PlanType_Effective_Date__c != trigger.OldMap.get(t.Id).PlanType_Effective_Date__c || (t.Position_Id__c != trigger.OldMap.get(t.Id).Position_Id__c)|| (t.PMFKey__c != trigger.OldMap.get(t.Id).PMFKey__c))))) 
                   {
                     if(t.PMFKey__c <> null)
                     {  
                       if (t.process_Step__c=='Employee Change' && ( trigger.IsUpdate && (t.position_id_status__c == 'Open') &&  (t.position_id__c != trigger.OldMap.get(t.Id).position_id__c))){ 
                             String positionId = '';
                             if(Trigger.oldMap.containsKey(t.id) && Trigger.oldMap.get(t.id).Position_Id__c != NULL)
                                positionId = (Trigger.oldMap.get(t.id).Position_Id__c).toUpperCase();
                           
                           { 
                               mPMF_Position.put((Trigger.IsInsert?t.PMFKey__c.toUpperCase():positionId),t.Position_Id__c);
                               
                           }
                       }
                       
                      // else if(t.process_Step__c=='Employee Change' && ( trigger.IsInsert ||  t.PlanType_Effective_Date__c != trigger.OldMap.get(t.Id).PlanType_Effective_Date__c || (t.PMFKey__c != trigger.OldMap.get(t.Id).PMFKey__c))) 
                      //       mPMF_Position.put((Trigger.IsInsert?t.PMFKey__c:Trigger.oldMap.get(t.id).PMFKey__c).toUpperCase(),t.PMFKey__c);
                       else if(t.process_Step__c=='Term / Transfer'){
                            mPMF_Position.put((Trigger.IsInsert?t.PMFKey__c:Trigger.oldMap.get(t.id).PMFKey__c).toUpperCase(),t.Position_Id__c);
                            
                            if(t.Employee_Status__c == 'Transfer-within' || t.Employee_Status__c == 'Transfer-Out' || t.Employee_Status__c == 'Terminated'){
                                terminatedPMFKeys.add(Trigger.oldMap.get(t.id).PMFKey__c);//---*****---
                            }
                           if(t.Manager_Pmf_Key__c!=null)
                                   pmfManagerMap.put(t.PMFKey__c.touppercase(),t.Manager_Pmf_Key__c.touppercase());
                               positionManagerMap.put(t.Position_Id__c.touppercase(),t.Manager_Pmf_Key__c.touppercase());
                               system.debug('pmfManagerMap:'+pmfManagerMap);
                               system.debug('positionManagerMap:'+positionManagerMap); 
                       }
                        
                       mPMF_EffectiveDate.put(t.PMFKey__c.toUpperCase(),t.PlanType_Effective_Date__c);
                     }
                      
                    }
                   
                  else if(t.Approval_Process_Status__c!=NULL && t.Approval_Process_Status__c.contains('Approved') &&  t.Process_Step__c=='New Hire')
                   {             
                    System.debug('______adSx2____'+t.Approval_Process_Status__c);           
                     if(t.Position_Id__c <> null)
                     {  
                         
                         mPMF_Position.put(t.Position_Id__c.toUpperCase(),t.PMFKey__c);
                         mPMF_EffectiveDate.put(t.Position_Id__c.toUpperCase(),t.PlanType_Effective_Date__c);
                         newHirePositionIds.add(t.Position_Id__c.toUpperCase());
                         if(!pmfManagerName.containsKey(t.PMFKey__c.toUpperCase())){
                             pmfManagerName.put(t.PMFKey__c.toUpperCase(),t.Employee_Name__c);
                         }                        
                     }
                   }                
    
                  else if(Trigger.isUpdate && t.Process_step__c=='Open Headcount'  && (trigger.oldmap.get(t.Id).Position_id__c != t.Position_Id__c))                  
                   {
                      positionIdsMap.put(trigger.oldmap.get(t.Id).Position_Id__c,t.Position_Id__c);
                   }
                }
                
                //---*****---                
               
                
            
           /*try{    
               List<TAQ_Account_team__c> accteamlist = [SELECT PMFKey__c from TAQ_Account_Team__c where PMFKey__c in: positionIdsmap.keySet()];
               for(TAQ_Account_team__c t: accteamlist){
                 t.PMFKey__c = positionIdsMap.get(t.PMFKey__c);
               }
              database.update(accteamlist);
           }catch(Exception e){
             System.debug('____Exception while updating account team mem'+e.getMessage());
           } 
           */
         if(terminatedPMFKeys!=null || newHirePositionIds!=null || positionIdsmap.keySet()!=null){
             if(terminatedPMFKeys!=null || newHirePositionIds!=null){
                 SystemIdUtility.isneeded=true;
             }       
             System.debug('____678B41');      
               System.debug('____678B42'+terminatedPMFKeys);
                 System.debug('____678B43'+newHirePositionIds);
                 System.debug('____678B44'+mPMF_Position);
                 System.debug('____678B45'+pmfManagerName);
             TAQ_UpdateTeamDetails_NH_TT.updateSubordinateTAQOrgRecords(terminatedPMFKeys,newHirePositionIds,mPMF_Position,pmfManagerName,positionIdsmap);
             System.debug('____678after6');
         }
           
           
        if(mPMF_Position.keyset().size() == 0)
            return;
                
        // List of Account Team Records about to get modified.
        List<TAQ_Account_Team__c> updateTeamList = TAQ_UpdateTeamDetails_NH_TT.fetchAccountTeamRecords(mPMF_Position);// [SELECT Id,PMFKey__c from TAQ_Account_Team__c where PMFKey__c in: mPMF_Position.keyset()];
        set<Id> taqOrgIds = new set<id>();
        if(updateTeamList != null && updateTeamList.size() > 0)
        {
              
                 for(TAQ_Organization__c t:Trigger.New)
                 {
                     taqOrgIds.add(t.id);
                 }
                
                if(updateTeamList.size() <= (Limits.getLimitDMLRows() - Limits.getDMLRows()))
                 {
                      TAQ_UpdateTeamDetails_NH_TT.updateTeamDetails(updateTeamList, mPMF_Position, mPMF_EffectiveDate,taqOrgIds,pmfManagerMap,positionManagerMap);
                 }
                 else
                 {
                     TAQ_UpdateTeamDetails_NH_TT.updateTeamDetailsFuture(mPMF_Position, mPMF_EffectiveDate,taqOrgIds,pmfManagerMap,positionManagerMap);
                 }
         }
         
         
    
    
    }