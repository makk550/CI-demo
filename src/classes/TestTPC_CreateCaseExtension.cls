@isTest(SEEALLDATA = TRUE)
public class TestTPC_CreateCaseExtension {
    
    public static testMethod void TPC_CreateCaseExtensionTest(){
        Id p = [select id from profile where name='TPC Community'].id;
        
        /*RecordTypes_Setting__c custSetting = new RecordTypes_Setting__c();
        custSetting.Name = 'SMB';
        custSetting.RecordType_Id__c = '01230000001L55j';
        insert custSetting;
        
        RecordTypes_Setting__c custSetting1 = new RecordTypes_Setting__c();
        custSetting1.Name = 'Account Team Covered Account';
        custSetting1.RecordType_Id__c = '01230000001L55e';
        insert custSetting1;
        
        RecordTypes_Setting__c custSetting2 = new RecordTypes_Setting__c();
        custSetting2.Name = 'Territory Covered Account';
        custSetting2.RecordType_Id__c = '01230000001L55o';
        insert custSetting2;
        
        RecordTypes_Setting__c custSetting3 = new RecordTypes_Setting__c();
        custSetting3.Name = 'Commercial Account';
        custSetting3.RecordType_Id__c = '01230000000GaFY';
        insert custSetting3;
        
        RecordTypes_Setting__c custSetting4 = new RecordTypes_Setting__c();
        custSetting4.Name = 'CA Enterprise Account';
        custSetting4.RecordType_Id__c = '01230000000DNfM';
        insert custSetting4;
        
        RecordTypes_Setting__c custSetting5 = new RecordTypes_Setting__c();
        custSetting5.Name = 'Reseller/Distributor Account';
        custSetting5.RecordType_Id__c = '01230000000GaFd';
        insert custSetting5;
        
        Account testAccount1 = new Account();
        testAccount1.Name = 'Generic Support Account'; 
        testAccount1.Enterprise_ID__c = '7777777777';
        testAccount1.BillingStreet='Street';
        testAccount1.BillingCountry='US';
        testAccount1.BillingCity='Islandia'; 
        insert testAccount1 ; */
        
        Account testAccount = new Account();
        testAccount.Name = 'TestAutoAssign'; 
        testAccount.Enterprise_ID__c = '7777777777';
        testAccount.BillingStreet='Street';
        testAccount.BillingCountry='US';
        testAccount.BillingCity='Islandia'; 
        insert testAccount ; 
        
        Site_Association__c testSiteAssociation = new Site_Association__c();
        testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
        testSiteAssociation.SAP_Site_ID__c = '280125';
        testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
        testSiteAssociation.Enterprise_ID__c = testAccount.Id;
        testSiteAssociation.SC_TOPS_ID__c = '1299636';
        testSiteAssociation.Country_picklist__c= 'US - UNITED STATES';
        testSiteAssociation.State__c='New York';
        testSiteAssociation.ProviSite__c = 1;
        insert testSiteAssociation ;
        
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        insert testContact ;
        Contacts_Site_Association__c csa = new Contacts_Site_Association__c();
        csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
        csa.SC_CSA_CONTACTS__c = testContact.Id; 
        insert csa; 
        
       
          
          id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
      
        Auto_Assign_Queues__c autoset = new Auto_Assign_Queues__c();
        autoset.name='Test';
        autoset.Queue_Id__c=queueGroupId;
      
        Insert autoset;
        
        Component_Release__c componentRelease = new Component_Release__c();
        componentRelease.Name = 'EARL';
        componentRelease.Component_Release__c = '6.1';
        componentRelease.Component_Code__c='Tape ';
        insert componentRelease;
        BusinessHours objBH=[SELECT Id, IsActive, Name FROM BusinessHours where IsActive=true limit 1];
        User_Skills__c objUS=new User_Skills__c();
        objUS.User__c=UserInfo.getUserId();
        objUS.Tops_Site_ID__c='1299636';
        objUS.Component_Code__c='CMDB;Tape';
        objUS.Location__c='US - UNITED STATES';
        objUS.Case_Severity__c='1;2;3;4';
        objUS.Severity_1_cases_assigned__c=1;
        objUS.Cases_Assigned__c=1;
        objUS.Cases_assigned_perday__c=1;
        objUS.Vacation_Start_Date__c=System.today()+7;
        objUS.Vacation_End_Date__c=System.today()+30;
        objUS.Business_Hours__c=objBH.Id;
        objUS.Maximum_Total_Cases__c=1000;
        objUS.Maximum_Severity1_Cases__c=1000;
        objUS.Maximum_Cases_Per_Day__c=1000;
        insert objUS;
      
        
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='Test';
        insert prodCtl;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='Test';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=prodCtl.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        Case testCase=new Case();
        testCase.Accountid=testAccount.Id;
        testCase.Site_Association__c=testSiteAssociation.Id;
        testCase.CA_Product_Controller__c=prodCtl.id;
        testCase.CA_Product_Component__c=prodcomp.id;
        testCase.ContactId=testContact.Id;
        
        testCase.Origin='Email';
        testCase.OwnerId=queueGroupId;
        testCase.Case_Type__c='Standard';
        testCase.Subject='test subject TPC';
        testCase.Description='asdf';
        testCase.Reason='Instructions Not Clear';
        testCase.Priority='P5';
        //testCase.Component_Release_Only_Selection__c='EARL';

        testCase.Status='Open';
        testCase.Severity__c='1';
        testCase.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        testCase.Internal_Priority__c='2';
        testCase.Production_Down_Status__c='Investigating';
        testCase.Alternate_email__c='vamsi.r@gmail.com';
        //testCase.BusinessHours='IN - INDIA';
        
        testCase.Component_Release_Only_Selection__c=  componentRelease.Id;
        Test.startTest();
        insert testCase;
        
        TPC_Team__c team = new TPC_Team__c();
        team.Name = 'WIPRO';
        team.location__c = 'US - UNITED STATES;NL - NETHERLANDS;WW - WORLDWIDE';
        team.Tops_Site_Id__c = '923752;933817;807367;329929;105246';
        insert team;
        
        
        TPCTeamProductCodeAssociation__c teamPro = new TPCTeamProductCodeAssociation__c();
        teamPro.TPC_Team__c = team.Id;
        teamPro.CA_Product_Component__c = prodcomp.Id;
        insert teamPro;
        
        Account ac = new Account();
        ac.Name = 'TestAutoAssign'; 
        ac.Enterprise_ID__c = '7777777777';
        ac.BillingStreet='Street';
        ac.BillingCountry='US';
        ac.BillingCity='Islandia'; 
        insert ac ; 
 
       
        Contact con = new Contact(AccountId = ac.Id);
        con.FirstName ='testAuto';
        con.LastName ='contact';
        con.TPC_Team__c = team.id;
        insert con;  
        
        user u = new user();
        u.contactId= con.id;
        u.Email = 'esachin@salesforce.com';
        u.LastName = 'test';
        u.username='testsachin@test.com';
        u.CommunityNickname ='portalTest1';
        u.Alias = 'alias';
        u.ProfileID = p;
        u.LocaleSidKey = 'en_US';
        u.firstName = 'sach';
        u.LanguageLocaleKey = 'en_US';  
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey='UTF-8';
        database.insert(u);
        
        /*system.runAs(u) {
            TPC_CreateCaseExtension ext = new TPC_CreateCaseExtension(new ApexPages.StandardController(testCase));
       	    ext.createCase();
            ext.getValuesFromController();
            System.debug(ext.selectedContactId);
            System.debug(ext.isEditing);
        } */
        Test.stopTest();
    }

}