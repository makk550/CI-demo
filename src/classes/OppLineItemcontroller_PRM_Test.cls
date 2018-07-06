/*
* Edited By      : Samhitha Tummanapalli
* Description    : Test Class for OppLineItemcontroller_PRM
* 
* Test Class      : OppLineItemcontroller_PRM_Test
* Coverage - 48%
* Updated ON      : Nov 3 2017 
*/
@isTest
public class OppLineItemcontroller_PRM_Test{
    
    static testMethod void testNewProductMethods(){
        insertCustomSettingData();
        Test.Starttest();

         Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
        User pUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        insert pUser;

         
        System.runAs(pUser){
            SystemIdUtility.skipOpportunityTriggers = true;
            SystemIdUtility.skipOpportunityLineItemTriggers  = true;
            SystemIdUtility.skipProductTriggers = true;
            
            ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
            ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();  //RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c; 
            String oppType = '1 Tier';
            String currencyIsoCode = 'USD';
            
            Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                               Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                               Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                               Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
            
            insert resellerAcct; 
            Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
            insert smbAcct; 
            
            System.debug('smbAcct:'+smbAcct.Id);
            RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
            // RecordType recopp = [select Id from Recordtype where  Name='Deal Registration'];
            
            Opportunity opp = new Opportunity();
            opp.Name = 'New Opportunity';
            if(oppType == '2 Tier') opp.What_is_your_Role__c = 'Reseller';
            opp.Did_the_deal_originate_from_a_campaign__c = 'Yes';
            opp.AccountId = smbAcct.Id;
            opp.Reseller__c= resellerAcct.Id;
            opp.Closedate = System.today();
            opp.StageName = Label.Opp_Stage_10_Percent;
            opp.CurrencyIsoCode = currencyIsoCode;
            opp.RecordTypeId = recopp.Id;
            opp.Type =  oppType;//'1 Tier';
             opp.Deal_Registration_status__c ='Sale Approved' ;
            //opp.RecordType.Name = 'Deal Registration';
            insert opp;          
         
            
            List<OpportunityLineItem> oppLtmList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);

               Test.Stoptest();
            ApexPages.currentPage().getParameters().put('oppid',opp.Id);
            ApexPages.currentPage().getParameters().put('producttype','Product');
            ApexPages.currentPage().getParameters().put('save_new','true');         
            
            ApexPages.currentPage().getParameters().put('deletedProduct','false');
            ApexPages.currentPage().getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId());//samtu01
            ApexPages.Standardcontroller stdcontroller = new ApexPages.Standardcontroller(new OpportunityLineItem());
            OppLineItemcontroller_PRM OppLineItemClass = new OppLineItemcontroller_PRM(stdcontroller);
            OppLineItemcontroller_PRM.productwrapper pw = new OppLineItemcontroller_PRM.productwrapper();
            OppLineItemClass.searchString = 'Agile';
            
            OppLineItemcontroller_PRM.findSearchResult('Agile',opp.Id);
            OppLineItemClass.lineCounter = 10;
            OppLineItemClass.productname = 'CA PPM';
            OppLineItemClass.lst_prd = new List<OppLineItemcontroller_PRM.productclass>();
            OppLineItemClass.selbu = new List<SelectOption>();
            OppLineItemClass.lst_ren = new List<OppLineItemcontroller_PRM.renewalclass>();
            OppLineItemClass.selfamily = new List<SelectOption>();
            OppLineItemClass.selbustype = new List<SelectOption>();
            OppLineItemClass.selprdcloudplatformuse = new List<SelectOption>();
            OppLineItemClass.selectedBU = 'Continuous Delivery';//samtu01
            OppLineItemcontroller_PRM.renewalclass objren = new OppLineItemcontroller_PRM.renewalclass();
            objren.oppli = new OpportunityLineItem();
            objren.strfamily = 'test data';
            objren.selrenbu = new List<SelectOption>();
            objren.strbu = 'test data';
            objren.strproduct = 'test data';
            objren.selproduct = new List<SelectOption>();
            objren.position = 10;
            objren.isFamilyDisabled = false;
            objren.isBUDisabled = false;
            objren.isPrdDisabled = false;
            OppLineItemClass.isPartner =true;
            //pageRef.getParameters().put('ent');
            OppLineItemClass.isRenewal = false;
            OppLineItemClass.isProduct = false;
            OppLineItemClass.fetchBUproduct();
            OppLineItemClass.fetchPG();
            OppLineItemClass.Searchproducts();
            OppLineItemClass.saveDeal();
            OppLineItemClass.saveAndReturn();
            OppLineItemClass.addProduct();
            OppLineItemClass.addProduct2();
            OppLineItemClass.addAndReturn();        
            OppLineItemClass.addAndStay();        
            OppLineItemClass.refreshSelectProducts();        
            OppLineItemClass.checkBeforeDelete();        
            OppLineItemClass.deleteProducts();
            OppLineItemClass.checkBeforeRefreshProductTable(); 
            OppLineItemClass.refreshProductTable(); 
            OppLineItemClass.checkBeforeSearchByProductGroup(); 
            OppLineItemClass.searchByProductGroup(); 
            OppLineItemClass.getproductgroup();                                         
            OppLineItemClass.SetBU();
            OppLineItemClass.checkbefore();
            OppLineItemClass.checkBeforeReturn();
            OppLineItemClass.checkBeforeSearch(); 
            OppLineItemClass.checkBeforeClear();
            OppLineItemClass.continueClear();
            OppLineItemClass.closePopup();
            OppLineItemClass.cancel();
            OppLineItemClass.getDealEligibleProgramList();   
            OppLineItemClass.populateIsoCodeConversionMap();
            OppLineItemClass.getPrdctGrpPrgrmRelation();
            OppLineItemClass.getProgRanks(oppLtmList);
            OppLineItemClass.getMaxRankAndHeader(oppLtmList);
            OppLineItemClass.setEligibleOrSeparateStatus(oppLtmList);
            OppLineItemClass.progForEachProdCall();
            OppLineItemClass.addProgForEachProd(oppLtmList,True);
            //OppLineItemClass.refreshopp();                        
            OppLineItemClass.getPrgNumberfromNameMap('testProgName');   
            OppLineItemClass.dealEligibleStatusChange();
            OppLineItemClass.saveproducts();
            // added by BAJPI01 to increase code coverage
            OppLineItemClass.pos = 0;
            OppLineItemClass.calculateUFLicenseFeeN();
            OppLineItemClass.fetchBU('Product');
            OppLineItemClass.fetchfamily();
            OppLineItemClass.calculateUFLicenseFee(oppLtmList[0]);
            PageReference pagerefer;
            pagerefer = OppLineItemClass.addmore_prds();
            system.assertEquals(null, pagerefer);
            pagerefer = OppLineItemClass.addmore_ren();
            system.assertEquals(null, pagerefer);
            pagerefer = OppLineItemClass.recalculate();
            system.assertEquals(null, pagerefer);
            //pagerefer = OppLineItemClass.redirectToDetailPage();
            //system.assertEquals(null, pagerefer);
             pagerefer = OppLineItemClass.resetIsOverrideChecked(); 
            system.assertEquals(null, pagerefer);
            OppLineItemClass.fetchproducts();
            OppLineItemClass.getMonthsBetween();//samtu01
            OppLineItemClass.calculateStretch();//samtu01
            OppLineItemClass.isxspDealaccount('test;test',opp.AccountId);//samtu01
            // OppLineItemClass.fetchrenewalbu();
            // added by BAJPI01 to increase code coverage
            //OppLineItemClass.redirectToDetailPage();   
           list<SelectOption> liclass = OppLineItemClass.LicenseClassification;
           list<SelectOption> licoverrides =OppLineItemClass.LicenseClassificationOverride;
            
            OppLineItemClass.refreshonc();
        }
        
        
        
    }
    
    public static testMethod void insertCustomSettingData(){
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
    }
    
    
    
}