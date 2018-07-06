@isTest
public class Test_SecQuoteExtController {
    public static testMethod void testSecQuoteExtController(){
        PageReference ref = new PageReference('/apex/PreviewQuoteApprovals');
        Test.setCurrentPage(ref);
        testCreateQuoteAndQuoteLine.createTestData();
        Test.startTest();
        List<SBQQ__Quote__c> quoteList =[Select Id from SBQQ__Quote__c];
        System.debug('quoteList'+quoteList);
        if(quoteList.size() > 0){
            insert new SalesOrg__c(Name = 'US',Sales_Organization__c='US01',Company_Code__c='1001');
            SBQQ__Quote__c quote =quoteList[0];
            ApexPages.currentPage().getParameters().put('Id', quote.Id);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(quote);
            Quote_CustomerDetails_Controller controller = new Quote_CustomerDetails_Controller(sc);
            SecQuoteExtController secController = new SecQuoteExtController(sc);
            secController.returnToQuote();
        }
        Test.stopTest();
    }
}