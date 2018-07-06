@isTest
public class Test_createNewCaseInServiceCloud {
    private static testMethod void createNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.siteId = '105246';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    /*
    private static testMethod void createNewCaseSuccess1(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.siteId = '229226';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noEmailcreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '';
        caseObj.email = '';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noSiteIdcreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.siteId = '';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void numericSiteIdcreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.siteId = 'alpha';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '';
        caseObj.email = '';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noProductCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.product = '';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noTitleCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = '';
        caseObj.product = 'DAASA';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noDescriptionCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.product = 'DAASA';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '190817';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= '';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noConnectIdCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.product = 'DAASA';
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.product = 'DAASA';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void gmailCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.product = 'DAASA';
        caseObj.siteId = '8888883';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = '';
        caseObj.email = 'cso.enterprise@gmail.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void connectIdCreateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.createCaseRequest caseObj = new createNewCaseInServiceCloud.createCaseRequest();
        caseObj.contactMethod = 'C';
        caseObj.replyMethod = 'O';
        caseObj.returnInput = '1';
        caseObj.firstPreferredLanguage = 'ENG';
        caseObj.release = '1.1';
        caseObj.operatingSystem = 'OS';
        caseObj.priority = '4';
        caseObj.type = 'P';
        caseObj.pmfKey = 'SCONECT';
        caseObj.caseTitle = 'CustomerConnect Access';
        caseObj.product = 'DAASA';
        caseObj.siteId = '1743';
        caseObj.firstName = 'Arianza';
        caseObj.lastName = 'Brillianco';
        caseObj.connectId = 'alpha';
        caseObj.email = 'mokme01@ca.com';
        caseObj.phoneNumber = '+919652221000';
        caseObj.caseDescription= 'Test';
        
        String jsonString = JSON.serialize(caseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.createNewCaseMethod(caseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void updateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.updateCaseRequest updateCaseObj = new createNewCaseInServiceCloud.updateCaseRequest();
        updateCaseObj.pmfKey = 'SHATA07';
        updateCaseObj.activityDate = '2017-03-21T00:00:00Z';
        updateCaseObj.activityText = 'testing';
        Case caseNumberVal = [Select caseNumber from Case where id=:Test_SetupData.caseNumberId limit 1];
        updateCaseObj.caseNumber = caseNumberVal.caseNumber;
        updateCaseObj.connectId = 'SHATA07';
        
        String jsonString = JSON.serialize(updateCaseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.updateCaseMethod(updateCaseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void noCaseupdateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.updateCaseRequest updateCaseObj = new createNewCaseInServiceCloud.updateCaseRequest();
        updateCaseObj.pmfKey = 'SHATA07';
        updateCaseObj.activityDate = '2017-03-21T00:00:00Z';
        updateCaseObj.activityText = 'testing';
        updateCaseObj.caseNumber = '1223';
        updateCaseObj.connectId = 'SHATA07';
        
        String jsonString = JSON.serialize(updateCaseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.updateCaseMethod(updateCaseObj);
        Test.stopTest();
        
    }
    
    private static testMethod void nullCaseupdateNewCaseSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        createNewCaseInServiceCloud.updateCaseRequest updateCaseObj = new createNewCaseInServiceCloud.updateCaseRequest();
        updateCaseObj.pmfKey = 'SHATA07';
        updateCaseObj.activityDate = '2017-03-21T00:00:00Z';
        updateCaseObj.activityText = 'testing';
        updateCaseObj.caseNumber = '';
        updateCaseObj.connectId = 'SHATA07';
        
        String jsonString = JSON.serialize(updateCaseObj);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/serviceCloudCaseService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        
        createNewCaseInServiceCloud.updateCaseMethod(updateCaseObj);
        Test.stopTest();
        
    }*/
}