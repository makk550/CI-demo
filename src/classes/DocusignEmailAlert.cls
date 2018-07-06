public class DocusignEmailAlert {
        
        List<String> sendTo = Label.DocusignEmailAlertList.split(',');
        
    public void sendAlert(String body) { 
      
      body+='<br/>  <br/> Regards <br/>SFDC Team </p>';
      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      
      //sendTo.add('godva01@ca.com');
      //sendTo.add('allha02@ca.com');
     
      mail.setToAddresses(sendTo);
    
      mail.setReplyTo('noreply@ca.com');
      mail.setSenderDisplayName('DocuSignAlert');
      mail.setSubject('DocuSign SOX Fields Modify Alert');
      mail.setHtmlBody(body);
      
      
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


    }
}