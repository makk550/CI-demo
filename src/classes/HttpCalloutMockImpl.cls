global class HttpCalloutMockImpl implements HttpCalloutMock {
        
         
          // Implement this interface method
    global HttpResponse  respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
               System.assertEquals('https://eaisvcqafs.ca.com/spl/r.v1?country=USA&city=Austin&name1=TestSA8&partnerid=GSA31&systemid=ZCA_SVCCLD&format=xml', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<ZGD_PRD_ECCN_T><item><BUSINESSPARTNER_ID>GSA31</BUSINESSPARTNER_ID>'+
'<ZDATE>20141205010952</ZDATE><MATCHSTATUS>Success</MATCHSTATUS>'+
'<DESCRIPTION>Partner screened successfully and this is not a blocked partner.</DESCRIPTION>'+
'<BUSINESSPARTNER_FUNCTION>RS</BUSINESSPARTNER_FUNCTION><SANCTIONEDPARTY>0070605556</SANCTIONEDPARTY>'+
'</item></ZGD_PRD_ECCN_T>');
        res.setStatusCode(200);
        return res ;
    }
}