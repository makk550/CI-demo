/*
Created By: Tarun Sharma
Created On: 10/13/2015
Purpose: B-04030: Associate an existing Defect to Case UI Mock Update Response
Modified By:
*/
@isTest
global class DefectAssociation_UIMockEmptyResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       if(req.getMethod().equalsIgnoreCase('PUT')){
          res.setBody('');
          res.setStatusCode(400);
       }else{
          res.setBody('');
          res.setStatusCode(200);
       }
       res.setStatus('OK'); 
       res.setHeader('Content-Type', 'application/json');
       return res;
    }
}