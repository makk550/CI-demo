@isTest(seealldata=true)
public class RelateKBArticleToCaseTest {

    static RelateKBArticleToCase ext;
    static Case testCase;
    static String kbArticleNumber = 'TEC-12345';
    
    private static void init() {
        testCase = new Case();
        testCase = [SELECT ID FROM CASE where Category__c !=null And Subcategory__c !=null LIMIT 1];
        ApexPages.StandardController con = new ApexPages.StandardController(testCase);
        ext = new RelateKBArticleToCase(con);
    }
    
    static testMethod void testEmptyKBArticle() {
        init();
        Test.startTest();
        ext.kbArticleNumb = kbArticleNumber;
        ext.messageName = 'KB Article Number cannot be empty. Please provide KB Article Number.';
        ext.errorLevel = 'ERROR';
        System.assertEquals(kbArticleNumber,ext.kbArticleNumb);
        String outPut = RelateKBArticleToCase.saveKBArticle('',testCase.id);
        System.assertEquals('Validation',outPut);
        ext.showMessage();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean exp = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('KB Article Number cannot be empty. Please provide KB Article Number.') ) {
                exp = true;    
            }
        }
        system.assert(exp);//Assert the Page Message was Properly Displayed
        Test.stopTest();
    }
    
    static testMethod void testExistingButNotLinkedKBArticle() {
        init();
        Test.startTest();
        KB_Article__c kbArticle = new KB_Article__c(KB_Article_No__c='TEC12340', Status__c='In Progress');
        insert kbArticle;
        String outPut = RelateKBArticleToCase.saveKBArticle('TEC12340',testCase.id);
        System.assertEquals('Success',outPut);
        Test.stopTest();
    }
    
    static testMethod void testNewKBArticle() {
        init();
        Test.startTest();
        String outPut = RelateKBArticleToCase.saveKBArticle('TEC12341',testCase.id);
        System.assertEquals('Success',outPut);   
        Test.stopTest();
    }
    
    static testMethod void testInvalidKBArticle() {
        init();
        ext.messageName = 'The entered value is not a valid KB article. Please recheck the KB Article number.';
        ext.errorLevel = 'INFO';
        Test.startTest();
        String outPut = RelateKBArticleToCase.saveKBArticle('testinvalid',testCase.id);
        System.assertEquals('NotValidKB',outPut);
        ext.showMessage();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean exp = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('The entered value is not a valid KB article. Please recheck the KB Article number.') ) {
                exp = true;    
            }
        }
        system.assert(exp);//Assert the Page Message was Properly Displayed
        Test.stopTest();
    }
    
    static testMethod void testLinkedKBArticle() {
        init();
        Test.startTest();
        ext.messageName = 'KB Article is already linked.';
        ext.errorLevel = 'INFO';
        KB_Article__c kbArticleLinked = new KB_Article__c(KB_Article_No__c='TEC12521', Status__c='In Progress');
        insert kbArticleLinked;
        KB_Article_Case__c kbArticleCase = new KB_Article_Case__c(Case__c=testCase.id, KB_Article__c=kbArticleLinked.Id);
        insert kbArticleCase;
        String outPut = RelateKBArticleToCase.saveKBArticle('TEC12521',testCase.id); 
        System.assertEquals('Linked',outPut);
        ext.showMessage();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean exp = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('KB Article is already linked.') ) {
                exp = true;    
            }
        }
        system.assert(exp);//Assert the Page Message was Properly Displayed
        Test.stopTest();
    }
    
    static testMethod void testException() {
        init();
        Test.startTest();       
        try{
             KB_Article__c outPut = KBArticleHandler.validateSyncKBArticle(null);
        }        
        catch(KBAutheringCustomException e) {
             System.assertEquals(null,e.message);
        }
        KBAutheringCustomException kbExp = new KBAutheringCustomException();
        String expMessage = kbExp.KBAutheringCustomException('testing custom exception');
        System.assertEquals('testing custom exception',expMessage);
        Test.stopTest();
    }

}