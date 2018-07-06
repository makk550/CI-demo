@isTest
public class productComponentCon_Test {

      private static testMethod void testMethod1(){
          
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='Test';
        insert prodCtl;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='Test';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=prodCtl.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        ApexPages.currentPage().getParameters().put('id',prodcomp.Id) ;
        Apexpages.StandardController stdController = new Apexpages.StandardController(prodcomp);
        productComponentCon con = new productComponentCon(stdController);
        con.saveComp();
        prodcomp.Default_Component_for_CA_Product__c=false;
        update prodcomp;
        con.saveComp();
        
        
      }
}