@isTest(SeeAllData=true)   
private class Test_CAEndUserAccountSearchCls{
    static testMethod void testCAEndUserAccountSearch() 
    {
     User usr;
     Profile pr = [select id from Profile where Name = 'Partner User with Sales Tools' LIMIT 1];
/*     if(pr <> null)
         usr = [select id from User where ProfileID =: pr.Id and IsActive = true Limit 1];*/

        Account a=new Account(Name='Test',RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
        insert a;
        
        Contact c=new Contact();
        c.LastName='TestCont';
        c.accountid=a.ID;
        insert c;
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;


        User uObj = new User(alias = 'utest', email='test@ca.com',contactId=c.id,
        emailencodingkey='UTF-8', lastname='Unit Test', firstname = 'test fname',
        languagelocalekey='en_US',
        localesidkey='en_GB', profileid = pr.id,
        timezonesidkey='Europe/London', 
        username='untest@ca.com');
        
            
        uObj.setOptions(dmo);
        insert uObj;
      

     CAEndUserAccountSearch objSearch = new CAEndUserAccountSearch();   
     objSearch.accountName = 'test';
     objSearch.selectedCountry = 'BR - BRAZIL';
     objSearch.stateRegion = 'BR';
     
     objSearch.createaccountName ='test';
     objSearch.physicalStreet = 'test';
     objSearch.physicalCity = 'test';
     objSearch.newCountry ='IN - INDIA';
     objSearch.physicalState = 'test';
     objSearch.ZipPostalCode = '23456';
     if(Usr<>null){
         system.runas(Usr){
             objSearch.CreateAccount();
             objSearch.getCountries();
             objSearch.showCreateAccount();
             objSearch.showSearchScreen();
         } 
      }
      else{
         objSearch.CreateAccount();
         objSearch.getCountries();
         objSearch.showCreateAccount();
         objSearch.showSearchScreen();
         objSearch.ClearControls(); 
      }
     objSearch = new CAEndUserAccountSearch(); 
     objSearch.accountName = 'test';
     objSearch.selectedCountry = 'US - UNITED STATES';
     objSearch.stateRegion = 'US';
     objSearch.CreateAccount();

    }    
}