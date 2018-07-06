@isTest
public class Test_SelecticaContractController{

    private static testMethod void testSelecticaContractController(){
        createTestData();
        test.startTest();
        contractArchivalDetails_MockResult();
        test.stopTest();
    }
    
    private static testMethod void testSelecticaContractController1(){
        test.startTest();
        contractArchivalDetails_MockResult1();
        test.stopTest();
    }
    
    private static testMethod void testSelecticaContractController2(){
        createTestData();
        test.startTest();
        contractArchivalDetails_MockResult2();
        test.stopTest();
    }
    
    private static void createTestData(){
        List<AWS_Credentials__c> listOfAWS = new List<AWS_Credentials__c>();
        AWS_Credentials__c awsCredentials = new AWS_Credentials__c();
        awsCredentials.Name = 'Case Archival';
        awsCredentials.Secret__c = 'nZOOCL0j+NDww7rfrjA0WDzkx+g9a5OTA+YHaZ/w';
        awsCredentials.Key__c = 'AKIAIXRMUKP2XKCSHNBA';
        listOfAWS.add(awsCredentials);
        
        AWS_Credentials__c awsCredentials1 = new AWS_Credentials__c();
        awsCredentials1.Name='Selectica Archive';
        awsCredentials1.Key__c = 'AKIAI5D6A35CENGVAW4Q';
        awsCredentials1.Secret__c = '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';
        listOfAWS.add(awsCredentials1);
        insert listOfAWS;        
    }
    
    private static void contractArchivalDetails_MockResult(){
        Test.setMock(HttpCalloutMock.class, new  searchArchival_MockResponse());
        apexpages.currentpage().getparameters().put('ContractLink', 'DOCS/8797099_contractdetails');
        SelecticaContractController controller = new SelecticaContractController();
    }
    
    private static void contractArchivalDetails_MockResult1(){
        Test.setMock(HttpCalloutMock.class, new  searchArchival_MockResponse());
        apexpages.currentpage().getparameters().put('ContractLink', '');
        SelecticaContractController controller = new SelecticaContractController();
    }
    
    private static void contractArchivalDetails_MockResult2(){
        
        SelecticaContractController controller = new SelecticaContractController();
        system.currentpagereference().getparameters().put('urlVal','01/02/1_xyx.zip');
        controller.callAWSFunc();  
    }
}