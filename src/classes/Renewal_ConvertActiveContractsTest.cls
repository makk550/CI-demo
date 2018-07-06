@isTest
private class Renewal_ConvertActiveContractsTest {
	@isTest(SeeAllData=true)
    static void TestSpecificProductSegmentation() {
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //ac.Sales_Area__c =''
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
        Product2 prod = new Product2(Name = 'Specific Product');
        prodList.add(prod);  
        
        insert prodList;
        
        //inserting rules
        List<Contracts_Grouping_Rules__c> RulesList = new List<Contracts_Grouping_Rules__c>();
        Contracts_Grouping_Rules__c cg1 = new Contracts_Grouping_Rules__c(
        Region__c ='NA',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg2 = new Contracts_Grouping_Rules__c(
        Region__c ='EMEA',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        
        Contracts_Grouping_Rules__c cg3 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',OCV_Lessthan__c =200000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg4 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',OCV_Greaterthan__c =200000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='HT');
        
        Contracts_Grouping_Rules__c cg5 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',OCV_Lessthan__c =15000,Area__c ='Korea',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='LT');
        Contracts_Grouping_Rules__c cg6 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',Area__c ='India',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg7 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',OCV_Greaterthan__c =30000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='HT');
         Contracts_Grouping_Rules__c cg8 = new Contracts_Grouping_Rules__c(
        Region__c ='PS/CAN',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        
        RulesList.add(cg1);
        RulesList.add(cg2);
        RulesList.add(cg3);
        RulesList.add(cg4);
        RulesList.add(cg5);
        RulesList.add(cg6);
        RulesList.add(cg7);
        insert RulesList;
        
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac1.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        
        Test.startTest();
        PageReference pageRef = Page.Renewal_ConvertActiveContracts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('records',activeContract.Id + ',' +activeContract2.Id);
        Renewal_ConvertActiveContracts rc = new Renewal_ConvertActiveContracts();
        Renewal_ConvertActiveContracts.isTest = true;
        
        rc.Ids = activeContract.Id + ',' +activeContract2.Id; 
        rc.Renewal_ConvertActiveContractsMethod();
        rc.Proceed();
        rc.recentRenewals();
        Test.stopTest();
    }
       @isTest(SeeAllData=true)
       static void TestSpecificRoleSegmentation() {
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
        
        Decimal orderOfPrecedence;
        if([select id from Contracts_Grouping_Rules__c].size() > 0)
         orderOfPrecedence = (Decimal)[select Max(Order_of_Precedence__c)orderby from Contracts_Grouping_Rules__c].get(0).get('orderby');
        else
         orderOfPrecedence = 0;
         
        List<Contracts_Grouping_Rules__c> RulesList = new List<Contracts_Grouping_Rules__c>();
        Contracts_Grouping_Rules__c cg1 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',Product_Segmentation__c ='LT',
        Renewal_Segmentation__c ='LT',Order_of_Precedence__c = orderOfPrecedence+1);
        Contracts_Grouping_Rules__c cg2 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',Product_Segmentation__c ='LT',
        OCV_Greaterthan__c =200000, Renewal_Segmentation__c ='HT',Order_of_Precedence__c = orderOfPrecedence+2);
        Contracts_Grouping_Rules__c cg3 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',Product_Segmentation__c ='LT',
        OCV_Lessthan__c =200000, Renewal_Segmentation__c    ='MT',Order_of_Precedence__c = orderOfPrecedence+3);
        Contracts_Grouping_Rules__c cg4 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',Product_Segmentation__c ='N/A',
        OCV_Lessthan__c = 200000, Renewal_Segmentation__c   ='MT',Order_of_Precedence__c = orderOfPrecedence+4);
        Contracts_Grouping_Rules__c cg5 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',Product_Segmentation__c ='N/A',
        OCV_Greaterthan__c = 200000, Renewal_Segmentation__c    ='HT',Order_of_Precedence__c = orderOfPrecedence+5);
        
        Contracts_Grouping_Rules__c cg6 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',Product_Segmentation__c ='N/A',Area__c ='Korea',
        OCV_Lessthan__c = 15000, Renewal_Segmentation__c    ='LT',Order_of_Precedence__c = orderOfPrecedence+6);
        Contracts_Grouping_Rules__c cg7 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',Product_Segmentation__c ='N/A',Area__c ='Korea',
        OCV_Greaterthan__c = 300000, Renewal_Segmentation__c    ='HT',Order_of_Precedence__c = orderOfPrecedence+7);
        Contracts_Grouping_Rules__c cg8 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',Product_Segmentation__c ='N/A',Area__c ='Japan',
        OCV_Lessthan__c = 30000, Renewal_Segmentation__c    ='LT',Order_of_Precedence__c = orderOfPrecedence+8);
        
        RulesList.add(cg1);
        RulesList.add(cg2);
        RulesList.add(cg3);
        RulesList.add(cg4);
        RulesList.add(cg5);
        RulesList.add(cg6);
        RulesList.add(cg7);
        RulesList.add(cg8);
        insert RulesList;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        Renewal_Currency__c renCurrency1 = new Renewal_Currency__c(name='USD');
        insert renCurrency1;
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'TestProd1');
        prodList.add(prod);  
        Product2 prod2 = new Product2(Name = 'TestProd2');
        prodList.add(prod2);
        insert prodList;
        
        
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac1.Id,
        Renewal_Currency__c=renCurrency1.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.today(),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('1/20/2014'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('2/20/2014'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('2/20/2014'),Pre_Segmentation__c ='HT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 15000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 15000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 30000,Raw_Maint_Calc_LC__c = 20000,
        OCV__c = 30000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        //system.debug('activeContractProdList>>' + activeContractProdList[0].Dismantle_Date__c);
        Test.startTest();
        PageReference pageRef = Page.Renewal_ConvertActiveContracts;
        Test.setCurrentPage(pageRef);
        
        Renewal_ConvertActiveContracts rc1 = new Renewal_ConvertActiveContracts();
        rc1.Renewal_ConvertActiveContractsMethod();
        pageRef.getParameters().put('records',activeContract.Id + ',' +activeContract2.Id);
        Renewal_ConvertActiveContracts rc = new Renewal_ConvertActiveContracts();
        
        //System.assert(lstActProd.size()>0,true);                                                 
        rc.Renewal_ConvertActiveContractsMethod();
        rc.Proceed();
        Test.stopTest();
   } 
   
   @isTest(SeeAllData=true)
   static void TestConvertToRenewalsTimeFrame() {
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //ac.Sales_Area__c =''
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
         Account ac2 = new Account();
        ac2.Name = 'Test Account';
        ac2.BillingState = 'NY';   
        ac2.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac2.GEO__c='PS/CAN';
        ac2.Enterprise_ID__c = '1234te';
        ac2.Enterprise_Account_Name__c = 'rdName1';
        ac2.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accntList.add(ac2);
        insert accntList;
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'Specific Product');
        prodList.add(prod);  
        
        insert prodList;
        
        //inserting rules
        List<Contracts_Grouping_Rules__c> RulesList = new List<Contracts_Grouping_Rules__c>();
        Contracts_Grouping_Rules__c cg1 = new Contracts_Grouping_Rules__c(
        Region__c ='NA',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg2 = new Contracts_Grouping_Rules__c(
        Region__c ='EMEA',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        
        Contracts_Grouping_Rules__c cg3 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',OCV_Lessthan__c =200000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg4 = new Contracts_Grouping_Rules__c(
        Region__c ='LA',OCV_Greaterthan__c =200000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='HT');
        
        Contracts_Grouping_Rules__c cg5 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',OCV_Lessthan__c =15000,Area__c ='Korea',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='LT');
        Contracts_Grouping_Rules__c cg6 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',Area__c ='India',
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='MT');
        Contracts_Grouping_Rules__c cg7 = new Contracts_Grouping_Rules__c(
        Region__c ='Asia-Pacific',OCV_Greaterthan__c =30000,
        SFDC_Product__c ='Specific Product',Renewal_Segmentation__c ='HT');
        
        RulesList.add(cg1);
        RulesList.add(cg2);
        RulesList.add(cg3);
        RulesList.add(cg4);
        RulesList.add(cg5);
        RulesList.add(cg6);
        RulesList.add(cg7);
        insert RulesList;
        
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac1.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Baseline_ATTRF_LC__c =1000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        
        Test.startTest();
        PageReference pageRef = Page.Renewal_ConvertActiveContracts;
        Test.setCurrentPage(pageRef);
        
        Renewal_ConvertToRenewal  rc = new Renewal_ConvertToRenewal ();
            
        rc.getItems(); 
        rc.Convert();
        rc.ac.ChangeDate__c = date.parse('1/1/2013');
        rc.Convert();
        rc.ac.Expected_Close_Date__c = date.parse('2/20/2014');
        rc.region = '-None-';
        Renewal_ConvertActiveContracts.isTest = true;
        
        rc.Convert();        
        Test.stopTest();
    }
}