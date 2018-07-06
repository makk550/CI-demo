@isTest
global class Quote_CustomerSAPReadMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"MT_SFDC_RESTAPI_CUSTOMER_READ_RESP":{"CUSTOMER_DETAILS":{"item":{"CONTACT_DETAILS":{"item":[{"CONTACT_ID":722589,"PARTNER_FUNCTION_DESCRIPTION":"Technical Contact","FIRST_NAME":"stesuser1","LAST_NAME":"aaaaaaa","TELEPHONE":9825867994,"TELEPHONE_EXTN":"","EMAIL_ID":"saikumr@1587gmai.com","LAST_NAME_INTL":"aaaaaaa","FIRST_NAME_INTL":"stesuser1"},{"CONTACT_ID":"        0","PARTNER_FUNCTION_DESCRIPTION":"","FIRST_NAME":"","LAST_NAME":"","TELEPHONE":"","TELEPHONE_EXTN":"","EMAIL_ID":"","LAST_NAME_INTL":"","FIRST_NAME_INTL":""},{"CONTACT_ID":"        0","PARTNER_FUNCTION_DESCRIPTION":"","FIRST_NAME":"","LAST_NAME":"","TELEPHONE":"","TELEPHONE_EXTN":"","EMAIL_ID":"","LAST_NAME_INTL":"","FIRST_NAME_INTL":""}]},"PARTNER_DETAILS":""}},"ERROR_MSG":""}}');
        res.setStatusCode(200);
        return res;
    }
}