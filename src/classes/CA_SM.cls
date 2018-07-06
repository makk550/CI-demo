global class CA_SM
{
    private static String incidentEndpoint
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_Incident_Endpoint_URL : Label.Service_Desk_Incident_Endpoint_URL_QA;}
    }

    private static String changeRequestEndpoint
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_Change_Request_Endpoint_URL : Label.Service_Desk_Change_Request_Endpoint_URL_QA;}
    }
    
    private static String attachmentEndpoint
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_Attachment_Endpoint_URL : Label.Service_Desk_Attachment_Endpoint_URL_QA;}
    }
    
    private static String serviceDeskUser
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_User_Name : Label.Service_Desk_User_Name_QA;}
    }

    private static String serviceDeskPassword
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_User_Password : Label.Service_Desk_User_Password_QA;}
    }

    webService static String ocs_WS(String des, String url, String sc, String ticket_Type)
    {
        String ticket_number;
    
        if(ticket_type=='incident')
        {
            String doc = reportIncidentSFDC(des, url);
            ticket_number = '300-' + doc.substringBetween('![CDATA[300-',']]&gt;&lt;/ticket_identifier>');
        }
        else
        {
            String doc = createChangeRequestSFDC(des, url);
            ticket_number = '200-' + doc.substringBetween('![CDATA[200-', ']]&gt;&lt;/ticket_identifier>');
        }
        
        attachAndRelateImg(sc, ticket_number, ticket_Type);
        
        return ticket_number;
    }

    public static String reportIncidentSFDC(String des, String url) 
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(incidentEndpoint);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('SOAPAction', '"urn:reportIncident"');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        //req.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd"><soapenv:Header/><soapenv:Body><wrap:reportIncident><wrap:credentials><xsd:userName>System_auto_tick</xsd:userName><xsd:userPassword>!Seven11</xsd:userPassword></wrap:credentials><wrap:extendedSettings><xsd:responseFormat>XML</xsd:responseFormat></wrap:extendedSettings><wrap:incBean><xsd:affected_ci_name>Salesforce</xsd:affected_ci_name><xsd:ccti_category>Application » Break-Fix » Salesforce (SFDC) » Accounts</xsd:ccti_category><xsd:ccti_class>Application</xsd:ccti_class><xsd:ccti_item>Accounts</xsd:ccti_item><xsd:ccti_type>Salesforce(SFDC)</xsd:ccti_type><xsd:requester_name>Kiran, Parvathala</xsd:requester_name><xsd:ticket_description>MORE PROBLEMS WITH CODE HACK</xsd:ticket_description></wrap:incBean></wrap:reportIncident></soapenv:Body></soapenv:Envelope>');
        String body = '';
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd">';
        body += '    <soapenv:Header/>';
        body += '    <soapenv:Body>';
        body += '    <wrap:reportIncident>';
        body += '        <wrap:credentials>';
        body += '    <xsd:userName>' + serviceDeskUser + '</xsd:userName>';
        body += '<xsd:userPassword>' + serviceDeskPassword + '</xsd:userPassword>';
        body += '</wrap:credentials>';
        body += '<wrap:extendedSettings>';
        body += '<xsd:responseFormat>XML</xsd:responseFormat>';
        body += '</wrap:extendedSettings>';
        body += '<wrap:incBean>';
        body += '<xsd:affected_ci_name>Salesforce</xsd:affected_ci_name>';
        body += '<xsd:ccti_category>Break-Fix</xsd:ccti_category>';
        body += '<xsd:ccti_class>Application</xsd:ccti_class>';
        //body += '<xsd:ccti_item>Other</xsd:ccti_item>';
        body += '<xsd:ccti_type>Salesforce (SFDC)</xsd:ccti_type>';
        //body += '<xsd:ccti_id>399</xsd:ccti_id>';
        //body += '<xsd:requester_name>Kiran, Parvathala</xsd:requester_name>';
        body += '<xsd:requester_name>' + UserInfo.getFirstName().escapeXml() + ', ' + UserInfo.getLastName().escapeXml() + '</xsd:requester_name>';
        //body += '<xsd:ticket_priority>Medium</xsd:ticket_priority>';
        //body += '<xsd:ticket_impact>Low</xsd:ticket_impact>';
        //body += '<xsd:ticket_urgency>Medium</xsd:ticket_urgency>';
        body += '<xsd:description_long>' + des.escapeXml() + '   SFDC URL : <![CDATA[' + url + ']]> </xsd:description_long>';
        //body += '<xsd:ticket_description>' + des.escapeXml() + '</xsd:ticket_description>';
        body += '<xsd:person1_alt_email>' + UserInfo.getUserEmail().escapeXml() + '</xsd:person1_alt_email>';
        body += '<xsd:ticket_priority>High</xsd:ticket_priority>';
        body += '<xsd:ticket_impact>High</xsd:ticket_impact>';
        body += '<xsd:ticket_urgency>High</xsd:ticket_urgency>';
        body += '</wrap:incBean>';
        body += '</wrap:reportIncident>';
        body += '</soapenv:Body>';
        body += '</soapenv:Envelope>';

        System.debug(body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res.getBody();
        
        //Dom.Document doc = new Dom.Document();
        //doc.load('<?xml version' + res.getBody().substringBetween('<?xml version','</soapenv:Envelope>') + '</soapenv:Envelope>');
        //return doc;
        //return res.getBodyDocument();
    }
    
    public static String logServiceRequestSFDC(String des, String url) 
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.Service_Desk_Service_Request_Endpoint_URL_QA);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('SOAPAction', '"urn:logServiceRequest"');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        String body = '';
        
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd">';
        body += '   <soapenv:Header/>';
        body += '   <soapenv:Body>';
        body += '      <wrap:logServiceRequest>';
        body += '         <wrap:credentials>';
        body += '            <xsd:userName>' + serviceDeskUser + '</xsd:userName>';
        body += '            <xsd:userPassword>' + serviceDeskPassword + '</xsd:userPassword>';
        body += '         </wrap:credentials>';
        body += '         <wrap:extendedSettings>';
        body += '            <xsd:responseFormat>XML</xsd:responseFormat>';
        body += '         </wrap:extendedSettings>';
        body += '         <wrap:srqBean>';
        body += '           <xsd:affected_ci_id>125109</xsd:affected_ci_id>';
        body += '            <xsd:affected_ci_name>Salesforce aka SFDC</xsd:affected_ci_name>';
        body += '           <xsd:ccti_id>1390</xsd:ccti_id>';
        body += '            <xsd:description_long>' + des.escapeXml() + '   SFDC URL : <![CDATA[' + url + ']]> </xsd:description_long>';
        body += '            <xsd:requester_name>' + UserInfo.getFirstName().escapeXml() + ', ' + UserInfo.getLastName().escapeXml() + '</xsd:requester_name>';
        body += '            <xsd:ticket_description>' + des.escapeXml() + '</xsd:ticket_description>';
        body += '         </wrap:srqBean>';
        body += '      </wrap:logServiceRequest>';
        body += '   </soapenv:Body>';
        body += '</soapenv:Envelope>';
        
        System.debug(body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res.getBody();
    }
    
    public static String createChangeRequestSFDC(String des, String url) 
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(changeRequestEndpoint);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('SOAPAction', '"urn:createChangeRequest"');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        String body = '';
        
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd">';
        body += '   <soapenv:Header/>';
        body += '   <soapenv:Body>';
        body += '      <wrap:createChangeRequest>';
        body += '         <wrap:credentials>';
        body += '            <xsd:userName>' + serviceDeskUser + '</xsd:userName>';
        body += '            <xsd:userPassword>' + serviceDeskPassword + '</xsd:userPassword>';
        body += '         </wrap:credentials>';
        body += '         <wrap:extendedSettings>';
        body += '            <xsd:responseFormat>XML</xsd:responseFormat>';
        body += '         </wrap:extendedSettings>';
        body += '         <wrap:chgBean>';
        //body += '            <xsd:affected_ci_id>125109</xsd:affected_ci_id>';
        //body += '            <xsd:ccti_id>1382</xsd:ccti_id>';
        body += '              <xsd:ccti_category>Enhancement</xsd:ccti_category>';
        body += '              <xsd:ccti_class>Application</xsd:ccti_class>';
        //body += '<xsd:ccti_item>Other</xsd:ccti_item>';
        body += '              <xsd:ccti_type>Salesforce (SFDC)</xsd:ccti_type>';
        body += '            <xsd:person1_alt_email>' + UserInfo.getUserEmail().escapeXml() + '</xsd:person1_alt_email>';
        body += '            <xsd:reason_for_change>' + des.escapeXml() + '   SFDC URL : <![CDATA[' + url + ']]> </xsd:reason_for_change>';
        body += '            <xsd:requester_name>' + UserInfo.getFirstName().escapeXml() + ', ' + UserInfo.getLastName().escapeXml() + '</xsd:requester_name>';
        body += '            <xsd:ticket_priority>High</xsd:ticket_priority>';
        body += '            <xsd:ticket_impact>High</xsd:ticket_impact>';
        body += '            <xsd:ticket_urgency>High</xsd:ticket_urgency>';
        body += '         </wrap:chgBean>';
        body += '      </wrap:createChangeRequest>';
        body += '   </soapenv:Body>';
        body += '</soapenv:Envelope>';
        
        System.debug(body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res.getBody();
    }
    
    @future (callout=true)
    public static void attachAndRelateImg(String img, String ticket, String ticket_type) 
    {
        System.debug(img);
        img = img.remove('data:image/png;base64,');
        System.debug(img);
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(attachmentEndpoint);
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('SOAPAction', '"urn:addAttachment"');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        String body = '';
        body += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd">';
        body += '<soapenv:Header/>';
        body += '<soapenv:Body>';
        body += '<wrap:addAttachment>';
        body += '<wrap:credentials>';
        body += '<xsd:userName>' + serviceDeskUser + '</xsd:userName>';
        body += '<xsd:userPassword>' + serviceDeskPassword + '</xsd:userPassword>';
        body += '</wrap:credentials>';
        body += '<wrap:extendedSettings>';
        body += '<xsd:responseFormat>XML</xsd:responseFormat>';
        body += '</wrap:extendedSettings>';
        body += '<wrap:attachmentBean>';
        body += '<xsd:attach_created_by>' + UserInfo.getFirstName().escapeXml() + ', ' + UserInfo.getLastName().escapeXml() + '</xsd:attach_created_by>';
        body += '<xsd:attach_description>screen capture</xsd:attach_description>';
        body += '<xsd:attach_file_name>screencapture.png</xsd:attach_file_name>';
        body += '<xsd:attach_file_type>Image</xsd:attach_file_type>';
        body += '<xsd:attach_is_global>yes</xsd:attach_is_global>';
        body += '<xsd:attach_is_private>false</xsd:attach_is_private>';
        body += '<xsd:attach_name>screencapture.png</xsd:attach_name>';
        body += '</wrap:attachmentBean>';
        body += '<wrap:attachFileData>' + img + '</wrap:attachFileData>';
        body += '</wrap:addAttachment>';
        body += '</soapenv:Body>';
        body += '</soapenv:Envelope>';
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        String attachmentId = res.getBody().substringBetween('attachment_id>&lt;![CDATA[', ']]&gt;&lt;/attachment_id>');
        
        
        req = new HttpRequest();
        
        if(ticket_type=='incident')
            req.setEndpoint(incidentEndpoint);
        else
            req.setEndpoint(changeRequestEndpoint);
            
        req.setTimeout(120000);
        req.setMethod('POST');
        //req.setHeader('SOAPAction', '"urn:relateAttachment"');
        req.setHeader('Content-Type', 'application/soap+xml;charset=UTF-8;action="urn:relateAttachment"');
        body = '';
        body += '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd">';
   body += '<soap:Header/>';
   body += '<soap:Body>';
      body += '<wrap:relateAttachment>';
         body += '<wrap:credentials>';
            body += '<xsd:userName>' + serviceDeskUser + '</xsd:userName>';
            body += '<xsd:userPassword>' + serviceDeskPassword + '</xsd:userPassword>';
         body += '</wrap:credentials>';
         body += '<wrap:extendedSettings>';
            body += '<xsd:responseFormat>XML</xsd:responseFormat>';
         body += '</wrap:extendedSettings>';
         body += '<wrap:ticketIdentifier>' + ticket + '</wrap:ticketIdentifier>';
         body += '<wrap:attachmentId>' + attachmentId + '</wrap:attachmentId>';
         body += '<wrap:attach_is_private>False</wrap:attach_is_private>';
         body += '</wrap:relateAttachment>';
        body += '</soap:Body>';
        body += '</soap:Envelope>';
        System.debug(body);
        req.setBody(body);
        http = new Http();
        res = http.send(req);
        System.debug(res.getBody());
    }
}