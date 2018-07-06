/*
* Test class modified by MERHA02
* Apex Class: Renewal_OpportunityUtilityClass
* Code Covergae: 84%
* Creates Opportunity, Opportunity Products at Active Contract Line Item level
* without the use of seealldata = true.
* It skips account,Opportunity triggers.
*/ 
@isTest
public class Renewal_OpportunityUtilityClass_Test {
    static ID oppid;  
    static Pricebook2 pb = new Pricebook2();
    STATIC Opportunity opp;
    Static Map<String, String> errorLog;
    static testMethod void myTest()
    {
        
        createdata();
        Test.startTest();
        Map<ID, Renewal__c> maprenewalslist= new   Map<ID, Renewal__c>();
        Set<Id> renwlids = new Set<id>();
        
        Renewal__c rnwl = [select Id,Local_Currency__c from Renewal__c limit 1];
        renwlids.add(rnwl.id);
        maprenewalslist = Renewal_OpportunityUtilityClass.RetrieveRenewals(renwlids);
        Renewal__c renewal = maprenewalslist.get(rnwl.Id);
        Renewal_OpportunityUtilityClass tempInstance = new Renewal_OpportunityUtilityClass();
      
        Renewal_OpportunityUtilityClass.CreateOpportunity(renewal);
     
     	Renewal_OpportunityUtilityClass.getOpportunitydetails(oppid);
        Renewal_OpportunityUtilityClass.Primarycontactexists(opp);
        tempInstance.emailLogs(new Map<String,String>{'testing Email Logs'=>'Testing Renewal_OpportuntityUtilityClass'});
        Test.stopTest();
        
        
    }
    static void createdata()
    {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
             
        User u = Test_CreateOpportunity.createPartnerUser();
        
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
        
        oppid = opp.id;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='USD' );
        insert renCurrency; 
             
        Pricebook2 pb = new Pricebook2(Name = 'CA Product List', Description = 'Price Book Test', IsActive = true );
        insert pb;
        Product2 prod2 = new Product2(Name = 'testprod' ,Commissionable_BU__c ='SEC',IsActive = true );                    
        insert prod2;
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'CA Product List';
        recordTypeObj1.SObject_Name__c = 'PriceBook';
        recordTypeObj1.RecordType_Id__c = pb.id;
        insert recordTypeObj1;
		
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod2.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pb.Id, Product2Id = prod2.Id,
            UnitPrice = 12000, IsActive = true,currencyIsoCode='USD');
        insert pbe;
       
        opp.Pricebook2Id = pb.Id;
        update opp;
        oppid = opp.id;
        
        Territory terr = [Select Territory_Country__c from Territory where Territory_Country__c != null LIMIT 1];
        
        Renewal_Currency__c renl_curr=new Renewal_Currency__c(Name='Renewal Currency 1',CurrencyIsoCode='USD');
        insert renl_curr;
        
        List<Renewal__c> renewalList = new List<Renewal__c>();    
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=smbAcct.Id,
                                            Projected_Renewal__c=200,Converted_To_Opportunity__c=false);
        renewal.Expected_Close_Date__c=System.today();
        renewal.Reason_duration_is_1_year__c = 'Bridge Contract';
        renewal.Status_at_end_of_term__c = 'Re-Renew';
        renewal.Converted_To_Opportunity__c=false;
        renewal.Overall_Comments__c='Test';
        renewal.CurrencyIsoCode='USD';
        renewal.Renewal_Currency__c=renl_curr.id;
        renewal.Projected_Time_Duration_Months__c=6;
        renewal.OwnerId=u.Id;
        renewal.OCV__c=100000;
        renewal.Annual_OCV_LC__c=200000;
        renewal.Sold_to_Ship_to_Party_Site_ID__c='1234';
        renewal.Projected_Renewal__c=50000;
        renewal.Territory_Country__c = 'USA';
        renewal.Segmentation__c= 'HT';
        renewalList.add(renewal);  
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=smbAcct.Id,Converted_To_Opportunity__c=false);
        renewalList.add(renewal2);
        
        Renewal__c renewal3 = new Renewal__c(name='TestRenewal3',Account__c=ac.Id,Segmentation__c='HT');
        renewal3.Expected_Close_Date__c=System.today();
        renewal3.Reason_duration_is_1_year__c = 'Bridge Contract';
        renewal3.Status_at_end_of_term__c = 'Re-Renew';
        renewal3.Converted_To_Opportunity__c=false;
        renewal3.Overall_Comments__c='Test';
        renewal3.CurrencyIsoCode='USD';
        renewal3.Projected_Time_Duration_Months__c=6;
        renewal3.OwnerId=u.Id;
        renewal3.OCV__c=100000;
        renewal3.Annual_OCV_LC__c=200000;
        renewal3.Sold_to_Ship_to_Party_Site_ID__c='1234';
        renewal3.Projected_Renewal__c=50000;
        renewal3.Segmentation__c='KT';
        
        renewal3.Territory_Country__c = terr.Territory_Country__c;
        renewalList.add(renewal3);
        insert renewalList;
        
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(name='Test Active Contract Name',Account__c=smbAcct.Id,
                                                                   Contract_Term_Months__c=10,header_dismantle_date__c=System.today(),
                                                                   Renewal_Currency__c=renCurrency.Id);
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
        Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP1',Active_Contract__c=activeContract.Id,
                                                                                Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,
                                                                                Opportunity__c= opp.id);
        acplist.add(actvContPrd1);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
                                                                                Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id
                                                                               );
        acplist.add(actvContPrd2);
        
        insert acplist;
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,
                                                                   Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,
                                                                    Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;       
        
        
        
        List<Active_Contract_Line_Item__c> acllist = new List<Active_Contract_Line_Item__c>();       
        Active_Contract_Line_Item__c aclprod1= new Active_Contract_Line_Item__c(name='TestACL1',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod1);
        Active_Contract_Line_Item__c aclprod2= new Active_Contract_Line_Item__c(name='TestACL2',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today()+12 ,Raw_Maintenance_LC__c=10023,Renewal_Valuation_Type__c='Invalid-EOL-No Replacement Product');
        acllist.add(aclprod2);     
        Active_Contract_Line_Item__c aclprod3= new Active_Contract_Line_Item__c(name='TestAC2L1',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod3);
        Active_Contract_Line_Item__c aclprod4= new Active_Contract_Line_Item__c(name='TestACL32',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today()+24 ,Raw_Maintenance_LC__c=10023);
        acllist.add(aclprod4);     
        insert acllist;
        
        
        
    }
    

    
}