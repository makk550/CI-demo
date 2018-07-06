/*
	Description : Test Class for "JiraIntegrationHelper" Class
*/

@isTest
public class JiraIntegrationHelperTest {
    public static testMethod void testJiraIntegrationHelper(){
        Test.startTest();
        JiraIntegrationHelper.addComment('5000c00001U0XTJAA3', 'Comment Added');
        JiraIntegrationHelper.createLog('5000c00001U0XTJAA3', 'Success', 'status_desc', 'JIRA -> SFDC', 'commentType', 'externalSysId', 'externalSysStatus', 'internalTicketStatus', 'Communication_desc');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper2(){
        
        Test.startTest();
        Map<String, String> fieldMap = new Map<String, String>();
        Map<String, String> labelMap = new Map<String, String>();
        
        JIRA_Configuration__c jiraConfiguration = new JIRA_Configuration__c();
        jiraConfiguration.Name='Default';
        jiraConfiguration.Username__c='sfdc';
        jiraConfiguration.Password__c='sfdc$$';
        jiraConfiguration.No_of_Inc_Field_Id__c ='10';
        insert jiraConfiguration;

        fieldMap.put('id', '5000c00001U0XTJAA3');
		fieldMap.put('priority', '5000c@@00001U@@0XTJAA3');
        fieldMap.put('NumberofIncident', '5000c@@00001U@@0XTJAA3');
        labelMap.put('id', '5000c00001U0XTJAA3');
        labelMap.put('addVersion', 'Name@@is@@name');
        labelMap.put('removeVersion', 'Name@@is@@name');
        
        JiraIntegrationHelper.updateJiraTicket(getCaseList('Standard').id, fieldMap, labelMap, true);
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper3(){
        Test.startTest();
        JiraIntegrationHelper.updateJiraTicketState(getCaseList('Standard').id, 'optionalComment');
        Test.stopTest();
    }

    public static testMethod void testJiraIntegrationHelper4(){
        Test.startTest();
		JIRA_Configuration__c jiraConfiguration = new JIRA_Configuration__c();
        jiraConfiguration.Name='Default';
        jiraConfiguration.Username__c='sfdc';
        jiraConfiguration.Password__c='sfdc$$';
        jiraConfiguration.No_of_Inc_Field_Id__c ='10';
        insert jiraConfiguration;
        JiraIntegrationHelper.addCommentToJira(getCaseList('Standard').ParentId, 'comment');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper5(){
        Test.startTest();
        JIRA_Configuration__c jiraConiguration = new JIRA_Configuration__c();
        jiraConiguration.Name='Default';
        jiraConiguration.Username__c='username';
        jiraConiguration.Password__c='password';
        jiraConiguration.Endpoint__c ='end point';
        insert jiraConiguration;
        JiraIntegrationHelper.callJIRAService('jsonStr');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper6(){
        Test.startTest();
        JIRA_Configuration__c jiraConiguration = new JIRA_Configuration__c();
        jiraConiguration.Name='Default';
        jiraConiguration.SFDC_Status__c='status';
        jiraConiguration.Support_Offering_Code__c='11';
        jiraConiguration.No_of_Inc_Field_Id__c ='No_of_Inc_Field_Id__c';
        jiraConiguration.Username__c = 'username';
        jiraConiguration.Password__c='password';
        insert jiraConiguration;
        JiraIntegrationHelper.updateStatus('jiraKey', 'status', 'offeringCode', 'noOfInc');
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper7(){
        Test.startTest();
        JiraIntegrationHelper.updateNextActionOwnerAndTime(getCaseList('Standard'));
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper8(){
        Test.startTest();
        JiraIntegrationHelper.caseProblemIntercommunication(getCaseList('Standard'));
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper9(){
        Test.startTest();
        JiraIntegrationHelper.createTask(getCaseList('Standard'));
        Test.stopTest();
    }
    
    public static testMethod void testJiraIntegrationHelper10(){
        Test.startTest();
        List<Case> caselist = new List<Case>();
        caseList.add(getCaseList('Standard'));
        JiraIntegrationHelper.createSEActionTask(caseList);
        Test.stopTest();
    }
    
    private static Case getCaseList(String caseType){
        Case sampleCase = new Case();
        
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
        
        Component_Release__c componentRelease2 = new Component_Release__c();
        componentRelease2.Component_Release__c = '2.1';
        componentRelease2.Component_Text__c = 'AUTOMIC WEB INTERFACE';
        componentRelease2.Name = 'AAUTWI 2.1 AUTOMIC WEB INTERFACE';
        componentRelease2.Component_Code__c = 'AAUTWI';
        insert componentRelease2;
        
        CA_Product_Component__c caProductComponent = new CA_Product_Component__c();
        caProductComponent.Name = 'AUTOMIC APPLICATIONS MANAGER';
        caProductComponent.Component_Text__c = 'AUTOMIC APPLICATIONS MANAGER';
        caProductComponent.Component_Code__c = 'AUTAM';
        caProductComponent.CA_Product_Controller__c = caProductController.Id;
        insert caProductComponent;

        sampleCase.Description='new sample case created';
        sampleCase.Case_Type__c=caseType;
        sampleCase.status='Open';
        sampleCase.Subject='Test';
        sampleCase.BusinessHoursId='01ma00000000PaHAAU';
        sampleCase.CA_Product_Controller__c = caProductController.id;
        sampleCase.CA_Product_Component__c = caProductComponent.id;
        sampleCase.Offering_Code_Ref__c='Standard';
        sampleCase.Priority='L';
        sampleCase.Severity__c='3';
        sampleCase.Component_Release_Only_Selection__c = componentRelease.Id;
        sampleCase.Jira_Issue_API_link__c = 'http://91.231.22.36/jira/rest/api/latest/issue/252333';
        sampleCase.Jira_Issue_Id__c = '252333';
        sampleCase.JIRA_Issue_Key__c = 'abcd123';
		sampleCase.jira_status__c = 'Info Needed';
        sampleCase.Status = 'Open';
        
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

        Case parentCase = new Case();
        parentCase.Description='new sample case created';
        parentCase.Case_Type__c='Problem';
        parentCase.status='Open';
        parentCase.Subject='Test';
        parentCase.CA_Product_Controller__c = caProductController.id;
        parentCase.CA_Product_Component__c = caProductComponent.id;
		parentCase.Site_Association__c = siteAssociation.id;
        parentCase.ContactId = contact.id;
		parentCase.Site_Association__c = siteAssociation.id;
		insert parentCase;
		List<Case> caseList = new List<Case>();
        sampleCase.ParentId= parentCase.id;

		insert sampleCase;
        return sampleCase;
    }
}