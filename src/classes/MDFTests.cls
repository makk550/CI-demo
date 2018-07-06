public class MDFTests {
    
    /**
    *   Code coverate tests for triggers.
    *
    */

    public static boolean IsTest = false;
    public static User partnerUser= new User(); 
    public static List<Account> testPartnerAccount = new List<Account>();
    public static Fund_Programs_Admin__c testFundAdmin = new Fund_Programs_Admin__c(); 
    public static SFDC_Budget__c testBudget= new SFDC_Budget__c();
    public static Contact testContact= new Contact();
    public static Fund_Participant__c testFR= new Fund_Participant__c(); 
    public static SFDC_Budget_Entry__c testEntry = new SFDC_Budget_Entry__c();
    public static SFDC_MDF__c mdf = new SFDC_MDF__c();
    public static SFDC_MDF_Claim__c mdfc = new SFDC_MDF_Claim__c();

    public static testMethod void unitBudget(){
        
        String partnerAccRecTypeId;
        String fundRequestRecTypeId;        
        
        MDFTests.IsTest = true;
        
        
        Map<String,Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String,Schema.RecordTypeInfo>();
        //retrive account object record types
        mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoPartner = mapRecTypeInfoAcc.get('Reseller/Distributor Account');
        Schema.RecordTypeInfo recTypeInfoCommercial = mapRecTypeInfoAcc.get('Commercial Account');
        partnerAccRecTypeId = recTypeInfoPartner.getRecordTypeId();
        
        //Insert reseller account---1.
        Account testAccount1 = new Account();
        Account testAccount2 = new Account();
        testAccount1.Name= 'Test Account-1';
        testAccount1.Customer_Category__c='Reseller';
        testAccount1.RecordTypeId=partnerAccRecTypeId;
        testAccount1.Eligible_for_MDF__c = true;
       testAccount2.Name= 'Test Account-2';
        testAccount2.Account_Type__c='Reseller';
        testAccount2.RecordTypeId=partnerAccRecTypeId;
        testAccount2.Eligible_for_MDF__c = true;  
        testPartnerAccount.add(testAccount1);
//      testPartnerAccount.add(testAccount2);       
        insert testPartnerAccount;        
    
        //insert fund admin
        testFundAdmin.Name='Test Admin';
        testFundAdmin.Fund_Claim_Level_1_Approver__c=UserInfo.getUserId();
        testFundAdmin.Fund_Claim_Level_2_Approver__c=UserInfo.getUserId();
        testFundAdmin.Fund_Claim_Level_3_Approver__c=UserInfo.getUserId();
        testFundAdmin.Fund_Request_Level_1_Approver__c=UserInfo.getUserId();
        testFundAdmin.Fund_Request_Level_2_Approver__c=UserInfo.getUserId();
        testFundAdmin.Fund_Request_Level_3_Approver__c=UserInfo.getUserId();
        testFundAdmin.Finance_Processor_Email__c='test@email.com';
        testFundAdmin.CA_Share__c=34;
        testFundAdmin.Approval_Funds_Expiry_Days__c=59;
        testFundAdmin.Active__c=true;
        insert testFundAdmin;

        
        //insert partner fund.
        testBudget.Fund_Program__c = testFundAdmin.Id;
        testBudget.Active__c = true;
        testBudget.Account__c = testPartnerAccount[0].Id;
        testBudget.CurrencyIsoCode = 'USD';
        insert testBudget;

      /*  //insert partner contact.
        testContact.FirstName='frst name';
        testContact.LastName='test name';
        testContact.Email='testemail@testemail.com';
        testContact.AccountId=testPartnerAccount[0].Id;
        insert testContact;
        
     
        
        //insert partner user
        User u2 = new User(alias = 'PRMTest', email='PRMTest@ca.com', 
        emailencodingkey='UTF-8', lastname='Testing',firstname='Testing', languagelocalekey='en_US', 
        localesidkey='en_IN', profileid = UserInfo.getProfileId(), 
        timezonesidkey='Asia/Kolkata', username='PRMTest@ca.com');
        System.runAs(u2) {
            
                //insert partner user
                partnerUser.FirstName='Test name';
                partnerUser.LastName='Test name';
                partnerUser.Alias='tetest';
                partnerUser.Email='testemail@testemail.com';
                partnerUser.Username='testemailxyz123@testemail.com';
                partnerUser.CommunityNickname='test1234';
                //partnerUser.ProfileId=Label.GEM_Partner_Deal_Reg_profile_ID;
                partnerUser.ProfileId=[Select Id from Profile where Name = 'Partner Champion' limit 1].Id;
                partnerUser.ContactId=testContact.Id;
                partnerUser.TimeZoneSidKey='Asia/Kolkata';
                partnerUser.LocaleSidKey='en_IN';
                partnerUser.EmailEncodingKey='UTF-8';
                partnerUser.LanguageLocaleKey='en_US'; 
                partnerUser.DefaultCurrencyIsoCode='USD';     
                insert partnerUser;         
            
        }
          
        //insert fund participant.
        testFR.TCAccepted__c = true;
        testFR.Partner__c = '00530000006cvqD';
        testFR.MDF_Program__c = testFundAdmin.Id;
        insert testFR;
        System.debug('--------------Budget'+testBudget);
         */ 
        
        //insert fund program entry
        testEntry.Name__c = 'test entry';
        testEntry.Fund_Program__c = testFundAdmin.Id;
        System.debug('--------------Budget'+testBudget);
        testEntry.Budget__c = testBudget.Id;
        testEntry.Amount__c = 10000;
        insert testEntry;
     
        //insert fund request.
        
       mdf.Name= 'test request';
 //     mdf.RecordTypeId = fundRequestRecTypeId;
        mdf.MDF_Program__c = testFR.Id; 
        mdf.Budget__c = testBudget.Id;
        mdf.Amount__c = 100;
        mdf.Account__c = testPartnerAccount[0].Id;
        mdf.OwnerId = '00530000006cvqD';
        mdf.Activity_Start_Date__c= System.today() + 20;
          Test.startTest();
        insert mdf;
        SFDC_MDF_Claim__c sf = new SFDC_MDF_Claim__c();
         sf.Fund_Request__c = mdf.id;
        sf.name = 'test';
        insert sf;
        mdf.Status__c='Approved';
        update mdf;
        
       Fund_Programs_Admin__c  fa = new Fund_Programs_Admin__c ();
        fa.name='test';
        fa.Approval_Funds_Expiry_Days__c = 12;
        fa.CA_Share__c=3;
        insert fa;
        system.debug(fa.id);

        Test.stopTest();
     
        
    
    }
    private static testmethod void test1()
    {
        	
    }

}