@isTest
public class Test_generateProjectId {
    
    private static testMethod void testGenerateProjectIdSuccess(){
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       Test_SetupData.createTestData();
       Test.startTest();
       User userObj = [select id from User where name=:'Sevice CloudRestApi' and isActive=:true limit 1];
       system.runAs(userObj){
           Project_Site_Association__c projectSiteObj = new Project_Site_Association__c();
           projectSiteObj.Name = 'Test';
           projectSiteObj.Description__c = 'Testing';
           projectSiteObj.Site_Association__c = Test_SetupData.caSiteId;
           projectSiteObj.Connect_ID__c = 'shata07';
           projectSiteObj.Project_ID__c = '0';
           insert projectSiteObj;
       }
       Test.stopTest();
    }
    
}