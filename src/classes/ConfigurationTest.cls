@IsTest
private class ConfigurationTest {
	
    private static testmethod void testGoogleMapsApiKey(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY,'test123');
        System.assertEquals('test123',Configuration.getInstance().googleMapsApiKey);
    }
    
    private static testmethod void testGoogleMapsApiKeySites(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY_SITES,'test123');
        System.assertEquals('test123',Configuration.getInstance().googleMapsApiKeyForSites);
    }
    
    private static testmethod void testImageUrlRecommendedPartner(){
        TestData.ensureVariableExists(Configuration.KEY_IMAGE_URL_RECOMMENDED_PARTNER,'test123');
        System.assertEquals('test123',Configuration.getInstance().imageUrlRecommendedPartner);
    }
    
    private static testmethod void testSearchHelpUrl(){
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_HELP_URL,'test123');
        System.assertEquals('test123',Configuration.getInstance().searchHelpUrl);
    }
    
    private static testmethod void testTermsAndConditionsUrl(){
        TestData.ensureVariableExists(Configuration.KEY_TERMS_AND_CONDITIONS_URL,'google.com');
        System.assertEquals('google.com',Configuration.getInstance().termsAndConditionsUrl);
        System.assertEquals(true,Configuration.getInstance().isTermsConditionsFeatureEnabled);
    }

    private static testmethod void testSearchScreenBasicSearchFields(){
        TestData.ensureVariableExists(
           Configuration.KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS,
           'Account.Industry=>Rating|Partner_Location__c.Is_Primary__c'
        );
        List<FieldConfiguration> fieldConfigurations = Configuration.getInstance().searchScreenBasicSearchFields;

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(2,fieldConfigurations.size());

        System.assertEquals('Account',fieldConfigurations.get(0).objectName);
        System.assertEquals('Industry',fieldConfigurations.get(0).fieldName);
        System.assertEquals('Rating',fieldConfigurations.get(0).applyToFieldName);

        System.assertEquals('Partner_Location__c',fieldConfigurations.get(1).objectName);
        System.assertEquals('Is_Primary__c',fieldConfigurations.get(1).fieldName);
        System.assertEquals(true,StringUtils.isBlank(fieldConfigurations.get(1).applyToFieldName));
    }
    
    private static testmethod void testDetailScreenCompanyBasicFields(){
        TestData.ensureVariableExists(
           Configuration.KEY_DETAIL_SCREEN_COMPANY_BASIC_FIELDS,
           'Account.Industry=>Rating|Partner_Location__c.Is_Primary__c|Account.AnnualRevenue'
        );
        //of two fields in variable, test that Partner_Location__c.Is_Primary__c is filtered out

        List<FieldConfiguration> fieldConfigurations = Configuration.getInstance().detailScreenCompanyBasicFields;

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(2,fieldConfigurations.size());

        System.assertEquals('Account',fieldConfigurations.get(0).objectName);
        System.assertEquals('Industry',fieldConfigurations.get(0).fieldName);
        System.assertEquals('Rating',fieldConfigurations.get(0).applyToFieldName);

        System.assertEquals('Account',fieldConfigurations.get(1).objectName);
        System.assertEquals('AnnualRevenue',fieldConfigurations.get(1).fieldName);
        //System.assertEquals('',fieldConfigurations.get(1).applyToFieldName);
    }
 
    private static testmethod void testParseDoubleList(){
    	final List<Integer> parsed = Configuration.parseIntegerList('5|10|xyz|-4');
        System.assertNotEquals(null,parsed);
        System.assertEquals(3,parsed.size());
        System.assertEquals(5,parsed.get(0));
        System.assertEquals(10,parsed.get(1));
        System.assertEquals(-4,parsed.get(2));
    }
    
   
}