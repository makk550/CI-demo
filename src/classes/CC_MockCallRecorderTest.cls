@IsTest
public class CC_MockCallRecorderTest {

  @IsTest
  static void it_should_record_multiple_calls() {
    // Given
    CC_MockCallRecorder recorder = new CC_MockCallRecorder();

    // When
    Map<String, Object> params = new Map<String, Object> {'param' => 'value'};
    recorder.recordCall('methodName', params, 'returnValue');
    recorder.recordCall('methodName', params, 'newReturnValue');

    // Then
    CC_MockCallRecorder.MockCall call = recorder.getRecordedCall('methodName');
    System.assertEquals(params, call.params);
    System.assertEquals('returnValue', call.returnValue);
    System.assert( call.called );

    call = recorder.getRecordedCall('methodName');
    System.assertEquals(params, call.params);
    System.assertEquals('newReturnValue', call.returnValue);
    System.assert( call.called );
  }

  @IsTest
  static void it_should_assert_call_params_fail() {
    // Given
    CC_MockCallRecorder recorder = new CC_MockCallRecorder();

    // When
    Map<String, Object> params = new Map<String, Object> {'param' => 'value'};
    recorder.recordCall('methodName', params, 'returnValue');

    // Then
    Exception caught;
    try {
      recorder.getRecordedCall('methodName', new Map<String, Object>());
    } catch (Exception ex) {
      caught = ex;
    }

    System.assertNotEquals( null, caught);
    System.assertEquals('Expected: {"param":"value"} Actual: {}', caught.getMessage() );
  }

  @IsTest
  static void it_should_verify_multiple_calls_pass() {
    // Given
    CC_MockCallRecorder recorder = new CC_MockCallRecorder();

    // When
    Map<String, Object> params = new Map<String, Object> {'param' => 'value'};
    recorder.recordCall('methodName', params, 'returnValue');
    recorder.recordCall('methodName', params, 'newReturnValue');

    // Then
    CC_MockCallRecorder.MockCall call = recorder.getRecordedCall('methodName');
    System.assert( call.called );

    call = recorder.getRecordedCall('methodName');
    System.assert( call.called );

    recorder.verify();
  }

  @IsTest
  static void it_should_verify_multiple_calls_fail() {
    // Given
    CC_MockCallRecorder recorder = new CC_MockCallRecorder();

    // When
    Map<String, Object> params = new Map<String, Object> {'param' => 'value'};
    recorder.recordCall('methodName', params, 'returnValue');
    recorder.recordCall('methodName', params, 'newReturnValue');

    // Then
    CC_MockCallRecorder.MockCall call = recorder.getRecordedCall('methodName');
    System.assert( call.called );

    Exception caught;
    try {
      recorder.verify();
    } catch (Exception ex) {
      caught = ex;
    }

    System.assertNotEquals( null, caught);
    System.assertEquals('methodName not called', caught.getMessage() );

  }

  @IsTest
  static void it_should_log_multiple_calls() {
    // Given
    CC_MockCallRecorder recorder = new CC_MockCallRecorder();

    // When
    Map<String, Object> params = new Map<String, Object> {'param' => 'value'};
    recorder.logCall('methodName', params, 'returnValue');
    recorder.logCall('methodName', params, 'newReturnValue');

    // Then
    CC_MockCallRecorder.MockCall call = recorder.getCall('methodName');
    System.assertEquals(params, call.params);
    System.assertEquals('returnValue', call.returnValue);

    call = recorder.getCall('methodName', 2);
    System.assertEquals(params, call.params);
    System.assertEquals('newReturnValue', call.returnValue);
  }
}