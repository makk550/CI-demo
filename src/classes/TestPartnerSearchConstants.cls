@IsTest
private class TestPartnerSearchConstants {
	private static testmethod void testGetInstance(){
		Configuration_Variable__c var = null;
		try{
			var = [select id from Configuration_Variable__c 
			where name = :PartnerSearchConstants.CONFIG_KEY_GOOGLE_MAPS_API_KEY];
		}catch(QueryException e){}
		if(var == null){
			var = new Configuration_Variable__c();
			var.name = PartnerSearchConstants.CONFIG_KEY_GOOGLE_MAPS_API_KEY;
		}
		var.value__c = 'test123';
		if(var.id == null){
			insert var;
		} else {
			update var;
		}
		PartnerSearchConstants constants = PartnerSearchConstants.getInstance();
		System.assertEquals('test123',constants.GOOGLE_MAPS_API_KEY);
	}
}