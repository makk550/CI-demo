public with sharing class NSDIntegrator {

public Static String CRNum = '';

private static String changeRequestEndpoint
    {
        get{ return Id.valueOf('00D300000006yn4') == UserInfo.getOrganizationId() ? Label.Service_Desk_Change_Request_Endpoint_URL : Label.Service_Desk_Change_Request_Endpoint_URL_QA;}
    }    
    
   public static String createIncident(String AssignedGroupId, String CCTIId, String TicketDescription, String RequestedForName, String RequesterName, String TicketSubject, String requestedForEmail, String requestedForPhone,String AccessRequestId,String AccessRequestNumber, String requestorEmail, String requestorPhone) {
        
        try {
            system.debug('RequesterName>'+RequesterName);
            HttpRequest request = new HttpRequest();
            /*request.setEndpoint(Label.NSD_Stage_Endpoint_Incident);
         
            String username = Label.NSD_Stage_Username;
            String password = Label.NSD_Stage_Password;*/
            
            //request.setEndpoint(Label.Service_Desk_Change_Request_Endpoint_URL);
         
            String username = Label.Service_Desk_User_Name;
            String password = Label.Service_Desk_User_Password;

            String envelope = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wrap="http://wrappers.webservice.appservices.core.inteqnet.com" xmlns:xsd="http://beans.webservice.appservices.core.inteqnet.com/xsd"> <soapenv:Header/> <soapenv:Body> <wrap:createChangeRequest> <wrap:credentials>             <xsd:userName>' + username + '</xsd:userName> <xsd:userPassword>' + password + '</xsd:userPassword> </wrap:credentials> <wrap:extendedSettings> <xsd:responseFormat>JSON</xsd:responseFormat> </wrap:extendedSettings> <wrap:chgBean> <xsd:assigned_group_id>' + AssignedGroupId + '</xsd:assigned_group_id> <xsd:ccti_id>' + CCTIId + '</xsd:ccti_id> <xsd:person1_alt_email>'+requestorEmail+'</xsd:person1_alt_email> <xsd:person1_alt_phone>'+requestorPhone+'</xsd:person1_alt_phone> <xsd:person2_alt_email>'+requestedForEmail+'</xsd:person2_alt_email> <xsd:person2_alt_phone>'+requestedForPhone+'</xsd:person2_alt_phone>  <xsd:reason_for_change>' + TicketDescription + '</xsd:reason_for_change> <xsd:requested_for_name>' + RequestedForName + '</xsd:requested_for_name> <xsd:requester_name>' + RequesterName + '</xsd:requester_name> <xsd:ticket_description>' + TicketSubject + '</xsd:ticket_description> </wrap:chgBean> </wrap:createChangeRequest> </soapenv:Body> </soapenv:Envelope>';
            System.Debug('envelope created' + envelope);
            request.setBody(envelope);
            request.setMethod('POST');
            request.setTimeout(120000);
         
            Http http = new Http();
            request.setEndpoint(changeRequestEndpoint);
            request.setHeader('content-type', 'text/xml; charset=utf-8');
            HTTPResponse response = http.send(request); 
            system.debug('request>'+request.getbody());
            system.debug('respone is '+response);
            
            String fullresponse = response.getBody();
            //system.debug('fullresponse>'+fullresponse);
            //system.debug('response.getStatusCode()>'+response.getStatusCode());
            If(response.getStatusCode()==200)
            {
                integer index1 = fullresponse.indexof('200-');
                CRNum = fullresponse.subString(index1, index1+10);
                
                
                String messageToPost = ' Service Desk Ticket : '+CRNum+' created for the SFDC access request : '+AccessRequestNumber+', with approval';
                chatterPost.mentionTextPost(AccessRequestId,Label.SFDC_L2_Group,messageToPost);
                system.debug('in Service last');
                
            } 
            }
            catch (System.CalloutException e) {
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {Label.Access_Request_Super_Admin};                   
                mail.setSubject('Exception raised while creating ServiceDesk for Access request '+AccessRequestNumber);
                mail.setToAddresses(toAddresses);
                mail.setHTMLBody('Exception :'+e);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              
                system.Debug('CalloutException' + e);
            }
            
            return CRNum;
        }
        
        
       
    

}