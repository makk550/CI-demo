@IsTest
public class CC_FetchCaseCommentsTest{
	// NOTE : Please find the test class code coverage in CC_ngTurkeyServiceTest class
    @IsTest
    public static void it_should_return_private_comments(){
    	CC_FetchCaseComments fetch=new CC_FetchCaseComments();

    } 
    @IsTest
  public static void it_should_insert_private_comments(){
      CC_FetchCaseComments fetch=new CC_FetchCaseComments();
      //Given
      Case aCase = CC_ngTurkeyServiceTest.setupCase();
      Test.startTest();
        ID privateCaseID=CC_FetchCaseComments.InsertCasePrivateComments('Private String',aCase.ID);
      Test.stopTest();
    System.assertEquals(1, [SELECT Id FROM CaseComment WHERE ParentId = :aCase.Id AND IsPublished=false].size());
  } 
  
  
 static testMethod void  it_should_get_private_comments(){
        Case aCase = CC_ngTurkeyServiceTest.setupCase();
        ID privateCaseID=CC_FetchCaseComments.InsertCasePrivateComments('this is a Private Comment',aCase.ID);
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'services/apexrest/casecomments';
        req.httpMethod = 'GET';
        req.addParameter('caseID',aCase.ID);
        RestContext.request = req;
        RestContext.response = res;
        List<CaseComment> response = CC_FetchCaseComments.getCasePrivateComments();
        System.debug('response='+response);
        System.assertEquals(1, response.size());
        System.assertEquals(privateCaseID, response[0].ID);
        Test.stopTest();
    
  } 
}