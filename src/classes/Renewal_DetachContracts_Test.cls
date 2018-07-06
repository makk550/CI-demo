/***************************************************************************************************
* Test Class - Renewal_DetachContracts_Test
* Apex class -Renewal_DetachContracts
* Created by SAMAP01
* Coverage - 62%
* ********************************************************************************************/
@isTest
public class Renewal_DetachContracts_Test {
    static ID oppid;  
    Static Opportunity opp;
    static testMethod void test_detach_UseCase()
    {
        createdata();
        Test.startTest();
        PageReference pageRef = Page.Renewal_DetachContracts;
        Test.setCurrentPage(pageRef);  
        pageRef.getParameters().put('Id',oppid);
        Renewal_DetachContracts ctrl = new Renewal_DetachContracts();
       
        string MainQuery = 'Select Instance_Id__c,a.Product__r.CSU2__c,Projected_Renewal_Calc__c, ATTRF_CRV__c,dismantle_date__c,'+
            'Opportunity__r.Opportunity_Number__c,Opportunity__r.Name,a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name,'+
            ' a.Product_Baseline_ATTRF_LC__c,a.Renewal_Product__c,a.Active_Contract__r.name,a.Name,a.Product__r.Name, a.Id,'+
            ' a.Converted_To_Opportunity__c, a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,'+
            'a.Active_Contract_Number__c,a.Sales_Price__c,a.Segmentation__c,a.Pre_Segmentation__c, '+
            'a.Active_Contract__r.Account__r.name,a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,'+
            'a.Renewal_Product__r.Projected_Renewal_LC__c,a.Renewal_Product__r.Projected_Time_Duration_Months__c,'+
            'a.Active_Contract__r.Contract_Term_Months__c,a.Raw_Maint_Calc_LC__c,a.Product__r.Family '+
            ' From Active_Contract_Product__c a ';
        
        ctrl.ActPdtlst = Database.query(MainQuery);
        ctrl.allchecked =true;

        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator(MainQuery));
        setCon.setSelected(ctrl.ActPdtlst);
        System.assertNotEquals(null,ctrl.setCon);
         
        for(integer i=0;i<ctrl.RenewalProductList.size();i++){
            ctrl.RenewalProductList.get(i).selected = true;
            
        } 
        
             
        ctrl.hasprimarycontact =true;
        // ctrl.hasprimarycontact=true;
        ctrl.allchecked =true;
        ctrl.getSelectedRenewalProductList();
        ctrl.applyFilter();
        ctrl.BuildQuery();
        ctrl.checkalllineitems();
        ctrl.refreshPageSize();
        ctrl.clearFilter();
        ctrl.detachProduct();
        ctrl.getSortDirection();
        ctrl.getSelectedRenewalProductList();
        ctrl.getRenewalProductList();
        ctrl.setSortDirection('ASC');
        ctrl.SortToggle();
        ctrl.hasprimarycontact =false;
        ctrl.detachProduct();
       
        Test.stopTest();
        
        
    }
    
    static void createdata()
    {
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        // Test_CreateOpportunity.insertRecordtypes();
        
        User u = Test_CreateOpportunity.createPartnerUser();
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',  Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
        
        Contact con = new Contact(LastName ='testCon',AccountId = smbAcct.Id,Email='test123@noemail.com');
        insert con; 
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        opp = new Opportunity(RecordTypeId=recopp.Id, Name = 'oppTestAddRenewal1' , StageName = 'test' , CloseDate = Date.today(), AccountId = smbAcct.Id, 
                                          Reseller__c= resellerAcct.Id, Reason_duration_is_1_year__c ='Renew',Status_at_end_of_term__c='aaa',
                                          currencyIsoCode='USD', Start_Date__c = Date.today(), End_Date__c = Date.today().addMonths(12));
        insert opp;
        
        OpportunityContactRole primaryrole = new OpportunityContactRole (ContactId=con.id,OpportunityId=opp.id,Role='Decision Maker',IsPrimary = true);
        insert primaryrole;                                       
        
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
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,Opportunity__c= opp.id);
        acplist.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod2.Id,Opportunity__c= opp.id);
        acplist.add(actvContPrd4);
        insert acplist;
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;       
        
        
        
        List<Active_Contract_Line_Item__c> acllist = new List<Active_Contract_Line_Item__c>(); 
               
        for(integer i=0;i<15;i++)
        {
                Active_Contract_Line_Item__c aclprod1= new Active_Contract_Line_Item__c(name='TestACL1',Contract_Product__c=actvContPrd1.Id,
                                                                                        Dismantling_Date__c=System.today() ,
                                                                                        Raw_Maintenance_LC__c=100 + 200*i);
      	  acllist.add(aclprod1);
            i=i++;
        }
        /*
        
        Active_Contract_Line_Item__c aclprod1= new Active_Contract_Line_Item__c(name='TestACL1',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod1);
        Active_Contract_Line_Item__c aclprod2= new Active_Contract_Line_Item__c(name='TestACL2',Contract_Product__c=actvContPrd1.Id,Dismantling_Date__c=System.today()+12 ,Raw_Maintenance_LC__c=10023);
        acllist.add(aclprod2);     
        Active_Contract_Line_Item__c aclprod3= new Active_Contract_Line_Item__c(name='TestAC2L1',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today() ,Raw_Maintenance_LC__c=100);
        acllist.add(aclprod3);
        Active_Contract_Line_Item__c aclprod4= new Active_Contract_Line_Item__c(name='TestACL32',Contract_Product__c=actvContPrd2.Id,Dismantling_Date__c=System.today()+24 ,Raw_Maintenance_LC__c=10023);
        acllist.add(aclprod4);  */   
        insert acllist;
        
        
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