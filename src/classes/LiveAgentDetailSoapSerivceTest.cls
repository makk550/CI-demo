@isTest
private class LiveAgentDetailSoapSerivceTest {
	 public static testMethod void  testService(){
         
         Product_Button__c pb= new Product_Button__c();
         pb.Button_Id__c = '573e000000000L';
         pb.Name = 'ACF2';
         insert pb;
         
         CA_Product_Controller__c cpc = new CA_Product_Controller__c();
         cpc.Product_Button__c = pb.Id;
         cpc.Name = 'ACF2';
         insert cpc;
         
         Product_Material__c pm = new Product_Material__c();
         pm.Name = 'ACF2';
         pm.CA_Product_Controller__c = cpc.id;
         insert pm;
         
         Test.startTest();
                 LiveAgentDetailSoapService.getButtonId('ACF2');
         LiveAgentDetailSoapService.getButtonId(null);
         Test.stopTest();
        
     }
}