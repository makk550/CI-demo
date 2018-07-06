@isTest(SeeAllData=true)
public with sharing class Test_Renewals_MassGenerateOpp_New {
    public static void testMoveRenewals2(){
        
    Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');       
    insert ac;   
    Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR', Conversion_Rate__c = 10);        
    insert renCurrency;
    Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);       
    insert activeContract;     
    User u = [select id from user where IsActive=:true limit 1];
    
    Renewal__c renewal = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,Segmentation__c='HT');
    renewal.Expected_Close_Date__c=Date.valueOf('2013-05-05');
    renewal.Converted_To_Opportunity__c=false;
    renewal.Overall_Comments__c='Test';
    renewal.CurrencyIsoCode='USD';
    renewal.Projected_Time_Duration_Months__c=6;
    renewal.OwnerId=u.Id;
    renewal.OCV__c=100000;
    renewal.Annual_OCV_LC__c=200000;
    renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
    renewal.Projected_Renewal__c=50000;
    insert renewal;
    
    Product2 prod = new Product2(Name = 'TestProd');        
    insert prod;
    
    Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
    insert rnwlProdct;   
     
    
     
    Active_Contract_Product__c acp = new Active_Contract_Product__c();
    acp.name='Test';
    acp.Converted_To_Opportunity__c=false;
    acp.Active_Contract__c=activeContract.Id;
    acp.Renewal_Product__c=rnwlProdct.ID;
    insert acp;
  
    Test.startTest();
          
    ApexPages.StandardController convcont = new ApexPages.StandardController(renewal);
    Renewals_MassGenerateOpp_New   cntrl = new Renewals_MassGenerateOpp_New();
    cntrl.getItems();
    cntrl.segmentation = 'HT,MT,LT';
    cntrl.Convert();
    Test.stopTest();  
    
   
    renewal = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,Segmentation__c='MT');
    renewal.Expected_Close_Date__c=Date.valueOf('2013-05-05');
    renewal.Converted_To_Opportunity__c=false;
    renewal.Overall_Comments__c='Test';
    renewal.CurrencyIsoCode='USD';
    renewal.Projected_Time_Duration_Months__c=6;
    renewal.OwnerId=u.Id;
    renewal.OCV__c=100000;
    renewal.Annual_OCV_LC__c=200000;
    renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
    renewal.Projected_Renewal__c=50000;
    insert renewal;
    
    prod = new Product2(Name = 'TestProd');        
    insert prod;
    
    rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
    insert rnwlProdct;   
      
    acp = new Active_Contract_Product__c();
    acp.name='Test';
    acp.Converted_To_Opportunity__c=false;
    acp.Active_Contract__c=activeContract.Id;
    acp.Renewal_Product__c=rnwlProdct.ID;
    insert acp;
    convcont = new ApexPages.StandardController(renewal);
    cntrl = new Renewals_MassGenerateOpp_New();
    cntrl.getItems();
    cntrl.segmentation = 'HT,MT,LT';
    cntrl.Convert();
    
    renewal = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,Segmentation__c='LT');
    Date dt = Date.Today()+1;
    String sdt = String.valueof(dt);
    renewal.Expected_Close_Date__c=Date.valueOf(sdt);
    renewal.Converted_To_Opportunity__c=false;
    renewal.Overall_Comments__c='Test';
    renewal.CurrencyIsoCode='USD';
    renewal.Projected_Time_Duration_Months__c=6;
    renewal.OwnerId=u.Id;
    renewal.OCV__c=100000;
    renewal.Annual_OCV_LC__c=200000;
    renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
    renewal.Projected_Renewal__c=50000;
    insert renewal;
    
    prod = new Product2(Name = 'TestProd');        
    insert prod;
    
    rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
    insert rnwlProdct;   
      
    acp = new Active_Contract_Product__c();
    acp.name='Test';
    acp.Converted_To_Opportunity__c=false;
    acp.Active_Contract__c=activeContract.Id;
    acp.Renewal_Product__c=rnwlProdct.ID;
    insert acp;
    convcont = new ApexPages.StandardController(renewal);
    cntrl = new Renewals_MassGenerateOpp_New();
    cntrl.getItems();
    cntrl.segmentation = 'HT,MT,LT';
    cntrl.Convert();
    
    
}
@isTest(SeeAllData=true)
public static void testMoveRenewals3(){
    /*
    SystemIdUtility.skipOpportunityTriggers = true;
    SystemIdUtility.skipOpportunityLineItemTriggers = true ;
    Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');       
    insert ac;   
    Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');        
    insert renCurrency;
    Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);       
    insert activeContract;     
    User u = [select id from user where IsActive=:true limit 1];
    
    List<Renewal__c> renewalList = new List<Renewal__c> ();
    Renewal__c renewal ;
    for(Integer i = 0 ;i<1000;i++){
        renewal = new Renewal__c(name='TestRenewal'+i,Account__c=ac.Id,Segmentation__c='HT');
        renewal.Expected_Close_Date__c=Date.valueOf('2013-05-05');
        renewal.Converted_To_Opportunity__c=false;
        renewal.Overall_Comments__c='Test';
        renewal.CurrencyIsoCode='USD';
        renewal.Projected_Time_Duration_Months__c=6;
        renewal.OwnerId=u.Id;
        renewal.OCV__c=100000;
        renewal.Annual_OCV_LC__c=200000;
        renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
        renewal.Projected_Renewal__c=50000;
        renewalList.add(renewal);
    }
    insert renewalList;
    Test.startTest();
    Product2 prod = new Product2(Name = 'TestProd');        
    insert prod;
    Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);       
    insert rnwlProdct;
    Active_Contract_Product__c acp = new Active_Contract_Product__c();
    acp.name='Test';
    acp.Converted_To_Opportunity__c=false;
    acp.Active_Contract__c=activeContract.Id;
    acp.Renewal_Product__c=rnwlProdct.ID;
    insert acp;    
    
    ApexPages.StandardController convcont = new ApexPages.StandardController(renewal);
    Renewals_MassGenerateOpp_New cntrl = new Renewals_MassGenerateOpp_New();
    cntrl.getItems();
    cntrl.segmentation = 'HT,MT,LT';
    cntrl.Convert();
    Test.stopTest();*/  
      
}
}