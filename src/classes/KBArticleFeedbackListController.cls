public class KBArticleFeedbackListController {
    
    public String articleNumber {get; set;}

    public KBArticleFeedbackListController(){
        articleNumber = ApexPages.currentPage().getParameters().get('aNumber');
        system.debug(articleNumber);
    }
    
    public KBArticle_Rating__c articleRecord{
        get{
        if(articleRecord == null && articleNumber != null){
            List<KBARticle_Rating__c> articleList = [SELECT Name
                                    FROM KBARticle_Rating__c
                                    WHERE Name = :articleNumber];
            
            if(articleList != null && articleList.size() > 0 ) {
                articleRecord = articleList[0];
            }
        }
        return articleRecord ;
    }
    set;
    }
    
    public Knowledge__kav articleKnowledgeRecord {
       get{
        if(articleKnowledgeRecord == null && articleNumber != null){
            List<Knowledge__kav> articleList = [SELECT Id, KnowledgeArticleId, Title
                                    FROM Knowledge__kav
                                    WHERE articleNumber = :articleNumber and publishstatus='Online'];
            
        if(articleList.size()==0) { 
             articleList = [SELECT Id, KnowledgeArticleId, Title
                                    FROM Knowledge__kav
                                    WHERE articleNumber = :articleNumber and publishstatus='Archived'];
         } 
            
            if(articleList != null && articleList.size() > 0 ) {
                articleKnowledgeRecord = articleList[0];
            }
                 
        }
        return articleKnowledgeRecord ;
    }
    set;
}

    
}