@isTest
public class KnowledgeArticleSummToRating_UnitTests {
	@isTest static void testSummarize() {
        system.runAs(createDataUser()){
			Test.startTest();
	        createArticles();
	        List<Knowledge__kav> onlineArticles = getOnlineArticles();
	        KBArticle_Rating__c rating = new KBArticle_Rating__c(Name=onlineArticles[0].ArticleNumber,Article_Rating__c=100);
	        insert rating;
	        KnowledgeArticleSummarizeToRating sch = new KnowledgeArticleSummarizeToRating();
		    Database.executeBatch(sch, 1); // integer is the size of the batch, tests can only execute one batch

	        Test.stopTest();
            rating = [SELECT Id, Title__c FROM KBArticle_Rating__c WHERE Id = :rating.Id];
            System.assertEquals(onlineArticles[0].Title,rating.Title__c);
	    }
	}

	@isTest static void testScheduleMe() {
		KnowledgeArticleSummarizeToRating.scheduleMe();
	}



	private static List<Knowledge__kav> getOnlineArticles() {
		return [SELECT Id, Title, UrlName, Summary, RecordTypeId, ArticleNumber, PublishStatus, KnowledgeArticleId FROM Knowledge__kav WHERE PublishStatus = 'Online'];
	}

	private static void createArticles() {
		      List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        List<knowledge__kav> listKnowledgeObj = new List<knowledge__kav>();
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
        knowledgeObj1.CADocid__c = 'TEST001';
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
        knowledgeObj2.CADocid__c = 'TEST001';
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
        knowledgeObj3.CADocid__c = 'TEST001';
        listKnowledgeObj.add(knowledgeObj3);
        insert listKnowledgeObj;
        
        List<knowledge__kav> testingKav = [Select id, knowledgeArticleId from knowledge__kav where Id=:listKnowledgeObj[2].Id];
        KbManagement.PublishingService.publishArticle(testingKav[0].knowledgeArticleId, true);
	}

    public static User createDataUser(){
       /* adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO' limit 1];
        testUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
        return testUser ; */
        User testUser = new User(id = UserInfo.getUserId());
        return testUser;
    }
}