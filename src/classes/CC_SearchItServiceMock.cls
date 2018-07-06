@IsTest
public class CC_SearchItServiceMock implements CC_SearchItService.I {
	public CC_MockCallRecorder callLogger { get; private set; }

  public CC_SearchItServiceMock() {
    callLogger = new CC_MockCallRecorder();
  }

  public CC_SearchItService.SearchItResults doSearch(String title, Id productId) {
    String methodName = 'doSearch';
    Map<String, Object> params = new Map<String, Object> {'title' => title, 'productId' => productId};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (CC_SearchItService.SearchItResults)returnValue;
  }
}