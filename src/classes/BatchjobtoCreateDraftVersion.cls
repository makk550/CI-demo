//batch job to update image links
global class BatchjobtoCreateDraftVersion implements Database.Batchable<sObject>, Database.stateful{

    global List<Knowledge__kav> listOfUpdatedArticle;
    global Map<String,String> mapOfArticle;
    global set<String> setOfDocumentName;
    global set<String> listOfArtciles;
    global String recordid;
    global String migratedstatus;
    global Integer limitValue;
    //ka10S0000004IVgQAM
    //
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        setOfDocumentName = new set<String>();
        mapOfArticle = new Map<String,String>();
        listOfUpdatedArticle = new List<Knowledge__kav>();
        listOfArtciles = new set<String>();
        String listOfECMArticles = 'Select LegacyArticleNumber__c from Temp_ECM_KB_Links_Update__c';
        return Database.getQueryLocator(listOfECMArticles);   
    }
    
    global void execute(Database.BatchableContext bc, List<Temp_ECM_KB_Links_Update__c> listOfArticles){
        
        if(listOfArticles <> null && listOfArticles.size() > 0){
            Set<String> setOfArticles= new set<String>();
            for(Temp_ECM_KB_Links_Update__c ecmObj: listOfArticles){
                if(String.isNotBlank(ecmObj.LegacyArticleNumber__c)){
                    setOfArticles.add(ecmObj.LegacyArticleNumber__c);
                }
            }
            if(setOfArticles <> null && setOfArticles.size() > 0){
                
                List<knowledge__kav> listOfArticle = [select id,ArticleNumber, KnowledgeArticleId from Knowledge__kav where publishstatus='Online' and ArticleNumber IN:setOfArticles ];
                
                if(listOfArticle <> null && listOfArticle.size() > 0){
                    System.debug(' Articles Count : '+ listOfArticle.size());
                    for(Knowledge__kav articleObj:listOfArticle){
                            Boolean flag = false;
                            String knowledge_Article_id=articleObj.KnowledgeArticleId;
                            //System.debug(' Url Not updated : Yes '+articleObj.ArticleNumber );
                            try{
                                
                                String id = KbManagement.PublishingService.editOnlineArticle(knowledge_Article_id,false);
                                System.debug(' Article : '+ articleObj.ArticleNumber+ ' is created draft version!');
                                
                            }catch(Exception er){
                                System.debug(' Article : '+ articleObj.articleNumber +' is failed to covert into draft with error : '+ er.getMessage());
                            }
                        
                    }   
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(' In Method- Finish ----');
        System.debug('  These are the which are not converted in draft');
    }     
    
}