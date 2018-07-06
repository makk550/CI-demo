global class PartnerInfluenceRequestReminder_Batch implements Database.Batchable<sObject>,Database.Stateful {

  // this method is used to get all reocrds that will be processed by execute method
 global Database.QueryLocator start(Database.BatchableContext bc){
   
  // try to use the .type to determine object type in SOQL
  // instead of DescribeSObjectResult apex code
    String query = 'select id,Registration_Status__c,IsEmailSent__c,Approved_Timestamp__c,Second_Approver__c,Third_Approver__c,Third_Approver__r.Email,Second_Approver__r.Email,Opportunity_Name__r.StageName,Createdby.Email from Opportunity_Registration__c where Registration_Status__c =\'Approved\' and Opportunity_Name__r.StageName !=\''+Label.Opp_Stage_Closed_Won+'\' and Opportunity_Name__r.StageName !=\''+Label.Opp_Stage_Closed_Lost +'\' and Approved_Timestamp__c < LAST_N_MONTHS:6 and IsEmailSent__c = false';
     return  Database.getQueryLocator(query);
 } // querylocator start
    
 // find all PIR records and are older than 6 months
 
 global void execute(Database.BatchableContext BC, List<sObject> scope) {
  
  List <Opportunity_Registration__c> lstPIR = new list<Opportunity_Registration__c>();
    for(Sobject s : scope)
    {
        Opportunity_Registration__c a = (Opportunity_Registration__c)s;
        lstPIR.add(a);
    }
     for(Opportunity_Registration__c PIR:lstPIR){
         PartnerInfluenceRequestReminder_Batch.SendReminderEmail(PIR.id,PIR.Second_Approver__c,PIR.Third_Approver__c,PIR.Third_Approver__r.Email,PIR.Createdby.Email);
         PIR.IsEmailSent__c = true;
     }
     Database.upsert(lstPIR);
   
      
 } // end SendReminders
 
 global void finish(Database.BatchableContext info) {
   
 } // finish
 
 public static void SendReminderEmail(Id TargetID,Id SecondApproverID, ID ThirdApproverID , string recepientEmail,String Createduser) {        
              
   
 
    // Make sure this transaction won't fail due to lack of daily capacity
    Messaging.reserveSingleEmailCapacity(1);
 
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
    String[] toAddresses;
     toAddresses = new String[] {recepientEmail}; 
    String[] toCCAddress = new String[] {Createduser};
     email.setTemplateId(Label.PIR_Reminder_Email);
     email.saveAsActivity = false;
     email.setTargetObjectId(SecondApproverID);
     email.setReplyTo('noreply@ca.com');
     email.setOrgWideEmailAddressId(Label.Referral_OrgWideEmailAddress);
     email.setWhatId(TargetID);
     email.setToAddresses(toAddresses);
     email.setCcAddresses(toCCAddress);
        Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
        Messaging.sendEmail(EmailsToSend);
      
 } // end send reminder email

} // end class