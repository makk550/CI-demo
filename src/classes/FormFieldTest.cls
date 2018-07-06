@IsTest
private class FormFieldTest {

    private static testmethod void test_Build(){
        final List<FormField> fields = FormField.build(new List<FieldConfiguration>{
            new FieldConfiguration('Account','Approved_for_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Approved_for_Partner_Finder__c.getDescribe())
            ,new FieldConfiguration('Account','NumberOfEmployees',null)
                .populateFieldsFromDescribe(Account.NumberOfEmployees.getDescribe())
            ,new FieldConfiguration('Account','Profile_Published_to_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Profile_Published_to_Partner_Finder__c.getDescribe())
        });
        Set<Object> fieldNames = FormField.fieldNames(fields);
        System.assert(fieldNames.contains('Approved_for_Partner_Finder__c'));
        System.assert(fieldNames.contains('NumberOfEmployees'));
        System.assert(fieldNames.contains('Profile_Published_to_Partner_Finder__c'));
        
    }
    
    private static testmethod void testFieldNames(){
        final List<FormField> fields = FormField.build(new List<FieldConfiguration>{
            new FieldConfiguration('Account','Approved_for_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Approved_for_Partner_Finder__c.getDescribe())
            ,new FieldConfiguration('Account','NumberOfEmployees',null)
                .populateFieldsFromDescribe(Account.NumberOfEmployees.getDescribe())
            ,new FieldConfiguration('Account','Profile_Published_to_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Profile_Published_to_Partner_Finder__c.getDescribe())
        });
        
        Set<Object> fieldNames = FormField.fieldNames(fields);
        System.assertNotEquals(null,fieldNames);
        System.assert(fieldNames.contains('Approved_for_Partner_Finder__c'));
        System.assert(fieldNames.contains('NumberOfEmployees'));
        System.assert(fieldNames.contains('Profile_Published_to_Partner_Finder__c'));
    }
    
    private static testmethod void testPopulateFields(){
        final List<FormField> fields = FormField.build(new List<FieldConfiguration>{
            new FieldConfiguration('Account','Approved_for_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Approved_for_Partner_Finder__c.getDescribe())
            ,new FieldConfiguration('Account','NumberOfEmployees',null)
                .populateFieldsFromDescribe(Account.NumberOfEmployees.getDescribe())
            ,new FieldConfiguration('Account','Profile_Published_to_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Profile_Published_to_Partner_Finder__c.getDescribe())
/*            ,new FieldConfiguration('Account','multiselect_test__c',null)
                .populateFieldsFromDescribe(Account.multiselect_test__c.getDescribe())
*/                
             
        });
        System.assertNotEquals(null,fields);
        System.assertEquals(3,fields.size());
        System.assertEquals(null,fields.get(0).typedValue);
        System.assertEquals(null,fields.get(1).typedValue);
        System.assertEquals(null,fields.get(2).typedValue);

        Account acct = new Account(
	        Approved_for_Partner_Finder__c = true
	        ,NumberOfEmployees = 10
	        ,Profile_Published_to_Partner_Finder__c = 'Yes'
        );
        
        FormField.populateFields(fields,acct);


        System.assertNotEquals(null,fields);
        System.assertEquals(3,fields.size());
        System.assertEquals(acct.Approved_for_Partner_Finder__c,fields.get(0).typedValue);
        System.assertEquals(acct.NumberOfEmployees,fields.get(1).typedValue);
        System.assertEquals(acct.Profile_Published_to_Partner_Finder__c,fields.get(2).typedValue);
    }
    
    private static testmethod void test_BOOLEAN(){
        final FormField field = new FormField(new FieldConfiguration('Account','Approved_for_Partner_Finder__c',null)
            .populateFieldsFromDescribe(Account.Approved_for_Partner_Finder__c.getDescribe()));

        System.assertEquals('Account',field.objectName);
        System.assertNotEquals(null,field.label);
        System.assertNotEquals(null,field.length);
        System.assertEquals('approved_for_partner_finder__c',StringUtils.lowerCase(field.localName));
        System.assertNotEquals(null,field.name);
        System.assertNotEquals(null,field.picklistValues);
        System.assert(field.picklistValues.size() <= 0);
        System.assertEquals(Schema.DisplayType.BOOLEAN,field.displayType);
        System.assertEquals(null,field.value);
        System.assertNotEquals(null,field.values);
        System.assert(field.values.size() <= 0);

        System.assertEquals('BOOLEAN',field.fieldType);
        System.assertEquals(true,field.blank);
        System.assertEquals(false,field.notBlank);
        System.assertEquals(false,field.isMultiselectPicklist);
        System.assertEquals(null,field.typedValue);
        
        field.value = 'true';

        System.assertEquals(false,field.blank);
        System.assertEquals(true,field.notBlank);
        System.assertEquals(true,field.typedValue);
    }

    private static testmethod void test_INTEGER(){
        final FormField field = new FormField(new FieldConfiguration('Account','NumberOfEmployees',null)
            .populateFieldsFromDescribe(Account.NumberOfEmployees.getDescribe()));

        System.assertEquals('Account',field.objectName);
        System.assertNotEquals(null,field.label);
        System.assertNotEquals(null,field.length);
        System.assertEquals('numberofemployees',StringUtils.lowerCase(field.localName));
        System.assertNotEquals(null,field.name);
        System.assertNotEquals(null,field.picklistValues);
        System.assert(field.picklistValues.size() <= 0);
        System.assertEquals(Schema.DisplayType.INTEGER,field.displayType);
        System.assertEquals(null,field.value);
        System.assertNotEquals(null,field.values);
        System.assert(field.values.size() <= 0);

        System.assertEquals('INTEGER',field.fieldType);
        System.assertEquals(true,field.blank);
        System.assertEquals(false,field.notBlank);
        System.assertEquals(false,field.isMultiselectPicklist);
        System.assertEquals(null,field.typedValue);

        field.value = '10';

        System.assertEquals(false,field.blank);
        System.assertEquals(true,field.notBlank);
        System.assertEquals(10,field.typedValue);

        field.value = 'x';

        System.assertEquals(true,field.blank);
        System.assertEquals(false,field.notBlank);
        System.assertEquals(null,field.typedValue);
    }

    private static testmethod void test_PICKLIST(){
        final FormField field = new FormField(new FieldConfiguration('Account','Profile_Published_to_Partner_Finder__c',null)
            .populateFieldsFromDescribe(Account.Profile_Published_to_Partner_Finder__c.getDescribe()));
            
        System.assertEquals('Account',field.objectName);
        System.assertNotEquals(null,field.label);
        System.assertNotEquals(null,field.length);
        System.assertEquals('profile_published_to_partner_finder__c',StringUtils.lowerCase(field.localName));
        System.assertNotEquals(null,field.name);
        System.assertNotEquals(null,field.picklistValues);
        System.assert(field.picklistValues.size() > 0);
        System.assertEquals(Schema.DisplayType.PICKLIST,field.displayType);
        System.assertEquals(null,field.value);
        System.assertNotEquals(null,field.values);
        System.assert(field.values.size() <= 0);

        System.assertEquals('PICKLIST',field.fieldType);
        System.assertEquals(true,field.blank);
        System.assertEquals(false,field.notBlank);
        System.assertEquals(false,field.isMultiselectPicklist);
        System.assertEquals(null,field.typedValue);
    }

}