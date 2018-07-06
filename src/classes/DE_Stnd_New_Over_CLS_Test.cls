@isTest(seealldata=true)
private class DE_Stnd_New_Over_CLS_Test{

static testMethod void ValidateRedirect(){
    
         Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true);
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Technology Partner').getRecordTypeId();  
         //Account acc= new Account(Name='CA ITC',BillingCity='asd',BillingCountry='US',BillingStreet='asd',Account_Status__c='New');
        insert acc;
    ApexPages.currentPage().getParameters().put('RecordType', acc.recordtypeid);
         
    
    
         ApexPages.StandardController sc = new ApexPages.standardController(acc);           
         DE_Stnd_New_Over_CLS butcontr = new DE_Stnd_New_Over_CLS (sc);
         butcontr.redir();
         
}




}