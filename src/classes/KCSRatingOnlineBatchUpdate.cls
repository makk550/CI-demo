global class KCSRatingOnlineBatchUpdate implements Database.Batchable<sObject>,Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ArticleNumber,PublishStatus FROM Knowledge__kav where PublishStatus =\'Online\' and lastmodifiedDate=LAST_N_DAYS:1';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope) {
        
        List<KBArticle_Average_Rating__c> avgratingRecords=new List<KBArticle_Average_Rating__c>();
        List<KBArticle_Rating__c> ratingRecords=new List<KBArticle_Rating__c>();
        Map<String,Knowledge__kav> NameMap = new Map<String,Knowledge__kav>();
        for(Knowledge__kav know: scope)
        {
                NameMap.put(know.ArticleNumber,know);
        }
        for(KBArticle_Average_Rating__c avgrating :[SELECT id,Name, Status__c FROM KBArticle_Average_Rating__c where Name IN :NameMap.keyset()]){
            if(avgrating.Status__c != NameMap.get(avgrating.Name).PublishStatus){
                avgrating.Status__c =NameMap.get(avgrating.Name).PublishStatus;
            }
            avgratingRecords.add(avgrating);
        }
         
        
        for(KBArticle_Rating__c rating :[SELECT id,Name,Status__c FROM KBArticle_Rating__c where Name IN :NameMap.keyset()]){
            if(rating.Status__c != NameMap.get(rating.Name).PublishStatus){
                rating.Status__c =NameMap.get(rating.Name).PublishStatus;
            }
            ratingRecords.add(rating);
        } 
        
        
        if(avgratingRecords.size()>0){
            //update avgratingRecords;
            Database.update(avgratingRecords);
        }
        if(ratingRecords.size()>0){
            //update ratingRecords;
            Database.update(ratingRecords);
            
        }
    }
    global void execute(SchedulableContext sc){
        
        KCSRatingOnlineBatchUpdate bo= new KCSRatingOnlineBatchUpdate();
        database.executeBatch(bo);
    }   
    
    global void finish(Database.BatchableContext BC) {
        KCSRatingArchivedBatchUpdate ba= new KCSRatingArchivedBatchUpdate();
        database.executeBatch(ba);
    }
}