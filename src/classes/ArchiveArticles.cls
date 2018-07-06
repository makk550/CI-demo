//Batch Apex for Mass update the Article PublishStatus from Draft to Archived

global class ArchiveArticles implements Database.Batchable <sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String darticles = 'SELECT Title, Id, KnowledgeArticleId,articlenumber, PublishStatus, Migrated_Status__c'
            + ' FROM Knowledge__kav '
            +  ' WHERE Migrated_Status__c=\'Retired\' and PublishStatus =\'draft\' AND Legacy_Source__c  =\'ECM\' AND Product_Association_update__c =2'; 
        return Database.getQueryLocator(darticles);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> scope){
        system.debug('Draft Articles...'+scope);
        Try{
            If(scope<>null && scope.size()>0){
                for(Knowledge__kav knowledgeObj:scope){
                    try{
                        
                        KbManagement.PublishingService.publishArticle(knowledgeObj.KnowledgeArticleId, true);
                        string knowledegArticleIdVal = knowledgeObj.KnowledgeArticleId;
                        KbManagement.PublishingService.archiveOnlineArticle(knowledegArticleIdVal, null);
                        // system.debug('Archived Article...'+knowledegArticleIdVal);
                    }catch(Exception er){
                        System.debug(' Exception Occured while Retiring Articl : '+ knowledgeObj.articlenumber+' with Message :'+er.getMessage());
                    }
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