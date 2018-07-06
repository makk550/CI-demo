/*
Created By: Tarun Sharma
Created On: 10/13/2015
Purpose: B-04030: Associate an existing Defect to Case UI Mock Null Response
Modified By:
*/
@isTest
global class DefectAssociation_UIMockNullResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       res.setBody('[{"operation":"GET","successful":true,"errors":null,"warnings":[{"cause":"help","detail":"help"}],"defect":{"defectNumber":"DE1111","defectId":"https://rally1.rallydev.com/slm/webservice/v2.0/defect/44730633007","subject":"test","description":"test","status":"Submitted","defectSeverity":"3 - Non - Critical","defectPripority":"4 - Low","defectOwner":"tarun","targetedReleaseNumber":"2","targetReleaseDate":"2015-10-13T11:43:47.559-04:00","resolution":"fixed","comments":[{"comment":"Commenter: Tarun Sharma <br>On: 2015/10/13 08:05:18.000 <br><br>test","date":"2015-10-13T12:05:20.719Z","author":"toolsadmin@ca.com","authorName":null},{"comment":"Commenter: SHATA07 <br>On: 2015/10/13 08:07:00.000 <br><br>testing","date":"2015-10-13T12:07:02.107Z","author":"toolsadmin@ca.com","authorName":null},{"comment":"Commenter: SHATA07 <br>On: 2015/10/13 08:07:00.000 <br><br>testing","date":"2015-10-13T12:07:26.611Z","author":"toolsadmin@ca.com","authorName":null}]}}]');
       res.setHeader('Content-Type', 'application/json');
       res.setStatus('OK'); 
       res.setStatusCode(500);
       return res;
    }
}