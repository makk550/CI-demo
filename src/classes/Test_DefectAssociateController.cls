/*
Created By: Tarun Sharma
Created On: 10/13/2015
Purpose: Test Class for user story ---> B-04030: Associate an existing Defect to Case
Modified By:
*/
@isTest
public class Test_DefectAssociateController{
    
           
    private static testMethod void testDefectAssociateController_Fail(){
         TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestProductData();
        test.startTest();
        checkDefectCalloutMethod();
        test.stopTest();
    }
        
    private static testMethod void testDefectAssociateControllerElseCond(){
         TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestData();
        test.startTest();
        checkDefectCalloutMethod();
       
        test.stopTest();
    }
   
    private static testMethod void testNullResponse(){
         TestSLOMilestonesDataSetup.createTestDataforMilestones();
        Test_SetupData.createTestProductData();//createTestNoDefectAssociateData();     
        test.startTest();
        checkNullResponseMethod();
        test.stopTest();
    }
    
    private static void checkNoUpdateResponseMethod(){
    
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMockUdpateResponse());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
        defectAssociateControllerObj.cancelAssociation();
        defectAssociateControllerObj.continueSubmitAssocaite();
    }
        
    private static void checkUpdateResponseFailureMethod(){
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMockUpdateFailure());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
    }
        
    private static void checkNullResponseMethod(){
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMockNullResponse());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
    }
        
    private static void checkDefectCalloutMethod(){
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMock());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
        defectAssociateControllerObj.cancelAssociation();
        defectAssociateControllerObj.fixedorClosed=false;
       defectAssociateControllerObj.continueSubmitAssocaite();
       defectAssociateControllerObj.prepareUpdateEndPoint();
       defectAssociateControllerObj.checkDefectCallout();
    }
        
    private static void checkNoDefectAssociateMethod(){
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMock());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
    }
        
    private static void checkDefectNullMethod(){
       Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMock());
       DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
       defectAssociateControllerObj.defectName = null;
       defectAssociateControllerObj.submitDefectAssociate();
       defectAssociateControllerObj.cancelAssociation();
       defectAssociateControllerObj.continueSubmitAssocaite();
    } 
   
   private static void checkDefectErrorMethod(){
        Test.setMock(HttpCalloutMock.class, new  DefectAssociation_UIMockFaliure());
        DefectAssociateController defectAssociateControllerObj = new DefectAssociateController();  
        defectAssociateControllerObj.defectName = 'DE1111';
        defectAssociateControllerObj.submitDefectAssociate();
        
    }
    
     
}