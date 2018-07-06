public without sharing class KeyGenerator {
	public static String createKey (String login, String salt) {
	   	// generate String for key
	   	String inputString = null;
	   	String myDay = null;
	   	String myMonth = null;
	   	Date d = Datetime.now().dateGMT();
	  
	   	// The following code adds a 0 in front of the day and month
	   	if(d.day()<10) {
	    	myDay = '0' + d.day();
	   	} else 
	   		myDay = d.day().format(); // converts to string
	
	   	if(d.month()<10) {
	      	myMonth = '0' + d.month();
	   	} else 
	   		myMonth = d.month().format(); // converts to string
	
	   	String datestamp = myMonth + '-' + myDay + '-' + d.year();
	   	inputString = login + salt + datestamp;
	   	Blob md5 = Crypto.generateDigest('MD5', Blob.valueOf(inputString));
	   	String accessKey = EncodingUtil.convertToHex(md5);
	
	   	return accessKey;
	}
	
	testMethod static void test() {
		System.debug('###### key=' + KeyGenerator.createKey('liferays', 'd00$r@4aLt')); 
	}
}