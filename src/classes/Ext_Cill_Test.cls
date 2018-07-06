@isTest
public class Ext_Cill_Test {

    static testMethod void method1() 
    {
         SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        // id res = accRecType.get('CA Enterprise Account').getRecordTypeId();
        account a = new account(name ='Test Account', recordtypeid =res);
        a.Region_Country__c='PS_FSI';
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'APJ';
        a.GEO__c='APJ';
        a.Sales_Area__c= 'JAPAN01';
        a.Sales_Region__c= 'JAPAN01';
        a.Segment__c='xxx'; 
        a.GU_DUNS_NUMBER__c='808998355';
        
        insert a;
        
        account a2 = new account(name ='Test Account', recordtypeid =res);
        a2.Region_Country__c='PS_FSI';
        
        a2.customer_Category__c= 'Reseller';
        a2.hq__c= true;
        a2.Commercial_Account_Name__c='test 11111114'  ;
        a2.Commercial_ID__c= 'test 11111115';
        a2.Country_Picklist__c= 'APJ';
        a2.GEO__c='APJ';
        a2.Sales_Area__c= 'JAPAN';
        a2.Sales_Region__c= 'JAPAN';
        a2.Segment__c='xxx';
        
        insert a2;

        List<Active_Contract__c> insertac=new list<Active_Contract__c>();
        
        Active_Contract__c ac1=new Active_Contract__c(Name='ACL_Test01');
        insertac.add(ac1);
        Active_Contract__c ac2=new Active_Contract__c(Name='ACL_Test02');
        insertac.add(ac2);
        
        insert insertac;
        
        list<Active_Contract_Product__c> insertacp=new list<Active_Contract_Product__c>();
        Active_Contract_Product__c acp1=new Active_Contract_Product__c(name='acp_test01',Active_Contract__c=ac1.id);
        insertacp.add(acp1);
        Active_Contract_Product__c acp2=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac2.id);
        insertacp.add(acp2);
        
        insert insertacp;     
        
         
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
       
       Ext_Cill pp=new Ext_Cill(sc);
        String ids = ApexPages.currentPage().getParameters().get('id');
        pp.populatelstACPGroupedByProduct();
        
    }
}