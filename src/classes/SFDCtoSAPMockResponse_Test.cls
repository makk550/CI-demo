@isTest
public class SFDCtoSAPMockResponse_Test implements HttpCalloutMock   {
    
    public HTTPResponse respond(HTTPRequest req) {
        
        HTTPResponse response=new HTTPResponse();
        
    SFDCtoSAPIntegration.RowresponseMessage rowrespons=new   SFDCtoSAPIntegration.RowresponseMessage();
          rowrespons.MSG='Data Recived Successfully';
     SFDCtoSAPIntegration.ResponseMessage rowres=new   SFDCtoSAPIntegration.ResponseMessage();
           rowres.row=rowrespons;
        
   SFDCtoSAPIntegration.SAPResponseback res=new   SFDCtoSAPIntegration.SAPResponseback();
         res.MT_SFDC_SALES_RESTAPI_RESP=rowres;
        
        String jsonres=JSON.serialize(res);
        
        response.setBody(jsonres);
        response.setStatus('Ok');
        response.setStatusCode(200);
        
        return response;
    }

}