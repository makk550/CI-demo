/*
Created By: Tarun Sharma
Created On: 04/25/2016
Purpose: Test Class to cover case UI
Modified By: Tarun Sharma
Modified On: 08/24/2016
Purpose: To cover new logic
*/
@isTest
public class Test_CaseArchivalDetailsController{
    
    private static testMethod void testCaseArchivalDetailsController(){
        createTestData();
        test.startTest();
        caseArchivalDetails_MockResult();
        caseArchivalDetailsStar_MockResult();
        caseArchivalDetailsNull_MockResult();
        caseArchivalDetails_MockChild();
        caseArchivalDetailsLayer7_MockChild();
        test.stopTest();
    }
    
    private static testMethod void testEmailsArchivalDetailsController(){
        createTestData();
        test.startTest();
        emailArchivalDetails_MockResult();
        emailArchivalDetailsStar_MockResult();
        emailrchivalDetailsEidNull_MockResult();
        emailrchivalDetailsSourceNull_MockResult();
        emailrchivalDetailsNull_MockResult();
        emailArchivalDetailsLayer7_MockChild();
        emailArchivalDetailsLayer7_Attachment();
        test.stopTest();
    }
    
    private static void createTestData(){
        AWS_Credentials__c awsCredentials = new AWS_Credentials__c();
        awsCredentials.Name = 'Case Archival';
        awsCredentials.Secret__c = 'nZOOCL0j+NDww7rfrjA0WDzkx+g9a5OTA+YHaZ/w';
        awsCredentials.Key__c = 'AKIAIXRMUKP2XKCSHNBA';
        insert awsCredentials;
    }
    
    private static void caseArchivalDetails_MockResult(){
        Test.setMock(HttpCalloutMock.class, new  AWSBucketAccess_MockResponse());
        apexpages.currentpage().getparameters().put('Cid', 'NIMSOFT/0000-00131072/caseDetails_00131072');
        CaseArchivalDetailsController controller = new CaseArchivalDetailsController();
    }
    
    private static void caseArchivalDetailsStar_MockResult(){
        apexpages.currentpage().getparameters().put('Cid', 'Star/0000-00131072/caseDetails_00131072');
        CaseArchivalDetailsController controller = new CaseArchivalDetailsController();
    }
    
    private static void caseArchivalDetailsNull_MockResult(){
        apexpages.currentpage().getparameters().put('Cid', '');
        CaseArchivalDetailsController controller = new CaseArchivalDetailsController();
    }
    private static void caseArchivalDetails_MockChild(){
        Test.setMock(HttpCalloutMock.class, new CaseArchivalDetails_MockResponse());
        CaseArchivalDetailsController.getRelatedChildDetails('Case Comment', '/RelatedXMLs/caseComments.xml','NIMSOFT/0000-00131072/caseDetails_00131072','NIMSOFT');
    }
    
    private static void caseArchivalDetailsLayer7_MockChild(){
        Test.setMock(HttpCalloutMock.class, new CaseArchivalDetailsl_EmailMockResponse());
        CaseArchivalDetailsController.getRelatedChildDetails('Emails', '/RelatedXMLs/00000_ActivityHistory_00040377.xml','Layer7/00000_caseDetails_00040377','Layer7');
    }
    
    private static void emailArchivalDetails_MockResult(){
        Test.setMock(HttpCalloutMock.class, new  AWSBucketAccess_EmailMockResponse());
        apexpages.currentpage().getparameters().put('Eid', 'EmailMessageContent/1_SampleEmailMessageContent_00040377.xml');
        apexpages.currentpage().getparameters().put('source', 'Layer7');
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
    }
    
    private static void emailArchivalDetailsStar_MockResult(){
        apexpages.currentpage().getparameters().put('Eid', 'EmailMessageContent/1_SampleEmailMessageContent_00040377.xml');
        apexpages.currentpage().getparameters().put('source', 'Star');
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
    }
    
    private static void emailrchivalDetailsEidNull_MockResult(){
        apexpages.currentpage().getparameters().put('Eid', '');
        apexpages.currentpage().getparameters().put('source', 'Layer7');
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
    }
    
    private static void emailrchivalDetailsSourceNull_MockResult(){
        apexpages.currentpage().getparameters().put('Eid', 'EmailMessageContent/1_SampleEmailMessageContent_00040377.xml');
        apexpages.currentpage().getparameters().put('source', '');
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
    }
    
    private static void emailrchivalDetailsNull_MockResult(){
        apexpages.currentpage().getparameters().put('Eid', '');
        apexpages.currentpage().getparameters().put('source', '');
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
    }
    
    private static void emailArchivalDetailsLayer7_MockChild(){
        Test.setMock(HttpCalloutMock.class, new EmailArchivalDetailsl_EmailMockResponse());
        CaseArchivalEmailContentController.getRelatedChildDetails('Attachments', '/RelatedXMLs/1_sampleEmailAttachments_00040377.xml','EmailMessageContent/1_SampleEmailMessageContent_00040377.xml','Layer7');
    }
    
    private static void emailArchivalDetailsLayer7_Attachment(){
        CaseArchivalEmailContentController CaseArchivalEmailContentObj = new CaseArchivalEmailContentController();
        CaseArchivalEmailContentObj.returnAttachmentURL();  
        system.currentpagereference().getparameters().put('attachmentId','Layer7Attachments/EmailAttachments/1_Layer7ZipFile_00040377.zip');
    }
}