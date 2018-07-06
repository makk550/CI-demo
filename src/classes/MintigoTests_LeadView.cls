@isTest (SeeAllData = true)
private class MintigoTests_LeadView extends MintigoTests_AbstractBase {
    @isTest static String getABMHTML() {
        String response = '<html><body>Hello</body></html>';
        InternalRequestMock fakeResponse = new InternalRequestMock(200, 'OK', response);
        Test.setMock(HttpCalloutMock.class, fakeResponse);     
        Lead lo = [Select Email, FirstName, LastName, Website, Country, Title from Lead limit 1];
        PageReference pref = Page.Sales_Coach_Lead_ABM;
        pref.getParameters().put('id', lo.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lo);
        LeadView leadview = new LeadView(stdController);
        Test.startTest();
        response = leadview.getABMHTML();
        Test.stopTest();
        return response;
    }
    
    @isTest static String getLBMHTML() {
        String response = '<html><body>Hello</body></html>';
        InternalRequestMock fakeResponse = new InternalRequestMock(200, 'OK', response);
        Test.setMock(HttpCalloutMock.class, fakeResponse);     
        Lead lo = [Select Email, FirstName, LastName, Website, Country, Title from Lead limit 1];
        PageReference pref = Page.Sales_Coach_Lead_LBM;
        pref.getParameters().put('id', lo.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lo);
        LeadView leadview = new LeadView(stdController);
        Test.startTest();
        response = leadview.getLBMHTML();
        Test.stopTest();  
        return response;      
    }
}