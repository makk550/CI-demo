@istest
private class Test_PartnerUserLog_bibu{
 
 static testMethod void myUnitTest1() {
 
     List<Partner_User_Log__c> listOfPartUserLog = [Select Address_1__c, Account_Region__c , Account_Reseller_Type__c , Reseller_Disti_Regional_ID__c , CPMS_HQ_ID__c , Account_Type__c,  Name, Type__c, User__c   From  Partner_User_Log__c where Type__c='New' and 
     
     Account_Region__c != null AND Account_Reseller_Type__c != null AND Reseller_Disti_Regional_ID__c != null AND CPMS_HQ_ID__c != null AND Account_Type__c != null limit 1 ];

    //for udpate trigger 
     if (listOfPartUserLog.size()>0 )
     {
         listOfPartUserLog[0].Address_1__c='Test';
         update listOfPartUserLog;
     }
    
//    User uObj = [select id    from user where isActive=true and AccountId <> null    limit 1];
 Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];

Account a=new Account(Name='Test',RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
insert a;

Contact c=new Contact();
c.LastName='TestCont';
c.accountid=a.ID;
insert c;

Database.DMLOptions dmo = new Database.DMLOptions();
dmo.EmailHeader.triggerUserEmail = true;


User uObj = new User(alias = 'utest', email='test@ca.com',contactId=c.id,
      emailencodingkey='UTF-8', lastname='Unit Test', 
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = profiles[0].id,
      timezonesidkey='Europe/London', 
      username='untest@ca.com');
        
            
        uObj.setOptions(dmo);
        insert uObj;

    
    // for insert 
    Partner_User_Log__c obj = new Partner_User_Log__c(Type__c='New', Account_Region__c='IND', Account_Reseller_Type__c='test', Reseller_Disti_Regional_ID__c='test', CPMS_HQ_ID__c='Test',  User__c = uObj.id  );
    insert obj;     
    
   /// Int_PopulateAccountDataOnPartnerUserLog.populateAccountDataOnPartnerUserLog( listOfPartUserLog );
      
 
 } // end testMethod 

}//end class