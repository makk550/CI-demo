/*
Created By: Tarun Sharma
Created On: 08/24/2016
Purpose: AWS Bucket Access
Modified By:
*/
@isTest
global class AWSBucketAccess_EmailMockResponse implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest req){
       HttpResponse res = new HttpResponse();
       res.setBody('<?xml version="1.0" encoding="UTF-8"?><EmailMessageContent><Email><fields><section visible="true" column="2" name="Information"><parent_id name="Parent Case">00040377</parent_id><status name="Status">Replied</status><MessageDate name="Message Date">2015-10-16T13:42:54.000+0000Z</MessageDate><LastModified_By name="Last Modified By">Stephen Hughes</LastModified_By><LastModifiedDate name="Last Modified Date/Time">2015-10-16T13:43:37.000+0000Z</LastModifiedDate><Created_By name="Created By">Stephen Hughes</Created_By><CreatedDate name="Created By Date/Time">2015-10-16T13:43:37.000+0000Z</CreatedDate></section><section visible="true" column="1" name="Address Information"><FromAddress name="From Address">bcook@hpe.com</FromAddress><FromName name="From Name">Cook, Barry</FromName><ToAddress name="To Address">api-support@ca.com;jamie.eastabrook@hpe.com;frederic.gagne@hpe.com;patrick.collings@hpe.com;andrei.frunza@aimia.com;cassiano.santos@hpe.com</ToAddress><CcAddress name="CC Address"/></section><section  visible="true" column="1" name="Message Content"><Subject name="Subject">RE: Aimia Layer 7 Gateway - tcpdump or other    [ ref:_00D00hiBS._50038hpZwY:ref ]</Subject><TextBody name="Text Body">Thank you Azad.Regards,Barry-----Original Message-----..........</TextBody><HtmlBody name="HTML Body"/></section></fields><relatedList name="Attachments"><relatedListURL>/RelatedXMLs/1_sampleEmailAttachments_00040377.xml</relatedListURL></relatedList></Email></EmailMessageContent>');
       res.setStatusCode(200);
       res.setStatus('OK'); 
       res.setHeader('Content-Type', 'application/xml');
       return res;
    }
}