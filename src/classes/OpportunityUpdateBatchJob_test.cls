/*
 * Test class created by MERHA02.
 * This is to test OpportunityUpdateBatchJob
 * 
 */ 

@isTest
private class OpportunityUpdateBatchJob_test {

    
    static testMethod void testOpportunityUpdateBatchJob() {
        
       
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
         Id dealRegOppRecordTypeID = oppRecType.get('Deal Registration').getRecordTypeId();
       
       
        Opportunity opp1 = new Opportunity(AccountId=a.Id,Reseller__c=a.Id,Name='Opp',RecordTypeId=dealRegOppRecordTypeID,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);
        insert opp1;
      
        Test.startTest();
        OpportunityUpdateBatchJob oppUpdate = new OpportunityUpdateBatchJob();
        Id batchId = Database.executeBatch(oppUpdate);
        Test.stopTest();
        
       
    }

    
    
}