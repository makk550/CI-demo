/*
Created By: Tarun Sharma
Created On: 04/25/2016
Purpose: Case Archival Mock Response
Modified By:
*/
@isTest
global class CaseArchivalDetails_MockResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       res.setBody('<?xml version="1.0" encoding="UTF-8"?><GoogleDocsAndAttachments_Fields><GoogleDocsAndAttachments><filename name="File Name">Nimsoft Case 00023115 New Comment.msg</filename><type name="Type">Attachment</type><bodylength name="Size">201798</bodylength><lastmodifieddate name="Last Modified">2009-03-11T14:27:12.000+0000Z</lastmodifieddate><created_by name="Created By">Michael Schoellhorn</created_by><section name="Archived Fields"><description name="Description" /><ispartnershared name="IsPartnerShared">False</ispartnershared><isprivate name="IsPrivate">False</isprivate><owner name="Owner">Michael Schoellhorn</owner><parent name="Parent">00023115</parent><url name="Url" /></section></GoogleDocsAndAttachments></GoogleDocsAndAttachments_Fields>');
       res.setStatusCode(200);
       res.setStatus('OK'); 
       res.setHeader('Content-Type', 'application/xml');
       return res;
    }
}