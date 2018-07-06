@IsTest 
global class CC_CustomerFormControllerMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint() == System.Label.CACOM_Countries_Endpoint) {
            res.setBody('[{"Country_Abbrev": "US","Country_ID": "10554","Country_Name": "US - UNITED STATES"},{"Country_Abbrev": "AX","Country_ID": "57140","Country_Name": "Aland Islands"}]');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains(System.Label.CACOM_States_Endpoint)){
            res.setBody('[{"FKCountry_ID": "10554","SAPCountry_Code": "", "SAPState_Code": "8", "State_Abbrev": "8", "State_ID": "122604", "State_NSID": "", "State_Name": "Baden-Württemberg" }]');
            res.setStatusCode(200);
            return res;
        }
        else if(req.getEndpoint().contains('https://www.google.com/recaptcha/api/siteverify')){
            res.setBody('{"success":"true"}');
            res.setStatusCode(200);
            return res;
        }
        return null;
    }
}