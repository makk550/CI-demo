/*
Created By: Tarun Sharma
Created On: 02/08/2016
Purpose: US197678: Rally Cons - Build a batch file to associate defects to converted cases
Modified By:
*/

global class defectMigration implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful{
    global List<DefectMigration__c> defectMigrationList;
    global String insertUiURL;
    global boolean isUpdateCallOut=false;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        defectMigrationList = new List<DefectMigration__c>(); 
        String defectMigrationQuery = 'Select CaseId__c, Defect_Object_Id__c, Migrated__c from DefectMigration__c where Migrated__c=false';
        return Database.getQueryLocator(defectMigrationQuery);    
    }
    
    global void execute(Database.BatchableContext BC, List<DefectMigration__c> listOfDefectMigration){
        if(listOfDefectMigration<>null && listOfDefectMigration.size()>0){    
            for(DefectMigration__c defectMigrationObj:listOfDefectMigration){
                system.debug(defectMigrationObj.Defect_Object_Id__c+'defectMigrationObj: '+defectMigrationObj.caseId__c);
                if(String.isNotBlank(defectMigrationObj.CaseId__c) && defectMigrationObj.Defect_Object_Id__c.contains('/defect/')){
                    List<Case> caseObj = [Select CA_Product_Controller__r.Name, CA_Product_Component__r.Name, CA_Product_Component__r.Component_Code__c,CaseNumber, Subject, Id, Tops_Support_Site_ID__c, Site_Association__r.Name from Case where id=:defectMigrationObj.CaseId__c];
                    if(caseObj<>null && caseObj.size()>0 && String.isNotBlank(defectMigrationObj.Defect_Object_Id__c) && String.isNotBlank(caseObj[0].CA_Product_Component__r.Name)){
                        String assoicateDefectEndPoint = getDefectNumber(defectMigrationObj.Defect_Object_Id__c, caseObj[0].CA_Product_Component__r.Name);
                        system.debug('%%%%%%%%%assoicateDefectEndPoint%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+assoicateDefectEndPoint);
                        String defectResult = getDefectDetails(assoicateDefectEndPoint, caseObj);
                        if(String.isNotBlank(defectResult) && defectResult == 'success'){
                            defectMigrationObj.Migrated__c = true;
                            defectMigrationList.add(defectMigrationObj);
                        }
                    }
                }
            }
        }
    } 
    
    global void finish(Database.BatchableContext BC){
        if(defectMigrationList <> null && defectMigrationList.size()>0){
            List<Database.SaveResult> updateDefectMigration = Database.update(defectMigrationList,false);
            for(Database.SaveResult defectMigrationObject:updateDefectMigration){
                if(defectMigrationObject.isSuccess()){
                    system.debug('SUCCESSFULLY UPDATE');    
                }else{
                    system.debug('Defect Migration Failure id: '+defectMigrationObject.getId()+' Error message: '+defectMigrationObject.getErrors());    
                } 
            }
        }   
    }
    
    //To fetch defect number and product name
    private String getDefectNumber(String defectObjectId, String productName){
        String defectNumber;
        String AssoicateEndpoint;
        system.debug('######defectObjectId####'+defectObjectId);
        if(defectObjectId.contains('defect/')){
            List<String> splitDefectObjectId = defectObjectId.split('defect/');
            defectObjectId = splitDefectObjectId[1];
            if(defectObjectId.contains('.js')){
                defectObjectId = defectObjectId.removeEndIgnoreCase('.js');
            }
            defectObjectId = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/'+defectObjectId;
            system.debug('######defectObjectId####2'+defectObjectId);
            // web service call to get defect Number
            Http httpObj = new Http();
            HttpRequest req = new HttpRequest(); 
            req.setMethod('GET');
            Organization organizationObj = [select Id, IsSandbox from Organization limit 1 ];
            system.debug('######organizationObj.IsSandbox####2'+organizationObj.IsSandbox);
            if(organizationObj.IsSandbox){
                req.setHeader('Username','tarun.sharma@ca.com');
                req.setHeader('password','Rally123!');
                req.setHeader('authorization','Basic dGFydW4uc2hhcm1hQGNhLmNvbTpSYWxseTEyMyE=');
            }else{
                req.setHeader('Username','sgunda@rallydev.com');
                req.setHeader('password','Boulder2016!!!');
                req.setHeader('authorization','Basic c2d1bmRhQHJhbGx5ZGV2LmNvbTpCb3VsZGVyMjAxNiEhIQ==');
            }
            req.setEndpoint(defectObjectId); 
            HttpResponse res;
            if(!Test.isRunningTest()){
                res = httpObj.send(req);
            }else{
                res = new HttpResponse();
                res.setBody('{"Defect": {"FormattedID": "DE17307","Errors": [],"Warnings": []}}');
                res.setStatusCode(200);
                res.setStatus('OK'); 
                res.setHeader('Content-Type', 'application/json');
            }
            system.debug('$$$%$%$$%$%$%$%$%$%$%%$%'+res.getBody());
            Map<String, Object> mapOfDefectJSON;
            if(res.getBody()<>null){
                mapOfDefectJSON =(Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                if(mapOfDefectJSON<>null && mapOfDefectJSON.get('Defect')<>null){
                    Map<String, Object> defectJSON =(Map<String, Object>)mapOfDefectJSON.get('Defect');  
                    if(defectJSON.get('FormattedID')<>null){
                        defectNumber =(String)defectJSON.get('FormattedID');
                        if(productName.contains(' ')){
                            productName = productName.replaceAll(' ','+');
                        }else{
                            productName = productName;
                        }    
                        AssoicateEndpoint = '&defectNumber='+defectNumber+'&product='+productName;
                    }
                }
            }
        }
        return AssoicateEndpoint;
    }
    
    //check defect exist in rally or not. if defect exist get all defect details
    private String getDefectDetails(String defectEndPoint, List<Case> caseObj){
        String responseResult;
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint(prepareEndPoint()+defectEndPoint); 
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(Integer.valueof(Label.RallyTimeout));
        String responseFromGetService;
        if(!Test.isRunningTest()){
            Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
            responseFromGetService = Layer7UtilCalloutObj.processLayer7Services(req);
        }else{
            responseFromGetService = '[{"operation":"GET","successful":true,"errors":null,"warnings":null,"defect":{"defectNumber":"DE32","defectId":"https://rally1.rallydev.com/slm/webservice/v2.0/defect/61133139123","subject":"Test Mike B second update","description":"test -- modified to test sasc integration","status":"Open","defectSeverity":"Major Problem","defectPripority":"High Attention","defectOwner":"stephen.breese@ca.com","targetedReleaseNumber":null,"targetReleaseDate":"2016-08-23T09:17:47.540-04:00","resolution":"None","comments":[],"blocked":false,"blockedReason":null,"workspaceName":"Sandbox - Rally Support"}}]';
        }
        system.debug('####response%%%'+responseFromGetService);
        if(String.isNotBlank(responseFromGetService)){
            responseResult = prepareResponse(responseFromGetService, caseObj);
            if(string.isNotBlank(responseResult) && responseResult == 'success'){
               return responseResult; 
            }
        }
        return 'failure';
    }
    
    //prepare GET service end point
    private String prepareEndPoint(){
        String retreiveEndPoint;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
            retreiveEndPoint = Label.RallyGetEndpointQA;
        }
        else {
             retreiveEndPoint = Label.RallyProductionGetEndpoint;
        }
        system.debug(retreiveEndPoint+'@##@#@##'+orgObj.IsSandbox);
        return retreiveEndPoint;
    }
    
    //prepare response from the service and create new defect in SC
    private String prepareResponse(String serviceResponse, List<Case> caseObj){
        serviceResponse = serviceResponse.replace('\\"','\\\"');
        serviceResponse = serviceResponse.removeStart('[');
        serviceResponse = serviceResponse.removeEnd(']');
        
        AssociateDefectResponse associateDefectObject = (AssociateDefectResponse)JSON.deserialize(serviceResponse, AssociateDefectResponse.class);    
        system.debug('#@#!#!#!#!#!#!#!#!#!#!'+associateDefectObject);
        
        if(associateDefectObject<>null){
            if(associateDefectObject.successful){
                if(associateDefectObject.Defect<>null && associateDefectObject.Defect.defectId <> null){
                    updateDefectCaseAssociation(associateDefectObject.Defect.defectId, caseObj);
                }
                
                if(isUpdateCallOut && associateDefectObject.Defect<>null){
                    String defectUUID;
                    if(String.isNotBlank(insertUiURL)){
                        defectUUID = insertUiURL.substringAfterLast('/');
                        if(String.isNotBlank(defectUUID)){
                            List<Defect__c> listOfDefectObj = [Select Id from Defect__c where Name =: associateDefectObject.Defect.defectNumber AND Defect_UUID__c =: defectUUID AND  R_D_System__c =: associateDefectObject.Defect.workspaceName limit 1];  
                            
                            if(listOfDefectObj<>null && listOfDefectObj.size()>0){
                                Defect_Case_Association__c defectCaseAssociationObj = new Defect_Case_Association__c();
                                defectCaseAssociationObj.Case__c = caseObj[0].id;
                                defectCaseAssociationObj.Defect__c = listOfDefectObj[0].id;
                                insert defectCaseAssociationObj;
                                return 'success';
                            }else{
                                Defect__c defectObj = new Defect__c();
                                
                                if(associateDefectObject.Defect.defectNumber <> null){
                                    defectObj.Name = associateDefectObject.Defect.defectNumber;
                                }
                                if(associateDefectObject.Defect.defectId <> null){
                                    defectObj.Defect_Object_ID__c = associateDefectObject.Defect.defectId;
                                }
                                if(associateDefectObject.Defect.subject <> null){
                                    defectObj.Subject__c = associateDefectObject.Defect.subject;
                                }
                                if(associateDefectObject.Defect.description <> null){
                                    defectObj.Description__c = associateDefectObject.Defect.description;
                                }
                                if(associateDefectObject.Defect.status <> null){
                                    defectObj.Status__c = associateDefectObject.Defect.status;
                                }
                                if(associateDefectObject.Defect.defectSeverity <> null){
                                    defectObj.Severity__c = associateDefectObject.Defect.defectSeverity;
                                }
                                if(associateDefectObject.Defect.defectPripority <> null){
                                    defectObj.Priority__c = associateDefectObject.Defect.defectPripority;
                                }
                                if(associateDefectObject.Defect.defectOwner <> null){
                                    defectObj.Defect_Owner__c = associateDefectObject.Defect.defectOwner;
                                }
                                if(associateDefectObject.Defect.targetedReleaseNumber <> null){
                                    defectObj.Targeted_Release_Number__c = associateDefectObject.Defect.targetedReleaseNumber;
                                }
                                if(associateDefectObject.Defect.targetReleaseDate <> null){
                                    defectObj.Target_Release_date__c = Date.valueOf(associateDefectObject.Defect.targetReleaseDate);
                                }
                                if(associateDefectObject.Defect.resolution <> null){
                                    defectObj.Resolution__c = associateDefectObject.Defect.resolution;
                                }
                                if(String.isNotBlank(insertUiURL)){
                                    defectObj.Defect_URL__c = insertUiURL;
                                    defectObj.Defect_UUID__c = insertUiURL.substringAfterLast('/');
                                }
                                if(associateDefectObject.Defect.blocked <> null){
                                    defectObj.Blocked__c = associateDefectObject.Defect.blocked;
                                }
                                if(associateDefectObject.Defect.blockedReason <> null){
                                    defectObj.Blocked_Reason__c = associateDefectObject.Defect.blockedReason;   
                                }
                                if(associateDefectObject.Defect.workspaceName<>null){
                                    defectObj.R_D_System__c=  associateDefectObject.Defect.workspaceName;
                                }
                                insert defectObj;  
                                
                                if(defectObj<>null){
                                    Defect_Case_Association__c defectCaseAssociationObj = new Defect_Case_Association__c();
                                    defectCaseAssociationObj.Case__c = caseObj[0].id;
                                    defectCaseAssociationObj.Defect__c = defectObj.id;
                                    insert defectCaseAssociationObj;
                                    return 'success';
                                }else{
                                    system.debug('Defect not inserted');   
                                    return 'success';
                                }
                            }   
                        }
                    }
                }
            }
        }   
      return 'failure';  
    }
    
    //Call out to update rally defect with case
    private void updateDefectCaseAssociation(String defectURL, List<Case> caseObj){
        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest();
        httpRequestObj.setMethod('PUT');
        httpRequestObj.setEndpoint(prepareUpdateEndPoint());
        httpRequestObj.setHeader('Content-Type', 'application/json');
        httpRequestObj.setBody(prepareUpdateBody(defectURL,caseObj));
        httpRequestObj.setTimeout(Integer.valueof(Label.RallyTimeout));
        HTTPResponse httpResponseObj;
        if(httpRequestObj <> null){
            String responseFromUpdateService;
            if(!Test.isRunningTest()){
                Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
                responseFromUpdateService = Layer7UtilCalloutObj.processLayer7Services(httpRequestObj);
            }else{
                responseFromUpdateService = '[{"operation":"PUT","successful":true,"errors":null,"warnings":null,"objectId":"https://rally1.rallydev.com/slm/webservice/v2.0/defect/61133139123","uiId":"DE32","uiUrl":"https://rally1.rallydev.com/#/44905827/detail/defect/61133139123","defectPriority":"High Attention","defectSeverity":"Major Problem","workspaceName":"Sandbox - Rally Support"}]';
            }
            system.debug('%%%responseFromUpdateService%%%'+responseFromUpdateService);
            if(string.isNotBlank(responseFromUpdateService)){
                prepareUpdateResponse(responseFromUpdateService);
            }
        }
    }
    
    //prepare Update service end point
    private String prepareUpdateEndPoint(){
        String retreiveEndPoint;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
            retreiveEndPoint = Label.RallyEndpointQA;
        }
        else {
             retreiveEndPoint = Label.RallyProductionEndpoint;
        }
        return retreiveEndPoint;
   }

    //prepare request for update call out
    private string prepareUpdateBody(String defectURL, List<Case> caseObj){        
        JSONGenerator jsonGeneratorObj = JSON.createGenerator(true);
        jsonGeneratorObj.writeStartObject();
        jsonGeneratorObj.writeStringField('objectId',defectURL);
        jsonGeneratorObj.writeStringField('product',caseObj[0].CA_Product_Component__r.Name);
        jsonGeneratorObj.writeStringField('externalSystemNumber',caseObj[0].CaseNumber);
        jsonGeneratorObj.writeStringField('externalSystemID',caseObj[0].Id);
        jsonGeneratorObj.writeStringField('customer',caseObj[0].Site_Association__r.Name+' ('+caseObj[0].Tops_Support_Site_ID__c+')');
        jsonGeneratorObj.writeEndObject();
        String jsonRequest = jsonGeneratorObj.getAsString();
        return jsonRequest;
    }
    
    //prepare update response for update call out and if we get success response from the service then set isUpdateCallout flag to true
    private void prepareUpdateResponse(String updateResponse){
        updateResponse = updateResponse.replace('\\"','\\\"');
        updateResponse = updateResponse.removeStart('[');
        updateResponse = updateResponse.removeEnd(']');
        
        DefectResponse defectResponseObject = (DefectResponse)JSON.deserialize(updateResponse, DefectResponse.class);
        if(defectResponseObject.successful){
            isUpdateCallOut = true;
            insertUiURL = defectResponseObject.uiUrl;
        }
   }
    
    //To prepare fake response
    private String prepareFakeResponse(){
        String dummyResponse = '{"Defect": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/defect/12245610760", "_refObjectUUID": "173c59eb-14d0-4fcf-b58b-6174c51c5a5f", "_objectVersion": "12", "_refObjectName": "Copying a story from the PI Hierarchy app does not retain tags on the story", "CreationDate": "2013-06-05T01:49:59.378Z", "_CreatedAt": "Jun 4, 2013", "ObjectID": 12245610760, "ObjectUUID": "173c59eb-14d0-4fcf-b58b-6174c51c5a5f", "VersionId": "12", "Subscription": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/subscription/400059", "_refObjectUUID": "76de2093-5f8d-403d-a2db-fcec9c5c7079", "_refObjectName": "Rally Development 100", "_type": "Subscription"}, "Workspace": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/41529001", "_refObjectUUID": "3497d043-3ea7-4c8a-bf78-069847936c13", "_refObjectName": "Rally", "_type": "Workspace"}, "Changesets": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Changesets", "_type": "Changeset", "Count": 0}, "Description": "\u003Cb\u003ETo replicate:\u003C/b\u003E     \u003Cdiv\u003E \u003Col\u003E \u003Cli\u003EStart by creating a story with tags, and a PI Feature parent\u003C/li\u003E \u003Cli\u003EInstall the Portfolio Hierarchy App, using Feature as the type\u003C/li\u003E \u003Cli\u003EExpand the PI Feature created in step 1\u003C/li\u003E \u003Cli\u003EClick on the gear of the story, select copy\u003C/li\u003E \u003Cli\u003EClick on the new story\u003C/li\u003E \u003C/ol\u003E \u003Cdiv\u003E\u003Cb\u003EExpected result: \u003C/b\u003E&nbsp;New story will have the same tag as the story it was copied from\u003C/div\u003E \u003C/div\u003E \u003Cdiv\u003E\u003Cb\u003EActual result: \u003C/b\u003E&nbsp;New story does not have any tags\u003C/div\u003E \u003Cdiv\u003E\u003Cbr /\u003E\u003C/div\u003E \u003Cdiv\u003ECopying a story from the detail page of a story using the action Copy option creates a new story with same tags.\u003C/div\u003E \u003Cdiv\u003E\u003Cbr /\u003E\u003C/div\u003E \u003Cdiv\u003E\u003Ci\u003E\u003Cfont color=\"#0000ff\"\u003ENote that this is also seen when copying from the Kanban board and may happen on other boards as well.&nbsp;\u003C/font\u003E\u003C/i\u003E\u003C/div\u003E\u003Cdiv\u003E\u003Ci\u003E\u003Cfont color=\"#0000ff\"\u003E\u003Cbr /\u003E\u003C/font\u003E\u003C/i\u003E\u003C/div\u003E\u003Cdiv\u003E\u003Cfont color=\"#0000ff\"\u003E\u003Ci\u003ESecond Note: this is also seen when copy started using EDP [Conny100]\u003C/i\u003E\u003C/font\u003E\u003C/div\u003E", "Discussion": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Discussion", "_type": "ConversationPost", "Count": 2}, "DisplayColor": "#f9a814", "Expedite": false, "FormattedID": "DE17307", "LastUpdateDate": "2016-05-20T16:11:35.032Z", "LatestDiscussionAgeInMinutes": 1055494, "Milestones": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Milestones", "_type": "Milestone", "_tagsNameArray": [], "Count": 0}, "Name": "Copying a story from the PI Hierarchy app does not retain tags on the story", "Notes": "", "Owner": null, "Project": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/project/10823784037", "_refObjectUUID": "dc7403c1-a073-44e9-a1b3-a1236f0ce5d6", "_refObjectName": "ALM", "_type": "Project"}, "Ready": false, "RevisionHistory": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/revisionhistory/12245610761", "_refObjectUUID": "67a17a81-2be7-410c-9848-37aa6a74b900", "_type": "RevisionHistory"}, "Tags": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Tags", "_type": "Tag", "_tagsNameArray": [], "Count": 0}, "LastBuild": null, "LastRun": null, "PassingTestCaseCount": 0, "ScheduleState": "Idea", "ScheduleStatePrefix": "I", "TestCaseCount": 0, "AcceptedDate": null, "AffectsDoc": false, "Attachments": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Attachments", "_type": "Attachment", "Count": 0}, "Blocked": false, "BlockedReason": null, "Blocker": null, "ClosedDate": "2016-05-20T16:11:35.018Z", "DefectSuites": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/DefectSuites", "_type": "DefectSuite", "Count": 0}, "DragAndDropRank": "O~{Fn~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", "Duplicates": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Duplicates", "_type": "Defect", "Count": 0}, "Environment": "Production", "FixedInBuild": null, "FoundInBuild": "master-10096", "InProgressDate": null, "Iteration": null, "OpenedDate": "2013-06-05T15:48:25.424Z", "Package": null, "PlanEstimate": null, "Priority": "Normal", "Recycled": false, "Release": null, "ReleaseNote": false, "Requirement": null, "Resolution": "Aged Out", "SalesforceCaseID": null, "SalesforceCaseNumber": null, "Severity": "Minor Problem", "State": "Closed", "SubmittedBy": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/user/2213512124", "_refObjectUUID": "832972e3-7bbf-40b4-b12d-3444b8987fd7", "_refObjectName": "Jeri 100", "_type": "User"}, "TargetBuild": null, "TargetDate": null, "TaskActualTotal": 0.0, "TaskEstimateTotal": 0.0, "TaskRemainingTotal": 0.0, "TaskStatus": "NONE", "Tasks": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/Tasks", "_type": "Task", "Count": 0}, "TestCase": null, "TestCaseResult": null, "TestCaseStatus": "NONE", "TestCases": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/TestCases", "_type": "TestCase", "Count": 0}, "VerifiedInBuild": null, "c_strhidden": null, "c_addat2H": null, "c_AffectedCustomers": "Epsilon Data Management, LLC&#124;Blue Cross and Blue Shield of Florida, Inc.", "c_ALMKanbanState": null, "c_ALMpullrequest": {}, "c_almpagedetailpullrequest": {}, "c_AnticipatedToggleOnDate": null, "c_appcatalogpullrequest": {}, "c_appsdkpullrequest": {}, "c_AUKanbanState": null, "c_BCR": null, "c_BigDataRebuild": {}, "c_BigMacKanban": null, "c_BlockedReasonDeprecated": null, "c_BoardLane": null, "c_Boo": null, "c_BrowsersTested": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_BrowsersTested", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_Build": null, "c_BungeeBan": null, "c_BurroVersion": null, "c_Churropullrequest": {}, "c_CodeArea": null, "c_CodeReview": null, "c_Collaborators": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_Collaborators", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_CRTracks": null, "c_Customer": null, "c_DataMigration": null, "c_DataMoveType": null, "c_DataMovesKanban": null, "c_DBDataRequest": null, "c_DE2datefield2": null, "c_DEdatefield2": null, "c_DefectActual": null, "c_DefectsBucket": null, "c_Deferred": null, "c_DeliverableTo": null, "c_DeployDate": null, "c_Dina": null, "c_Discipline": null, "c_DMAIC": null, "c_EffectedBrowser": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_EffectedBrowser", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_EphemeralRebuild": {}, "c_ExceptionEmail": false, "c_ExpectedCost": null, "c_FeatureTeam": null, "c_FeatureToggleStatus": null, "c_FinanceKanban": null, "c_FoundBy": null, "c_Gaucho": null, "c_gnarwhalstorystates": null, "c_gnarwhalstorystatesnew": null, "c_hiddenDEfieldat2": null, "c_IdeaMgtKanban": null, "c_IdeaURL": {}, "c_IE9Overhead": null, "c_ImpactonOps": null, "c_ImpactedServices": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_ImpactedServices", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_IntegrationTAMvotes": null, "c_IntegrationsKanban": null, "c_IntroducedBy": null, "c_ITSwimlane": null, "c_JediStates2": null, "c_Jenkins": null, "c_Kanban": null, "c_KanbanState": null, "c_KanbanStateSales": null, "c_KanbanStateSimple": null, "c_KanBanStatesTRM": null, "c_LeatherPantsKanban": null, "c_MarketingwithCAKanban": null, "c_MissingAutomatedTest": null, "c_MobileOS": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_MobileOS", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_NamedAccount": null, "c_NumberofCases": 2, "c_ObservedLocation": null, "c_oDBDataRequest": null, "c_OnBranch": null, "c_OnCall": null, "c_OnDemandZip": {}, "c_OnPremImpact": false, "c_OpsImpact": null, "c_PartnerKanbanStates": null, "c_PeerReview": null, "c_PER": null, "c_Piñatapullrequest": {}, "c_PlannedWork": null, "c_PricingKanbanState": null, "c_PrimaryDept": null, "c_PrimarySystem": null, "c_PriorityGroup": null, "c_Product": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_Product", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_PumaKanbanState": null, "c_PushedToMaster": null, "c_RallyWShidden": null, "c_RallyValue": null, "c_ReOpenedOLD": null, "c_ReadyDeprecated": null, "c_RealOwner": null, "c_Recording": {}, "c_ReleasedtoCustomer": null, "c_ReOpened": null, "c_Repo": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_Repo", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_ReposAffected": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_ReposAffected", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_reusestring": null, "c_RootCause": null, "c_RootCauseCatergory": null, "c_RootCauseDetails": null, "c_SalesforceCase": {}, "c_SalesforceCouncilKanban": null, "c_SalesRegion": null, "c_SecurityKanban": null, "c_ServicesKanbanState": null, "c_SharedTasks": null, "c_Shoulddefectbeclosed": null, "c_Shoulditbeclosed": null, "c_sombreropullrequest": {}, "c_SPOTW": null, "c_SupportKanbanState": null, "c_TCImpact": null, "c_TechnologyPartnerKanban": null, "c_TechnologyPartnerPipelineState": null, "c_TerrisLane": null, "c_test": null, "c_TestArtifact": null, "c_TestBranch": null, "c_testestes": null, "c_TestFile": {}, "c_Testmultivalue": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/Defect/12245610760/c_Testmultivalue", "_type": "AllowedAttributeValue", "_tagsNameArray": [], "Count": 0}, "c_TestServer": null, "c_Testweblinkcustomfield": {}, "c_test1": null, "c_TestEstesBoolean": null, "c_Text": null, "c_Type": null, "c_ULKanbanState": null, "c_UXKanban": null, "c_UXStoryStates": null, "c_Walkthrough": null, "c_WatchList": "Jeri", "c_WCKanbanStates": null, "c_WebLink": {}, "c_xcv": false, "c_zUnusedString": null, "c_zzTop": null, "Errors": [], "Warnings": []}}';
        return dummyResponse;
    }
}