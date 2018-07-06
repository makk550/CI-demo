/**
* Test class to provide coverage for ToolingAPI
**/

@isTest(SeeAllData = true)
private class Test_ToolingAPI {


    public class ToolingApiMockQuery implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            // Create response element from the autogenerated class.
            // Populate response element.
            // Add response element to the response parameter, as follows:
            response.put('response_x', new ToolingAPIWSDL.queryResponse_element());
        }
    }

    
   private static testMethod void TestToolingAPI()
   {
        
        Test.setMock(WebServiceMock.class, new ToolingApiMockQuery());
        
        ToolingAPI toolingAPI = new ToolingAPI();
        string str = 'Select ApexClassOrTriggerId,NumLinesCovered,NumLinesUncovered From ApexCodeCoverageAggregate Order By NumLinesUncovered Desc';
        ToolingAPIWSDL.QueryResult qr  = toolingApi.query('Select id from ApexClass');
        system.debug('########--'+qr);
        new toolingAPI.ToolingAPIException ();
        //toolingApi.query('Select Name from ApexClass','test');
        
        
       // toolingApi.castQueryResultToSubclass(qr,'Account');
        
    }  
      

}