@isTest
public class Test_CADiagnosticTrigger{
    
  private static testMethod void testTriggerSuccess(){
      Test.startTest();
      TestSLOMilestonesDataSetup.createTestDataforMilestones();
      Test_SetupData.createTestData();
      CA_Diagnostics__c caobj = new CA_Diagnostics__c();
      caobj.Case__c = Test_SetupData.caseNumberId;
      caobj.File_location__c='https://test';
      caobj.File_Size__c = '1MB';
      caobj.Source__c = 'Remote Engineer';
      caobj.Status__c = 'Completed';
      caobj.Upload_Date__c = System.now();
      insert caobj;
      Test.stopTest();
    }
}