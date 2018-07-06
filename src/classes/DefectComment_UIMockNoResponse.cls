/*
Created By: Tarun Sharma
Created On: 10/14/2015
Purpose: NO RESPONSE UI MOCK Class for user story ---> B-03937: Send support defect comments from SC to Rally
Modified By:
*/
@isTest
global class DefectComment_UIMockNoResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody('[{"operation":"PUT","successful":false,"errors":null,"warnings":null,"objectId":null}]');
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('Bad Request'); 
        res.setStatusCode(400);
        return res;
    }
}