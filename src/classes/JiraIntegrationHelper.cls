public class JiraIntegrationHelper {
    
    // to add private case comment
    public static void addComment(string caseId,string comment)
    {
        string truncateStr;
        if(comment != null && comment != ''){
            if(comment.length() > 3950)
               truncateStr = comment.abbreviate(3800) +'\n \n- - T R U N C A T E D - -\n\n- - PLEASE CHECK JIRA ticket - -';
            else
               truncateStr = comment;
            CaseComment cc = new CaseComment(IsPublished = false,parentId=caseId,CommentBody= truncateStr);
            insert cc;
        }
    }
    
    //To Create Logs
    public static void createLog(string parentId,string status,string status_desc,string flow,string commentType,string externalSysId,string externalSysStatus,string internalTicketStatus,string Communication_desc)
    {
        try{
            // initialize the log object
            Integration_Log__c log = new Integration_Log__c();
            // set the field values
            log.Master_Record__c = parentId;
            log.API_Status__c = status;
            log.API_Comment__c = status_desc;
            log.Communication_Flow__c = flow;
            log.Communication_Type__c = commentType;
            log.External_Ticket_Id__c = externalSysId;
            log.External_Ticket_Status__c = externalSysStatus;
            log.Internal_Ticket_Status__c = internalTicketStatus;
            log.Communication_Details__c = Communication_desc;
            // insert log record
            insert log;
        }
        catch(Exception ex){
            system.debug('Exception : '+ex.getMessage());
        }
    }
    
    // a future method is used to update the JIRA ticket from triggers
    @future(callout = true)
    public static void updateJiraTicket(string caseId,map<string,string> fieldMap,map<string,string> labelMap,Boolean isStatusUpdated)
    {
        Case c;
        string comment;
        
        system.debug('CaseId to be..!!'+caseId);
        system.debug('fieldMap..!!!!'+fieldMap.values());
        system.debug('labelMap..!!!!'+labelMap.values());
        try{
            // querying case object
            c = [select id,JIRA_Issue_Key__c,Jira_Issue_API_link__c,JIRA_Status__c,status from case where id =: caseId];
            if(c != null){
                HttpRequest req = new HttpRequest();
                JIRA_Configuration__c setting = JIRA_Configuration__c.getAll().get('Default');
                if(setting != null){
                    string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                    req.setMethod('PUT');
                    req.setTimeout(120000);
                    req.setEndpoint(c.Jira_Issue_API_link__c);
                    req.setHeader('Content-Type', 'application/json');  
                    req.setHeader('Authorization', authStr);
                    system.debug(fieldMap);
                    system.debug(labelMap);
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    
                    if(!labelMap.isEmpty()){
                        gen.writeFieldName('update');
                        gen.writeStartObject();
                        gen.writeFieldName('labels');
                        gen.writeStartArray();
                        for(string key: labelMap.keySet()){
                            system.debug('release version!'+key);
                            if(key.equalsIgnoreCase('addVersion')){
                                if(labelMap.get(key) != null){
                                    for(string ver: labelMap.get(key).split('@@')){
                                        gen.writeStartObject();
                                        gen.writeStringField('add',ver.replace(' ','_'));
                                        gen.writeEndObject();
                                        if(comment != null && comment != '')
                                            comment += '\nVersion <'+ver.replace(' ','_')+'> added to JIRA issue '+c.JIRA_Issue_Key__c;
                                        else
                                            comment = 'Version <'+ver.replace(' ','_')+'> added to JIRA issue '+c.JIRA_Issue_Key__c; 
                                    }   
                                }
                                system.debug('label comment..!!'+comment);
                            }   
                            else if(key.equalsIgnoreCase('removeVersion')){
                                if(labelMap.get(key) != null){
                                    for(string ver: labelMap.get(key).split('@@')){
                                        gen.writeStartObject();
                                        gen.writeStringField('remove',ver.replace(' ','_'));
                                        gen.writeEndObject();
                                        if(comment != null && comment != '')
                                            comment += '\nVersion <'+ver.replace(' ','_')+'> removed from JIRA issue '+c.JIRA_Issue_Key__c;
                                        else
                                            comment = 'Version <'+ver.replace(' ','_')+'> removed from JIRA issue '+c.JIRA_Issue_Key__c;
                                    }
                                }   
                            }
                        }
                        gen.writeEndArray();
                        gen.writeEndObject();
                    } 
                    
                    if(!fieldMap.isEmpty()){
                        gen.writeFieldName('fields');
                        gen.writeStartObject();
                        for(string key: fieldMap.keySet()){
                            system.debug('Severity and No of Incident!'+key);
                            if(key.equalsIgnoreCase('priority')){
                                gen.writeFieldName(key);
                                gen.writeStartObject();
                                gen.writeStringField('id',fieldMap.get(key));
                                gen.writeEndObject();
                                
                                if(comment != null && comment != '')
                                    comment += '\nPriority of JIRA issue '+c.JIRA_Issue_Key__c+' changed to '+fieldMap.get(key);
                                else
                                    comment = 'Severity of JIRA issue '+c.JIRA_Issue_Key__c+' changed to '+fieldMap.get(key);
                            }    
                            else if(key.equalsIgnoreCase('NumberofIncident')){
                                gen.writeStringField(setting.No_of_Inc_Field_Id__c.trim(),fieldMap.get(key));
                                if(comment != null && comment != '')
                                    comment += '\nFrequency of JIRA issue '+c.JIRA_Issue_Key__c+' changed to '+fieldMap.get(key);
                                else
                                    comment = 'Frequency of JIRA issue '+c.JIRA_Issue_Key__c+' changed to '+fieldMap.get(key);
                            }    
                        }
                        
                        gen.writeEndObject();
                    }
                    
                    if(isStatusUpdated)
                    {
                        string updatedComment = 'SFDC ticket is closed.';
                        updateJiraStatustoOpen(c.id,setting,updatedComment);
                    }
                    
                    gen.writeEndObject();
                    if(comment != null && comment != '')
                    {
                        System.debug('last Comment to be..!!!'+comment);
                        req.setBody(gen.getAsString());  
                        system.debug('Request Body with comment..!!'+gen.getAsString());
                        system.debug('Request Body with comment2..!!'+req);
                        Http http = new Http();
                        HTTPResponse res;
                        if(!Test.isRunningTest()){
                            res = http.send(req);
                            System.debug('Response for Comment..!!'+res);
                        }else{
                            res=new HTTPResponse();
                            res.setStatusCode(204);
                            res.setBody('');
                        }
                        system.debug('Response body is....!!'+res.getBody());
                        
                        if(res.getStatusCode() == 204){
                            system.debug('Callout Success..');
                            if(comment != null && comment != ''){
                                comment = '[SFDC - JIRA] '+comment;
                                addComment(c.id,comment);
                            }        
                            JiraIntegrationHelper.createLog(c.id,'Success',res.getBody(),'SFDC -> JIRA','UPDATE_TICKET',c.JIRA_Issue_Key__c,c.JIRA_Status__c,c.status,comment);     
                        }   
                        else{
                            system.debug('Callout Failure..');
                            JiraIntegrationHelper.createLog(c.id,'Failure',res.getBody(),'SFDC -> JIRA','UPDATE_TICKET',c.JIRA_Issue_Key__c,c.JIRA_Status__c,c.status,null);
                        }  
                    } 
                }
                else{
                    system.debug('custom setting is blank');
                    // adding log
                    JiraIntegrationHelper.createLog(c.id,'Failure','Jira configuration data is missing in "JIRA Configuration" custom setting','SFDC -> JIRA','UPDATE_TICKET',c.JIRA_Issue_Key__c,c.JIRA_Status__c,c.status,null);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug('JIRA callout Exception : '+ex.getMessage());
            // adding log
            JiraIntegrationHelper.createLog(c.id,'Failure',ex.getMessage(),'SFDC -> JIRA','UPDATE_TICKET',c.JIRA_Issue_Key__c,c.JIRA_Status__c,c.status,null);
        }
    }
    
    @future(callout = true)
    public static void updateJiraTicketState(string caseId,string optionalComment)
    {
        JIRA_Configuration__c setting = JIRA_Configuration__c.getAll().get('Default');
        updateJiraStatustoOpen(caseId,setting,optionalComment);
    }
     public static void updateJiraFields(string caseId,string optionalComment){


     }
    // method is used to update the JIRA ticket status
    public static void updateJiraStatustoOpen(string caseId,JIRA_Configuration__c setting,string optionalComment)
    {
        string status;
        string sfdcComment = optionalComment;
        try{
            // querying case object
            List<Case> caseList = new List<Case>([select id,isClosed,Jira_Issue_API_link__c,Jira_Issue_Id__c,JIRA_Issue_Key__c,JIRA_Status__c from case where id =: caseId]);
            // if case exists in salesforce
            if(!caseList.isEmpty())
            {
                // initialize the properties
                string issueId = caseList[0].Jira_Issue_Id__c;
                string issueKey = caseList[0].JIRA_Issue_Key__c;
                string endPoint = caseList[0].Jira_Issue_API_link__c;
                
                // making endpoint url to get transition details
                string oldString = 'latest/issue/'+issueId;
                string newString = '2/issue/'+issueKey+'/transitions';
                String transEndpoint = endPoint.replace(oldString,newString);
                string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                //Set HTTPRequest Method  
                req.setMethod('GET');
                //Set timeout 
                req.setTimeout(120000);
                //Set header values
                req.setHeader('Content-Type', 'application/json');  
                req.setHeader('Authorization', authStr);
                //Set endpoint
                req.setEndPoint(transEndpoint);
                // send the request
                HTTPResponse res;
                
                if(Test.isRunningTest()){
                    JiraCalloutMock mock = new JiraCalloutMock();
                    res =  mock.getJiraResponse(req);
                }else{
                    res = http.send(req);
                    System.debug('Response is..!!'+res);
                }
                
                system.debug(res);
                system.debug('Response body..!!'+res.getBody());
                
                // parse the response
                map<string,string> resMap = parseResponse(res.getBody());
                system.debug('Response Map is!!'+resMap);
                
                // if response is not null and do contains the transition id, update the status in JIRA
                if(!caseList[0].isClosed && !resMap.isEmpty() && (resMap.get('stop progress') != null || resMap.get('redo issue') != null || resMap.get('reopen') != null || resMap.get('information provided') != null))
                {
                    HttpRequest req1 = new HttpRequest();
                    //Set HTTPRequest Method  
                    req1.setMethod('POST');
                    //Set header values
                    req1.setHeader('Content-Type', 'application/json');  
                    req1.setHeader('Authorization', authStr);
                    //Set endpoint
                    req1.setEndpoint(endPoint+'/transitions');
                    //making body
                    if(optionalComment != null && optionalComment != ''){
                        optionalComment =  optionalComment.replace('\n','\\n').replace('\r','').replace('\t','\\t');
                        optionalComment = 'Salesforce Author: '+UserInfo.getName()+'\\n'+optionalComment;
                    }
                    string transitionId = (resMap.get('stop progress') != null?resMap.get('stop progress'):(resMap.get('redo issue') != null?resMap.get('redo issue'):(resMap.get('reopen') != null?resMap.get('reopen') : (resMap.get('information provided') != null?resMap.get('information provided'):''))));
                    string body='{ "update": {  "comment": [  {  "add": { "body": "'+optionalComment+'"} }]}, "fields": { }, "transition": { "id": "'+transitionId+'" } }';
                    //Set request body
                    req1.setBody(body);  
                    system.debug('Request Body.......!!!!'+body);
                    // making callout
                    if(!Test.isRunningTest()){
                        res = http.send(req1);
                    }else{
                        res=new HTTPResponse();
                        res.setStatusCode(204);
                        res.setBody('');
                    }
                    system.debug('response body 2: '+res.getBody());
                    // checking callout status code
                    if(res.getStatusCode() == 204){
                        system.debug('Callout Success.');
                        if(caseList[0].isClosed)
                            addCommentToJira(caseId,sfdcComment);
                    } 
                }
                else if(caseList[0].isClosed){
                    addCommentToJira(caseId,sfdcComment);
                }
                
                  
                
            }
            
        }
        catch(Exception ex)
        {
            system.debug('JIRA callout Exception : '+ex.getMessage());
        }   
        
    }
    public static string addCommentToJira(string parId,string comment)
    {
        // will contain success or failure message
        string retMsg;
        // querying case object
        List<Case> caseList = new List<Case>([select id,status,Case_Type__c,Jira_Issue_API_link__c,JIRA_Status__c,JIRA_Issue_Key__c from Case where id =: parId LIMIT 1]); 
        try{
            if(!caseList.isEmpty()){
                // creating HTTP request
                HttpRequest req = new HttpRequest();
                // access the configuration data from custom setting
                JIRA_Configuration__c setting = JIRA_Configuration__c.getAll().get('Default');
                // making authorization string
                string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                //Set HTTPRequest Method  
                req.setMethod('POST'); 
                //Set request callout tome
                req.setTimeout(120000);
                /******** start: set header properties ************/
                req.setHeader('Accept', '*/*');
                req.setHeader('Content-Type', 'application/json');  
                req.setHeader('Authorization', authStr);
                /******** End: set header properties ************/
                
                //Set request service endpoint
                req.setEndpoint(caseList[0].Jira_Issue_API_link__c+'/comment');
                // customizing and refining comment string
                string updatedComment = 'Salesforce Author: '+UserInfo.getName()+'\n'+comment;
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('body', updatedComment);
                string body = gen.getAsString();
                // set the request body
                req.setBody(body);  
                system.debug('Request Body to be..!!!!'+body);
                
                // making callout
                Http http = new Http();
                HTTPResponse res;
                
                if(Test.isRunningTest()){
                    JiraCalloutMock mock = new JiraCalloutMock();
                    res =  mock.getJiraResponse(req);
                }else{
                    res = http.send(req);
                    System.debug('response1 be!!!!!'+res);
                }

                System.debug('Response1 has to be!!'+res.toString());
                System.debug('Response1 body to is!!'+res.getBody());
                
                // if callout success
                if(res.getStatusCode() == 201)
                {
                    // parse the JSON response string
                    map<string,string> resultMap = parseResponse(res.getBody());
                    // adding private case comment
                    string caseCommentStr = '[SFDC - JIRA] Info sent to JIRA issue '+caseList[0].JIRA_Issue_Key__c+': '+comment;
                    addComment(parId,caseCommentStr);
                    retMsg = 'Comment has been added to JIRA ticket successfully.';
                    // adding log
                    createLog(parId,'Success',retMsg,'SFDC -> JIRA','BASIC_COMMENT',caseList[0].JIRA_Issue_Key__c,caseList[0].JIRA_Status__c,caseList[0].status,comment);
                }
            }
        }
        catch(exception ex)
        {
            retMsg  = ex.getMessage();
            // adding log
            createLog(parId,'Failure',ex.getMessage(),'SFDC -> JIRA','BASIC_COMMENT',caseList[0].JIRA_Issue_Key__c,caseList[0].JIRA_Status__c,caseList[0].status,comment);
        } 
        return retMsg;  
        
    }
    
    public static map<string,string> parseResponse(string jsonStr)
    {
        map<string,string> resultMap = new map<string,string>();
        JSONParser parser = JSON.createParser(jsonStr);
        while (parser.nextToken() != null) 
        {
            if(!resultMap.containsKey(parser.getText()) && parser.getCurrentName() != parser.getText() && parser.getCurrentName() == 'id'){
                string key = parser.getText();
                parser.nextToken();
                parser.nextToken();
                if(parser.getCurrentName() != parser.getText() && parser.getCurrentName() == 'name')
                    resultMap.put(parser.getText().toLowerCase().trim(),key);
            }   
        }
        system.debug(resultMap);
        return resultMap;
    }
 

     public static String callJIRAService(string jsonStr){
                // creating HTTP request
                HttpRequest req = new HttpRequest();
                // access the configuration data from custom setting
                JIRA_Configuration__c setting = JIRA_Configuration__c.getAll().get('Default');
                // making authorization string
                string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                //Set HTTPRequest Method  
                req.setMethod('POST'); 
                //Set request callout tome
                req.setTimeout(120000);
                /******** start: set header properties ************/
                req.setHeader('Accept', '*/*');
                req.setHeader('Content-Type', 'application/json');  
                req.setHeader('Authorization', authStr);
                /******** End: set header properties ************/
                 //Set request service endpoint
                req.setEndpoint(setting.Endpoint__c);
                // customizing and refining comment string
                //string updatedComment = 'Salesforce Author: '+UserInfo.getName()+'\n'+comment;
                JSONGenerator gen = JSON.createGenerator(true);
                // making callout
                Http http = new Http();
         		HTTPResponse res;

         		if(Test.isRunningTest()){
                    JiraCalloutMock mock = new JiraCalloutMock();
                    res =  mock.getJiraResponse(req);
                }else{
                    res = http.send(req);
                }	
         
                System.debug('response'+res.getBody());
                if (res.getStatusCode()==200)
                    return res.getBody();
                else 
                    return '';    
    }

    @future(callout = true)
    public static void updateStatus(String jiraKey, String status, String offeringCode,String noOfInc){
        JIRA_Configuration__c configuration = JIRA_Configuration__c.getAll().get('Default');
        JSONGenerator jsonGenrator = JSON.createGenerator(true);
        jsonGenrator.writeStartObject();
        jsonGenrator.writeFieldName('fields');
        jsonGenrator.writeStartObject();
        
        if(null != status){
        	jsonGenrator.writeStringField(configuration.SFDC_Status__c, status);
        }
        
        if(null != offeringCode){
            jsonGenrator.writeStringField(configuration.Support_Offering_Code__c, offeringCode);
        }
        if(null != noOfInc && noOfInc!='' ){
            jsonGenrator.writeStringField(configuration.No_of_Inc_Field_Id__c, noOfInc);
            //gen.writeStringField(setting.No_of_Inc_Field_Id__c.trim(),String.valueOf(noOfInc));
        }
                
        jsonGenrator.writeEndObject();
        jsonGenrator.writeEndObject();
        System.debug(jsonGenrator.getAsString());
        string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(configuration.Username__c+':'+configuration.Password__c));
        HttpRequest request = new HttpRequest();
		request.setMethod('PUT'); 
		request.setHeader('Content-Type', 'application/json'); 
		request.setHeader('Authorization', authStr);
		request.setEndpoint(configuration.Endpoint__c+'/'+jiraKey);
        request.setBody(jsonGenrator.getAsString());
		Http http = new Http();
        HTTPResponse response;
        
        if (Test.isRunningTest()){
            JiraCalloutMock mock = new JiraCalloutMock();
            response =  mock.respond(request);
        }else{
            response = http.send(request); 
        }
    }
    
    public static Case updateNextActionOwnerAndTime(Case caseObject){
        Datetime currentDate=System.now();
        Datetime finalDate = null;
        //case newc=new Case(Id=caseObject.id);
        Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
        if(caseObject.BusinessHoursId!=null){
            for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:caseObject.BusinessHoursId])
                taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
        }
        if(caseObject.Severity__c=='1' || caseObject.Severity__c=='2')
        {
            finalDate=BusinessHours.addGmt(caseObject.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObject.BusinessHoursId) *Integer.valueOf('1'))*long.Valueof('3600000')));
        }
        else if(caseObject.Severity__c=='3' || caseObject.Severity__c=='4' )
        {
            finalDate=BusinessHours.addGmt(caseObject.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObject.BusinessHoursId)*Integer.valueOf('5'))*long.Valueof('3600000')));
        }
        caseObject.SE_Action__c = true;
        caseObject.Next_Action_Due_Date__c = finalDate; 
        caseObject.Next_Action__c='Pending CA Engineering (L2)';
        return caseObject;
    }
    
    public static Case caseProblemIntercommunication(Case caseObject){
        caseObject.Next_Action__c='Pending CA Support';
        caseObject.Next_Action_Due_Date__c = BusinessHours.addGmt(caseObject.BusinessHoursId, System.now(), 2 * 60 * 60 * 1000L); 
        return caseObject;
    }
    
    public static void createTask(Case caseObject){
        List<Task> otherSupportTaskList = [select Id,Status,WhatId from Task where 
                                                   RecordTypeId =:Label.Other_Support_Task_Record_Type
                                                   AND Type = 'SE Action' AND WhatId =:caseObject.ID AND Status!='Closed'];  
        if(otherSupportTaskList.Size()==0 && !Test.isRunningTest()){ 
            JiraIntegration.createSEActionTask(caseObject.Id, caseObject.JIRA_Issue_Key__c);
        }
    }
    public static void createSEActionTask(List<Case> caseList){
		List<Case> tasksCaseList = new List<Case>();
		for(Case caseObject : caseList){
			List<Task> otherSupportTaskList = [select Id,Status,WhatId from Task where 
													   RecordTypeId =:Label.Other_Support_Task_Record_Type 
													   AND Type = 'SE Action' AND (WhatId =:caseObject.ID ) AND Status!='Closed'];  
													   
			if(otherSupportTaskList.Size()==0){
				tasksCaseList.add(caseObject);
			}
		 }
        Id devRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Other Support Task').getRecordTypeId();
        List<Task> taskList = new List<Task>();
        String timeStr = datetime.now().format('yyyy-MM-dd hh:mm a');
        for(Case caseObject : tasksCaseList){
            Task t = new Task();        
            t.whatId =caseObject.Id;      
            t.recordTypeId =devRecordTypeId ;       
            t.Status = 'Not Started';       
            t.Priority ='Normal'; 
            t.subject =caseObject.JIRA_Issue_Key__c;
            t.description='Task auto created by JIRA Integration by  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' and '+ timeStr + ')';        
            t.Type ='SE Action';
            taskList.add(t);
        }
        System.debug('creating the tasks');
        if(taskList != null && taskList.size()>0 && !Test.isRunningTest()){
        	insert taskList;
        }
        System.debug('tasks are created');
	}
}