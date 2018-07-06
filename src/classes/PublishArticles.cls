//Batch Apex for Mass update the Article PublishStatus from Draft to Online.

global class PublishArticles implements Database.Batchable <sObject>{
   global String recordId;
    global String migratedStatus;
    global Integer limitValue;
    //ka10S0000004IVgQAM
    
    global PublishArticles(String recordIdValue, String migStatus, Integer limitVal){
        recordId = recordIdValue;
        migratedStatus = migStatus;
        limitValue = limitVal;
    }
       
    global Database.QueryLocator start(Database.BatchableContext BC){
        String darticles = 'SELECT Title, Id, KnowledgeArticleId,articlenumber, PublishStatus, Migrated_Status__c'
              + ' FROM Knowledge__kav ' 
                  +  ' WHERE Product_Association_update__c=2 and recordtypeid=\''+recordId+'\' and migrated_status__c=\''+migratedStatus+'\' and PublishStatus =\'Draft\' AND Legacy_Source__c  =\'ECM\' limit '+limitValue+' ';
                   return Database.getQueryLocator(darticles);
      
    } 
 
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope){
        system.debug('Draft Articles...'+scope);
        
        If(scope<>null && scope.size()>0){
            for(Knowledge__kav knowledgeObj:scope){
                try{
                    KbManagement.PublishingService.publishArticle(knowledgeObj.KnowledgeArticleId, false);
                   // system.debug('publish Article...'+knowledgeObj.articlenumber);
                }
                Catch(Exception e) {
                    System.debug('An exception occurred in Article : '+ knowledgeObj.articlenumber+' with an Error : '+e.getMessage());
                }
            }  
        }
        
    }
    
     global void finish(Database.BatchableContext BC){
   
     }
}