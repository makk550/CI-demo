@isTest(SeeAllData=true)
private class QuoteTestsWithApprovals {
    
    static testMethod void QuoteExtControllerTest () {

        account testAccount  = new account(name = 'par');
        testAccount.customer_Category__c= 'MSP';
        testAccount.hq__c= true;
        testAccount.Commercial_Account_Name__c='test 11111111'  ;
        testAccount.Commercial_ID__c= 'test 11111112';
        testAccount.Country_Picklist__c= 'CA - CANADA';
        testAccount.GEO__c= 'PS/CAN';
        testAccount.Sales_Area__c= 'CANADA';
        testAccount.Sales_Region__c= 'PS_CANADA';
        testAccount.Region_Country__c= 'PS_CAN_WEST-CTL';
        testAccount.Billingstate= 'A';
        testAccount.Billingcity= 'B';
        testAccount.Billingstreet= 'C';   
    
        insert testAccount;                
        
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity123', Accountid = testAccount.id,
            CloseDate = Date.parse('12/31/2020'), Stagename = 'Prospecting');
        insert testOpportunity;
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Type__c='Quote', SBQQ__Status__c='Draft',
            SBQQ__Opportunity2__c = testOpportunity.id, SBQQ__Account__c = testAccount.id);
        insert testQuote;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuote);
        QuoteExtController cntrllr = new QuoteExtController(sc);
        
        //PageReference submitPg = cntrllr.onSubmit();
        //PageReference recallPg = cntrllr.onRecall();
        //PageReference previewPg = cntrllr.onPreview();
    }
    
    static testMethod void QuoteStatusTestRejected () {
        account testAccount  = new account(name = 'par');
        testAccount.customer_Category__c= 'MSP';
        testAccount.hq__c= true;
        testAccount.Commercial_Account_Name__c='test 11111111'  ;
        testAccount.Commercial_ID__c= 'test 11111112';
        testAccount.Country_Picklist__c= 'CA - CANADA';
        testAccount.GEO__c= 'PS/CAN';
        testAccount.Sales_Area__c= 'CANADA';
        testAccount.Sales_Region__c= 'PS_CANADA';
        testAccount.Region_Country__c= 'PS_CAN_WEST-CTL';
        testAccount.Billingstate= 'A';
        testAccount.Billingcity= 'B';
        testAccount.Billingstreet= 'C';   
    
        insert testAccount; 
        
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity123', Accountid = testAccount.id,
            CloseDate = Date.parse('12/31/2020'), Stagename = 'Prospecting');
        insert testOpportunity;
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Type__c='Quote', SBQQ__Status__c='Draft',
            SBQQ__Opportunity2__c = testOpportunity.id, SBQQ__Account__c = testAccount.id);
        insert testQuote;
        
        Test.startTest();
        
        testQuote.ApprovalStatus__c = 'Pending';
        update testQuote;      
        
        testQuote.ApprovalStatus__c = 'Rejected';
        update testQuote; 
        
        Test.stopTest();
    }
    
    static testMethod void QuoteStatusTestApproved () {
        account testAccount  = new account(name = 'par');
        testAccount.customer_Category__c= 'MSP';
        testAccount.hq__c= true;
        testAccount.Commercial_Account_Name__c='test 11111111'  ;
        testAccount.Commercial_ID__c= 'test 11111112';
        testAccount.Country_Picklist__c= 'CA - CANADA';
        testAccount.GEO__c= 'PS/CAN';
        testAccount.Sales_Area__c= 'CANADA';
        testAccount.Sales_Region__c= 'PS_CANADA';
        testAccount.Region_Country__c= 'PS_CAN_WEST-CTL';
        testAccount.Billingstate= 'A';
        testAccount.Billingcity= 'B';
        testAccount.Billingstreet= 'C';   
    
        insert testAccount; 
        
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity123', Accountid = testAccount.id,
            CloseDate = Date.parse('12/31/2020'), Stagename = 'Prospecting');
        insert testOpportunity;
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Type__c='Quote', SBQQ__Status__c='Draft',
            SBQQ__Opportunity2__c = testOpportunity.id, SBQQ__Account__c = testAccount.id);
        insert testQuote;
        
        Test.startTest();
        
        testQuote.ApprovalStatus__c = 'Pending';
        update testQuote;      
        
        testQuote.ApprovalStatus__c = 'Approved';
        update testQuote; 
        
        Test.stopTest();
    }
    
    static testMethod void QuoteStatusTestValidated () {
        account testAccount  = new account(name = 'par');
        testAccount.customer_Category__c= 'MSP';
        testAccount.hq__c= true;
        testAccount.Commercial_Account_Name__c='test 11111111'  ;
        testAccount.Commercial_ID__c= 'test 11111112';
        testAccount.Country_Picklist__c= 'CA - CANADA';
        testAccount.GEO__c= 'PS/CAN';
        testAccount.Sales_Area__c= 'CANADA';
        testAccount.Sales_Region__c= 'PS_CANADA';
        testAccount.Region_Country__c= 'PS_CAN_WEST-CTL';
        testAccount.Billingstate= 'A';
        testAccount.Billingcity= 'B';
        testAccount.Billingstreet= 'C';   
    
        insert testAccount; 
        
        Opportunity testOpportunity = new Opportunity(Name='Test Opportunity123', Accountid = testAccount.id,
            CloseDate = Date.parse('12/31/2020'), Stagename = 'Prospecting');
        insert testOpportunity;
        
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(SBQQ__Type__c='Quote', SBQQ__Status__c='Draft',
            SBQQ__Opportunity2__c = testOpportunity.id, SBQQ__Account__c = testAccount.id);
        insert testQuote;
        
        Test.startTest();
        
        testQuote.SBQQ__Status__c = 'Quote Validated';
        testQuote.Quote_Effective_Date__c  = date.today();
        testQuote.Sales_Attestation_Agreement__c = true;
        testQuote.SoldTo_BPID__c = '0';
        testQuote.ShipTo_BPID__c = '0';
        testQuote.BillTo_BPID__c = '0';
        testQuote.TechnicalContact_ID__c = '0';
        testQuote.ShippingContact_ID__c ='0';
        testQuote.BillingContact_ID__c ='0';
        testQuote.TechnicalContact_Email__c='abc@xyz.com';
        //testQuote.SBQQ__NetAmount__c = 2000;
        update testQuote;      
        
        Product2 product = [select id from Product2 where isActive = true Limit 1];
        
        SBQQ__QuoteLine__c  testLineQuote = new SBQQ__QuoteLine__c(SBQQ__Product__c = product.id, SBQQ__Quote__c = testQuote.id);
        testLineQuote.SBQQ__Quantity__c = 100;
        testLineQuote.SBQQ__ListPrice__c = 200.00;
        testLineQuote.SBQQ__NetPrice__c  = 200.00;
        testLineQuote.CurrencyIsoCode = 'EUR';
        insert testLineQuote;
        
        Payment_Plan__c pp = new Payment_Plan__c(Quote__c=testQuote.Id, Date__c=date.today());
        pp.CurrencyIsoCode = 'EUR';
        insert pp;
        
        Payment_Plan__c pp2 = new Payment_Plan__c(Quote__c=testQuote.Id, Date__c=date.today());
        pp2.CurrencyIsoCode = 'JPY';
        insert pp2;
        testQuote.SBQQ__Status__c = 'Draft';
        update testQuote; 
        
        testQuote.Payment_Plan__c = 'Monthly';           
        testQuote.SBQQ__Status__c = 'Quote Validated';
        
        update testQuote;    
        
        testQuote.SBQQ__Status__c = 'Draft';
        update testQuote; 
        
        testQuote.Payment_Plan__c = 'Quarterly';           
        testQuote.SBQQ__Status__c = 'Quote Validated';
        update testQuote;
        
        testQuote.Payment_Plan__c = 'Custom';           
        testQuote.SBQQ__Status__c = 'Draft';
        update testQuote;
        
        List<Payment_Plan__c> pp3 = [select id, CurrencyIsoCode from Payment_Plan__c where Quote__c = :testQuote.Id limit 1];
        if(pp3.size() > 0){
             pp3[0].CurrencyIsoCode = 'EUR';
                update pp3;
        
        apexpages.currentpage().getparameters().put('qid' , testQuote.Id);
        QuotePaymentPlans cntrllr = new QuotePaymentPlans();
        }
       
        
        
        //PageReference submitPg = cntrllr.onSubmit();
        
        Test.stopTest();
    }
}