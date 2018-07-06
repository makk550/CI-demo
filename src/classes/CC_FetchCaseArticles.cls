public without sharing class CC_FetchCaseArticles {
    public static list<knowledge__kav> fetchArticles(Id caseId)
     {
                 
     /* String fetchArticles='SELECT id, KnowledgeArticleVersion.ArticleNumber, KnowledgeArticleVersion.Title,KnowledgeArticleVersion.UrlName,KnowledgeArticleVersion.LastModifiedDate ' + 
        ' FROM CaseArticle ' +
        ' WHERE  KnowledgeArticleVersion.PublishStatus=\'Online\'' +' and  CaseId= \''+ caseId +'\'';
        System.debug('fetchArticles:'+fetchArticles);
        CaseArticle[] carticles = DataBase.query(fetchArticles); //[SELECT KnowledgeArticleVersion.ArticleNumber,KnowledgeArticleVersion.Title FROM CaseArticle  WHERE KnowledgeArticleVersion.PublishStatus='Online' and  CaseId= :caseId];
        //DataBase.query(fetchArticles);
        return carticles;*/
        //List<CaseArticleWrapper> caws = new List<CaseArticleWrapper>();
         List<CaseArticle> cas = [SELECT Id, 
                                        KnowledgeArticleId,
                                        CaseId,
                                        CreatedDate
                                 FROM CaseArticle
                                 WHERE CaseId = :caseId];

        List<String> articleIds = new List<String>();
        for (CaseArticle ca : cas) {
            articleIds.add(ca.KnowledgeArticleId);
        }
        List<knowledge__kav> listOfArticles=new List<Knowledge__kav>();
        Map<String, Knowledge__kav> kavsByArticleId = new Map<String, Knowledge__kav>();
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, ArticleNumber,urlname,LastModifiedDate from Knowledge__kav WHERE KnowledgeArticleId in :articleIds AND PublishStatus = 'Online']) {
            kavsByArticleId.put(kav.KnowledgeArticleId, kav);
            listOfArticles.add(kav);
        }
         return listOfArticles;
     }
    
}