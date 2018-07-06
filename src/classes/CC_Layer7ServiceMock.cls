@IsTest
public class CC_Layer7ServiceMock implements CC_Layer7Service.I {
  public CC_MockCallRecorder callLogger { get; private set; }
	public CC_Layer7ServiceMock() {
		callLogger = new CC_MockCallRecorder();
	}
  public Map<String,String> getSitesAndProducts(String siteId, String connectId) {
    String methodName = 'getSitesAndProducts';
    Map<String, Object> params = new Map<String, Object> {'siteId' => siteId, 'connectId' => connectId};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Map<String,String>)returnValue;
  }
    public List<String> getSitesForUser(String connectSiteId,String connectId){
        String methodName = 'getSitesForUser';
        Map<String, Object> params = new Map<String, Object> {'connectSiteId' => connectSiteId, 'connectId' => connectId};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (List<String>)returnValue;
    }
    
    public String callLayer7ToCreateVirtualFolderInEFT(String email,String caseNumber,String siteId){
        String methodName = 'callLayer7ToCreateVirtualFolderInEFT';
        Map<String, Object> params = new Map<String, Object> {'email' => email, 'caseNumber' => caseNumber, 'siteId' => siteId};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (String)returnValue;
    }
    
     public String invokeL7GSService(String siteId, String caseNumber){
        String methodName = 'invokeL7GSService';
        Map<String, Object> params = new Map<String, Object> {'siteId' => siteId , 'caseNumber' => caseNumber};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (String)returnValue;
    }
    
	 public String getLDAPID(String emailID){
        String methodName = 'getLDAPID';
        Map<String, Object> params = new Map<String, Object> {'emailID' => emailID };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (String)returnValue;
    }
  
    public String getSAMLResponse(String emailID){
        String methodName = 'getSAMLResponse';
        Map<String, Object> params = new Map<String, Object> {'emailID' => emailID };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (String)returnValue;
    }
    
        public Map<String,Set<String>> getSitesAndProductsFromEER(String connectId){
        String methodName = 'getSitesAndProductsFromEER';
        Map<String, Object> params = new Map<String, Object> {'connectId' => connectId };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (Map<String,Set<String>>)returnValue;
    }
    
    public String callToFetchSitesAndProductsFromEER(String connectId){
        String methodName = 'callToFetchSitesAndProductsFromEER';
        Map<String, Object> params = new Map<String, Object> {'connectId' => connectId };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
         return (String)returnValue;
    }

    
  
}