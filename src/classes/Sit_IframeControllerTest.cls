@isTest
private class Sit_IframeControllerTest {

    @isTest
    static void should_get_product_from_controller() {
        // Given
        Case myCase = new Case(Ca_Product_Controller__r = new CA_Product_Controller__c(name = 'Jive Turkey'));

        Sit_IframeController ctrl = buildController();
        ctrl.myCase = myCase;

        // When
        Test.startTest();
            String result = ctrl.product;
        Test.stopTest();

        // Then
        System.assertEquals(myCase.Ca_Product_Controller__r.Name, result);
    }

    @isTest
    static void should_get_KBproduct_from_SCKBProductMap() {
        //Given
        CC_TestUtils.setupTestDataToInsertCase();
        Contact testContact = new Contact(LastName = 'Jones', Email = UserInfo.getUserEmail());
        insert testContact;
        CA_Product_Controller__c tempController = new CA_Product_Controller__c(name = 'Jive Turkey');
        insert tempController;
        SCKBProductMap__c product = new SCKBProductMap__c(KB_Product_Name__c = 'Super turkey', SCProduct__c = tempController.Id);
        insert product;
        CA_Product_Component__c component = new CA_Product_Component__c(
            Name= 'Gravy',
            CA_Product_Controller__c = tempController.Id,
            Default_Component_for_this_CA_Product__c = true,
            component_expiration_date__c = null
        );
        insert component;
        Case myCase = buildCaseForProductMap(testContact.Id, tempController.Id);
        insert myCase;
        Sit_IframeController ctrl = buildController();
        ctrl.myCase = myCase;

        //When
        Test.startTest();
            String result = ctrl.product;
        Test.stopTest();

        //Then
        System.assertEquals(product.KB_Product_Name__c, result);
    }

    @isTest
    static void should_get_subject() {
        // Given
        Case myCase = new Case(Subject = 'hello');

        Sit_IframeController ctrl = buildController();
        ctrl.myCase = myCase;
        // When
        Test.startTest();
            String result = ctrl.searchTerm;
        Test.stopTest();
        // Then
        System.assertEquals(myCase.Subject, result);
    }

    @isTest
    static void write_to_case_related_should_write_to_related_case() {
        // Given
        CC_TestUtils.setupTestDataToInsertCase();
        Contact testContact = new Contact(LastName = 'Jones', Email = UserInfo.getUserEmail());
        insert testContact;
        Case myCase = buildCase(testContact.Id);
        insert myCase;
        String title ='LMP KEY FOR IDEAL FOR DB2 (15027297-01 | RESOLVED)';
        String url = 'http://star.ca.com/issuedetail.jsp?contact=15027297&issue=01';
        String src = 'STAR Issues';

        Sit_IframeController ctrl = buildController();
        ctrl.myCase = myCase;
        ctrl.knowledgeData = '[{"title":"LMP KEY FOR IDEAL FOR DB2 (15027297-01 | RESOLVED)","url":"http://star.ca.com/issuedetail.jsp?contact=15027297&issue=01","sourceName":"STAR Issues"}]';

        Test.startTest();
            ctrl.writeToCaseRelated();
        Test.stopTest();

        Case_Related_Object__c relatedObject = [SELECT Source__c, Title__c, URL__c FROM Case_Related_Object__c WHERE CaseId__c = :myCase.Id Limit 1];
        System.assertEquals(relatedObject.Source__c, src);
        System.assertEquals(relatedObject.Title__c, title);
        System.assertEquals(relatedObject.URL__c, url);

    }

    @isTest
    static void should_write_to_KBArticle_If_KBarticle_found_in_database_ignores_kbid_alphacase(){
    // Given
        CC_TestUtils.setupTestDataToInsertCase();
        Contact testContact = new Contact(LastName = 'Jones', Email = UserInfo.getUserEmail());
        insert testContact;
        Case myCase = buildCase(testContact.Id);
        insert myCase;
        String kbId = 'TeC1474504';
        String title ='Testing XMD Updates';
        String url = 'http://cacomqa.ca.com/us/support/ca-support-online/product-content/knowledgebase-articles/tec1474504.aspx';
        String src = 'Knowledge Base Articles';
        KB_Article__c tempKBArticle = new KB_Article__c(KB_Article_Title__c = title, KB_Article_No__c = kbId);
        insert tempKBArticle;

        Sit_IframeController ctrl = buildController();
        ctrl.myCase = myCase;
        ctrl.knowledgeData = '[{"title":"Testing XMD Updates","url":"http://cacomqa.ca.com/us/support/ca-support-online/product-content/knowledgebase-articles/tec1474504.aspx","sourceName":"Knowledge Base Articles","kbId":"tEc1474504"}]';

        Test.startTest();
            ctrl.writeToCaseRelated();
        Test.stopTest();

        KB_Article_Case__c relatedKBArticle = [SELECT Id FROM KB_Article_Case__c WHERE Case__C = :myCase.Id Limit 1];
        System.assertNotEquals(relatedKBArticle, null);
    }

    @isTest
    static void should_write_to_related_content_if_KBarticle_not_found_ignores_kbid_alphacase(){
        CC_TestUtils.setupTestDataToInsertCase();
        Contact testContact = new Contact(LastName = 'Jones', Email = UserInfo.getUserEmail());
        insert testContact;
        Case myCase = buildCase(testContact.Id);
        insert myCase;

        Sit_IframeController ctrl = buildController(new MockSit_KBArticleProcessor());
        ctrl.myCase = myCase;
        ctrl.knowledgeData = '[{"title":"Testing XMD Updates","url":"http://cacomqa.ca.com/us/support/ca-support-online/product-content/knowledgebase-articles/tec1474504.aspx","sourceName":"Knowledge Base Articles","kbId":"tEc1474504"}]';

        Test.startTest();
            ctrl.writeToCaseRelated();
        Test.stopTest();

        Case_Related_Object__c relatedObject = [SELECT Source__c, Title__c, URL__c FROM Case_Related_Object__c WHERE CaseId__c = :myCase.Id Limit 1];
        System.assertNotEquals(null, relatedObject);
    }

    @isTest
    static void should_not_write_to_related_content_if_kb_article_not_found_and_related_content_exists_ignores_kbid_alphacase(){
        // Given
        CC_TestUtils.setupTestDataToInsertCase();
        Contact testContact = new Contact(LastName = 'Jones', Email = UserInfo.getUserEmail());
        insert testContact;
        Case myCase = buildCase(testContact.Id);
        insert myCase;
        Case_Related_Object__c cro = new Case_Related_Object__c(
            Title__c = 'Testing XMD Updates',
            Source__c = 'Knowledge Base Articles',
            URL__c = 'http://cacomqa.ca.com/us/support/ca-support-online/product-content/knowledgebase-articles/tec1474504.aspx',
            CaseId__c = myCase.Id
        );
        insert cro;

        Sit_IframeController ctrl = buildController(new MockSit_KBArticleProcessor());
        ctrl.myCase = myCase;
        ctrl.knowledgeData = '[{"title":"Testing XMD Updates","url":"http://cacomqa.ca.com/us/support/ca-support-online/product-content/knowledgebase-articles/tec1474504.aspx","sourceName":"Knowledge Base Articles","kbId":"tEc1474504"}]';

        Test.startTest();
            ctrl.writeToCaseRelated();
        Test.stopTest();

        List<Case_Related_Object__c> relatedObject = [SELECT Source__c, Title__c, URL__c FROM Case_Related_Object__c WHERE CaseId__c = :myCase.Id ];
        System.assertEquals(1, relatedObject.size());
        System.assertEquals(cro.Id, relatedObject[0].Id);
    }

    private static Case buildCase(Id contact) {
        return CC_TestUtils.buildCase(contact, 'Open');
    }

    private static Case buildCaseForProductMap(Id contact, Id product){
          Site_Association__c testSite = [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SAP_Site_ID__c = '12345' LIMIT 1];
          return new Case(
              Business_Impact__c = 'Business_Impact__c',
              CA_Product_Controller__c = product,
              ContactId = contact,
              Description = 'Description',
              Severity__c = '3',
              Subject = 'Subject',
              Site_Association__c = testSite.Id,
              Next_Action_Due_Date__c = Datetime.now().addDays(1),
              Next_Action__c = 'Pending CA'
          );
    }

    private static Sit_IframeController buildController() {
        return new Sit_IframeController();
    }

    private static Sit_IframeController buildController(Sit_KBArticleProcessor.I kbProcessor) {
        Sit_IframeController controller =  new Sit_IframeController();
        controller.kbArticleProcessor = kbProcessor;
        return controller;
    }

    public class MockSit_KBArticleProcessor implements Sit_KBArticleProcessor.I {
        public void writeKbArticle(List<Sit_KBArticleProcessor.kbInfo> kbLinkData) {}
    }
}