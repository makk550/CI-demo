@IsTest
private class AutoCompletePartnerNameTest {

    private static testmethod void testInvalidSearchStrThrowingException(){
        assertInvalidSearchStrThrowingException(null);
        assertInvalidSearchStrThrowingException('');
        assertInvalidSearchStrThrowingException('x');
    }
    
    private static void assertInvalidSearchStrThrowingException(String searchStr){
        Boolean exceptionCaught = false;
        try{
            new AutoCompletePartnerName(searchStr);
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(
            exceptionCaught == true, 
            'new AutoCompletePartnerName(' 
                + (searchStr == null ? 'null' : '\'' + searchStr + '\'') 
                + ') did not throw IllegalArgumentException');
    }
       
    private static testmethod void testKeywordAutoComplete(){
        final Account acct = getAcct('Test Rty395i832ij Test');
        final List<String> results = new AutoCompletePartnerName('ty395i832i').execute();
        System.assertNotEquals(null,results);
        System.assert(results.size() >= 1, 'Expected at least one result');
        System.assertEquals(acct.name,results.get(0));
    }

    private static Account getAcct(String name){
        TestData.ensureVariableExists(Configuration.KEY_TERMS_AND_CONDITIONS_URL,'test123');

        Account acct = new Account(
            name = name,
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',
            Partner_User_Agreed_to_PF_Terms_Cond__c = UserInfo.getUserId(),
            Partner_Date_Agreed_to_PF_Terms_Cond__c = Datetime.now(),
            BillingStreet = 'Arlington',
            BillingCountry = 'US',
            BillingCity = 'VA');

        insert acct;
        acct.IsPartner = true;
        update acct;
        
        Partner_Location__c loc = new Partner_Location__c();
        loc.Name = 'test location';
        loc.Longitude__c = 0;
        loc.Latitude__c = 0;
        loc.Is_Primary__c = true;
        loc.Account__c = acct.id;
        insert loc;
        System.assert(acct.Id != null);
        return acct;
    }

}