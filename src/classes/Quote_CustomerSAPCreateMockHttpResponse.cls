@isTest
global class Quote_CustomerSAPCreateMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"MT_SFDC_RESTAPI_CONTACT_MAINTAIN_RESP":{"row":{"CONTACT_PERS_ID":"0000722590","MESSAGE":"Contact person 0000722590 created for customer 0002034254","STATUS":"Success"}}}');
        res.setStatusCode(200);
        return res;
    }
}