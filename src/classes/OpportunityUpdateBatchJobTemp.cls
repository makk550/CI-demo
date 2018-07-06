global class OpportunityUpdateBatchJobTemp implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
       	String id1='006a000001LLfjl';
        //Set<id> oppids=new Set<id>{'006a000001LMC8DAAX','006a000001LME1eAAH','006a000001LMEThAAP','006a000001LMEcMAAX','006a000001LMEecAAH','006a000001LMEl2AAH','006a000001LMF43AAH','006a000001LMGOVAA5','006a000001LMGzYAAX','006a000001LMHDIAA5','006a000001LMHUYAA5','006a000001LMISYAA5','006a000001LMJnHAAX','006a000001LMJqpAAH','006a000001LMJrYAAX','006a000001LMKcyAAH','006a000001LMMDXAA5','006a000001LMMGCAA5','006a000001LMMIHAA5','006a000001LMMJPAA5','006a000001LMMJnAAP','006a000001LMMmNAAX','006a000001LMMn1AAH','006a000001LMMnHAAX','006a000001LMMnYAAX','006a000001LMMnpAAH'};
        
        //String OppType='PNCV';
        String query='SELECT id,Route__c,Type,Contract_Type__c,PrimaryPartner4__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,Name,Reseller__c,Distributor_6__c,AccountId,partner_1__c,Alliance_Partner_2__c,Technology_Partner__c,PrimaryPartner4__r.RecordType.Name,Account.Coverage_Model__c,Account.Account_Type__c,PrimaryPartner4__r.Coverage_Model__c from Opportunity where CreatedDate>=2017-01-22T00:00:00Z and Route__c=null' ;
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
        String[] toAddresses = new String[] {'samtu01@ca.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}