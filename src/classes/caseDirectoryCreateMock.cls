@IsTest
global class caseDirectoryCreateMock implements HttpCalloutMock{
		global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('/crushftp/siteid')) {
            res.setStatusCode(200);
            return res;
        }
        
        else if(req.getEndpoint().contains('csp/casefolder')){
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><commandResult><response></response></commandResult>');
            return res;
        } 
         
        return null;
	}
}