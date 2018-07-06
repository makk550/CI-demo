@IsTest
private class TestLocation {

    private static testmethod void testAll(){
    
    Account acct = new Account(
            name = 'test',
            Approved_for_Partner_Finder__c = true,
            Profile_Published_to_Partner_Finder__c = 'Yes',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert acct;
        
        Partner_Location__c sobj = new Partner_Location__c();
        sobj.Name = 'test';
        sobj.Latitude__c = 5.5;
        sobj.Longitude__c = 4.4;
        sobj.Street__c = '123 Main';
        sobj.City__c = 'New York';
        sobj.State_Province__c = 'NY';
        sobj.Postal_Code__c = '10001';
        sobj.Country__c = 'UNITED STATES';
        sobj.account__c = acct.id;
        insert sobj;

        Location loc = Location.build(sobj);
        System.assertEquals(sobj.Id, loc.Id );
        System.assertEquals(sobj.Name, loc.name);
        System.assertEquals(sobj.Latitude__c, loc.latitude);
        System.assertEquals(sobj.Longitude__c, loc.longitude);
        System.assertEquals(sobj.Street__c, loc.street);
        System.assertEquals(sobj.City__c, loc.city);
        System.assertEquals(sobj.State_Province__c, loc.state);
        System.assertEquals(sobj.Postal_Code__c, loc.postalCode);
        System.assertEquals(sobj.Country__c, loc.country);
        loc.serialNumber = 1;
        
        System.assertEquals(
            '{"id":"' + sobj.id 
            + '","name":"test"' 
            + ',"latitude":5.5' 
            + ',"longitude":4.4' 
            + ',"street":"123 Main"' 
            + ',"city":"New York"' 
            + ',"state":"NY"' 
            + ',"postalCode":"10001"' 
            + ',"country":"UNITED STATES"' 
            + ',"serialNumber":1' 
            + '}', loc.toJSON());
    }

}