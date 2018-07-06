/*
	Description : Test Class for "JIRARESTAddComment" Class
*/

@isTest
public class JIRARESTAddCommentTest {
    
    public static testMethod void testJIRARESTAddComment1(){
        Test.startTest();
        Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, '', 'SOLUTION_FOUND', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }

    public static testMethod void testJIRARESTAddComment2(){
        Test.startTest();
        Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, '', 'SOLUTION_FOUND', 'Sudhakar Pottabathula', 'param1', 'INCIDENT', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment3(){
        Test.startTest();
        Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, '', 'SOLUTION_FOUND', 'Sudhakar Pottabathula', 'param1', 'BUG', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment4(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'param3 dot. value', '2017-10-05 11');
        Test.stopTest();
    }
    public static testMethod void testJIRARESTAddComment5(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'param3 dot. value', '');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment6(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'remove', 'param2', 'param3 dot. value', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment7(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'TF test.1234', '2017-10-06 11');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment8(){
        Test.startTest();
		Case sampleCase = insertData('Problem', false);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'TF test.1234', '2017-10-06 11');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment9(){
        Test.startTest();
		Case sampleCase = insertData('Problem', false);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'remove', 'param2', 'TF test.1234', '2017-10-06 11');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment10(){
        Test.startTest();
		Case sampleCase = insertData('Problem', false);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'remove', 'param2', 'test', '2017-10-06 11');
        Test.stopTest();
    }

    public static testMethod void testJIRARESTAddComment11(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'TF test.1234', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment12(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', '?', 'TF test.1234', '2017-10-05 11');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment13(){
        Test.startTest();
		Case sampleCase = insertData('Problem', false);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'add', 'param2', 'param3 dot. value', '2017-10-05 11');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment14(){
        Test.startTest();
		Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', '', 'param2', '2018-2-2', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment15(){
        Test.startTest();
		Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'FIX_VERSION', 'Sudhakar Pottabathula', 'param1', 'param2', '', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment16(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'STATUS_CHANGED', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment17(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'STATUS_CHANGED', 'Sudhakar Pottabathula', NULL, 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment18(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'BUG_CONFIRMED', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment19(){
        Test.startTest();
		Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'BUG_CONFIRMED', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment20(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'DUPLICATE_INTERNAL', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment21(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'INFO_NEEDED', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment22(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'BASIC', 'Sudhakar Pottabathula', 'key1233', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment23(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'NOT_BUG', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment24(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'VERSION_RELEASED', 'Sudhakar Pottabathula', 'param1', 'param2', '2018-2-2', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment25(){
        Test.startTest();
		Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'VERSION_RELEASED', 'Sudhakar Pottabathula', 'param1', 'param2', '2018-2-2', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment26(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'BUG_FIXED', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment27(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'WORKAROUND', 'Sudhakar Pottabathula', 'param1', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment28(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'AFFECTED_COMPONENTS', 'Sudhakar Pottabathula', 'add', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment29(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'AFFECTED_COMPONENTS', 'Sudhakar Pottabathula', 'remove', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment30(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'AFFECTED_COMPONENTS', 'Sudhakar Pottabathula', '', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment31(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'AFFECTED_COMPONENTS', 'Sudhakar Pottabathula', 'remove', 'param2', '', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment32(){
        Test.startTest();
		Case sampleCase = insertData('Standard', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'AFFECTED_COMPONENTS', 'Sudhakar Pottabathula', 'remove', 'param2', '', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment33(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'KEY_CHANGED', 'Sudhakar Pottabathula', 'key1233-', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    public static testMethod void testJIRARESTAddComment34(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, 'Jira Modified', 'KEY_CHANGED', 'Sudhakar Pottabathula', NULL, 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
    public static testMethod void testJIRARESTAddComment35(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, NULL, 'BASIC', 'Sudhakar Pottabathula', 'key1233', 'param2', 'param3', 'param4');
        Test.stopTest();
    }

    public static testMethod void testJIRARESTAddComment36(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(sampleCase.id, NULL, NULL, 'Sudhakar Pottabathula', 'key1233', 'param2', 'param3', 'param4');
        Test.stopTest();
    }
    
     public static testMethod void testJIRARESTAddComment37(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost(NULL, NULL, 'BASIC', 'Sudhakar Pottabathula', 'key1233', 'param2', 'param3', 'param4');
        Test.stopTest();
    }

    public static testMethod void testJIRARESTAddComment38(){
        Test.startTest();
		Case sampleCase = insertData('Problem', true);
        JIRARESTAddComment.doPost('5000c00001U0qZ6AAJ', NULL, 'BASIC', 'Sudhakar Pottabathula', 'key1233', 'param2', 'param3', 'param4');
        Test.stopTest();
    }

    public static Case insertData(String caseType, Boolean isBugFixed){
		JIRA_Configuration__c jiraConfig = new JIRA_Configuration__c();
        jiraConfig.Case_Field_Id__c = 'customfield_11409';
        jiraConfig.Case_Number_Field_Id__c = '	customfield_11411';
        jiraConfig.CreatedById = '0050c00000D2Pw2AAF';
        jiraConfig.CurrencyIsoCode = 'USD';
        jiraConfig.Endpoint__c = 'http://91.231.22.36/jira/rest/api/latest/issue';
        jiraConfig.Name = 'Default';
        jiraConfig.No_of_Inc_Field_Id__c = 'customfield_11901';
        jiraConfig.Password__c = 'sfdc$$';
        jiraConfig.Project_Code_Idea__c = 'PMPER';
        jiraConfig.Service_Class_Field_Id_del__c = 'customfield_11902';
        jiraConfig.SFDC_Status__c = 'customfield_12600';
        jiraConfig.Support_Offering_Code__c = 'customfield_11902';
        jiraConfig.Username__c = 'sfdc';
        jiraConfig.Issue_Created_Date_and_Time__c = 'customfield_12401';
        List<JIRA_Configuration__c> jiraConfigList = new List<JIRA_Configuration__c>();
        jiraConfigList.add(jiraConfig);
        insert jiraConfigList;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig1 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig1.Apex_Code_Block__c = 'SOLUTION'; 
        sfdcJiraCommentTypeConfig1.Name = 'SOLUTION_FOUND';
        insert sfdcJiraCommentTypeConfig1;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig2 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig2.Apex_Code_Block__c = 'VERSION';
        sfdcJiraCommentTypeConfig2.Name = 'FIX_VERSION';
        insert sfdcJiraCommentTypeConfig2;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig3 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig3.Apex_Code_Block__c = 'STATUS';
        sfdcJiraCommentTypeConfig3.Name = 'STATUS_CHANGED';
        insert sfdcJiraCommentTypeConfig3;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig4 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig4.Apex_Code_Block__c = 'BUGCONFIRM';
        sfdcJiraCommentTypeConfig4.Name = 'BUG_CONFIRMED';
        insert sfdcJiraCommentTypeConfig4;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig5 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig5.Apex_Code_Block__c = 'DUPLICATEBUG';
        sfdcJiraCommentTypeConfig5.Name = 'DUPLICATE_INTERNAL';
        insert sfdcJiraCommentTypeConfig5;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig6 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig6.Apex_Code_Block__c = 'INFO';
        sfdcJiraCommentTypeConfig6.Name = 'INFO_NEEDED';
        insert sfdcJiraCommentTypeConfig6;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig7 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig7.Apex_Code_Block__c = 'BASIC';
        sfdcJiraCommentTypeConfig7.Name = 'BASIC';
        insert sfdcJiraCommentTypeConfig7;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig8 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig8.Apex_Code_Block__c = 'NOTBUG';
        sfdcJiraCommentTypeConfig8.Name = 'NOT_BUG';
        insert sfdcJiraCommentTypeConfig8;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig9 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig9.Apex_Code_Block__c = 'RELEASED';
        sfdcJiraCommentTypeConfig9.Name = 'VERSION_RELEASED';
        insert sfdcJiraCommentTypeConfig9;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig10 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig10.Apex_Code_Block__c = 'BUGFIXED';
        sfdcJiraCommentTypeConfig10.Name = 'BUG_FIXED';
        insert sfdcJiraCommentTypeConfig10;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig11 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig11.Apex_Code_Block__c = 'WORKAROUND';
        sfdcJiraCommentTypeConfig11.Name = 'WORKAROUND';
        insert sfdcJiraCommentTypeConfig11;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig12 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig12.Apex_Code_Block__c = 'COMPONENTS';
        sfdcJiraCommentTypeConfig12.Name = 'AFFECTED_COMPONENTS';
        insert sfdcJiraCommentTypeConfig12;
        
        SFDC_JIRA_CommentType_Config__c sfdcJiraCommentTypeConfig13 = new SFDC_JIRA_CommentType_Config__c();
        sfdcJiraCommentTypeConfig13.Apex_Code_Block__c = 'KEY';
        sfdcJiraCommentTypeConfig13.Name = 'KEY_CHANGED';
        insert sfdcJiraCommentTypeConfig13;
            
        Case problemCase = new Case();
        problemCase.Description='new problem case created';
        problemCase.Case_Type__c='Problem';
        problemCase.status='Open';
        problemCase.Subject='Test';
        problemCase.Jira_Issue_API_link__c = 'http://91.231.22.36/jira/rest/api/latest/issue/252053';
        problemCase.JIRA_Status__c='Open';
        problemCase.JIRA_Issue_Key__c='key_1234';
        Case sampleCase = new Case();
        sampleCase.Description='new sample case created';
        sampleCase.Case_Type__c=caseType;
        sampleCase.status='Open';
        sampleCase.Subject='Test';
        sampleCase.BusinessHoursId='01ma00000000PaHAAU';
        sampleCase.Jira_Issue_API_link__c = 'http://91.231.22.36/jira/rest/api/latest/issue/252053';
        //sampleCase.ParentId = problemCase.Id;
		sampleCase.SE_Action__c=true;
        sampleCase.Bug_fixed__c = true;

        CA_Product_Controller__c caProductController = new CA_Product_Controller__c();
        caProductController.Name = 'AUTOMIC RELEASE AUTOMATION';
        caProductController.Case_Concern_Allowed__c = true;
        caProductController.CurrencyIsoCode = 'USD';
        insert caProductController;

        Component_Release__c componentRelease = new Component_Release__c();
        componentRelease.Component_Release__c = '1.0';
        componentRelease.Name = 'AUTAM 1.0 AUTOMIC APPLICATION MANAGER';
        componentRelease.Component_Code__c = 'AUTAM';
        insert componentRelease;

        CA_Product_Component__c caProductComponent = new CA_Product_Component__c();
        caProductComponent.Name = 'AUTOMIC APPLICATIONS MANAGER';
        caProductComponent.Component_Text__c = 'AUTOMIC APPLICATIONS MANAGER';
        caProductComponent.Component_Code__c = 'AUTAM';
        caProductComponent.CA_Product_Controller__c = caProductController.Id;
        insert caProductComponent;

        sampleCase.CA_Product_Controller__c = caProductController.id;
        sampleCase.CA_Product_Component__c = caProductComponent.id;
        sampleCase.Offering_Code_Ref__c='Standard';
        sampleCase.Priority='L';
        sampleCase.Severity__c='3';
        sampleCase.Affected_Component_s__c = 'AUTOMIC APPLICATIONS MANAGER';
        sampleCase.Bug_fixed__c = isBugFixed;
        Contact contact = new Contact();
        contact.LastName = 'last name';
        insert contact;

		SancPartyUserList__c sanctionParty = new SancPartyUserList__c();
        sanctionParty.Name = 'Name';
        insert sanctionParty;
        sampleCase.ContactId = contact.id;

        Site_Association__c siteAssociation = new Site_Association__c();
        siteAssociation.SC_TOPS_ID__c = '00839';
        siteAssociation.ProviSite__c = 6514612.0;
        siteAssociation.SC_SITE_Sanctioned_Party__c = 'No';
        insert siteAssociation;

        sampleCase.Site_Association__c = siteAssociation.id;
        SancPartyUserList__c sanparty = new SancPartyUserList__c();
        sanparty.Name='Name';
        insert sanparty;

        JIRA_Project_Key__c jiraProjectKey = new JIRA_Project_Key__c();
        jiraProjectKey.Name = 'AUTOMIC.APPLICATIONS.MANAGER';
        jiraProjectKey.JIRA_Project_ID__c = '1234';
        jiraProjectKey.JIRA_Project_Key__c = 'key1233';
        insert jiraProjectKey;

		Problem_Case_Products__c problemCaseProducts = new Problem_Case_Products__c();
        problemCaseProducts.CA_Product_Controller_Name__c = 'AUTOMIC RELEASE AUTOMATION';
        problemCaseProducts.Name = 'AUTOMIC RELEASE AUTOMATION';
        insert problemCaseProducts;

        TestSLOMilestonesDataSetup.createCertificationExternalData();
        TestSLOMilestonesDataSetup.createContractOfferingsExternalData();
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        insert sampleCase;
        
        Automic_Version__c automicVersion = new Automic_Version__c();
        automicVersion.Problem_Case__c = sampleCase.id;
        automicVersion.Fixed_In__c='param2';
        automicVersion.Fix_Type__c='param2';
        automicVersion.Name='TF test.1';
        insert automicVersion;

        Automic_R_D_Component_Version__c automicRandDComponentVersion = new Automic_R_D_Component_Version__c();
        automicRandDComponentVersion.Problem__c = sampleCase.Id;
        automicRandDComponentVersion.Created_Internally__c = TRUE;
        automicRandDComponentVersion.Fixed_In__c='param2';
        automicRandDComponentVersion.Name='TF test.1';
        automicRandDComponentVersion.Fixed_Type__c = '?';
        automicRandDComponentVersion.jira_Version__c = 'TF test.1234';
        insert automicRandDComponentVersion;

        return sampleCase;
    }
}