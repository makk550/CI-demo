@isTest
public class Test_BatchToUpdateValidationForRetired {
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        createTestData();
        BatchJobtoUpdateValidationforRetired obj = new BatchJobtoUpdateValidationforRetired();
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
        knowledgeObj1.ValidationStatus='Not Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CLARITY ON DEMAND: CLARITY ON DEMAND';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Retired';
        listKnowledgeObj.add(knowledgeObj1);
        
        
        //List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj2 = new Knowledge__kav();
        knowledgeObj2.Title = 'test batch2';
        knowledgeObj2.UrlName = 'test-batch2';
        knowledgeObj2.Summary = 'testingning11112';
        knowledgeObj2.ValidationStatus='Not Validated';
        knowledgeObj2.IsVisibleInPkb=true;
        knowledgeObj2.RecordTypeId = listOfRecord[0].id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj2.Product_Names__c = 'CLARITY ON DEMAND: CLARITY ON DEMAND';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Retired';
        listKnowledgeObj.add(knowledgeObj2);
        
        Knowledge__kav knowledgeObj3 = new Knowledge__kav();
        knowledgeObj3.Title = 'test batch3';
        knowledgeObj3.UrlName = 'test-batch3';
        knowledgeObj3.Summary = 'testingning11113';
        knowledgeObj3.ValidationStatus='Not Validated';
        knowledgeObj3.IsVisibleInPkb=true;
        knowledgeObj3.RecordTypeId = listOfRecord[0].id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj3.Product_Names__c = 'CLARITY ON DEMAND: CLARITY ON DEMAND';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Retired';
        listKnowledgeObj.add(knowledgeObj3);
        
        insert listKnowledgeObj;
              
         
    }
                                             }