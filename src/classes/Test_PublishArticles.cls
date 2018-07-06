@isTest
public class Test_PublishArticles {
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        createTestData(listOfRecord);
       // system.debug('===listKnowledgeObj=>>>>'+listKnowledgeObj);
        String recordid=listOfRecord[0].id;
        Integer limitvalue=20;
        String migStatus='published';
        //createTestData();
        PublishArticles obj = new PublishArticles(recordid,migStatus,limitvalue);
        database.executeBatch(obj);
        Test.stopTest();
    }

    private static void createTestData(List<RecordType> listOfRecord){       
        
        // List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test batch1';
        knowledgeObj1.UrlName = 'test-batch1';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.ValidationStatus='Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = '';
        knowledgeObj1.Component_Codes__c = 'CA PPM:PPMENV;PPMINV';
        knowledgeObj1.Releases__c = 'CA PPM:Release:1;1.0;13.0';
        knowledgeObj1.Product_Names__c = 'CA PPM;';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Published';
        knowledgeObj1.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj1);
        
        
        //List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj2 = new Knowledge__kav();
        knowledgeObj2.Title = 'test batch2';
        knowledgeObj2.UrlName = 'test-batch2';
        knowledgeObj2.Summary = 'testingning11112';
        knowledgeObj2.ValidationStatus='Not Validated';
        knowledgeObj2.IsVisibleInPkb=true;
        knowledgeObj2.RecordTypeId = listOfRecord[0].id;
        knowledgeObj2.Component_Names__c = '';
        knowledgeObj2.Component_Codes__c = 'ARGIS;ARGWEB';
        knowledgeObj2.Releases__c = 'CA IT Asset Manager:11.3.4';
        knowledgeObj2.Product_Names__c = 'CA IT Asset Manager CA Asset Portfolio Management CA Client Automation;';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.migrated_status__c='Published';
        knowledgeObj2.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj2);
        
        Knowledge__kav knowledgeObj3 = new Knowledge__kav();
        knowledgeObj3.Title = 'test batch3';
        knowledgeObj3.UrlName = 'test-batch3';
        knowledgeObj3.Summary = 'testingning11113';
        knowledgeObj3.ValidationStatus='Not Validated';
        knowledgeObj3.IsVisibleInPkb=true;
        knowledgeObj3.RecordTypeId = listOfRecord[0].id;
        knowledgeObj3.Component_Names__c = '';
        knowledgeObj3.Component_Codes__c = 'CA VISION:Results for z/OS:V';
        knowledgeObj3.Releases__c = 'CA VISION:Results for z/OS:6.0';
        knowledgeObj3.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.Legacy_Source__c='ECM';
        knowledgeObj3.migrated_status__c='Published';
        knowledgeObj3.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj3);        
        insert listKnowledgeObj;
              
         
    }
                                             }