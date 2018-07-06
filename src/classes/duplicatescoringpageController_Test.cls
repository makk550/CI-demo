@isTest//(SeeAllData=true)
private class duplicatescoringpageController_Test{
    
    @isTest
    private static void duplicatescoringpageControllertest2()
    {
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Account a = new Account(Name='TestAccount',BillingState = 'NY',Customer_Category__c = 'Enterprise',GEO__c='NA',
                                Enterprise_ID__c = '1234te',Enterprise_Account_Name__c = 'rdName',RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId(),
                                Commercial_ID__c = 'asdf');
        insert a;
        List<PricebookEntry> priceBookEntryList = Test_CreateOpportunity.createPriceBookEntryList();  
        
        opportunity opp=Test_CreateOpportunity.createTestOpp('2 Tier');
        opp.Accountid=a.id;
        opp.Amount = 10;
        //opp.Type='xSP';
        update opp;
        
        OpportunityLineItem opl=new OpportunityLineItem();
        opl.OPPORTUNITYID = opp.Id;
        opl.QUANTITY = 1;
        opl.PRICEBOOKENTRYID = priceBookEntryList[0].Id;
        opl.UNITPRICE = 6000000;                               
        opl.BUSINESS_TYPE__C = 'Capacity';
        opl.Deal_Registration__c = 'Yes';
        insert opl;
        
        OpportunityLineItem opl1=new OpportunityLineItem();
        opl1.OPPORTUNITYID = opp.Id;
        opl1.QUANTITY = 1;
        opl1.PRICEBOOKENTRYID = priceBookEntryList[1].Id;
        opl1.UNITPRICE = 6000000;                               
        opl1.BUSINESS_TYPE__C = 'Capacity';
        opl1.Deal_Registration__c = 'Yes';
        insert opl1;
        
        opportunity opp1=Test_CreateOpportunity.createTestOpp('2 Tier');
        opp1.Accountid=a.id;
        opp1.Amount = 30;
        update opp1;
        OpportunityLineItem opl2=new OpportunityLineItem();
        opl2.OPPORTUNITYID = opp1.Id;
        opl2.QUANTITY = 1;
        opl2.PRICEBOOKENTRYID = priceBookEntryList[0].Id;
        opl2.UNITPRICE = 6000000;                               
        opl2.BUSINESS_TYPE__C = 'Capacity';
        opl2.Deal_Registration__c = 'Yes';
        insert opl2;
        
        opportunity opp2=Test_CreateOpportunity.createTestOpp('2 Tier');
        opp2.Accountid=a.id;
        opp2.Name=a.Name+'Opprtu';
        opp2.Amount = 10;
        update opp2;
        OpportunityLineItem opl3=new OpportunityLineItem();
        opl3.OPPORTUNITYID = opp1.Id;
        opl3.QUANTITY = 1;
        opl3.PRICEBOOKENTRYID = priceBookEntryList[0].Id;
        opl3.UNITPRICE = 6000000;                               
        opl3.BUSINESS_TYPE__C = 'Capacity';
        opl3.Deal_Registration__c = 'Yes';
        insert opl3;
        Test.StartTest();
        
        PageReference pageRef = Page.duplicatescoringpage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', opp.id);
        duplicatescoringpageController controller = new duplicatescoringpageController() ;
        controller.setSortDirection('DESC');
        controller.getSortDirection();
        controller.ViewData();
        
        Test.StopTest();
    }
}