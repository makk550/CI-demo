@istest (SeeAllData=true) 
private class Test_DE_AccSearch_CLS{

    static testMethod void unitTestAccSearch()
    {
        PageReference pageRef = Page.DE_AccSearch_VFP;
        //ApexPages.setCurrentPage(pageRef);
        Test.startTest();
       // Test_CreateOpportunity.insertRecordtypes();
       // Test_SetupData.createTestData();
       //  lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
       //     RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFZ', Name='CA Indirect Lead');
       //     lstrec.add(rec1);
       // insert lstrec;
        Account testAccnew = new Account(Name='Test Account',
        RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
       
       
        testAccnew.BillingState = 'NY';   
        testAccnew.Customer_Category__c = 'Enterprise';   
        testAccnew.GEO__c='NA';
        testAccnew.Enterprise_ID__c = '1234te';       
        testAccnew.Enterprise_Account_Name__c = 'rdName';
        testAccnew.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        testAccnew.Commercial_ID__c = 'asdf';
        insert testAccnew; 

        
       Lead l = new Lead();
       l.FirstName = 'test lead';
       l.LastName = 'test lead';
       l.Status = 'Pursuing';
       l.Meeting_Rating__c = 'N/A';
       l.Company = 'CA';
       l.Country_Picklist__c = 'SA - Saudi Arabia';
       l.City = 'Dammam';
       l.State = 'Eastern';
       l.Street = 'street 2312';
       
       l.RecordTypeId= Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
       insert l;

       Site_Association__c newSite = new Site_Association__c(Enterprise_ID__c = testAccnew.Id, Site_Status__c = 'Approved', SAP_Site_ID__c = '999999' , System__c = 'S',Street__c = 'Street', 
            Country_Picklist__c = 'US - United States', State__c = 'FL - Florida', Postal_Code__c = '45623',City__c = 'City',  
            Region__c = 'APJ' ,DUNS_Number__c = '656818705',DUNS_Name__c = 'ABACUS DISTRIBUTION SYSTEMS LTD.',Area__c = 'HONG KONG/TAIWAN',
            Territory_Country__c = 'TAIWAN',GP_DUNS_NUMBER__c = '675708655',GP_NAME__c = 'ABACUS DISTRIBUTION SYSTEMS TAIWAN LTD');
       insert newsite;
       
       
       ID hdnAccountID = testAccnew.id;
       String hdnAccountName = testAccnew.name;
       ID leadid = l.id;
       
        ApexPages.currentPage().getParameters().put('namefield', 'thePage:theForm:theBlock:'+hdnAccountName);
        ApexPages.currentPage().getParameters().put('idfield', 'thePage:theForm:theBlock:'+hdnAccountID);
        ApexPages.currentPage().getParameters().put('lid', leadid);
        ApexPages.currentPage().getParameters().put('sid', newsite.Id);
        
        DE_AccSearch_CLS srchController = new DE_AccSearch_CLS();
        
        srchController.gotoPrevAccSrch();
        srchController.gotoPrevScreen();
        srchController.loadheader();
        srchController.getCountries();
        srchController.getStateRegionsForCANADA();
        srchController.getStateRegionsFor_US();
        srchController.getStateRegionsForAustralia();
        srchController.getStateRegionsForINDIA();
    srchController.pagered = 'StandNew';
        srchController.accountName = 'Test 123';
        srchController.physicalCountry  = 'US - United States';
        srchController.physicalState = 'Florida';
        srchController.physicalStateUS = 'Florida';
        srchController.isTaqProcess = false;
     
        srchController.selAccId1 = testAccnew.Id;
        srchController.selAccId = '132665238';
       srchController.resultset1 = new List<DE_AccResWithDuns_CLS>();
           srchController.resultset2 = new List<DE_AccResWithDuns_CLS>();
        srchController.selectedSize='5';
        srchController.pageNo=2;
        srchController.SearchAcc();
        srchController.SearchNext();
        srchController.getRecordssize();
        srchController.selectAccId();
        srchController.selectAccDuns();
     
        srchController.First1();
       // srchController.First2();
        srchController.Last1();
        srchController.Last2();
        srchController.displayresults1();
       srchController.selectedSFDCId='';
         srchController.nextPage();
        srchController.physicalStateIndia='Telangana';
        srchController.Next2();
        srchController.Previous2();
        srchController.getTotalrecords();
        srchController.getrecentlyAccounts();
        srchController.gotoPrevRes2();
        srchController.strErrMsg ='';
        srchController.physicalStateCA ='Mexico';
        srchController.physicalStateAU ='Sydney';
        srchController.pageOne =true;srchController.pageThree =false;
        srchController.pagetwo = false;
        srchController.pageFour =false;
       
        srchController.Next1();
        srchController.Next2();
        srchController.bindLocalSearchREsults();
        srchController.Previous1();
          srchController.accountName='';
        srchController.SearchAcc();
        srchController.physicalCountry='';
        srchController.SearchAcc();
      
        srchController.parentPage = 'Dealxsp';
        srchController.getrecentlyAccounts();
    
       // srchController.getSampleTestXML(true);
      //srchController.createTaqAccount();
        /*
        DE_AccResWithDuns_CLS testAcc = new DE_AccResWithDuns_CLS();
        testAcc.accName=srchController.accountName;      
        testAcc.street='lane 123';      
        testAcc.city ='scottsdale';      
        testAcc.state =srchController.physicalState;      
        testAcc.country =srchController.physicalCountry;      
        testAcc.zipCode='47512478';      
        testAcc.geo='NA';      
        testAcc.GPAccNo='122221';      
        testAcc.GPAccName='test';      
        testAcc.opparea='ANZ';      
        testAcc.salReg='RIO';      
        testAcc.GPSeg='Other';     
        testAcc.territory='BARBADOS';      
        testAcc.segment='Growth';      
        testAcc.coverMod='Territory'; 
        testAcc.accDunsNo='1232334';
        
        srchController.objacc = new DE_AccResWithDuns_CLS();
        srchController.objacc = testAcc;
        */
       Test.stopTest();  
        
        //srchController.createTaqAccount();
        
        
    }
}