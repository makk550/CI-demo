@isTest
private class Renewal_MassConvertToOpportunityTest {

/*
  static  testmethod void TestMethodfor_TimeFrame() {
         SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Test_CreateOpportunity.insertRecordtypes();
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='Asia-Pacific';
        ac.Sales_Area__c ='Korea';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accntList.add(ac);
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac1.GEO__c='LA';
        ac1.Enterprise_ID__c = '1234te';
        ac1.Enterprise_Account_Name__c = 'rdName1';
        ac1.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accntList.add(ac1);
        insert accntList;
                 
                
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
       
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'TestProd');
        prodList.add(prod);  
        Product2 prod2 = new Product2(Name = 'TestProd2');
        prodList.add(prod2);
        insert prodList; 
        
        List<Renewal__c> renewalList = new List<Renewal__c>();    
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=ac.Id,Projected_Renewal__c=200,
        Expected_Close_Date__c = date.parse('11/01/2023'),Segmentation__c ='HT');
        renewalList.add(renewal);  
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,
        Expected_Close_Date__c = date.parse('11/06/2022'),Segmentation__c = 'MT');
        renewalList.add(renewal2);
        insert renewalList;
              
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Renewal_Product__c> renewalProdList = new List<Renewal_Product__c>();
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        renewalProdList.add(rnwlProdct); 
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        renewalProdList.add(rnwlProdct2);
        insert renewalProdList;
              
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        activeContractProdList.add(actvContPrd2);
        insert activeContractProdList;        
              
        
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;
        
        Test.startTest();
        PageReference pageRef = Page.Renewal_ConvertToOpportunityWithDate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('records',activeContract.Id + ',' +activeContract2.Id);
        Renewal_ConvertToOpportunityWithDate rc = new Renewal_ConvertToOpportunityWithDate();
        rc.getItems();
        /////rc.Convert();
        rc.ac.Contract_End_Date__c = System.Today().addYears(2);
        ///rc.Convert();
        rc.ac.Agreement_Acceptance_Date__c = System.Today();
        /////rc.Convert();
        Test.stopTest();
   } 
  
    
   static  testMethod  void TestMethodforListView() {
           SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Test_CreateOpportunity.insertRecordtypes();
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='Asia-Pacific';
        ac.Sales_Area__c ='Korea';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accntList.add(ac);
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac1.GEO__c='LA';
        ac1.Enterprise_ID__c = '1234te';
        ac1.Enterprise_Account_Name__c = 'rdName1';
        ac1.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accntList.add(ac1);
        insert accntList;
                 
                
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
       
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'TestProd');
        prodList.add(prod);  
        Product2 prod2 = new Product2(Name = 'TestProd2');
        prodList.add(prod2);
        insert prodList; 
        
        List<Renewal__c> renewalList = new List<Renewal__c>();    
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=ac.Id,Projected_Renewal__c=200,
        Expected_Close_Date__c = date.parse('01/02/2017'),Segmentation__c ='HT');
        renewalList.add(renewal);  
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=ac.Id,
        Expected_Close_Date__c = date.parse('01/10/2019'),Segmentation__c = 'MT');
        renewalList.add(renewal2);
        insert renewalList;
              
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Renewal_Product__c> renewalProdList = new List<Renewal_Product__c>();
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        renewalProdList.add(rnwlProdct); 
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        renewalProdList.add(rnwlProdct2);
        insert renewalProdList;
              
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        activeContractProdList.add(actvContPrd2);
        insert activeContractProdList;        
              
        
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;
        
        Test.startTest();
        PageReference pageRef = Page.Renewal_MassOpportunityConv;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('records',renewal.Id + ',' +renewal2.Id);
        
        Renewal_MassOpportunityConv rc = new Renewal_MassOpportunityConv();
        //rc.RenewalConv();
        rc.geterrorlog();
       Map<String, String> convertren = rc.convRenewals();
       Map<String, String> createopp = rc.CreateOpp(renewal);
        Test.stopTest();
   } */
}