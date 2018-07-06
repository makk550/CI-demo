@IsTest
private class SearchFormTest {

    private static testmethod void testSerializeKeyword1(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        form.keyword = 'abc';
        System.assertEquals('keyword=abc',form.serialize());
    }
    
    private static testmethod void testDeSerializeKeyword1(){
        scenario1();
        final SearchForm form = SearchForm.deSerialize('keyword=abc');
        System.assertEquals('abc',form.keyword);
        System.assertEquals(null,form.address);
        System.assertEquals(null,form.unit);
        System.assertEquals(null,form.latitude);
        System.assertEquals(null,form.longitude);
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals('(Account__r.name like \'abc\' OR name like \'abc\')',form.getAttributeSearchCriteria().toSoql());
    }
    
    private static testmethod void testSerializeKeyword2(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        form.keyword = 'ab=c';
        System.assertEquals('keyword=ab%3Dc',form.serialize());
    }
    
    private static testmethod void testDeSerializeKeyword2(){
        scenario1();
        final SearchForm form = SearchForm.deSerialize('keyword=ab%3Dc');
        System.assertEquals('ab=c',form.keyword);
        System.assertEquals(null,form.address);
        System.assertEquals(null,form.unit);
        System.assertEquals(null,form.latitude);
        System.assertEquals(null,form.longitude);
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals('(Account__r.name like \'ab=c\' OR name like \'ab=c\')',form.getAttributeSearchCriteria().toSoql());
    }
    
    private static testmethod void testSerializeAttribute1(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        form.basicFields.get(0).value = 'Retail';
        System.assertEquals('account.industry=Retail',form.serialize());
    }
        
    private static testmethod void testDeSerializeAttribute1(){
        scenario1();
        final SearchForm form = SearchForm.deSerialize('account.type=xyz');
        System.assertEquals(null,form.keyword);
        System.assertEquals(null,form.address);
        System.assertEquals(null,form.unit);
        System.assertEquals(null,form.latitude);
        System.assertEquals(null,form.longitude);
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals('account__r.Type = \'xyz\'',form.getAttributeSearchCriteria().toSoql());
    }

/*
    private static testmethod void testSerializeAttribute2(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        form.advancedFields.get(1).values.add('A');
        form.advancedFields.get(1).values.add('B');
        System.assertEquals('account.multiselect_test__c=A%2CB',form.serialize());
    }

    private static testmethod void testDeSerializeAttribute2(){
        scenario1();
        final SearchForm form = SearchForm.deSerialize('account.multiselect_test__c=A%2CB');
        System.assertEquals(null,form.keyword);
        System.assertEquals(null,form.address);
        System.assertEquals(null,form.unit);
        System.assertEquals(null,form.latitude);
        System.assertEquals(null,form.longitude);
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals('account__r.Multiselect_Test__c INCLUDES (\'A\',\'B\')',form.getAttributeSearchCriteria().toSoql());
    }
    private static testmethod void testSerializeAndDeSerializeAttribute2(){
        scenario1();
        final SearchForm original = SearchForm.blank();
        System.assertNotEquals(null,original.getAttributeSearchCriteria());
        
        final SearchForm deSerialized = SearchForm.deSerialize(original.serialize());
        System.assertEquals(original.keyword,   deSerialized.keyword);
        System.assertEquals(original.address,   deSerialized.address);
        System.assertEquals(original.unit,      deSerialized.unit);
        System.assertEquals(original.distance,  deSerialized.distance);
        System.assertEquals(original.latitude,  deSerialized.latitude);
        System.assertEquals(original.longitude, deSerialized.longitude);
        System.assertEquals(null,deSerialized.getGeoSearchCriteria());
        System.assertNotEquals(null,deSerialized.getAttributeSearchCriteria());
        System.assertEquals(original.getAttributeSearchCriteria().toSoql(),deSerialized.getAttributeSearchCriteria().toSoql());
    }
*/


    private static testmethod void testSerializeAndUnserialize_GeoCriteria(){
        scenario1();
        final SearchForm original = SearchForm.blank();
        original.address = '1 Broadway, New York, NY 10001';
        original.unit = 'miles';
        original.distance = 5;
        original.latitude = 1.1;
        original.longitude = 1.1;
        
        final SearchForm deSerialized = SearchForm.deSerialize(original.serialize());
        System.assertEquals(original.address,deSerialized.address);
        System.assertEquals(original.unit,deSerialized.unit);
        System.assertEquals(original.distance,deSerialized.distance);
        System.assertEquals(original.latitude,deSerialized.latitude);
        System.assertEquals(original.longitude,deSerialized.longitude);
        System.assertEquals(null,deSerialized.keyword);
        System.assertEquals(null,deSerialized.getAttributeSearchCriteria());
        System.assertNotEquals(null,deSerialized.getGeoSearchCriteria());
    }
    
    private static testmethod void testDeSerializeBadGeoCriteria(){
        scenario1();
        final SearchForm deSerialized = SearchForm.deSerialize('address=x,distance=x,latitude=x,longitude=x');
        System.assertEquals(null,deSerialized.getGeoSearchCriteria());
    }
    
    private static testmethod void testSerializeCombined(){

        scenario1();
        final SearchForm original = SearchForm.blank();
        original.keyword = 'ab=c';
        original.address = '1 Broadway, New York, NY 10001';
        original.unit = 'miles';
        original.distance = 5;
        original.latitude = 1.1;
        original.longitude = 1.1;
        original.basicFields.get(0).value = 'Retail';
        original.basicFields.get(1).value = 'true';
        original.advancedFields.get(0).value = 'x';
        
        final SearchForm deSerialized = SearchForm.deSerialize(original.serialize());
        System.assertEquals(original.keyword,deSerialized.keyword);
        System.assertEquals(original.address,deSerialized.address);
        System.assertEquals(original.unit,deSerialized.unit);
        System.assertEquals(original.distance,deSerialized.distance);
        System.assertEquals(original.latitude,deSerialized.latitude);
        System.assertEquals(original.longitude,deSerialized.longitude);
        System.assertNotEquals(null,deSerialized.getAttributeSearchCriteria());
        System.assertNotEquals(null,deSerialized.getGeoSearchCriteria());
    }

    private static testmethod void testWithoutSearchFields(){
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS,'');
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_SCREEN_ADVANCED_SEARCH_FIELDS,'');
        final SearchForm form = SearchForm.blank();
        System.assertNotEquals(null,form.basicFields);
        System.assertNotEquals(null,form.advancedFields);
        System.assertEquals(0,form.basicFields.size());
        System.assertEquals(0,form.advancedFields.size()); 
        System.debug(form.toStr);
    }
    
    private static testmethod void testWithSearchFields(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        
        System.assertEquals(null,form.keyword);
        System.assertEquals(null,form.address);
        System.assertEquals(null,form.unit);
        System.assertEquals(null,form.latitude);
        System.assertEquals(null,form.longitude);
        System.assertNotEquals(null,form.distanceOptions);
        System.assertNotEquals(null,form.basicFields);
        System.assertNotEquals(null,form.advancedFields);

        System.assertEquals(2,form.basicFields.size());
        System.assertEquals(2,form.advancedFields.size());

        System.assertEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());
    }
    
    private static testmethod void testKeywordSearch(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        System.assertEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());
        form.keyword = 'abc';
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertEquals('(Account__r.name like \'abc\' OR name like \'abc\')',form.getAttributeSearchCriteria().toSoql());
    }
    
    private static testmethod void testFieldSearch(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        System.assertEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());
        form.basicFields.get(0).value = 'Retail';
        System.assertNotEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());
        System.assertEquals('account__r.Rating = \'Retail\'',form.getAttributeSearchCriteria().toSoql());
    }
        
    private static testmethod void testGeoSearch(){
        scenario1();
        final SearchForm form = SearchForm.blank();
        System.assertEquals(null,form.getAttributeSearchCriteria());
        System.assertEquals(null,form.getGeoSearchCriteria());

        form.address = '1 Broadway';
        form.unit = 'kilometers';
        form.distance = 10;
        form.latitude = 0;
        form.longitude = 0;

        System.assertEquals(null,form.getAttributeSearchCriteria());
        System.assertNotEquals(null,form.getGeoSearchCriteria());
    }
        
    private static void scenario1(){
        TestData.ensureVariableExists(
           Configuration.KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS,
           'Account.Industry=>Rating|Partner_Location__c.Is_Primary__c'
        );
        TestData.ensureVariableExists(
           Configuration.KEY_SEARCH_SCREEN_ADVANCED_SEARCH_FIELDS,
           'Account.Type|Account.AnnualRevenue'
        );
        System.assert(true);
    }
    
}