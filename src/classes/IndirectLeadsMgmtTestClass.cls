@isTest
private class IndirectLeadsMgmtTestClass {

    // *** test methods for Leads fields update triggers: before insert & before update trigger *** //
    @isTest(SeeAllData=true)
    static void testLeadUpdateFieldsTriggers() {
        
        String uid = UserInfo.getUserId();

        List<User> usr = [Select Id,Name,PMFKey__c from User where PMFKey__c != null and IsActive=true and id != :uid limit 1];       
        /*Create new accont list*/
        List<Account> lstAcc=new List<Account>();      
        //create test Accounts
        Account commericialAccount = new Account();
        commericialAccount.Name = 'commericialAccount';
        commericialAccount.Lead_Rating__c = 'B';
        commericialAccount.Customer_Category__c = 'Commercial';
        commericialAccount.Account_Status__c = 'Approved';
        commericialAccount.Reseller_Type__c = 'Value';
        commericialAccount.BillingState = 'NY';
        commericialAccount.Commercial_ID__c =   '12';
        commericialAccount.Commercial_Account_Name__c = 'caName';
        commericialAccount.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert commericialAccount;
        lstAcc.add(commericialAccount);

        Account aggregateAccount = new Account();
        aggregateAccount.Name = 'acc';
        aggregateAccount.Lead_Rating__c = 'B';
        aggregateAccount.Customer_Category__c = 'Commercial';
        aggregateAccount.Account_Status__c = 'Approved';
        aggregateAccount.Reseller_Type__c = 'Value';
        aggregateAccount.BillingState = 'NY';
        aggregateAccount.Aggregate_Account__c = 'Yes';
        aggregateAccount.Commercial_ID__c =     '12';
        aggregateAccount.Commercial_Account_Name__c = 'caName';
        aggregateAccount.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert aggregateAccount;
        lstAcc.add(aggregateAccount);

        Account commericialAccount2 = new Account();
        commericialAccount2.Name = 'acc1';
        commericialAccount2.Lead_Rating__c = 'B';
        commericialAccount2.Customer_Category__c = 'Commercial';
        commericialAccount2.Account_Status__c = 'Approved';
        commericialAccount2.Reseller_Type__c = 'Value';
        commericialAccount2.BillingState = 'NY';
        commericialAccount2.Commercial_ID__c =  '12';
        commericialAccount2.Commercial_Account_Name__c = 'caName';
        commericialAccount2.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert commericialAccount2;
        lstAcc.add(commericialAccount2);

        Account aggregateAccount2 = new Account();
        aggregateAccount2.Name = 'acc1';
        aggregateAccount2.Lead_Rating__c = 'B';
        aggregateAccount2.Customer_Category__c = 'Commercial';
        aggregateAccount2.Account_Status__c = 'Approved';
        aggregateAccount2.Reseller_Type__c = 'Value';
        aggregateAccount2.BillingState = 'NY';
        aggregateAccount2.Aggregate_Account__c = 'Yes';
        aggregateAccount2.Commercial_ID__c =    '12';
        aggregateAccount2.Commercial_Account_Name__c = 'caName';
        aggregateAccount2.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert aggregateAccount2;
        lstAcc.add(aggregateAccount2);
        
        //create a test reseller acc.
        Account resellerAcc = new Account();
        resellerAcc.Name = 'testAcc2';
        resellerAcc.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        resellerAcc.Country_Picklist__c = 'INDIA';
        resellerAcc.GEO__c = 'NA';
        resellerAcc.Account_Status__c = 'Approved';
        resellerAcc.Aggregate_Account__c = 'NO';
        resellerAcc.Customer_Category__c = 'Reseller';
        resellerAcc.Reseller_Disti_Regional_ID__c = 'id1';
        resellerAcc.Reseller_Distributor_Name__c = 'rdName';
        resellerAcc.Reseller_Type__c = 'RMDM';
        resellerAcc.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert resellerAcc;
        lstAcc.add(resellerAcc);
        
        insert lstAcc;
        // create volume customers
        /*Create a list of volume customer*/
        List<Volume_Customer__c> lstVc=new List<Volume_Customer__c>();
        Volume_Customer__c voc = new Volume_Customer__c();
        voc.Account__c = aggregateAccount.Id;
        voc.Name = 'volCust';
        //insert voc;
        lstVc.add(voc);        
        Volume_Customer__c voc1 = new Volume_Customer__c();
        voc1.Account__c = aggregateAccount2.Id;
        voc1.Name = 'volCust1';
        //insert voc1;        
        lstVc.add(voc1);
        Volume_Customer__c voc2 = new Volume_Customer__c();
        voc2.Account__c = aggregateAccount2.Id;
        voc2.Name = 'volCust2';
        //insert voc2;                
        lstVc.add(voc2);
        insert lstVc;
        //create test Contacts
        /*Create List of contact*/
        List<Contact> lstCon=new List<Contact>();
        Contact volumeContact = new Contact();
        volumeContact.LastName = 'LName';
        volumeContact.AccountId = aggregateAccount.Id;
        volumeContact.Volume_Customer__c = voc.Id;
        //insert volumeContact;
        lstCon.add(volumeContact);
        Contact volumeContact2 = new Contact();
        volumeContact2.LastName = 'LName';
        volumeContact2.AccountId = aggregateAccount2.Id;
        volumeContact2.Volume_Customer__c = voc1.Id;
        //insert volumeContact2;
        lstCon.ADD(volumeContact2);
        Contact commericialContact = new Contact();
        commericialContact.LastName = 'LName';
        commericialContact.AccountId = commericialAccount.Id;        
        //insert commericialContact;
        lstCon.add(commericialContact);
        Contact resellerConatct = new Contact();
        resellerConatct.LastName = 'LName';
        resellerConatct.AccountId = resellerAcc.Id;
        //insert resellerConatct;
        lstCon.add(resellerConatct);

        Contact commericialContact2 = new Contact();
        commericialContact2.LastName = 'LName';
        commericialContact2.AccountId = commericialAccount2.Id;
        commericialContact2.CIDB_Contact_ID__c = '111';
        //insert commericialContact2;
        lstCon.add(commericialContact2);
        
        insert lstCon;
        
        // create a test Lead
        /*Create Lead List*/
        List<Lead> lstLead=new List<Lead>();
        Lead testLead = new Lead();
        testLead.LastName = 'John';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.Volume_Customer__c = voc.Id;
        testLead.Account_Contact__c = volumeContact.Id;
        testLead.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead.Reseller_Initiated__c = false;
        testLead.CIDB_Contact_ID__c = '1001';
        testLead.SAP_Site_ID__c = '2001';
        testLead.TOPS_Site_ID__c = '3001';
        testLead.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        //insert testLead;
        lstLead.add(testLead);
        /*Lead without comm acc, Volume acc, volume acc contact*/
        Lead testLead7 = new Lead();
        testLead7.LastName = '7John';
        testLead7.FirstName = 'Kerry';
        testLead7.Company = 'X7YZ';
        testLead7.Status = 'Contacted';
        //testLead.Volume_Customer__c = voc.Id;
        //testLead.Account_Contact__c = volumeContact.Id;
        testLead7.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead7.Reseller_Initiated__c = false;
        testLead7.CIDB_Contact_ID__c = '1001';
        testLead7.SAP_Site_ID__c = '2001';
        testLead7.TOPS_Site_ID__c = '3001';
        testLead7.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        lstLead.add(testLead7);
        
        
        Lead testLead8= new Lead();
        testLead8.LastName = '7John';
        testLead8.FirstName = 'Kerry';
        testLead8.Company = 'X78YZ';
        testLead8.Status = 'Contacted';
        testLead8.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead8.Reseller_Initiated__c = false;
        testLead8.CIDB_Contact_ID__c = '1001';
        testLead8.SAP_Site_ID__c = '2001';
        testLead8.TOPS_Site_ID__c = '3001';
        testLead8.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        lstLead.add(testLead8);
                
        // create a test Lead
        Lead testLead1 = new Lead();
        testLead1.LastName = 'John1';
        testLead1.FirstName = 'Kerry';
        testLead1.Company = 'XYZ';
        testLead1.Status = 'Contacted';
        testLead1.Commercial_Account__c = commericialAccount2.Id;
        testLead1.Account_Contact__c = commericialContact2.Id;
        testLead1.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead1.Reseller_Initiated__c = false;
        testLead1.CIDB_Contact_ID__c = '111';
        testLead1.SAP_Site_ID__c = '2001';
        testLead1.TOPS_Site_ID__c = '3001';
        testLead1.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        //insert testLead1;
        lstLead.add(testLead1);

        // create a test Lead
        Lead testLead2 = new Lead();
        testLead2.LastName = 'John2';
        testLead2.FirstName = 'Kerry';
        testLead2.Company = 'XYZ';
        testLead2.Status = 'Contacted';
        testLead2.Commercial_Account__c = commericialAccount.Id;
        testLead2.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead2.Reseller_Initiated__c = false;
        testLead2.Lead_Owner_PMF__c = 'as1'; 
        testLead2.CIDB_Contact_ID__c = '1111';
        testLead2.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        testLead2.TOPS_Site_ID__c = '3001';        
        //insert testLead2;
        lstLead.add(testLead2);
 
         // create a test Lead, with Reseller_Initiated__c = true
        Lead testLead3 = new Lead();
        testLead3.LastName = 'John2';
        testLead3.FirstName = 'Kerry';
        testLead3.Company = 'XYZ';
        testLead3.Status = 'Contacted';
        testLead3.Commercial_Account__c = commericialAccount.Id;
        testLead3.Reseller_Initiated__c = true;
        testLead3.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead3.Lead_Owner_PMF__c = 'as1'; 
        testLead3.CIDB_Contact_ID__c = '111';
        if(usr.size() > 0)
        {           
            testLead3.Lead_Owner_PMF__c = usr.get(0).PMFKey__c;
        }
        else
        {
            testLead3.Lead_Owner_PMF__c = 'ting1';
        }
        testLead3.Reseller__c = resellerAcc.Id;
        testLead3.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        testLead3.Opportunity_Deal_Type__c = 'IND-RMDM';
        testLead3.MKT_BU_Category__c = 'RMDM';
        testLead3.TOPS_Site_ID__c = '3001';                
        //insert testLead3;
        lstLead.add(testLead3);

        // create a test Lead
        Lead testLead4 = new Lead();
        testLead4.LastName = 'John2';
        testLead4.FirstName = 'Kerry';
        testLead4.Company = 'XYZ';
        testLead4.Status = 'Contacted';
        testLead4.Reseller_Initiated__c = false;
        testLead4.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead4.CIDB_Contact_ID__c = '111';
        testLead4.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        //insert testLead4;
        lstLead.add(testLead4);

        // create a test Lead
        Lead testLead5 = new Lead();
        testLead5.LastName = 'John5';
        testLead5.FirstName = 'Kerry';
        testLead5.Company = 'XYZ';
        testLead5.Status = 'Contacted';
        testLead5.Reseller_Initiated__c = false;
        testLead5.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead5.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        //insert testLead5;
        lstLead.add(testLead5);
       
       //insert lstLead;
           try{ 
                insert lstLead;
                }
                catch(exception e)
                {
                }  
        // update Lead details
        List<Lead> lstLeadToUpdate =new List<Lead>();
        testLead.Account_Contact__c = volumeContact2.Id;
        testLead.Volume_Customer__c = voc1.Id;
        //upsert testLead;
        lstLeadToUpdate.add(testLead);
        testLead2.Account_Contact__c = volumeContact.Id;
        testLead2.Volume_Customer__c=voc.Id;
        testLead2.Commercial_Account__c=null;
        //upsert testLead2; 
        lstLeadToUpdate.add(testLead2);
        testLead5.status = 'Pulled Back';
        testLead5.Commercial_Account__c = commericialAccount.Id;
        if(usr.size() > 0)
        {           
            testLead5.ownerId = usr.get(0).Id;
        }
        //upsert testLead5;
        lstLeadToUpdate.add(testLead5);
        
        testLead7.Volume_Customer__c = voc.Id;
        testLead7.Account_Contact__c = volumeContact.Id;
        testLead8.Commercial_Account__c=commericialAccount.id;
        lstLeadToUpdate.add(testLead7);
        lstLeadToUpdate.add(testLead8);
        Try{
           upsert lstLeadToUpdate;          
        }
        Catch(Exception e){
        }  
        testLead5.status = 'Pulled Back';
        testLead5.Commercial_Account__c = commericialAccount.Id;
        testLead5.ownerId = SystemIdUtility.getLeadQueueOwnerId();
        try{
        upsert testLead5;          
        }
        catch(exception e)
        {}
    }
    // *** test method for SendChildRecordsToCPMS trigger
    @isTest(SeeAllData=true)
    static void testSendChildRecordsTrigger() {

            //create a test commercial acc.
            List<Account> lstAcc=new List<Account>();
            Account acct = new Account();
            acct.Name = 'Test Acc';
            acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
            acct.Country_Picklist__c = 'INDIA';
            acct.GEO__c = 'NA';
            acct.Account_Status__c = 'Approved';
            acct.Aggregate_Account__c = 'Yes';
            acct.Customer_Category__c = 'Commercial';
            acct.Commercial_Account_Name__c = 'commAcc';
            acct.Commercial_ID__c = 'commId';
            acct.Global_ID__c = 'globId';
            acct.Global_Name__c = 'globName';
            //insert acct;
            lstAcc.add(acct);

            // create a test reseller account
            Account acc1 = new Account();
            acc1.Name = 'Test Acc1';
            acc1.Lead_Rating__c = 'B';
            acc1.Customer_Category__c = 'Reseller';
            acc1.Account_Status__c = 'Approved';
            acc1.Reseller_Type__c = 'Value';
            acc1.BillingState = 'NY';
            acc1.Reseller_Disti_Regional_ID__c = '12';
            acc1.Reseller_Distributor_Name__c = 'rdName';       
            acc1.Reseller_Type__c = 'RMDM';
            acc1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
            //insert acc1;
            lstAcc.add(acc1);
            insert lstAcc;
                                
            // create a test lead
            List<Lead> lstLead=new List<Lead>();
            Lead ld = new Lead();
            ld.LastName = 'TestL';
            ld.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
            ld.LastName = 'Kelly';
            ld.Company = 'Google';
            ld.Status = 'Contacted';
            ld.GEO__c = 'NA';
            ld.MKT_BU_Category__c = 'RMDM';
            ld.Product__c = 'Volume';
            ld.Reseller__c = acc1.Id;
            ld.Opportunity_Deal_Type__c = 'IND-RMDM';
            ld.Reseller_Milestone__c = '10% - Discovery & Assessment';
            lstLead.add(ld);     
            try{ 
                insert lstLead;
                }
                catch(exception e)
                {
                }        
                
                         
                
            // create a test opportunity
            RecordType rp = [select Id from RecordType where sObjectType='Opportunity' and name='New Opportunity' limit 1];
            List<Opportunity> lstOpp=new List<Opportunity>();
            Opportunity opp = new Opportunity(
                    /*recordTypeId=SystemIdUtility.getIndirectISBURecordTypeId()*/ recordTypeId = rp.Id,
                    Name = 'testOpp1'
                    , CloseDate = Date.today()
                    , StageName = 'test'
                    , AccountId = ld.Reseller__c
                    , Ent_Comm_Account__c = acct.Id,
                    Lead_to_Oppty__c=true
                    );
            //insert opp;
          //  lstOpp.add(opp);
            insert lstOpp;
            
            upsert acc1;
    }
    @isTest(SeeAllData=true)
    static void testLeadUpdateFieldsLastCoverage() {
        
        String uid = UserInfo.getUserId();

        List<User> usr = [Select Id,Name,PMFKey__c from User where PMFKey__c != null and IsActive=true and id != :uid limit 1];       
        /*Create new accont list*/
        List<Account> lstAcc=new List<Account>();      
        //create test Accounts
        Account commericialAccount = new Account();
        commericialAccount.Name = 'commericialAccount';
        commericialAccount.Lead_Rating__c = 'B';
        commericialAccount.Customer_Category__c = 'Commercial';
        commericialAccount.Account_Status__c = 'Approved';
        commericialAccount.Reseller_Type__c = 'Value';
        commericialAccount.BillingState = 'NY';
        commericialAccount.Commercial_ID__c =   '12';
        commericialAccount.Commercial_Account_Name__c = 'caName';
        commericialAccount.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        lstAcc.add(commericialAccount);

        Account aggregateAccount = new Account();
        aggregateAccount.Name = 'acc';
        aggregateAccount.Lead_Rating__c = 'B';
        aggregateAccount.Customer_Category__c = 'Commercial';
        aggregateAccount.Account_Status__c = 'Approved';
        aggregateAccount.Reseller_Type__c = 'Value';
        aggregateAccount.BillingState = 'NY';
        aggregateAccount.Aggregate_Account__c = 'Yes';
        aggregateAccount.Commercial_ID__c =     '12';
        aggregateAccount.Commercial_Account_Name__c = 'caName';
        aggregateAccount.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert aggregateAccount;
        lstAcc.add(aggregateAccount);

        Account commericialAccount2 = new Account();
        commericialAccount2.Name = 'acc1';
        commericialAccount2.Lead_Rating__c = 'B';
        commericialAccount2.Customer_Category__c = 'Commercial';
        commericialAccount2.Account_Status__c = 'Approved';
        commericialAccount2.Reseller_Type__c = 'Value';
        commericialAccount2.BillingState = 'NY';
        commericialAccount2.Commercial_ID__c =  '12';
        commericialAccount2.Commercial_Account_Name__c = 'caName';
        commericialAccount2.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert commericialAccount2;
        lstAcc.add(commericialAccount2);

        Account aggregateAccount2 = new Account();
        aggregateAccount2.Name = 'acc1';
        aggregateAccount2.Lead_Rating__c = 'B';
        aggregateAccount2.Customer_Category__c = 'Commercial';
        aggregateAccount2.Account_Status__c = 'Approved';
        aggregateAccount2.Reseller_Type__c = 'Value';
        aggregateAccount2.BillingState = 'NY';
        aggregateAccount2.Aggregate_Account__c = 'Yes';
        aggregateAccount2.Commercial_ID__c =    '12';
        aggregateAccount2.Commercial_Account_Name__c = 'caName';
        aggregateAccount2.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert aggregateAccount2;
        lstAcc.add(aggregateAccount2);
        
        //create a test reseller acc.
        Account resellerAcc = new Account();
        resellerAcc.Name = 'testAcc2';
        resellerAcc.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        resellerAcc.Country_Picklist__c = 'INDIA';
        resellerAcc.GEO__c = 'NA';
        resellerAcc.Account_Status__c = 'Approved';
        resellerAcc.Aggregate_Account__c = 'NO';
        resellerAcc.Customer_Category__c = 'Reseller';
        resellerAcc.Reseller_Disti_Regional_ID__c = 'id1';
        resellerAcc.Reseller_Distributor_Name__c = 'rdName';
        resellerAcc.Reseller_Type__c = 'RMDM';
        resellerAcc.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        //insert resellerAcc;
        lstAcc.add(resellerAcc);
        
        insert lstAcc;
        // create volume customers
        /*Create a list of volume customer*/
        List<Volume_Customer__c> lstVc=new List<Volume_Customer__c>();
        Volume_Customer__c voc = new Volume_Customer__c();
        voc.Account__c = aggregateAccount.Id;
        voc.Name = 'volCust';
        //insert voc;
        lstVc.add(voc);        
        Volume_Customer__c voc1 = new Volume_Customer__c();
        voc1.Account__c = aggregateAccount2.Id;
        voc1.Name = 'volCust1';
        //insert voc1;        
        lstVc.add(voc1);
        Volume_Customer__c voc2 = new Volume_Customer__c();
        voc2.Account__c = aggregateAccount2.Id;
        voc2.Name = 'volCust2';
        //insert voc2;                
        lstVc.add(voc2);
        insert lstVc;
        //create test Contacts
        /*Create List of contact*/
        List<Contact> lstCon=new List<Contact>();
        Contact volumeContact = new Contact();
        volumeContact.LastName = 'LName';
        volumeContact.AccountId = aggregateAccount.Id;
        volumeContact.Volume_Customer__c = voc.Id;
        //insert volumeContact;
        lstCon.add(volumeContact);
        Contact volumeContact2 = new Contact();
        volumeContact2.LastName = 'LName';
        volumeContact2.AccountId = aggregateAccount2.Id;
        volumeContact2.Volume_Customer__c = voc1.Id;
        //insert volumeContact2;
        lstCon.ADD(volumeContact2);
        Contact commericialContact = new Contact();
        commericialContact.LastName = 'LName';
        commericialContact.AccountId = commericialAccount.Id;        
        //insert commericialContact;
        lstCon.add(commericialContact);
        Contact resellerConatct = new Contact();
        resellerConatct.LastName = 'LName';
        resellerConatct.AccountId = resellerAcc.Id;
        //insert resellerConatct;
        lstCon.add(resellerConatct);

        Contact commericialContact2 = new Contact();
        commericialContact2.LastName = 'LName';
        commericialContact2.AccountId = commericialAccount2.Id;
        commericialContact2.CIDB_Contact_ID__c = '111';
        //insert commericialContact2;
        lstCon.add(commericialContact2);
        
        insert lstCon;
        
        // create a test Lead
        /*Create Lead List*/
        List<Lead> lstLead=new List<Lead>();
        Lead testLead = new Lead();
        testLead.LastName = 'John';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead.Reseller_Initiated__c = false;
        testLead.CIDB_Contact_ID__c = '1001';
        testLead.SAP_Site_ID__c = '2001';
        testLead.TOPS_Site_ID__c = '3001';
        testLead.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        testLead.Commercial_Account__c=commericialAccount.Id;
        testLead.Account_Contact__c=commericialContact.Id;
        lstLead.add(testLead);
        // create a test Lead
        Lead testLead1 = new Lead();
        testLead1.LastName = 'John1';
        testLead1.FirstName = 'Kerry';
        testLead1.Company = 'XYZ';
        testLead1.Status = 'Contacted';
        testLead1.Commercial_Account__c = commericialAccount2.Id;
        testLead1.Account_Contact__c = commericialContact2.Id;
        testLead1.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead1.Reseller_Initiated__c = false;
        testLead1.CIDB_Contact_ID__c = '111';
        testLead1.SAP_Site_ID__c = '2001';
        testLead1.TOPS_Site_ID__c = '3001';
        testLead1.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        
        lstLead.add(testLead1);

        Lead testLead3 = new Lead();
        testLead3.LastName = 'John2';
        testLead3.FirstName = 'Kerry';
        testLead3.Company = 'XYZ';
        testLead3.Status = 'Contacted';
        testLead3.Reseller_Initiated__c = true;
        testLead3.Country_Picklist__c = 'US - UNITED STATES'; 
        testLead3.Lead_Owner_PMF__c = 'as1'; 
        testLead3.CIDB_Contact_ID__c = '111';
        if(usr.size() > 0)
        {           
            testLead3.Lead_Owner_PMF__c = usr.get(0).PMFKey__c;
        }
        else
        {
            testLead3.Lead_Owner_PMF__c = 'ting1';
        }
        testLead3.Reseller__c = resellerAcc.Id;
        testLead3.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        testLead3.Opportunity_Deal_Type__c = 'IND-RMDM';
        testLead3.MKT_BU_Category__c = 'RMDM';
        testLead3.TOPS_Site_ID__c = '3001';                
        testLead3.Volume_Customer__c=voc.Id;
        testLead3.Account_Contact__c=volumeContact.Id;
        
        lstLead.add(testLead3);

        //insert lstLead;
         try{ 
                insert lstLead;
                }
                catch(exception e)
                {
                }  
        // update Lead details
        List<Lead> lstLeadToUpdate =new List<Lead>();
        testLead.Commercial_Account__c = commericialAccount2.Id;
        testLead.Account_Contact__c = commericialContact2.Id;
        
        
        testLead1.Commercial_Account__c = commericialAccount.Id;
        testLead1.Account_Contact__c = commericialContact.Id;
        
        testLead3.Volume_Customer__c=voc1.Id;
        testLead3.Account_Contact__c=volumeContact2.Id;
        
        if(usr.size() > 0)
        {           
            testLead1.ownerId = usr.get(0).Id;
        }
        lstLeadToUpdate.add(testLead);
        lstLeadToUpdate.add(testLead3);
        lstLeadToUpdate.add(testLead1);
        try{    
        update lstLeadToUpdate;
        }
        Catch(Exception e){
        }          
    }
       
}