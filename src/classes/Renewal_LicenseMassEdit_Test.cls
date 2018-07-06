/***************************************************************************************************
* Test Class - Renewal_LicenseMassEdit_Test
* Created by SAMAP01
* Coverage - 80%
* ********************************************************************************************/
@isTest
private class Renewal_LicenseMassEdit_Test{
    static ID oppid; 
    
    static testMethod void test_Save_UseCase(){
        createdata();
        Test.startTest();      
        PageReference pageRef = Page.Renewal_LicenseMassEdit;
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardSetController con; 
        pageRef.getParameters().put('Id',oppid);
        Renewal_LicenseMassEdit ctrl = new Renewal_LicenseMassEdit();
        ctrl.setPages(5);
        ctrl.allchecked =true;
        Set<String> bt = new Set<String>{'Renewal'};
        ctrl.size=3;
        ctrl.noOfRecords =6;
        ctrl.Businesstype=bt;
        ctrl.cancel();
        ctrl.checkalllineitems();
        ctrl.getPageno();
        ctrl.getPages();
        ctrl.sortExpression ='Asc';
        ctrl.getSortDirection();
        ctrl.setSortDirection('Asc');
        ctrl.getPageSize();
        ctrl.setPageSize(15);
        ctrl.getOpplineitemList();
        ctrl.next();
        ctrl.previous();
        ctrl.check();
        list<SelectOption>  licenetypes =  ctrl.LicenseType;
        ctrl.oppId =oppid;
        ctrl.renderRenewalDetails =true;
        ctrl.Save();
        ctrl.selectedLicense ='Upfront';
        Test.stopTest();
        
        
    }
    
    static void createdata()
    {
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Test_CreateOpportunity.insertRecordtypes();
        
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        
        
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',  Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
        
        
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        Opportunity opp = new Opportunity(RecordTypeId=recopp.Id, Name = 'oppTestAddRenewal1' , StageName = 'test' , CloseDate = Date.today(), AccountId = smbAcct.Id, 
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
        oppid = opp.id;
        
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
        Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP1',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,Opportunity__c= opp.id);
        acplist.add(actvContPrd1);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,Opportunity__c= opp.id);
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
        acllist.add(aclprod4);     
        insert acllist;
        
        
        /*
List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
for(integer i=0;i<15;i++)
{
OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id,CA_Contract_Product_Name__c= 'TestCa'+i,unitprice= 100.0 );
OppItmList.add(oli);
i=i++;
}
insert OppItmList;
*/
        
        List<CA_Product_Renewal__c> caProdRnwl =new List<CA_Product_Renewal__c>();
        for(integer i=0;i<15;i++)
        {
            CA_Product_Renewal__c ca = new CA_Product_Renewal__c(Name ='TestCA'+i,Renewal_Opportunity__c = opp.Id,Quote__C ='testquote');
            caProdRnwl.add(ca);
            i=i++;
        }
        insert caProdRnwl;
        
        acplist = [select id,Opportunity__c,Converted_To_Opportunity__c from Active_Contract_Product__c where id=:actvContPrd1.id and Opportunity__c=: opp.id ];          
        acplist[0].Converted_To_Opportunity__c = true;
        update acplist;  
        
        List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
        for(Active_Contract_Line_Item__c acl :acllist  )
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id,
                                                              PricebookEntryId = pbe.Id,
                                                              CA_Contract_Product_Name__c= 'TestCa',
                                                              unitprice= 100.0,
                                                              Active_Contract_Line_Item__c =acl.id,
                                                              Active_Contract_Product__c=acl.Contract_Product__c,
                                                              Raw_Maintenance__c=acl.Raw_Maintenance_LC__c,
                                                              ATTRF__c=acl.Orig_ATTRF_LC__c,  
                                                              Baseline_ATTRF_LC__c = acl.Baseline_ATTRF_LC__c,   
                                                              Old_TRR__c=acl.AOCV__c,
                                                              Stretch__c=acl.Projected_Renewal_Value__c,
                                                              Business_Type__c = 'Renewal',    
                                                              License__c = acl.License_Type_Text__c, 
                                                              Segmentation__c = 'HT' ,
                                                              Original_Expiration_Date__c = acl.Dismantling_Date__c,
                                                              Original_Deal_Term_Months__c= acl.Install_Dismantle_Duration_months__c,
                                                              Start_Date__c = opp.Start_Date__c,
                                                              End_Date__c = opp.End_Date__c);
            OppItmList.add(oli);
            
        }
        insert OppItmList;
        
        
        
    }
}