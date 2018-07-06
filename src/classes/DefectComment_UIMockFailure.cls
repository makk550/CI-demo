/*
Created By: Tarun Sharma
Created On: 10/14/2015
Purpose: FAILURE UI MOCK Class for user story ---> B-03937: Send support defect comments from SC to Rally
Modified By:
*/
@isTest
global class DefectComment_UIMockFailure implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody('[{"operation":"PUT","successful":false,"errors":[{"cause":"test","detail":"test"}],"warnings":null,"objectId":"https:www.abc.com","uiId":"DE1111","uiUrl":"https:www.abc.com"}]');
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK'); 
        res.setStatusCode(200);
        return res;
    }
}