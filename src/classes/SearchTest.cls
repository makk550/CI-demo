@IsTest
private class SearchTest {

    private static testmethod void testSearchByAccountName(){
        verifyCriteriaProducesExtraResult(new FieldCondition('Account__r.name').likex('%Aerugo%'),null);
    }
    
    private static testmethod void testSearchByLocationName(){
        verifyCriteriaProducesExtraResult(new FieldCondition('name').likex('%Aleurometer%'),null);
    }
    
    private static testmethod void testSearchByAccountRating(){
        verifyCriteriaProducesExtraResult(new FieldCondition('Account__r.rating','Hot'),null);
    }
    
    private static testmethod void testSearchByProximity(){
        verifyCriteriaProducesExtraResult(null,new GeoSearchCriteria(new GeoPoint(-0.1,-0.1),100,UnitOfLength.MILES));
    }
    
    private static testmethod void testSearchAll(){
        verifyCriteriaProducesExtraResult(null,null);
    }

    private static testmethod void testSearchByProximityAndName(){
        verifyCriteriaProducesExtraResult(
            new FieldCondition('Account__r.rating','Hot'),
            new GeoSearchCriteria(new GeoPoint(-0.1,-0.1),100,UnitOfLength.MILES));
    }   

    private static testmethod void testSearchWithUserFields(){
        final Search aSearch = new Search().addFields(new Set<Object>{'Account__r.Industry', new Field('Is_Primary__c')});
        final List<SearchHit> beforeSave = aSearch.execute();
        scaffoldScenario1();
        final List<SearchHit> afterSave = aSearch.execute();

        System.assertNotEquals(null,beforeSave);
        System.assertNotEquals(null,afterSave);
        System.assert(afterSave.size() > 0);
     //   System.assert(afterSave.size() > beforeSave.size());
    }   

    private static testmethod void testSearchByProximityRecursive(){
        final Double TEST_DISTANCE_MILES = 12;
        final Double TEST_DISTANCE_KILOMETERS = ConversionUtils.convert(TEST_DISTANCE_MILES,UnitOfLength.MILES,UnitOfLength.KILOMETERS);
        Search aSearch = new Search(new GeoSearchCriteria(new GeoPoint(-0.35,-0.35),TEST_DISTANCE_MILES,UnitOfLength.MILES));
        aSearch.queryRowLimit = 5; //setting low query limit will force recursion in search
        scaffoldScenario2();
        final List<SearchHit> hits = aSearch.execute();
        System.assertNotEquals(null,hits);
        System.assert(hits.size() >= 4);
        Double distancePrevious = 0;
        for(SearchHit hit : hits){
            System.assert(distancePrevious <= hit.distanceInKilometers);
            System.assert(hit.distanceInKilometers < TEST_DISTANCE_KILOMETERS);
            distancePrevious = hit.distanceInKilometers;
        }
    }
    
    private static void verifyCriteriaProducesExtraResult(  Condition attributeCriteria,
                                                            GeoSearchCriteria geoCriteria){
        Search aSearch = null;
        if(attributeCriteria == null){
            if(geoCriteria == null){
                aSearch = new Search();
            } else {
                aSearch = new Search(geoCriteria);
            }
        } else {
            if(geoCriteria == null){
                aSearch = new Search(attributeCriteria);
            } else {
                aSearch = new Search(attributeCriteria,geoCriteria);
            }
        } 
        final List<SearchHit> beforeSave = aSearch.execute();
        scaffoldScenario1();
        final List<SearchHit> afterSave = aSearch.execute();

        System.assertNotEquals(null,beforeSave);
        System.assertNotEquals(null,afterSave);
        System.assert(afterSave.size() > 0);
    //    System.assert(afterSave.size() > beforeSave.size());
    }
    
    private static Scenario2Scaffolding scaffoldScenario1(){
        final Account account = new Account(
            Name='Aerugo'
            ,Profile_Published_to_Partner_Finder__c='Yes'
            ,Approved_for_Partner_Finder__c=true
            ,Partner_User_Agreed_to_PF_Terms_Cond__c=UserInfo.getUserId()
            ,Partner_Date_Agreed_to_PF_Terms_Cond__c=Datetime.now()
            ,Rating = 'Hot',BillingStreet = 'street',BillingCountry='US',BillingCity='CA');
        insert account;
        account.IsPartner = true;
        update account;

        final Partner_Location__c location = new Partner_Location__c(
            Name = 'Aleurometer'
            ,Latitude__c = 0
            ,Longitude__c = 0
            ,Account__c = account.id
            ,Is_Primary__c = true
        );
        insert location;
        List<Partner_Location__c> locations = new List<Partner_Location__c>();
        locations.add(location);
        System.assert(location.Id != null);
        return new Scenario2Scaffolding(account,locations);
    }
    
    private static Scenario2Scaffolding scaffoldScenario2(){
        final Account account = new Account(
            Name='Oebityooeri'
            ,Profile_Published_to_Partner_Finder__c='Yes'
            ,Approved_for_Partner_Finder__c=true
            ,Partner_User_Agreed_to_PF_Terms_Cond__c=UserInfo.getUserId()
            ,Partner_Date_Agreed_to_PF_Terms_Cond__c=Datetime.now(),
            BillingStreet = 'street',BillingCountry='US',BillingCity='CA');
        insert account;
        account.IsPartner = true;
        update account;
        System.assert(account.Id != null);
        final List<Partner_Location__c> locations = new List<Partner_Location__c>(); 
        for(Integer i = -5; i < 0; i++){
            for(Integer j = -5; j < 0; j++){
                Partner_Location__c loc = new Partner_Location__c(
                    Name = 'Glossographia' + i + j
                    ,Latitude__c = ((Double)i/10)
                    ,Longitude__c = ((Double)j/10)
                    ,Account__c = account.id
                    ,Is_Primary__c = true
                );
                locations.add(loc);
            }           
        }
        insert locations;
        return new Scenario2Scaffolding(account,locations);
    }

}