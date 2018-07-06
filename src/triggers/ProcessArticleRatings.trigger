trigger ProcessArticleRatings  on KBArticle_Rating__c (after delete, after insert, after update) {
 
   //TODO Move the entire logic from trigger to a class.
    //Limit the size of list by using Sets which do not contain duplicate elements
    Set<Id> ArticleIds = new Set<Id>();
    //When adding new article ratings or updating existing ratings
    if(trigger.isInsert || trigger.isUpdate){
        for(KBArticle_Rating__c p : trigger.new){
          ArticleIds.add(p.KBArticle_Average_Rating__c);
        }
    }
    
    //When deleting ratings
    if(trigger.isDelete){
        for(KBArticle_Rating__c p : trigger.old){
          ArticleIds.add(p.KBArticle_Average_Rating__c);
        }
    }
    
    //Map will contain one Article Id to one sum value
    map<Id, Double > articleAverageRatingMap = new map<Id, Double >();
    map<Id, Integer > articleVoteCountMap = new map<Id, Integer>(); 
    //Produce a sum of ratings and add them to the map
    //use group by to have a single Article Id with a single sum value
    for(AggregateResult q : [SELECT KBArticle_Average_Rating__c,AVG(Article_Rating__c), COUNT(ID)
                                FROM KBArticle_Rating__c 
                                WHERE KBArticle_Average_Rating__c IN :ArticleIds AND Article_Rating__c != null
                                GROUP BY KBArticle_Average_Rating__c]){
        articleAverageRatingMap.put((Id)q.get('KBArticle_Average_Rating__c'),(Double)q.get('expr0'));
        articleVoteCountMap.put((Id)q.get('KBArticle_Average_Rating__c'),(Integer)q.get('expr1'));
    }
    
    List<KBArticle_Average_Rating__c> ArticlesToUpdate = new List<KBArticle_Average_Rating__c>();
     
    //Run the for loop on Article using the non-duplicate set of Article Ids
    //Get the sum value from the map and create a list of Article records to update
    for(KBArticle_Average_Rating__c articleRec : [Select Id,Name, Average_Score__c from KBArticle_Average_Rating__c where Id IN :ArticleIds]){
        articleRec.Average_Score__c = articleAverageRatingMap.get(articleRec.Id);
        articleRec.Vote_Count__c = articleVoteCountMap.get(articleRec.Id);
        ArticlesToUpdate.add(articleRec);
    }
    update ArticlesToUpdate;
}