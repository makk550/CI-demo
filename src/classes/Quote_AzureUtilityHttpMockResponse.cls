@istest
global class Quote_AzureUtilityHttpMockResponse  implements HttpCalloutMock {
    
    
      global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        String respon='{"status":"OK","message":"The request was successful.","siteId":"0005001489","reason":"Customer 0005001489 created successfully.","CUSTOMER_INFO":{"SoldToId":"0005001489","ShipToId":"","BillToId":"","CA_Account_ID":"L103207","Account_Group":"Z001","Account_Group_code":"Z001","City":"Taipei","CityInternationalLanguage":"台北市","Country":"TW","Country_code":"TW","Name1":"Hewlett Packard","Name2":"Enterprise Company","Name3":"private","Name4":"Limited","Name1InternationalLanguage":"電資系統股份有限公司","Name2InternationalLanguage":"電資系統股份有限公司","Name3InternationalLanguage":"","Name4InternationalLanguage":"","Postal_Code":"106","Region":"","Region_code":"TWN","Street":"11/Fl No 260 Pa Teh Rd","Street2":"Ir#455900","Street3":"Aspen drive","Street4":"Plainsboro","Street5":"","Street1InternationalLanguage":"承德路四段172號","Street2InternationalLanguage":"士林區","Street3InternationalLanguage":"士林區","Street4InternationalLanguage":"士林區","Street5InternationalLanguage":"士林區","Tax_Number_1":"tax1","Tax_Number_2":"tax2","Tax_Number_3":"tax3","Tax_Number_4":"tax4","Telephone":"","VAT_Registration_Number":"vrn1","GST_Registration_Number":"grn1","UserInfo_RequestedUserName":"","UserInfo_PMFKey":"pmfk1","UserInfo_TransactionReferenceNo":"","UserInfo_OpportunityNumber":"","UserInfo_CreatedDate":"2017-11-23T19:35:46.621Z"}}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(respon);
        res.setStatusCode(200);
        return res;
    }

}