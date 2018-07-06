/**
Class Name: PLM_SchedulableTest
Date: 1/03/2011
Project/Requirement: CA PRM R2/PAD
Author: Accenture
Description: This class is test class for PLM_SchedulableToUpdateTechPartnerFields
*/

@isTest
private class PLM_SchedulableTest {

    @isTest
    private static void testPLMBatch() {
        List <Account> accns = new List<Account>();
        for(integer i = 0; i<2; i++){
            Account a = new Account(name='testAccount'+'i',
            Technology_Partner_Effective_Date__c= System.today(),
            RecordTypeId=SystemIdUtility.getTechPartnerRecordTypeId(),
            Ownerid = userinfo.getuserID());
            accns.add(a);
        }
        insert accns;
        Test.StartTest();
        /*
        PLM_SchedulableToUpdateTechPartnerFields.updateTechPartnerFields();
        List <Account> accns1 = new List<Account>();
        for(integer i = 0; i<2000; i++){
            Account a = new Account(name='testAccount'+'i',
            Technology_Partner_Effective_Date__c= System.today(),
            RecordTypeId=SystemIdUtility.getTechPartnerRecordTypeId(),
            Ownerid = userinfo.getuserID());
            accns1.add(a);
        }
        insert accns1;
        */
        PLM_BatchToUpdateTechPartnerFields  reassign = new PLM_BatchToUpdateTechPartnerFields ();
        reassign.query='SELECT ID, Name, Ownerid FROM Account WHERE ownerid=\'' + userinfo.getuserID() + '\' LIMIT=2';
        //system.debug(''+);
        ID batchprocessid = Database.executeBatch(reassign,1);        
        Test.StopTest();
     }


    
    static testMethod void testPLM_SchedulableClass(){
        Test.StartTest();
        String techAccRecTypeId;
        //getting account record types by using schema
        Map<String, Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String, Schema.RecordTypeInfo>();
        //retrive account object record types 
        mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoTech = mapRecTypeInfoAcc.get('Technology Partner');
        techAccRecTypeId  = recTypeInfoTech.getRecordTypeId();
        
        //Insert reseller account. Will also cover the class PLM_AccountPercentCompleteForPartner
        Account testTechAccount = new Account();
        testTechAccount.Name= 'Test Account';
        testTechAccount.Customer_Category__c='Technology';
        testTechAccount.RecordTypeId=techAccRecTypeId;
        testTechAccount.Technology_Partner_Effective_Date__c=System.today();
        insert testTechAccount;               
        
        PLM_SchedulableToUpdateTechPartnerFields p = new PLM_SchedulableToUpdateTechPartnerFields();
        String sch = '0 0 0-23 * * ?';
        system.schedule('PLM_BatchToUpdateAccountTechPartnerFields2', sch, p);
        Test.StopTest();
    }
}