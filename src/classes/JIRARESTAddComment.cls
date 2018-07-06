//jira_sfdc
//https://ca--fsb1.cs78.my.salesforce.com/services/apexrest/addcomment.
@RestResource(urlMapping='/addcomment')

global with sharing class JIRARESTAddComment
{
    
    // POST method is used by external system to communicate with SFDC
    @HttpPost
    global static void doPost(String caseId,String comment,String commentType,string Author,string param1,string param2,string param3,string param4)
    {
        /***** Debug request *********/
        System.debug('Case Id -> '+caseId);
        System.debug('Comment -> '+comment);
        System.debug('Comment Type -> '+commentType);
        System.debug('Parame1 -> '+param1+' Parame2 -> '+param2+' Parame3 -> '+param3+' Parame4 -> '+param4);
        /***** Debug request *********/
        
        // accessing config data from custom setting
        Map<string,SFDC_JIRA_CommentType_Config__c> settingMap = SFDC_JIRA_CommentType_Config__c.getAll();
        
        //datetime currentdatetime = system.now();
        //system.debug('Current date..!!'+currentdatetime);
        //datetime NextActionDueDt = currentdatetime.addHours(2);
        datetime NextActionDueDt;
        system.debug('NextAction Duedate..!!'+NextActionDueDt);
        
        // initialize the response
        RestResponse res;
        List<Case> cList = new List<Case>();
        if(!Test.isRunningTest())
            res = RestContext.response;
        else
            res = new RestResponse();   
        // set response header
        res.addHeader('Content-Type', 'application/json');
        // initialize the JSON response
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        
        try
        {
            // set the response status code
            Boolean isSuccess = false;
            res.statusCode = 200;
            // check if caseId is null
            if(caseId != null && caseId != '')
            {
                // check if commentType is null and not configured in Salesforce
                if(commentType != null && commentType != '' && settingMap.containsKey(commentType))
                {
                    if(Id.valueOf(caseId).getSobjectType() == Schema.Case.SObjectType){
                       // querying Case object
                       // cList = new List<Case>([select id,isClosed,Product__c,Time_to_Respond_R_D__c,Acknowledged_by_R_D_At__c,Suggested_Solution__c,Workaround__c,Bug_Confirmed__c,Actual_Engg_Released_Time__c,Actual_Engg_RCA_Time__c,Actual_Engg_Fixed_Time__c,JIRA_Status__c,status,JIRA_Issue_Key__c,JIRA_Affected_component_s__c,Jira_Issue_API_link__c,priority,accountId,Unread__c,recordType.name from Case where id =: caseId Limit 1]);
                       
                       cList = new List<Case>([select id,isClosed,CA_Product_Component__c,BusinessHoursId,Component_Release_Only_Selection__c,CA_Product_Component__r.Name,SE_Action__c,JIRA_Status__c,status,JIRA_Issue_Key__c,Jira_Issue_Id__c,Jira_Issue_API_link__c,priority,Affected_Component_s__c,Bug_Confirmed__c,accountId,Next_Action__c,Next_Action_Due_Date__c,Bug_Fixed__c,Case_Type__c,Workaround__c,CA_Product_Controller__c from Case where id =: caseId Limit 1]);
                    }
                    
                    // get the config setting for current commentType
                    SFDC_JIRA_CommentType_Config__c setting = settingMap.get(commentType);
                    
                    if(!cList.isEmpty()){
                        NextActionDueDt = BusinessHours.addGmt(cList[0].BusinessHoursId, System.now(), 2 * 60 * 60 * 1000L);
                        // if commentType is BASIC
                        if(setting.Apex_Code_Block__c.equalsIgnoreCase('BASIC'))
                        {
                            if(comment == NULL || comment == ''){
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : comment is required');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            } 
                            else{
                                cList[0].SE_Action__c = True;
                                cList[0].Next_Action__c = 'Pending CA Support';
                                cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                isSuccess = TRUE;
                            }                          
                        }
                        
                        // if commentType is KEY_CHANGED
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('KEY'))
                        {
                            if(param1 != null && param1 != ''){
                                // set the custom comment if comment is null
                                if(comment == NULL || comment == '')
                                    comment = 'JIRA Ticket link has been updated.';
                                List<JIRA_Project_Key__c> pk = new List<JIRA_Project_Key__c>([select Name from JIRA_Project_Key__c where JIRA_Project_Key__c =:param1.substring(0, param1.lastIndexOfchar(45)).replace('.',' ') LIMIT 1]);
                                List<CA_Product_Component__c> pCListDot = new List<CA_Product_Component__c>([select Name,id,CA_Product_Controller__c from CA_Product_Component__c where Component_Text__c =:pk[0].Name]);
                                List<CA_Product_Component__c> pCList = new List<CA_Product_Component__c>([select Name,id,CA_Product_Controller__c from CA_Product_Component__c where Component_Text__c =:pk[0].Name.replace('.', ' ').toUpperCase()]);
                                Boolean isCommentFalse=FALSE;
                                if(pCListDot.size()>0){//CA_Product_Controller__c
                                    cList[0].CA_Product_Controller__c = pCListDot[0].CA_Product_Controller__c;
                                    cList[0].CA_Product_Component__c = pCListDot[0].id;
                                    cList[0].Component_Release_Only_Selection__c = null;
                                    cList[0].Product_Material__c=null;
                                    cList[0].Product_Release_Selection__c=null;
                                    //cList[0].Troubleshooting_Stage__c='1. Problem Identification';
                                }else if(pCList.size()>0){
                                    cList[0].CA_Product_Controller__c = pCList[0].CA_Product_Controller__c;
                                    cList[0].CA_Product_Component__c = pCList[0].id;
                                    cList[0].Component_Release_Only_Selection__c = null;
                                    cList[0].Product_Material__c=null;
                                    cList[0].Product_Release_Selection__c=null;
                                    //cList[0].Troubleshooting_Stage__c='1. Problem Identification';
                                    
                                }else{
                                    if(comment != null && comment != ''){
                                        //comment = '[JIRA -> SFDC] -- '+Author+': '+cList[0].JIRA_Issue_Key__c+' status changed from '+cList[0].JIRA_Status__c+' to '+param1+' ';
                                        comment = '[JIRA -> SFDC]  Received KEY_CHANGED message '+param1+',Relavent Component Release could not be found – please get in touch with your SDM!';                                        
                                    }else{
                                        comment = '[JIRA -> SFDC] '+comment+'\n Received KEY_CHANGED message '+param1+',Relavent Component Release could not be found – please get in touch with your SDM!';
                                    }
                                    JiraIntegrationHelper.addComment(caseId,comment);
                                    isSuccess = FALSE;
                                    isCommentFalse = TRUE;
                                }
                                
                                
                                List<Automic_R_D_Component_Version__c> pVerList = new List<Automic_R_D_Component_Version__c>();
                             /*// for(Automic_R_D_Component_Version__c pv: [select id,name,Created_Internally__c,Fixed_Type__c,Version_Jira_Id__c,Fixed_In__c,Actual_Release_Date__c,Planned_Released_Date__c from Automic_R_D_Component_Version__c where Problem__c =: cList[0].id AND Case.Case_Type__c = 'Problem'])
                                */
                                String productValue = '';
                                if(comment != null && comment !=''){
                                    productValue = comment.subString(0, comment.lastIndexOf('.'));
                                    productValue = productValue.subString(productValue.lastIndexOf('to')+3, productValue.length());
                                }
                                for(Automic_R_D_Component_Version__c pv: [select id,name,Created_Internally__c,Fixed_Type__c,Version_Jira_Id__c,Fixed_In__c,Actual_Release_Date__c,Planned_Released_Date__c,Problem__c from Automic_R_D_Component_Version__c where Problem__c =: cList[0].Id]) 
                                {
                                    pv.Problem__c = null;
                                    if(!pv.Name.contains(productValue.toUpperCase())){
                                        pVerList.add(pv);
                                    }
                                }
                                if(!pVerList.isEmpty()){
                                    try {
                                        CheckRecursiveTrigger.isInitiatedByJira=TRUE;        
                                        delete pVerList;
                                        //  Need to reconfirm from Rene **********
                                        //if(componentNotAvailable){
                                          //  Automic_R_D_Component_Version__c automicRDComponentversion = new Automic_R_D_Component_Version__c();
                                           // automicRDComponentversion.Name = param1;
                                            //automicRDComponentversion.Problem__c = cList[0].Id;
                                            //automicRDComponentversion.Fixed_Type__c = '?';
                                            //insert automicRDComponentversion;
                                        //}
                                    } catch (DmlException e) {
                                        isSuccess = FALSE;
                                        gen.writeStringField('message', 'ERROR : unable to remove "Automic R D Component Version" related list.');
                                        gen.writeStringField('errorCode', 'FAILURE');
                                        res.responseBody = Blob.valueOf(gen.getAsString());
                                    }
                                    //update pVerList;
                                }
                                if(cList[0].Jira_Issue_API_link__c!= null  && cList[0].Jira_Issue_API_link__c !=''){
                                    system.debug('1st : '+cList[0].Jira_Issue_API_link__c);
                                        String str = cList[0].Jira_Issue_API_link__c;                                   
                                        Integer ind = str.lastIndexOfchar(047)+1;
                                        String substr = str.substring(0, ind);
                                        substr = substr+param1;
                                       cList[0].Jira_Issue_API_link__c= substr;
                                    system.debug('2nd : '+cList[0].Jira_Issue_API_link__c);
                                }
                                cList[0].JIRA_Issue_Key__c = param1;
                                cList[0].Next_Action__c = 'Pending CA Support';
                                cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                isSuccess = TRUE;

                                if(isCommentFalse){  
                                    isSuccess = FALSE;                                  
                                    gen.writeStringField('message', 'ERROR : Received KEY_CHANGED message '+param1+',Relavent Component Release could not be found – please get in touch with your SDM!');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                            }
                            else{
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : param1 is required with updated issue key');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            }                           
                        }
                        
                        // if commentType is STATUS_CHANGED
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('STATUS'))
                        {
                            if(param1 != null && param1 != ''){
                                // set the custom message if comment is null
                                if(comment == NULL || comment == '')
                                    comment = 'Jira issue status changed from '+cList[0].JIRA_Status__c+' to '+param1;
                                
                                // adding private case comment
                                if(comment != null && comment != ''){
                                  //comment = '[JIRA -> SFDC] -- '+Author+': '+cList[0].JIRA_Issue_Key__c+' status changed from '+cList[0].JIRA_Status__c+' to '+param1+' ';
                                  comment = '[JIRA -> SFDC] '+comment;
                                    JiraIntegrationHelper.addComment(caseId,comment);
                                }
                                
                                // set new status
                                cList[0].JIRA_Status__c = param1;
                                update cList;
                            
                                // set success response, if processing made success 
                                gen.writeStringField('message','SUCCESS');
                                gen.writeStringField('errorCode','SUCCESS');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                                
                                //isSuccess = TRUE;
                            }
                            else{
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : param1 is required with updated issue status');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            }
                        }
                        
                        // if commentType is WORKAROUND
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('WORKAROUND'))
                        {
                            //set status to In Progress
                            if(!cList[0].isClosed)
                                cList[0].status = 'In Progress';
                            // fill the provided workaround
                            cList[0].Workaround__c = param1;
                            cList[0].Next_Action__c = 'Pending CA Support';
                            cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                            // set the custom comment if comment is null
                            if(comment == NULL || comment == '')
                                comment = 'Development team has provided the workaround.';
                            isSuccess = TRUE;    
                        }
                        
                        // if commentType is INFO_NEEDED
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('INFO'))
                        {
                            // update Jira Status to "INFO NEEDED"  
                            cList[0].JIRA_Status__c = 'Info Needed';
                            //cList[0].SE_Action__c = True;
                            cList[0].Next_Action__c = 'Pending CA Support';
                            cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                            //set status to In Progress
                            if(!cList[0].isClosed)
                                cList[0].status = 'In Progress';
                            // set the custom comment if comment is null
                            if(comment == NULL || comment == '')
                                comment = 'Development team has requested more information to investigate the issue.';
                            isSuccess = TRUE;    
                        }
                        
                        
                        // if commentType is COMPONENTS                        
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('COMPONENTS'))
                        {
                            if(cList[0].Case_Type__c == 'Problem'){
                                // set the fix version communicated by JIRA
                                if(param1 != null && param1 != ''){
                                    if(param3 != null && param3 != ''){
                                        Set<String> affectedComponentsAfterUpdate = new Set<String>();
                                           system.debug('COMPONENTS');
                                            //set status to In Progress
                                            if(!cList[0].isClosed)
                                              cList[0].status = 'In Progress';
 
                                            if(cList[0].Affected_Component_s__c != null){
                                              list<String> listAffectedComp = new list<String>();                                            
                                              listAffectedComp = cList[0].Affected_Component_s__c.split(',');
                                              affectedComponentsAfterUpdate.addAll(listAffectedComp);
                                             }   
                                            

                                                if(param1.equalsIgnoreCase('add')){
                                                   affectedComponentsAfterUpdate.add(param3.trim());
                                                   String componentSetToString = '';
                                                    for(String s:affectedComponentsAfterUpdate) {
                                                       componentSetToString += (componentSetToString==''?'':',')+s;
                                                    }
                                                    cList[0].Affected_Component_s__c = componentSetToString; 
                                                }
                                                else if(param1.equalsIgnoreCase('remove')){
                                                   affectedComponentsAfterUpdate.remove(param3.trim());
                                                   String componentSetToString = '';
                                                    for(String s:affectedComponentsAfterUpdate) {
                                                       componentSetToString += (componentSetToString==''?'':',')+s;
                                                    }
                                                    cList[0].Affected_Component_s__c = componentSetToString; 
                                                }
                                                /***********************************/
                                                // set the custom comment if comment is null
                                                if(comment == NULL || comment == '')
                                                    comment = 'Affected component has been communicated by JIRA.';
                                                    isSuccess = TRUE;
                                            
                                    }else{
                                        isSuccess = FALSE;
                                        gen.writeStringField('message', 'ERROR : param3 is required with Component Name.');
                                        gen.writeStringField('errorCode', 'FAILURE');
                                        res.responseBody = Blob.valueOf(gen.getAsString());
                                    }
                                }else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : param1 is required with add/remove value');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                            }
                            else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : commentType is not valid for Incident type of ticket');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        }
                        
                        // if commentType is SOLUTION_FOUND (only for INC)
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('SOLUTION'))
                        {
                            if(cList[0].Case_Type__c == 'Standard' && param2.equalsIgnoreCase('INCIDENT')){
                                //set status to In Progress
                                if(!cList[0].isClosed)
                                    cList[0].status = 'In Progress';
                                // set the jira status with resolution
                                cList[0].JIRA_Status__c = 'Closed ('+(param1!=null?param1:'')+')';
                                cList[0].SE_Action__c = True;
                                cList[0].Next_Action__c = 'Pending CA Support';
                                cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                // set the custom comment if comment is null
                                if(comment == NULL || comment == '')
                                    comment = 'Development team has requested more information to investigate the issue.';
                                
                                isSuccess = TRUE;  
                            }  
                            else if(cList[0].Case_Type__c == 'Problem'){
                                //set status to In Progress
                                if(!cList[0].isClosed)
                                    cList[0].status = 'In Progress';
                                // set JIRA status with resolution
                                cList[0].JIRA_Status__c = 'Closed ('+(param1!=null?param1:'')+')';
                                cList[0].SE_Action__c = True;
                                cList[0].Next_Action__c = 'Pending CA Support';
                                cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                // set the custom comment if comment is null
                                if(comment == NULL || comment == '')
                                    comment = 'Development team has identified that raised issue is not a bug.';
                                
/**

                                        List<Automic_R_D_Component_Version__c> autoRDVersion1 = new List<Automic_R_D_Component_Version__c>();
                                        

*/

                                List<Automic_R_D_Component_Version__c> pVerList = new List<Automic_R_D_Component_Version__c>();
                                List<Automic_R_D_Component_Version__c> autoRDVersion = new List<Automic_R_D_Component_Version__c>(
                                            [select id,Name,Version_Jira_Id__c,Planned_Released_Date__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,
                                            Component_Release__c,Fixed_Type_display__c 
                                                from Automic_R_D_Component_Version__c where  Problem__c =: cList[0].Id]);
                                Map<String,Integer> m = new Map<String,Integer>();
                                for(Automic_R_D_Component_Version__c ar: autoRDVersion){
                                    system.debug('ar.name : '+ar.name);
                                    if(m.values().size()>0){
                                        if(m.get(ar.Name)>=1){
                                            m.put(ar.name,m.get(ar.name)+1);
                                        }else{
                                            m.put(ar.name,1);
                                        }
                                    }else{
                                        m.put(ar.name,1);
                                    }

                                }
                                for(String s:m.keyset()){
                                    system.debug('key : '+s);
                                }
                                List<Automic_R_D_Component_Version__c> rDelete = new List<Automic_R_D_Component_Version__c>();
                                /*for(Automic_R_D_Component_Version__c pv: [select id,name,Created_Internally__c,Fixed_Type__c,Version_Jira_Id__c,Fixed_In__c,Actual_Release_Date__c,Planned_Released_Date__c from Automic_R_D_Component_Version__c where Problem__c =: cList[0].Id]) 
                                {
                                    pv.Fixed_In__c = null;
                                    //pv.Version_Jira_Id__c = null;
                                    //pv.Fixed_Type__c = null;
                                    pv.Fixed_Type__c = '--No Fix--';
                                    pv.Actual_Release_Date__c = null;
                                    pv.Planned_Released_Date__c = null;
                                    pv.Created_Internally__c = false;
                                    pVerList.add(pv);
                                }
                                if(!pVerList.isEmpty())
                                    update pVerList;*/
                                system.debug('****:'+autoRDVersion);
                                for(Automic_R_D_Component_Version__c ard : autoRDVersion){
                                    if(m.get(ard.name)>1){
                                        system.debug('in delete: '+param3);
                                        rDelete.add(ard);
                                        m.put(ard.name,m.get(ard.name)-1);
                                    }else{
                                        system.debug('12 in delete: '+param3);
                                        ard.Fixed_In__c = null;
                                        ard.Version_Jira_Id__c = null;
                                        ard.jira_Version__c = param3;
                                        ard.Fixed_Type__c = '--No Fix--';
                                        ard.Actual_Release_Date__c = null;
                                        ard.Planned_Released_Date__c = null;   
                                        pVerList.add(ard);
                                    }
                                }
                                if(pVerList.size()>0){
                                    update pVerList;
                                }
                                if(rDelete.size()>0)
                                    CheckRecursiveTrigger.isInitiatedByJira=TRUE;        
                                    delete rDelete;
                                // start "Solution Notification" OLA
                                //cList[0].Bug_Confirmed__c = FALSE;
                                
                                // if NOT_BUG identified at the time of fixing the bug by Development team
                            /*  if (cList[0].Actual_Engg_Fixed_Time__c == null && param2.equalsIgnoreCase('BUG')) {
                                    cList[0].Actual_Engg_Fixed_Time__c = DateTime.now();
                                    // Stop "Waiting Analysis" OLA
                                    Set<string> OlaNames = new Set<string>{'Waiting Fix in Engineering','RCA'};
                                    BLogic_JiraIntegrationHelper.stopOLA(OlaNames,caseId);
                                }
                                // if NOT_BUG identified at the time of RCA by Development team
                                else if(cList[0].Actual_Engg_RCA_Time__c == null && param2.equalsIgnoreCase('PROBLEM')) {
                                    cList[0].Actual_Engg_RCA_Time__c = DateTime.now();
                                    // Stop "Waiting Analysis" OLA
                                    Set<string> OlaNames = new Set<string>{'Waiting Analysis in Engineering','RCA'};
                                    BLogic_JiraIntegrationHelper.stopOLA(OlaNames,caseId);
                                } */
                                isSuccess = TRUE;
                            }
                            else if(cList[0].Case_Type__c == 'Standard' && param2.equalsIgnoreCase('BUG')){
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : Jira ticket has been marked as a BUG, which is not a valid scenario for an incident.');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            }
                        }

                        // if commentType is BUG_CONFIRMED(only for PRB)
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('BUGCONFIRM'))
                        {
                                if(cList[0].Case_Type__c == 'Problem'){
                                    //set status to In Progress
                                    if(!cList[0].isClosed)
                                        cList[0].status = 'In Progress';
                                    // set the custom comment if comment is null
                                    if(comment == NULL || comment == '')
                                        comment = 'Development team has confirmed the bug.';
                                    // updates all versions
                                    List<Automic_R_D_Component_Version__c> versionsList = new List<Automic_R_D_Component_Version__c>();
                                    for(Automic_R_D_Component_Version__c pVer: [select id,Created_Internally__c from Automic_R_D_Component_Version__c where Problem__c =: cList[0].Id AND Created_Internally__c=true])
                                    {
                                      pVer.Created_Internally__c = FALSE;
                                      versionsList.add(pVer);
                                    }
                                    if(!versionsList.isEmpty())
                                        update versionsList;
                                    List<String> fixedInStr=new List<String>();
                                    List<Automic_R_D_Component_Version__c> versionsListDummy = new List<Automic_R_D_Component_Version__c>();
                                    for(Automic_R_D_Component_Version__c pVer: [select id,Version_Jira_Id__c,Planned_Released_Date__c,jira_Version__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c from Automic_R_D_Component_Version__c where Problem__c=:caseId and Fixed_Type__c = '?'])
                                    {
                                        pVer.Fixed_Type__c='--No Fix--';
                                        versionsListDummy.add(pVer);
                                    }

                                    if(!versionsListDummy.isEmpty())
                                        update versionsListDummy;
                                        
                                   // start "Waiting Fix" OLA
                                   // cList[0].Actual_Engg_RCA_Time__c = DateTime.now();
                                    cList[0].Bug_Confirmed__c = TRUE;
                                    cList[0].Next_Action__c = 'Pending CA Support';
                                    cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                   // Stop "Waiting Analysis" OLA
                                   /* Set<string> OlaNames = new Set<string>{'Waiting Analysis in Engineering','RCA'};
                                    BLogic_JiraIntegrationHelper.stopOLA(OlaNames,caseId); */
                                    isSuccess = TRUE;
                                }
                                else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : commentType is not valid for Incident type of ticket');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        }
                        // if commentType is FIX_VERSION(only for PRB)
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('VERSION')){
                            if(param1 == null || param1 == ''){
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : param1 is required with add/remove value');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            }
                            else if(param3 == null || param3 == ''){
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : param3 is required with version-ID');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                            }
                            else if(cList[0].Case_Type__c == 'Problem'){//Bug_Confirmed__c
                                
                                String str = param3;                                   
                                Integer ind = str.indexOfchar(032)+1;       
                                Integer indPeriod = str.indexOf('.',ind);
                                String ComponentRelease = str.substring(ind,indPeriod+2);
                                String ComponentNameRD = str.substring(0, ind-1).replace('.', ' ').toUpperCase()+' '+ComponentRelease;
                                
                                if(param1.equalsIgnoreCase('add')){
                                    system.debug('add begin : '+ComponentNameRD+ ' : '+param2);
                                    List<Automic_R_D_Component_Version__c> autoRDVersion = new List<Automic_R_D_Component_Version__c>([
                                            select id,jira_Version__c,Version_Jira_Id__c,Planned_Released_Date__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c 
                                                from Automic_R_D_Component_Version__c where name =:ComponentNameRD and Problem__c=:caseId and (Fixed_Type__c=:param2 ) LIMIT 1 ]);
                                    List<Automic_R_D_Component_Version__c> autoRDVersion1 = new List<Automic_R_D_Component_Version__c>([
                                                select id,jira_Version__c,Version_Jira_Id__c,Planned_Released_Date__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c 
                                                    from Automic_R_D_Component_Version__c where name =:ComponentNameRD and Problem__c=:caseId and (Fixed_Type__c LIKE '--No Fix--' or Fixed_Type__c='?' ) LIMIT 1 ]);
                                    if(cList[0].Bug_fixed__c){//replace this with bug fixed
                                        
                                        if (autoRDVersion.isEmpty()){
                                            system.debug('1 add : ');
                                            // TASK - Check and get the component release version ID from componenet release object 
                                            //
                                            //List<Component_Release__c> comRelease = new List<Component_Release__c>([SELECT ID,Component_Text__c ,Component_Release__c  from Component_Release__c where Component_Text__c like :ComponentText and Component_Release__c =:ComponentRelease  LIMIT 1]);
                                            //if (!comRelease.isEmpty()){
                                            
                                            if(autoRDVersion1.isEmpty()){
                                                if(param4 != '' && param4 != 'N/A' ){
                                                    Automic_R_D_Component_Version__c newversion=new Automic_R_D_Component_Version__c(
                                                        Name=ComponentNameRD,jira_Version__c=param3,Fixed_In__c=param3, Fixed_Type__c=param2,
                                                        Problem__c=caseId,Planned_Released_Date__c=Date.valueOf(param4.substring(0, param4.lastIndexOfchar(032))));
                                                    insert newversion;
                                                }else{
                                                    Automic_R_D_Component_Version__c newversion=new Automic_R_D_Component_Version__c(
                                                        Name=ComponentNameRD,jira_Version__c=param3,Fixed_In__c=param3, Fixed_Type__c=param2,
                                                        Problem__c=caseId);
                                                    insert newversion;
                                                }
                                            }else{

                                                system.debug('2 add : '+autoRDVersion1[0].jira_Version__c + ' : ' + autoRDVersion1[0].Fixed_Type__c);
                                                autoRDVersion1[0].jira_Version__c=param3;
                                                autoRDVersion1[0].Fixed_Type__c=param2;
                                                autoRDVersion1[0].Fixed_In__c=param3;
                                                if(param4 != '' && param4 != 'N/A' ){
                                                    autoRDVersion1[0].Planned_Released_Date__c=Date.valueOf(param4.substring(0, param4.lastIndexOfchar(032)));
                                                }
                                                update autoRDVersion1;      
                                            }
                                            
                                            /*}else{
                                            System.debug('else param3 -> '+param3+' ComponentNameRD -> '+ComponentNameRD);
                                                 isSuccess = FALSE;
                                                 gen.writeStringField('message', 'ERROR : Component Release not found');
                                                 gen.writeStringField('errorCode', 'FAILURE');
                                                 res.responseBody = Blob.valueOf(gen.getAsString());
                                                 System.debug('else end param3 -> '+param3+' ComponentNameRD -> '+ComponentNameRD);
                                            }*/
                                        }else{
                                            system.debug('3 add : '+autoRDVersion[0].jira_Version__c + ' : ' + autoRDVersion[0].Fixed_Type__c);
                                            autoRDVersion[0].jira_Version__c=param3;
                                            autoRDVersion[0].Fixed_Type__c=param2;
                                            autoRDVersion[0].Fixed_In__c=param3;
                                            if(param4 != '' && param4 != 'N/A' ){
                                                autoRDVersion[0].Planned_Released_Date__c=Date.valueOf(param4.substring(0, param4.lastIndexOfchar(032)));
                                            }
                                            update autoRDVersion;
                                        }
                                    }else{
                                        system.debug('4 add : ');
                                        if (autoRDVersion.isEmpty() && autoRDVersion1.isEmpty()){
                                            Automic_R_D_Component_Version__c newversion=new Automic_R_D_Component_Version__c(
                                                Name=ComponentNameRD,jira_Version__c=param3, Fixed_Type__c=param2,Problem__c=caseId);  
                                            insert newversion;
                                        }else if(!autoRDVersion1.isEmpty()){
                                            system.debug('4 add : sub');
                                            autoRDVersion1[0].jira_Version__c=param3;
                                            autoRDVersion1[0].Fixed_Type__c=param2;
                                            autoRDVersion1[0].Fixed_In__c=null;
                                            autoRDVersion1[0].Planned_Released_Date__c=null;
                                            update autoRDVersion1;
                                        }else{
                                            if(autoRDVersion[0].Fixed_Type__c==param2){
                                                autoRDVersion[0].jira_Version__c=param3;
                                                autoRDVersion[0].Fixed_Type__c=param2;
                                                autoRDVersion[0].Fixed_In__c=null;
                                                autoRDVersion[0].Planned_Released_Date__c=null;
                                                update autoRDVersion;
                                            }else{
                                                Automic_R_D_Component_Version__c newversion=new Automic_R_D_Component_Version__c(
                                                    Name=ComponentNameRD,jira_Version__c=param3, Fixed_Type__c=param2,Problem__c=caseId);  
                                                insert newversion;
                                            }
                                           
                                            
                                        }
                                        
                                    }
                                    List<Automic_Version__c> autoVersion = new List<Automic_Version__c>(
                                        [select jira_Version__c,id,Version_Jira_Id__c,Planned_Released_Date__c,Fix_Type__c,Fixed_In__c,Actual_Release_Date__c, Problem_Case__c 
                                            from Automic_Version__c where name =:ComponentNameRD and (Fix_Type__c=:param2 ) and Problem_Case__c = :caseId  LIMIT 1 ]);
                                    if (autoVersion.isEmpty()){       
                                        system.debug('5 add : ');                              
                                        if(param4 != '' && param4 != 'N/A' ){
                                            Automic_Version__c newversion=new Automic_Version__c(Problem_Case__c = caseId, Name=ComponentNameRD,jira_Version__c=param3,Fixed_In__c=param3, Fix_Type__c=param2,Planned_Released_Date__c=Date.valueOf(param4.substring(0, param4.lastIndexOfchar(032))));
                                            insert newversion;
                                        }else{
                                            Automic_Version__c newversion=new Automic_Version__c(Problem_Case__c = caseId, Name=ComponentNameRD,jira_Version__c=param3,Fixed_In__c=param3, Fix_Type__c=param2);
                                            insert newversion;
                                        }

                                        cList[0].Next_Action__c = 'Pending CA Support';
                                        cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                        isSuccess = TRUE;
                                    }else{
                                        system.debug('6 add : '+autoVersion[0].jira_Version__c);        
                                        autoVersion[0].jira_Version__c=param3;
                                        autoVersion[0].Fix_Type__c=param2;
                                        autoVersion[0].Fixed_In__c=param3;
                                        autoVersion[0].Actual_Release_Date__c=null;
                                        if(param4 != '' && param4 != 'N/A' ){
                                            autoVersion[0].Planned_Released_Date__c=Date.valueOf(param4.substring(0, param4.lastIndexOfchar(032)));
                                        }
                                        update autoVersion;

                                        cList[0].Next_Action__c = 'Pending CA Support';
                                        cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                        isSuccess = TRUE;
                                    }
                                    
                                }
                                else if(param1.equalsIgnoreCase('remove')){                       
                                        List<Automic_R_D_Component_Version__c> autoRDVersion = new List<Automic_R_D_Component_Version__c>(
                                            [select id,Version_Jira_Id__c,jira_Version__c,Planned_Released_Date__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c, Problem__c 
                                                from Automic_R_D_Component_Version__c where name =:ComponentNameRD and Problem__c=:cList[0].id  ]);

                                        List<Automic_R_D_Component_Version__c> autoRDVersion1 = new List<Automic_R_D_Component_Version__c>();
                                        Automic_R_D_Component_Version__c rDelete;
                                        for(Automic_R_D_Component_Version__c ard : autoRDVersion){
                                            if(ard.jira_Version__c==param3 && autoRDVersion.size()>1){
                                                rDelete=new Automic_R_D_Component_Version__c(id=ard.id);
                                            }else if(ard.jira_Version__c==param3 && autoRDVersion.size()==1){
                                                ard.Fixed_In__c = null;
                                                ard.Version_Jira_Id__c = null;
                                                ard.jira_Version__c = param3;
                                                ard.Fixed_Type__c = '--No Fix--';
                                                ard.Actual_Release_Date__c = null;
                                                ard.Planned_Released_Date__c = null;   
                                                autoRDVersion1.add(ard);
                                            }
                                        }
                                        if(autoRDVersion1.size()>0){
                                            update autoRDVersion1;
                                        }
                                        if(rDelete!=null){
                                            CheckRecursiveTrigger.isInitiatedByJira=TRUE; 
                                            delete rDelete;       
                                        }
                                        
                                        system.debug('remove end : ');
                                        
                                    cList[0].Next_Action__c = 'Pending CA Support';
                                    cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                    isSuccess = TRUE;
                                }    
                            }
                        }
                        
                        // if commentType is FIX_VERSION(only for PRB)
                        /**
                        


                        *//*
                      else if(setting.Apex_Code_Block__c.equalsIgnoreCase('VERSION'))
                        {
                            if(cList[0].recordType.name == 'Problem'){
                                // set the fix version communicated by JIRA
                                if(param1 != null && param1 != ''){
                                    if(param2 != null && param2 != ''){
                                        
                                            //set status to In Progress
                                            if(!cList[0].isClosed)
                                                cList[0].status = 'In Progress';
                               
                                            // get the version name as per jira version ids
                                            List<Depman_Version__c> depVersions = new List<Depman_Version__c>([select id,major__c,minor__c,Version_Type__c,released_Date__c,custom_basedisplay__c from Depman_Version__c where version_foreign_id_jira__c =: Decimal.valueOf(param2) LIMIT 1]);
                                            //string versionNames = BLogic_JiraIntegrationHelper.getVersionNameById(param2);
                                            if(!depVersions.isEmpty())
                                            {
                                                if(param1.equalsIgnoreCase('add')){
                                                    Map<string,Product_Version__c> majorMinorTypeMap = new Map<string,Product_Version__c>();
                                                    Map<string,Product_Version__c> majorMinorMap = new Map<string,Product_Version__c>();
                                                    for(Product_Version__c pVer: [select id,name,Fixed_Type__c,Version_Jira_Id__c,Fixed_In__c from Product_Version__c where Problem__c =: cList[0].id]){
                                                        if(pVer.Fixed_Type__c == null)
                                                            majorMinorMap.put(pVer.name.replace(cList[0].Product__c,'').trim(),pVer);
                                                        else{
                                                            string key = pVer.name.replace(cList[0].Product__c,'').trim()+'.'+pVer.Fixed_Type__c;
                                                            majorMinorTypeMap.put(key,pVer);
                                                        }
                                                    }
                                                    Product_Version__c newVer;
                                                    // checking if major,minor and fixed type do match
                                                    string depmanVerNamewithType = depVersions[0].major__c+'.'+depVersions[0].minor__c+'.'+depVersions[0].Version_Type__c;
                                                    system.debug('depmanVerNamewithType '+depmanVerNamewithType);
                                                    if(majorMinorTypeMap.containsKey(depmanVerNamewithType))
                                                        newVer = majorMinorTypeMap.get(depmanVerNamewithType);
                                                    else if(majorMinorMap.containsKey(depVersions[0].major__c+'.'+depVersions[0].minor__c))
                                                        newVer = majorMinorMap.get(depVersions[0].major__c+'.'+depVersions[0].minor__c);
                                                   system.debug('newVer '+newVer); 
                                                    if(newVer != null)
                                                    {
                                                        //newVer.Fixed_In__c = depVersions[0].custom_basedisplay__c;
                                                        newVer.Version_Jira_Id__c = param2;
                                                        newVer.Fixed_Type__c = depVersions[0].Version_Type__c;
                                                        update newVer;
                                                    }
                                                    else{
                                                        newVer = new Product_Version__c(name=cList[0].Product__c+' '+depVersions[0].major__c+'.'+depVersions[0].minor__c);
                                                        newVer.Fixed_Type__c = depVersions[0].Version_Type__c;
                                                        //newVer.Planned_Released_Date__c = depVersions[0].released_Date__c;
                                                        //newVer.Fixed_In__c = depVersions[0].custom_basedisplay__c;
                                                        newVer.Version_Jira_Id__c = param2;
                                                        newVer.Problem__c = cList[0].id;
                                                        BLogic_TriggerRecursionHandler.isInitiatedByJira = TRUE;
                                                        insert newVer;
                                                        BLogic_TriggerRecursionHandler.isInitiatedByJira  = FALSE;
                                                    }
                                                }
                                                else if(param1.equalsIgnoreCase('remove')){
                                                    List<Product_Version__c> pVerList = new List<Product_Version__c>([select id,name,Fixed_Type__c,Version_Jira_Id__c,Fixed_In__c from Product_Version__c where Version_Jira_Id__c =: param2 AND Problem__c =: cList[0].id]);
                                                    if(!pVerList.isEmpty()){
                                                        pVerList[0].Fixed_In__c = null;
                                                        pVerList[0].Version_Jira_Id__c = null;
                                                     // pVerList[0].Fixed_Type__c = null;
                                                        pVerList[0].Fixed_Type__c = '--No Fix--';
                                                        update pVerList;
                                                    }
                                                }
                                               
                                                // set the custom comment if comment is null
                                                if(comment == NULL || comment == '')
                                                    comment = 'Fixed Version has been communicated by JIRA.';
                                                isSuccess = TRUE;
                                            }
                                            else{
                                                isSuccess = FALSE;
                                                gen.writeStringField('message', 'ERROR : Version-ID is not valid');
                                                gen.writeStringField('errorCode', 'FAILURE');
                                                res.responseBody = Blob.valueOf(gen.getAsString());
                                            }
                                    }
                                    else{
                                        isSuccess = FALSE;
                                        gen.writeStringField('message', 'ERROR : param2 is required with version-ID');
                                        gen.writeStringField('errorCode', 'FAILURE');
                                        res.responseBody = Blob.valueOf(gen.getAsString());
                                    }
                                }
                                else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : param1 is required with add/remove value');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                            }
                            else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : commentType is not valid for Incident type of ticket');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        } */
                        
                        
                        // if commentType is BUG_FIXED(only for PRB)
                      else if(setting.Apex_Code_Block__c.equalsIgnoreCase('BUGFIXED'))
                        {
                            if(cList[0].Case_Type__c == 'Problem'){
                                //set status to In Progress
                                if(!cList[0].isClosed)
                                    cList[0].status = 'In Progress';
                                // set the JIRA status with resolution
                                //cList[0].SE_Action__c = True;
                                cList[0].JIRA_Status__c = 'Closed ('+(param1!=null?param1:'')+')';
                                cList[0].Next_Action__c = 'Pending CA Support';
                                cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                // updating all versions with planned release date
                                List<Automic_R_D_Component_Version__c> autoRDVersion = new List<Automic_R_D_Component_Version__c>(
                                    [select id,Version_Jira_Id__c,Planned_Released_Date__c,jira_Version__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c 
                                        from Automic_R_D_Component_Version__c where Problem__c=:caseId ]);
                                List<Automic_Version__c> autoVersion = new List<Automic_Version__c>(
                                    [select id,Version_Jira_Id__c,jira_Version__c,Planned_Released_Date__c,Fix_Type__c,Fixed_In__c,Actual_Release_Date__c,ca_release_version__c 
                                        from Automic_Version__c where Problem_Case__c=:caseId ]);
                                Map<String, Automic_Version__c> m = new Map<String, Automic_Version__c>();
                                for(Automic_Version__c avc:autoVersion){
                                    m.put(avc.jira_Version__c,avc);
                                }
                                List<Automic_R_D_Component_Version__c> autoRDVersionList = new List<Automic_R_D_Component_Version__c>();
                                if (autoRDVersion.isEmpty()){
                                    if(!autoVersion.isEmpty()){
                                    system.debug('BUG_FIXED Name='+ autoVersion[0].ca_release_version__c);
                                        Automic_R_D_Component_Version__c newversion=new Automic_R_D_Component_Version__c(
                                            ca_release_version__c=autoVersion[0].ca_release_version__c, Actual_Release_Date__c=autoVersion[0].Actual_Release_Date__c,
                                            jira_Version__c=autoVersion[0].jira_Version__c,Fixed_In__c=autoVersion[0].Fixed_In__c, 
                                            Fixed_Type__c=autoVersion[0].Fix_Type__c,Problem__c=caseId,Planned_Released_Date__c=autoVersion[0].Planned_Released_Date__c);
                                        insert newversion;
                                    }
                                }else if(!autoVersion.isEmpty()){
                                    for(Automic_R_D_Component_Version__c ardc:autoRDVersion){
                                        if(m.get(ardc.jira_Version__c)!=null && ardc.Fixed_Type__c != '--No Fix--' ){
                                            ardc.jira_Version__c=m.get(ardc.jira_Version__c).jira_Version__c;
                                            ardc.Fixed_Type__c=m.get(ardc.jira_Version__c).Fix_Type__c;
                                            ardc.Fixed_In__c=m.get(ardc.jira_Version__c).Fixed_In__c;
                                            ardc.Actual_Release_Date__c=m.get(ardc.jira_Version__c).Actual_Release_Date__c;
                                            ardc.Planned_Released_Date__c=m.get(ardc.jira_Version__c).Planned_Released_Date__c;
                                            autoRDVersionList.add(ardc);
                                        }
                                    }
                                    if(autoRDVersionList.size()>0)
                                        update autoRDVersionList;
                                }
                                cList[0].Bug_fixed__c = true;
                                isSuccess = TRUE;
                            }
                            else{
                                isSuccess = FALSE;
                                gen.writeStringField('message', 'ERROR : commentType is not valid for Incident type of ticket');
                                gen.writeStringField('errorCode', 'FAILURE');
                                res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        }
                        
                        // if commentType is VERSION_RELEASED(only for PRB)
                        
                        else if(setting.Apex_Code_Block__c.equalsIgnoreCase('RELEASED'))
                        {
                            if(cList[0].Case_Type__c == 'Problem'){
                                // set the released version
                                //if(param1 != null && param1 != ''){
                                    
                                    //set status to In Progress
                                    if(!cList[0].isClosed)
                                        cList[0].status = 'In Progress';
                                    
                                    if(cList[0].Bug_fixed__c){
                                        List<Automic_R_D_Component_Version__c> versionsList = new List<Automic_R_D_Component_Version__c>();
                                        for(Automic_R_D_Component_Version__c pVer: [select id,Version_Jira_Id__c,Planned_Released_Date__c,Fixed_Type__c,Fixed_In__c,Actual_Release_Date__c,Component_Release__c,Fixed_Type_display__c 
                                                    from Automic_R_D_Component_Version__c where  Problem__c =: cList[0].Id and Fixed_In__c = :param2 ])
                                        {
                                            if(param3 != '' && param3 != 'N/A' ){
                                                pVer.Actual_Release_Date__c = Date.valueOf(param3);
                                            }
                                            versionsList.add(pVer);
                                        }
                                        if(!versionsList.isEmpty())
                                            update versionsList;
                                    }
                                    List<Automic_Version__c> validVersionsList = new List<Automic_Version__c>([select id,Version_Jira_Id__c,Planned_Released_Date__c,Fix_Type__c,Fixed_In__c,Actual_Release_Date__c 
                                                from Automic_Version__c where  Problem_Case__c =: cList[0].Id and Fixed_In__c = :param2 ]);
                                    if(validVersionsList.size()>0){
                                         List<Automic_Version__c> versionsList = new List<Automic_Version__c>();
                                        for(Automic_Version__c pVer: [select id,Version_Jira_Id__c,Planned_Released_Date__c,Fix_Type__c,Fixed_In__c,Actual_Release_Date__c 
                                                    from Automic_Version__c where  Problem_Case__c =: cList[0].Id and Fixed_In__c = :param2 ])
                                        {
                                            if(param3 != '' && param3 != 'N/A' ){
                                                pVer.Actual_Release_Date__c = Date.valueOf(param3);
                                            }
                                            versionsList.add(pVer);
                                        }
                                        if(!versionsList.isEmpty())
                                            update versionsList;
                                        
                                        
                                        cList[0].Next_Action__c = 'Pending CA Support';
                                        cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                        // set the custom comment if comment is null
                                        //if(comment == NULL || comment == '')
                                        //   comment = 'Development team has requested more information to investigate the issue.';
                                        // set the custom comment if comment is null
                                        if(comment == NULL || comment == '')
                                            comment = 'Fixed Versions have been released.';
                                        isSuccess = TRUE;
                                    }else{
                                        //isSuccess = TRUE;
                                        if(comment == NULL || comment == ''){
                                            comment = '[JIRA -> SFDC] '+comment;
                                            comment = 'Received Version_Released message but version '+param2+' could not be found in version list – please get in touch with your SDM!';
                                        }
                                        else{
                                            comment = comment + '\n Received Version_Released message but version '+param2+' could not be found in version list – please get in touch with your SDM!';
                                        }
                                        JiraIntegrationHelper.addComment(caseId,comment);
                                        isSuccess = FALSE;
                                        gen.writeStringField('message', 'ERROR : Received Version_Released message but version '+param2+' could not be found in version list – please get in touch with your SDM!');
                                        gen.writeStringField('errorCode', 'FAILURE');
                                        res.responseBody = Blob.valueOf(gen.getAsString());
                                    }
                                   
                                /*}
                                else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : param1 is required with comma separated list of version-Id');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }*/
                            }
                            else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : commentType is not valid for Incident type of ticket');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        } 
                        
                        /**

                        */
                        // If commentType is DUPLICATE_INTERNAL (only for PRB)
                        // This section will use three parameters provided in POST call
                        // Param1 will bring New Jira_Issue_Id__c
                        // Param2 will bring New JIRA_Issue_Key__c
                        // Param3 will bring new JIRA_Status__c
                      else if(setting.Apex_Code_Block__c.equalsIgnoreCase('DUPLICATEBUG'))
                        {
                                if(cList[0].Case_Type__c == 'Problem' || cList[0].Case_Type__c == 'Standard'){
                                    if(!cList[0].isClosed){
                                    String Errormsg = '';
                                    string oldJiraKey;
                                    
                                    //If param1 is blank or null add the error in error message to show to user 
                                    if(param1 != null && param1 != ''){
                                        System.debug('case.Jira_Issue_Id__c -> '+cList[0].Jira_Issue_Id__c);
                                        System.debug('Jira_Issue_Id__c -> '+param1);
                                        cList[0].Jira_Issue_Id__c = param1;                                    
                                        
                                        System.debug('case.Jira_Issue_API_link__c -> '+cList[0].Jira_Issue_API_link__c);
                                        if(cList[0].Jira_Issue_API_link__c!= null  && cList[0].Jira_Issue_API_link__c !=''){
                                        String str = cList[0].Jira_Issue_API_link__c;                                   
                                        Integer ind = str.lastIndexOfchar(047)+1;
                                        String substr = str.substring(0, ind);
                                        substr = substr+param1;
                                       cList[0].Jira_Issue_API_link__c= substr; 
                                        }
                                        
                                    }else{
                                        isSuccess = FALSE;
                                        Errormsg += 'ERROR : Param1 is required with New Jira ID.\n';                                    
                                    }
                                    
                                    //If param2 is blank or null add the error in error message to show to user
                                    if(param2 != null && param2 != ''){
                                        oldJiraKey = cList[0].JIRA_Issue_Key__c;
                                        cList[0].JIRA_Issue_Key__c = param2;
                                        string ProductName =  param2.substringBefore('-');
                                        
                                        //Get the ProductFamilty id through Depman product 
                                        /*
                                        list<Depman_Product__c> dpList = new list<Depman_Product__c>([SELECT Id,lifecycle_entity_technical_name__c,Lifecycle_entity_family_id_formula__c,lifecycle_entity_family_id__c,lifecycle_entity_id__c,lifecycle_entity_name__c,Name FROM Depman_Product__c
                                            //where lifecycle_entity_name__c = : ProductName limit 1]);
                                              where lifecycle_entity_technical_name__c = : ProductName limit 1]);
                                        */
                                        //Get ProductName and ProductFamily and set into Problem  
                                        /*
                                        if(!dpList.isEmpty() && dpList.get(0).Lifecycle_entity_family_id_formula__c != ''){    
                                            list<Depman_Support_Product_Group__c>  dspgList = new list<Depman_Support_Product_Group__c>([SELECT Lifecycle_entity_family_id_formula__c,lifecycle_entity_family_id__c,lifecycle_entity_family_name__c FROM Depman_Support_Product_Group__c where Lifecycle_entity_family_id_formula__c =: String.valueOf(dpList.get(0).Lifecycle_entity_family_id_formula__c) limit 1]);
                                             cList[0].Product__c = dpList.get(0).lifecycle_entity_name__c ;
                                                                                   
                                            if(!dspgList.isEmpty() && dspgList.get(0).lifecycle_entity_family_name__c != '' ){
                                                cList[0].Product_Family__c = dspgList.get(0).lifecycle_entity_family_name__c ;                                           
                                            }else{
                                                isSuccess = FALSE;
                                                Errormsg += 'ERROR : Asociated Depman Product Family not found.';
                                            }        
                                            
                                        }else{
                                            isSuccess = FALSE;
                                            Errormsg += 'ERROR : Asociated Depman Product not found.';
                                        }*/
                                    }else{
                                        isSuccess = FALSE;
                                        Errormsg = Errormsg + 'ERROR : Param2 is required with New Jira Key.';
                                    }
                                    
                                    //If param3 is blank or null add the error in error message to show to user
                                    if(param3 != null && param3 != ''){
                                        System.debug('case.JIRA_Status__c -> '+cList[0].JIRA_Status__c);
                                        cList[0].JIRA_Status__c = param3;
                                    }else{
                                        isSuccess = FALSE;
                                        Errormsg = Errormsg + 'ERROR : Param3 is required with Jira Status.';
                                    }
                                
                                    
                                    if(Errormsg == ''){
                                        if(!cList[0].isClosed){
                                            cList[0].status = 'In Progress';
                                        }
                                        
                                        //Get the list of Product Versions associated with this Problem and delete them 
                                        /*
                                        List<Product_Version__c> versionList = new List<Product_Version__c>([select id,name from Product_Version__c where Problem__c =: cList[0].id]);
                                        
                                        if(!versionList.isEmpty()){
                                            delete versionList;
                                        }
                                       */

                                        cList[0].Next_Action__c = 'Pending CA Support';
                                        cList[0].Next_Action_Due_Date__c = NextActionDueDt;
                                        comment = 'Author: '+Userinfo.getFirstName()+' '+Userinfo.getLastName()+ '\nAlready exisiting JIRA-issue found: '+param2+'. This PRB is re-linked from '+ oldJiraKey +' to '+param2+(comment != null ? '\n JIRA comment:'+comment: '');
                                        isSuccess = TRUE;
                                    }
                                    //Write the error message to JSONGenerator
                                    else{
                                        gen.writeStringField('message', Errormsg);
                                        gen.writeStringField('errorCode', 'FAILURE');
                                        res.responseBody = Blob.valueOf(gen.getAsString());
                                    }
                                }
                                else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : action is only valid for open (Problem or standard type of) tickets');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                                    
                                 //if The case is not of Problem type and commenttype is DUPLICATE_INTERNAL  
                                }
                                else{
                                    isSuccess = FALSE;
                                    gen.writeStringField('message', 'ERROR : commentType is only valid for Problem or standard type of tickets');
                                    gen.writeStringField('errorCode', 'FAILURE');
                                    res.responseBody = Blob.valueOf(gen.getAsString());
                                }
                        } /**/
                        
                        
                        
                    if(isSuccess){
                            // updating Time when case is acknowledged by JIRA
                            // cList[0].Acknowledged_by_R_D_At__c = Datetime.now();
                            // updating "Time to respond date" if it is an incident
                            
                            /* if(cList[0].recordType.name == 'Incident'){
                              //  cList[0].Time_to_Respond_R_D__c = BLogic_JiraIntegrationHelper.calculate_RespondRnDTime(cList[0].accountId,cList[0].priority);
                             } */
                           
                            // cList[0].Unread__c = TRUE;
                            
                            // setting static variable to avoid recursion
                            // BLogic_TriggerRecursionHandler.isInitiatedByJira = TRUE;
                           
                            // updating respective Case
                            
                            update cList;
                            
                            
                            // BLogic_TriggerRecursionHandler.isInitiatedByJira = FALSE;
                            
                            // adding private case comment
                            if(comment != null && comment != ''){
                                comment = '[JIRA -> SFDC] '+comment;
                                JiraIntegrationHelper.addComment(caseId,comment);
                            }
                            
                            // set success response, if processing made success 
                            gen.writeStringField('message','SUCCESS');
                            gen.writeStringField('errorCode','SUCCESS');
                            res.responseBody = Blob.valueOf(gen.getAsString());
                    } //Success block end
                    
                    // adding log
                       comment += '\nParam1: '+param1+'\nParam2: '+param2+'\nParam3: '+param3+'\nParam4: '+param4;
                       JiraIntegrationHelper.createLog(caseId,(isSuccess?'Success':'Failure'),(gen.getAsString() != null ? gen.getAsString():'Not a valid request.'),'JIRA -> SFDC',commentType,cList[0].JIRA_Issue_Key__c,cList[0].JIRA_Status__c,cList[0].status,comment);
                    
                } //cList end   
                    else{
                            system.debug('Error: Invalid recordId');
                            gen.writeStringField('message', 'ERROR : Invalid recordId');
                            gen.writeStringField('errorCode', 'FAILURE');
                            res.responseBody = Blob.valueOf(gen.getAsString());
                            // adding log
                            if(!cList.isEmpty()){
                                comment += '\nParam1: '+param1+'\nParam2: '+param2+'\nParam3: '+param3+'\nParam4: '+param4;
                                JiraIntegrationHelper.createLog(caseId,'Failure',gen.getAsString(),'JIRA -> SFDC',commentType,null,null,null,comment);
                            } 
                        }//error block end
                        
                }   
                 
                else{
                    system.debug('Error: commentType is required');
                    gen.writeStringField('message', 'ERROR : commentType is required, either it is null or has not been configured in Salesforce.');
                    gen.writeStringField('errorCode', 'FAILURE');
                    res.responseBody = Blob.valueOf(gen.getAsString());
                    // adding log
                    comment += '\nParam1: '+param1+'\nParam2: '+param2+'\nParam3: '+param3+'\nParam4: '+param4;
                    JiraIntegrationHelper.createLog(caseId,'Failure',gen.getAsString(),'JIRA -> SFDC',commentType,null,null,null,comment);
                }
            }
            else{
                system.debug('Error: caseId is required');
                gen.writeStringField('message', 'ERROR : caseId is required');
                gen.writeStringField('errorCode', 'FAILURE');
                res.responseBody = Blob.valueOf(gen.getAsString());
                // adding log
                comment += '\nParam1: '+param1+'\nParam2: '+param2+'\nParam3: '+param3+'\nParam4: '+param4;
                JiraIntegrationHelper.createLog(caseId,'Failure',gen.getAsString(),'JIRA -> SFDC',commentType,null,null,null,comment);
            }                
        
        } //End of Try
       
       catch(Exception ex){
           system.debug('Exception: '+ex+' ## '+ex.getMessage());
           gen.writeStringField('message', 'ERROR : '+ex.getMEssage());
           gen.writeStringField('errorCode', 'FAILURE');
           res.responseBody = Blob.valueOf(gen.getAsString());
         //  adding log
             comment += '\nParam1: '+param1+'\nParam2: '+param2+'\nParam3: '+param3+'\nParam4: '+param4;
             JiraIntegrationHelper.createLog(caseId,'Failure',gen.getAsString(),'JIRA -> SFDC',commentType,null,null,null,comment);
        } // Ending catch block
    
    } //Method
}