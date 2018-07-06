@isTest
public class FetchREEnabledProductsTest {
    
    @isTest
    static void test_fetchOauthToken(){
        Test.setMock(HttpCalloutMock.class, new FetchREEnabledProdcutsMock());
         Test.startTest();  
        FetchREEnabledProducts obj = new FetchREEnabledProducts();
        obj.fetchOauthToken();
        obj.fetchREEnabledProductsFromService();
        obj.sendEmailonError('test');
        Test.stopTest();
    }

}