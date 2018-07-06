@isTest
public class testContractTriggerClass{
    
    
    public static testMethod void testContractHandler(){
        testCreateQuoteAndQuoteLine.createTestData();
        Opportunity opp = [select id,StageName,ReasonField__c,Competitor__c,SBQQ__Contracted__c, AccountId from opportunity limit 1];
        SBQQ__Quote__c quote = [select id from SBQQ__Quote__c limit 1];
        Account acc = [select id from Account limit 1];
        

        Contract c = new Contract(AccountId= acc.id,
                                  SBQQ__Quote__c = quote.id,
                                  SBQQ__Opportunity__c = opp.id,
                                  Bill_To_Address_Lcl__c = ''
                                 );
        insert c;
    }
    
}