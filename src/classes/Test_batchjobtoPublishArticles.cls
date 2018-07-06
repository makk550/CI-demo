@isTest
public class Test_batchjobtoPublishArticles {

    static testMethod void test1(){
        
         List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        
        List<knowledge__kav> listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.CADocid__c = 'tec0001';
        knowledgeObj1.Legacy_Source__c = 'ECM';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
       
        
        insert knowledgeObj1;
        
        
        List<knowledge__kav> kb1 = [select id,cadocid__c, articleNumber, KnowledgeArticleId from knowledge__kav where id = :knowledgeObj1.id limit 1];
        
        Temp_ECM_KB_Links_Update__c tempecmArticle = new Temp_ECM_KB_Links_Update__c();
        tempecmArticle.LegacyArticleNumber__c = kb1[0].CADocid__c;
        insert tempecmArticle;
        
        Test.startTest();
        if(kb1 != null && kb1.size() > 0) {
            //KbManagement.PublishingService.publishArticle(kb1[0].KnowledgeArticleId  , false);        
             batchjobtoPublishArticles obj = new batchjobtoPublishArticles(); 
          database.executeBatch(obj);
        }
        Test.stopTest();    
    }
}