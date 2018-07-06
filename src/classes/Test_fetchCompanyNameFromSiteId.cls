@isTest
public class Test_fetchCompanyNameFromSiteId {

    private static testMethod void testfetchCompanyNameFromSiteSuccess(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       fetchCompanyNameFromSiteId.requestPayload reqObj = new fetchCompanyNameFromSiteId.requestPayload();
       fetchCompanyNameFromSiteId.siteId siteObj = new fetchCompanyNameFromSiteId.siteId();
       List<fetchCompanyNameFromSiteId.siteId> listOfSite = new List<fetchCompanyNameFromSiteId.siteId>();
       siteObj.siteId = Test_SetupData.siteIdNumber;
       listOfSite.add(siteObj);
       reqObj.siteId = listOfSite;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/fetchCompanyName';
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       fetchCompanyNameFromSiteId.callFetchCompanyNameFromSiteId(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testfetchCompanyNameFromSiteSuccess1(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       fetchCompanyNameFromSiteId.requestPayload reqObj = new fetchCompanyNameFromSiteId.requestPayload();
       fetchCompanyNameFromSiteId.siteId siteObj = new fetchCompanyNameFromSiteId.siteId();
       List<fetchCompanyNameFromSiteId.siteId> listOfSite = new List<fetchCompanyNameFromSiteId.siteId>();
       siteObj.siteId = Test_SetupData.siteIdNumber;
       listOfSite.add(siteObj);
       reqObj.siteId = listOfSite;
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/fetchCompanyName';
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       fetchCompanyNameFromSiteId.callFetchCompanyNameFromSiteId(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testfetchCompanyNameFromSiteSuccess2(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       fetchCompanyNameFromSiteId.requestPayload reqObj = new fetchCompanyNameFromSiteId.requestPayload();
       fetchCompanyNameFromSiteId.siteId siteObj = new fetchCompanyNameFromSiteId.siteId();
       List<fetchCompanyNameFromSiteId.siteId> listOfSite = new List<fetchCompanyNameFromSiteId.siteId>();
       siteObj.siteId = Test_SetupData.siteIdNumber;
       listOfSite.add(siteObj);
       reqObj.siteId = listOfSite;
       
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/fetchCompanyName';
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       fetchCompanyNameFromSiteId.callFetchCompanyNameFromSiteId(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testfetchCompanyNameFromSiteSuccess3(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       fetchCompanyNameFromSiteId.requestPayload reqObj = new fetchCompanyNameFromSiteId.requestPayload();
       reqObj.siteId = null;
       
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/fetchCompanyName';
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       fetchCompanyNameFromSiteId.callFetchCompanyNameFromSiteId(reqObj);
       Test.stopTest();
    }
    
    private static testMethod void testfetchCompanyNameFromSiteSuccess4(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       fetchCompanyNameFromSiteId.requestPayload reqObj = new fetchCompanyNameFromSiteId.requestPayload();
       fetchCompanyNameFromSiteId.siteId siteObj = new fetchCompanyNameFromSiteId.siteId();
       List<fetchCompanyNameFromSiteId.siteId> listOfSite = new List<fetchCompanyNameFromSiteId.siteId>();
       siteObj.siteId = '123';
       listOfSite.add(siteObj);
       reqObj.siteId = listOfSite;
       
        
       String jsonString = JSON.serialize(reqObj);
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/apexrest/fetchCompanyName';
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(jsonString);
       RestContext.request = req;
       RestContext.response= res;
       
       fetchCompanyNameFromSiteId.callFetchCompanyNameFromSiteId(reqObj);
       Test.stopTest();
    }
}