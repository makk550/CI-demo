/**
Class Name: PLM_BatchTest
Date: 1/03/2011
Project/Requirement: CA PRM R2/PAD
Author: Accenture
Description: This class is test class for PLM_BatchToUpdateTechPartnerFields
*/

@isTest
private class PLM_BatchTest {

    public static testMethod void testPLMBatch() {
        Test.StartTest();
        /*List <Account> accns = new List<Account>();
        for(integer i = 0; i<200; i++){
            Account a = new Account(name='testAccount'+'i',
            Technology_Partner_Effective_Date__c= System.today(),
            RecordTypeId=SystemIdUtility.getTechPartnerRecordTypeId(),
            Ownerid = userinfo.getuserID());
            accns.add(a);
        }
        insert accns;
        */
        //Insert Technology Partner Account
        Account testTechAccount = new Account();
        testTechAccount.Name= 'Test Account';
        testTechAccount.Customer_Category__c='Technology';
        testTechAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Technology Partner').getRecordTypeId();
        testTechAccount.Technology_Partner_Effective_Date__c=System.today();
        insert testTechAccount;               
        

        PLM_BatchToUpdateTechPartnerFields  reassign = new PLM_BatchToUpdateTechPartnerFields ();
        reassign.query='SELECT ID, Name, Ownerid, Technology_Partner_Effective_Date__c FROM Account WHERE ownerid=\'' + userinfo.getuserID() + '\'  LIMIT 200';
        ID batchprocessid = Database.executeBatch(reassign,1);
        Test.StopTest();
     }
     
}