@isTest
private class Renewal_ViewAccountsTest {

    static testMethod void myUnitTest1() {
        List<Account> actLst = new List<Account>();
        List<Active_Contract__c> actContLst = new List<Active_Contract__c>();
        Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        Account ac2= new Account(Name='testAccount2',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        actLst.add(ac);
        actLst.add(ac2);
        insert actLst;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'TestProd1');
        prodList.add(prod);  
        Product2 prod2 = new Product2(Name = 'TestProd2');
        prodList.add(prod2);
        insert prodList;
                
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        Active_Contract__c activeContract3 = new Active_Contract__c(name='TestActiveContract3',Account__c=ac2.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        //Active_Contract__c activeContract4 = new Active_Contract__c(name='TestActiveContract4',Account__c=ac2.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        
        actContLst.add(activeContract);
        actContLst.add(activeContract2);
        actContLst.add(activeContract3);
        //actContLst.add(activeContract4);
        insert actContLst; 
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('12/20/2010'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2010'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('12/20/2010'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract3.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('12/20/2010'),Pre_Segmentation__c ='HT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 15000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 15000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id);
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 30000,Raw_Maint_Calc_LC__c = 20000,
        OCV__c = 30000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id);
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id);
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id);
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        
        Test.startTest();
        Renewal_ViewAccounts r1 = new Renewal_ViewAccounts();
       // r1.searchAccount();
        r1.OnClickNext();
        r1.OnClickPrevious();
        r1.getCurrentPage();
        r1.setfirstValue(5);
        r1.getfirstValue();
        r1.getifNext();
        r1.getifPrevious();
        r1.getdisplayNum();
        r1.getdisplaySearchResult();
        r1.getTotalPageNumber();
        r1.getSortDirection();
        r1.region ='LA';
        r1.Area ='Japan';
        r1.accountName = 'test';
        r1.OCV_Greater_than = 5000;
        r1.AOCV_Greater_than = 6000;
        r1.searchAccount();
        r1.getdisplaySearchResult();
        for(integer i=0;i<r1.sDataLst.size();i++){
            r1.sDataLst.get(i).isActive = true;
            if(1>5)
                break;
        //camDetails.PLBSSummaryApplicantWise.get(i).add()
        }
        r1.changeFinanceOwner();
        Test.stopTest();
        
    }
}