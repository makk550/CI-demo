/*
	Description : Test Class for "JiraProjectKeysScheduler" Class
*/

@isTest
public class JiraProjectKeysSchedulerTest {

    public static testMethod void testJiraProjectKeysScheduler(){
        Test.startTest();
        JIRA_Configuration__c jiraConfiguration = new JIRA_Configuration__c();
        jiraConfiguration.JIRA_Keys_Endpoint__c='Test Url';
        jiraConfiguration.Name='Default';
        insert jiraConfiguration;

		JiraProjectKeysScheduler jiraProjectKeysScheduler = new JiraProjectKeysScheduler();
        jiraProjectKeysScheduler.execute();
        Test.stopTest();
    }
}