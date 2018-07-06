@IsTest(SeeAllData=True)
public class TestRallyCustomRestService{
    
   static testMethod void  testSuccessPUTMethod(){
   
     Case caseRec = [select id from Case where status ='Open' limit 1 ];
     Defect__c defect = new Defect__c();
     if (caseRec!=null){
         defect.Name = 'DE0000';
         defect.Defect_Object_ID__c = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/44734550279';
         defect.Defect_URL__c ='https://rally1.rallydev.com//#/43516634687/detail/defect/44734550279';
         defect.Subject__c = 'Test';
         defect.Description__c ='Test';
         defect.Status__c = 'Open';
         defect.Severity__c = 'Low';
         defect.Priority__c = 'Low';
         defect.Defect_Owner__c = 'Test'; 
         defect.Targeted_Release_Number__c = '8.0';
         defect.Target_Release_date__c = date.valueof('2015-07-16');
         defect.Resolution__c = 'Not Fixed';
         defect.Defect_UUID__c  = '44734550279';
         defect.R_D_System__c = 'CA Test Workspace';
         defect.Type__c='Certification Request';
         insert defect;
         Defect_Case_Association__c defectCaseAssociation = new Defect_Case_Association__c();
         defectCaseAssociation.Defect__c = defect.Id ; 
         defectCaseAssociation.case__c = caseRec.Id;
         insert defectCaseAssociation;
     }
     
     RallyCustomRestService.Defect defectRequest = new  RallyCustomRestService.Defect();
     defectRequest.defectNumber = 'DE0000';
     defectRequest.defectId = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/44734550279';
     defectRequest.subject = 'Subject';
     defectRequest.description = 'Create an incident';
     defectRequest.status = 'New';
     defectRequest.defectSeverity = 'Critical';
     defectRequest.defectPriority = 'High';
     defectRequest.defectOwner = 'Kiran';
     defectRequest.targetedReleaseNumber = '7.0';  
     defectRequest.targetReleaseDate = '2015-06-16kT';
     defectRequest.resolution = 'Fixed';
     defectRequest.updatedBy = 'dhriti';
     defectRequest.workspaceName ='CA Test Workspace';
     defectRequest.blocked = 'true';
     defectRequest.blockedReason ='test' ;
     defectRequest.defectType='Request for Information';
      
     RallyCustomRestService.comment comment = new RallyCustomRestService.comment();
     comment.comment = 'Comment1';
     comment.cdate = '2015-07-16';
     comment.author = 'patdh07';
     comment.authorName = 'Test';
     defectRequest.comments = new List<RallyCustomRestService.comment>();
     defectRequest.comments.add(comment);
     
     String JsonMsg=JSON.serialize(defectRequest);
   
     Test.startTest();
   
     //As Per Best Practice it is important to instantiate the Rest Context 
   
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
         
     req.requestURI = '/services/apexrest/UpdateDefect';  //Request URL
     req.httpMethod = 'PUT';//HTTP Request Type
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;

 
     RallyCustomRestService.callDefectUpdate(defectRequest);
     //System.assert(resp.statusMessage.contains('Test success message'));//Assert the response has message as expected 
     //System.assert(resp.statusCode.contains('Done'));

     Test.stopTest();
   
   }
    static testMethod void  testFailurePUTMethod(){
   
     
     RallyCustomRestService.Defect defectRequest = new  RallyCustomRestService.Defect();
     defectRequest.defectNumber = '1234';
     defectRequest.defectId = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/44734550279';
     defectRequest.subject = 'Subject';
     defectRequest.description = 'Create an incident';
     defectRequest.status = 'New';
     defectRequest.defectSeverity = 'Critical';
     defectRequest.defectPriority = 'High';
     defectRequest.defectOwner = 'Kiran';
     defectRequest.targetedReleaseNumber = '7.0';  
     defectRequest.targetReleaseDate = '2015-06-16KT';
     defectRequest.resolution = 'Fixed';
     defectRequest.updatedBy = 'dhriti';
     defectRequest.defectType='Expected Bug ';
     
     
     
     String JsonMsg=JSON.serialize(defectRequest);
   
     Test.startTest();
   
     //As Per Best Practice it is important to instantiate the Rest Context 
   
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
         
     req.requestURI = '/services/apexrest/UpdateDefect';  //Request URL
     req.httpMethod = 'PUT';//HTTP Request Type
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;

 
     RallyCustomRestService.callDefectUpdate(defectRequest);
     //System.assert(resp.statusMessage.contains('Test success message'));//Assert the response has message as expected 
     //System.assert(resp.statusCode.contains('Done'));

     Test.stopTest();
   
   }
    static testMethod void  testBlankRequest(){
   
     
     RallyCustomRestService.Defect defectRequest = new  RallyCustomRestService.Defect();
     defectRequest.defectNumber = '';
     defectRequest.defectId = '';
     defectRequest.subject = 'Subject';
     defectRequest.description = 'Create an incident';
     defectRequest.status = 'New';
     defectRequest.defectSeverity = 'Critical';
     defectRequest.defectPriority = 'High';
     defectRequest.defectOwner = 'Kiran';
     defectRequest.targetedReleaseNumber = '7.0';  
     defectRequest.targetReleaseDate = '2015-06-16KT';
     defectRequest.resolution = 'Fixed';
     defectRequest.updatedBy = 'dhriti';
     defectRequest.defectType='Expected Bug';
     
     
     
     String JsonMsg=JSON.serialize(defectRequest);
   
     Test.startTest();
   
     //As Per Best Practice it is important to instantiate the Rest Context 
   
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
         
     req.requestURI = '/services/apexrest/UpdateDefect';  //Request URL
     req.httpMethod = 'PUT';//HTTP Request Type
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;

 
     RallyCustomRestService.callDefectUpdate(defectRequest);
     //System.assert(resp.statusMessage.contains('Test success message'));//Assert the response has message as expected 
     //System.assert(resp.statusCode.contains('Done'));

     Test.stopTest();
   
   }

    static testMethod void  testInvalidDate(){
   
     Case caseRec = [select id from Case where status ='Open' limit 1 ];
     Defect__c defect = new Defect__c();
     if (caseRec!=null){
         defect.Name = 'DE0000';
         defect.Defect_Object_ID__c = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/44734550279';
         defect.Defect_URL__c ='https://rally1.rallydev.com//#/43516634687/detail/defect/44734550279';
         defect.Subject__c = 'Test';
         defect.Description__c ='Test';
         defect.Status__c = 'Open';
         defect.Severity__c = 'Low';
         defect.Priority__c = 'Low';
         defect.Defect_Owner__c = 'Test'; 
         defect.Targeted_Release_Number__c = '8.0';
         defect.Target_Release_date__c = date.valueof('2015-07-16');
         defect.Resolution__c = 'Not Fixed';
         defect.Type__c='Expected Bug';
         insert defect;
         Defect_Case_Association__c defectCaseAssociation = new Defect_Case_Association__c();
         defectCaseAssociation.Defect__c = defect.Id ; 
         defectCaseAssociation.case__c = caseRec.Id;
         insert defectCaseAssociation;
     }
     
     RallyCustomRestService.Defect defectRequest = new  RallyCustomRestService.Defect();
     defectRequest.defectNumber = 'DE0000';
     defectRequest.defectId = 'https://rally1.rallydev.com/slm/webservice/v2.0/defect/44734550279';
     defectRequest.subject = 'Subject';
     defectRequest.description = 'Create an incident';
     defectRequest.status = 'New';
     defectRequest.defectSeverity = 'Critical';
     defectRequest.defectPriority = 'High';
     defectRequest.defectOwner = 'Kiran';
     defectRequest.targetedReleaseNumber = '7.0';  
     defectRequest.targetReleaseDate = '2015-08-06KT';
     defectRequest.resolution = 'Fixed';
     defectRequest.updatedBy = 'dhriti';
     defectRequest.defectType='Request of Information';
     
      
     RallyCustomRestService.comment comment = new RallyCustomRestService.comment();
     comment.comment = 'Comment1';
     comment.cdate = '2015-07-16';
     comment.author = 'patdh07';
     comment.authorName = 'Test';
     defectRequest.comments = new List<RallyCustomRestService.comment>();
     defectRequest.comments.add(comment);
     
     String JsonMsg=JSON.serialize(defectRequest);
   
     Test.startTest();
   
     //As Per Best Practice it is important to instantiate the Rest Context 
   
     RestRequest req = new RestRequest(); 
     RestResponse res = new RestResponse();
         
     req.requestURI = '/services/apexrest/UpdateDefect';  //Request URL
     req.httpMethod = 'PUT';//HTTP Request Type
     req.requestBody = Blob.valueof(JsonMsg);
     RestContext.request = req;
     RestContext.response= res;

 
     RallyCustomRestService.callDefectUpdate(defectRequest);
     //System.assert(resp.statusMessage.contains('Test success message'));//Assert the response has message as expected 
     //System.assert(resp.statusCode.contains('Done'));

     Test.stopTest();
   
   }
 }