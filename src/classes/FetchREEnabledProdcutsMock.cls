@IsTest 
global class FetchREEnabledProdcutsMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('/care/v1.0/api/EnabledProducts')) {            
            res.setBody('{ "products": [ { "name": "ADVANCED AUTHENTICATION", "displayName": "ADVANCED AUTHENTICATION", "id": "5000378", "scName": "ADVANCED AUTHENTICATION", "category": "RE"  }]}');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('/care/v1.0/login')){
            res.setHeader('OAuth', 'e54ccff8-613d-43a1-952b-4a00acacd2af');
            res.setStatusCode(200);
            return res;
        }
        return null;
    }
}