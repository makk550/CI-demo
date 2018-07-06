@IsTest
private class TestJSONUtils {

	private static testmethod void testEncode(){
		assertEncode(null,'null');
		assertEncode('','""');
		assertEncode('abc','"abc"');
		assertEncode('a"bc','"a\\"bc"');
		assertEncode('a\\bc','"a\\\\bc"');
		assertEncode('a\nbc','"a\\nbc"');
		assertEncode('a\tbc','"a\\tbc"');
		assertEncode('a\fbc','"a\\fbc"');
		assertEncode('a\rbc','"a\\rbc"');
		assertEncode('a/bc','"a\\/bc"');
	}

    private static void assertEncode(String str, String expected){
    	String actual = JSONUtils.encode(str);
    	System.assert(actual==expected, 'JSONUtils.encode(\'' + str + '\') returned \'' 
    		+ actual + '\'; expected \'' + expected + '\'');
    }

}