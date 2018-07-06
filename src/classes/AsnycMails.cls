public class AsnycMails
{
    //comments have been removed from the code , since for bulk load the number of executed script statements was crossing the limit.
    //try catch have been removed from the code , since for bulk load the number of executed script statements was crossing the limit.
    @future
    public static void sendassignmentemail(Set<ID> leadids)
    {
        List<Lead> updatedleads = [select CIDB_Campaign_Name__c,ID,OwnerID,Owner.Name,Owner.Email,FirstName,LastName,Owner.FirstName,Company,MKT_BU_Category__c,MKT_Solution_Set__c,Description from lead where Id in: leadids];
        if(updatedleads.size()>0){
                Messaging.Singleemailmessage[] mess = new Messaging.Singleemailmessage[]{};
                for(Integer leadcount=0;leadcount<updatedleads.size();leadcount++){
                    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
                    string leaddescription = '';
                    string ncv = '';
                    if(updatedleads[leadcount].Description!=null)
                        leaddescription = updatedleads[leadcount].Description;
                    if(updatedleads[leadcount].MKT_Solution_Set__c!=null)
                        ncv = updatedleads[leadcount].MKT_Solution_Set__c;  
                    mail.setToAddresses(new String[] {updatedleads[leadcount].Owner.Email});
                    string ownername = '';
                    if(updatedleads[leadcount].Owner.FirstName==null)
                        ownername = updatedleads[leadcount].Owner.Name;
                    else
                        ownername = updatedleads[leadcount].Owner.FirstName;
                    mail.setSubject('New Lead notification - '+updatedleads[leadcount].FirstName+' '+updatedleads[leadcount].LastName);
                    string strbody = '<img src="https://na1.salesforce.com/resource/1256157168000/CA_Logo" /><br>';
                    strbody += 'Dear '+ownername+',<br><br>This message is to inform you that the following new Lead has been assigned to you. Please review and action this Lead as appropriate.<br><br>Click here to go to the lead in SFDC.<br><a href="https://login.salesforce.com/'+updatedleads[leadcount].Id+'">https://login.salesforce.com/'+updatedleads[leadcount].Id+'</a><br><br>Lead details:<br>Lead Name:  '+updatedleads[leadcount].FirstName+' '+updatedleads[leadcount].LastName+'<br>Company:  '+updatedleads[leadcount].Company+'<br>BU: '+updatedleads[leadcount].MKT_BU_Category__c+'<br>NCV Driver: '+ncv+'<br>Description: '+leaddescription+'<br>MKTDB Campaign Name: '+ updatedleads[leadcount].CIDB_Campaign_Name__c +'<br><br>If you need any assistance with the above, please reach out to your local Sales Operations contact.<br><br>Thank You';
                    mail.setHtmlBody(strbody);
                    mess.add(mail);}
                Messaging.sendEmail(mess); 
        }
    }
    
    public static testMethod void AsnycMailsTest(){
       
           Set<ID> ids = new Set<ID>(); 
     List<Lead> updatedleads = [select   CIDB_Campaign_Name__c,ID,OwnerID,Owner.Name,Owner.Email,FirstName,LastName,Owner.FirstName,Company,MKT_BU_Category__c,MKT_Solution_Set__c,Description from lead Where Company != null and  MKT_BU_Category__c != null and MKT_Solution_Set__c != null and email != null and Owner.Email != null Limit 10  ];
 
    for (Lead l : updatedleads )
    {
       ids.add(l.id);  
    }
    
    Test.startTest();
    if (ids.size() > 0 )
    AsnycMails.sendassignmentemail(ids );
    Test.stopTest();
    
    }//end test method 
    
}