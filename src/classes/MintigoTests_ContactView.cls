@isTest (SeeAllData = true)
private class MintigoTests_ContactView extends MintigoTests_AbstractBase {
    @isTest static String getABMHTML() {
        String response = '<html><body>Hello</body></html>';
        InternalRequestMock fakeResponse = new InternalRequestMock(200, 'OK', response);
        Test.setMock(HttpCalloutMock.class, fakeResponse);     
        Contact co = [SELECT Id, Name, Email, Title, Account.Name, FirstName, LastName, Account.BillingState, Account.Website, Account.BillingCountry FROM Contact limit 1];
        PageReference pref = Page.Sales_Coach_Contact_ABM;
        pref.getParameters().put('id', co.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(co);
        ContactView contactview = new ContactView(stdController);
        Test.startTest();
        response = contactview.getABMHTML();
        Test.stopTest();
        
        return response;
    }
    
    @isTest static String getLBMHTML() {
        String response = '<html><body>Hello</body></html>';
        InternalRequestMock fakeResponse = new InternalRequestMock(200, 'OK', response);
        Test.setMock(HttpCalloutMock.class, fakeResponse);     
        Contact co = [SELECT Id, Name, Email, Title, Account.Name, FirstName, LastName, Account.BillingState, Account.Website, Account.BillingCountry FROM Contact limit 1];
        PageReference pref = Page.Sales_Coach_Contact_LBM;
        pref.getParameters().put('id', co.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(co);
        ContactView contactview = new ContactView(stdController);
        Test.startTest();
        response = contactview.getLBMHTML();
        Test.stopTest();
        
        return response;
    }    
}