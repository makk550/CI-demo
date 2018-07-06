@IsTest
public class CC_MockCallRecorder {
    private Map<String, List<MockCall>> actualCallMap = new Map<String, List<MockCall>>();
  private Map<String, List<MockCall>> expectedCalls = new Map<String, List<MockCall>>();

  public void recordCall(String methodName, Map<String, Object> expectedParams, Object returnValue) {
    List<MockCall> calls;
    if(!expectedCalls.containsKey(methodName)) {
      calls = new List<MockCall>();
      expectedCalls.put(methodName, calls);
    } else {
      calls = expectedCalls.get(methodName);
    }
    MockCall expectedCall = new MockCall(expectedParams, returnValue);
    calls.add(expectedCall);
  }

  Map<String, Integer> callNumbers = new Map<String, Integer>();
  public MockCall getRecordedCall(String methodName) {
    if (!callNumbers.containsKey(methodName)) {
      callNumbers.put(methodName, 1);
    }
    Integer callNumber = callNumbers.get(methodName);
    callNumbers.put(methodName, callNumber+1);
    MockCall call = expectedCalls.get(methodName).get(callNumber-1);
    call.called = true;
    return call;
  }

  public MockCall getRecordedCall(String methodName, Map<String, Object> params) {
    MockCall call = getRecordedCall(methodName);
    call.assertParams(params);
    return call;
  }

  public void logCall(String methodName, Map<String, Object> params) {
    logCall(methodName, params, null);
  }

  public void logCall(String methodName, Map<String, Object> params, Object returnValue) {
    List<MockCall> calls;
    if (actualCallMap.containsKey(methodName)) {
      calls = actualCallMap.get(methodName);
    } else {
      calls = new List<MockCall>();
      actualCallMap.put(methodName, calls);
    }
    calls.add(new MockCall(params,returnValue));
  }

  public MockCall getCall(String methodName) {
    return getCall(methodName, 1);
  }

  public MockCall getCall(String methodName, Integer callNumber) {
    return actualCallMap.get(methodName).get(callNumber-1);  
  }

  public void verify() {
    for (String methodName : expectedCalls.keySet()) {
      List<MockCall> calls = expectedCalls.get(methodName);
      for (MockCall call : calls) {
        if (!call.called) {
          throw new MockException(methodName + ' not called');
        }
      }
    }
  }

  public class MockException extends Exception {}

  public class MockCall {
    public Map<String, Object> params { get; private set; }
    public Object returnValue { get; private set; }
    public Boolean called { get; set; }

    public MockCall(Map<String, Object> params, Object returnValue) {
      this.params = params;
      this.returnValue = returnValue;
      this.called = false;
    }

    public MockCall(Map<String, Object> params) {
      this.params = params;
    }

    public MockCall(Object returnValue) {
      this.returnValue = returnValue;
    }

    public MockCall() {}

    public void assertParams(Map<String, Object> params) {
      if (this.params != null && this.params != params){
        throw new MockException('Expected: ' + JSON.serialize(this.params) + ' Actual: ' + JSON.serialize(params));
      }
    }
  }
}