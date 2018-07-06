@isTest
public class Test_productAreaControllerExtension {
   
    private static testMethod void testProductAreaControllerSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        productAreaControllerExtension obj = new productAreaControllerExtension(new ApexPages.StandardController(Test_SetupData.productAreaObject[0])); 
        system.currentpagereference().getparameters().put('selectedRecords','["allId_select_'+Test_SetupData.compId[0].Id+'"]');
        system.currentpagereference().getparameters().put('defaultRecords',Test_SetupData.compId[0].id);
        obj.submitRecords();
        obj.cancelRecords();
        Test.stopTest();
    }
    
    /*private static testMethod void testProductAreaControllerSuccess1(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        productAreaControllerExtension obj = new productAreaControllerExtension(new ApexPages.StandardController(Test_SetupData.productAreaObject[0])); 
        system.currentpagereference().getparameters().put('selectedRecords','["allId_select_'+Test_SetupData.compId[1].Id+'"]');
        system.currentpagereference().getparameters().put('defaultRecords',Test_SetupData.compId[1].id);
        obj.submitRecords();
        obj.cancelRecords();
        Test.stopTest();
    }
    
    private static testMethod void testProductAreaControllerSuccess2(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        productAreaControllerExtension obj = new productAreaControllerExtension(new ApexPages.StandardController(Test_SetupData.productAreaObject[1])); 
        system.currentpagereference().getparameters().put('selectedRecords','["allId_select_'+Test_SetupData.compId[1].Id+'"]');
        system.currentpagereference().getparameters().put('defaultRecords',Test_SetupData.compId[1].id);
        obj.submitRecords();
        obj.cancelRecords();
        Test.stopTest();
    }
    
    private static testMethod void testUpdateProductAreaControllerSuccess(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        Test.startTest();
        
        updateCompControllerExtension obj = new updateCompControllerExtension(new ApexPages.StandardController(Test_SetupData.productAreaObject[0])); 
        system.currentpagereference().getparameters().put('selectedRecords','["allId_select_'+Test_SetupData.compId[0].Id+'"]');
        system.currentpagereference().getparameters().put('defaultRecords',Test_SetupData.compId[0].Id);
        obj.submitRecords();
        obj.cancelRecords();
        Test.stopTest();
    }*/
}