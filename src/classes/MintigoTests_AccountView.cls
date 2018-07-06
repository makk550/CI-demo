@isTest (SeeAllData = true)
private class MintigoTests_AccountView extends MintigoTests_AbstractBase {
    @isTest static String getABMHTML() {
        String response = '<html><body>Hello</body></html>';
        InternalRequestMock fakeResponse = new InternalRequestMock(200, 'OK', response);
        Test.setMock(HttpCalloutMock.class, fakeResponse);     
        Account o = [Select Name, Website, id from Account limit 1];
        PageReference pref = Page.Sales_Coach_Account;
        pref.getParameters().put('id', o.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(o);
        AccountView acctview = new AccountView(stdController);
        Test.startTest();
        response = acctview.getABMHTML();
        Test.stopTest();
        response = '';      
        return response;
    }
}