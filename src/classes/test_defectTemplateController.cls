@isTest
public class test_defectTemplateController{

    private static testMethod void testDefectTemplate(){
        Test_SetupData.createTestData();
        Test.StartTest();
        createDefectData();
        apexpages.currentpage().getparameters().put('caseId', Test_SetupData.caseNumberId);
        defectTemplateController defectTemplateControllerObj = new defectTemplateController();
        Test.StopTest();
    }
    
    private static testMethod void testDefectTemplate1(){
        Test_SetupData.createTestData();
        Test.StartTest();
        apexpages.currentpage().getparameters().put('caseId', '');
        defectTemplateController defectTemplateControllerObj = new defectTemplateController();
        Test.StopTest();
    }
    
    private static void createDefectData(){
        Defect_Template__c defectTemplateObj = new Defect_Template__c();
        defectTemplateObj.Name = 'Case Details';
        defectTemplateObj.Description__c = 'caseDefectSubject,caseSubject,caseCaseNumber,caseDescription,caseSiteId,caseBusinessImpact,caseProductRelease,caseOperatingSystem,lastCaseComment,caseSftpAttachment,caseOwnerName,caseContactName';
        insert defectTemplateObj;
    }
}