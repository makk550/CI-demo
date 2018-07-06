/*
* For Class = OpportunityCreateOverrideExtension
* Coverage = 82%.
* Updated by BAJPI01
*/

@isTest
public class OpportunityCreateOverrideExtensionTest {
    
    public static testmethod void createoppErrors(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_Closed_Won;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.Influencer.isPrimary = true;
        result = oppctrl.onSave();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        opp.Type = '1 Tier';
        oppctrl.onTypeChange();
        result = oppctrl.onSave();
        pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        opp.Type = '2 Tier';
        oppctrl.onTypeChange();
        result = oppctrl.onSave();
        pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        opp.Type = 'xSP';
        oppctrl.onTypeChange();
        result = oppctrl.onSave();
        pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        opp.Type = 'Direct';
        opp.StageName = Label.Opp_Stage_10_Percent;
        oppctrl.onStageNameChange();
        
    } 
    
    public static testmethod void createopp(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = true;
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave();
        oppctrl.onCancel();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        
        system.debug('---pg messages-----'+pageMessages);
        
        opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
                Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
               Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
       
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        
        
        
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.onCurrencyChange();
        oppctrl.onTypeChange();
        oppctrl.onServiceChange();
         //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = true;

        oppctrl.onSave();
        oppctrl.onCancel();
         OpportunityCreateOverrideExtensionTest.insertPBERecord();
        PricebookEntry pbe =[select id from PricebookEntry limit 1];
         OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                              raw_maintenance__c=1.00,Start_Date__c = system.today(),End_Date__c = system.today()+80 );
        insert oli;
        
         opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
               Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity where id=:opp.id limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.onCurrencyChange();
        oppctrl.onStageNameChange();
        oppctrl.onTypeChange();
        oppctrl.onServiceChange();
         //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        oppctrl.onSave();
   
    } 
    
     public static testmethod void createopp2(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
         opp.Salesforce_CPQ_Eligibility_Route__c = true;
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        
         opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
               Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.onCurrencyChange();
        oppctrl.onTypeChange();
        oppctrl.onServiceChange();
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        oppctrl.onSave();
         
         opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
                Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
         
         
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
         //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        oppctrl.onSave();
         
           opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
                 Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
          //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        oppctrl.onSave();

          opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
                Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
         
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
           //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = true;
        oppctrl.onSave();
        oppctrl.onCurrencyChange();
        oppctrl.onTypeChange();
        oppctrl.onServiceChange();
         
         
          Opportunity opp2 = new Opportunity();
        opp2.Name = 'test opp';
        opp2.AccountId = acc.Id ; 
        opp2.CloseDate = system.today()+15;
        opp2.stageName = Label.Opp_Stage_10_Percent;
        opp2.Type = 'Direct';
        opp2.Inside_Outside__c = 'Inside';
        opp2.Contract_Type__c = 'ELA';
        opp2.CurrencyIsoCode = 'USD';
          //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        
        stdCtrl = new ApexPages.StandardController(opp2);
        tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave();
         
        
    }

    public static testmethod void createPreOppRecord() {
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();

        opportunity opp = new opportunity();
        opp.Name = 'test Opp';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre Opportunity').getRecordTypeId();

        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.onRecordTypeChange();
    }
  
    public static testmethod void createAddOppProdMethod(){
        
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        opp.Start_Date__c = system.today();
        opp.End_Date__c = system.today()+50;
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave_AddProducts();
    }
    
    public static testmethod void createAddMainframeMethod(){
        
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        opp.Start_Date__c = system.today();
        opp.End_Date__c = system.today()+50;
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave_AddMainframeCapacity();
    }
   
	public static testmethod void createAddOfferingsMethod(){
        
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        
        opp.Start_Date__c = system.today();
        opp.End_Date__c = system.today()+50;
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave_AddOfferings();
    }
    
    public static testmethod void createAttachContractMethod(){
        
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        opp.Start_Date__c = system.today();
        opp.End_Date__c = system.today()+50;
        
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave_AttachContractProduct();
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'test opp';
        opp2.AccountId = acc.Id ; 
        opp2.CloseDate = system.today()+1;
        opp2.stageName = Label.Opp_Stage_10_Percent;
        opp2.Type = 'Direct';
        opp2.Inside_Outside__c = 'Inside';
        opp2.Contract_Type__c = 'ELA';
        opp2.CurrencyIsoCode = 'USD';
        
        stdCtrl = new ApexPages.StandardController(opp2);
        tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        ApexPages.currentPage().getParameters().put('contrnum','12');
        ApexPages.currentPage().getParameters().put('contrval', '11');
        ApexPages.currentPage().getParameters().put('projno', '123');
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        oppctrl.onSave();
    }
 
    public static testmethod void createOppWithProduct(){

        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        testCreateAccount.createTestAccountData();
        Account acc = [select id from account limit 1];
        
        
        contact con=new contact(lastname='con1',accountid=acc.id,Active_User__c=true);
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = acc.Id ; 
        opp.CloseDate = system.today()+1;
        opp.stageName = Label.Opp_Stage_10_Percent;
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = true;
        
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opp);
        PageReference tpageRef = Page.OpportunityCreateOverride;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('conId', con.Id);
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        PageReference result;
        String oppid;
        OpportunityCreateOverrideExtension oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        result = oppctrl.onSave();
        oppctrl.onCancel();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        
        system.debug('---pg messages-----'+pageMessages);
        
        opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
               Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
        
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        
        
        
       
         OpportunityCreateOverrideExtensionTest.insertPBERecord();
        PricebookEntry pbe =[select id from PricebookEntry limit 1];
         OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                              raw_maintenance__c=1.00,Start_Date__c = system.today(),End_Date__c = system.today()+80 );
        insert oli;
        
        opp = [select id,recordtypeid,Opportunity_Type__c,SBQQ__PrimaryQuote__c,Salesforce_CPQ_Eligibility_Route__c,CreatedDate,
               Name,CloseDate,StageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
               Start_Date__c,End_Date__c,Will_CA_Services_Be_Used__c,No_CA_Service_Reason__c,Services_Transaction_Type__c,
               Sales_Business_Unit__c,Competitor__c,Other_Competitor__c,Order_Number__c,ReasonField__c,Other_Win_Loss_Reason__c,
               Related_Opportunity__c,Cloud_Platform__c,Service_Provider_Client__c,Reseller__c,Distributor_6__c,List_of_Activities__c,
               Identified_Pain__c,Metrics__c,Decision_Criteria__c,Decision_Process__c,Paper_Process__c,Next_Steps__c
               from opportunity limit 1];
       
        system.assertNotEquals(null, opp.id, 'Opportunity Not Inserted');
        opp.StageName = Label.Opp_Stage_20_Percent;
        opp.Type = '1 Tier';
        stdCtrl = new ApexPages.StandardController(opp);
        tpageRef = Page.ChangeStage;
        Test.setCurrentPage(tpageRef);
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        oppctrl = new OpportunityCreateOverrideExtension(stdCtrl);
        boolean productExists = oppctrl.productexists;
        boolean isService = oppctrl.isServiceProviderRequired;
        boolean isContractSigned = oppctrl.isContractsigned;
        boolean isOrderNumber = oppctrl.isOrderNumberRequired;
        
        
   
    }
    
    public static testmethod void customcontactlooptest(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        
        testCreateAccount.createTestAccountData();
        Account acc2 = [select id from account limit 1];
        
        user u1=new user(id='00530000003rQuJ');
        system.runas(u1){
            test.starttest();
            
            contact con2=new contact(lastname='con1',accountid=acc2.id,Active_User__c=true);
            insert con2;
            
            ApexPages.StandardController stdCtrl10;
            OppNewButtonController oppctrl10 = new OppNewButtonController(stdCtrl10);
            oppctrl10.ProfileSelection();            
            
            ApexPages.StandardController stdCtrl11;
            PageReference contactlookup = Page.CustomContactLookup;
            Test.setCurrentPage(contactlookup);
            ApexPages.currentPage().getParameters().put('lksrch', 'con');
            ApexPages.currentPage().getParameters().put('accid', '');
            CustomContactLookupController contactcntrl  = new CustomContactLookupController();
            
            PageReference contactlookup2 = Page.CustomContactLookup;
            Test.setCurrentPage(contactlookup2);
            ApexPages.currentPage().getParameters().put('lksrch', 'con*');
            ApexPages.currentPage().getParameters().put('accid', acc2.id);
            ApexPages.currentPage().getParameters().put('frm', 'test');
            ApexPages.currentPage().getParameters().put('txt', 'test');
            CustomContactLookupController contactcntrl2  = new CustomContactLookupController();
            contactcntrl2.searchString = 'con';
            contactcntrl2.getKey();
            contactcntrl2.getItems();
            contactcntrl2.setKey('test');
            contactcntrl2.getFormTag();
            contactcntrl2.getTextBox();
            test.stopTest();
        }
    }
    
    public static testMethod void insertPBERecord(){
         SystemIdUtility.skipProductTriggers = true;
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
    }
    
}