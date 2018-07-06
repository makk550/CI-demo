@isTest
public class CC_AWSServiceTest {
    
    @IsTest
    static void test_getSitesForUser(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
        String connectId = 'abcde', siteId = '12345';
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();        
        svc.getSitesForUser(connectId,siteId);
        Test.stopTest();
    }
    
        @IsTest
    static void test_getSitesandProductsForUser(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
        String connectId = 'abcde', siteId = '12345';
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();        
        svc.getSitesAndProducts(connectId,siteId);
        Test.stopTest();
    }
    
        @IsTest
    static void test_getSolution(){
        //Layer7UtilCalloutMock mock = buildL7Mock();
        //CC_Layer7Service svc = buildL7Svc(mock);
        String product = 'testProduct', release = 'testrelease',solID = 'testSolID', solType = 'test';
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();        
        String awstoken=CC_Layer7Service.getAWSToken();
        CC_Layer7Service.getSolution(awstoken, product, release, solID, solType);
        Test.stopTest();
    }
    
    static Layer7UtilCalloutMock buildL7Mock() {
        return new Layer7UtilCalloutMock();
    }
    
    static CC_Layer7Service buildL7Svc(Layer7UtilCalloutMock mock) {
        CC_Layer7Service svc = new CC_Layer7Service();
        svc.layer7Callout = mock;
        return svc;
    }
    
}