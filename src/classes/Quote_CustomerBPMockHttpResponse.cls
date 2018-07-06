@isTest
global class Quote_CustomerBPMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Response":{"executionStatus":{"status":"OK","description":"Search/Retrieve done successfully"},"BusinessPartners":[{"SiteID":"0000019587","AccountGroup":"Z001","Name":"WAL-MART STORES, INC.","Name2":"","Name3":"","Street":"27 Bear Hollow Rd","Street2":"","Street3":"","Pincode":"64856-8204","City":"Pineville","State":"MO","Country":"US, USA","NameLocal":"","Name2Local":"","Name3Local":"","StreetLocal":"","Street2Local":"","Street3Local":"","CityLocal":"","NationInternationalCode":"","BPType":"US01 - CAI, ZD - Direct, CA - CA Software, BP - Bill-to party"}]}}');
        res.setStatusCode(200);
        return res;
    }
}