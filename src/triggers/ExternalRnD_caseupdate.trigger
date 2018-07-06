trigger ExternalRnD_caseupdate on External_RnD__c (after insert, after update, before delete) {
    set<String> CaNumSet=new set<String>();
    List<Case> CaseList=new List<Case>();
    set<String> externalType = new set<String>();//US303641
    
    if((Trigger.isAfter && (trigger.isupdate || trigger.isinsert))||(trigger.isbefore && trigger.isDelete))
    {  
        /* If External Request of Record Type SaaS Ops Incident is created  
* Then Callout to CSM is made to create Incident in CSM 
*/    
        RecordType[] recordtypeList = [select id from RecordType where Name = 'Saas Ops Incident' limit 1];   
        
        if((trigger.isInsert) && trigger.isAfter){
            for(Integer i=0; i<trigger.new.size(); i++){
                // callout should be made only if Record Type is saas ops incident type 
                if((recordtypeList!=null && recordtypeList.size()>0) && (Trigger.New[i].recordtypeid == recordtypeList[0].Id)){
                    //sending the Id of the External Request 
                    CalloutToCSM.createLog(Trigger.New[i].Id);
                    CalloutToCSM.createIncident(Trigger.New[i].Id);
                    
                }
                //US303641
                if(Trigger.New[i].Type__c == 'Solution'){
                   externalType.add(Trigger.New[i].Type__c); 
                }
                //US303641
            }  
        }
        /* If External Request of Record Type SaaS Ops Incident is updated  
* Then Callout to CSM is made to update Incident in CSM 
*/    
        if((trigger.isUpdate) && trigger.isAfter){
            Set<Id> taskIdUpdateSaasOpsSet = new Set<Id>();
            List<Task>taskList = new List<Task>();
            for(Integer i=0; i<trigger.new.size(); i++){
                // For Updates callout should not be made if LastModified user is Saas Ops Integration User
                if((recordtypeList!=null && recordtypeList.size()>0) && (Trigger.New[i].recordtypeid == recordtypeList[0].Id) && (!UserInfo.getUserId().contains(Label.saas_ops_integration_user))){
                    IncidentUpdateRequest incident = new IncidentUpdateRequest();
                    Boolean makeUpdateCallout = false;
                    
                    if(trigger.Old[i].Priority__c!=trigger.new[i].Priority__c){
                        incident.priority = true;
                        makeUpdateCallout = true;
                    }
                    if(trigger.Old[i].Severity__c !=trigger.new[i].Severity__c){
                        incident.severity = true;
                        makeUpdateCallout = true;
                    }
                    if(trigger.Old[i].Due_Date__c !=trigger.new[i].Due_Date__c){
                        incident.dueDate  = true;
                        makeUpdateCallout = true;
                    }
                    if(trigger.Old[i].Subject__c !=trigger.new[i].Subject__c){
                        incident.label  = true;
                        makeUpdateCallout = true;
                    }
                    if(trigger.Old[i].SaaS_Description__c !=trigger.new[i].SaaS_Description__c){
                        incident.description  = true;
                        makeUpdateCallout = true;
                    }
                    if(trigger.Old[i].SaaS_Incident_Status__c !=trigger.new[i].SaaS_Incident_Status__c && trigger.new[i].SaaS_Incident_Status__c=='Cancelled'){
                        CalloutToCSM.cancelIncident(Trigger.New[i].Reference_ID__c);
                    }
                    if(makeUpdateCallout){
                        CalloutToCSM.updateIncident(incident,Trigger.New[i].id);
                    }
                } 
                if((recordtypeList!=null && recordtypeList.size()>0) && (Trigger.New[i].recordtypeid == recordtypeList[0].Id)&& !UtilityFalgs.updateTask){
                    taskIdUpdateSaasOpsSet.add(Trigger.New[i].task_Id__c);
                }   
            }  
            Map<ID, Task> taskMap = new Map<ID, Task>([Select Id, Severity__c ,Priority,ActivityDate,Subject,Description ,LastModifiedDate
                                                       From Task 
                                                       Where ID IN:taskIdUpdateSaasOpsSet
                                                       Limit:Limits.getLimitQueryRows() - Limits.getQueryRows()
                                                      ]); 
            for(External_RnD__c externalReq: Trigger.new) {
                if(taskMap.containsKey(externalReq.task_Id__c)){
                    Task task = taskMap.get(externalReq.task_Id__c);
                    if(externalReq.LastModifiedDate>task.LastModifiedDate){
                        task.Severity__c = externalReq.Severity__c;
                        task.Priority =  externalReq.Priority__c;
                        task.Subject = externalReq.Subject__c ;
                        task.Description = externalReq.SaaS_Description__c ;
                        task.ActivityDate = Date.valueof(externalReq.Due_Date__c) ;
                        if((externalReq.SaaS_Incident_Status__c=='Cancelled') || (externalReq.SaaS_Incident_Status__c=='Closed')){
                            task.Status = 'Closed';
                        }
                        else if(externalReq.SaaS_Incident_Status__c!='New'){
                            task.Status = 'In Progress';
                        }
                        taskList.add(task);
                    }
                }
                
            }                                             
            UtilityFalgs.updateTask = true;
            update taskList;                                          
        }   
        
        
        if(Trigger.isdelete&&trigger.isbefore)
        {
            for(External_RnD__c recrnd: Trigger.old)
            {
                
                CaNumSet.add(recrnd.Case__c);
            }
            
        }
        else
        {
            for(External_RnD__c recrnd: Trigger.new)
            {
                CaNumSet.add(recrnd.Case__c);
                
            }
        }
        if(caNumSet!=null&& CaNumSet.size()>0)
            caseList=[select id,Subject,Case_mgmt_LastUpdatedBy_User__c, Case_mgmt_LastUpdateDT__c from case where id in :CaNumSet]; //Case_mgmt_LastUpdatedBy__c,
        if(caseList!=null && caseList.size()>0)
        {
            try
            {//US303641---START
                if(Trigger.isInsert){
                    if(externalType<>null && externalType.size()>0){
                        List<Case> caseNewList = new List<Case>();
                        for(Case caseObj:caseList){
                            caseObj.Case_mgmt_LastUpdatedBy_User__c = userinfo.getUserId();
                            caseObj.Case_mgmt_LastUpdateDT__c = system.now();
                            caseNewList.add(caseObj);
                        }
                        update caseNewList;    
                    }
                }else{//US303641--END
                  update caseList;
                }
            }
            catch(Exception ex)
            {
                String msg=ex.getMessage();
                if(ex.getMessage().contains('VALIDATION_EXCEPTION'))
                    msg=msg.substring(10+msg.indexof('EXCEPTION,'),msg.indexof(': ['));
                if(!Trigger.isDelete)
                    Trigger.new[0].addError(msg+' on Case');
                else
                    Trigger.old[0].addError(msg+' on Case');
            }
        }
    }
}