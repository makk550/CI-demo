/*
 * Test class created by BAJPI01.
 * Creates account, opportunity without
 * the use of seealldata = true.
 * It skips account triggers.
 * 
 * This is to test Opportunity Triggers
 * 
 * NOTE - THIS CLASS IS USED IN A LOT OF OTHER TEST CLASSES. DO NOT COMMENT OUT ANY OPERATIONS WITHOUT
 * LOOKING AT THE DEPENDENCY.
 * 
 */ 

@isTest
public class testOpportunityTriggersClass {
    
       
    public static testMethod void createTestData(){
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
        system.debug('----'+oppRecType);
        Id recopp = oppRecType.get('SB Record Type').getRecordTypeId(); 
   
        Opportunity opp = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = Label.Opp_Stage_10_Percent,
                                          CloseDate = Date.today()+90,
                                          Start_Date__c = Date.today(),
                                          Type = 'Direct',
                                          Contract_Type__c = 'SAAS',
                                          Inside_Outside__c = 'Inside',
                                          CurrencyISOCode = 'USD',
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity not inserted');
    
    }
    
    public static testMethod void createNewOpportunity(){
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
        system.debug('----'+oppRecType);
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
   
        Opportunity opp = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = Label.Opp_Stage_10_Percent,
                                          CloseDate = Date.today()+90,
                                          Start_Date__c = Date.today(),
                                          Type = 'Direct',
                                          Contract_Type__c = 'SAAS',
                                          Inside_Outside__c = 'Inside',
                                          CurrencyISOCode = 'USD',
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity not inserted');
        
    }
    
	 public static testMethod void createSBOppWithNoTrigger(){
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        SystemIdUtility.skipOpportunityTriggers =true;
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
        system.debug('----'+oppRecType);
        Id recopp = oppRecType.get('SB Record Type').getRecordTypeId(); 
   
        Opportunity opp = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = Label.Opp_Stage_10_Percent,
                                          CloseDate = Date.today()+90,
                                          Start_Date__c = Date.today(),
                                          Type = 'Direct',
                                          Contract_Type__c = 'SAAS',
                                          Inside_Outside__c = 'Inside',
                                          CurrencyISOCode = 'USD',
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity not inserted');
    
    }
    
    public static testMethod void createNewOppWithNoTriggers(){
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityTriggers =true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
        system.debug('----'+oppRecType);
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
   
        Opportunity opp = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = Label.Opp_Stage_10_Percent,
                                          CloseDate = Date.today()+90,
                                          Start_Date__c = Date.today(),
                                          Type = 'Direct',
                                          Contract_Type__c = 'SAAS',
                                          Inside_Outside__c = 'Inside',
                                          CurrencyISOCode = 'USD',
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity not inserted');
        
    }
    
    
}