@IsTest
public Class kb_UrlRewriterTest{
     @IsTest
     static void redirect_to_kcs_article_exist() {
        Test.startTest();
            kb_UrlRewriter kcsr = new kb_UrlRewriter();
             System.assert(kcsr.generateUrlFor(null) == null);
        Test.stopTest();
     }  
    @isTest
    static void redirectKbMapUrl() {
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
            knowledgeObj3.CADocid__c = 'TEC1760935';
            
            insert knowledgeObj3;


            List<knowledge__kav> knowledgeObject = [Select id, articleNumber,knowledgeArticleId,publishStatus,IsVisibleInPkb from knowledge__kav where id=:knowledgeObj3.id];
            knowledgeObject[0].IsVisibleInPkb=true;
            update knowledgeObject;
            KbManagement.PublishingService.publishArticle(knowledgeObject[0].knowledgeArticleId, true);

            kb_UrlRewriter redirect= new kb_UrlRewriter();
            String ecmID='TEC1760935';
            String actualResult = redirect.mapRequestUrl(new PageReference('https://support-qa.ca.com/us/knowledge-base-articles.TEC1760935.html')).getUrl();
            String expectedResult = System.label.siteURL+'/kbDetails?id='+knowledgeObject[0].articleNumber;
            System.debug('actual:'+actualResult);
            System.debug('expected:'+expectedResult);
            //System.assert(actualResult == expectedResult);
        Test.stopTest();

    }
}