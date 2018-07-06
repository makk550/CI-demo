@isTest
public class Test_PDDActiveContractLineItems {
		public static id pddEnhanceID;
     	public static Id accId ;
    	public static Id entId,IntId,prodId;
    	public static id materialID; 
        static testMethod void testActiveContractLineItems(){
        accData();
        String noOfRecords;
        Test.startTest();
       
        PageReference pg = Page.PDDActiveContractLineItems;
        Test.setCurrentPage(pg); 
        ApexPages.currentPage().getParameters().put('id', pddEnhanceID); 
         PDDActiveContractLineItems pddAcli = new PDDActiveContractLineItems();
        pddAcli.getActiveContractLineItems();
        
        //contrl.getEntitlementsList();
       
        pddAcli.cancel();
        pddAcli.first();
        pddAcli.last();
        pddAcli.next();
        pddAcli.previous();
        pddAcli.refresh();
               
        Boolean next = pddAcli.hasNext;
        Integer pgnum = pddAcli.pageNumber;
        Boolean previous = pddAcli.hasPrevious;
         Test.stopTest();
    }
    
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
            name='40166896',Account__c=a.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='40216320',Account__c=a.Id);
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
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[0].Id, ACL_Status__c = 'invalid', Sales_Document_Item__c = '00150');
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,Product_Material__c =productMaterial.id,
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[1].Id, ACL_Status__c = 'invalid', Sales_Document_Item__c = '00025');
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,Product_Material__c =productMaterial.id,
            ATTRF_CRV__c = 14000, Contract_Product__c =activeContractProdList[2].Id, ACL_Status__c = 'invalid', Sales_Document_Item__c = '00150');
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
            AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,Orig_Dismantle_Date__c =System.today()+30,
            OCV__c = 200000,
            ATTRF_CRV__c = 14000,Contract_Product__c =activeContractProdList[3].Id, ACL_Status__c = 'invalid', Sales_Document_Item__c = '00025');
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
        entId =actLineItemsList[1].id;
        System.debug('%%%%%'+entId);
         
        PDD_Enhanced__c ePDD = new PDD_Enhanced__c();
        ePDD.name = 'Test';
        ePDD.GA_Level__c = 'GA-3 or Beyond';
        ePDD.CA_Product_Controller__c = prodCtl.id;
        ePDD.Account__c = a.Id;
        ePDD.Associated_Contracts__c = '40166896-00150;40216320-00025';
        Database.SaveResult sr2 =  Database.insert(ePDD); 
         pddEnhanceID =  sr2.id;
         System.debug('%%%%%pddEnhanceID'+pddEnhanceID);
    }
}