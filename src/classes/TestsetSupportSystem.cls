@isTest
 public class TestsetSupportSystem {
 static testMethod void setSupportSystemTrigger_Test()
 {
 Component_Release__c testcmprls = new Component_Release__c();
 testcmprls.Component_Code__c='ABC';
 testcmprls.SFDC_Support_System__c=false;
 testcmprls.Component_Release__c='Testcmp';
 testcmprls.Name='Testcomponentname';
 insert testcmprls;
     
 CA_Product_Controller__c testCAProCtl =new CA_Product_Controller__c();
 testCAProCtl.Name='TestCACtlName';
 testCAProCtl.SFDC_Support_System__c=True;
 insert testCAProCtl;
 
 Product_Material__c testpm=new Product_Material__c();
 testpm.Name='Testmaterial';
 testpm.CA_Product_Controller__c= testCAProCtl.Id; 
 insert testpm;
 
 Product_Release__c testproductrelease=new Product_Release__c();
 testproductrelease.Product_Material__c=testpm.id;
 testproductrelease.Name='Testproductrelease';
 insert testproductrelease;
 
 
     
 
 Product_Release_Component_Release__c testprcr=new Product_Release_Component_Release__c();
 testprcr.Name='testproductcomponent';
 testprcr.Product_Release__c=testproductrelease.id;
 testprcr.Component_Release__c=testcmprls.id;
 insert testprcr;

 
}
}