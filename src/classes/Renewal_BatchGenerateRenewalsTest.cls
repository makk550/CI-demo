@isTest
private class Renewal_BatchGenerateRenewalsTest{

@isTest(SeeAllData=true)
public static void testBatch() {
    
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
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2012'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2012'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2012'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2012'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
    
    Test.StartTest();
    Renewal_BatchGenerateRenewals reassign = new Renewal_BatchGenerateRenewals(
    date.parse('01/01/2012'),date.parse('01/31/2013'),'-None-',true);
    Renewal_BatchGenerateRenewals.isTest = true; 
    reassign.processResult(activeContractprodList);
    ID batchprocessid = Database.executeBatch(reassign,400);
    Test.StopTest();
    
}
}