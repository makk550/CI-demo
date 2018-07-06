@isTest
public class Test_projectSiteAssociationService {
    private static testMethod void testProjectSiteAssociationServiceSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        reqObj.description = 'Dummy';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFailure(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        reqObj.description = 'Dummy';
        reqObj.siteId = '18972232313';//unknow site,which does not exist
        reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFailDescription(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        //reqObj.description = '';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFailTitle(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        reqObj.description = 'Dummy';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        //reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFailSiteId(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        reqObj.description = 'Dummy';
        //reqObj.siteId = Test_SetupData.siteIdNumber;
        reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFailConnectId(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        //reqObj.connectId = 'shata07';
        reqObj.description = 'Dummy';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        reqObj.title = 'Dummy Title';
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
 		projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    private static testMethod void testProjectSiteAssociationServiceFail(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = null;//= new projectSiteAssociationService.requestPayload();
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
      private static testMethod void testProjectSiteAssociationServiceUpdateProject(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        reqObj.connectId = 'shata07';
        reqObj.description = 'UpdateDesc';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        reqObj.title = 'Update Title';
        reqObj.projectId = Test_SetupData.projectIdNumber;
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    } 
    private static testMethod void testProjectSiteAssociationServiceUpdateProjectFail(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        projectSiteAssociationService.requestPayload reqObj = new projectSiteAssociationService.requestPayload();
        //reqObj.connectId = 'shata07';
        //reqObj.description = 'UpdateDesc';
        reqObj.siteId = Test_SetupData.siteIdNumber;
        //reqObj.title = 'Update Title';
        reqObj.projectId = Test_SetupData.projectIdNumber;
        String jsonString = JSON.serialize(reqObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/projectSiteAssociationService';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        projectSiteAssociationService.insertAndUpdateProjectSiteAssocationRecord(reqObj);
        Test.stopTest();
    }
    
}