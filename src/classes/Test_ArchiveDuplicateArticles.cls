@isTest
public class Test_ArchiveDuplicateArticles {
    
    private static testMethod void batchJobToUpdateArticlesMethod(){
        
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        createTestData(listOfRecord);
        Integer productFalg=1;
        String recordtypeid=listOfRecord[0].id;
        ArchiveDuplicateArticles obj = new ArchiveDuplicateArticles(recordtypeid,productFalg);
        database.executeBatch(obj);
        Test.stopTest();
    }

    private static void createTestData(List<RecordType> listOfRecord){       
        
        //List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         
       // recordtypeid = listOfRecord[0].id;
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test batch1';
        knowledgeObj1.UrlName = 'test-batch1';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.ValidationStatus='Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = '';
        knowledgeObj1.Component_Codes__c ='CA 2E:MFDOC';
        knowledgeObj1.Releases__c = 'CA 2E:8.1;8.5';
        knowledgeObj1.Product_Names__c = 'CA 2E';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Published';
        knowledgeObj1.Product_Association_update__c=1;
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
        knowledgeObj2.Component_Codes__c = 'CA 2E:MFDOC\nCA PPM:PPMINV;PRVASV';
        knowledgeObj2.Releases__c = 'CA 2E:8 \n CA PPM:1.1';
        knowledgeObj2.Product_Names__c = 'CA PPM\n CA 2E';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.migrated_status__c='Published';
        knowledgeObj2.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj2);
        
        Knowledge__kav knowledgeObj3 = new Knowledge__kav();
        knowledgeObj3.Title = 'test batch3';
        knowledgeObj3.UrlName = 'test-batch3';
        knowledgeObj3.Summary = 'testingning11113';
        knowledgeObj3.ValidationStatus='Not Validated';
        knowledgeObj3.IsVisibleInPkb=true;
        knowledgeObj3.RecordTypeId = listOfRecord[0].id;
        knowledgeObj3.Component_Names__c = '';
        knowledgeObj3.Component_Codes__c = 'CA VISION:Results for z/OS:CAIRIM \n CA PPM:PPMINV';
        knowledgeObj3.Releases__c = 'CA VISION:Results for z/OS:10 \n CA PPM:1.1';
        knowledgeObj3.Product_Names__c = 'CA VISION:Results for z/OS \n CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.Legacy_Source__c='ECM';
        knowledgeObj3.migrated_status__c='Published';
        knowledgeObj2.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj3);
        
        
        Knowledge__kav knowledgeObj4 = new Knowledge__kav();
        knowledgeObj4.Title = 'test batch4';
        knowledgeObj4.UrlName = 'test-batch4';
        knowledgeObj4.Summary = 'testingning11114';
        knowledgeObj4.ValidationStatus='Not Validated';
        knowledgeObj4.IsVisibleInPkb=true;
        knowledgeObj4.RecordTypeId = listOfRecord[0].id;
        knowledgeObj4.Component_Names__c = '';
        knowledgeObj4.Component_Codes__c = 'ODINCL;PPMINV;V';
        knowledgeObj4.Releases__c = 'CA VISION:Results for z/OS:Release:6.0;';
        knowledgeObj4.Product_Names__c = 'CA VISION:Results for VSE;CA VISION:Results for z/OS;CA PPM';
        knowledgeObj4.Content1__c='Issue';
        knowledgeObj4.Content2__c ='Resolution';
        knowledgeObj4.Legacy_Source__c='ECM';
        knowledgeObj4.migrated_status__c='Published';
        knowledgeObj4.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj4);
        
        
        
        Knowledge__kav knowledgeObj5 = new Knowledge__kav();
        knowledgeObj5.Title = 'test batch5';
        knowledgeObj5.UrlName = 'test-batch5';
        knowledgeObj5.Summary = 'testingning11115';
        knowledgeObj5.ValidationStatus='Validated';
        knowledgeObj5.IsVisibleInPkb=true;
        knowledgeObj5.RecordTypeId = listOfRecord[0].id;
        knowledgeObj5.Component_Names__c = '';
        knowledgeObj5.Component_Codes__c = 'name1:PPMINV;name2:CAIRIM';
        knowledgeObj5.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj5.Product_Names__c = 'CA VISION:Results for z/OS;';
        knowledgeObj5.Content1__c='Issue';
        knowledgeObj5.Content2__c = 'Resolution';
        knowledgeObj5.Legacy_Source__c='ECM';
        knowledgeObj5.migrated_status__c='Published';
        knowledgeObj5.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj5);
        
        Knowledge__kav knowledgeObj6 = new Knowledge__kav();
        knowledgeObj6.Title = 'test batch6';
        knowledgeObj6.UrlName = 'test-batch6';
        knowledgeObj6.Summary = 'testingning11116';
        knowledgeObj6.ValidationStatus='Validated';
        knowledgeObj6.IsVisibleInPkb=true;
        knowledgeObj6.RecordTypeId = listOfRecord[0].id;
        knowledgeObj6.Component_Names__c = '';
        knowledgeObj6.Component_Codes__c = 'name1:PPMINV';
        knowledgeObj6.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj6.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj6.Content1__c='Issue';
        knowledgeObj6.Content2__c = 'Resolution';
        knowledgeObj6.Legacy_Source__c='ECM';
        knowledgeObj6.migrated_status__c='Published';
        knowledgeObj6.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj6);
        
      /*  Knowledge__kav knowledgeObj7 = new Knowledge__kav();
        knowledgeObj7.Title = 'test batch7';
        knowledgeObj7.UrlName = 'test-batch7';
        knowledgeObj7.Summary = 'testingning11117';
        knowledgeObj7.ValidationStatus='Validated';
        knowledgeObj7.IsVisibleInPkb=true;
        knowledgeObj7.RecordTypeId = listOfRecord[0].id;
        knowledgeObj7.Component_Names__c = '';
        knowledgeObj7.Component_Codes__c = 'ODINCL;PPMINV;V';
        knowledgeObj7.Releases__c = 'CA VISION:Results for z/OS:Release:6.0;CA PPM:Release:8.1;CA PPM:Release:8.0.01;';
        knowledgeObj7.Product_Names__c = 'CA VISION:Results for VSE;CA VISION:Results for z/OS;CA PPM';
        knowledgeObj7.Content1__c='Issue';
        knowledgeObj7.Content2__c ='Resolution';
        knowledgeObj7.Legacy_Source__c='ECM';
        knowledgeObj7.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj7);
        
        Knowledge__kav knowledgeObj8 = new Knowledge__kav();
        knowledgeObj8.Title = 'test batch8';
        knowledgeObj8.UrlName = 'test-batch8';
        knowledgeObj8.Summary = 'testingning11111';
        knowledgeObj8.ValidationStatus='Validated';
        knowledgeObj8.IsVisibleInPkb=true;
        knowledgeObj8.RecordTypeId = listOfRecord[0].id;
        knowledgeObj8.Component_Names__c = '';
        knowledgeObj8.Component_Codes__c = 'PPMENV;PPMINV';
        knowledgeObj8.Releases__c = 'CA PPM:Release:1;CA PPM:Release:1.0;PPM:Release:13.0;';
        knowledgeObj8.Product_Names__c = 'CA PPM';     
        knowledgeObj8.Content1__c='Issue';
        knowledgeObj8.Content2__c = 'Resolution';
        knowledgeObj8.Legacy_Source__c='ECM';
        knowledgeObj8.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj8);
        
        Knowledge__kav knowledgeObj9 = new Knowledge__kav();
        knowledgeObj9.Title = 'test batch9';
        knowledgeObj9.UrlName = 'test-batch9';
        knowledgeObj9.Summary = 'testingning11119';
        knowledgeObj9.ValidationStatus='Validated';
        knowledgeObj9.IsVisibleInPkb=true;
        knowledgeObj9.RecordTypeId = listOfRecord[0].id;
        knowledgeObj9.Component_Names__c = '';
        knowledgeObj9.Component_Codes__c = 'name2:CAIRIM';
        knowledgeObj9.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj9.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj9.Content1__c='Issue';
        knowledgeObj9.Content2__c = 'Resolution';
        knowledgeObj9.Legacy_Source__c='ECM';
        knowledgeObj9.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj9);*/
        
        insert listKnowledgeObj;
              
         
    }
                                             }