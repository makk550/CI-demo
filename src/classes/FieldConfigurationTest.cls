@IsTest
private class FieldConfigurationTest {

    private static testmethod void testParse_Null(){
        final List<FieldConfiguration> fieldConfigurations = FieldConfiguration.parse(null);

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(0,fieldConfigurations.size());
    }

    private static testmethod void testParse_BlankString(){
        final List<FieldConfiguration> fieldConfigurations = FieldConfiguration.parse('   ');

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(0,fieldConfigurations.size());
    }

    private static testmethod void testParse_1(){
        final List<FieldConfiguration> fieldConfigurations = FieldConfiguration.parse(
           'Account.Partner_Type_METADATA__c=>Partner_Type__c|Partner_Location__c.Is_Primary__c');

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(2,fieldConfigurations.size());

        System.assertEquals('Account',fieldConfigurations.get(0).objectName);
        System.assertEquals('Partner_Type_METADATA__c',fieldConfigurations.get(0).fieldName);
        System.assertEquals('Partner_Type__c',fieldConfigurations.get(0).applyToFieldName);

        System.assertEquals('Partner_Location__c',fieldConfigurations.get(1).objectName);
        System.assertEquals('Is_Primary__c',fieldConfigurations.get(1).fieldName);
        System.assertEquals(true,StringUtils.isBlank(fieldConfigurations.get(1).applyToFieldName));
        
    }

    private static testmethod void testParse_2(){
        final List<FieldConfiguration> fieldConfigurations = FieldConfiguration.parse(
           '  Account    .  Partner_Type_METADATA__c   =>   Account   .  Partner_Type__c  |  Partner_Location__c .  Is_Primary__c ');

        System.assertNotEquals(null,fieldConfigurations);
        System.assertEquals(2,fieldConfigurations.size());

        System.assertEquals('Account',fieldConfigurations.get(0).objectName);
        System.assertEquals('Partner_Type_METADATA__c',fieldConfigurations.get(0).fieldName);
        System.assertEquals('Partner_Type__c',fieldConfigurations.get(0).applyToFieldName);

        System.assertEquals('Partner_Location__c',fieldConfigurations.get(1).objectName);
        System.assertEquals('Is_Primary__c',fieldConfigurations.get(1).fieldName);
        System.assertEquals(true,StringUtils.isBlank(fieldConfigurations.get(1).applyToFieldName));
        
    }

    private static testmethod void testPopulateFromDescribe(){
    	final FieldConfiguration config = new FieldConfiguration();
    	config.populateFieldsFromDescribe(Account.Profile_Published_to_Partner_Finder__c.getDescribe());
    	
        System.assertNotEquals(null,config.label);
        System.assertNotEquals(null,config.length);
        System.assertEquals('Profile_Published_to_Partner_Finder__c',config.localName);
        System.assertNotEquals(null,config.name);
        System.assertNotEquals(null,config.picklistValues);
        System.assert(config.picklistValues.size() > 0);
        System.assertEquals(Schema.DisplayType.PICKLIST ,config.displayType);
    }
    
}