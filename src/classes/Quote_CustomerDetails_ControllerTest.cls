@isTest
public class Quote_CustomerDetails_ControllerTest {
    public static testMethod void Quote_Customer(){
        PageReference ref = new PageReference('/apex/Quote_CustomerDetails_Page');
        Test.setCurrentPage(ref);
        testCreateQuoteAndQuoteLine.createTestData();
        Test.startTest();
         List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
            SBQQ__Quote__c quote =quoteList[0];
            ApexPages.currentPage().getParameters().put('Id', quote.Id);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(quote);
            Quote_CustomerDetails_Controller controller =new Quote_CustomerDetails_Controller(sc);
            controller.quote.SoldTo_BPID__c='19587';
            controller.quote.SoldTo_Name__c='WAL-MART STORES, INC.';
            controller.quote.SoldTo_Street__c='27 Bear Hollow Rd';
            controller.quote.SoldTo_Street2__c='';
            controller.quote.SoldTo_City__c='Pineville';
            controller.quote.SoldTo_State__c='MO';
            controller.quote.SoldTo_PostalCode__c='64856-8204';
            controller.quote.SoldTo_Country__c='US';
            controller.quote.SoldTo_Name_Intl__c='';
            controller.quote.SoldTo_Street_Intl__c='';
            controller.quote.SoldTo_Street2_Intl__c='';
            controller.quote.SoldTo_City_Intl__c='';
            controller.quote.SoldTo_State_Intl__c='';
            controller.copythedetails();
            controller.copyBillTo();
            controller.copyShipTo();
            controller.refreshaddress();
            controller.quote.TechnicalContact_ID__c='722589';
            controller.quote.TechnicalContact_FirstName__c='stesuser1';
            controller.quote.TechnicalContact_LastName__c='aaaaaaa';
            controller.quote.TechnicalContact_Email__c='saikumr@1587gmai.com';
            controller.quote.TechnicalContact_Phone__c='9825867994';
            controller.quote.TechnicalContact_IntlFName__c='';
            controller.quote.TechnicalContact_IntlLName__c='';
            controller.refreshaddress();
            controller.copyBillingcontacts();
            controller.copyShippingcontacts();
            controller.getSoldTofullAddress();
            controller.getBillTofullAddress();
            controller.getShipTofullAddress();
            controller.getTechnicalContactName();
            controller.getBillingContactName();
            controller.getShippingContactName();
            controller.save();
            

        }
        Test.stopTest();
    }
    @isTest static void AWStestCallout() {
        // Set mock callout class 
        PageReference ref = new PageReference('/apex/Quote_MDMSiteSearch');
        Test.setCurrentPage(ref);
        testCreateQuoteAndQuoteLine.createTestData();
        insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
        Test.startTest();
        List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            SBQQ__Quote__c quote =quoteList[0];
            ApexPages.currentPage().getParameters().put('Id', quote.Id);
            ApexPages.currentPage().getParameters().put('soldId','');
        	ApexPages.currentPage().getParameters().put('searchtype','SOLDTO');
        	ApexPages.currentPage().getParameters().put('accountId','NR48689');
       		ApexPages.currentPage().getParameters().put('OppCountryCode','US');
        	ApexPages.currentPage().getParameters().put('salesOrg','');
        	ApexPages.currentPage().getParameters().put('selectedcountry','');
            Quote_MDMSiteSearchController controller1 =new Quote_MDMSiteSearchController();
            Test.setMock(HttpCalloutMock.class, new Quote_CustomerSOLDMockHttpResponse());
            controller1.doDataload();
        	
        }
        Test.stopTest();
    }
    
     @isTest static void AWStestCallout2() {
        // Set mock callout class 
        PageReference ref = new PageReference('/apex/Quote_MDMSiteSearch');
        Test.setCurrentPage(ref);
        testCreateQuoteAndQuoteLine.createTestData();
        insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
        Test.startTest();
        List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            SBQQ__Quote__c quote =quoteList[0];
            ApexPages.currentPage().getParameters().put('soldId','39870');
        	ApexPages.currentPage().getParameters().put('searchtype','BILLTO');
        	ApexPages.currentPage().getParameters().put('accountId','NR48689');
       		ApexPages.currentPage().getParameters().put('OppCountryCode','US');
        	ApexPages.currentPage().getParameters().put('salesOrg','US01');
        	ApexPages.currentPage().getParameters().put('selectedcountry','US');
            Quote_MDMSiteSearchController controller1 =new Quote_MDMSiteSearchController();
            Test.setMock(HttpCalloutMock.class, new Quote_CustomerBPMockHttpResponse());
            controller1.doDataload();
           
        	
        }
        Test.stopTest();
    }
    @istest   //(seeAllData=true)
    public static void AzureTestCallout(){

         PageReference ref = new PageReference('/apex/Quote_MDMSiteSearch');
        Test.setCurrentPage(ref);
        //testCreateQuoteAndQuoteLine.createTestData();
          SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        testOpportunityTriggersClass.createNewOpportunity();
        Opportunity opp = [select id from Opportunity Limit 1];

          SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;


        
         SBQQ__Quote__c quoteinser = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.id,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft');
        
        insert quoteinser;
        

        //insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
        Test.startTest();
        //List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c Limit 1];
        if(quoteinser!=null){
            SBQQ__Quote__c quote =quoteinser;
            ApexPages.currentPage().getParameters().put('soldId','39870');
        	ApexPages.currentPage().getParameters().put('searchtype','BILLTO');
        	ApexPages.currentPage().getParameters().put('accountId','NR48689');
       		ApexPages.currentPage().getParameters().put('OppCountryCode','US');
        	ApexPages.currentPage().getParameters().put('salesOrg','US01');
        	ApexPages.currentPage().getParameters().put('selectedcountry','US');
            Quote_MDMSiteSearchController controller1 =new Quote_MDMSiteSearchController();
            Quote_MDMSiteSearchController.LeanCustomerClass leandata=new Quote_MDMSiteSearchController.LeanCustomerClass();
            Test.setMock(HttpCalloutMock.class, new Quote_AzureUtilityHttpMockResponse());
             leandata.PhoneNumber='8797656787';
             leandata.PostalCode='52001';
             leandata.Name1='Test Company';
             leandata.Street1='CA Road No 4 Gachibowli';
             leandata.RegionName='Telagana';
             leandata.City='Hyderabad';
             controller1.isPostalRequiredLean=true;
             controller1.postalCodeLength=5;
             controller1.LeanCustomerCountry='india';
             controller1.initLeanCustomerFields();
 
            
            //controller1.createcustomer();
            controller1.cancelCountry();
            controller1.createLeanCustomer();
            controller1.SelectCountry();
            controller1.getAccountGroup('SOLDTO');
            controller1.saveLeanCustomer();
           controller1.forceCreateLeanCustomer();
        	
        }
        Test.stopTest();
        
        
    }
    
    
    @isTest static void SAPtestCallout1() {
        // Set mock callout class 
        PageReference ref = new PageReference('/apex/Quote_TechnicalContactSearch');
        Test.setCurrentPage(ref);
        testCreateQuoteAndQuoteLine.createTestData();
        insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
        Test.startTest();
        List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            SBQQ__Quote__c quote =quoteList[0];
            ApexPages.currentPage().getParameters().put('soldId','39870');
        	ApexPages.currentPage().getParameters().put('searchtype','TECHNICAL');
        	ApexPages.currentPage().getParameters().put('SoldToCountry','US');
            Quote_TechnicalContactSearchController controller2 =new Quote_TechnicalContactSearchController();
            Test.setMock(HttpCalloutMock.class, new Quote_CustomerSAPReadMockHttpResponse());
            controller2.doDataload();
        	
        }
        Test.stopTest();
    }
    @isTest static void SAPtestCallout2() {
        // Set mock callout class 
        PageReference ref = new PageReference('/apex/Quote_TechnicalContactSearch');
        Test.setCurrentPage(ref);
        //testCreateQuoteAndQuoteLine.createTestData();
        insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
        Test.startTest();
            ApexPages.currentPage().getParameters().put('soldId','39870');
        	ApexPages.currentPage().getParameters().put('searchtype','TECHNICAL');
        	ApexPages.currentPage().getParameters().put('SoldToCountry','US');
            Quote_TechnicalContactSearchController controller2 =new Quote_TechnicalContactSearchController();
            Test.setMock(HttpCalloutMock.class, new Quote_CustomerSAPCreateMockHttpResponse());
            //controller2.doDataload();
            controller2.SAPUtilityObj =new SAP_ECC_Utility();
        	SAP_ECC_Utility.ContactItem Cobj= new SAP_ECC_Utility.ContactItem();
            controller2.getpartnerRoles();
            controller2.Createcontact();
            controller2.firstName='Saikumar';
            controller2.Createcontact();
            controller2.lastName='Amand';
            controller2.Createcontact();
            controller2.email='';
            controller2.Createcontact();
           System.debug('my debug 1');
        	controller2.email='amasa03@ca.com';
            controller2.Createcontact();
        	System.debug('my debug 2');
            controller2.phone='12345';
            controller2.partnerRole='TECHNICAL_CONTACT';
            controller2.title='';
        	controller2.SoldToID ='39870';
        	
            controller2.Createcontact();
        Test.stopTest();
    }
    @isTest static void serviceEX(){
        DOM.Document doc = new DOM.Document();
        dom.XmlNode products = doc.createRootElement('Code', null, null);
        dom.XmlNode body1= products.addChildElement('Code', null, null);
 
        body1.addChildElement('Name', null, null).addTextNode('Xbox One');
        body1.addChildElement('Code', null, null).addTextNode('XBO');
 		AWS.ServiceException obj=new AWS.ServiceException(body1);
        AWS_MDM_Utility AWSPbj=new AWS_MDM_Utility();
        AWSPbj.JPRegionConstants();
    }
    @isTest static void CustomerTriggerCoverage(){
       
        testCreateQuoteAndQuoteLine.createTestData();
        Test.startTest();
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        Site_Association__c site1 = new Site_Association__c();
        site1.Name = 'Test Site Association';
        site1.Street__c = '195 Broadway';
        site1.City__c = 'New York';
        site1.State__c = 'NY';
        site1.Postal_Code__c ='10008';
        site1.Country_Picklist__c= 'US - UNITED STATES';
        site1.Support_Region__c= 'NA';
        site1.SC_SITE_Preferred_Language__c = 'ENGLISH';
        site1.SAP_Site_ID__c = '1234';
        site1.ProviSite__c=0;
        
        insert site1;
        
        List<SBQQ__Quote__c> quoteList =[Select Id,SoldTo_BPID__c,ShipTo_BPID__c from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            SBQQ__Quote__c quote =quoteList[0];
            quote.SoldTo_BPID__c='1234';
            quote.ShipTo_BPID__c='1234';
            update quote;
        }
        Test.stopTest();
    }
}