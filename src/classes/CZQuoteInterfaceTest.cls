@isTest
public class CZQuoteInterfaceTest {
    private static final String TEST_OPPORTUNITY_TEMPLATE_NAME = 'Test_Opportunity_Template';
    private static final String TEST_QUOTE_TEMPLATE_NAME = 'Test_Quote_Template';

    public static void setupContractTestData() {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Physical_Street_Local__c = '123 Elm St';
        account.Physical_City_Local__c = 'Atlanta';
        account.Physical_Country_Local__c = 'USA';
        account.Physical_State_Prov_Local__c = 'GA';
        account.Physical_Zip_Local__c = '30308';
        account.Account_Status__c = 'Prospect';
        account.BillingStreet = '123 Elm St';
        account.BillingCity = 'Atlanta';
        account.BillingState = 'GA';
        account.Commercial_ID__c = '12345';
        
        insert account;
        
        Site_Association__c siteAssociation = new Site_Association__c();
        siteAssociation.Enterprise_Id__c = account.Id;
        siteAssociation.SAP_Site_ID__c = '12345';
        
        insert siteAssociation;

        Account account2 = new Account();
        account2.Name = 'Test Account';
        account2.Physical_Street_Local__c = '123 Elm St';
        account2.Physical_City_Local__c = 'Atlanta';
        account2.Physical_Country_Local__c = 'USA';
        account2.Physical_State_Prov_Local__c = 'GA';
        account2.Physical_Zip_Local__c = '30308';
        account2.Account_Status__c = 'Prospect';
        account2.BillingStreet = '123 Elm St';
        account2.BillingCity = 'Atlanta';
        account2.BillingState = 'GA';
        account2.Commercial_ID__c = '34567';
        
        insert account2;
        
        siteAssociation = new Site_Association__c();
        siteAssociation.Enterprise_Id__c = account2.Id;
        siteAssociation.SAP_Site_ID__c = '34567';
        
        insert siteAssociation;
        
        Contract contract = new Contract();
        
        contract.AccountId = account.Id;
        contract.SoldTo_BPID__c = '12345';
        contract.ShipTo_BPID__c = '12345';
        contract.StartDate = Date.parse('7/1/2018');
        contract.ContractTerm = 12;
        
        insert contract;

        contract = new Contract();
        
        contract.AccountId = account2.Id;
        contract.SoldTo_BPID__c = '34567';
        contract.ShipTo_BPID__c = '34567';
        contract.StartDate = Date.parse('2/1/2019');
        contract.ContractTerm = 12;
        
        insert contract;
    }
    
    public static void setupBatchTestData(Boolean useTemplates) {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Physical_Street_Local__c = '123 Elm St';
        account.Physical_City_Local__c = 'Atlanta';
        account.Physical_Country_Local__c = 'USA';
        account.Physical_State_Prov_Local__c = 'GA';
        account.Physical_Zip_Local__c = '30308';
        account.Account_Status__c = 'Prospect';
        account.BillingStreet = '123 Elm St';
        account.BillingCity = 'Atlanta';
        account.BillingState = 'GA';
        account.Commercial_ID__c = '12345';
        
        insert account;
        
        Site_Association__c siteAssociation = new Site_Association__c();
        siteAssociation.Enterprise_Id__c = account.Id;
        siteAssociation.SAP_Site_ID__c = '12345';
        
        insert siteAssociation;

        Account account2 = new Account();
        account2.Name = 'Test Account';
        account2.Physical_Street_Local__c = '123 Elm St';
        account2.Physical_City_Local__c = 'Atlanta';
        account2.Physical_Country_Local__c = 'USA';
        account2.Physical_State_Prov_Local__c = 'GA';
        account2.Physical_Zip_Local__c = '30308';
        account2.Account_Status__c = 'Prospect';
        account2.BillingStreet = '123 Elm St';
        account2.BillingCity = 'Atlanta';
        account2.BillingState = 'GA';
        account2.Commercial_ID__c = '34567';
        
        insert account2;
        
        siteAssociation = new Site_Association__c();
        siteAssociation.Enterprise_Id__c = account2.Id;
        siteAssociation.SAP_Site_ID__c = '34567';
        
        insert siteAssociation;
        
        Contract contract = new Contract();
        
        contract.AccountId = account.Id;
        contract.SoldTo_BPID__c = '12345';
        contract.ShipTo_BPID__c = '12345';
        contract.StartDate = Date.parse('7/1/2018');
        contract.ContractTerm = 12;
        
        insert contract;

        contract = new Contract();
        
        contract.AccountId = account2.Id;
        contract.SoldTo_BPID__c = '34567';
        contract.ShipTo_BPID__c = '34567';
        contract.StartDate = Date.parse('2/1/2019');
        contract.ContractTerm = 12;
        
        insert contract;
        
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;

        //insert a new product
        Product2 p1 = new Product2(name='Product A', productCode='A', Auth_Use_Mode__c=CZQuoteInterfaceConstants.DURATION_AUTH_USE_MODE);
        insert p1;
        
        Product2 p2 = new Product2(name='Product B', productCode='B', Auth_Use_Mode__c=CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE);
        insert p2;
        
        Product2 p2m = new Product2(name='Product B - maintenance');
        insert p2m;
        
        Product2 p3 = new Product2(name='Bundle');
        insert p3;
        
        Pricebook2 stdPb = new Pricebook2(isActive=true,currencyisocode='USD',Id=Test.getStandardPricebookId());
        update stdPb;
        
        System.debug('====>' + stdPb.CurrencyIsoCode);
        stdPb.CurrencyIsoCode = 'USD';
        update stdPb;
        
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = p1.id, unitprice=1000, isActive=true);
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = p2.id, unitprice=1000, isActive=true);
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = p2m.id, unitprice=1000, isActive=true);
        insert new PricebookEntry(pricebook2id = Test.getStandardPricebookId(), product2id = p3.id, unitprice=1000, isActive=true);
        
        SBQQ__ProductOption__c p1o = new SBQQ__ProductOption__c();
        p1o.SBQQ__Number__c = 1;
        p1o.SBQQ__OptionalSKU__c = p1.Id;   //option
        p1o.SBQQ__ConfiguredSKU__c = p3.Id; //bundle
        
        insert p1o;
            
        SBQQ__ProductOption__c p2o = new SBQQ__ProductOption__c();
        p2o.SBQQ__Number__c = 2;
        p2o.SBQQ__OptionalSKU__c = p2.Id;   //option
        p2o.SBQQ__ConfiguredSKU__c = p3.Id; //bundle
        
        insert p2o;
        
        SBQQ__ProductOption__c p2mo = new SBQQ__ProductOption__c();
        p2mo.SBQQ__Number__c = 1;
        p2mo.SBQQ__OptionalSKU__c = p2m.Id;
        p2mo.SBQQ__ConfiguredSKU__c = p2.Id;
        p2mo.SBQQ__Required__c = true;
        
        insert p2mo;
        
        if (useTemplates) {
            Opportunity templateOpp = new Opportunity();
            templateOpp.Name = 'Test Opportunity Template';
            templateOpp.StageName = '100% - Closed';
            templateOpp.CloseDate = System.today();
            templateOpp.Opportunity_Template__c = TEST_OPPORTUNITY_TEMPLATE_NAME;
            templateOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId();
            templateOpp.Probability = 100;
            templateOpp.SBQQ__Contracted__c = true;
            
            insert templateOpp;
            System.debug('====> template opp id ' + templateOpp.Id);
            
            SBQQ__Quote__c templateQuote = new SBQQ__Quote__c();
            templateQuote.SBQQ__Type__c='Quote';
            templateQuote.SBQQ__Status__c='Draft';
            templateQuote.SBQQ__Opportunity2__c = templateOpp.id;
            templateQuote.Quote_Template__c = TEST_QUOTE_TEMPLATE_NAME;
            templateQuote.SBQQ__BillingFrequency__c = 'Monthly';
            templateQuote.CurrencyIsoCode = 'USD';
            
            insert templateQuote;
            System.debug('====> template quote id ' + templateQuote.Id);
        }
        
        Input_Quote_Header__c header = new Input_Quote_Header__c();
        header.Name = 'Testing 1 2 3';
        header.Description__c = 'Testing description';
        header.Quote_Description__c = 'Testing description quote';
        header.Quote_Effective_Date__c = '7/5/2020';
        header.StartDate__c = '7/5/2020';
        header.Status__c = 10;
        
        if (useTemplates) {
            header.Opportunity_Template__c = TEST_OPPORTUNITY_TEMPLATE_NAME;
            header.Quote_Template__c = TEST_QUOTE_TEMPLATE_NAME;
        }

        header.CurrencyIsoCode__c = 'USD';
        header.Quote_Number__c = '001';
        header.CloseDate__c = '06/08/2020';
        header.BillingContact_Email__c = 'fred@rogers.net';
        header.BillingContact_FirstName__c = 'Fred';
        header.BillingContact_IntlFName__c = 'Freddy';
        header.BillingContact_IntlLName__c = 'Rogers';
        header.BillingContact_LastName__c = 'Rogers';
        header.BillingContact_Phone__c = '(666) 444-2345';
        header.BillTo_BPID__c = '12345';
        header.ShipTo_BPID__c = '12345';
        header.SoldTo_BPID__c = '12345';
        header.AccountId__c = account.Id;
        header.Subscription_Term__c = '12';
        header.TechnicalContact_Email__c = 'fred@rogers.net';
        header.TechnicalContact_FirstName__c = 'Fred';
        header.TechnicalContact_Intl_FName__c = 'Freddy';
        header.TechnicalContact_Intl_LName__c = 'Rogers';
        header.TechnicalContact_LastName__c = 'Rogers';
        header.TechnicalContact_Phone__c = '(666) 444-2345';        
        header.ShippingContact_Email__c = 'fred@rogers.net';
        header.ShippingContact_FirstName__c = 'Fred';
        header.ShippingContact_Intl_FName__c = 'Freddy';
        header.ShippingContact_Intl_LName__c = 'Rogers';
        header.ShippingContact_LastName__c = 'Rogers';
        header.ShippingContact_Phone__c = '(666) 444-2345';
        header.BILL_TO_Address_Lcl__c = '123 Elm St';
        header.BillTo_City__c = 'Atlanta';
        header.BillTo_City_Intl__c = 'Atlanta';
        header.BillTo_Country__c = 'US';
        header.BillTo_Name__c = 'Fred Rogers';
        header.BillTo_Name_Intl__c = 'Freddy Rogers';
        header.BillTo_PostalCode__c = '30308';
        header.BillTo_State__c = 'GA';
        header.BillTo_State_Intl__c = 'GA';
        header.BillTo_Street__c = '123 Elm St';
        header.BillTo_Street_Intl__c = '123 Elm St';
        header.BillTo_Street2__c = '123 Elm St';
        header.BillTo_Street2_Intl__c = '123 Elm St';
        header.ShipTo_Address_Lcl__c = '123 Elm St';
        header.ShipTo_City__c = 'Atlanta';
        header.ShipTo_City_Intl__c = 'Atlanta';
        header.ShipTo_Country__c = 'US';
        header.ShipTo_Name__c = 'Fred Rogers';
        header.ShipTo_Name_Intl__c = 'Freddy Rogers';
        header.ShipTo_PostalCode__c = '30308';
        header.ShipTo_State__c = 'GA';
        header.ShipTo_State_Intl__c = 'GA';
        header.ShipTo_Street__c = '123 Elm St';
        header.ShipTo_Street_Intl__c = '123 Elm St';
        header.ShipTo_Street2__c = '123 Elm St';
        header.ShipTo_Street2_Intl__c = '123 Elm St';
        header.SoldTo_Address_Lcl__c = '123 Elm St';
        header.SoldTo_City__c = 'Atlanta';
        header.SoldTo_City_Intl__c = 'Atlanta';
        header.SoldTo_Country__c = 'US';
        header.SoldTo_Name__c = 'Fred Rogers';
        header.SoldTo_Name_Intl__c = 'Freddy Rogers';
        header.SoldTo_PostalCode__c = '30308';
        header.SoldTo_State__c = 'GA';
        header.SoldTo_State_Intl__c = 'GA';
        header.SoldTo_Street__c = '123 Elm St';
        header.SoldTo_Street_Intl__c = '123 Elm St';
        header.SoldTo_Street2__c = '123 Elm St';
        header.SoldTo_Street2_Intl__c = '123 Elm St';
        header.Reseller_City__c = 'Atlanta';
        header.Reseller_City_Intl__c = 'Atlanta';
        header.Reseller_Country__c = 'US';
        header.Reseller_Name__c = 'Fred Rogers';
        header.Reseller_Name_Intl__c = 'Freddy Rogers';
        header.Reseller_PostalCode__c = '30308';
        header.Reseller_State__c = 'GA';
        header.Reseller_State_Intl__c = 'GA';
        header.Reseller_Street__c = '123 Elm St';
        header.Reseller_Street_Intl__c = '123 Elm St';
        header.Reseller_Street2__c = '123 Elm St';
        header.Reseller_Street2_Intl__c = '123 Elm St';
        header.EndUser_City__c = 'Atlanta';
        header.EndUser_City_Intl__c = 'Atlanta';
        header.EndUser_Country__c = 'US';
        header.EndUser_Name__c = 'Fred Rogers';
        header.EndUser_Name_Intl__c = 'Freddy Rogers';
        header.EndUser_PostalCode__c = '30308';
        header.EndUser_State__c = 'GA';
        header.EndUser_State_Intl__c = 'GA';
        header.EndUser_Street__c = '123 Elm St';
        header.EndUser_Street_Intl__c = '123 Elm St';
        header.EndUser_Street2__c = '123 Elm St';
        header.EndUser_Street2_Intl__c = '123 Elm St';
        header.EndUserContact_Email__c = 'fred@rogers.net';
        header.EndUserContact_FirstName__c = 'Fred';
        header.EndUserContact_IntlFName__c = 'Freddy';
        header.EndUserContact_IntlLName__c = 'Rogers';
        header.EndUserContact_LastName__c = 'Rogers';
        header.EndUserContact_Phone__c = '(666) 444-2345';

        header.BillingContact_ID__c = '12345';
        header.ShippingContact_ID__c = '12345';
        header.TechnicalContact_ID__c = '12345';
        header.EndUserContact_ID__c = '12345';
        
        insert header;
        
        Input_Quote_Line__c line1 = new Input_Quote_Line__c();

        line1.Status__c = 10;
        line1.Quote_Number__c = '001';
        line1.ProductCode__c = 'A';
        line1.Auth_Use_Mode__c = 'D';
        line1.Quote_Line_Number__c = '1';
        line1.Discount__c = '10';
        line1.Quantity__c = '1';
        line1.Business_Type__c = 'New';
        line1.Product_Instance_Id__c = '123442';
        
        insert line1;

        Input_Quote_Line__c line2 = new Input_Quote_Line__c();

        line2.Status__c = 10;
        line2.Quote_Number__c = '001';
        line2.ProductCode__c = 'B';
        line2.Auth_Use_Mode__c = 'I';
        line2.Quote_Line_Number__c = '1';
        line2.Discount__c = '10';
        line2.Quantity__c = '1';
        line2.Business_Type__c = 'New';
        line2.Product_Instance_Id__c = '123442';
        
        insert line2;
    }
    
    public static void setupAccountLookupTestData() {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        //Label.TriggerByPass
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Physical_Street_Local__c = '123 Elm St';
        account.Physical_City_Local__c = 'Atlanta';
        account.Physical_Country_Local__c = 'USA';
        account.Physical_State_Prov_Local__c = 'GA';
        account.Physical_Zip_Local__c = '30308';
        account.Account_Status__c = 'Prospect';
        account.BillingStreet = '123 Elm St';
        account.BillingCity = 'Atlanta';
        account.BillingState = 'GA';
        account.Commercial_ID__c = '12345';
        
        insert account;
        
        Site_Association__c siteAssociation = new Site_Association__c();
        siteAssociation.Enterprise_Id__c = account.Id;
        siteAssociation.SAP_Site_ID__c = '12345';
        
        insert siteAssociation;
    }
    
    public static void setupContactLookupTestData() {
        Contact c1 = new Contact();
        c1.Email = 'fred@rogers.net';
        c1.FirstName = 'Fred';
        c1.LastName = 'Rogers';
        c1.Phone = '5551112222';
        
        insert c1;
    }

    public static testMethod void testAccountLookup() {
        setupAccountLookupTestData();

        Map<String,String> siteIds = new Map<String,String>();
        siteIds.put('12345', '12345');
        siteIds.put('44444', '44444');
        
        Map<String,Site_Association__c> siteAssociationMap = CZQILookupHelper.lookupSiteAssociations(siteIds.keySet());
        System.assert(siteAssociationMap.get('12345') != null, 'The site association \'12345\' was not found and should exist.');
        System.assert(siteAssociationMap.get('44444') == null, 'The site association \'44444\' was found and should not exist.');        
    }
    
    public static testMethod void testContractLookup() {
        setupContractTestData();

        List<CZQILookupHelper.ContractCriteria> critList = new List<CZQILookupHelper.ContractCriteria>();
        
        CZQILookupHelper.ContractCriteria crit = new CZQILookupHelper.ContractCriteria();
        crit.endDate = Date.parse('6/30/2019');
        crit.soldToSiteId = '12345';
        crit.shipToSiteId = '12345';
        critList.add(crit);

        CZQILookupHelper.ContractCriteria crit2 = new CZQILookupHelper.ContractCriteria();
        crit2.endDate = Date.parse('1/31/2020');
        crit2.soldToSiteId = '34567';
        crit2.shipToSiteId = '34567';
        critList.add(crit2);
        
        CZQILookupHelper.ContractCriteria crit3 = new CZQILookupHelper.ContractCriteria();
        crit3.endDate = Date.parse('8/31/2019');
        crit3.soldToSiteId = '55555';
        crit3.shipToSiteId = '55555';
        critList.add(crit3);
        
        Test.startTest();
        Map<String,Contract> contractMap = CZQILookupHelper.lookupMasterContracts(critList);

        System.assert(contractMap.get(crit.getKey()) != null);
        System.assert(contractMap.get(crit2.getKey()) != null);
        System.assert(contractMap.get(crit3.getKey()) == null);
        
        Test.stopTest();
    }

    public static testMethod void testBatch() {
        setupBatchTestData(true);
        
        Test.startTest();
        
        CZQuoteInterfaceBatch b = new CZQuoteInterfaceBatch();
        ID batchprocessid = Database.executeBatch(b);
        
        System.debug('Returned batch process ID: ' + batchProcessId);
        
        Test.stopTest();
        
        List<Input_Quote_Header__c> errors = [Select Error_Reason__c from Input_Quote_Header__c where Status__c = 99];
        
        for (Input_Quote_Header__c header : errors) {
            System.debug('Error Reason: ' + header.Error_Reason__c);
        }

        System.assert(errors.size() == 0, 'Quote Interface batch executed with errors 1.');
        
        List<Input_Quote_Header__c> headers = [SELECT Id, Status__c from Input_Quote_Header__c];
        
        for (Input_Quote_Header__c header : headers) {
            header.Status__c = 12;
        }
        
        update headers;
    }
    
    public static testMethod void testBatch2() {
        setupBatchTestData(false);
        
        Test.startTest();
        
        CZQuoteInterfaceBatch b = new CZQuoteInterfaceBatch();
        ID batchprocessid = Database.executeBatch(b);
        
        System.debug('Returned batch process ID: ' + batchProcessId);
        
        Test.stopTest();
        
        List<Input_Quote_Header__c> errors = [Select Error_Reason__c from Input_Quote_Header__c where Status__c = 99];
        
        for (Input_Quote_Header__c header : errors) {
            System.debug('Error Reason: ' + header.Error_Reason__c);
        }

        System.assert(errors.size() == 0, 'Quote Interface batch executed with errors 2.');
        
        List<Input_Quote_Header__c> headers = [SELECT Id, Status__c from Input_Quote_Header__c];
        
        for (Input_Quote_Header__c header : headers) {
            header.Status__c = 12;
        }
        
        update headers;
    }
    
    public static testMethod void testBatch3() {
        setupBatchTestData(false);
        
        Test.startTest();
        
        CZQuoteInterfaceBatch b = new CZQuoteInterfaceBatch();
        ID batchProcessId = Database.executeBatch(b);
        
        System.debug('Returned batch process ID: ' + batchProcessId);
        
        Test.stopTest();
        
        List<Input_Quote_Header__c> errors = [Select Error_Reason__c from Input_Quote_Header__c where Status__c = 99];
        
        for (Input_Quote_Header__c header : errors) {
            System.debug('Error Reason: ' + header.Error_Reason__c);
        }

        System.assert(errors.size() == 0, 'Quote Interface batch executed with errors.');
        
        List<Input_Quote_Header__c> headers = [SELECT Id, Status__c from Input_Quote_Header__c];
        
        for (Input_Quote_Header__c header : headers) {
            header.Status__c = 12;
        }
        
        update headers;

        CZQuoteFinisherBatch b2 = new CZQuoteFinisherBatch();
        ID batchProcessId2 = Database.executeBatch(b2);
        
        System.debug('Returned batch process ID: ' + batchProcessId2);
        
        List<Input_Quote_Header__c> errors2 = [Select Error_Reason__c from Input_Quote_Header__c where Status__c = 99];
        
        for (Input_Quote_Header__c header : errors2) {
            System.debug('Error Reason: ' + header.Error_Reason__c);
        }

        System.assert(errors2.size() == 0, 'Quote Finisher batch executed with errors.');
        
    }
    
    public static testMethod void testMisc() {
        CZQuoteInterfaceUtility.setFailure('Test', new Input_Quote_Line__c());
        CZQuoteInterfaceUtility.setFailure('Test', new Input_Quote_Header__c());
        CZQuoteInterfaceUtility.setFailure('Test', (List<Input_Quote_Line__c>)null);
        CZQuoteInterfaceUtility.setFailure('Test', (List<Input_Quote_Header__c>)null);
        CZQuoteInterfaceUtility.setFailure('Test', new List<Input_Quote_Line__c>{new Input_Quote_Line__c()});
        CZQuoteInterfaceUtility.setFailure('Test', new List<Input_Quote_Header__c>{new Input_Quote_Header__c()});
    }
}