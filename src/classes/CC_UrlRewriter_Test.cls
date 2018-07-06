@isTest
public class CC_UrlRewriter_Test{
	@isTest
	static void testGenerateUrlFor() {
		CC_UrlRewriter rewriter = new CC_UrlRewriter();
		System.assert(rewriter.generateUrlFor(null) == null);
    }
    @isTest
    static void testMapUrl() {
		CC_UrlRewriter rewriter = new CC_UrlRewriter();
		String actualResult = rewriter.mapRequestUrl(new PageReference('/CaseManagement/cases')).getUrl();
		String expectedResult = '/CaseManagement#!/cases';
        System.debug('actual:'+actualResult);
        System.debug('expected:'+expectedResult);
		System.assert(actualResult == expectedResult);

    }
}