/*************************************************************************************************************************
*   This is a Schedule class that Sends an Email everyday with EAI - Account & TAQ Account Failure Summary. 
*   This class can be scheduled to run as required at a specific time.
*   Execute performs following:
*       1. Query for the failed EAI Sycn for Account & TAQ Account records count.
*       2. Instantiate Email Method & set the parameters.
*       3. Send an Email to EAI Administrators to correct the Data Error.
*
* Version   Date            Owner                         Description
****************************************************************************************************
* 1.0       23/03/2015      Manikandan Raju               Created.
**************************************************************************************************
        ScheduleEAISyncFailSendEmail p = new ScheduleEAISyncFailSendEmail();
        String sch = '0 0 7 * * ?';
        system.schedule('EAI Sync Failure Summary Send Email', sch, p);
***************************************************************************************************/

/*

    Don't hardcode the list views
    Use Exception Handling


*/
global class ScheduleEAISyncFailSendEmail implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {
        //Collect the count of EAI - Account & TAQ Account Sync failed records.
        Integer EAIAccountSyncFailCount = [Select count() FROM Account WHERE Error_Code_MDM__c != null];
        Integer EAITAQAccountSyncFailCount = [Select count() FROM TAQ_Account__c WHERE Error_Code_MDM__c != null];
      
        //Form email message to be mailed indicating number of records failed during Sync*/
        String bodyStr='Dear Team'+',<br/> <br/>Please note that Account (Count '+EAIAccountSyncFailCount+') failed to sync with EAI due to data error and the List of failed records can be found in the below list views,'+ 
                '<br/><br/>Click on the link below'+
                '<br/><a href='+Label.Account_List_View+'>Account List view'+'</a>'+
                '<br/><br/>Similarly TAQ Account Count'+EAITAQAccountSyncFailCount+' Failed to sync with EAI. Click on the link below to see the failed TAQ Accounts'+
                '<br/><a href='+Label.TAQ_Account_List+'>TAQ Account List view'+'</a>'+
                '<br/><br/>Please correct the data errors to sync the records'+
                '<br/><br/>Regards,<br/>Salesforce Team<br /><br />'; 

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Set the parameters for sending the email
        String[] toAddresses = new String[] {'TeamSFDCAccountMaintenance@ca.com '};
        string fromaddress = 'Support@salesforce.com';
        //String[] toAddresses = new String[] {'krivi06@ca.com '};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSubject('EAI Failure - Account & TAQ Account Summary ' );
        mail.setHtmlBody(bodyStr); 
        mail.setSenderDisplayName(fromaddress);

        //Send Email
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(EmailException ex){
            System.debug( '****Exception while sending Email on EAI Failure Summary ***'+ex );
        }
    }
}