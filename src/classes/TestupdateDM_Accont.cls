@isTest(seealldata=true)
private class TestupdateDM_Accont{
    public static testmethod void testupdateDM1(){
        Account testAccount = new Account(); 
        testAccount.Name = 'Test Account _ DM Values';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Account_Type__c = 'Distributor';
        testAccount.Country_Picklist__c = 'MX - MEXICO';
        testAccount.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId(); 
        insert testAccount ;      
        
        testAccount.Country_Picklist__c = 'BR - BRAZIL';
        update testAccount;
    }
}