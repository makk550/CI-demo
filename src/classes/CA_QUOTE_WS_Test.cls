@isTest(seealldata = true)
private class CA_QUOTE_WS_Test 
{

    static testMethod void validateDirectRegiThroughWS1()
    {
        // insert account
        Account acc = new Account(name='test account', RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        insert acc;
        
        // insert opp
        Opportunity opp = new Opportunity(name='test opp 1',accountId=acc.Id, CloseDate=Date.today()+1, StageName=Label.Opp_Stage_20_Percent);
        insert opp;
        scpq__SciQuote__c sq;
        List<scpq__SciQuote__c> theSQ;
        List<Quote_Product_Report__c> qpList = new List<Quote_Product_Report__c>();
        for(Integer i=0; i<2; i++)
        {
            qpList.add(new Quote_Product_Report__c(Quote_Product_Line_Item_Unique_Key__c = 'Test QP #' + i));            
        }
        
        List<PaymentPlan__c> ppList = new List<PaymentPlan__c>();
        for(Integer i=0; i<2; i++)
        {
            ppList.add(new PaymentPlan__c(Name='test pp#' + i));
        }
        //Create data for WS call
        sq = new scpq__SciQuote__c(scpq__OpportunityId__c=opp.Id, scpq__SciLastModifiedDate__c=DateTime.now(), scpq__OrderHeaderKey__c='test hk 1', CA_Quote_Type__c='Direct Registration');
        theSQ = [SELECT Id, (SELECT ID FROM Quote_Products_Reporting__r), (SELECT ID FROM Payment_Plan__r) FROM scpq__SciQuote__c WHERE Id=:sq.Id];
        
        Test.startTest();
        // Run insert test
      //  System.assertEquals('Success', CA_QUOTE_WS.upsertDirectRegiQuote(sq, qpList, ppList) );
        Test.stopTest();
        if(theSQ!=null && theSQ.size()>0)
        {
            System.assertEquals(2, theSQ[0].Quote_Products_Reporting__r.size());
            System.assertEquals(2, theSQ[0].Payment_Plan__r.size());
        }
    }
    static testMethod void validateDirectRegiThroughWS2()
    {
        // insert account
        Account acc = new Account(name='test account', RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        insert acc;
        
        // insert opp
        Opportunity opp = new Opportunity(name='test opp 1',accountId=acc.Id, CloseDate=Date.today()+1, StageName=Label.Opp_Stage_20_Percent);
        insert opp;scpq__SciQuote__c sq;
        scpq__SciQuote__c theSQ;
        List<Quote_Product_Report__c> qpList = new List<Quote_Product_Report__c>();
        for(Integer i=0; i<2; i++)
        {
            qpList.add(new Quote_Product_Report__c(Quote_Product_Line_Item_Unique_Key__c = 'Test QP #' + i));            
        }
        
        List<PaymentPlan__c> ppList = new List<PaymentPlan__c>();
        for(Integer i=0; i<2; i++)
        {
            ppList.add(new PaymentPlan__c(Name='test pp#' + i));
        }
        
        //run update test
        sq = new scpq__SciQuote__c(scpq__OpportunityId__c=opp.Id, scpq__SciLastModifiedDate__c=DateTime.now(), scpq__OrderHeaderKey__c='test hk 1', CA_SAP_Status__c = 'In Review');
        
        qpList.clear();
        for(Integer i=0; i<2; i++)
        {
            qpList.add(new Quote_Product_Report__c(Quote_Product_Line_Item_Unique_Key__c = 'Test QP #' + i));            
        }
        
        ppList.clear();
        for(Integer i=0; i<2; i++)
        {
            ppList.add(new PaymentPlan__c(Name='test pp#' + i));
        }
        
        Test.startTest();
        System.assertEquals('Success', CA_QUOTE_WS.upsertDirectRegiQuote(sq, qpList, ppList) );
        Test.stopTest();
        //System.assertEquals(2, [SELECT COUNT() FROM Education_Request__c WHERE CPQ_Quote__c = :theSQ.Id]);
    }
}