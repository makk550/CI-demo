@isTest
public class Test_ArchiveArticles {
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        createTestData();
        ArchiveArticles obj = new ArchiveArticles();
        database.executeBatch(obj);
        Test.stopTest();
    }

    private static void createTestData(){       
        
         List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test batch1';
        knowledgeObj1.UrlName = 'test-batch1';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.ValidationStatus='Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = '';
        knowledgeObj1.Component_Codes__c = 'PPMENV;PPMINV';
        knowledgeObj1.Releases__c = 'CA PPM:Release:1;CA PPM:Release:1.0;PPM:Release:13.0;';
        knowledgeObj1.Product_Names__c = 'CA PPM;';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Retired';
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
        knowledgeObj2.Releases__c = 'CA IT Asset Manager:Release:11.3.4;';
        knowledgeObj2.Product_Names__c = 'CA IT Asset Manager;CA Asset Portfolio Management;CA Client Automation;';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.migrated_status__c='Retired';
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
        knowledgeObj3.Component_Codes__c = 'V';
        knowledgeObj3.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj3.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.Legacy_Source__c='ECM';
        knowledgeObj3.migrated_status__c='Retired';
        knowledgeObj3.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj3);

        Knowledge__kav knowledgeObj4 = new Knowledge__kav();
        knowledgeObj4.Title = 'test batch4';
        knowledgeObj4.UrlName = 'test-batch4';
        knowledgeObj4.Summary = 'testingning11114';
        knowledgeObj4.ValidationStatus='Validated';
        knowledgeObj4.IsVisibleInPkb=true;
        knowledgeObj4.RecordTypeId = listOfRecord[0].id;
        knowledgeObj4.Component_Names__c = '';
        knowledgeObj4.Component_Codes__c = 'PPMENV;PPMINV';
        knowledgeObj4.Releases__c = 'CA PPM:Release:1;CA PPM:Release:1.0;PPM:Release:13.0;';
        knowledgeObj4.Product_Names__c = 'CA PPM;';     
        knowledgeObj4.Content1__c='Issue';
        knowledgeObj4.Content2__c = 'Resolution';
        knowledgeObj4.Legacy_Source__c='ECM';
        knowledgeObj4.migrated_status__c='Retired';
        knowledgeObj4.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj4);
        
        
        //List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj5 = new Knowledge__kav();
        knowledgeObj5.Title = 'test batch5';
        knowledgeObj5.UrlName = 'test-batch5';
        knowledgeObj5.Summary = 'testingning11115';
        knowledgeObj5.ValidationStatus='Not Validated';
        knowledgeObj5.IsVisibleInPkb=true;
        knowledgeObj5.RecordTypeId = listOfRecord[0].id;
        knowledgeObj5.Component_Names__c = '';
        knowledgeObj5.Component_Codes__c = 'ARGIS;ARGWEB';
        knowledgeObj5.Releases__c = 'CA IT Asset Manager:Release:11.3.4;';
        knowledgeObj5.Product_Names__c = 'CA IT Asset Manager;CA Asset Portfolio Management;CA Client Automation;';
        knowledgeObj5.Content1__c='Issue';
        knowledgeObj5.Content2__c = 'Resolution';
        knowledgeObj5.Legacy_Source__c='ECM';
        knowledgeObj5.migrated_status__c='Retired';
        knowledgeObj5.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj5);
        
        Knowledge__kav knowledgeObj6 = new Knowledge__kav();
        knowledgeObj6.Title = 'test batch6';
        knowledgeObj6.UrlName = 'test-batch6';
        knowledgeObj6.Summary = 'testingning11116';
        knowledgeObj6.ValidationStatus='Not Validated';
        knowledgeObj6.IsVisibleInPkb=true;
        knowledgeObj6.RecordTypeId = listOfRecord[0].id;
        knowledgeObj6.Component_Names__c = '';
        knowledgeObj6.Component_Codes__c = 'V';
        knowledgeObj6.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj6.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj6.Content1__c='Issue';
        knowledgeObj6.Content2__c = 'Resolution';
        knowledgeObj6.Legacy_Source__c='ECM';
        knowledgeObj6.migrated_status__c='Retired';
        knowledgeObj6.Product_Association_update__c=2;
        listKnowledgeObj.add(knowledgeObj6);        
        insert listKnowledgeObj;
              
         
    }
                                             }