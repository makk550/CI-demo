global with sharing class BPApprovalTriggerHandler_MockCallout implements HttpCalloutMock  {

	String endpoint;
	public BPApprovalTriggerHandler_MockCallout(String endpoint){
		this.endpoint = endpoint;
	}

	global HTTPResponse respond(HTTPRequest req) {
	        System.assertEquals(endpoint, req.getEndpoint());
	        System.assertEquals('POST', req.getMethod());
	        
	        //mock response
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"TestCallout":"true"}');
	        res.setStatusCode(200);
	        return res;
	}

}