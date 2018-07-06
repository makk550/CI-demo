/*	RevRec----US410669 
	Batch Job to delete Old Opportunity Line Items
	merha02
*/

global class  RevRec_OliDeletion_BatchJob implements Database.Batchable<sObject> {

   global Database.QueryLocator start(Database.BatchableContext BC){
     // id temp='006a000001Ng24cAAB';
      String query='select Id from OpportunityLineItem where Active_Contract_Product__c!=null and Active_Contract_Line_Item__c=null and RevRec_Conversion__c=true ';
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oliList){
      // OpportunityLineItemGateway.RevRec_Deletion_flag=true;
       if(oliList!=null && oliList.size()>0){
          delete oliList;
          Database.emptyRecycleBin(oliList);
       }
     
    }

   global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
       // from Database.BatchableContext.
       // Query the AsyncApexJob object to retrieve the current job's information.
       AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
          TotalJobItems, CreatedBy.Email
          FROM AsyncApexJob WHERE Id =
          :BC.getJobId()];
       // Send an email to the Apex job's submitter notifying of job completion.
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Apex Sharing Recalculation ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
   }
}