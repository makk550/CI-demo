global class DealRegistrationRequestReminder_Batch implements Database.Batchable<sObject>,Database.Stateful {


	  // this method is used to get all reocrds that will be processed by execute method
 global Database.QueryLocator start(Database.BatchableContext bc){
   
  // try to use the .type to determine object type in SOQL
  // instead of DescribeSObjectResult apex code
    String query = 'select id,Emailbefore5days__c,Deal_Expiration_Date__c,Deal_Registration_Status__c,Source__c,Reseller_Contact__c,Reseller_Contact__r.Email,Additional_Emails__c from opportunity where  Source__c=\'Deal Registration\' and Deal_Registration_Status__c=\'Sale Approved\' and Deal_Expiration_Date__c!=Null';
   return  Database.getQueryLocator(query);
 } // querylocator start


global void execute(Database.BatchableContext BC, List<sObject> scope) {
  
  List <Opportunity> listdelreg = new list<Opportunity>();
    
  for(Sobject s : scope)
  {
        Opportunity a = (Opportunity)s;
    listdelreg.add(a);
  }
    if(listdelreg.size()>0){
     for(Opportunity DLR:listdelreg){
	 
	 if(DLR.Emailbefore5days__c==date.today() && DLR.Deal_Registration_Status__c=='Sale Approved')
	 {
         
         DealRegistrationRequestReminder_Batch.SendReminderEmailsbefore5days(DLR.id,DLR.Reseller_Contact__c,DLR.Reseller_Contact__r.Email,DLR.Additional_Emails__c);
       
	}	 
     }
    }
 } // end SendReminders


global void finish(Database.BatchableContext info) {
   
 } // finish

public static void SendReminderEmailsbefore5days(Id TargetID,id Contactid,string recepientEmail,String Additionalemails) {        
              
    /** << Insert code here for other objects & email templates >> **/
 
    // Make sure this transaction won't fail due to lack of daily capacity
    Messaging.reserveSingleEmailCapacity(1);
 
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
    String[] toAddresses=new String[]{};
	if(Additionalemails!=null && Additionalemails!=''){
	toAddresses=Additionalemails.split(';');
	
	}
	toAddresses.add(recepientEmail); 
     email.setTemplateId(Label.Dealreg_Reminder);
     email.saveAsActivity = false;
     email.setTargetObjectId(Contactid);
     email.setWhatId(TargetID);
     email.setToAddresses(toAddresses);
        Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
        Messaging.sendEmail(EmailsToSend);
      
 } // end send reminder email


}