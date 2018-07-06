@isTest
public class PDDCustomerVersionCon_Test{

    public static Id accId ;
    public static testMethod void testData(){
    
          SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='Generic Support Account 1234we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
         
        ApexPages.currentPage().getParameters().put('id',a.id);
        
        Customer_Version_Map__c  cvm = new Customer_Version_Map__c();
            cvm.Enterprise_account__c = a.id;
            //cvm.product_new__c = pm.id;
            insert cvm;
            
       ApexPages.StandardController sc = new ApexPages.StandardController(cvm);
       PDDCustomerVersionCon con =new PDDCustomerVersionCon(sc);
       con.refreshPageSize();
       con.getlstVersions();
        
        
    }

}