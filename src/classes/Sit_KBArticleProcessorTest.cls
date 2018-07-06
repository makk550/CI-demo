@IsTest
public class Sit_KBArticleProcessorTest {

    static Case testCase;
    private static void init() {
        CC_TestUtils.setupTestDataToInsertCase();
        testCase = createCase();
    }

    @isTest
    static void write_kb_article_should_link_exising_kb_article_to_case() {
        init();
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        Sit_KBArticleProcessor.KbInfo tempInfo = new Sit_KBArticleProcessor.KbInfo();
        String kbNumber = 'TEC1474504';
        String title ='Testing XMD Updates';
        KB_Article__c tempKBArticle = new KB_Article__c(KB_Article_Title__c = title, KB_Article_No__c = kbNumber);
        insert tempKBArticle;
        tempInfo.kbNumber = kbNumber;
        tempInfo.caseId = testCase.Id;
        kbArticles.add(tempInfo);
        Test.startTest();
            buildProcessor().writeKbArticle(kbArticles);
        Test.stopTest();

        List<KB_Article_Case__c> results = [SELECT id, KB_Article__c FROM KB_Article_Case__c WHERE Case__c = :testCase.Id];
        System.assert(results.size() > 0);
        System.assertEquals(results[0].KB_Article__c, kbArticles[0].kbArticleId);
        System.assertEquals(results[0].Id, kbArticles[0].kbArticleCaseId);
    }

    @isTest
    static void write_kb_article_should_handle_case_differences_in_kb_id() {
        init();
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        Sit_KBArticleProcessor.KbInfo tempInfo = new Sit_KBArticleProcessor.KbInfo();
        String kbNumber = 'tec1474504';
        String title ='Testing XMD Updates';
        KB_Article__c tempKBArticle = new KB_Article__c(KB_Article_Title__c = title, KB_Article_No__c = kbNumber.toLowerCase());
        insert tempKBArticle;
        tempInfo.kbNumber = kbNumber.toUpperCase();
        tempInfo.caseId = testCase.Id;
        kbArticles.add(tempInfo);
        Test.startTest();
            buildProcessor().writeKbArticle(kbArticles);
            tempKBArticle.KB_Article_No__c = kbNumber.toUpperCase();
            update tempKBArticle;
            tempInfo.kbNumber = kbNumber.toLowerCase();
            buildProcessor().writeKbArticle(kbArticles);
        Test.stopTest();

        List<KB_Article_Case__c> results = [SELECT id, KB_Article__c FROM KB_Article_Case__c WHERE Case__c = :testCase.Id];
        System.assertEquals(1, results.size());
        System.assertEquals(results[0].KB_Article__c, kbArticles[0].kbArticleId);
    }

    @isTest
    static void write_kb_article_should_insert_kb_articles_not_found_in_sf() {
        init();
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        Sit_KBArticleProcessor.KbInfo tempInfo = new Sit_KBArticleProcessor.KbInfo();
        String kbNumber = 'TEC1238246';
        tempInfo.kbNumber = kbNumber;
        tempInfo.caseId = testCase.Id;
        kbArticles.add(tempInfo);
        Test.startTest();
            buildProcessor().writeKbArticle(kbArticles);
        Test.stopTest();

        KB_Article__c[] sfKbArticles = [SELECT Id, KB_Article_No__c FROM KB_Article__c WHERE KB_Article_No__c = :kbNumber];
        System.assertEquals(1, sfKbArticles.size());
        System.assertEquals(kbArticles[0].kbArticleId, sfKbArticles[0].Id);
        System.assertEquals(kbArticles[0].kbNumber, sfKbArticles[0].KB_Article_No__c);
        System.assertNotEquals(null, kbArticles[0].kbArticleCaseId);
    }

    @isTest
    static void write_kb_article_should_return_set_of_articles_not_found() {
        init();
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        Sit_KBArticleProcessor.KbInfo tempInfo = new Sit_KBArticleProcessor.KbInfo();
        String kbNumber = 'TEC1474504';
        tempInfo.kbNumber = kbNumber;
        tempInfo.caseId = testCase.Id;
        kbArticles.add(tempInfo);
        Layer7UtilCalloutMock mockL7Service = new Layer7UtilCalloutMock();
        mockL7Service.callLogger.recordCall('processLayer7Services', null, invalidKbArticleResponse);
        Sit_KBArticleProcessor processor = buildProcessor(mockL7Service);
        Test.startTest();
            processor.writeKbArticle(kbArticles);
        Test.stopTest();
        System.assertEquals(null, kbArticles[0].kbArticleId);
        System.assertEquals(null, kbArticles[0].kbArticleCaseId);
    }

    @isTest
    static void write_kb_article_should_not_link_articles_already_linked_to_case() {
        init();
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        Sit_KBArticleProcessor.KbInfo tempInfo = new Sit_KBArticleProcessor.KbInfo();
        String kbNumber = 'tec1474504';
        String title ='Testing XMD Updates';
        KB_Article__c tempKBArticle = new KB_Article__c(KB_Article_Title__c = title, KB_Article_No__c = kbNumber);
        insert tempKBArticle;
        tempInfo.kbNumber = kbNumber.toUpperCase();
        tempInfo.caseId = testCase.Id;
        kbArticles.add(tempInfo);
        KB_Article_Case__c kbArticleCase = new KB_Article_Case__c(Case__c = testCase.Id, KB_Article__c = tempKBArticle.Id);
        insert kbArticleCase;
        Test.startTest();
            buildProcessor().writeKbArticle(kbArticles);
        Test.stopTest();

        List<KB_Article_Case__c> results = [SELECT id, KB_Article__c FROM KB_Article_Case__c WHERE Case__c = :testCase.Id];
        System.assertEquals(1, results.size());
        System.assertEquals(results[0].KB_Article__c, kbArticles[0].kbArticleId);
        System.assertEquals(results[0].Id, kbArticles[0].kbArticleCaseId);
    }

    @isTest
    static void write_kb_article_should_handle_null(){
        Exception caught;
        try {
            buildProcessor().writeKbArticle(null);
        } catch (Exception ex) {
            caught = ex;
        }
        System.assertEquals(null, caught);
    }

    @isTest
    static void write_kb_article_should_handle_empty_list(){
        Exception caught;
        try {
            buildProcessor().writeKbArticle(new List<Sit_KBArticleProcessor.KbInfo>());
        } catch (Exception ex) {
            caught = ex;
        }
        System.assertEquals(null, caught);
    }

    private static Sit_KBArticleProcessor buildProcessor() {
        return buildProcessor(null);
    }
    private static Sit_KBArticleProcessor buildProcessor(Layer7UtilCallout.I l7Service) {
        Sit_KBArticleProcessor processor = new Sit_KBArticleProcessor();
        if (l7Service == null) {
            Layer7UtilCalloutMock mockL7Service = new Layer7UtilCalloutMock();
            mockL7Service.callLogger.recordCall('processLayer7Services', null, validateKbArticleResponse);
            processor.l7Service = mockL7Service;
        } else {
            processor.l7Service = l7Service;
        }
        return processor;
    }

    private static Case createCase() {
        Contact c = new Contact(LastName = 'Test', Email = 'Test@ca.com');
        insert c;
        Case aCase = CC_TestUtils.buildCase(c.Id, 'Open');
        insert aCase;
        return aCase;
    }

    static String validateKbArticleResponse = '{"KB_Article_No__c":"TEC1238246","Author__c":"Chary, Venu Madhava","KB_Article_Title__c":"Test1","Modified_date":"2016-07-15T06:09:44Z","Status__c": "REVIEWER PENDING"}';
    static String invalidKbArticleResponse = '{"status":"failure","error":{"code":2016,"description":"No data found for KB Article","message":"Mandatory response fields missing"}}';
}