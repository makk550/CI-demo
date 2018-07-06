@IsTest
private class TestConfigUtils {

	private static testmethod void testGetVariableBadInput(){
		//test with null key; should return null
		System.assertEquals(null,ConfigUtils.getVariable(null));
		System.assertEquals(null,ConfigUtils.getVariable(''));
		System.assertEquals(null,ConfigUtils.getVariable('  '));

		//test with bad key name; should return null
		System.assertEquals(null,ConfigUtils.getVariable('non-existant key name'));
	}
	
	private static testmethod void testGetVariableGoodInput(){
		Configuration_Variable__c var = new Configuration_Variable__c();
		var.name = 'test_key_test';
		var.value__c = 'test_abc123_test';
		insert var;
		String result = ConfigUtils.getVariable(var.name);
		System.assertNotEquals(null,result);
		System.assertEquals(var.value__c,result);
	}

}