@isTest
private class Renewal_BatchUpdateAccountTest{
@isTest(SeeAllData=true)	
public static void testBatch() {
    
    // Create 200 test accounts - this simulates one execute.
    // Important - the Salesforce.com test framework only allows you to
    // test one execute.
    Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='Asia-Pacific';
        ac.Sales_Area__c ='Korea';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        insert ac;
        
    List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
    for(integer i = 0; i<200; i++){
    
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract'+i,Account__c=ac.Id,Contract_Term_Months__c=10);
        activeContractList.add(activeContract);                
    }
    insert activeContractList;
   
    Renewal_BatchUpdateAccount cls = new Renewal_BatchUpdateAccount();
    cls.processRecords(activeContractList);
     
    Test.StartTest();
    Renewal_BatchUpdateAccount reassign = new Renewal_BatchUpdateAccount();
    ID batchprocessid = Database.executeBatch(reassign);
    Test.StopTest();
    
   
  
}
}