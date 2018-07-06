/*
* Test Class For = accountSeatCountAggregateClass 
* Created by = BAJPI01
* Coverage = 95%
* 
*/

@isTest
public class accountSeatCountAggregateTestClass {
    
    public static testMethod void testErrorMessageNoAccountId(){
        PageReference tpageRef = Page.accountSeatCountAggregatePage;
        Test.setCurrentPage(tpageRef);
        
        accountSeatCountAggregateClass accSeatCountContrl = new accountSeatCountAggregateClass();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        
        Boolean pgMsg = false;
        
        for(Apexpages.Message msg:pageMessages){
            if (msg.getDetail().contains('You do not have access to this account.'))
                pgMsg = true;
        }
        system.assert(pgMsg);
        
        testCreateQuoteAndQuoteLine.createTestData();
        Account a = [select id from account limit 1];
        system.assertNotEquals(null, a.id, 'Account not found');
        ApexPages.currentPage().getParameters().put('accId', a.id);
        accSeatCountContrl = new accountSeatCountAggregateClass();
        ApexPages.Message[] pageMsgs_noAccError = ApexPages.getMessages();
        System.assertNotEquals(0, pageMsgs_noAccError.size());
        
        Boolean noSubPgMsg = false;
        Boolean noAssetPgMsg = false;
        for(Apexpages.Message msg:pageMsgs_noAccError){
            system.debug('-------errror message----'+msg.getDetail());
            if (msg.getDetail().contains('No Subscriptions exists for the given account.'))
                noSubPgMsg = true;
            if (msg.getDetail().contains('No Asset exists for the given account.'))
                noAssetPgMsg = true;
        }
        system.assert(noSubPgMsg);
        system.assert(noAssetPgMsg);
        
    }
    
    public static testMethod void testWithSubscriptionRec(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        testCreateQuoteAndQuoteLine.createTestData();
        test.startTest();
        Opportunity opp = [select id,StageName,ReasonField__c,Competitor__c,SBQQ__Contracted__c, AccountId from opportunity limit 1];
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c where SBQQ__Primary__c=true limit 1];
        Account acc = [select id,GU_Duns_Number__c from Account limit 1];
        SBQQ__QuoteLine__c qli = [select id,SBQQ__Quantity__c,Instance_Id__c from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quote.id limit 1];
        Product2 prod = [select id from Product2 limit 1];
        
        qli.instance_id__c = '1234';
        update qli;
        
        Contract c = new Contract(AccountId= acc.id,
                                  SBQQ__Quote__c = quote.id,
                                  SBQQ__Opportunity__c = opp.id,
                                  Bill_To_Address_Lcl__c = '',
                                  StartDate = system.today(),
                                  ContractTerm = 4
                                 );
        insert c;
        system.assertNotEquals(null, c.id, 'Contract not inserted');
        
        SBQQ__Subscription__c subsc = new SBQQ__Subscription__c(SBQQ__Account__c = acc.id,
                                                                SBQQ__Contract__c = c.id,
                                                                SBQQ__OriginalQuoteLine__c =qli.id,
                                                                SBQQ__RequiredByProduct__c = prod.id,
                                                                SBQQ__Product__c = prod.id,
                                                                SBQQ__Quantity__c = qli.SBQQ__Quantity__c,
                                                                SBQQ__QuoteLine__c = qli.id);
        
        insert subsc;
        system.assertNotEquals(null, subsc.id, 'Subscription not inserted');
         test.stopTest();
        PageReference tpageRef = Page.accountSeatCountAggregatePage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('accId', acc.id);
        accountSeatCountAggregateClass accSeatCountContrl = new accountSeatCountAggregateClass();
        system.assertNotEquals(0, accSeatCountContrl.productAggregateList.size());
        system.assertEquals(null, accSeatCountContrl.productAssetAggregateList);
        acc.GU_Duns_Number__c = '123456789';
        update acc;
       
        accSeatCountContrl = new accountSeatCountAggregateClass();
        system.assertNotEquals(0, accSeatCountContrl.productAggregateList.size());
        system.assertEquals(null, accSeatCountContrl.productAssetAggregateList);
    }
    
    
    public static testMethod void testWithAssetRec(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        testCreateQuoteAndQuoteLine.createTestData();
        Opportunity opp = [select id,StageName,ReasonField__c,Competitor__c,SBQQ__Contracted__c, AccountId from opportunity limit 1];
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c where SBQQ__Primary__c=true limit 1];
        Account acc = [select id,GU_Duns_Number__c from Account limit 1];
        SBQQ__QuoteLine__c qli = [select id,SBQQ__Quantity__c,instance_id__c from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quote.id limit 1];
        Product2 prod = [select id from Product2 limit 1];
        test.startTest();
        Contract c = new Contract(AccountId= acc.id,
                                  SBQQ__Quote__c = quote.id,
                                  SBQQ__Opportunity__c = opp.id,
                                  Bill_To_Address_Lcl__c = '',
                                  StartDate = system.today(),
                                  ContractTerm = 4
                                 );
        insert c;
        system.assertNotEquals(null, c.id, 'Contract not inserted');
        
        Asset assetRec = new Asset(AccountId = acc.id,
                                   SBQQ__RequiredByProduct__c = prod.id,
                                   Product2Id = prod.id,
                                   Quantity = qli.SBQQ__Quantity__c,
                                   SBQQ__QuoteLine__c = qli.id,
                                   Name = 'Test Asset');
        
        insert assetRec;
        system.assertNotEquals(null, assetRec.id, 'Asset not inserted');
        
        PageReference tpageRef = Page.accountSeatCountAggregatePage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('accId', acc.id);
        accountSeatCountAggregateClass accSeatCountContrl = new accountSeatCountAggregateClass();
        system.assertEquals(null, accSeatCountContrl.productAggregateList);
        system.assertNotEquals(0, accSeatCountContrl.productAssetAggregateList.size());
        acc.GU_Duns_Number__c = '123456789';
        update acc;
        test.stopTest();
        accSeatCountContrl = new accountSeatCountAggregateClass();
        system.assertEquals(null, accSeatCountContrl.productAggregateList);
        system.assertNotEquals(0, accSeatCountContrl.productAssetAggregateList.size());
    }
    
}