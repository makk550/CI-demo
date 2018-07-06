@isTest
public class CaseAttachments_UpdateCase_Test {
   
    private static testMethod void testUpload(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        
        System.debug('caseNumberId:'+Test_SetupData.caseNumberId) ;
        System.debug('siteIdNumber:'+Test_SetupData.siteIdNumber) ;
        Test.startTest();
        String caseNumber = [select id,caseNumber from Case where id = :Test_SetupData.caseNumberId].caseNumber;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/attachments_updateCase/';
        req.httpMethod = 'POST';
        
        req.addParameter('file', '/'+ caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/');
        req.addParameter('parentPath',  '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/' );
        req.addParameter('size', '112');
        req.addParameter('name', 'Test.txt' );
        req.addParameter('user', 'manar08@ca.com' );
        req.addParameter('dt', String.valueOf(system.now()));
        req.addParameter('action', 'update');
        RestContext.request = req;
        
        CaseAttachments_UpdateCase.ResponseMessage resp = CaseAttachments_UpdateCase.updateCaseWithAttachmentDetails();
        System.debug('resp:'+resp);
    	Test.stopTest();
    }
    
    private static testMethod void testDelete(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        
        System.debug('caseNumberId:'+Test_SetupData.caseNumberId) ;
        System.debug('siteIdNumber:'+Test_SetupData.siteIdNumber) ;
        Test.startTest();
        String caseNumber = [select id,caseNumber from Case where id = :Test_SetupData.caseNumberId].caseNumber;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/attachments_updateCase/';
        req.httpMethod = 'POST';
        
        req.addParameter('file', '/'+ caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/');
        req.addParameter('parentPath',  '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/' );
        req.addParameter('size', '112');
        req.addParameter('name', 'Test.txt' );
        req.addParameter('user', 'manar08@ca.com' );
        req.addParameter('dt', String.valueOf(system.now()));
        req.addParameter('action', 'delete');
        RestContext.request = req;
        
        CaseAttachments_UpdateCase.ResponseMessage resp = CaseAttachments_UpdateCase.updateCaseWithAttachmentDetails();
        System.debug('resp:'+resp);
    	Test.stopTest();
    }
    
    private static testMethod void testUplaod_whenPathisNull(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        
        System.debug('caseNumberId:'+Test_SetupData.caseNumberId) ;
        System.debug('siteIdNumber:'+Test_SetupData.siteIdNumber) ;
        Test.startTest();
        String caseNumber = [select id,caseNumber from Case where id = :Test_SetupData.caseNumberId].caseNumber;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/attachments_updateCase/';
        req.httpMethod = 'POST';
        
        req.addParameter('file', null);
        req.addParameter('parentPath',  '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/' );
        req.addParameter('size', '112');
        req.addParameter('name', 'Test.txt' );
        req.addParameter('user', 'manar08@ca.com' );
        req.addParameter('dt', String.valueOf(system.now()));
        req.addParameter('action', 'update');
        RestContext.request = req;
        
        CaseAttachments_UpdateCase.ResponseMessage resp = CaseAttachments_UpdateCase.updateCaseWithAttachmentDetails();
        System.debug('resp:'+resp);
    	Test.stopTest();
    }
    
    private static testMethod void testUplaod_whenCaseNotFound(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        
        System.debug('caseNumberId:'+Test_SetupData.caseNumberId) ;
        System.debug('siteIdNumber:'+Test_SetupData.siteIdNumber) ;
        Test.startTest();
        String caseNumber = [select id,caseNumber from Case where id = :Test_SetupData.caseNumberId].caseNumber;
        
        caseNumber = String.valueOf(Integer.valueOf(caseNumber)+1); 
            
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/attachments_updateCase/';
        req.httpMethod = 'POST';
        
        req.addParameter('file', '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/');
        req.addParameter('parentPath',  '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/' );
        req.addParameter('size', '112MB');
        req.addParameter('name', 'Test.txt' );
        req.addParameter('user', 'manar08@ca.com' );
        req.addParameter('dt', String.valueOf(system.now()));
        req.addParameter('action', 'update');
        RestContext.request = req;
        
        CaseAttachments_UpdateCase.ResponseMessage resp = CaseAttachments_UpdateCase.updateCaseWithAttachmentDetails();
        System.debug('resp:'+resp);
    	Test.stopTest();
    }
    
    private static testMethod void testUplaod_invalidParam(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        
        System.debug('caseNumberId:'+Test_SetupData.caseNumberId) ;
        System.debug('siteIdNumber:'+Test_SetupData.siteIdNumber) ;
        Test.startTest();
        String caseNumber = [select id,caseNumber from Case where id = :Test_SetupData.caseNumberId].caseNumber;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/attachments_updateCase/';
        req.httpMethod = 'POST';
        
        req.addParameter('file', '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/');
        req.addParameter('parentPath',  '/'+caseNumber+'/0'+Test_SetupData.siteIdNumber + '/files_from_customer/' );
        req.addParameter('size', '112MB');
        req.addParameter('name', 'Test.txt' );
        req.addParameter('user', 'manar08@ca.com' );
        req.addParameter('dt', String.valueOf(system.now()));
        req.addParameter('action', 'update');
        RestContext.request = req;
        
        CaseAttachments_UpdateCase.ResponseMessage resp = CaseAttachments_UpdateCase.updateCaseWithAttachmentDetails();
        System.debug('resp:'+resp);
    	Test.stopTest();
    }
    
}