@isTest
private class Renewal_editContractHeaderInfoTest {
    @isTest(SeeAllData=true)
    static void TestMethod1() {
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingStreet = 'Arlington';
        ac.BillingCountry = 'US';
        ac.BillingCity = 'VA';
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.Commercial_Id__c = 'test';
        //ac.RecordTypeId = SystemIdUtility.getEnterpriseAccountRecordTypeId();
        //ac.Sales_Area__c =''
        accntList.add(ac);
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac1.BillingStreet = 'Arlington';
        ac1.BillingCountry = 'US';
        ac1.BillingCity = 'VA';
        ac1.GEO__c='LA';
        ac1.Enterprise_ID__c = '1234te';
        ac1.Enterprise_Account_Name__c = 'rdName1';
        ac1.Commercial_Id__c = 'test';
        //ac1.RecordTypeId = SystemIdUtility.getEnterpriseAccountRecordTypeId();
        accntList.add(ac1);
        insert accntList;
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'Specific Product');
        prodList.add(prod);  
        
        insert prodList;
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac1.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2010'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2010'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2010'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2010'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,Raw_Maintenance_LC__c = 25000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Raw_Maintenance_LC__c = 45000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,Raw_Maintenance_LC__c = 35000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,Raw_Maintenance_LC__c = 51000,Authorized_Use_Model_text__c='MIPS LICENSE',Licensed_MIPS_Quantity__c = 25,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        
        Test.startTest();
        PageReference pageRef = Page.Renewal_add_CA_RenewalProduct;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(new Active_Contract__c(id=activeContract.Id));        
        
        pageRef.getParameters().put('Id',activeContract.Id);
        Renewal_editContractHeaderInfo ctrl = new Renewal_editContractHeaderInfo(con);
        ctrl.UpdateContractValues();
        ctrl.goback();
        
        Test.stopTest();
        }
}