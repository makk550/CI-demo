/*
Created By: Tarun Sharma
Created On: 08/24/2016
Purpose: Case Archival Mock Response
Modified By:
*/
@isTest
global class CaseArchivalDetailsl_EmailMockResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       res.setBody('<?xml version="1.0" encoding="UTF-8"?><EmailMessage_Fields><EmailMessage><status name="Status">0</status><subject name="Subject" URL="/EmailMessageContent/1_SampleEmailMessageContent_00040377.xml">RE: Aimia Layer 7 Gateway - tcpdump or other    [ ref:_00D00hiBS._50038hpZwY:ref ]</subject><toAddress name="Email Address">api-support@ca.com;jamie.eastabrook@hpe.com;frederic.gagne@hpe.com;patrick.collings@hpe.com;andrei.frunza@aimia.com;cassiano.santos@hpe.com</toAddress><messagedate name="Message Date">2015-10-16T13:42:54.000+0000Z</messagedate><TextBody name="Text Body">Thank you Azad.Regards,Barry-----Original Message-----..........</TextBody></EmailMessage></EmailMessage_Fields>');
       res.setStatusCode(200);
       res.setStatus('OK'); 
       res.setHeader('Content-Type', 'application/xml');
       return res;
    }
}