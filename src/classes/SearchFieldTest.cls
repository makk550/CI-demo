@IsTest
private class SearchFieldTest {

    private static testmethod void test_Build(){
        final List<SearchField> fields = SearchField.build(new List<FieldConfiguration>{
            new FieldConfiguration('Account','Approved_for_Partner_Finder__c',null)
                .populateFieldsFromDescribe(Account.Approved_for_Partner_Finder__c.getDescribe())
        });
        
        System.assertNotEquals(null,fields);
        System.assertEquals(1,fields.size());
        
    }

}