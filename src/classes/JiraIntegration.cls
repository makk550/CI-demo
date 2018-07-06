//This class creates JIRA ticket and add the comments.
public class JiraIntegration{

     static JIRA_Configuration__c setting;
     
     //Method is used to create JIRA ticket
     public static string createJiraTicket(string objId,string comment,string requestType,string initialComponent){
     
             system.debug('objId is..!!'+objId);
             system.debug('Comment be..!!'+comment);
             system.debug('requestType..!!'+requestType);
             system.debug('Component is..!!'+initialComponent);
             string retMsg;
             // access the configuration data from custom setting
            if(JIRA_Configuration__c.getAll().get('Default') != null)
                setting = JIRA_Configuration__c.getAll().get('Default');
            else{
                retMsg = 'Required Jira config setting missing. Please Contact Admin.';
                return retMsg;
            }
            
            // querying case object
            List<Case> caseList = new List<Case>([select Id,Description,Case_Type__c,status,Subject,BusinessHoursId,LastModifiedBy.Name,CA_Product_Controller__r.Name,CA_Product_Component__r.Name,CA_Product_Component__r.Component_Text__c,CA_Product_Component__r.Component_Code__c,Product_Release__c,Component_Release_Only_Selection__r.Name,Component_Release_Only_Selection__r.Component_Release__c,Offering_Code_Ref__c,No_of_problem_or_standard_cases__c,Owner.Name,CaseNumber,Priority,Severity__c,JIRA_Issue_Key__c,JIRA_Status__c from Case where id =: objId LIMIT 1]);
            system.debug('caseList is..!!'+caseList[0]);
            
            List<JIRA_Project_Key__c> Depmanprojectkey = new List<JIRA_Project_Key__c>([Select Id,Name,JIRA_Project_ID__c,JIRA_Project_Key__c from JIRA_Project_Key__c where Name =:caseList[0].CA_Product_Component__r.Component_Text__c.replaceall(' ','.') ]);
             if(Depmanprojectkey.isEmpty()){
                retMsg = 'Required Jira Project Key is missing. Please Contact Admin.';
                return retMsg;
             }
             if(!caseList.isEmpty()){
                 try{  
                    if(caseList[0].CA_Product_Component__r.Name != NULL){ 
                        // creating HTTP request
                        HttpRequest req = new HttpRequest();
                        // making authorization string
                        string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                        //Set HTTPRequest Method  
                        req.setMethod('POST'); 
                        // set request timeout
                        req.setTimeout(120000); 
                        // set request service endpoint
                        req.setEndpoint(setting.Endpoint__c);  
                        req.setHeader('Content-Type', 'application/json');  
                        req.setHeader('Authorization', authStr);

                        string body;
                        string newComment;
                        DateTime IssueCreateddate = DateTime.now();
                        String IssueDatetime = IssueCreateddate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ','GMT');
                        
                        JSONGenerator gen = JSON.createGenerator(true);
                        // if case is Standard
                        if(caseList[0].Case_Type__c == 'Standard'){
                            newComment = '*SFDC Description:*\r\n'+caseList[0].description+'\n\n*SFDC Comment:*\r\n '+comment;
                            system.debug('NewComment for standard is..!!'+newComment);
                            gen.writeStartObject();
                            gen.writeFieldName('fields');
                            gen.writeStartObject();
                            gen.writeFieldName('project');
                            gen.writeStartObject();
                            //gen.writeStringField('key','AE');
                            gen.writeStringField('key',Depmanprojectkey[0].JIRA_Project_Key__c);
                            gen.writeEndObject();
                            gen.writeStringField('description',newComment);
                            gen.writeStringField('summary',caseList[0].subject);
                            gen.writeFieldName('issuetype');
                            gen.writeStartObject();
                            gen.writeStringField('name','Incident');
                            gen.writeEndObject();
                            gen.writeFieldName('priority');
                            
                            gen.writeStartObject();
                            gen.writeStringField('id',caseList[0].Severity__c);
                            gen.writeEndObject();
                            gen.writeFieldName('labels');
                            gen.writeStartArray();
                         // gen.writeString(caseList[0].CA_Product_Component__r.Name!= null ? ('Component:'+initialComponent).replace(' ','_'):'');
                            gen.writeString(caseList[0].CA_Product_Component__r.Component_Text__c!= null?caseList[0].CA_Product_Component__r.Component_Text__c.replace(' ','.'):'');
                         // gen.writeString(caseList[0].Component_Release_Only_Selection__r.Name!= null?caseList[0].Component_Release_Only_Selection__r.Name.replace(' ','_'):'');
                            gen.writeString((caseList[0].CA_Product_Component__r.Component_Text__c!= null?caseList[0].CA_Product_Component__r.Component_Text__c.replace(' ','.'):'')+'_'+caseList[0].Component_Release_Only_Selection__r.Component_Release__c);
                         
                            gen.writeString('Information_Request'); 
                            gen.writeString(caseList[0].LastModifiedBy.Name.replace(' ','_'));                          
                            gen.writeEndArray();
                            gen.writeStringField(setting.Case_Field_Id__c.trim(),objId);
                            gen.writeStringField(setting.Case_Number_Field_Id__c.trim(),caseList[0].CaseNumber);
                            gen.writeStringField(setting.Issue_Created_Date_and_Time__c.trim(),IssueDatetime);
                            gen.writeStringField(setting.Support_Offering_Code__c,(caseList[0].Offering_Code_Ref__c != null ?caseList[0].Offering_Code_Ref__c :'Standard'));
                            gen.writeStringField(setting.SFDC_Status__c,caseList[0].Status);
                            gen.writeEndObject();
                            gen.writeEndObject();
                            body = gen.getAsString(); 
                            system.debug('case bdy for standard is..!!'+body);
                            
                        }
                        else if(caseList[0].Case_Type__c == 'Problem'){
                            List<Automic_R_D_Component_Version__c> ComponentVersions = new List<Automic_R_D_Component_Version__c>([Select Component_Release__r.Component_Release__c from Automic_R_D_Component_Version__c where Problem__c =:caseList[0].Id AND Created_Internally__c=TRUE]);
                            if(ComponentVersions.isEmpty()){
                                  retMsg = 'Please add the component release before creating the JIRA issue.';
                                  return retMsg;
                            }
                            // newComment = '*SFDC Problem Description:\r\n'+caseList[0].description+'\n\n*SFDC Comment from '+UserInfo.getName()+':\r\n '+comment;
                            newComment = '*SFDC Description:*\r\n'+caseList[0].description+'\n\n*SFDC Comment:*\r\n '+comment;
                            system.debug('NewComment for problem is..!!'+newComment);
                            Integer noOfInc = Integer.valueOf(caseList[0].No_of_problem_or_standard_cases__c!= null?caseList[0].No_of_problem_or_standard_cases__c:0);
                            gen.writeStartObject();
                            gen.writeFieldName('fields');
                            gen.writeStartObject();
                            gen.writeFieldName('project');
                            gen.writeStartObject();
                          //gen.writeStringField('key','AM');
                            gen.writeStringField('key',Depmanprojectkey[0].JIRA_Project_Key__c);
                            gen.writeEndObject();

                            gen.writeStringField('description',newComment);
                            gen.writeStringField('summary',caseList[0].subject);
                            gen.writeFieldName('issuetype');
                            gen.writeStartObject();
                            gen.writeStringField('name','Problem');
                            gen.writeEndObject();
                            gen.writeFieldName('priority');
                            
                            gen.writeStartObject();
                            gen.writeStringField('id',caseList[0].Severity__c);
                            gen.writeEndObject();
                            gen.writeFieldName('labels');
                            gen.writeStartArray();
                            gen.writeString(caseList[0].CA_Product_Component__r.Component_Text__c!= null?caseList[0].CA_Product_Component__r.Component_Text__c.replace(' ','.'):'');
                            for(Automic_R_D_Component_Version__c versions: ComponentVersions){
                                gen.writeString((caseList[0].CA_Product_Component__r.Component_Text__c!= null?caseList[0].CA_Product_Component__r.Component_Text__c.replace(' ','.'):'')+'_'+versions.Component_Release__r.Component_Release__c);
                                System.debug('Version='+versions.Component_Release__r.Component_Release__c);
                            }
                            gen.writeString(requestType.replace(' ','_')); 
                            gen.writeString(caseList[0].LastModifiedBy.Name.replace(' ','_'));                          
                            gen.writeEndArray();
                            gen.writeStringField(setting.Case_Field_Id__c.trim(),objId);
                            gen.writeStringField(setting.Case_Number_Field_Id__c.trim(),caseList[0].CaseNumber);
                            gen.writeStringField(setting.No_of_Inc_Field_Id__c.trim(),String.valueOf(noOfInc));
                            gen.writeStringField(setting.Issue_Created_Date_and_Time__c.trim(),IssueDatetime);
                            gen.writeStringField(setting.SFDC_Status__c,caseList[0].Status);
                            gen.writeEndObject();
                            gen.writeEndObject();
                            body = gen.getAsString(); 
                            system.debug('case bdy for Problem is..!!'+body);
                        
                        }
                        
                        // set the request body
                        req.setBody(body);  
                        system.debug('Reqest Body ..!! '+body);
                        
                        // making callout
                        Http http = new Http();
                        HTTPResponse res;
                        
                        if (Test.isRunningTest()){
                            JiraCalloutMock mock = new JiraCalloutMock();
                            res =  mock.respond(req);
                        }else{
                            res = http.send(req); 
                        }
                        
                        System.debug('Response is..!!'+res);
                        System.debug('Response toString is..!!'+res.toString());
                        System.debug('Response bdy to be....!!'+res.getBody());
                        
                        // if callout success
                        if(res.getStatusCode() == 201){
          
                           // parsing JSON response string
                           map<string,string> resultMap = parseResponse(res.getBody());
                          
                           // initialize case object to update
                        // Case c = new Case(Id=objId,JIRA_Status__c='Open',Jira_Issue_API_link__c=resultMap.get('self'),Jira_Issue_Id__c=resultMap.get('id'),JIRA_Issue_Key__c=resultMap.get('key'));
                            Case c = new Case(Id=objId,Severity__c = caseList[0].Severity__c, BusinessHoursId=caseList[0].BusinessHoursId, JIRA_Status__c='Open',Jira_Issue_API_link__c=resultMap.get('self'),Jira_Issue_Id__c=resultMap.get('id'),JIRA_Issue_Key__c=resultMap.get('key'),Initial_Transmit_to_R_D__c=datetime.now());
                           
                            System.debug('case record before update..'+c.Jira_Issue_API_link__c);  
                            System.debug('case record in update opt!!!'+c);
                            c = JiraIntegrationHelper.updateNextActionOwnerAndTime(c);
                            if(caseList[0].Case_Type__c == 'Standard'){
                                createSEActionTask(c.Id,resultMap.get('key'));
                                update c;
                            }
                            if(caseList[0].Case_Type__c == 'Problem'){
                                List<Case> childList = new List<Case>();
                                childList = ([select id,SE_Action__c,parentID,case_type__c,casenumber,JIRA_Issue_Key__c,BusinessHoursId,Next_Action_Due_Date__c,Next_Action__c,Severity__c from Case where parentID =:c.id AND Status!='Closed']);
                                System.debug('full child list1'+childList);
                                if (!childList.isEmpty()){
                                    System.debug('full child list2'+childList);
                                    for(Case pc:childList){
                                        pc = JiraIntegrationHelper.updateNextActionOwnerAndTime(pc);
                                        System.debug('case record for loop'+pc);
                                    }
                                    System.debug('full child list3'+childList);
                                }
                                childList.add(c);
                                System.debug('full child list4'+childList);
                                JiraIntegrationHelper.createSEActionTask(childList); 
                                update childList;
                                //if (!childList.isEmpty())
                                    
                            }
                            string caseCommentStr = '[SFDC -> JIRA] Info sent to JIRA issue '+c.JIRA_Issue_Key__c+' =>\n '+comment;
                            JiraIntegrationHelper.addComment(objId,caseCommentStr);
                            retMsg = 'Issue has been successfully created in JIRA.';
                        } 
                        else{
                            // set the JIRA message
                            if(res.getBody().contains('project is required'))
                                retMsg = 'Selected Product is not valid in JIRA, cannot create JIRA ticket.';
                            else
                                retMsg = res.getBody();                           
                        }
                    }
                     else{
                         retMsg = 'Selected product is not available.';
                     }
                 } 
                 catch(Exception ex){
                     // set the exception message
                     retMsg = 'There is some technical problem. Please get in touch with your Admin.';
                 }  
             }else{
             retMsg = 'Please check the case Fields.';
         }
         return retMsg;   
     }
     
     
     public static string addComment(string parId,string comment){
     
            // will contain success or failure message
            string retMsg;
            // access the configuration data from custom setting
            if(JIRA_Configuration__c.getAll().get('Default') != null)
                setting = JIRA_Configuration__c.getAll().get('Default');
            else{
                retMsg = 'Required Jira config setting missing. Please Contact Admin.';
                return retMsg;
            }
                
            // querying case object
            List<Case> caseList = new List<Case>([select Id,status,Case_Type__c,Jira_Issue_API_link__c,JIRA_Status__c,JIRA_Issue_Key__c from Case where id =: parId LIMIT 1]); 
            
            if(!caseList.isEmpty())
                try{ 
                    // creating HTTP request
                    HttpRequest req = new HttpRequest();
                    string authStr = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(setting.Username__c+':'+setting.Password__c)); 
                    //Set HTTPRequest Method  
                    req.setMethod('POST'); 
                    //Set request callout tome
                    req.setTimeout(120000);
                    req.setHeader('Accept', '*/*');
                    req.setHeader('Content-Type', 'application/json');  
                    req.setHeader('Authorization', authStr);

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
                    system.debug('Request Body is..!!'+body);
                    
                    // making callout
                    Http http = new Http();
                    HTTPResponse res;
                    
                    if (Test.isRunningTest()){
                        JiraCalloutMock mock = new JiraCalloutMock();
                        res =  mock.respond(req);
                    }else{
                        res = http.send(req); 
                    }
                    
                    System.debug('Response is..!!'+res);
                    System.debug('Response string..!!'+res.toString());
                    System.debug('Response body'+res.getBody());
                    
                    // If callout success
                    if(res.getStatusCode() == 201)
                    {
                       // parse the JSON response string
                       map<string,string> resultMap = parseResponse(res.getBody());
                       system.debug('Jira Status is..!!'+caseList[0].JIRA_Status__c);
                       
                     //string caseCommentStr = '[SFDC -> JIRA] -- Info sent to JIRA issue'+caseList[0].JIRA_Issue_Key__c+':\n\n '+comment;
                       string caseCommentStr = '[SFDC -> JIRA] -- Info sent to JIRA issue '+caseList[0].JIRA_Issue_Key__c+':\n\n '+comment;
                       system.debug('Case Comments For creation1..!!'+caseCommentStr);
                       JiraIntegrationHelper.addComment(parId,caseCommentStr);
                       retMsg = 'Comment has been added to JIRA ticket successfully.';
                       
                    }
                    // else set the error message
                    else
                    {
                       // set the JIRA message
                       retMsg = res.getBody();
                      
                    }
                    
                 }
                 catch(Exception ex)
                 {
                     // set the exception message
                     retMsg = 'There is some technical problem. Please get in touch with your Admin.';
                    
                 } 
                 
       return retMsg;   
    } 
     
     
     // method is used to parse the JSON response
     static map<string,string> parseResponse(string jsonStr){
          map<string,string> resultMap = new map<string,string>();
          JSONParser parser = JSON.createParser(jsonStr);
          while (parser.nextToken() != null){
            resultMap.put(parser.getCurrentName(),parser.getText());
          }
          system.debug('resultMap..!!'+resultMap);
          return resultMap;
     }

     public static void createSEActionTask(ID caseID,String subject){
            Id devRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Other Support Task').getRecordTypeId();

            String timeStr = datetime.now().format('yyyy-MM-dd hh:mm a');
            //Create the task for the JIRA Defect

                Task t = new Task();        
                t.whatId =caseID;      
                //t.whoId =c[0].ContactId;
                //t.ownerId=UserInfo.ID;   
                t.recordTypeId =devRecordTypeId ;       
                t.Status = 'Not Started';       
                //t.Severity__c = c[0].Severity__c;        
                t.Priority ='Normal'; 
                t.subject =subject;      
                t.description='Task auto created by JIRA Integration by  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' and '+ timeStr + ')';        
                t.Type ='SE Action';
                insert t; 

     }
}