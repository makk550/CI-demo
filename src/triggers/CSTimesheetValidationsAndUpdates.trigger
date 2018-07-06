//Written to Validate the Tasks for Customer Success Time Entry
trigger CSTimesheetValidationsAndUpdates on Task (before insert, after insert, before update,after update,before delete) 
{
    //Commented the bypass code as we dont have initial case load - velud01 - dec 2,2014
    if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15))) return;
    if(CheckRecursiveTrigger.isInitiatedByJira) return;
    if('YES'.equals(Label.TaskTriggerByPass)){ return ; }
    
    //Skip the trigger execution for the newtasks(workaround and resolution) that are created from code with all values set.
  
    if(TaskGateway.skipForNewtaskTypes && Trigger.isBefore && Trigger.isInsert){ return; }
    
    string temp_accountid;
    id recId = TaskGateway.customerSuccessRecTypeId;    
    Id SupportRecType = TaskGateway.SupportRecTypeId;
    Id RestorationTaskRecType = TaskGateway.restorationTaskRecTypeId; //US217005
  
    
    RecordType[] supportRt;    
   
    
    Set<id> setCaseSevfour=new Set<id>();
    Set<id> setAccIds = new Set<id>();    
    Set<id> setUserId = new Set<id>();    
    Set<date> setweekenddate = new Set<date>();
    Set<string> setCategory= new Set<string>();    
    set<String> CaNumSet = new set<String>();
    List<Case> caseList = new List<Case>();
    Map<String,id> caseNumMap = new Map<String,id>();    
    String conMilli='60000';
    String conSecond='3600000';
    String conSec='60';
    String conMin='15';
    set<id> tskidSet = new set<id>();
    set<id> tskidSetcom = new set<id>();
    set<id> comtskidSetopn = new set<id>();
    set<id> tskidSetcomopn = new set<id>();
    set<id> updCaseCallBackSet= new set<id>();
    set<id> compTskCaseIdSet = new set<id>();
    List<Case> listCase = new List<case>();
    List<Case> listCaseCom = new List<case>();
    List<task> listTask = new List<task>();
    List<Case> listCaseComopn = new List<case>();
    List<task> listTaskopn= new List<task>();
    List<Case> updatelistCase = new List<case>();
    List<task> listTaskop= new List<task>();
    Map<id,List<Task>> castasMap = new Map<id,List<Task>>();
    Map<id,List<Task>> oPcastasMap= new Map<id,List<Task>>();
    Map<id,List<Task>> taskMap = new Map<id,List<Task>>();
    set<id> caseSetSupportRecordType = new set<id>(); 
    Map<id,Id> caseNumbTaskMap = new Map<id,Id>();
    List<Task> tasksToUpdate = new List<Task>();
    set<id> UpdInternlPriorityOfCaseSet = new set<id>();
    
    set<id> OpenCallBackCaseIds= new set<id>();
    Set<Id> donotUpdateCaseCallBack = new Set<Id>();
    Set<Id> updateCase = new Set<Id>();
    boolean isSupportRecordtype=false;
    Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
    set<Id> updatePriorityCaseSet = new set<ID>();
    Set<Id> donotUpdateCasePriority = new Set<Id>();
    Set<Id> updateCaseSet = new Set<Id>();
    Set<Id> caseIdsToUpdSev= new Set<Id>();
    Set<Id> busHrsCaseSet = new Set<Id>();
    Set<Id> tpcCaseIdSet=new Set<Id>();
    
    Map<id,Case> BusinessHrsMap = new Map<id,Case>();
    
    List<Task> newTasksToInsert = new List<Task>();
    Map<Id,Datetime> caseIDNextActionDueDateMap=new Map<Id,Datetime>();
       Set<Id> updateCaseCBSet = new Set<Id>();   
    // user/per time period/per account/per category
    if(!Trigger.isDelete)
    {//Validating that the Week End Date Should be a Friday - Start
        
        for(Task t: Trigger.New)
        {
            if(Trigger.isbefore && (Trigger.isinsert || Trigger.isupdate )){    
                /* if(t.recordtypeid == recid)
{ 
if(t.IsRecurrence)
{   t.addError('Recurrence is not valid for CST Time Tracking tasks' );
continue;
}   

//if(t.Week_End_Date__c.toStartOfWeek().daysBetween(t.Week_End_Date__c) <> 5)
if( t.Week_End_Date__c.daysBetween(cst_timesheet.getFriday(t.Week_End_Date__c)) <> 0)
t.Week_End_Date__c.addError('Week End Date should be a Friday');
else
{
if(t.WhatId <> null && String.ValueOf(t.WhatId).startsWith('001') )    //To Move the Related To Values to the new Activity fields
setAccIds.add(t.WhatId); 
if(t.WhatId == null || String.ValueOf(t.WhatId).startsWith('001')) // For Checking duplicates
{
setUserId.add(t.OwnerId); 
setweekenddate.add(t.Week_End_Date__c);
setCategory.add(t.category__c); 
} 
}   
}*/
                //Getting all case ids before insert task
                if(Trigger.isinsert && Trigger.isBefore && t.whatid != null && (String.ValueOf(t.WhatId).startsWith('500'))){
                    tpcCaseIdSet.add(t.whatid);
                }
                if(Trigger.isinsert && t.whatid != null && (String.ValueOf(t.WhatId).startsWith('500')))
                    caseIdsToUpdSev.add(t.whatid);   
                if(Trigger.isinsert && (t.Subject == 'Initial Callaback' ||  t.Subject == 'Workaround' || t.Subject == 'Resolution')){
                    t.RecordTypeId = SupportRecType;
                    t.IsVisibleInSelfService = true; // We need this so Community Users can see these tasks
                }
               
                //US217005 - starts - Set attributes of Restoration Task
                if(Trigger.isinsert  && Trigger.isBefore &&  t.Subject == 'Restoration'){ 
                    if(!Test.isRunningTest()) { t.RecordTypeId = RestorationTaskRecType; }
                    t.IsVisibleInSelfService = true; 
                    t.Type =  'Restoration';      
                    t.Status='Open';
                }
                //US217005 -  ends                
                
                if(t.recordtypeid == SupportRecType){
                    if( t.Subject != 'Workaround' && t.Subject != 'Resolution' ) {
                        caseSetSupportRecordType.add(t.whatid);
                        //US138062-Change as part of Queue Jumping logic-start
                        if(UtilityFalgs.isQueueJumpingEnabled && t.Subject == 'Initial Callaback')
                        t.Queue_Jumping__c=true; 
                        //US138062-Change as part of Queue Jumping logic-end
                        System.debug('task status'+t.status);
                        if(t.status=='Completed' || t.status=='Closed')
                        {
                            t.call_back_prioirity__c='N';
                            t.Open_call_back__c='N';
                        }
                        else
                            t.Open_call_back__c='Y';                        
                        
                    }  
                }
                
                if(t.recordtypeid != recid){                          
                    if(Trigger.isInsert && (t.status=='Completed' || t.status=='Closed'))
                        t.CallBackEndTime__c =system.now();           
                    else if(Trigger.isUpdate && trigger.oldMap.get(t.Id).Status!= t.Status && (t.status=='Completed' || t.status=='Closed')){ 
                        t.CallBackEndTime__c =system.now();  
                        busHrsCaseSet.add(t.WhatId);
                    }    
                    else
                        t.CallBackEndTime__c = null;      
                }
                
                if(t.recordtypeid != SupportRecType && t.ActivityDate!=null)
                    t.Due_Date_SLO__c =datetime.newInstance(t.ActivityDate.year(), t.ActivityDate.month(),t.ActivityDate.day(),23,59,0);
                
                
            }   
            
           
            
            if(t.recordtypeid == SupportRecType && Trigger.isAfter && (Trigger.isUpdate ||  Trigger.isInsert))
            {
                if( t.Subject != 'Workaround' && t.Subject != 'Resolution' ) { 
                    if(Trigger.isInsert){    
                        
                        if(t.Open_call_back__c=='Y' && t.whatid!=null)            
                            OpenCallBackCaseIds.add(t.whatid);
                    } 
                    
                    if(Trigger.isupdate){            
                        
                        if(trigger.oldMap.get(t.Id).call_back_prioirity__c!= t.call_back_prioirity__c && t.call_back_prioirity__c=='Y' && t.whatId!=null)
                            UpdInternlPriorityOfCaseSet.add(t.whatId);      
                        
                        if(trigger.oldMap.get(t.Id).Status!= t.Status && (t.Status=='Completed' || t.Status=='Closed') && t.WhatId!=null)
                            compTskCaseIdSet.add(t.WhatId); 
                        
                    }                      
                }   
                if(t.Case_Number__c!=null && t.Whatid==null)            
                    caseNumbTaskMap.put(t.Id,t.Case_Number__c); 
            }
        }
    } 
    
    
    //Changes for increasing slo values to 1 business day for severity 4 task      -start
    if(caseSetSupportRecordType!=null && caseSetSupportRecordType.size()>0){
        for(Case cse : [select id, BusinessHoursId from Case where id in :caseSetSupportRecordType and (Severity__c='4' OR Severity__c=:system.label.sealNumberOfDays)])
            setCaseSevfour.add(cse.BusinessHoursId);
    }
    
    if(setCaseSevfour!=null && setCaseSevfour.size()>0){
        
        for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id in :setCaseSevfour])
            taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
       
    }
    
    //TPC task making it public in portal 
    if(Trigger.isInsert && Trigger.isBefore && !tpcCaseIdSet.isEmpty() ) {
        Set<Id> tpcCaseList = (new Map<Id, Case>([SELECT id FROM CASE WHERE  TPC_Team__c  != null and id in:tpcCaseIdSet])).keySet();
        for(Task taskRec:Trigger.New){
            if(tpcCaseList.contains(taskRec.WhatId)) {
                
                taskRec.IsVisibleInSelfService = True;
            }
        }
    }
    
    //Changes for increasing slo values to 1 business day for severity 4 task      -end
    if(busHrsCaseSet!=null && busHrsCaseSet.size()>0){
        BusinessHrsMap= new Map<id,Case>([Select id, BusinessHoursId from Case Where id in : busHrsCaseSet]);   
    } 
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        for(Task taskRec:Trigger.New){
            if(BusinessHrsMap.get(taskRec.WhatId)!=null &&trigger.oldMap.get(taskRec.Id).Status!= taskRec.Status && (taskRec.status=='Completed' || taskRec.status=='Closed')){
                
                Long totalMilSecnds = BusinessHours.diff(BusinessHrsMap.get(taskRec.WhatId).BusinessHoursId,taskRec.createdDate,system.now());
                if(totalMilSecnds!=0)
                    taskRec.Callback_Resolution_Time__c=totalMilSecnds/1000;              
            }            
        }
    }
    
    if(caseIdsToUpdSev!=null && caseIdsToUpdSev.size()>0){
        //By aditya for offering business rule adding new columns(Offering_Name__c) in query
        Map<id,Case> caseMap = new Map<id,Case>([Select id, Case_Type__c,contactId, OwnerId,tpc_team__c, Severity__c,Origin,BusinessHoursId,lastmodifieddate,Reopen_Count__c,Offering_Name__c,createdDate,AccountId from Case Where id in : caseIdsToUpdSev and Status!='Closed']);
        
        Map<String,String> casebusinessHourIdMap=new Map<String,String>();
        Map<String,String> supportOfferingMap=new Map<String,String>();
        
        
        
        for(String id:caseMap.keySet()) {
            System.debug('&&&&&&&&&&&&LOL&&&&&&&&&&&&:'+caseMap);
            System.debug('&&&&&&&&&&&&&&&&&&&&&&&&:'+caseMap.get(id).Offering_Name__c);
            if(caseMap.get(id).Offering_Name__c<>null){
                casebusinessHourIdMap.put(id,caseMap.get(id).BusinessHoursId);
                supportOfferingMap.put(caseMap.get(id).Offering_Name__c, caseMap.get(id).Severity__c);
                for(BusinessHours obj : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id in  :casebusinessHourIdMap.values()]){
                    taskBusinessdayMap.put(obj.id,(obj.MondayEndTime.hour()-obj.MondayStartTime.hour()));
                }  
            }
        }
        Map<ID,Offering_Feature__c> offeringBusinessRulesMap=new Map<ID,Offering_Feature__c>([SELECT ID,Type__c,Case_Severity__c,SLO_Value__c,SLO_Type__c,Unit__c FROM Offering_Feature__c WHERE Offering_Business_Rules__c in :supportOfferingMap.keySet() and Case_Severity__c in : supportOfferingMap.values()]);
        
        List<Offering_Feature__c> offeringBusinessFeaturesCombKeyList=[SELECT Type__c,ID FROM Offering_Feature__c WHERE Offering_Business_Rules__c in :supportOfferingMap.keySet() and Case_Severity__c in : supportOfferingMap.values()];  
        Map<String, Offering_Feature__c> offeringBusinessFeaturesCombKeyMap = new Map<String, Offering_Feature__c>();
        for(Offering_Feature__c obj : offeringBusinessFeaturesCombKeyList) {
            offeringBusinessFeaturesCombKeyMap.put(obj.Type__c, obj);
        }
        //End of Aditya
        
        if(Trigger.isinsert && Trigger.isbefore && caseMap!=null && caseMap.size()>0){
            for(Task t: Trigger.New){
                if(Trigger.isinsert && t.Subject == 'Initial Callaback'){
                    t.Subject=caseMap.get(t.WhatId).Reopen_Count__c>0?'Reopen Case':'New Case';
                    if(caseMap.get(t.WhatId).Origin!=null){
                        if(caseMap.get(t.WhatId).Origin.contains('Email'))
                            t.Source__c='Email';
                        else if(caseMap.get(t.WhatId).Origin.contains('Portal')) 
                            t.Source__c='CSO';
                    }
                    t.Status='Open';
                    t.Priority='Low';
                    t.WhatId=caseMap.get(t.WhatId).id;
                    t.RecordTypeId = SupportRecType;           
                    t.Type='Initial Callback';
                    t.IsVisibleInSelfService = True; // this task should always be public for customer community and partner community
                    
                    if(caseMap.get(t.WhatId).Case_Type__c =='Case Concern'){
                        t.Case_Concern_Call_back_check__c=true;
                    }
                    String caseOwner = caseMap.get(t.WhatId).OwnerId;        
                    if(caseOwner.substring(0, 3)!='005')
                        t.OwnerId=label.Service_cloud_Task_assignee;
                    else
                        t.OwnerId=caseMap.get(t.WhatId).OwnerId;                           
                }  
                
                //Adding below code to check the new offering SLO flow
                DateTime targTime=System.now(); 
                if((t.RecordTypeId == SupportRecType || t.RecordTypeId == RestorationTaskRecType) && t.WhatId!=null && caseMap.get(t.WhatId)!=null){
                    t.Severity__c=caseMap.get(t.WhatId).Severity__c;
                    
                    String caseOfferingCode=null;       
                    String caseOfferingCode_workaround = null; 
                    String caseOfferingCode_resolution = null; 
                    boolean executeSLOFlow=false;
                    if(caseMap.get(t.WhatId).Offering_Name__c<>null){
                        if(offeringBusinessFeaturesCombKeyMap.containsKey('Initial Callback')){
                            caseOfferingCode=offeringBusinessFeaturesCombKeyMap.get('Initial Callback').ID;
                        }
                        if(offeringBusinessFeaturesCombKeyMap.containsKey('Workaround')){
                            caseOfferingCode_workaround=offeringBusinessFeaturesCombKeyMap.get('Workaround').ID;   
                        }
                        if(offeringBusinessFeaturesCombKeyMap.containsKey('Resolution')){
                            caseOfferingCode_resolution=offeringBusinessFeaturesCombKeyMap.get('Resolution').ID;   
                        }                        
                        executeSLOFlow=true;
                    }                  
                    //Code flow with Offering Business Rule Criteria
                    if(executeSLOFlow){
                        if(t.Type == 'Initial Callback'){ // if(t.Subject == 'Initial Callback'){
                            if(caseOfferingCode!= null){ 
                                t.Due_Date_SLO__c=OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode,false,false,taskBusinessdayMap,offeringBusinessRulesMap);
                                t.SLO_Start_DT__c   =OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode,false,true,taskBusinessdayMap,offeringBusinessRulesMap); 
                                t.SLO2_Milestone2__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '2', false,caseOfferingCode,t.Due_Date_SLO__c);
                                t.SLO3_Milestone3__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '3', false,caseOfferingCode,t.Due_Date_SLO__c);
                                t.SLO4_Milestone4__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '4', false,caseOfferingCode,t.Due_Date_SLO__c);
                            }
                            else{ 
                                t.Due_Date_SLO__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, false,null,null);
                                t.SLO_Start_DT__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, true,null,null);
                                t.SLO2_Milestone2__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '2', false,null,null);
                                t.SLO3_Milestone3__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '3', false,null,null);
                                t.SLO4_Milestone4__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '4', false,null,null);
                            }               
                        }
                        if(caseOfferingCode_workaround!= null && UtilityFalgs.createWRTasks == true){
                            Task workaroundTask = new Task();
                            workaroundTask.Type = 'Workaround';
                            workaroundTask.Subject = 'Workaround';
                            workaroundTask.WhatId = t.WhatId; //assigning this to the same case as of initial callback.
                            workaroundTask.Due_Date_SLO__c=OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode_workaround,false,false,taskBusinessdayMap,offeringBusinessRulesMap);                                
                            workaroundTask.SLO_Start_DT__c   =OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode_workaround,false,true,taskBusinessdayMap,offeringBusinessRulesMap);
                            workaroundTask.RecordTypeId = SupportRecType;
                            workaroundTask.Status='Open';
                            workaroundTask.Priority='Low';
                            workaroundTask.Severity__c=caseMap.get(t.WhatId).Severity__c;
                            workaroundTask.Source__c='';
                            workaroundTask.IsVisibleInSelfService = True; // this task should always be public for customer community and partner community
                            String caseOwner = caseMap.get(t.WhatId).OwnerId;        
                            if(caseOwner.substring(0, 3)!='005')
                                workaroundTask.OwnerId=label.Service_cloud_Task_assignee;
                            else
                                workaroundTask.OwnerId=caseMap.get(t.WhatId).OwnerId;
                            newTasksToInsert.add(workaroundTask);
                        }
                        
                        if(caseOfferingCode_resolution!= null && UtilityFalgs.createWRTasks == true){
                            Task resolutionTask = new Task();
                            resolutionTask.Type = 'Resolution';
                            resolutionTask.Subject = 'Resolution';
                            resolutionTask.WhatId = t.WhatId; //assigning this to the same case as of initial callback.
                            resolutionTask.Due_Date_SLO__c=OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode_resolution,false,false,taskBusinessdayMap,offeringBusinessRulesMap);                                
                            resolutionTask.SLO_Start_DT__c   =OfferingRulesSLOMappings.calculateSLO(caseMap.get(t.WhatId).BusinessHoursId,caseOfferingCode_resolution,false,true,taskBusinessdayMap,offeringBusinessRulesMap);
                            resolutionTask.RecordTypeId = SupportRecType;
                            resolutionTask.Status='Open';
                            resolutionTask.Priority='Low';
                            resolutionTask.Severity__c=caseMap.get(t.WhatId).Severity__c;
                            resolutionTask.Source__c='';
                            resolutionTask.IsVisibleInSelfService = True; // this task should always be public for customer community and partner community
                            String caseOwner = caseMap.get(t.WhatId).OwnerId;        
                            if(caseOwner.substring(0, 3)!='005')
                                resolutionTask.OwnerId=label.Service_cloud_Task_assignee;
                            else
                                resolutionTask.OwnerId=caseMap.get(t.WhatId).OwnerId;
                            newTasksToInsert.add(resolutionTask);
                        }
                        
                        if((t.Type!='Initial Callback') && (t.Type!='Workaround') && (t.Type!='Resolution')){                         
                            t.Due_Date_SLO__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, false,null,null);
                            t.SLO_Start_DT__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, true,null,null);
                        } //end of hadling other task types to set due dates.
                    }
                    else{
                        //existing flow from custom settings
                        t.Due_Date_SLO__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, false,null,null);
                        t.SLO_Start_DT__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, true,null,null);
                        t.SLO2_Milestone2__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '2', false,null,null);
                        t.SLO3_Milestone3__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '3', false,null,null);
                        t.SLO4_Milestone4__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '4', false,null,null);
                        
                    }//end of else block of existing flow from custom settings
                    
                }//end of support rec type

                //US217005 -  starts - Set attributes of Restoration Task
                if( t.Type == 'Restoration' ){
                    t.Due_Date_SLO__c =  System.now().addHours(Integer.valueOf(System.Label.Three)); // Adding three standard hours as SLA
                    t.SLO_Start_DT__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, null, true,null,null);
                    t.SLO2_Milestone2__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '2', false,null,null);
                    t.SLO3_Milestone3__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '3', false,null,null);
                    t.SLO4_Milestone4__c=DueDateandMilestoneCalculator.calculateSLOMileStone(caseMap.get(t.WhatId).Severity__c, caseMap.get(t.WhatId).BusinessHoursId, taskBusinessdayMap, '4', false,null,null);
                    t.Severity__c=caseMap.get(t.WhatId).Severity__c;
                    String caseOwner = caseMap.get(t.WhatId).OwnerId;        
                    if(caseOwner.substring(0, 3)!='005')
                        t.OwnerId=label.Service_cloud_Task_assignee;
                    else
                        t.OwnerId=caseMap.get(t.WhatId).OwnerId; 
                         // t.OwnerId=label.Service_cloud_Task_assignee;
                }
                //US217005 -  ends                  
                
            }//end of for loop for trigger      
        }    
    }
    
    //Changes related to ESS PLUS
    if(newTasksToInsert!= null && !newTasksToInsert.isEmpty()){
        TaskGateway.skipForNewtaskTypes = true;
        insert newTasksToInsert;
        UtilityFalgs.createWRTasks = false;
        newTasksToInsert.clear();
    }
    //Changes related to ESS PLUS
    
    //Added as part of US133508 and US133511
    Map<id,DateTime> updateCaseNextActionDueDate=new Map<Id,DateTime>();    
    if(Trigger.isinsert && Trigger.isAfter){
        for(Task t: Trigger.New){
            if(t.Type == 'Initial Callback'){
                updateCaseNextActionDueDate.put(t.WhatId,t.Due_Date_SLO__c); 
                UtilityFalgs.isInitialCallBackTaskCreated=false;
            }
            else if(t.type == 'Callback' && (t.Subject==UtilityFalgs.callbackSubject || t.Subject == 'Case Update')&& UtilityFalgs.isCaseReopend){
               
                updateCaseNextActionDueDate.put(t.whatid,t.Due_Date_SLO__c);
            }
        }
        if(updateCaseNextActionDueDate<>null && updateCaseNextActionDueDate.size()>0){
            List<Case> getNextActionDetails=[SELECT ID,Next_Action__c,Next_Action_Due_Date__c,isNextActionOwnerDefault__c FROM CASE where id in:updateCaseNextActionDueDate.keySet() and status!='Closed']; 
            for(Case updateNext:getNextActionDetails){
                if(updateNext.Next_Action_Due_Date__c==null && updateNext.isNextActionOwnerDefault__c){
                    updateNext.Next_Action_Due_Date__c=updateCaseNextActionDueDate.get(updateNext.ID);
                    caseIDNextActionDueDateMap.put(updateNext.ID, updateNext.Next_Action_Due_Date__c);
                }
            }
        }      
    }//End of US133508 and US133511
    
    if(OpenCallBackCaseIds!=null && OpenCallBackCaseIds.size()>0){        
        List<Case> caseReccordList = [Select Id,Case_Type__c ,Open_CB__c,Next_Action_Due_Date__c,Initial_CB_DueDateSLO__c from case where Id in:OpenCallBackCaseIds and Open_CB__c!='Y'];
        for(case rec: caseReccordList){         
            rec.Open_CB__c = 'Y';
            if(caseIDNextActionDueDateMap.containsKey(rec.ID)){//Added as part of US133508 and US133511
                rec.Next_Action_Due_Date__c= caseIDNextActionDueDateMap.get(rec.ID);
                rec.isNextActionOwnerDefault__c=false;               
            }
            //US252305 - Internal Priority : To populate the DueDateSLO on InitialCallback task to case field - 'Initial_CB_DueDateSLO__c'
            if(UtilityFalgs.isInitialCallBackTaskCreated==false){
                //System.debug('^^^Entered test block^^^'+rec.Case_Type__c +'===='+updateCaseNextActionDueDate.get(rec.Id));
                rec.Initial_CB_DueDateSLO__c = updateCaseNextActionDueDate.get(rec.ID);
                
                if(rec.Case_Type__c =='Case Concern'){
                    //System.debug('******'+rec.Initial_CB_DueDateSLO__c);
                    rec.Next_Action_Due_Date__c =rec.Initial_CB_DueDateSLO__c;
                }
            }
            
            updatelistCase.add(rec);
        }
        
    }
    
    if(compTskCaseIdSet!= null && compTskCaseIdSet.size()>0)
        listTask=[select id,call_back_prioirity__c,status,whatid,Due_Date_SLO__c from task where WhatId in: compTskCaseIdSet and Status  !='Closed' and recordTypeid =:SupportRecType  ];
    
    if(listTask!=null && listTask.size()>0){
        for(Task rec:listTask){
            donotUpdateCaseCallBack.add(rec.WhatId); 
            if(rec.Due_Date_SLO__c<System.now())
                donotUpdateCasePriority.add(rec.WhatId);                       
        } 
    }   
    
    for(Id caseRecId :compTskCaseIdSet){
        if(!donotUpdateCaseCallBack.contains(caseRecId))
            updCaseCallBackSet.add(caseRecId);
        if(!donotUpdateCasePriority.contains(caseRecId))   
            updatePriorityCaseSet.add(caseRecId);
    }
    
    if(!UpdInternlPriorityOfCaseSet.isEmpty()) { updateCaseSet.addAll(UpdInternlPriorityOfCaseSet); }
    
    if(!updCaseCallBackSet.isEmpty()) {   updateCaseSet.addAll(updCaseCallBackSet); }
    
    if(!updatePriorityCaseSet.isEmpty()) { updateCaseSet.addAll(updatePriorityCaseSet);  }      
    
    
    if(!updateCaseSet.isEmpty()){
        
        List<case> caseRecLst =[select id,Open_CB__c,Status,Internal_Priority_4__c from case where id in: updateCaseSet];
        
        if(caseRecLst!=null && caseRecLst.size()>0){
            for(Case rec:caseRecLst )
            {          
                boolean caseUpdated =false;
                if(updCaseCallBackSet!=null && updCaseCallBackSet.contains(rec.Id) && rec.Open_CB__c!='N'){ 
                    rec.Open_CB__c='N';
                    caseUpdated =True;
                }
  
                if(UpdInternlPriorityOfCaseSet!=null && UpdInternlPriorityOfCaseSet.contains(rec.Id) && rec.Internal_Priority_4__c!='Y' && rec.Status != 'Closed'){ 
                    rec.Internal_Priority_4__c='Y'; 
                    caseUpdated =True;  
                }   
                
                if(updatePriorityCaseSet!=null && updatePriorityCaseSet.contains(rec.Id) && rec.Internal_Priority_4__c!='N' && rec.Status != 'Closed'){ 
                    rec.Internal_Priority_4__c='N'; 
                    caseUpdated =True;  
                } 
                if(caseUpdated)     
                    updatelistCase.add(rec);     
            }   
            
        }       
    }
    // Added below as a part of DE175176 by Abdul qadir
   /* if(!updateCaseCBSet.isEmpty()){
        
        List<case> caseRecLst =[select id,Open_CB__c from case where id in: updateCaseCBSet];
        
        if(caseRecLst!=null && caseRecLst.size()>0){
            for(Case rec:caseRecLst )
            {
            boolean caseUpdated =false;
               if(updCaseCallBackSet!=null && updCaseCallBackSet.contains(rec.Id) && rec.Open_CB__c!='N'){ 
                    rec.Open_CB__c='N';
                    caseUpdated =True;
                }
                if(caseUpdated)     
                    updatelistCase.add(rec);     
            }   
            }
                        }
*/
    
    if(caseNumbTaskMap!=null && caseNumbTaskMap.size()>0){
        caseList=[select id,CaseNumber from case where CaseNumber in :caseNumbTaskMap.Values()];
        
        
        
        if(caseList!=null && caseList.size()>0)  {
            for(Case caseRec:caseList)
                caseNumMap.put(caseRec.CaseNumber,caseRec.id);
            
            if(caseNumMap!=null && caseNumMap.size()>0) {
                
                List<Task> tasks =[Select Id,Whatid from task where Id in:caseNumbTaskMap.keySet()];
                
                for(Task recTask: tasks) {
                    if(recTask.Case_Number__c!=null && recTask.Whatid==null){
                        recTask.Whatid=caseNumMap.get(recTask.Case_Number__c);
                        tasksToUpdate.add(recTask);
                    }
                }
            }   
        }
    }  
    
    // Tasks of Record Type (Callback and Other Support Record Type) of Service Cloud cannot be deleted  
    Profile currentProfile = TaskGateway.currentUserProfile; 
    String currentProfileName =currentProfile.name; 
    if(Trigger.isDelete){
        for(Task taskRec:Trigger.old){
            //US217005 - Added the Restoration Record Type check in the condition
            if((taskRec.RecordTypeId==Label.Other_Support_Task_Record_Type || taskRec.RecordTypeId ==Label.Service_cloud_Task_Record_Type || taskRec.RecordTypeId== TaskGateway.restorationTaskRecTypeId) && !((currentProfileName!=null && ( currentProfileName.contains( 'Admin')|| (currentProfileName.contains('Integration')) )) )){
                taskRec.addError('You are not allowed to delete Activity record, please click on browser Back button to return back to your case and continue');
            }
        }    
    }
    // Closed Tasks of Record Type (Callback and Other Support Record Type) of Service Cloud cannot be edited 
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Task taskRec:Trigger.New){                    
            task oldTaskRec = trigger.oldmap.get(taskRec.id);
            //US217005 - Added the Restoration Record Type check in the condition
            if((taskRec.RecordTypeId==Label.Other_Support_Task_Record_Type || taskRec.RecordTypeId ==Label.Service_cloud_Task_Record_Type || taskRec.RecordTypeId== TaskGateway.restorationTaskRecTypeId) && (taskRec.Status=='Closed' && oldTaskRec.Status==taskRec.status)&& !((currentProfileName!=null && ( currentProfileName.contains( 'Admin')|| (currentProfileName.contains('Integration')) )) )){
                taskRec.addError('You are not allowed to edit Activity History record, please click on cancel to continue ');
            }
        }  
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Task taskRec:Trigger.New){                    
            task oldTaskRec = trigger.oldmap.get(taskRec.id);
            //US217005 - Added the Restoration Record Type check in the condition
            if((taskRec.RecordTypeId==Label.Other_Support_Task_Record_Type || taskRec.RecordTypeId ==Label.Service_cloud_Task_Record_Type || taskRec.RecordTypeId== TaskGateway.restorationTaskRecTypeId) && ((taskRec.Status=='Open' || taskRec.Status=='In Progress' || taskRec.Status=='Not Started') && (oldTaskRec.Status=='Closed' || oldTaskRec.Status=='Completed'))&& !((currentProfileName!=null && ( currentProfileName.contains( 'Admin')|| (currentProfileName.contains('Integration')) )) )){
                taskRec.addError('You are not allowed to reopen an Activity History record, please click on cancel to continue ');
            }
        }  
    }

    //US217005 - Restoration task cannot be closed manually
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Task taskRec:Trigger.New){                    
            task oldTaskRec = trigger.oldmap.get(taskRec.id);
            if( (taskRec.RecordTypeId== TaskGateway.restorationTaskRecTypeId) && (taskRec.Task_Closure_By_ProcessFlow__c == false) && ((oldTaskRec.Status=='Open' || oldTaskRec.Status=='In Progress' || oldTaskRec.Status=='Not Started') && (taskRec.Status=='Closed' || taskRec.Status=='Completed'))&& !((currentProfileName!=null && ( currentProfileName.contains( 'Admin')|| (currentProfileName.contains('Integration')) )) )){
                taskRec.addError('You are not allowed to edit the restoration task, please click on cancel to continue ');
            }
        }  
    }    
    
    // Logic for Calculated Status Functionality begins here
    Set<Id> caseIdSet = new Set<Id>();
    Set<Task> processCalculatedStatusTaskSet = new  Set<Task>();
    List<GSS_Transactions__c> gssLst = new List<GSS_Transactions__c>();
    List<GSS_Transactions__c> gssInsertLst = new List<GSS_Transactions__c>();
    Map<Id,GSS_Transactions__c>caseGssMap = new Map<Id,GSS_Transactions__c>();
    Map<Id,Case> caseIdMap = new Map<Id,Case>();
    String pmfKey = TaskGateway.currentUserPMFKey;
    if(pmfkey==null || pmfkey==''){
        pmfkey = UserInfo.getName();
    }
    if(Trigger.isInsert && Trigger.isAfter){
        for(Task taskRec : Trigger.new){
            if(taskRec.RecordTypeId == Label.Other_Support_Task_Record_Type && taskRec.Type == 'SE Action' && taskRec.status!='Closed'){
                caseIdSet.add(taskRec.whatId);
                processCalculatedStatusTaskSet.add(taskRec);
                UtilityFalgs.isSEActionTaskCreated = true; //Timeboxing
            }
        }
    }  
    if(Trigger.isUpdate && Trigger.isAfter){
        for(Task taskRec : Trigger.new){
            Task oldRec = (Task)Trigger.OldMap.get(taskRec.id); 
            if(taskRec.RecordTypeId == Label.Other_Support_Task_Record_Type && taskRec.Type == 'SE Action' && taskRec.status!=oldRec.Status && taskRec.Status=='Closed'){
                caseIdSet.add(taskRec.whatId);
                processCalculatedStatusTaskSet.add(taskRec);
            }
        }
    }
    
    //if((Trigger.isInsert || Trigger.isUpdate)&& (processCalculatedStatusTaskSet!=null && processCalculatedStatusTaskSet.size()>0) && Trigger.New[0].Type !='SE Action'){
    if((Trigger.isInsert || Trigger.isUpdate)&& (processCalculatedStatusTaskSet!=null && processCalculatedStatusTaskSet.size()>0) ){    
        List<Case> caseUpdateList = [Select Id , Status , Next_Action__c,Calculated_Status_Transfer_In_Count__c,Calculated_Status_Transfer_Out_Count__c,Date_Time_ReOpened__c,Createddate,Is_Task_Closed__c,Troubleshooting_Stage__c,Restoration_SLA_Disqualified__c  from Case where Id IN :caseIdSet ];
        
        if(caseUpdateList!=null && caseUpdateList.Size()>0){     
            for(Case caseRec : caseUpdateList){
                caseIdMap.put(caseRec.Id,caseRec); 
            } 
            gssLst = [select id,Case__c,Current_Next_Action__c,Current_Status__c,Current_Status_Added_By__c,Curr_Next_Action_By__c,Current_Next_Action_Date__c,
                      Current_Status_Date__c,Current_GSS_TR__c,Current_Next_Action_Due_Date__c,Current_GSS_TR_Date__c ,Previous_Next_Action__c,
                      Previous_GSS_TR__c,Prev_Next_Action_Date__c,Prev_Next_Action_By__c,Prev_Next_Action_Due_Date__c,Previous_GSS_TR_Date__c,Status_From__c, Case_Owner__c,Case_Severity__c,Restoration_SLA_Disqualified__c
                      from GSS_Transactions__c 
                      where Case__c in: caseIdSet and Stage_Count__c = null order by createdDate desc
                     ]; //US108116 - Added the condition Stage_Count__c = null to not consider the troubleshooting stage changes from GSS_Transactions__c object.
                     //US131502 -    - removed from above query , order by LastModifieddate desc 
            if(gssLst!=null && !gssLst.isEmpty()){
                for(GSS_Transactions__c  gssRec: gssLst){
                    if(!caseGssMap.keySet().contains(gssRec.Case__c))
                        caseGssMap.put(gssRec.Case__c,gssRec); 
                }
                
            }
            for(Task taskRec : processCalculatedStatusTaskSet){
                //if(caseIdMap.containsKey(taskRec.whatId) && taskRec.Type != 'SE Action'){
                if(caseIdMap.containsKey(taskRec.whatId) ){
                    Case caseRec = caseIdMap.get(taskRec.whatId);
                   if(taskRec.Status !='Closed'){
                        caseRec.Calculated_Status_Transfer_In_Count__c = caseRec.Calculated_Status_Transfer_In_Count__c+1;
                    }
                    else {  caseRec.Calculated_Status_Transfer_Out_Count__c = caseRec.Calculated_Status_Transfer_Out_Count__c+1;  }
                    GSS_Transactions__c  gssRec1 =null ;
                    GSS_Transactions__c  gssRec2 =null ;
                    
                    if(caseGssMap.containsKey(taskRec.whatId)){               
                        GSS_Transactions__c prevGss = caseGssMap.get(taskRec.whatId);
                        gssRec1 =   new GSS_Transactions__c(
                            Case__c=taskRec.whatid,
                            Previous_GSS_TR__c=prevGss.Current_GSS_TR__c,
                            Current_Next_Action__c=prevGss.Current_Next_Action__c,
                            Current_Status__c=prevGss.Current_Status__c,
                            Current_Status_Added_By__c=pmfkey,
                            Current_Next_Action_Date__c=prevGss.Current_Next_Action_Date__c,
                            Current_Status_Date__c=Datetime.Now(),
                            Prev_Next_Action_Date__c=prevGss.Prev_Next_Action_Date__c,
                            Status_From_Date__c=prevGss.Current_Status_Date__c,
                            Prev_Next_Action_By__c=prevGss.Curr_Next_Action_By__c,
                            Curr_Next_Action_By__c=pmfkey,
                            Previous_Status_Added_By__c=prevGss.Current_Status_Added_By__c,
                            Previous_Next_Action__c=prevGss.Previous_Next_Action__c,
                            Status_From__c=prevGss.Status_From__c,
                            Current_Next_Action_Due_Date__c=prevGss.Current_Next_Action_Due_Date__c,
                            Prev_Next_Action_Due_Date__c=prevGss.Prev_Next_Action_Due_Date__c,
                            Current_GSS_TR_Date__c=Datetime.now(),
                            Previous_GSS_TR_Date__c=prevGss.Current_GSS_TR_Date__c,
                            Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,
                            ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate ,
                            
                            Case_Owner__c = prevGss.Case_Owner__c,
                            Case_Severity__c = prevGss.Case_Severity__c);
                        
                        gssRec2 =   new GSS_Transactions__c(
                            Case__c=taskRec.whatid,
                            Previous_GSS_TR__c=prevGss.Current_GSS_TR__c,
                            Current_Next_Action__c=prevGss.Current_Next_Action__c,
                            Current_Status__c=prevGss.Current_Status__c,
                            Current_Status_Added_By__c=pmfkey,
                            Current_Next_Action_Date__c=prevGss.Current_Next_Action_Date__c,
                            Current_Status_Date__c=Datetime.Now(),
                            Prev_Next_Action_Date__c=prevGss.Prev_Next_Action_Date__c,
                            Status_From_Date__c=prevGss.Current_Status_Date__c,
                            Prev_Next_Action_By__c=prevGss.Curr_Next_Action_By__c,
                            Curr_Next_Action_By__c=pmfkey,
                            Previous_Status_Added_By__c=prevGss.Current_Status_Added_By__c,
                            Previous_Next_Action__c=prevGss.Previous_Next_Action__c,
                            Status_From__c=prevGss.Status_From__c,
                            Current_Next_Action_Due_Date__c=prevGss.Current_Next_Action_Due_Date__c,
                            Prev_Next_Action_Due_Date__c=prevGss.Prev_Next_Action_Due_Date__c,
                            Current_GSS_TR_Date__c=Datetime.now(),
                            Previous_GSS_TR_Date__c=prevGss.Current_GSS_TR_Date__c,
                            Current_Troubleshooting_Stage__c = caseRec.Troubleshooting_Stage__c,
                            ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate,
                            Case_Owner__c = prevGss.Case_Owner__c,
                            Case_Severity__c = prevGss.Case_Severity__c);
                        
                    }   
                    else{
                        gssRec1 =   new GSS_Transactions__c(
                            Case__c=taskRec.whatid,
                            Previous_GSS_TR__c= '',
                            Current_Next_Action__c= '',
                            Current_Status__c= '',
                            Current_Status_Added_By__c=pmfkey,
                            Current_Next_Action_Date__c= null,
                            Current_Status_Date__c=Datetime.Now(),
                            Prev_Next_Action_Date__c=null,
                            Status_From_Date__c= null,
                            Prev_Next_Action_By__c='',
                            Curr_Next_Action_By__c=pmfkey,
                            Previous_Status_Added_By__c='',
                            Previous_Next_Action__c='',
                            Status_From__c='',
                            Current_Next_Action_Due_Date__c=null,
                            Prev_Next_Action_Due_Date__c= null,
                            Current_GSS_TR_Date__c=Datetime.now(),
                            Previous_GSS_TR_Date__c=null,
                            Current_Troubleshooting_Stage__c='',
                            ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate,
                            
                            Case_Owner__c = caseRec.OwnerID,
                            Case_Severity__c = caseRec.Severity__c);
                        
                        gssRec2 =   new GSS_Transactions__c(
                            Case__c=taskRec.whatid,
                            Previous_GSS_TR__c='',
                            Current_Next_Action__c='',
                            Current_Status__c='',
                            Current_Status_Added_By__c=pmfkey,
                            Current_Next_Action_Date__c=null,
                            Current_Status_Date__c=Datetime.Now(),
                            Prev_Next_Action_Date__c= null,
                            Status_From_Date__c= null,
                            Prev_Next_Action_By__c='',
                            Curr_Next_Action_By__c=pmfkey,
                            Previous_Status_Added_By__c='',
                            Previous_Next_Action__c='',
                            Status_From__c='',
                            Current_Next_Action_Due_Date__c=null,
                            Prev_Next_Action_Due_Date__c= null,
                            Current_GSS_TR_Date__c=Datetime.now(),
                            Previous_GSS_TR_Date__c=null,
                            Current_Troubleshooting_Stage__c='',
                            ReOpen_Date__c = caseRec.Date_Time_ReOpened__c!=null ? caseRec.Date_Time_ReOpened__c :caseRec.CreatedDate,
                            
                            Case_Owner__c = caseRec.OwnerID,
                            Case_Severity__c = caseRec.Severity__c);
                        
                        
                    }
                    
                    // US222674 - Added the field 'Restoration_SLA_Disqualified__c' to push to GSS
                    if(caseRec.Restoration_SLA_Disqualified__c == true){
                        gssRec1.Restoration_SLA_Disqualified__c = true;
                        gssRec2.Restoration_SLA_Disqualified__c = true;
                    }
                    if((caseRec.Status=='Open' || caseRec.Status=='Verify') && taskRec.Status!='Closed'){
                        gssRec1.Current_Status__c = 'Transferred';  
                        gssRec2.Current_Status__c = 'Transferred';               
                    }
                    else if(caseRec.Status=='Verify' && taskRec.Status=='Closed' && caseRec.Calculated_Status_Transfer_In_Count__c-caseRec.Calculated_Status_Transfer_Out_Count__c==0){
                        gssRec1.Current_Status__c = 'Pending'; 
                        gssRec2.Current_Status__c = 'Pending'; 
                    }
                    else if(caseRec.Status=='Open' && taskRec.Status=='Closed' && caseRec.Calculated_Status_Transfer_In_Count__c-caseRec.Calculated_Status_Transfer_Out_Count__c==0){
                        gssRec1.Current_Status__c = 'Open'; 
                        gssRec2.Current_Status__c = 'Open'; 
                    } 
                    if(caseRec.Status!='Closed'){
                        if(taskRec.Status!='Closed'){
                            if(caseRec.Calculated_Status_Transfer_In_Count__c==1){
                                gssRec1.Current_GSS_TR__c='T1';
                                gssRec2.Current_GSS_TR__c='X1';
                                UtilityFalgs.createGSS = true;
                            }
                            else if((caseRec.Calculated_Status_Transfer_In_Count__c>1) && (caseRec.Calculated_Status_Transfer_In_Count__c-caseRec.Calculated_Status_Transfer_Out_Count__c==1)){
                                gssRec1.Current_GSS_TR__c='T2';
                                gssRec2.Current_GSS_TR__c='X2';
                                UtilityFalgs.createGSS = true;
                            }
                        }
                        else{  
                            if(caseRec.Calculated_Status_Transfer_In_Count__c- caseRec.Calculated_Status_Transfer_Out_Count__c == 0){     
                                if(caseRec.Is_Task_Closed__c == false ){
                                    gssRec1.Current_GSS_TR__c='X1';
                                    gssRec2.Current_GSS_TR__c='T1';
                                    caseRec.Is_Task_Closed__c=true;
                                    UtilityFalgs.createGSS = true;
                                }
                                else if(caseRec.Is_Task_Closed__c == true ){
                                    gssRec1.Current_GSS_TR__c='X2';
                                    gssRec2.Current_GSS_TR__c='T2';  
                                    UtilityFalgs.createGSS = true;
                                }
                            }
                        }
                    }
                    if(gssRec1.Current_GSS_TR__c!=null && UtilityFalgs.createGSS == true)
                        gssInsertLst.add(gssRec1);   
                    if(gssRec2.Current_GSS_TR__c!=null && UtilityFalgs.createGSS == true)
                        gssInsertLst.add(gssRec2);                         
                } 
            }      
            for(Id idValue : caseIdMap.keySet()){
              updatelistCase.add(caseIdMap.get(idValue));   
            }
            //updatelistCase.add(caseIdMap.values()); 
        }  
    }
   
    
    if(updatelistCase!=null && updatelistCase.size()>0){
        
       System.debug('====='+updatelistCase);
        Database.update(updatelistCase,false);
    }
          
    if(gssInsertLst!=null && gssInsertLst.Size()>0){
        DataBase.insert(gssInsertLst, false);
    }   
    
    // Trigger on task to update the parent id
    
    if(tasksToUpdate!=null && tasksToUpdate.size()>0)
        update tasksToUpdate;
    
    //Validating that the Week End Date Should be a Friday - End
    
    //Checking Duplicates - Start
    Set<string> setUniqueKey = new set<string>();
  /* ***  If(setUserId.size() > 0) //Records Qualify for Checking
    {
        task[] lstDupes ;
        if(Trigger.isUpdate)
            lstDupes = [Select Task_Account_Id__c,id,WhatId,OwnerId,Week_End_Date__c, category__c from Task WHERE ID NOT IN : Trigger.New 
                        AND (Task_Account_Id__c IN :setAccIds OR  Task_Account_Id__c = '' OR  Task_Account_Id__c = null) AND OwnerId IN :setUserId AND Category__c IN : setCategory
                        AND RecordTypeId = : recId];
        else
            lstDupes = [Select Task_Account_Id__c,id,WhatId,OwnerId,Week_End_Date__c, category__c from Task WHERE  
                        (Task_Account_Id__c IN :setAccIds OR  Task_Account_Id__c = ''  OR  Task_Account_Id__c = null) AND OwnerId IN :setUserId AND Category__c IN : setCategory
                        AND RecordTypeId = : recId];
        
        If(lstDupes.size() > 0)
        {
            for(Task t: lstDupes)
            {
                temp_accountid  = t.Task_Account_Id__c;
                if(temp_accountid == null || temp_accountid == '') { temp_accountid ='--'; }
                setUniqueKey.add(temp_accountid +';'+t.OwnerId +';'+ string.valueOf(t.Week_End_Date__c)+';'+t.Category__c);
            }
        }    
    }  ************** */
    // Logic to update the Case modified timestamp and modified by when a task is updated
    
    
    if((Trigger.isAfter && (trigger.isupdate || trigger.isinsert))||(trigger.isbefore && trigger.isDelete))
    {
        supportRt = TaskGateway.supportRecType; //[Select id,Name from RecordType where name like '%Support%' and SobjectType ='Task'];
        set<String> CaidSet=new set<String>();
        //set<Id> caseAlertset=new Set<Id>(); //US78177 - Commented as part of US78177
        List<Case> CaseidList=new List<Case>(); 
        List<Case> caseAlertList = new List<Case>();    
        System.debug('*********Record type = '+SupportRecType);
        if(Trigger.isdelete&&trigger.isbefore)
        {
            for(Task recTask: Trigger.old)
            {
                for(RecordType suportyp :Supportrt )                    
                    if( suportyp.id==recTask.RecordTypeId)                    
                    CaidSet.add(recTask.Whatid);
            }
        }
        else
        {
            for(Task recTask: Trigger.new)
            {
                for(RecordType suportyp :Supportrt )
                {
                    if( suportyp.id==recTask.RecordTypeId)
                        CaidSet.add(recTask.Whatid);
                    //US78177 - Commented as part of US78177
                    /*
                    if(Trigger.isUpdate && (recTask.RecordTypeId ==suportyp.id && suportyp.Name== 'Other Support Task') && (recTask.status=='Completed' || recTask.status=='Closed') && Trigger.OldMap.get(recTask.id).Status!=recTask.Status && recTask.WhatId!=null)
                        caseAlertset.add(recTask.Whatid);
          */
                } 
            }
        }
        /*
        if(Trigger.isInsert)
        {
            for(Task recTask: Trigger.new)
            {
                for(RecordType suportyp :Supportrt )
                {
                    if(recTask.RecordTypeId ==suportyp.id && suportyp.Name== 'Support Callback' && recTask.WhatId!=null && recTask.Type!='Initial Callback' && recTask.Type!='Workaround' && recTask.Type!='Resolution')
                    {
                        caseAlertset.add(recTask.whatId);
                    }
                } 
            }
        } */
        if(CaidSet!=null)
            caseidList=[select id,Case_Type__c from case where id in :CaidSet and status!='Closed'];
        if(caseidList!=null && caseidList.size()>0 && !Test.isRunningTest() && caseidList[0].Case_Type__c !='Case Concern' )
        {
            try
            {
                update caseidList;
            }
            catch(Exception ex)
            {
                String msg=ex.getMessage();
                if(ex.getMessage().contains('VALIDATION_EXCEPTION'))
                    msg=msg.substring(10+msg.indexof('EXCEPTION,'),msg.indexof(': ['));
                if(!Trigger.isDelete) Trigger.new[0].addError(msg+' on the Case.');
                else  Trigger.old[0].addError(msg+' on the Case.');
            }
        }
        //US78177 - Commented as part of US78177
        /*
        System.debug('******caseAlertset'+ UtilityFalgs.sentAlert);
        if(caseAlertset!=null)
            caseAlertList=[select id from Case where id in : caseAlertset];
        if(!UtilityFalgs.sentAlert && caseAlertList != null && caseAlertList.size()>0)
        {
            System.debug('task assign');
            UtilityFalgs.sendMail(caseAlertList);
            UtilityFalgs.sentAlert=true;
        } */
        //US78177 - Commented as part of US78177
    }
    
    //Case updates - end
    //Checking Duplicates - End
    
    //MOVING THE RELATED TO ACCOUNT TO THE NEW ACTIVITY FIELDS - START
  /*  *************  If(setAccIds.size() > 0 || setUserId.size() > 0)
    {
        Map<id,account> mAcc = new Map<id,account>();
        if(setAccIds.size() > 0)
            mAcc = new Map<id,account>([Select id, name, Enterprise_Id__c, Commercial_ID__c from Account Where id in : setAccIds]);
        for(Task t: Trigger.New)
        {
            if(t.recordtypeid == recid)
            {
                
                if((setAccIds.size() > 0) && t.WhatId <> null && (String.ValueOf(t.WhatId).startsWith('001')))
                {
                    t.Task_Account_Name__c  = mAcc.get(t.WhatId).name;
                    t.Task_Account_Id__c = t.WhatId;
                    t.Task_Account_Enterprise_Id__c = mAcc.get(t.WhatId).Enterprise_Id__c;
                    t.Task_Account_Site_Id__c = mAcc.get(t.WhatId).Commercial_ID__c;
                    t.WhatId = null;        
                }
                
                //Duplicate Check - Start
                temp_accountid  = t.Task_Account_Id__c;
                if(temp_accountid == null || temp_accountid == '') { temp_accountid = '--'; }
                
                if(setUniqueKey.contains(temp_accountid +';'+t.OwnerId +';'+ string.valueOf(t.Week_End_Date__c)+';'+t.Category__c))                               
                {
                    t.addError('Duplicate Record. Similar Customer Success Activity Exists for:-' + (t.Task_Account_Name__c <> null? ' Account: ' + t.Task_Account_Name__c:' Empty Account')  +', Date: '+ string.valueOf(t.Week_End_Date__c)+', Category: '+t.Category__c + ' and Assigned To you.' );
                }         
                //Duplicate Check - End    
            }
        }    
    } ****  */ 
    /*Code for CSM SaaS integration 
* Author :PATDH07
* Whenever a Task is created of Saas Op Incident type the External Request is created
*/
    
    List<External_RnD__c> externalRequestList = new List<External_RnD__c>();
    //RecordType[] externalRequestRecordType = [Select id from RecordType where name = 'Saas Ops Incident' and SobjectType ='External_RnD__c'];
   // RecordType[] externalRequestRecordType = TaskGateway.saasOpsRecType;
    Id externalRequestRecordTypeId = TaskGateway.saasOpsRecTypeId ; 
    
    if(trigger.isafter && trigger.isInsert){
        List<Task> taskListForEmailNotifcation = new List<Task>(); //US152151
        for(Task taskRec : trigger.New){
            if(taskRec.Type == 'SaaS Ops Incident'||taskRec.Type =='SaaS Ops Request' ){
                External_RnD__c workReq = new External_RnD__c();
                if(externalRequestRecordTypeId != null){
                     workReq.recordTypeId = externalRequestRecordTypeId  ;                  
                }
               /* if(externalRequestRecordType!=null && externalRequestRecordType.size()>0){
                    workReq.recordTypeId = externalRequestRecordType[0].id;
                }*/
                workReq.Case__c = taskRec.whatId;
                workReq.Subject__c = taskRec.Subject;
                workReq.SaaS_Type__c = taskRec.Type;
                workReq.Severity__c = taskRec.Severity__c;
                workReq.Priority__c = taskRec.Priority;
                workReq.SaaS_Description__c = taskRec.Description;
                workReq.task_Id__c = taskRec.Id ;
                workReq.Due_Date__c = taskrec.ActivityDate;
                externalRequestList.add(workReq);
            }
            //US152151 
            if(taskRec.WhatId != null)
            {
                if(taskRec.Type == 'Email' && String.valueOf(taskRec.WhatId).startsWith('500') && taskRec.Status == 'Completed'){
                        taskListForEmailNotifcation.add(taskRec);                    
                }  
            }
            //US152151 
        }
        //US152151
        if(taskListForEmailNotifcation!=null && taskListForEmailNotifcation.size()>0){
                System.debug('taskListForEmailNotifcation:'+taskListForEmailNotifcation);
                TaskGateway.sendNotificationonEmailTask(taskListForEmailNotifcation);
        }
        //US152151
        insert externalRequestList;
    }
    if(trigger.isafter && trigger.isUpdate){
        
        Set<Id> taskIdUpdateSaasOpsSet = new Set<Id>();
        Map<Id,External_RnD__c> taskIdToExternalRequestMap = new  Map<Id,External_RnD__c>();
        for(Integer i=0;i<trigger.new.size();i++){
            if( (!UtilityFalgs.updateExternalRequest)
               && (trigger.new[i].Type == 'SaaS Ops Incident'||trigger.new[i].Type =='SaaS Ops Request')
               &&( (trigger.new[i].Severity__c!= trigger.old[i].Severity__c)
                  || (trigger.new[i].Priority!= trigger.old[i].Priority) 
                  || (trigger.new[i].ActivityDate!= trigger.old[i].ActivityDate) 
                  || (trigger.new[i].Subject!= trigger.old[i].Subject)
                  || (trigger.new[i].Description!= trigger.old[i].Description)
                 ) 
              ){
                  taskIdUpdateSaasOpsSet.add(trigger.new[i].Id);
              }
        }
        externalRequestList = new List<External_RnD__c>();
        externalRequestList = [select Id , Subject__c , SaaS_Type__c , Severity__c , Priority__c,Due_Date__c,SaaS_Description__c ,task_Id__c,LastModifiedDate
                               from External_RnD__c
                               where task_Id__c IN : taskIdUpdateSaasOpsSet
                               limit:Limits.getLimitQueryRows() - Limits.getQueryRows()
                              ];
        
        if(externalRequestList!=null && externalRequestList.Size()>0){
            for(External_RnD__c externalRequest :externalRequestList ){
                taskIdToExternalRequestMap.put(externalRequest.task_Id__c,externalRequest);
            }
        }
        externalRequestList = new List<External_RnD__c>();
        for(Task taskRec : trigger.New){
            if(taskIdToExternalRequestMap.containskey(taskRec.Id)){
                External_RnD__c externalRequest = taskIdToExternalRequestMap.get(taskRec.Id);
                if(taskRec.LastModifiedDate>externalRequest.LastModifiedDate){
                    externalRequest.Subject__c = taskRec.Subject;
                    externalRequest.Severity__c = taskRec.Severity__c;
                    externalRequest.Priority__c = taskRec.Priority;
                    externalRequest.SaaS_Description__c = taskRec.Description;
                    externalRequest.Due_Date__c = taskrec.ActivityDate;
                    externalRequestList.add(externalRequest);
                }
            }
        }  
        UtilityFalgs.updateExternalRequest = true;
        update externalRequestList;           
    }
    
    //Start of CR:100-208878. Dt 12/29/2014 KUMGA08
    /*    
if(trigger.isDelete){
for(Task t : trigger.old){
String s = t.whatId;
Profile prof =[Select name from profile where id=:userInfo.getProfileId()];
String profName = prof.name;

if(s.subString(0,3)=='500'&&!(profName.contains('Integration')||(profName.contains('Admin'))))
t.addError('Deletion of tasks is not allowed. Please use the browser back button or keyboard backspace to return to the view');
}
}*/
    
    //End of CR:100-208878
    //MOVING THE RELATED TO ACCOUNT TO THE NEW ACTIVITY FIELDS - End
    
}