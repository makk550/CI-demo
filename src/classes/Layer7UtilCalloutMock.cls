@IsTest
public class Layer7UtilCalloutMock implements Layer7UtilCallout.I {

  public CC_MockCallRecorder callLogger { get; private set; }

  public Layer7UtilCallout mockedClass;

	public Layer7UtilCalloutMock() {
		callLogger = new CC_MockCallRecorder();
    mockedClass = new Layer7UtilCallout();
	}

  public String processLayer7Services(HttpRequest httpInputRequest) {
    String methodName = 'processLayer7Services';
    Map<String, Object> params = new Map<String, Object> {'httpInputRequest' => httpInputRequest};
    String returnValue = (String)callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return returnValue;
  }
  public String getLayer7BaseUrl() {
    return mockedClass.getLayer7BaseUrl();
  }
}