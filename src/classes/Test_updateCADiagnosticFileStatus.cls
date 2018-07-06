@isTest
public class Test_updateCADiagnosticFileStatus {
    /*
    private static testMethod void testUpdateCADiagnosticFileStatus(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();  
       String diagnosticId = createDiagnosticRecord(Test_SetupData.caseNumberId);     
       updateCADiagnosticFileStatus.requestPayload reqObj = new updateCADiagnosticFileStatus.requestPayload();
       updateCADiagnosticFileStatus.diagnosticFiles diagnosticObj = new updateCADiagnosticFileStatus.diagnosticFiles();
       List<updateCADiagnosticFileStatus.diagnosticFiles> listOfDiagnostic = new List<updateCADiagnosticFileStatus.diagnosticFiles>();
       diagnosticObj.Id = diagnosticId; 
       listOfDiagnostic.add(diagnosticObj); 
       reqObj.diagnosticFiles = listOfDiagnostic;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/updateDiagnosticFileStatus';
       req.httpMethod = 'PUT';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       updateCADiagnosticFileStatus.updateFileStatus(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testUpdateCADiagnosticFileStatus_Fail(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();       
       updateCADiagnosticFileStatus.requestPayload reqObj = new updateCADiagnosticFileStatus.requestPayload();
       updateCADiagnosticFileStatus.diagnosticFiles diagnosticObj = new updateCADiagnosticFileStatus.diagnosticFiles();
       List<updateCADiagnosticFileStatus.diagnosticFiles> listOfDiagnostic = new List<updateCADiagnosticFileStatus.diagnosticFiles>();
       diagnosticObj.Id = ''; 
       listOfDiagnostic.add(diagnosticObj); 
       reqObj.diagnosticFiles = listOfDiagnostic;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/updateDiagnosticFileStatus';
       req.httpMethod = 'PUT';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       updateCADiagnosticFileStatus.updateFileStatus(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testUpdateCADiagnosticFileStatus_Null(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();       
       updateCADiagnosticFileStatus.requestPayload reqObj = new updateCADiagnosticFileStatus.requestPayload();
       updateCADiagnosticFileStatus.diagnosticFiles diagnosticObj = new updateCADiagnosticFileStatus.diagnosticFiles();
       List<updateCADiagnosticFileStatus.diagnosticFiles> listOfDiagnostic = new List<updateCADiagnosticFileStatus.diagnosticFiles>();
       reqObj.diagnosticFiles = listOfDiagnostic;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/updateDiagnosticFileStatus';
       req.httpMethod = 'PUT';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       updateCADiagnosticFileStatus.updateFileStatus(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testUpdateCADiagnosticFileStatus_Null1(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();       
       updateCADiagnosticFileStatus.requestPayload reqObj = new updateCADiagnosticFileStatus.requestPayload();
       updateCADiagnosticFileStatus.diagnosticFiles diagnosticObj = new updateCADiagnosticFileStatus.diagnosticFiles();
       List<updateCADiagnosticFileStatus.diagnosticFiles> listOfDiagnostic = new List<updateCADiagnosticFileStatus.diagnosticFiles>();
       reqObj.diagnosticFiles = null;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/updateDiagnosticFileStatus';
       req.httpMethod = 'PUT';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       updateCADiagnosticFileStatus.updateFileStatus(reqObj);
       Test.stopTest();
    }
    
    private static String createDiagnosticRecord(String caseId){
        CA_Diagnostics__c diagnosticObj = new CA_Diagnostics__c();
        diagnosticObj.Case__c = caseId;
        diagnosticObj.Description__c = 'test';
        diagnosticObj.File_location__c = 'www.test.com';
        diagnosticObj.File_Size__c = '2';
        diagnosticObj.Source__c = 'RE';
        diagnosticObj.Status__c = 'Published';
        insert diagnosticObj;
        return diagnosticObj.Id;
    }
	*/
}