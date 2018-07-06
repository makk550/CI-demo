@IsTest
public class SC_SaasUserLookupControllerTest {
	
	@IsTest
	static void search_should_query_by_username() {
		// Given
		Map<String, String> searchCriteria = new Map<String, String> {
			'username' => 'chajo30@ca.com',
			'searchType' => 'username'
		};
		String query = EncodingUtil.urlEncode('(UserName = "chajo30@ca.com")', 'UTF-8');
		String expectedEndpoint = 'callout:Agile_Central_WSAPI/admin/user?fetch=true&query=' + query;
		HttpResponse resp = new HttpResponse();
		resp.setBody('Some result');
		CalloutMock httpMock = new CalloutMock(resp);
		Test.setMock(HttpCalloutMock.class, httpMock);

		// When
		String result = SC_SaasUserLookupController.search(searchCriteria);

		// Then
		HttpRequest req = httpMock.requests[0];
		System.assertEquals(expectedEndpoint, req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
	}

	@IsTest
	static void search_should_query_by_email() {
		// Given
		Map<String, String> searchCriteria = new Map<String, String> {
			'emailAddress' => 'chajo30@ca.com',
			'searchType' => 'email'
		};
		String query = EncodingUtil.urlEncode('(EmailAddress = "chajo30@ca.com")', 'UTF-8');
		String expectedEndpoint = 'callout:Agile_Central_WSAPI/admin/user?fetch=true&query=' + query;
		HttpResponse resp = new HttpResponse();
		resp.setBody('Some result');
		CalloutMock httpMock = new CalloutMock(resp);
		Test.setMock(HttpCalloutMock.class, httpMock);

		// When
		String result = SC_SaasUserLookupController.search(searchCriteria);

		// Then
		HttpRequest req = httpMock.requests[0];
		System.assertEquals(expectedEndpoint, req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
	}

	@IsTest
	static void search_should_query_by_first_and_last() {
		// Given
		Map<String, String> searchCriteria = new Map<String, String> {
			'firstName' => 'foo',
			'lastName' => 'Bar',
			'searchType' => 'firstlast' 
		};
		String query = EncodingUtil.urlEncode('((FirstName contains "foo") and (LastName = "Bar"))', 'UTF-8');
		String expectedEndpoint = 'callout:Agile_Central_WSAPI/admin/user?fetch=true&query=' + query;
		HttpResponse resp = new HttpResponse();
		resp.setBody('Some result');
		CalloutMock httpMock = new CalloutMock(resp);
		Test.setMock(HttpCalloutMock.class, httpMock);

		// When
		String result = SC_SaasUserLookupController.search(searchCriteria);

		// Then
		HttpRequest req = httpMock.requests[0];
		System.assertEquals(expectedEndpoint, req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
	}

	@IsTest
	static void fetch_subscription_admin_info_should_query_admin_info(){
		//Given 
		String query = EncodingUtil.urlEncode('((WorkspacePermission = "Subscription Admin") and (SubscriptionID = "3006"))', 'UTF-8');
		String expectedEndpoint = 'callout:Agile_Central_WSAPI/user?fetch=true&query=' + query;
		HttpResponse resp = new HttpResponse();
		resp.setBody('Some result');
		CalloutMock httpMock = new CalloutMock(resp);
		Test.setMock(HttpCalloutMock.class, httpMock);
		
		//When
		String result = SC_SaasUserLookupController.fetchSubscriptionAdminInfo(3006);

		//Then
		HttpRequest req = httpMock.requests[0];
		System.assertEquals(expectedEndpoint, req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
	}

	@IsTest
	static void fetch_subscription_info_should_return_url(){
		//Given 
		String query = EncodingUtil.urlEncode('(SubscriptionID = "3006")', 'UTF-8');
		String expectedEndpoint = 'callout:Agile_Central_WSAPI/subscription?fetch=true&query=' + query;
		HttpResponse resp = new HttpResponse();
		resp.setBody('Some result');
		CalloutMock httpMock = new CalloutMock(resp);
		Test.setMock(HttpCalloutMock.class, httpMock);
		
		//When
		String result = SC_SaasUserLookupController.fetchSubscriptionInfo(3006);

		//Then
		HttpRequest req = httpMock.requests[0];
		System.assertEquals(expectedEndpoint, req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
	}
}