@isTest
public class Batch_RenewalDetachContracts_Test {

    public static Opportunity opp;
    
    static testMethod void testMethod1() 
    {
        
  	 Map<id, PricebookEntry> mapPBE = new  Map<id, PricebookEntry>();
        
        createtestdata();
        list<active_contract_product__c> acp = [select Id from active_contract_product__c]; 
        Set<Id> ActiveContractIds = (new Map<Id,SObject>(acp)).keySet();
        Test.startTest();

            Batch_RenewalDetachContracts obj = new Batch_RenewalDetachContracts(ActiveContractIds,opp.Id);
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    public static void createtestdata()
    {
          SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Test_CreateOpportunity.insertRecordtypes();
          Account ac = new Account();
            ac.Name = 'Test Account';
            ac.BillingState = 'NY';   
            ac.Customer_Category__c = 'Enterprise';
            ac.Account_Status__c = 'Approved';      
            ac.BillingState = 'NY';
            ac.GEO__c='NA';
            ac.Enterprise_ID__c = '1234te';
            ac.Enterprise_Account_Name__c = 'rdName';
            ac.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
            
            ac.Reseller_Disti_Regional_ID__c = 'PA75344';
            ac.Reseller_Distributor_Name__c = 'APJ DM Test';
            insert ac;

        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        
        
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',  Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
        
        
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
         opp = new Opportunity(RecordTypeId=recopp.Id, Name = 'oppTestAddRenewal1' , StageName = 'test' , CloseDate = Date.today(), AccountId = smbAcct.Id, 
                                          Reseller__c= resellerAcct.Id, currencyIsoCode='USD', Start_Date__c = Date.today(), End_Date__c = Date.today().addMonths(12));
        insert opp;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='USD');
        insert renCurrency;     
        
        // Pricebook2 pb2 = [SELECT Id  FROM Pricebook2 WHERE Name='CA Product List' and  isStandard=true and isactive=true  LIMIT 1];      
        // Pricebook2 pb = new Pricebook2(Name = 'CA Product List', Description = 'Price Book Test', IsActive = true );
        //insert pb;
        Product2 prod2 = new Product2(Name = 'testprod' ,Commissionable_BU__c ='SEC');                    
        insert prod2;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod2.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='CA Product List', isActive=true);
        insert customPB;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod2.Id,
            UnitPrice = 12000, IsActive = true);
        insert pbe;
        
        // PricebookEntry pbe = new PricebookEntry(Pricebook2Id =pb2.Id , Product2Id = prod2.Id ,currencyIsoCode =opp.currencyIsoCode,UnitPrice = 1000.00,UseStandardPrice =true, IsActive = True);                    
        // insert pbe;
        
        
        opp.Pricebook2Id = customPB.Id;
        update opp;
        
        
        List<Renewal__c> renewalList = new List<Renewal__c>();    
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=smbAcct.Id,Projected_Renewal__c=200);
        renewalList.add(renewal);  
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=smbAcct.Id);
        renewalList.add(renewal2);
        insert renewalList;
        
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=smbAcct.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=smbAcct.Id,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Renewal_Product__c> renewalProdList = new List<Renewal_Product__c>();
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod2.Id,Renewal__c=renewal.Id);
        renewalProdList.add(rnwlProdct); 
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        renewalProdList.add(rnwlProdct2);
        insert renewalProdList;
        
        List<Active_Contract_Product__c> acplist = new List<Active_Contract_Product__c>();       
        Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP1',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,opportunity__C =opp.id);
        acplist.add(actvContPrd1);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,opportunity__C =opp.Id);
        acplist.add(actvContPrd2);
        
        insert acplist;
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;       
        
        
        
        List<Active_Contract_Line_Item__c> acllist = new List<Active_Contract_Line_Item__c>();       
        Active_Contract_Line_Item__c aclprod1= new Active_Contract_Line_Item__c(name='TestACL1',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod1);
        Active_Contract_Line_Item__c aclprod2= new Active_Contract_Line_Item__c(name='TestACL2',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today()+12 ,Raw_Maintenance_LC__c=10023);
        acllist.add(aclprod2);     
        Active_Contract_Line_Item__c aclprod3= new Active_Contract_Line_Item__c(name='TestAC2L1',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod3);
        Active_Contract_Line_Item__c aclprod4= new Active_Contract_Line_Item__c(name='TestACL32',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today()+24 ,Raw_Maintenance_LC__c=10023);

        insert acllist;
        
        
        
        List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
        for(integer i=0;i<15;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id,Active_Contract_Product__c=actvContPrd1.id, PricebookEntryId = pbe.Id,CA_Contract_Product_Name__c= 'TestCa'+i,unitprice= 100.0 );
            OppItmList.add(oli);
            i=i++;
        }
        insert OppItmList;
        
        
        List<CA_Product_Renewal__c> caProdRnwl =new List<CA_Product_Renewal__c>();
        for(integer i=0;i<15;i++)
        {
            CA_Product_Renewal__c ca = new CA_Product_Renewal__c(Name ='TestCA'+i,Renewal_Opportunity__c = opp.Id,Quote__C ='testquote');
            caProdRnwl.add(ca);
            i=i++;
        }
        insert caProdRnwl;
        
      
    }
}