/*
Created By: Tarun Sharma
Created On: 08/24/2016
Purpose: Case Archival Mock Response
Modified By:
*/
@isTest
global class EmailArchivalDetailsl_EmailMockResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       res.setBody('<?xml version="1.0" encoding="UTF-8"?><EmailAttachments><Attachments><name name="Name" URL="/Layer7Attachments/EmailAttachments/1_Layer7ZipFile_00040377.zip">Layer7.files.zip</name><bodylength name="Size">111111111</bodylength>	  <lastmodifieddate name="Last Modified Date/Time">2015-10-23T16:07:52.000+0000Z</lastmodifieddate><lastmodified_by name="Last Modified By">Stephen Hughes</lastmodified_by></Attachments></EmailAttachments>');
       res.setStatusCode(200);
       res.setStatus('OK'); 
       res.setHeader('Content-Type', 'application/xml');
       return res;
    }
}