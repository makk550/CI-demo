/*
	Description : Test Class for "JiraIntegration" Class
*/

@isTest
public class JiraIntegrationTest {
    public static testMethod void testJiraIntegration1(){
        Test.startTest();
        //Case sampleCase = JIRARESTAddCommentTest.insertData();
        Case sampleCase = insertData('Standard');
        Test.setMock(HttpCalloutMock.class, new JiraCalloutMock()); 
        String message = JiraIntegration.createJiraTicket(sampleCase.id, 'test', 'GET', 'AUTOMIC WORKLOAD AUTOMATION');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegration2(){
        Test.startTest();
        //Case sampleCase = JIRARESTAddCommentTest.insertData();
        Case sampleCase = insertData('Problem');
        Test.setMock(HttpCalloutMock.class, new JiraCalloutMock()); 
        String message = JiraIntegration.createJiraTicket(sampleCase.id, 'test', 'GET', 'AUTOMIC WORKLOAD AUTOMATION');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegration3(){
        Test.startTest();
        //Case sampleCase = JIRARESTAddCommentTest.insertData();
        Case sampleCase = insertData('Problem');
        Test.setMock(HttpCalloutMock.class, new JiraCalloutMock()); 
        JiraIntegration.addComment(sampleCase.Id, 'New Comment Added');
        Test.stopTest();
    }
    
    private static Case insertData(String caseType){
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
        sampleCase.ParentId = problemCase.Id;

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
    
		sampleCase.SE_Action__c=true;
        
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
        List<Case> caseList = new List<Case>();
        caseList.add(sampleCase);
        insert caseList;
        
        Task task = new Task();
        task.Type = 'SE Action';
        task.WhatId = task.id;
        task.Case__c = sampleCase.id;
        insert task;

        Automic_R_D_Component_Version__c automicRandDComponentVersion = new Automic_R_D_Component_Version__c();
        automicRandDComponentVersion.Problem__c = sampleCase.Id;
        automicRandDComponentVersion.Created_Internally__c = TRUE;
        insert automicRandDComponentVersion;
        
        return sampleCase;
    }
}