@isTest
public class Assign_to_Common_Lead_Pool_Queue_Test {
    
    @isTest
    static void createPartnerUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardDDRuser@gmail.com',
                         Eligible_to_receive_leads__c=true);
        insert u;
        Group test = new Group();
        
            
		test.Name = 'Test Group';
		insert test;
        
        
        
        QueueCust__c que = new QueueCust__c(Name='Common Partner Lead Pool',Queue_ID__c=test.id);
        insert que;
        system.runAs(u){
        update u;
        }
    }
    
    @isTest
    static void createPartnerUser2(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='Generic Support Account 1234we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
        system.assertNotEquals(null, a.id, 'Account inserted');
        
        Contact userCon = new contact(AccountID = a.id,FirstName = 'testuser',
            LastName = 'partnerreferral',
            email = 'testuserpartnerreferral@gmail.com');
            insert userCon;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardDDRuser@gmail.com',
                         Eligible_to_receive_leads__c=true);
        insert u;
        Group test = new Group();
        
            
		test.Name = 'Test Group';
		insert test;
        
        
        
        QueueCust__c que = new QueueCust__c(Name='Common Partner Lead Pool',Queue_ID__c=test.id);
        insert que;
        system.runAs(u){
            u = [select id,Eligible_to_receive_leads__c from user where id=:u.id];
            u.Eligible_to_receive_leads__c = false;
        update u;
        }
    }
    /*
    @isTest
    static void createPortalUser(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        account a = new account(name ='Generic Support Account 1234we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@ca.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            a.OwnerId = portalAccountOwner1.Id;
            Database.insert(a);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = a.Id,
                Email = System.now().millisecond() + 'test@gmail.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345partner@ca.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345partner@ca.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
    }
    */

}