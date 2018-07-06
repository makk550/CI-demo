@isTest(seealldata = true)     
private class CalloutClassTest {
     @isTest static void testCallout() {
     
       Account testAccount = new Account();
     testAccount.Name = 'Generic Support Account'; 
     testAccount.Enterprise_ID__c = '777779';
     testAccount.BillingStreet='Street';
     testAccount.BillingCountry='US';
     testAccount.BillingCity='Islandia'; 
     insert testAccount ;
     
     
        
    Site_Association__c recSA = new Site_Association__c();
    recSA.Name='TestSA8';
    recSA.City__c='TestSA8';
    recSA.Country_picklist__c='US-UnitedStates';
    recSA.State__c='NEW york' ;
    recSA.SC_SITE_Source__c = 'Support';
    recSA.Enterprise_ID__c =testAccount.Id;
    recSA.SC_SITE_Sanctioned_Party__c='NOT VALIDATED';
    Country_Support_Region__c c=new Country_Support_Region__c();
    c.Country__c='US - UNITED STATES';

         
    insert recSA;
      SiteAssociationHandler.doSanctionedPartyCheck(recSA.Id);
          
      Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
     //    SiteAssociationHandler.doSanctionedPartyCheck(recSA.Id);
          Site_Association__c recSA1 = [SELECT  SC_SITE_Sanctioned_Party__c from  Site_Association__c where Id =:recSA.Id];
         
        System.assertEquals('NOT VALIDATED',recSA1.SC_SITE_Sanctioned_Party__c) ;
        Test.stopTest();
      //  System.assertEquals(200, res.getStatusCode());
    }
}