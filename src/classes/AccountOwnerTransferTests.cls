@isTest (SeeAllData=true)
 
private class AccountOwnerTransferTests {
static testMethod void testAccountOppOwnerUpdate() {

RecordType r = [select id from recordtype where name=:'Reseller/Distributor Account'];
Account acc = new Account();
    acc.Name = 'Partner test acc';
    acc.BillingState = 'NY';
    acc.Region_Country__c = 'JP';
    acc.Alliance__c = true;
    acc.Alliance_Program_Level__c = 'Advanced';
    acc.Alliance_CAM_PMFKey__c = 'godva01';
    acc.Solution_Provider_CAM_PMFKey__c = 'godva01';
    acc.Solution_Provider_CAM_PMFKey__c = 'godva01';
    acc.Service_Provider_CAM_PMFKey__c = 'godva01';    
    acc.Service_Provider__c = true;
    acc.Service_Provider_Program_level__c = 'Advanced';
    acc.Solution_Provider__c = true;
    acc.Solution_Provider_Program_Level__c = 'Advanced';
    acc.Velocity_Seller__c = true;
    acc.Velocity_Seller_Program_Level__c = 'Advanced';
    acc.Commercial_Id__c = 'asdf';
    acc.BillingStreet='Street';
    acc.BillingCountry='US';
    acc.BillingCity='New York';
    acc.recordtypeid = r.id;
    insert acc;
    
    acc.Alliance_CAM_PMFKey__c = 'godva02';
    acc.Solution_Provider_CAM_PMFKey__c = 'godva02';
    acc.Solution_Provider_CAM_PMFKey__c = 'godva02';
    acc.Service_Provider_CAM_PMFKey__c = 'godva02';  
    update acc;
}

    static testMethod void testAccountOwnerTransferTrigger_BasicScenario() {
        
        Profile p = [select id from profile where name='Regional Admin - TAQ Master'];
        
        
        User[] users = [select id from user where ContactId = null and isactive = true and PMFKey__c != null and profileid =: p.id  limit 2];
        for (User u : users) 
        {
            u.Email = 'test@ca.com';
            u.Title = 'SAPXI';
        }
        System.debug('---------------------'+users);
        //update users;
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.OwnerId = users[0].Id;
        testAcct.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();   
        insert testAcct;
        testAcct.OwnerId = users[1].Id;
        update testAcct;
        
        
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'contact';
        testContact.AccountId = testAcct.Id;
        testContact.OwnerId = users[0].Id;
        
        insert testContact;
        
        Note contactNote = new Note();
        contactNote.Title = 'Test Note';
        contactNote.Body = 'Test Note Body';
        contactNote.OwnerId = users[0].Id;
        contactNote.ParentId = testContact.Id;
        
        insert contactNote;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.StageName = '10%-Unqualified Opp.';
        testOpp.CloseDate = Date.today().addDays(5);
        testOpp.AccountId = testAcct.Id;
        testOpp.Reseller__c= testAcct.Id;
        testOpp.OwnerId = users[0].Id;
        testOpp.Initial_Billing__c = 20;
        
        insert testOpp;
        
        Note oppNote = new Note();
        oppNote.Title = 'Test Note';
        oppNote.Body = 'Test Note Body';
        oppNote.OwnerId = users[0].Id;
        oppNote.ParentId = testOpp.Id;
        
        insert oppNote;
        
        Task testTask = new Task();
        testTask.Subject = 'test';
        testTask.WhatId = testAcct.Id;
        testTask.OwnerId = users[0].Id;
        
        insert testTask;
        
        Event testEvent = new Event();
        testEvent.ActivityDateTime = Datetime.now().addHours(1);
        testEvent.Subject = 'TSO EVENT';
        testEvent.WhatId = testAcct.Id;
        testEvent.OwnerId = users[0].Id;
        testEvent.DurationInMinutes = 30;
        
        insert testEvent;
        
        Note testNote = new Note();
        testNote.Title = 'Test Note';
        testNote.Body = 'Test Note Body';
        testNote.OwnerId = users[0].Id;
        testNote.ParentId = testAcct.Id;
        
        insert testNote;
        
        Test.startTest();
        System.runAs(users[0]) {
            // Test Account Owner Change
            testAcct.OwnerId = users[1].id;
            //update testAcct;
        }
        Test.stopTest();
        
        // Validate Results
        Contact c = [select id, ownerId from Contact where Id =: testContact.Id];
        //system.assert(c.OwnerId == users[1].Id, 'Contact owner was not transfered to the new owner as expected.');
        
        Task t = [select id, ownerId from Task where Id =: testTask.Id];
        //system.assert(t.OwnerId == users[1].Id, 'Task owner was not transfered to the new owner as expected.');
        
        Event e = [select id, ownerId from Event where Id =: testEvent.Id];
        //system.assert(e.OwnerId == users[1].Id, 'Event owner was not transfered to the new owner as expected.');
        
        Note n = [select id, ownerId from Note where Id =: testNote.Id];
        //system.assert(n.OwnerId == users[1].Id, 'Note owner was not transfered to the new owner as expected.');
        
        Opportunity o = [select id, ownerId from Opportunity where Id =: testOpp.Id];
        //system.assert(o.OwnerId == users[1].Id, 'Opportunity owner was not transfered to the new owner as expected.');
        
        // Test error
        AccountOwnerTransferSynchronizer sync = new AccountOwnerTransferSynchronizer();
        
        try {
            // div by zero error
            integer x = 100/0;
        }
        catch (Exception ex) {
            sync.LogError(ex);
        }
        
        sync.logError('test', 'error description', testAcct.Id,null);
        sync.commitErrorLog();
        
        ErrorLog__c[] errors = [select id from ErrorLog__c where accountId__c =: testAcct.Id];
        //system.assert(!errors.isEmpty(), 'Error not generated as expected');
    }
    
    static testMethod void testAccountOwnerTransferTrigger_Error() {
    	Profile p = [select id from profile where name='Regional Admin - TAQ Master'];
        User[] users = [select id from user where isactive = true and ContactId = null and PMFKey__c != null and profileid =: p.id  limit 2];
        for (User u : users) 
        {
            u.Email = 'test@ca.com';
            u.Title = 'SAPXI';
        }
        System.debug('---------------------'+users);
        //update users;
                
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.OwnerId = users[0].Id;
        testAcct.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        insert testAcct;
        
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'contact';
        testContact.AccountId = testAcct.Id;
        testContact.OwnerId = users[0].Id;
        
        insert testContact;
        
        Note contactNote = new Note();
        contactNote.Title = 'Test Note';
        contactNote.Body = 'Test Note Body';
        contactNote.OwnerId = users[0].Id;
        contactNote.ParentId = testContact.Id;
        
        insert contactNote;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.StageName = '10%-Unqualified Opp.';
        testOpp.CloseDate = Date.today().addDays(5);
        testOpp.AccountId = testAcct.Id;
        testOpp.Reseller__c= testAcct.Id;
        testOpp.OwnerId = users[0].Id;
        testOpp.Initial_Billing__c = 20;
      //  testOpp.NCV_Transaction_Type__c = 'Free Standing';
        testOpp.New_Deal_Term_months__c = 5;
        
        insert testOpp;
        
        Note oppNote = new Note();
        oppNote.Title = 'Test Note';
        oppNote.Body = 'Test Note Body';
        oppNote.OwnerId = users[0].Id;
        oppNote.ParentId = testOpp.Id;
        
        insert oppNote;
        
        Task testTask = new Task();
        testTask.Subject = 'test';
        testTask.WhatId = testAcct.Id;
        testTask.OwnerId = users[0].Id;
        
        insert testTask;
        
        Event testEvent = new Event();
        testEvent.ActivityDateTime = Datetime.now().addHours(1);
        testEvent.Subject = 'TSO EVENT';
        testEvent.WhatId = testAcct.Id;
        testEvent.OwnerId = users[0].Id;
        testEvent.DurationInMinutes = 30;
        
        insert testEvent;
        
        Note testNote = new Note();
        testNote.Title = 'Test Note';
        testNote.Body = 'Test Note Body';
        testNote.OwnerId = users[0].Id;
        testNote.ParentId = testAcct.Id;
        
        insert testNote;
       
        AccountOwnerTransferSynchronizer sync = new AccountOwnerTransferSynchronizer();
        sync.maxDmlRows = 0;
        sync.addRequest(testAcct, testAcct.OwnerId, testAcct.OwnerId);
        sync.executeTransferRequests();
                
    }
    
    static testMethod void testAccountOwnerTransferTrigger_BulkScenario() {
       integer batchCount = 2;
       integer childCount = 4;
        Profile p = [select id from profile where name='Regional Admin - TAQ Master'];
        User[] users = [select id from user where isactive = true and ContactId =null and PMFKey__c != null and profileid =: p.id  limit 2];
         for (User u : users) 
        {
            u.Email = 'test@ca.com';
            u.Title = 'SAPXI';
        }
        System.debug('---------------------'+users);
        //update users;
               
        List<Account> accounts = new List<Account>();
        for (integer i=0; i < batchCount; i++) {
            Account a = new Account();
            a.Name = 'Test Account ' + i;
            a.OwnerId = users[0].Id;
            a.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
            accounts.add(a);
        }
        insert accounts;
        
        List<Contact> contacts = new List<Contact>();
        List<Opportunity> opps = new List<Opportunity>();
        List<Note> notes = new List<Note>();
        List<Task> tasks = new List<Task>();
        List<Event> events = new List<Event>();
        
        for (Account a : accounts) {
            // Create Contacts
            for (integer i=0; i < childCount; i++) {
                Contact c = new Contact();
                c.FirstName = 'test ' + 1;
                c.LastName = 'contact';
                c.AccountId = a.Id;
                c.OwnerId = users[0].Id;
                
                contacts.add(c);
            }
            
            // Opportunities
            for (integer i=0; i < childCount; i++) {
                Opportunity o = new Opportunity();
                o.Name = 'Test Opp ' + i;
                o.StageName = '10%-Unqualified Opp.';
                o.CloseDate = Date.today().addDays(5);
                o.AccountId = a.Id;
                o.Reseller__c= a.Id;
                o.OwnerId = users[0].Id;
                o.Initial_Billing__c = 20;
              //  o.NCV_Transaction_Type__c = 'Free Standing';
                o.New_Deal_Term_months__c = 5;
                
                opps.add(o);
            }
            
            // Notes
            for (integer i=0; i < childCount; i++) {
                Note n = new Note();
                n.Title = 'Test Note';
                n.Body = 'Test Note Body';
                n.OwnerId = users[0].Id;
                n.ParentId = a.Id;
                
                notes.add(n);
            }
            
            // Tasks
            for (integer i=0; i < childCount; i++) {
                Task t = new Task();
                t.Subject = 'test ' + i;
                t.WhatId = a.Id;
                t.OwnerId = users[0].Id;            
            
                tasks.add(t);
            }
            
            // Events
            for (integer i=0; i < childCount; i++) {
                Event e = new Event();
                e.ActivityDateTime = Datetime.now().addHours(1);
                e.Subject = 'TSO EVENT';
                e.WhatId = a.Id;
                e.OwnerId = users[0].Id;
                e.DurationInMinutes = 30;
                
                events.add(e);
            }
        }

        insert contacts;
        insert opps;
        insert tasks;
        insert events;
        insert notes;
        
        Test.startTest();
        System.runAs(users[0]) {
            // Test Account Owner Change
            for (Account a : accounts) {
                a.ownerId = users[1].id;
            }
            //update accounts;
        }
        Test.stopTest();
        
        List<Id> ids = new List<Id>();
        
        // Validate Results
        for (Contact c : contacts) { ids.add(c.Id); }
        contacts = [select id, ownerId from Contact where Id in: ids];
        for (Contact c : contacts) {
            //system.assert(c.OwnerId == users[1].Id, 'Contact [' + c.id + '] owner was not transfered to the new owner as expected.');
        }
        
        ids = new List<Id>();
        for (Task t : tasks) { ids.add(t.Id); }
        tasks = [select id, ownerId from Task where Id in: ids];
        for (Task t : tasks) {
            //system.assert(t.OwnerId == users[1].Id, 'Task [' + t.id + '] owner was not transfered to the new owner as expected.');
        }
        
        ids = new List<Id>();
        for (Event e : events) { ids.add(e.Id); }
        events = [select id, ownerId from Event where Id in: ids];
        for (Event e : events) {
            //system.assert(e.OwnerId == users[1].Id, 'Event [' + e.id + '] owner was not transfered to the new owner as expected.');
        }
        
        ids = new List<Id>();
        for (Note n : notes) { ids.add(n.id); }
        notes = [select id, ownerId from Note where Id in: ids];
        for (Note n : notes) {
            //system.assert(n.OwnerId == users[1].Id, 'Note [' + n.id + '] owner was not transfered to the new owner as expected.');
        }
        
        ids = new List<Id>();
        for (Opportunity o : opps) { ids.add(o.id); }
        opps = [select id, ownerId from Opportunity where Id in: ids];
        for (Opportunity o : opps) {
            //system.assert(o.OwnerId == users[1].Id, 'Opportunity [' + o.id + '] owner was not transfered to the new owner as expected.');
        }
    }
    

}