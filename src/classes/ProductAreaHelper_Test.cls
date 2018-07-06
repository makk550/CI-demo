@isTest
public class ProductAreaHelper_Test {

    @isTest
    static void test_PA_insert(){
        SystemIdUtility.skipProductTriggers = true;
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();
        
        CA_Product_Controller__c  testProdCtrl = CC_TestUtils.createProduct('TestP1');        
		Product_Area__c pa1 = new Product_Area__c(name='testPA1', CA_Product__c=testProdCtrl.Id );
        insert pa1;
        System.assertNotEquals(null, pa1.Id);
        Test.stopTest();        
    }

    @isTest
    static void test_PA_update(){
        SystemIdUtility.skipProductTriggers = true;
        Test.startTest();
        CA_Product_Controller__c  testProdCtrl = CC_TestUtils.createProduct('TestP1');        
		Product_Area__c pa1 = new Product_Area__c(name='testPA1', CA_Product__c=testProdCtrl.Id );
        insert pa1;
        pa1.Name = 'testPA1-Updated';
        update pa1;
        System.assertEquals('testPA1-Updated', pa1.name);
        Test.stopTest();        
    }    
    
    @isTest
    static void test_PA_delete(){
        SystemIdUtility.skipProductTriggers = true;
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();
        CA_Product_Controller__c  testProdCtrl = CC_TestUtils.createProduct('TestP1');        
        Product_Area__c pa1 = new Product_Area__c(name='testPA1', CA_Product__c=testProdCtrl.Id );
        insert pa1;        
        delete pa1;        
        Test.stopTest();        
    } 
    
}