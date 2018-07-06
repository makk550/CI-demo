@isTest
public class KBArticleFeedbackController_Test {
     private static List<knowledge__kav> listKnowledgeObj;
     private static List<KBArticle_Average_Rating__c> listAvgRatingObj;
     private static List<KBArticle_Rating__c> listRatingObj;
    
     private static testMethod void method1(){
         Test.startTest();
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
           listKnowledgeObj.add(knowledgeObj1);
            
           insert listKnowledgeObj;
         
            knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber,CADocid__c FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
            KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
           
            KBArticleFeedbackController con=new KBArticleFeedbackController();
         
               con.aId = knowledgeObj1.KnowledgeArticleId;
               con.aNumber = knowledgeObj1.ArticleNumber;
               con.legArticleNumber = knowledgeObj1.CADocid__c;
               con.contactName = 'Test';
               con.contactEmail = 'test@test.com';
               con.feedbackComment = 'Testing controller';
               con.thumbsUpDownRating = 100;
                           
         con.incrementVoteCount();
         System.assertEquals(con.thumbsUpDownRating,100);
         System.assertEquals(con.renderGreyThumbsUp,false);
         System.assertEquals(con.renderGreyThumbsDown,true);
         System.assertEquals(con.renderContactPanel,true);
         
         con.decrementVoteCount();
         System.assertEquals(con.thumbsUpDownRating, 20);
         System.assertEquals(con.renderGreyThumbsUp,true);
         System.assertEquals(con.renderGreyThumbsDown,false);
         System.assertEquals(con.renderContactPanel,true);
         
         con.save();
         
         con.reset();       
         System.assertEquals(con.renderFeedbackInput,true);
         System.assertEquals(con.renderGreyThumbsUp,true);
         System.assertEquals(con.renderGreyThumbsDown,true);
         System.assertEquals(con.renderContactPanel,false);
         System.assertEquals(con.disableSubmitFeedback,true);
         System.assertEquals(con.thumbsUpDownRating,0);
         System.assertEquals(con.contactName,'');
         System.assertEquals(con.contactEmail,'');
         System.assertEquals(con.feedbackComment,'');
         
         con.backToArticle();
         con.first();
         con.last();
         con.previous();
         con.next();
        
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
            knowledgeObj2.CADocid__c = '';
            listKnowledgeObj.add(knowledgeObj2);
            
            insert listKnowledgeObj;
          
            knowledgeObj2 = [SELECT KnowledgeArticleId,ArticleNumber,CADocid__c FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
            KbManagement.PublishingService.publishArticle(knowledgeObj2.KnowledgeArticleId, true);
         
             listAvgRatingObj=new List<KBArticle_Average_Rating__c>();
             KBArticle_Average_Rating__c AvgRatingObj1 = new KBArticle_Average_Rating__c();
             AvgRatingObj1.Name =knowledgeObj2.ArticleNumber;
             AvgRatingObj1.Legacy_Article_Number__c=knowledgeObj2.ArticleNumber;
             AvgRatingObj1.Status__c='Online';
             listAvgRatingObj.add(AvgRatingObj1);
             insert listAvgRatingObj;
             
             listRatingObj = new List<KBArticle_Rating__c>();
             KBArticle_Rating__c RatingObj1 = new KBArticle_Rating__c();
             RatingObj1.Name=knowledgeObj2.ArticleNumber;
             RatingObj1.Status__c='Online';
             RatingObj1.Article_Rating__c=100;
             listRatingObj.add(RatingObj1);
             
             insert listRatingObj;
             
         
           KBArticleFeedbackController con=new KBArticleFeedbackController();
         
           AvgRatingObj1 = [SELECT ID,Name,Average_Score__c,Vote_Count__c FROM KBArticle_Average_Rating__c WHERE Id = :listAvgRatingObj[0].Id];
           
           con.aId = knowledgeObj2.KnowledgeArticleId;
           con.aNumber = knowledgeObj2.ArticleNumber;
           con.legArticleNumber = knowledgeObj2.CADocid__c;
           con.contactName = 'Test';
           con.contactEmail = 'test@test.com';
           con.feedbackComment = 'Testing controller';
           con.thumbsUpDownRating = 100;
               
                        
          // System.assertEquals(con.avgRating,['SELECT '+AvgRatingObj1.ID+', '+AvgRatingObj1.Name+','+ AvgRatingObj1.Average_Score__c+','+ AvgRatingObj1.Vote_Count__c+' FROM KBArticle_Average_Rating__c WHERE Name = :knowledgeObj2.ArticleNumber']);
          // con.averageArticleRating = AvgRatingObj1.Average_Score__c;
          // con.articleVoteCount = AvgRatingObj1.Vote_Count__c;
          // System.assertEquals(con.averageRatingTitle, 'Average Rating : '+con.averageArticleRating+' from '+con.articleVoteCount+' ratings');
                
         con.incrementVoteCount();
         System.assertEquals(con.thumbsUpDownRating,100);
         System.assertEquals(con.renderGreyThumbsUp,false);
         System.assertEquals(con.renderGreyThumbsDown,true);
         System.assertEquals(con.renderContactPanel,true);
         
         con.decrementVoteCount();
         System.assertEquals(con.thumbsUpDownRating, 20);
         System.assertEquals(con.renderGreyThumbsUp,true);
         System.assertEquals(con.renderGreyThumbsDown,false);
         System.assertEquals(con.renderContactPanel,true);
         
         con.save();
         
         con.reset();       
         System.assertEquals(con.renderFeedbackInput,true);
         System.assertEquals(con.renderGreyThumbsUp,true);
         System.assertEquals(con.renderGreyThumbsDown,true);
         System.assertEquals(con.renderContactPanel,false);
         System.assertEquals(con.disableSubmitFeedback,true);
         System.assertEquals(con.thumbsUpDownRating,0);
         System.assertEquals(con.contactName,'');
         System.assertEquals(con.contactEmail,'');
         System.assertEquals(con.feedbackComment,'');
         
      
         con.backToArticle();
         con.hasNext=true;
         con.hasPrevious=true;
         con.pageNumber=1;
         con.first();
         con.last();
         con.previous();
         con.next();
        
         Test.stopTest(); 
     }
    
}