//Batch Apex for Mass update the Article PublishStatus from Draft to Online.

global class Automic_PublishArticles implements Database.Batchable <sObject>{
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        String darticles = 'SELECT Title, Id, KnowledgeArticleId, PublishStatus, Migrated_Status__c'
              + ' FROM Knowledge__kav ' 
                  +  ' WHERE PublishStatus =\'Draft\' AND Migrated_Status__c=\'Online\' AND Legacy_Source__c  =\'Automic\'';
                   return Database.getQueryLocator(darticles);
      
    } 
 
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope){
        system.debug('Draft Articles...'+scope);
        Try{
            If(scope<>null && scope.size()>0){
                for(Knowledge__kav knowledgeObj:scope){
                    KbManagement.PublishingService.publishArticle(knowledgeObj.KnowledgeArticleId, true);
                    system.debug('publish Article...'+knowledgeObj.KnowledgeArticleId);
                }  
             }
         }
         
         Catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
          }
     }
    
     global void finish(Database.BatchableContext BC){
   
     }
}