@isTest
public class KCSGenericArchivalScheduler_Test {
private static List<knowledge__kav> listKnowledgeObj;
  private static testMethod void method1(){
        Test.startTest();
        createTestData();
        SchedulableContext sc;
        KCSGenericArchivalScheduler ge= new KCSGenericArchivalScheduler();
        ge.execute(sc);
        database.executeBatch(ge);
        Test.stopTest();     
    }  
        private static void createTestData(){
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Generic' limit 1];
        listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.Request_Type__c = 'active';
        knowledgeObj1.ValidationStatus='Not Validated';
        knowledgeObj1.Content3__c='test';
        knowledgeObj1.Background__c='<a></a>';
        knowledgeObj1.Environment__c='test';
        knowledgeObj1.Instructions__c='test';
        knowledgeObj1.Additional_Information__c = '<a></a>';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.CreatedById = '0050c00000D1f3LAAR';
        listKnowledgeObj.add(knowledgeObj1);
        
        insert listKnowledgeObj;
        
         knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
         KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
         KbManagement.PublishingService.archiveOnlineArticle(knowledgeObj1.KnowledgeArticleId,null);
         System.debug([SELECT Publishstatus FROM knowledge__kav where ArticleNumber =:knowledgeObj1.ArticleNumber]);
    }
}