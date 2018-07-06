@isTest
public class KBArticleFeedbackListController_Test{

    private static List<knowledge__kav> listKnowledgeObj;
    private static List<KBArticle_Average_Rating__c> listAvgRatingObj;
    private static List<KBArticle_Rating__c> listRatingObj;

  
    private static testMethod void method1(){
        Test.startTest();
        
       // KBArticleFeedbackListController con =new KBArticleFeedbackListController();
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        
         listKnowledgeObj = new List<knowledge__kav>();
         knowledge__kav knowledgeObj1 = new knowledge__kav();
         knowledgeObj1.Title = 'test111';
         knowledgeObj1.UrlName = 'testing1111';
         knowledgeObj1.Summary = 'testingning11111';
         knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
         knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
         knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
         knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
         knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
         knowledgeObj1.Content1__c='Issue';
         knowledgeObj1.Content2__c = 'Resolution';
         //knowledgeObj1.PublishStatus ='Online';
         listKnowledgeObj.add(knowledgeObj1);
         insert listKnowledgeObj;
         
         knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
         
           listAvgRatingObj=new List<KBArticle_Average_Rating__c>();
          
           KBArticle_Average_Rating__c AvgRatingObj1 = new KBArticle_Average_Rating__c();
           AvgRatingObj1.Name =knowledgeObj1.ArticleNumber;
           AvgRatingObj1.Status__c='Online';
           listAvgRatingObj.add(AvgRatingObj1);
           insert listAvgRatingObj;
         
           listRatingObj = new List<KBArticle_Rating__c>();
           
           KBArticle_Rating__c RatingObj1 = new KBArticle_Rating__c();
           RatingObj1.Name=knowledgeObj1.ArticleNumber;
           RatingObj1.Status__c='Online';
           listRatingObj.add(RatingObj1);
           insert listRatingObj;
         
         apexpages.currentPage().getParameters().put('aNumber', knowledgeObj1.ArticleNumber);
         system.Debug('article number:'+ knowledgeObj1.ArticleNumber);
         
         KBArticleFeedbackListController con =new KBArticleFeedbackListController();
         System.assertEquals(con.articleKnowledgeRecord, [SELECT Id, KnowledgeArticleId, Title FROM Knowledge__kav WHERE (articleNumber = :knowledgeObj1.ArticleNumber AND publishstatus = 'Online')]);
         
         Test.stopTest(); 
    }  
    
     private static testMethod void method2(){
        Test.startTest();
        
        
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj2 = new knowledge__kav();
        knowledgeObj2.Title = 'test11112';
        knowledgeObj2.UrlName = 'testing12111';
        knowledgeObj2.Summary = 'testingning121111';
        knowledgeObj2.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1';
        knowledgeObj2.Product_Names__c = 'CA PPM';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.IsVisibleInPkb = true;
        knowledgeObj2.Introduction__c = '<a></a>';
        knowledgeObj2.Additional_Information__c = '<a></a>';
        knowledgeObj2.Answer__c = '<a></a>';
        knowledgeObj2.Background__c = '<a></a>';
        knowledgeObj2.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj2);
        
        insert listKnowledgeObj;
        
        
         
         
         knowledgeObj2 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj2.KnowledgeArticleId, true);
         KbManagement.PublishingService.archiveOnlineArticle(knowledgeObj2.KnowledgeArticleId,null);
         
         listAvgRatingObj=new List<KBArticle_Average_Rating__c>();
         
        
         KBArticle_Average_Rating__c AvgRatingObj2 = new KBArticle_Average_Rating__c();
         AvgRatingObj2.Name =knowledgeObj2.ArticleNumber;
         AvgRatingObj2.Status__c='Archived';
         listAvgRatingObj.add(AvgRatingObj2);
         
         insert listAvgRatingObj;
         
         listRatingObj = new List<KBArticle_Rating__c>();
         KBArticle_Rating__c RatingObj2 = new KBArticle_Rating__c();
         RatingObj2.Name=knowledgeObj2.ArticleNumber;
         RatingObj2.Status__c='Archived';
         listRatingObj.add(RatingObj2);
         
         insert listRatingObj;
         
        // Test.setCurrentPageReference(new PageReference('Page.KBArticleFeedbackList')); 
         apexpages.currentPage().getParameters().put('aNumber', knowledgeObj2.ArticleNumber);
         KBArticleFeedbackListController con =new KBArticleFeedbackListController();
         System.assertEquals(con.articleRecord, [SELECT Name FROM KBARticle_Rating__c WHERE Name = :knowledgeObj2.ArticleNumber]);
         System.assertEquals(con.articleKnowledgeRecord, [SELECT Id, KnowledgeArticleId, Title FROM Knowledge__kav WHERE (articleNumber = :knowledgeObj2.ArticleNumber AND publishstatus = 'Archived')]);
         system.Debug('article number:'+ knowledgeObj2.ArticleNumber);
         Test.stopTest(); 
         
    }
 
    
         
}