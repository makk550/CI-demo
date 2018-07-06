@isTest(SeeAllData=true) 
private class Test_CAResellerAccountSearchCls {
    static testMethod void testCAResellerAccountSearch() 
    {
     CAResellerAccountSearch objSearch = new CAResellerAccountSearch();   
     objSearch.accountName = 'test';
     objSearch.stateRegion = 'test';
     objSearch.createaccountName ='test';
     objSearch.physicalStreet = 'test';
     objSearch.physicalCity = 'test';
     objSearch.newCountry ='IN - INDIA';
     objSearch.physicalState = 'test';
     objSearch.showCreateAccount();
     objSearch.SearchAccounts();
     objSearch.showSearchScreen();
     objSearch.CreateAccount();
     objSearch.ClearControls();
     
     objSearch = new CAResellerAccountSearch(); 
     objSearch.accountName = 'test';
     objSearch.stateRegion = '';
     objSearch.selectedCountry = 'IN - INDIA';

    }    
}