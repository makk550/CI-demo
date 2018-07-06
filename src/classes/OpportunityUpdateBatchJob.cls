global class OpportunityUpdateBatchJob implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
       
        String query='SELECT id,Route__c,Type,Contract_Type__c,PrimaryPartner4__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,Name,Reseller__c,Distributor_6__c,AccountId,partner_1__c,Alliance_Partner_2__c,Technology_Partner__c,PrimaryPartner4__r.RecordType.Name,Account.Coverage_Model__c,Account.Account_Type__c,PrimaryPartner4__r.Coverage_Model__c from Opportunity where CreatedDate>= LAST_N_DAYS:1 and Route__c=null' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) 
    {
        Set<id> Oppidlist = new Set<id>();
        
        for(Opportunity o:scope){
            oppidlist.add(o.id);
        }
        
        System.debug('----size----'+oppidlist.size());
        
        
            PrimaryPartner.updateOpportunity(oppidlist);
            
       
       
    }
    global void finish(Database.BatchableContext BC) 
    {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'Team-GIS-Cavalry@ca.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}