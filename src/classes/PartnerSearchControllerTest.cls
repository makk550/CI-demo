@IsTest
private class PartnerSearchControllerTest {

    private static testmethod void testSearch_Keyword_Deserialize(){
        final PartnerSearchController controller = new PartnerSearchController();
        controller.getMessages();
        controller.paramString = 'keyword=Aleurometer';
        System.assertEquals(null,controller.doOnLoad());

        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        Integer beforeScaffold = controller.hits.size();

        scaffoldScenario1();
        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        Integer afterScaffold = controller.hits.size();

        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        System.assert(afterScaffold > beforeScaffold);
        
        Object x = null;
        SearchHitWrapper hit = controller.hits.get(0);
        x = hit.resultSequenceNumber;
        x = hit.locationName;
        x = hit.locationId;
        x = hit.partnerName;
        x = hit.partnerAccountId;
        x = hit.website;
        x = hit.isPrimary;
        //comment below code(Point_of_Contact_Phone__c) for changing data type of phone.  sandeep dstsa01 
        x = hit.pointOfContactPhone;
        x = hit.pointOfContactName;
        x = hit.pointOfContactEmail;
        x = hit.description;
        x = hit.street;
        x = hit.city;
        x = hit.stateProvince;
        x = hit.postalCode;
        x = hit.country;
        x = hit.longitude;
        x = hit.latitude;
        x = hit.point;
        x = hit.containsDistance;
        x = hit.distanceInKilometers;
        x = hit.distanceInMiles;
        x = hit.isRecommended;
        x = hit.logoId;
        
        
    }

    private static testmethod void testSearch_Keyword(){
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_SCREEN_FIELDS_IN_RESULT_LIST,'Account.Industry');
        final PartnerSearchController controller = new PartnerSearchController();

        System.assertEquals('{ "locations" : []}',controller.locationsJSON);
        System.assertEquals(null,controller.searchSerialized);
        System.assertEquals(null,controller.config);
        System.assertEquals(null,controller.form);
        System.assertEquals(null,controller.hits);
        System.assertEquals(null,controller.paginator);
        System.assertEquals(null,controller.displayAdvancedSearchFlag);
        System.assertEquals(null,controller.displaySearchResultsFlag);
        System.assertEquals(null,controller.sortColumn);
        
        System.assertEquals(null,controller.doOnLoad());
        
        System.assertEquals('{ "locations" : []}',controller.locationsJSON);
        System.assertEquals(null,controller.searchSerialized);
        System.assertNotEquals(null,controller.config);
        System.assertNotEquals(null,controller.form);
        System.assertNotEquals(null,controller.hits);
        System.assertEquals(0,controller.hits.size());
        System.assertNotEquals(null,controller.paginator);
        System.assertNotEquals(null,controller.displayAdvancedSearchFlag);
        System.assertEquals(null,controller.displaySearchResultsFlag);
        System.assertEquals(null,controller.sortColumn);
        
        controller.form.keyword = 'Aleurometer';
        
        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        Integer beforeScaffold = controller.hits.size();

        scaffoldScenario1();
        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        Integer afterScaffold = controller.hits.size();

        System.assertEquals(null,controller.searchClicked());
        System.assertNotEquals(null,controller.hits);
        System.assert(afterScaffold > beforeScaffold);
        
        System.assertEquals(false,controller.displayAdvancedSearchFlag);
        System.assertEquals(null,controller.toggleFilter());
        System.assertEquals(true,controller.displayAdvancedSearchFlag);
    }
    
    private static testmethod void testSearch_Sort(){
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_SCREEN_SORTABLE_FIELDS,'Account.Industry');
        TestData.ensureVariableExists(Configuration.KEY_SEARCH_SCREEN_FIELDS_IN_RESULT_LIST,'Account.Industry');
        final PartnerSearchController controller = new PartnerSearchController();
        System.assertEquals(null,controller.doOnLoad());
        System.assertNotEquals(null,controller.getSortColumnList());
        System.assert(controller.getSortColumnList().size() > 0);

    }

    private static Scenario2Scaffolding scaffoldScenario1(){
        final Account account = new Account(
            Name='Aerugo'
            ,Profile_Published_to_Partner_Finder__c='Yes'
            ,Approved_for_Partner_Finder__c=true
            ,Partner_User_Agreed_to_PF_Terms_Cond__c=UserInfo.getUserId()
            ,Partner_Date_Agreed_to_PF_Terms_Cond__c=Datetime.now()
            ,Rating = 'Hot',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert account;
        account.IsPartner = true;
        update account;
        System.assert(account.Id != null);
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
        return new Scenario2Scaffolding(account,locations);
    }

}