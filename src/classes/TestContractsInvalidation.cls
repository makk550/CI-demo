@isTest
public class TestContractsInvalidation{    
    public static testMethod void ContractsInvalidationTest(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'jsmith@salesforce.com';
        email.ccAddresses = new String[] {'Jon Smith <' + contactEmail + '>'};
        email.subject = 'Dummy Account Name 123';
          
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
        system.assertNotEquals(null, a.id, 'Account inserted');
          
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;  
          
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=a.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=a.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product inserted');
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContractList[0].Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContractList[1].Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContractList[0].Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContractList[1].Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[0].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[1].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[2].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000,Contract_Product__c =activeContractProdList[3].Id, ACL_Status__c = 'invalid');
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        
        ContractsInvalidation CI = new ContractsInvalidation();
        SystemIdUtility.runTestContractsInvalidation = true;
        Test.startTest();
        Messaging.InboundEmailResult result = CI.handleInboundEmail(email, env);
        Test.stopTest();
    }   
    public static testMethod void ContractsInvalidationTest1(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        
        Account a = [select id from account limit 1];
        
        
        Product2 prod = [select id from Product2 limit 1];
       
        Active_Contract__c activeContract = new Active_Contract__c(CRV_Process_completed__c = true,
        name='TestActiveContract',Account__c=a.Id,Contract_Term_Months__c=10, Invalid__c = false);
        insert activeContract;
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='LT');
        insert actvContPrd;
        
        
        OpportunityLineItem oli1 = [Select id,Active_Contract_Product__r.Active_Contract__r.Status_Formula__c, Active_Contract_Product__c, OpportunityId 
                                                        FROM OpportunityLineItem where  Business_Type__c = 'Renewal' limit 1];
                                                        
        oli1.Active_Contract__c = activeContract.id;
        update oli1;    
        
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=a.Id);
        insert activeContract2 ;
        activeContract2.Invalid__c = true;
        update activeContract2 ;
        activeContract.Invalid__c = true;
        update activeContract ;
       
        }
           
}