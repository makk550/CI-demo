@IsTest
private class TestPartnerSearchResultSortByDistCompara {

	private static testmethod void testNormal(){
		PartnerSearchResult r1 = new PartnerSearchResult(new Partner_Location__c());
		PartnerSearchResult r2 = new PartnerSearchResult(new Partner_Location__c());
		r1.distance = 1;
		r2.distance = 2;
		assertCompare(r1,r1,0);
		assertCompare(r1,r2,-1);
		assertCompare(r2,r1,1);
		assertCompare(r2,r2,0);
	}

	private static testmethod void testThrowingIllegalArgumentException1(){
		Boolean exceptionThrown = false;
		try{
			assertCompare(null,null,0);
		}catch(IllegalArgumentException e){
			exceptionThrown = true;
		}
		System.assert(exceptionThrown);
	}

	private static testmethod void testThrowingIllegalArgumentException2(){
		Boolean exceptionThrown = false;
		try{
			assertCompare(1,1,0);
		}catch(IllegalArgumentException e){
			exceptionThrown = true;
		}
		System.assert(exceptionThrown);
	}

	private static void assertCompare(Object o1, Object o2, Integer expected){ 
		System.assertEquals(expected,(new PartnerSearchResultSortByDistComparator()).compare(o1,o2));
	}
	

}