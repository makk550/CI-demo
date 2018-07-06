@isTest
public class Duplicateleadsearchcontroller_Test {

     private static testmethod void testDuplicateleadsearch()
     {
         String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
          String strRecordTypeIdAc = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='Account' and developername ='Generic_Record_Type'].Id;
           Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        List<RecordTypes_Setting__c > listrecd=new List<RecordTypes_Setting__c >();
        RecordTypes_Setting__c rectype=new RecordTypes_Setting__c();
        rectype.Name='Commercial Account';
        rectype.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
        rectype.SObject_Name__c='Account';
        listrecd.add(rectype);
          RecordTypes_Setting__c rectype1=new RecordTypes_Setting__c();
        rectype1.Name='CA Enterprise Account';
        rectype1.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Enterprise Account').getRecordTypeId();
        rectype1.SObject_Name__c='Account';
        
           listrecd.add(rectype1);
         RecordTypes_Setting__c rectype2=new RecordTypes_Setting__c();
        rectype2.Name='Account Team Covered Account';
        rectype2.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        rectype2.SObject_Name__c='Account';
        
         listrecd.add(rectype2);
        
         RecordTypes_Setting__c rectype3=new RecordTypes_Setting__c();
        rectype3.Name='Reseller/Distributor Account';
        rectype3.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
        rectype3.SObject_Name__c='Account';
        
         listrecd.add(rectype3);
         
         
          RecordTypes_Setting__c rectype4=new RecordTypes_Setting__c();
        rectype4.Name='CA Indirect Lead';
        rectype4.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Indirect Lead').getRecordTypeId();
        rectype4.SObject_Name__c='Lead';
        
         listrecd.add(rectype4);
         
         
           RecordTypes_Setting__c rectype5=new RecordTypes_Setting__c();
        rectype5.Name='CA Global Lead';
        rectype5.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        rectype5.SObject_Name__c='Lead';
        
         listrecd.add(rectype5);
        
        
       
          
       
          Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();   
         
           RecordTypes_Setting__c rectypeopp2=new RecordTypes_Setting__c();
        rectypeopp2.Name='Deal Registration';
        rectypeopp2.RecordType_Id__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId();
        rectypeopp2.SObject_Name__c='Opportunity';
         listrecd.add(rectypeopp2);
          RecordTypes_Setting__c rectypeopp=new RecordTypes_Setting__c();
        rectypeopp.Name='New Opportunity';
        rectypeopp.RecordType_Id__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        rectypeopp.SObject_Name__c='Opportunity';
         listrecd.add(rectypeopp);
         RecordTypes_Setting__c rectypeopp1=new RecordTypes_Setting__c();
        rectypeopp1.Name='Acquisition';
        rectypeopp1.RecordType_Id__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Acquisition').getRecordTypeId();
        rectypeopp1.SObject_Name__c='Opportunity';
         listrecd.add(rectypeopp1);
         insert listrecd;
       id comopp = oppRecType.get('New Opportunity').getRecordTypeId();
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
         id comac=accRecType.get('Commercial Account').getRecordTypeId();
         account a = new account(name ='Test Account', recordtypeid =com);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c= 'NA';
        a.Sales_Area__c= 'America';
        a.Sales_Region__c= 'America';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        a.BillingCountry = 'USA';
         a.Customer_Category__c='Reseller';
        insert a;
        
          Product2 prod = new Product2(Name = 'Agile Central', 
            Family = 'Hardware',CSU_Driver__c='Agile Central');
        insert prod;
         Id pricebookId = Test.getStandardPricebookId();
         PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
         
          Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
         opp.recordtypeid=comopp;
        opp.AccountId = a.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_20_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
         insert opp;
         
           Opportunity oppt = new Opportunity();
        oppt.Name = 'test opp';
         oppt.recordtypeid=comopp;
        oppt.Service_Provider_Client__c = a.Id ; 
        oppt.CloseDate = system.today()+1;
        oppt.stageName = Label.Opp_Stage_20_Percent;
        oppt.Type='xSP';
        oppt.Cloud_Platform__c='Agile Central Embedded Use';
        oppt.Inside_Outside__c = 'Inside';
        oppt.Contract_Type__c = 'ELA';
        oppt.CurrencyIsoCode = 'USD';
         insert oppt;
         
         
         OpportunityLineItem OLI = new OpportunityLineItem();
OLI.OpportunityId = opp.Id; //Opportunity Id has to be assigned
OLI.PricebookEntryId = standardPrice.Id; //PriceBookEntry Id for that Product should be assigned.
OLI.Quantity = 1;
OLI.UnitPrice = standardPrice.UnitPrice;
OLI.Product2Id=prod.id;
 
insert OLI;
         
  OpportunityLineItem OLIp = new OpportunityLineItem();
OLIp.OpportunityId = oppt.Id; //Opportunity Id has to be assigned
OLIp.PricebookEntryId = standardPrice.Id; //PriceBookEntry Id for that Product should be assigned.
OLIp.Quantity = 1;
OLIp.UnitPrice = standardPrice.UnitPrice;
OLIp.Product2Id=prod.id;
 
insert OLIp;         
            lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
        ld.Commercial_Account__c=a.id;
         ld.CSU_Driver__c='Agile Central';
         insert ld;
         
          PageReference pageRef = Page.dupscoring_lead;
            pageRef.getParameters().put('id',String.valueOf(ld.Id));
            Test.setCurrentPage(pageRef);
          //ApexPages.StandardController sc = new ApexPages.StandardController(ld);
       
     Duplicateleadsearchcontroller testAcceptreject = new Duplicateleadsearchcontroller();
     }
    
      private static testmethod void testDuplicateleadsearch2()
     {
         String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
          String strRecordTypeIdAc = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='Account' and developername ='Generic_Record_Type'].Id;
           Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        List<RecordTypes_Setting__c > listrecd=new List<RecordTypes_Setting__c >();
        RecordTypes_Setting__c rectype=new RecordTypes_Setting__c();
        rectype.Name='Commercial Account';
        rectype.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
        rectype.SObject_Name__c='Account';
        listrecd.add(rectype);
          RecordTypes_Setting__c rectype1=new RecordTypes_Setting__c();
        rectype1.Name='CA Enterprise Account';
        rectype1.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Enterprise Account').getRecordTypeId();
        rectype1.SObject_Name__c='Account';
        
           listrecd.add(rectype1);
         RecordTypes_Setting__c rectype2=new RecordTypes_Setting__c();
        rectype2.Name='Account Team Covered Account';
        rectype2.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        rectype2.SObject_Name__c='Account';
        
         listrecd.add(rectype2);
        
         RecordTypes_Setting__c rectype3=new RecordTypes_Setting__c();
        rectype3.Name='Reseller/Distributor Account';
        rectype3.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
        rectype3.SObject_Name__c='Account';
        
         listrecd.add(rectype3);
         
         
          RecordTypes_Setting__c rectype4=new RecordTypes_Setting__c();
        rectype4.Name='CA Indirect Lead';
        rectype4.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Indirect Lead').getRecordTypeId();
        rectype4.SObject_Name__c='Lead';
        
         listrecd.add(rectype4);
         
         
           RecordTypes_Setting__c rectype5=new RecordTypes_Setting__c();
        rectype5.Name='CA Global Lead';
        rectype5.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        rectype5.SObject_Name__c='Lead';
        
         listrecd.add(rectype5);
        
        
       
          
       
      
         insert listrecd;
    
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
         id comac=accRecType.get('Commercial Account').getRecordTypeId();
         account a = new account(name ='Test Account', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c= 'NA';
        a.Sales_Area__c= 'America';
        a.Sales_Region__c= 'America';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        a.BillingCountry = 'USA';
         a.Customer_Category__c='Reseller';
        insert a;
        
            lead ldh=New Lead();
         ldh.LastName='Sesi Test';
         ldh.Company='Company Test';
         ldh.Status='New';
         ldh.RecordTypeId=strRecordTypeId;
        ldh.Commercial_Account__c=a.id;
         ldh.CSU_Driver__c='Agile Central';
         insert ldh;
         
         
            lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
        ld.Commercial_Account__c=a.id;
         ld.CSU_Driver__c='Agile Central';
         insert ld;
         
          PageReference pageRef = Page.dupscoring_lead;
            pageRef.getParameters().put('id',String.valueOf(ld.Id));
            Test.setCurrentPage(pageRef);
          //ApexPages.StandardController sc = new ApexPages.StandardController(ld);
       
     Duplicateleadsearchcontroller testAcceptreject = new Duplicateleadsearchcontroller();
     }

}