global class ArchiveDuplicateArticles implements Database.Batchable <sObject>{
    global final String recordtypeIdValue;
    global final Integer productFlag;
    global ArchiveDuplicateArticles(String recordId,Integer flag){
              recordtypeIdValue = recordId;
              productFlag = flag;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
      String darticles = 'SELECT id,cadocid__c,knowledgearticleid from knowledge__kav where recordtypeid=\''+recordtypeIdValue+'\' and Legacy_source__c=\'ECM\' and Product_Association_update__c='+productFlag+' and publishstatus=\'Draft\' '; 
                   return Database.getQueryLocator(darticles);
      
    }
 
    global void execute(Database.BatchableContext BC, List<knowledge__kav> scope){
        system.debug('Draft Articles...'+scope);
        Try{
            If(scope<>null && scope.size()>0){
                for(knowledge__kav knowledgeObj:scope){
                    try{
                        //System.debug(' knowledgeObj : '+ knowledgeObj);
                        KbManagement.PublishingService.publishArticle(knowledgeObj.KnowledgeArticleId, true);
                        string knowledegArticleIdVal = knowledgeObj.knowledgearticleid;
                        KbManagement.PublishingService.archiveOnlineArticle(knowledegArticleIdVal, null);
                        KbManagement.PublishingService.deleteArchivedArticle(knowledegArticleIdVal);
                    }catch(Exception Er){
                        System.debug('Error Occured: '+er.getMessage());
                    }

                 }      
            }
         }
         
         Catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
          }    
     }
    
     global void finish(Database.BatchableContext BC){
             system.debug(' In Finish Method! ');
     }
    
}