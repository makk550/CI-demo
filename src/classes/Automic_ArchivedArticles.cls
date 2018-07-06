//Batch Apex for Mass update the Article PublishStatus from Draft to Archived

global class Automic_ArchivedArticles implements Database.Batchable <sObject>{
 
    global Database.QueryLocator start(Database.BatchableContext BC){
      String darticles = 'SELECT Title, Id, KnowledgeArticleId, PublishStatus, Migrated_Status__c'
              + ' FROM Knowledge__kav '
                  +  ' WHERE PublishStatus =\'Draft\' AND Migrated_Status__c=\'Archived\' AND Legacy_Source__c  =\'Automic\''; 
                   return Database.getQueryLocator(darticles);
      
    }
 
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope){
        system.debug('Draft Articles...'+scope);
        Try{
            If(scope<>null && scope.size()>0){
                for(Knowledge__kav knowledgeObj:scope){
                    KbManagement.PublishingService.publishArticle(knowledgeObj.KnowledgeArticleId, true);
                    string knowledegArticleIdVal = knowledgeObj.KnowledgeArticleId;
                    KbManagement.PublishingService.archiveOnlineArticle(knowledegArticleIdVal, null);
                    system.debug('Archived Article...'+knowledegArticleIdVal);
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