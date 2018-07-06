@isTest
public class PDDSingle_Test {
    
    public static Id accId ;
    public static Id entId,IntId,prodId;
    public static id materialID;    
    
    //TestMethod for EntitlementList
    public static testMethod void EntitlementList_Test(){
        accData();  
        PageReference pg = Page.PDDSingle;
        Test.setCurrentPage(pg); 
        ApexPages.currentPage().getParameters().put('dID', accId); 
        ApexPages.currentPage().getParameters().put('sdunsID', accId);
        ApexPages.currentPage().getParameters().put('materialId', materialID);
        ApexPages.currentPage().getParameters().put('myIntId', IntId);
        ApexPages.currentPage().getParameters().put('myEntID', entId);
        
        ApexPages.currentPage().getParameters().put('productId',prodId);
        ApexPages.currentPage().getParameters().put('myDID', accId);
        ApexPages.currentPage().getParameters().put('intID', IntId);       
        
        PDDSingle contrl = new PDDSingle();
        
        //contrl.getEntitlementsList();
        contrl.getContItemList() ;
        contrl.getInstanceList();
        contrl.getEntitlement();
        contrl.getInstanceEdit();
        contrl.cancel();
        contrl.first();
        contrl.last();
        contrl.next();
        contrl.previous();
        contrl.refresh();
        contrl.toggleSort();        
        
        contrl.goNewInst();
        contrl.goEditInst();
        contrl.goViewInst();
        
        contrl.copyInstance();
        contrl.goCustoVersionData();
        contrl.getValStatment();
        contrl.goSaveRelStatement();
        Boolean next = contrl.hasNext;
        Integer pgnum = contrl.pageNumber;
        Boolean previous = contrl.hasPrevious;
        contrl.copyInst();
        contrl.goNewInst(); 
        contrl.goSaveInst(); 
        contrl.goInstCancel();
        contrl.goDelInst();      
        
    }
    
    // TestMethod for ProdRelLkpController
    public static testMethod void ProdRelLkpControllerTest(){
        accData();
        PageReference pg = Page.ProdRelLkp;
        Test.setCurrentPage(pg);       
        ProdRelLkpController contrl = new ProdRelLkpController();
        contrl.query='DEMAND'; 
        Pagereference resQuery = contrl.runQuery();
    } 
    
    
    //TestData for Release level visible on entilements page
    public static testmethod void testReleaseVersion() {        
        Test.StartTest();
        PDDSingle pds = new PDDSingle();
        String versionNum =  pds.versionCompare('1', '2'); 
        System.AssertEquals(versionNum, '2');
        Test.StopTest();        
    }
    
    //Test Data
    public static testMethod void accData()
    {        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers=true;
        
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
        accId=a.id; 
        
        
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
        prodId =prod.Id;
        
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='Test';
        insert prodCtl;
        
        Product_Material__c productMaterial = new Product_Material__c(
            Name='p123', 
            Product__c=prod.Id, 
            Material_Text__c='test material text',
            SAP_Product_Mapping__c = 'product mapping',
            Source_System__c = 'SAP',
            POC_Eligible__c = true,
            CA_Product_Controller__c =prodCtl.id
            
        );
        insert productMaterial;
        materialID = productMaterial.id;
        
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
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,Product_Material__c =productMaterial.id,
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[0].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,Product_Material__c =productMaterial.id,
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[1].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,Product_Material__c =productMaterial.id,
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[2].Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,
            ATTRF_CRV__c = 14000,Contract_Product__c =activeContractProdList[3].Id, ACL_Status__c = 'invalid');
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        entId =actLineItemsList[1].id;
        System.debug('%%%%%'+entId);
        
        InstancePDD__c zInt = new InstancePDD__c();
        zInt.Name='Test Instance';
        zInt.Is_Deleted__c = false;
        zInt.Product_Detail__c='Test Product';
        zInt.Release_Version__c='1';
        zInt.Capacity_Used__c=100;
        zInt.Environment_Type__c='Testing';
        zInt.Software_Type__c='OnPremise';
        zInt.Account_ID__c =a.Id;
        zInt.Product_Material__c=productMaterial.id;
        
        Database.SaveResult sr1 =  Database.insert(ZInt); 
        IntId =sr1.getId();
        
        PDD__c zPDD = new PDD__c();
        zPDD.name = 'Test';
        zPDD.Barriers_to_Adoption__c = 'Unknown';
        zPDD.Business_Alignment__c = 'Test';
        zPDD.Business_Impact__c = 'High';
        zPDD.Capacity_Used__c = 0;
      
        zPDD.Comments__c = 'High';
        zPDD.Competitive_Technology__c = 'No';
        zPDD.CSP_Candidate__c = 'Not Needed';
        zPDD.Production_Status__c = 'Unknown';
        zPDD.Renewal_Risk__c = 'Unknown';
        zPDD.Scale_of_Adoption__c = 'Unknown';
        zPDD.Upgrade_Planned__c = 'No';
        zPDD.Instance__c = sr1.getId();
        Database.SaveResult sr2 =  Database.insert(ZPDD);      
        
        Account_Value_Statement__c valStmt = new Account_Value_Statement__c();
        valStmt.Account__c = accId;
        valStmt.Product_Material__c = materialID;
        valStmt.Value_Statement__c = 'test';
        insert valStmt;          
    }
    
    
    public static testMethod void testPDDFetchDetails(){
        Test.startTest();
        PddFetchDetails obj1 = new PddFetchDetails(false);
        PddFetchDetails obj2 = new PddFetchDetails(System.now(),'1.0', false);
        Test.stopTest();
    }
    
}