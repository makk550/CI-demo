Public class LeadDeleteNotification{

Public Static void readrecord(List<lead> leadLst,String Name,string[] email2)
{

String DeletedUser =Name; 
Set<String> distinctRT = new Set<string>();
Set<String> DetailLink= new Set<string>();
String finalList = '';//'Lead Name' + '\n'; as per sneha
String link='';
String le;
List<lead> leadDelLst =new List<lead>();
leadDelLst =leadLst;
ID idLead;
//distinctRT.add('DELETED LEAD ALERT!\n'); as per sneha


for (lead l:leadDelLst){
     
     distinctRT.add(l.FirstName+' '+l.LastName); 
    //distinctRT.add('https://na13.salesforce.com/'+ idLead ) ;
     DetailLink.add(URL.getSalesforceBaseUrl().toExternalForm()+'/'+ l.id ); //BAJPI01, changing as part of US352411 - removing hardcoding of base URL.

}
for (String s: distinctRT){
    //string line = s + '\n'; 
    finalList += s; 
    le=finalList;
   
}

for (String s: DetailLink){
    //string line = s + '\n'; 
    link+= s; 
    
   
}
 String bodystatement='';
 bodystatement+='\n'+'DELETED LEAD ALERT!';
 bodystatement+='\n'+'\n'+'Lead:'+le;
 bodystatement+= '\n'+'Lead ID:'+'\n'+link+'\n';
 
bodystatement+= '\n' +  'No leads should be deleted from the system.  Please update the lead to the correct status to';
bodystatement+= '\n' +  'reflect the reason it is no longer valid.\n';
bodystatement+= '\n' +  'Thanks!';

       
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalList);
        string csvname= 'Leadnamedistinct.xls';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses=email2;
        String subject ='Deleted Lead Alert - SFDC Lead:'+le;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(bodystatement);
        
        //email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
}

}