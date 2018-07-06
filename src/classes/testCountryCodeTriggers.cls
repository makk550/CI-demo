@istest
public class testCountryCodeTriggers {
    static testMethod void testCountryCodeTriggers () {
    
        /*Lead lead = new Lead(LastName = 'leadIns1', Company='testco', Country_Picklist__c = '');
        insert lead;

        Lead retLead = [SELECT Id, Country FROM Lead WHERE Id = :lead.Id LIMIT 1];
        System.assert(retLead .Id != null);        
        System.assertEquals(null, retLead .Country);
        
        lead = new Lead(LastName = 'leadIns2', Company='testco', Country_Picklist__c = 'AL - ALBANIA');
        insert lead ;
        retLead = [SELECT Id, Country FROM Lead WHERE Id = :lead.Id LIMIT 1];
        System.assert(retLead .Id != null);        
        System.assertEquals('AL', retLead .Country );
    */
        // test Contact
        Contact contact = new Contact(LastName = 'contactIns1', Country_Picklist__c = '');
        insert contact ;

        Contact retContact = [SELECT Id, MailingCountry FROM Contact WHERE Id = :contact.Id LIMIT 1];
        //System.assert(retContact.Id != null);        
        //System.assertEquals(null, retContact.MailingCountry);
        
        contact = new Contact(LastName = 'contactIns2', Country_Picklist__c = 'AL - ALBANIA');
        insert contact ;
        retContact = [SELECT Id, MailingCountry FROM Contact WHERE Id = :contact.Id LIMIT 1];
        //System.assert(retContact.Id != null);        
        //System.assertEquals('AL', retContact.MailingCountry );

        // test Account
        Account account = new Account(Name = 'acctIns1', Country_Picklist__c = '');
        account.Commercial_Id__c = 'asdf';
        account.BillingStreet = 'Arlington';
        account.BillingCountry = 'US';
        account.BillingCity = 'VA';
        
        insert account ;

        Account retAccount = [SELECT Id, BillingCountry FROM Account WHERE Id = :account.Id LIMIT 1];
        //System.assert(retAccount.Id != null);        
        //System.assertEquals(null, retAccount.BillingCountry );
        
        account = new Account(Name = 'acctIns2', Country_Picklist__c = 'AL - ALBANIA');
        account.Commercial_id__c = 'asdf';
        account.BillingStreet = 'Arlington';
        account.BillingCountry = 'US';
        account.BillingCity = 'VA';
        insert account ;
        retAccount = [SELECT Id, BillingCountry FROM Account WHERE Id = :account.Id LIMIT 1];
        //System.assert(retAccount.Id != null);        
        //System.assertEquals('AL', retAccount.BillingCountry );
        
    }
}