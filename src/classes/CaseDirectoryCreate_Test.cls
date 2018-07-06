@isTest
public class CaseDirectoryCreate_Test {
	
    public class CaseDirectoryMock_Success implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('/support/case/folder/r.v1')) {
                res.setBody('<createCaseFolderResponse><caseId>5003C000001RszFQAS</caseId><caseNumber>00720264</caseNumber><siteId>8346366</siteId><comment>Case folder creation request successfully submitted</comment></createCaseFolderResponse>');
                res.setStatusCode(200);
                return res;
            }            
            return null;
        }
    }
    
     public class CaseDirectoryMock_Error implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('/support/case/folder/r.v1')) {
                res.setBody('<createCaseFolderResponse>\'File not found\' occurred when trying to CDW to \'/EmailtoCase\'.</createCaseFolderResponse>');
                res.setStatusCode(200);
                return res;
            }            
            return null;
        }
    }
    
    public class CaseDirectoryMock_Error2 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Read timed out');
            throw e;
        }
    }
    
    @isTest
    static void test1_callEAIforDirectoryCreate(){
        String xmlstr = '<createCaseFolderRequest><caseId>5003C000001RszFQAS</caseId><caseNumber>00720264</caseNumber><siteId>105246</siteId></createCaseFolderRequest>';
        List<String> xmlStrings = new List<String>();
        xmlStrings.add(xmlstr);
        Test.setMock(HttpCalloutMock.class,new CaseDirectoryMock_Success());
        Test.startTest();        
        CaseDirectoryCreate.callEAIforDirectoryCreate(xmlStrings);        
        Test.stopTest();
    }
    
  /*  @isTest
    static void test2_callEAIforDirectoryCreate(){
        String xmlstr = '<createCaseFolderRequest><caseId>5003C000001RszFQAS</caseId><caseNumber>00720264</caseNumber><siteId>105246</siteId></createCaseFolderRequest>';
        List<String> xmlStrings = new List<String>();
        xmlStrings.add(xmlstr);        
        Test.setMock(HttpCalloutMock.class,new CaseDirectoryMock_Error());
        Test.startTest();
        CaseDirectoryCreate.callEAIforDirectoryCreate(xmlStrings);
        Test.stopTest();        
    } */
    
        @isTest
    static void test3_callEAIforDirectoryCreate(){
        String xmlstr = '<createCaseFolderRequest><caseId>5003C000001RszFQAS</caseId><caseNumber>00720264</caseNumber><siteId>105246</siteId></createCaseFolderRequest>';
        List<String> xmlStrings = new List<String>();
        xmlStrings.add(xmlstr);        
        Test.setMock(HttpCalloutMock.class,new CaseDirectoryMock_Error2());
        Test.startTest();
        CaseDirectoryCreate.callEAIforDirectoryCreate(xmlStrings);
        Test.stopTest();        
    } 
    
}