/*
 * Test Class for- cz_GlobalSeatCountExtension
*/ 
@isTest
public class cz_GlobalSeatCountExtensionTest {

    
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
         
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New'); 
        quoteLineList.add(qli1);

         acc.GU_Duns_Number__c = '123456789';
        update acc;
        quoteLineList = cz_GlobalSeatCountExtension.getSeatCountForQuoteLines(quoteLineList);
        test.stopTest();
    }
    
     public static testMethod void testWithSubscriptionRecBlankDuns(){
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
         
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New'); 
        quoteLineList.add(qli1);
      
       quoteLineList = cz_GlobalSeatCountExtension.getSeatCountForQuoteLines(quoteLineList);

        test.stopTest();
    }

    
     public static testMethod void testWithAssetRec(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        testCreateQuoteAndQuoteLine.createTestData();
         test.startTest();
        Opportunity opp = [select id,StageName,ReasonField__c,Competitor__c,SBQQ__Contracted__c, AccountId from opportunity limit 1];
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c where SBQQ__Primary__c=true limit 1];
        Account acc = [select id,GU_Duns_Number__c from Account limit 1];
        SBQQ__QuoteLine__c qli = [select id,SBQQ__Quantity__c,instance_id__c from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quote.id limit 1];
        Product2 prod = [select id from Product2 limit 1];
        
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
         
         List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New'); 
        quoteLineList.add(qli1);
       
         acc.GU_Duns_Number__c = '123456789';
        update acc;
        quoteLineList = cz_GlobalSeatCountExtension.getSeatCountForQuoteLines(quoteLineList);
         test.stopTest();
     }
    
    
     public static testMethod void testWithAssetRecBlankDuns(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        testCreateQuoteAndQuoteLine.createTestData();
         test.startTest();
        Opportunity opp = [select id,StageName,ReasonField__c,Competitor__c,SBQQ__Contracted__c, AccountId from opportunity limit 1];
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c where SBQQ__Primary__c=true limit 1];
        Account acc = [select id,GU_Duns_Number__c from Account limit 1];
        SBQQ__QuoteLine__c qli = [select id,SBQQ__Quantity__c,instance_id__c from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quote.id limit 1];
        Product2 prod = [select id from Product2 limit 1];
        
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
         
         List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New'); 
        quoteLineList.add(qli1);
   
       quoteLineList = cz_GlobalSeatCountExtension.getSeatCountForQuoteLines(quoteLineList);
       
         test.stopTest();
     }
    
}