/*
Created By: Tarun Sharma
Created On: 10/13/2015
Purpose: B-04030: Associate an existing Defect to Case UI Failure Mock Response
Modified By:
*/
@isTest
global class DefectAssociation_UIMockFaliure implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       if(req.getMethod().equalsIgnoreCase('PUT')){
          res.setBody('[{"operation":"PUT","successful":false,"errors":[{"cause":"help","detail":"help"}],"warnings":[{"cause":"help","detail":"help"}],"objectId":"https://rally1.rallydev.com/slm/webservice/v2.0/defect/38548860275","uiId":"DE1234","uiUrl":"https://rally1.rallydev.com//#/38499718573/detail/defect/38548860275"}]'); 
       }else{
          res.setBody('[{"operation":"GET","successful":false,"errors":[{"cause":"help","detail":"help"}],"warnings":[{"cause":"help","detail":"help"}],"defect":null}]');
       }
       res.setHeader('Content-Type', 'application/json');
       res.setStatus('OK'); 
       res.setStatusCode(200);
       return res;
    }
}