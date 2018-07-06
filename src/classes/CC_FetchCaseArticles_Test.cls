@isTest
public class CC_FetchCaseArticles_Test {
    @isTest
    static void fetchArticlesTest()
    {
        Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType); 
        Knowledge__kav[] obtainedResult = CC_FetchCaseArticles.fetchArticles(fakeCaseId);
    }
}