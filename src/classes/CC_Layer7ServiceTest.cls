@IsTest
public class CC_Layer7ServiceTest {
    public static void inserAwsToken()
    {
        aws_security_token__c awstokenkey = new aws_security_token__c();
        awstokenkey.Name='awstoken';
        insert awstokenkey;
    }
    @IsTest
    static void it_should_generate_aws_token()
    {
        String strAWStoken='';
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();
        strAWStoken = CC_Layer7Service.generateAWSToken();
        Test.stopTest();
        System.assertNotEquals('',strAWStoken);
    }
    @IsTest
    static void it_should_update_aws_token_empty()
    {
        String strAWStoken='';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        System.assertEquals(strAWStoken, readtoken);
    }    
    @IsTest
    static void it_should_update_aws_token_250_below()
    {
        String strAWStoken='eyJraWQiOiJ2XC9sTHpGWnRBZjQxeVcrV2d3TDZKRjQ0SmlwcnVQdCtTU1wvVndTWFpabFk9IiwiYWxnIjoiUlMyNTYifQ.';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }
    @IsTest
    static void it_should_update_aws_token_500_below()
    {
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJ';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }
    @IsTest
    static void it_should_update_aws_token_750_below()
    {
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }
    @IsTest
    static void it_should_update_aws_token_1000_below()
    {
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }
    @IsTest
    static void it_should_update_aws_token_1250_below()
    {
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }   
    @IsTest
    static void it_should_update_aws_token_1500_below()
    {
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lwc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw';
        Test.startTest();
        inserAwsToken();
        CC_Layer7Service.updateAWSToken(strAWStoken);
        //String readtoken=CC_Layer7Service.getAWSToken();
        Test.stopTest();
        //System.assertEquals(strAWStoken, readtoken);
    }
    @IsTest
    static void it_should_get_solutions(){
        Layer7UtilCalloutMock mock = buildL7Mock(); 
        String strAWStoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lwc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw';
        mock.callLogger.recordCall('getSolutionsfromAWS', null,strAWStoken);
        Test.startTest();
        //String awstoken=CC_Layer7Service.getSolution();
        Test.stopTest();
    }


    @IsTest
    static void test_getSitesForUser(){
         Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
        String connectId = 'abcde', siteId = '12345';
         //TODO : Complete the mock call 

    }

    @IsTest
    static void test_callLayer7ToCreateVirtualFolderInEFT(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
         mock.callLogger.recordCall('callLayer7ToCreateVirtualFolderInEFT',  
            new Map<String, Object>{'email' => 'test@t.com', 'caseNumber' => '123456', 'siteId' => '105246'},
             'OK');
          Test.startTest();
          svc.callLayer7ToCreateVirtualFolderInEFT('test@t.com','123456','105246');
          Test.stopTest();
    }

    @IsTest
    static void it_should_fetch_private_comments_all(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
         mock.callLogger.recordCall('fetchPrivateComments',  
            new Map<String, Object>{'email' => 'test@t.com', 'caseNumber' => '123456', 'siteId' => '105246'},
             'OK');
          Test.startTest();
          svc.callLayer7ToCreateVirtualFolderInEFT('test@t.com','123456','105246');
          Test.stopTest();
    }
    
    @IsTest
    static void it_should_generate_sfdc_token()
    {
        String strsfdctoken='';
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();
        strsfdctoken = CC_Layer7Service.generateSFDCAccessToken();
        Test.stopTest();
        System.assertNotEquals('',strsfdctoken);
    }

    @IsTest
    static void it_should_fetch_private_comments_by_comment_Id(){

        // Given
        Case aCase = CC_ngTurkeyServiceTest.setupCase();
        ////setupTestCaseComment(aCase.Id);
        //CC_TestUtils.setUpTestAWSToken();
        //Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        
        CaseComment privateComment = new CaseComment(ParentId = aCase.Id, CommentBody = 'PrivateComment', IsPublished = false);
        insert privateComment;

        System.assertEquals(1, [SELECT Id FROM CaseComment WHERE ParentId = :aCase.Id].size());
        Test.startTest();
        //CC_ngTurkeyService.I svc = buildTurkeySvc();
        // When
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        string strsfdctoken = CC_Layer7Service.fetchPrivateComments(aCase.id);
        Test.stopTest();

    // Then

    /*
        String strsfdctoken='';
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Test.startTest();
        strsfdctoken = CC_Layer7Service.fetchPrivateComments();
        Test.stopTest();
        System.assertNotEquals('',strsfdctoken);
      */  

    }

    /*@IsTest
    static void it_should_insert_private_comment(){
        Case aCase = CC_ngTurkeyServiceTest.setupCase();
        String comm;
         Test.startTest();
            comm=CC_Layer7Service.InsertPrivateComments(aCase.ID,'This is Private Comment');
        System.debug('comm='+comm);
        Test.stopTest();        
        System.assertEquals('success',comm);
        System.assertEquals(1, [SELECT Id FROM CaseComment WHERE ParentId = :aCase.Id AND IsPublished=false].size());
    } */


 /* @IsTest
  static void it_should_get_sites_and_products() {
    // Given
    Layer7UtilCalloutMock mock = buildL7Mock();
    CC_Layer7Service svc = buildL7Svc(mock);
    CC_Layer7Service.JSON2Token jsontoken=new CC_Layer7Service.JSON2Token();
      
    String connectId = 'abcde', siteId = '12345';

    String[] jsonResults = new String[]{
      '{ "site_id": "site1", "name": "product1" }',
      '{ "site_id": "site2", "name": "product1" }',
      '{ "site_id": "site3", "name": "product2" }',
      '{ "site_id": "site4", "name": "product2" }'
    };
  String jsonAWStoken='{"token": "eyJraWQiOiJ2XC9sTHpGWnRBZjQxeVcrV2d3TDZKRjQ0SmlwcnVQdCtTU1wvVndTWFpabFk9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI2NGM5OGE1ZS05MWM0LTRlZjEtODFmYS02NTE2YjlmOGRkMjUiLCJhdWQiOiI3bmRoNzdmazJzdTFqOXM1NTRhdDZnOWhsNyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTQ5MzExNDI4MCwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfakVseHhKSG0zIiwiY29nbml0bzp1c2VybmFtZSI6ImNzb2FwaXVzZXIiLCJleHAiOjE0OTMxMTc4ODAsImlhdCI6MTQ5MzExNDI4MCwiZW1haWwiOiJwb3JtYTA5QGNhLmNvbSJ9.USNmG_eMli9JRRac56G7g5losUCgxq6Q8iTkK4oixhprnzq2N1v0F6b9fAP15DwWvehVDmov3R6bG6bLzZP-j6yXNFmQL2oW6aepnvlz64zuQBExiyOr213iZ9T05xnfR5mLxI_4mXvAVlbxtx6TjF5MlSRVWer_6rZ9HitdmxFX6AcBICbDsbKcNXTJFew8AR7rGp2TeE0s-8wwXAZHLNCa4qJMpUxluP9RefUkelhD1_V4JGCj8NCACDWJRoOVrnLBZ5LAFRwslky0SqJjN5S6pyYN4l564o8f6uMDRMiYAoRYTr6VLiwtV5wvoqzbwDjgdIPflIw5kkaJoKOFwQ"}';
            
    mock.callLogger.recordCall('processLayer7Services', null,
      '{ "status": "success", "data": { "sites": { "site_id": "12345,1234" }, "sites_and_products": [ ' + String.join(jsonResults, ',') + '] } }'
    );

    // When
    Test.startTest();
    CC_Layer7Service.parse(jsonAWStoken); 
    Map<String,String> results = svc.getSitesAndProducts(siteId, connectId);
    /*String token=CC_Layer7Service.getAWSToken();  
    String token1=CC_Layer7Service.generateAWSToken();
  //String awstoken='eyJraWQiOiJtSFFVbkYzY1dMenhzVmRuXC85blhqWklTS1BOTW1JNlk3MlF6OWRtSDJjaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2ZjdlODFhZi03ZDZiLTRkYWMtYjAwNy02ZDRjOWZkMDJkYjYiLCJhdWQiOiJkaWd2ZWJkb2xkcGxnMGJja3U2djZpZWV2IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNDkyODI0MDgzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9uTnRKQVhrZFAiLCJjb2duaXRvOnVzZXJuYW1lIjoidGVsZW1ldHJ5dXNlcjEiLCJleHAiOjE0OTI4Mjc2ODMsImlhdCI6MTQ5MjgyNDA4MywiZW1haWwiOiJUZWFtLUdJUy1BbWF6b25XZWJTZXJ2aWNlc0FkbWluc0BjYS5jb20ifQ.dvoHJbJFsEdqNRgXeGlSGOW-g7gIek3aZ9B7VlqUIvayJPj4aoly2Y6ZStEAoYNIE0sHVnDNhz2fbcrx4d8vzN-OwOfB5ABc2-s6fgqMlDDxpjmYFpiuQj0I3FtYi2D0H96Tl-WbUOl0chMXf7w8xQmFG-pPfj4ujdC_28A9Rym3yyhCjEwBExrTT333BR23Zzzl7ni1M5plJjNbZSMrejo2OCjTjj_rmYe76BNwHx43mlS50OOwy9JLEOlu9XSpnlq3veZZdieCILlKy5pelBpHTIIbvhcCO3MZmZDPca2Ny8j1zcKlVh_85COp78cGpftrW9oJ8EnX3QOmQdy0lw';    CC_Layer7Service.updateAWSToken(awstoken);  
    
    String sol1=CC_Layer7Service.getSolution(token,'VPE','11.0','45','');
    String sol2=CC_Layer7Service.getSolution(token,'VPE','11.0','45','T');**
    Test.stopTest();
  
    // Then
    // verify L7 call
    mock.callLogger.verify();
    HttpRequest req = (HttpRequest)mock.callLogger.getCall('processLayer7Services').params.get('httpInputRequest');
    System.assert(req.getEndpoint().endsWith('/userProductWithSites?connectId=' + connectId + '&ConnectSiteId=' + siteId));

    // verify results
    System.assertNotEquals(null, results);
    /*System.assertEquals(4, results.sites_and_products.size());
    System.assertNotEquals(null, results.sites);
    System.assertNotEquals(null, results.sites.siteIds);
    System.assertEquals(2, results.sites.siteIds.size(), results.sites.siteIds);**
  } */
    
    @isTest
    static void is_should_get_ldapId(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
        mock.callLogger.recordCall('getLDAPID',  
            new Map<String, Object>{'emailID' => 'test@t.com'},
             '123456');
        Test.startTest();
        svc.getLDAPID('test@t.com');
        Test.stopTest();        
    }  
    
    @isTest
    static void test_getSAMLResponse(){
        Layer7UtilCalloutMock mock = buildL7Mock();
        CC_Layer7Service svc = buildL7Svc(mock);
        mock.callLogger.recordCall('getSAMLResponse',  
            new Map<String, Object>{'connectID' => '123456'},
             '123456');
        Test.startTest();
        svc.getSAMLResponse('123456');
        Test.stopTest(); 
        
    }
    
    @isTest
    static void updateAccountOnContact_Test(){
        CC_TestUtils.setUpTestAWSToken();
        Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
        Id contactId= CC_TestUtils.fakeId(Contact.SObjectType); 
        Test.startTest();
        CC_Layer7Service.updateAccountOnContact(contactId, 'test@test.com');
        Test.stopTest();
    }
  

  static Layer7UtilCalloutMock buildL7Mock() {
    return new Layer7UtilCalloutMock();
  }

  static CC_Layer7Service buildL7Svc(Layer7UtilCalloutMock mock) {
    CC_Layer7Service svc = new CC_Layer7Service();
    svc.layer7Callout = mock;
    return svc;
  }
}