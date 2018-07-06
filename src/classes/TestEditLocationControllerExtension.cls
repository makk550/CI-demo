@IsTest
private class TestEditLocationControllerExtension {

    private static testmethod void testNoMapAPIKeyError(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, '');
        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        acct.IsPartner = true;
        update acct;
        Partner_Location__c location = new Partner_Location__c();
        location.account__c = acct.id;
        insert location;
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        //call doOnLoad
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,controller.errorOccurred);
        System.assertEquals(controller.ERROR_NO_MAP_API_KEY,controller.errorCode);
        
    }
    
    private static testmethod void testNoAccountIDError(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');
        Partner_Location__c location = new Partner_Location__c();
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        //call doOnLoad
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,controller.errorOccurred);
        System.assertEquals(controller.ERROR_NO_ACCOUNT_ID,controller.errorCode);
    }
    


    private static testmethod void testCreateAsStandardLicenseUser(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');

        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        acct.IsPartner = true;
        update acct;
        Partner_Location__c location = new Partner_Location__c();
        location.account__c = acct.id;
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        //call doOnLoad
        System.assertEquals(false,location.Is_Primary__c);
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,location.Is_Primary__c);
        
        //call doDetailsDone
        System.assertEquals(false,controller.showConfirmation);
        System.assertEquals(null,controller.doDetailsDone());
        System.assertEquals(true,controller.showConfirmation);
        System.assertEquals(true,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call handleLocationFound
        System.assertEquals(null,controller.handleLocationFound());
        System.assertEquals(false,controller.lookingForLocation);
        System.assertEquals(true,controller.locationFound);
        
        //call handleLocationNotFound
        System.assertEquals(null,controller.handleLocationNotFound());
        System.assertEquals(false,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call doConfirmationPrevious
        System.assertEquals(null,controller.doConfirmationPrevious());
        System.assertEquals(false,controller.showConfirmation);

        //call doCancel
        PageReference next = controller.doCancel();
        System.assertNotEquals(null,next);
        System.assertEquals('/'+acct.id,next.getUrl());

        //call doDetailsDone
        System.assertEquals(false,controller.showConfirmation);
        System.assertEquals(null,controller.doDetailsDone());
        System.assertEquals(true,controller.showConfirmation);
        System.assertEquals(true,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call doConfirmationDone
        next = controller.doConfirmationDone();
        System.assertNotEquals(null,next);
        System.assertEquals('/'+acct.id,next.getUrl());

        TestUtils.assertNoErrorMessagesExist();
    }

    private static testmethod void testEditAsStandardLicenseUser(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');

        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        acct.IsPartner = true;
        update acct;
        Partner_Location__c location = new Partner_Location__c();
        location.account__c = acct.id;
        location.Is_Primary__c = true;
        insert location;
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        //call doOnLoad
        System.assertEquals(true,location.Is_Primary__c);
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,location.Is_Primary__c);
        
        TestUtils.assertNoErrorMessagesExist();
    }


    private static testmethod void testCreateFail(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');

        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        acct.IsPartner = true;
        update acct;
        Partner_Location__c location = new Partner_Location__c();
        location.account__c = acct.id;
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        System.assertEquals(null,controller.doOnLoad());
        TestUtils.assertNoErrorMessagesExist();
        System.assertEquals(false,controller.showConfirmation);
        System.assertEquals(null,controller.doDetailsDone());
        System.assertEquals(true,controller.showConfirmation);
        TestUtils.assertNoErrorMessagesExist();
        location.point_of_contact_email__c = '@';
        System.assertEquals(null,controller.doConfirmationDone());
        TestUtils.assertErrorMessagesExist();
    }

    private static testmethod void testCreateAsPartnerLicenseUser(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');
        Partner_Location__c location = new Partner_Location__c();
        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        location.account__c = acct.id;
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.standardController(location));
        
        //call doOnLoad
        System.assertEquals(false,location.Is_Primary__c);
        System.assertEquals(null,controller.doOnLoad());
        //System.assertEquals(queriedUser.contact.AccountId,location.account__c);
        //call doDetailsDone
        System.assertEquals(false,controller.showConfirmation);
        System.assertEquals(null,controller.doDetailsDone());
        //System.assertEquals(true,controller.showConfirmation);
        //System.assertEquals(true,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call handleLocationFound
        System.assertEquals(null,controller.handleLocationFound());
        System.assertEquals(false,controller.lookingForLocation);
        //System.assertEquals(true,controller.locationFound);
        
        //call handleLocationNotFound
        System.assertEquals(null,controller.handleLocationNotFound());
        System.assertEquals(false,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call doConfirmationPrevious
        System.assertEquals(null,controller.doConfirmationPrevious());
        System.assertEquals(false,controller.showConfirmation);

        //call doCancel
        PageReference next = controller.doCancel();
        System.assertNotEquals(null,next);

        //call doDetailsDone
        System.assertEquals(false,controller.showConfirmation);
        System.assertEquals(null,controller.doDetailsDone());
        //System.assertEquals(true,controller.showConfirmation);
        //System.assertEquals(true,controller.lookingForLocation);
        System.assertEquals(false,controller.locationFound);
        
        //call doConfirmationDone
        next = controller.doConfirmationDone();
        System.assertNotEquals(null,next);

        TestUtils.assertNoErrorMessagesExist();
    }

    private static testmethod void testMake2ndLocationPrimary(){
        TestData.ensureVariableExists(Configuration.KEY_GOOGLE_MAPS_API_KEY, 'test');
        Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        acct.IsPartner = true;
        update acct;
        Partner_Location__c first = new Partner_Location__c();
        first.account__c = acct.id;
        first.Is_Primary__c = true;
        insert first;
        Partner_Location__c second = new Partner_Location__c();
        second.account__c = acct.id;
        
        //build controller
        EditLocationControllerExtension controller = new EditLocationControllerExtension(
            new ApexPages.StandardController(second));
        TestUtils.assertNoErrorMessagesExist();
        
        //call doOnLoad
        System.assertEquals(null,controller.doOnLoad());
        TestUtils.assertNoErrorMessagesExist();
        
        second.Is_Primary__c = true;
        PageReference next = controller.doDetailsDone();
        TestUtils.assertNoErrorMessagesExist();
        System.assertEquals(null,next);

        first = [select id,Is_Primary__c from Partner_Location__c where id = :first.id];
        System.assertEquals(true,first.Is_Primary__c);
        Boolean exceptionCaught = false;
        try{
            second = [select id,Is_Primary__c from Partner_Location__c where id = :second.id];
        }catch(QueryException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught,'Expected QueryException');

        next = controller.doConfirmationDone();
        TestUtils.assertNoErrorMessagesExist();
        System.assertNotEquals(null,next);
        
        first = [select id,Is_Primary__c from Partner_Location__c where id = :first.id];
        System.assertEquals(false,first.Is_Primary__c);
        second = [select id,Is_Primary__c from Partner_Location__c where id = :controller.location.id];
        System.assertEquals(true,second.Is_Primary__c);
    }   
}