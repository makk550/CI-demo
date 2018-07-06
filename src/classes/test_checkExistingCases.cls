@isTest
Public class test_checkExistingCases{
    
    private static testMethod void testCheckExistingCase(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases(Test_SetupData.caSiteId ,Test_SetupData.caProduct, '2');
        Test.stopTest();
    }
    
    private static testMethod void testCheckExistingCase_success(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases(Test_SetupData.caSiteId ,Test_SetupData.caProduct, Test_SetupData.productAreaObject[0].Id);
        checkExistingCases.defaultComponent(Test_SetupData.productAreaObject[2].Id);
        Test.stopTest();
    }
    
    private static testMethod void testCheckExistingCase1(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases(Test_SetupData.caSiteId ,'1',Test_SetupData.productAreaObject[0].Id);
        checkExistingCases.defaultComponent(Test_SetupData.productAreaObject[0].Id);
        Test.stopTest();
    }
    
    private static testMethod void testCheckExistingCase2(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases('1' ,'2',Test_SetupData.productAreaObject[0].Id);
        Test.stopTest();
    }
    
    private static testMethod void testCheckExistingCase3(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases('1' ,'2','4');
        Test.stopTest();
    }
    
    private static testMethod void testCheckExistingCase4(){
        Test_SetupData.createTestData();
        Test.startTest();
        checkExistingCases.checkOldExistingCases('','','');
        Test.stopTest();
    }
}