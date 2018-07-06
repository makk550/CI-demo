@IsTest
public class KB_redirecttokcsTest{
     @IsTest
     static void redirect_to_kcs_article_exist() {
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        Test.startTest();
            knowledge__kav knowledgeObj3 = new knowledge__kav();
            knowledgeObj3.Title = 'test11112xxx';
            knowledgeObj3.UrlName = 'this-is-a-test1';
            knowledgeObj3.Summary = 'testingning121111xxxx';
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
            knowledgeObj3.CADocid__c = 'TEC1234';
            
            insert knowledgeObj3;


            List<knowledge__kav> knowledgeObject = [Select id, articleNumber,knowledgeArticleId,publishStatus,IsVisibleInPkb from knowledge__kav where id=:knowledgeObj3.id];
            knowledgeObject[0].IsVisibleInPkb=true;
            update knowledgeObject;
            KbManagement.PublishingService.publishArticle(knowledgeObject[0].knowledgeArticleId, true);
            
            List<knowledge__kav> knowledgeObjectPub = [Select id, articleNumber,knowledgeArticleId,publishStatus,IsVisibleInPkb,CADocid__c from knowledge__kav where id=:knowledgeObj3.id];
            System.debug('knowledgeObject[0]='+knowledgeObjectPub[0]);            
            
            ApexPages.currentPage().getParameters().put('legacyid','TEC1234');
            KB_redirecttokcs k=new KB_redirecttokcs();
             k.redirectTopage();
        Test.stopTest();
     }  
     @IsTest
     static void redirect_to_not_found() {
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112xxx';
        knowledgeObj3.UrlName = 'testing12111xxx22';
        knowledgeObj3.Summary = 'testingning121111xxxx';
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
        knowledgeObj3.CADocid__c = 'TEC1234';
        insert knowledgeObj3;


        Test.startTest();
            ApexPages.currentPage().getParameters().put('legacyid','TEC654321');
            KB_redirecttokcs k=new KB_redirecttokcs();
             k.redirectTopage();
        Test.stopTest();
     }  

}