@isTest
public class KCSRatingOnlineBatchUpdate_Test{

    private static List<knowledge__kav> listKnowledgeObj;
    private static List<KBArticle_Average_Rating__c> listAvgRatingObj;
    private static List<KBArticle_Rating__c> listRatingObj;
    
    private static testMethod void method1(){
        Test.startTest();
        createTestData();
        SchedulableContext sc;
        KCSRatingOnlineBatchUpdate bo= new KCSRatingOnlineBatchUpdate();
        bo.execute(sc);
        database.executeBatch(bo);
        Test.stopTest();
        
    }  
    private static testMethod void method2(){
        Test.startTest();
        createTestData();
        KCSRatingArchivedBatchUpdate bo= new KCSRatingArchivedBatchUpdate();
        database.executeBatch(bo);
        Test.stopTest();
        
    }   
    private static void createTestData(){
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
        
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112x';
        knowledgeObj3.UrlName = 'testing12111x';
        knowledgeObj3.Summary = 'testingning121x111';
        knowledgeObj3.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1';
        knowledgeObj3.Product_Names__c = 'CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.IsVisibleInPkb = true;
        knowledgeObj3.Introduction__c = '<a></a>';
        knowledgeObj3.Additional_Information__c = '<a></a>';
        knowledgeObj3.Answer__c = '<a></a>';
        knowledgeObj3.Background__c = '<a></a>';
        knowledgeObj3.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj3);
       
        insert listKnowledgeObj;
        
         knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
         
         knowledgeObj2 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[1].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj2.KnowledgeArticleId, true);

         knowledgeObj3 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[2].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj3.KnowledgeArticleId, true);
         KbManagement.PublishingService.archiveOnlineArticle(knowledgeObj3.KnowledgeArticleId,null);
         System.debug([SELECT Publishstatus FROM knowledge__kav where ArticleNumber =:knowledgeObj3.ArticleNumber]);
         
         listAvgRatingObj=new List<KBArticle_Average_Rating__c>();
         KBArticle_Average_Rating__c AvgRatingObj1 = new KBArticle_Average_Rating__c();
         AvgRatingObj1.Name =knowledgeObj1.ArticleNumber;
         AvgRatingObj1.OwnerId='005a000000Ce4ePAAR';
         AvgRatingObj1.Legacy_Article_Number__c=knowledgeObj1.ArticleNumber;
         AvgRatingObj1.Status__c='Archived';
         listAvgRatingObj.add(AvgRatingObj1);
         
         KBArticle_Average_Rating__c AvgRatingObj2 = new KBArticle_Average_Rating__c();
         AvgRatingObj2.Name =knowledgeObj2.ArticleNumber;
         //AvgRatingObj2.OwnerId='005a000000Ce4ePAAR';
         AvgRatingObj2.Legacy_Article_Number__c=knowledgeObj2.ArticleNumber;
         AvgRatingObj2.Status__c='Archived';
         listAvgRatingObj.add(AvgRatingObj2);
         
         KBArticle_Average_Rating__c AvgRatingObj3 = new KBArticle_Average_Rating__c();
         AvgRatingObj3.Name =knowledgeObj3.ArticleNumber;
         AvgRatingObj3.OwnerId='005a000000Ce4ePAAR';
         AvgRatingObj3.Legacy_Article_Number__c=knowledgeObj3.ArticleNumber;
         AvgRatingObj3.Status__c='Online';
         listAvgRatingObj.add(AvgRatingObj3);
         
         insert listAvgRatingObj;
         
         listRatingObj = new List<KBArticle_Rating__c>();
         KBArticle_Rating__c RatingObj1 = new KBArticle_Rating__c();
         RatingObj1.Name=knowledgeObj1.ArticleNumber;
         RatingObj1.Status__c='Archived';
         listRatingObj.add(RatingObj1);
         
         KBArticle_Rating__c RatingObj2 = new KBArticle_Rating__c();
         RatingObj2.Name=knowledgeObj3.ArticleNumber;
         RatingObj2.Status__c='Online';
         listRatingObj.add(RatingObj2);
         
         insert listRatingObj;
         
         
         
    }
    
}