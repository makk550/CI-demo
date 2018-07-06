@isTest
public class ScheduledREProductsJobTest {
	
    @isTest
    static void test_ScheduledREProductsJob(){
        Test.setMock(HttpCalloutMock.class, new FetchREEnabledProdcutsMock());
        Test.startTest();
        System.schedule('TestClass_ScheduledREProductsJob', '0 0 10 * * ?', new ScheduledREProductsJob());
        Test.stopTest();
	}
}