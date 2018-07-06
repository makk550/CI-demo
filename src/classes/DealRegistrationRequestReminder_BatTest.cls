@isTest
public class DealRegistrationRequestReminder_BatTest {
      static testMethod void testMethod1() 
    {
       /* RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
        contact c=new contact();
        c.FirstName='Sesidhar';
        c.LastName='Ponnada';
        c.Email='ponse01@ca.com';
        insert c;
        List<opportunity> lstopp= new List<opportunity>();
       Id RecordTypeIdopp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId();

            opportunity acc = new opportunity();
            acc.Name ='Name test';
            acc.source__c='Deal Registration';
            acc.Deal_Expiration_Date__c=Date.today() + 5;
            acc.Reseller_Contact__c=c.Id;
        acc.RecordTypeId=rec.RecordType_Id__c;
        insert acc;
         opportunity opp = new opportunity();
            opp.Name ='Name test2';
            opp.source__c='Deal Registration';
            opp.Deal_Expiration_Date__c=Date.today() + 5;
            opp.Reseller_Contact__c=c.Id;
        acc.RecordTypeId=RecordTypeIdopp;
            insert opp;*/
           // lstopp.add(acc);
       // lstopp.add(opp);
       
         lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
            RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
            lstrec.add(rec1);
            RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
            lstrec.add(rec2);
            RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
            lstrec.add(rec3);
            RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
            lstrec.add(rec4);
          RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55o', Name='Territory Covered Account');
            lstrec.add(rec5);
              RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFD', Name='SMB');
            lstrec.add(rec7);
                    RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFD', Name='Deal Registration');
            lstrec.add(rec8); 
            RecordTypes_Setting__c rec9 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFP', Name='Partner Opportunity');
            lstrec.add(rec9); 
              RecordTypes_Setting__c rec19 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFN', Name='New Opportunity');
            lstrec.add(rec19); 
            insert lstrec;
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<4;i++) {
            Account a = new Account(Name='TestAccount' + i,BillingState = 'NY',Customer_Category__c = 'Enterprise',GEO__c='NA',
                                        Enterprise_ID__c = '1234te'+i,Enterprise_Account_Name__c = 'rdName',RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId(),
                                            Commercial_ID__c = 'asdf'+i);
            accts.add(a);
        }
        insert accts;
          contact c=new contact();
        c.FirstName='Sesidhar';
        c.LastName='Ponnada';
        c.Email='ponse01@ca.com';
        c.AccountId = accts[0].Id;
        insert c;
        List<Opportunity> opps = new List<Opportunity>();
            List<Contact> Contacts = new list<Contact>();
        for (Integer j=0;j<4;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<2;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id,Deal_Expiration_Date__c=Date.today() + 5,Deal_Registration_Status__c='Sa Approved',Source__c='Deal Registration',Reseller_Contact__c=c.id));
                  
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;

        
        
       // system.debug('===lstopp======'+lstopp);
        Test.startTest();

            DealRegistrationRequestReminder_Batch obj = new DealRegistrationRequestReminder_Batch();
        integer batchSize = 10;
            DataBase.executeBatch(obj,batchSize); 
            
        Test.stopTest();
    }

}