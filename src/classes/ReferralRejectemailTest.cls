@isTest(SeeAllData=true)
public class ReferralRejectemailTest {
    static testMethod void testReferralRejectemailTest(){
        Test.startTest();
       
        //system.assertEquals(WHATYOUEXPECT, l.OwnerID);
        Profile p = [SELECT Id FROM Profile WHERE Name='Referral Partner Profile' limit 1];
        Account acc = new Account();
            acc.Name = 'test CAAcc';
            acc.Country_Picklist__c = 'AL - ALBANIA';
            acc.Account_Status__c = 'New';
            acc.Geo__c = 'EMEA';
            acc.BillingStreet='Arlington';
            acc.BillingCity='NY';
            acc.BillingCountry='US';
            insert acc;
      Contact c = new Contact();
              c.FirstName = 'test contact';
              c.LastName = 'test contact';      
              c.AccountId = acc.Id;
        	  c.email = 'testgys@test.com';
        insert c;
        user u;
        if(p <> null){
            u =new user( FirstName=c.FirstName,ContactId=c.id,LastName=c.LastName, ProfileId = p.Id,Username =c.email,Is_Admin_for_Partner_Finder_Profile__c=true,PortalRole='Executive',Email='testtsd@jsd.com',Alias='testi01',  EmailEncodingKey='UTF-8',TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', LanguageLocaleKey='en_US');
			insert u;
        } 
        Lead ReferralLead;
        if(u <> null) {
            ReferralLead = new Lead();
            ReferralLead.Referral_Partner__c =u.Id;
            ReferralLead.Referral_Partner_Account__c = acc.id;
            ReferralLead.Referral_Date__c = System.today();
            ReferralLead.LeadSource='Partner Referral';
            ReferralLead.FirstName = 'TestReferral';
            ReferralLead.LastName = 'lastReferral';
            ReferralLead.email = 'Test@jshd.com';
            ReferralLead.phone='9999999999';
            ReferralLead.Comments_Field__c='testing Comment';
            ReferralLead.Company='TEST TEST';
           ReferralLead.Street='TEST STREET';
           ReferralLead.City='CITY TEST';
           ReferralLead.PostalCode='763636';
          ReferralLead.Website='www.cddkdsssk.com';
            ReferralLead.Status = 'Rejected';
            ReferralLead.No_Interest_Reason__c='Opportunity Already in CA Forecast';
            insert ReferralLead;
            System.debug('ReferralLead->>>>>'+ReferralLead);
			ReferralLeadRejectionEmail.sendEmailNotification(New ID[]{ReferralLead.id});
    }
        
		  Test.stopTest();
    }
}