@isTest
public class Test_BatchtoUpdateImageLinkLatest{

    //private static List<Knowledge__kav> listKnowledgeObj;
        
    private static testMethod void runBatchJob(){
        
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        createTestData(listOfRecord);
       // system.debug('===listKnowledgeObj=>>>>'+listKnowledgeObj);
        String recordid=listOfRecord[0].id;
        Integer limitvalue=20;
        String migStatus='published';
        batchJObToUpdateImageLinksLatest Obj = new batchJObToUpdateImageLinksLatest(recordid,migStatus,limitvalue);
        Obj.testMethodDummy();
        Database.executeBatch(Obj);
        Test.stopTest();
    }
    
    private static void createTestData(List<RecordType> listOfRecord){
        List<Folder> folderObj = [Select Id From Folder Where Name=:System.label.DocumentFolderName LIMIT 1];
        if(folderObj<>null && folderObj.size()>0){
            Document documentObj = new Document(FolderId = folderObj[0].Id, Name='TEC12343_Test',Keywords = 'Test');
            insert documentObj;
        }
        
//        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        
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
        knowledgeObj1.Content1__c='test <img alt="TEC1234_Test" src="http://ecm.ca.com/KB/KB Asset Library/TEC1234_Embeded/Test.png"/>';
        knowledgeObj1.Content2__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj1.Introduction__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj1.Additional_Information__c = '2112 <a href="http://ecm.ca.com/KB/Pages/Authoring/Create-KB-Article.aspx?kbid=TEC12343" target="_blank">TEC12343</a>';
        knowledgeObj1.Answer__c = '211212 <img alt="TEC1234_Test" src="http://ecm.ca.com/KB/KB Asset Library/TEC1234_Embeded/Test.png"></img>';
        knowledgeObj1.Background__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj1.Cause__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj1.CADocid__c = 'TEC1234';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.Migrated_Status__c='published';
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
        knowledgeObj2.Content1__c='211212 <a alt="TEC12343_Test" href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Extended/Testfile.pdf"></a>';
        knowledgeObj2.Content2__c = '2121 <img alt="TEC12343_Test" src="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png"></img>';
        knowledgeObj2.Additional_Information__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj2.Answer__c = '211212 <img alt="TEC12343_Test" src="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png"></img>';
        knowledgeObj2.Background__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj2.Cause__c = '2121 <a href="http://ecm.ca.com/KB/Pages/Authoring/Create-KB-Article.aspx?kbid=TEC12343>TEC12343</a>';
        knowledgeObj2.Content4__c = '211212 <a alt="TEC12343_Test" href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Extended/Testfile.pdf"></a>';
        knowledgeObj2.Instructions__c = '122112 <img alt="TEC12343_Test" src="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png"></img>';
        knowledgeObj2.Content3__c = '2121 <a href="http://ecm.ca.com/KB/KB Asset Library/TEC12343_Embeded/Test.png" target="_blank">Test.png</a>';
        knowledgeObj2.CADocid__c = 'TEC12343';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.Migrated_Status__c='published';
        listKnowledgeObj.add(knowledgeObj2);
        
        
        
        
        insert listKnowledgeObj;
        
           }
}