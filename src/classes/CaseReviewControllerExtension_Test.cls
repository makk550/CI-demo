@isTest(seeAllData = true)
public class CaseReviewControllerExtension_Test {
    
    private static testMethod void testMethod1(){
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
        insert testSiteAssociation ;
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        testContact.Email = 'shata07@ca.com';
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
        testCase.Subject='test subject';
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
        Test.stopTest();
        
        Case_Review_Admin__c cra = new Case_Review_Admin__c();
        cra.Description__c = 'Test Desc';
        cra.Title__c = 'Test title';
        cra.Explanation_of_Scores__c ='test exp';
        cra.Sort_Order__c = 100;
        cra.Score_Options__c = 'yes-no';
        cra.Score_Options_New__c = '1-5';
        cra.Review_Type__c = 'Chat';
        insert cra;
        
        Case_Review__c testCaseReview = new Case_Review__c();
        testCaseReview.Case__c = testCase.id;
        testCaseReview.Engineer_Name__c = userinfo.getUserId();
        testCaseReview.Reviewer_Name__c = userinfo.getUserId();
        testCaseReview.Case_Number__c = testCase.CaseNumber;
        testCaseReview.Today_Date__c = system.today();
        testCaseReview.Chat_Transcript__c = testCase.CaseNumber;
        testCaseReview.Review_Today_Date__c= system.today();
        testCaseReview.Review_Type__c = 'Chat';
        insert testCaseReview;
        
        Case_Review_Type__c crt = new Case_Review_Type__c();
        crt.Case_Review__c = testCaseReview.id;
        crt.Comment__c = 'Test comment';
        crt.Description__c = cra.Description__c;
        crt.Explanation__c = cra.Explanation_of_Scores__c;
        crt.render_1__c = true;
        crt.render_2__c = true;
        crt.render_3__c = true;
        crt.render_4__c = true;
        crt.Score_Picklist_1__c = 'Yes';
        crt.Score_Picklist_2__c = 'No';
        crt.Score_Picklist_3__c = '1';
        crt.Score_Picklist_4__c = '5';
        crt.Score_Options__c = cra.Score_Options_New__c;
        insert crt;
        
        crt.render_2__c = false;
        update crt;
        
        List<Case_Review_Record_Type__c> listOfRecordTypeObj = new List<Case_Review_Record_Type__c>();
        Case_Review_Record_Type__c recordTypeObj = new Case_Review_Record_Type__c();
        recordTypeObj.Name = 'Chat1';
        listOfRecordTypeObj.add(recordTypeObj);
        
        Case_Review_Record_Type__c recordTypeObj1 = new Case_Review_Record_Type__c();
        recordTypeObj1.Name = 'Assisted1';
        listOfRecordTypeObj.add(recordTypeObj1);
        insert listOfRecordTypeObj;
        
        apexpages.currentpage().getparameters().put('Id', testCaseReview.Id);
        apexpages.currentpage().getparameters().put('caseId', '');
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCaseReview);
        CaseReviewControllerExtension controller = new CaseReviewControllerExtension(stdController);
        controller.caseReviewLogic();
        //controller.save();
        //controller.cancel();
        
    }
    
    private static testMethod void testMethod2(){
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
        insert testSiteAssociation ;
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        testContact.Email = 'shata07@ca.com';
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
        testCase.Subject='test subject';
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
        Test.stopTest();
        
        Case_Review_Admin__c cra1 = new Case_Review_Admin__c();
        cra1.Description__c = 'Test Desc';
        cra1.Title__c = 'Test title';
        cra1.Explanation_of_Scores__c ='test exp';
        cra1.Sort_Order__c = 100;
        cra1.Score_Options__c = 'yes-no';
        cra1.Score_Options_New__c = '1-5';
        cra1.Review_Type__c = 'Assisted';
        insert cra1;
        
        Case_Review__c testCaseReview1 = new Case_Review__c();
        testCaseReview1.Case__c = testCase.id;
        testCaseReview1.Engineer_Name__c = userinfo.getUserId();
        testCaseReview1.Reviewer_Name__c = userinfo.getUserId();
        testCaseReview1.Case_Number__c = testCase.CaseNumber;
        testCaseReview1.Today_Date__c = system.today();
        testCaseReview1.Chat_Transcript__c = testCase.CaseNumber;
        testCaseReview1.Review_Today_Date__c= system.today();
        testCaseReview1.Review_Type__c = 'Assisted';
        insert testCaseReview1;
       
        Case_Review_Type__c crt1 = new Case_Review_Type__c();
        crt1.Case_Review__c = testCaseReview1.id;
        crt1.Comment__c = 'Test comment';
        crt1.Description__c = cra1.Description__c;
        crt1.Explanation__c = cra1.Explanation_of_Scores__c;
        crt1.render_1__c = true;
        crt1.render_2__c = true;
        crt1.render_3__c = true;
        crt1.render_4__c = true;
        crt1.Score_Picklist_1__c = 'Yes';
        crt1.Score_Picklist_2__c = 'No';
        crt1.Score_Picklist_3__c = '1';
        crt1.Score_Picklist_4__c = '5';
        crt1.Score_Options__c = cra1.Score_Options_New__c;
        insert crt1;
        
        crt1.render_2__c = false;
        update crt1;
        
        List<Case_Review_Record_Type__c> listOfRecordTypeObj = new List<Case_Review_Record_Type__c>();
        Case_Review_Record_Type__c recordTypeObj = new Case_Review_Record_Type__c();
        recordTypeObj.Name = 'Chat2';
        listOfRecordTypeObj.add(recordTypeObj);
        
        Case_Review_Record_Type__c recordTypeObj1 = new Case_Review_Record_Type__c();
        recordTypeObj1.Name = 'Assisted2';
        listOfRecordTypeObj.add(recordTypeObj1);
        insert listOfRecordTypeObj;
        
        apexpages.currentpage().getparameters().put('Id', testCaseReview1.Id);
        apexpages.currentpage().getparameters().put('caseId', '');
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(testCaseReview1);
        CaseReviewControllerExtension controller1 = new CaseReviewControllerExtension(stdController1);
        //controller.save();
        //controller.cancel();
        
    }
    
    private static testMethod void testMethod3(){
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
        insert testSiteAssociation ;
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        testContact.Email = 'shata07@ca.com';
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
        testCase.Subject='test subject';
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
        Test.stopTest();
        
        Case_Review_Admin__c cra1 = new Case_Review_Admin__c();
        cra1.Description__c = 'Test Desc';
        cra1.Title__c = 'Test title';
        cra1.Explanation_of_Scores__c ='test exp';
        cra1.Sort_Order__c = 100;
        cra1.Score_Options__c = 'yes-no';
        cra1.Score_Options_New__c = '1-5';
        cra1.Review_Type__c = 'Assisted';
        insert cra1;
        
        Case_Review__c testCaseReview1 = new Case_Review__c();
        testCaseReview1.Case__c = testCase.id;
        testCaseReview1.Engineer_Name__c = userinfo.getUserId();
        testCaseReview1.Reviewer_Name__c = userinfo.getUserId();
        testCaseReview1.Case_Number__c = testCase.CaseNumber;
        testCaseReview1.Today_Date__c = system.today();
        testCaseReview1.Chat_Transcript__c = testCase.CaseNumber;
        testCaseReview1.Review_Today_Date__c= system.today();
        testCaseReview1.Review_Type__c = 'Assisted';
        insert testCaseReview1;
       
        Case_Review_Type__c crt1 = new Case_Review_Type__c();
        crt1.Case_Review__c = testCaseReview1.id;
        crt1.Comment__c = 'Test comment';
        crt1.Description__c = cra1.Description__c;
        crt1.Explanation__c = cra1.Explanation_of_Scores__c;
        crt1.render_1__c = true;
        crt1.render_2__c = true;
        crt1.render_3__c = true;
        crt1.render_4__c = true;
        crt1.Score_Picklist_1__c = 'Yes';
        crt1.Score_Picklist_2__c = 'No';
        crt1.Score_Picklist_3__c = '1';
        crt1.Score_Picklist_4__c = '5';
        crt1.Score_Options__c = cra1.Score_Options_New__c;
        insert crt1;
        
        crt1.render_2__c = false;
        update crt1;
        
        List<Case_Review_Record_Type__c> listOfRecordTypeObj = new List<Case_Review_Record_Type__c>();
        Case_Review_Record_Type__c recordTypeObj = new Case_Review_Record_Type__c();
        recordTypeObj.Name = 'Chat2';
        listOfRecordTypeObj.add(recordTypeObj);
        
        Case_Review_Record_Type__c recordTypeObj1 = new Case_Review_Record_Type__c();
        recordTypeObj1.Name = 'Assisted2';
        listOfRecordTypeObj.add(recordTypeObj1);
        insert listOfRecordTypeObj;
        
        apexpages.currentpage().getparameters().put('Id', '');
        apexpages.currentpage().getparameters().put('caseId', testCase.Id);
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(testCaseReview1);
        CaseReviewControllerExtension controller1 = new CaseReviewControllerExtension(stdController1);
        controller1.recordTypeValue = 'Assisted';
        controller1.caseReviewLogic();
        controller1.save();
        controller1.cancel();
        
    }
    
    private static testMethod void testMethod4(){
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
        insert testSiteAssociation ;
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        testContact.Email = 'shata07@ca.com';
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
        testCase.Subject='test subject';
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
        Test.stopTest();
        
        Case_Review_Admin__c cra = new Case_Review_Admin__c();
        cra.Description__c = 'Test Desc';
        cra.Title__c = 'Test title';
        cra.Explanation_of_Scores__c ='test exp';
        cra.Sort_Order__c = 100;
        cra.Score_Options__c = 'yes-no';
        cra.Score_Options_New__c = '1-5';
        cra.Review_Type__c = 'Chat';
        insert cra;
        
        Case_Review__c testCaseReview = new Case_Review__c();
        testCaseReview.Case__c = testCase.id;
        testCaseReview.Engineer_Name__c = userinfo.getUserId();
        testCaseReview.Reviewer_Name__c = userinfo.getUserId();
        testCaseReview.Case_Number__c = testCase.CaseNumber;
        testCaseReview.Today_Date__c = system.today();
        testCaseReview.Chat_Transcript__c = testCase.CaseNumber;
        testCaseReview.Review_Today_Date__c= system.today();
        testCaseReview.Review_Type__c = 'Chat';
        insert testCaseReview;
        
        Case_Review_Type__c crt = new Case_Review_Type__c();
        crt.Case_Review__c = testCaseReview.id;
        crt.Comment__c = 'Test comment';
        crt.Description__c = cra.Description__c;
        crt.Explanation__c = cra.Explanation_of_Scores__c;
        crt.render_1__c = true;
        crt.render_2__c = true;
        crt.render_3__c = true;
        crt.render_4__c = true;
        crt.Score_Picklist_1__c = 'Yes';
        crt.Score_Picklist_2__c = 'No';
        crt.Score_Picklist_3__c = '1';
        crt.Score_Picklist_4__c = '5';
        crt.Score_Options__c = cra.Score_Options_New__c;
        insert crt;
        
        crt.render_2__c = false;
        update crt;
        
        List<Case_Review_Record_Type__c> listOfRecordTypeObj = new List<Case_Review_Record_Type__c>();
        Case_Review_Record_Type__c recordTypeObj = new Case_Review_Record_Type__c();
        recordTypeObj.Name = 'Chat1';
        listOfRecordTypeObj.add(recordTypeObj);
        
        Case_Review_Record_Type__c recordTypeObj1 = new Case_Review_Record_Type__c();
        recordTypeObj1.Name = 'Assisted1';
        listOfRecordTypeObj.add(recordTypeObj1);
        insert listOfRecordTypeObj;
        
        apexpages.currentpage().getparameters().put('Id', '');
        apexpages.currentpage().getparameters().put('caseId', testCase.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCaseReview);
        CaseReviewControllerExtension controller1 = new CaseReviewControllerExtension();
        CaseReviewControllerExtension controller = new CaseReviewControllerExtension(stdController);
        controller.recordTypeValue = 'Chat';
        controller.getRecordValues();
        controller.caseReviewLogic();        
    }
}