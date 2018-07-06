@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        string url='http://maps.google.com/maps/geo?key=ABQIAAAAn-_wL1b8pbIpJfusL0LMmRQ72da4xWLg1N8Ce02Xdu0VxpZsuRQ204RfeXqfJttrBEVklwfOQn2xNA' 
                                    + '&output=csv&q=' + EncodingUtil.urlEncode('s,c,US','UTF-8');
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res.setBody('"0","0",44.968046,-94.420307');
        res.setStatusCode(200);
        return res;
    }
}