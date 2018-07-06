/*
 * HTTP Mock Class to send test response for Defect Create Callout 
*/
@isTest
global class DefectCreateMockCallout implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody('[{"operation":"POST","successful":true,"errors":null,"warnings":null,"objectId":"https://rally1.rallydev.com/slm/webservice/v2.0/defect/45925784761","uiId":"DE000000","uiUrl":"https://rally1.rallydev.com//#/43516634687/detail/defect/45925784761","defectPriority":"4 - Low","defectSeverity":"3 - Non - Critical"}]');
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK'); 
        res.setStatusCode(200);
        return res;
    }
}