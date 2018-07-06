@isTest
public class TestCaseHandler{ 
    
    private static Site_Association__c testSite ; 
    private static Site_Association__c excludedSite;
    private static CA_Product_Controller__c testCAProduct ; 
    private static CA_Product_Controller__c testCAProduct2;
    private static CA_Product_Controller__c testCAProduct3;
    private static CA_Product_Component__c testCAComponent2;
    private static CA_Product_Component__c testCAComponent1;
    private static Contact testContact ; 
    @TestVisible private static User supportUser ; 
    private static Offering_Business_Rules__c offeringBusinessRulesObj;
    private static Offering_Business_Rules__c offeringBusinessRulesObj2;
    private static Product_Material__c productMaterial;
    private static Product_Material__c productMaterial2;
    private static Product_Material__c productMaterial3;
    private static Product_Release__c productRelease;
    private static Product_Release__c productRelease2;
    private static Account testAccount;
    private static Product_Release__c productRelease3;
    private static Profile adminProfile;
    private static User testUser;
    
     
 
  
  
    public static User createDataUser(){
       /* adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO' limit 1];
        testUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
        return testUser ; */
        testUser = new User(id = UserInfo.getUserId());
        return testUser;
    }
    
    public static  void createTestData () {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
    SystemIdUtility.skipAccountOnMIPSUpdate = true;     
    
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
       
        testAccount = new Account() ; 
        testAccount.Name = 'HONG KONG GOVERNMENT'; 
        testAccount.Enterprise_ID__c = 'AR51855';
        testAccount.BillingStreet = 'Admiralty Ctr';
        testAccount.BillingCountry = 'HK';
        testAccount.BillingCity = 'ADMIRALTY';
        insert testAccount ; 
        
        testContact = new Contact();
        testContact.LastName = 'Darcy' ;
        testContact.FirstName = 'Brian' ; 
        testContact.Email = 'Brian@test.com';
        testContact.Language_Preference__c = 'English';
        insert testContact ; 
        
        Provisional_Site_Number__c provSiteNum = new Provisional_Site_Number__c();
        provSiteNum.Name = 'Last Site No';
        provSiteNum.Prov_Site_Number__c=9999909;
        insert provSiteNum;
        
        testSite = new Site_Association__c();
        testSite.Name = 'FINANCIAL SERVICES & THE TREASURY BUREA';
        testSite.Enterprise_ID__c =  testAccount.Id; 
        testSite.SC_SITE_Sanctioned_Party__c = 'No';
        testSite.SC_TOPS_ID__c = '788689111';
        testSite.SC_SITE_Source__c = 'Support' ; 
        testSite.Country_picklist__c = 'IN - INDIA'; //US - UNITED STATES';
        testSite.SC_SITE_CSM__c = testUser.Id;
        testSite.SC_CA_Internal_Site__c = false;
        testSite.SAP_Site_ID__c = '11';
        insert testSite ;  
        system.debug('test site:'+testSite);
        testCAProduct = new CA_Product_Controller__c();
        //testCAProduct.Name = 'APPLICATION PERFORMANCE MANAGEMENT' ;
        testCAProduct.Name = 'testtest' ;
        testCAProduct.Troubleshooting_Stage_Threshold_Calc__c = true;
        insert testCAProduct ; 
        
        CA_Product_Component__c testCAComponent = new CA_Product_Component__c();
        testCAComponent.Name = 'APPLICATION PERFORMANCE MANAGEMENT CEMINT';
        testCAComponent.CA_Product_Controller__c = testCAProduct.Id ; 
        testCAComponent.Default_Component_for_this_CA_Product__c = true;
        insert testCAComponent;
        
        productMaterial = new Product_Material__C();
        productMaterial.Name = 'DAL2TO00200';
        productMaterial.CA_Product_Controller__c = testCAProduct.Id;
        productMaterial.Source_System__c = 'TOPS';
        insert productMaterial;
        
        productRelease =  new Product_Release__C();
        productRelease.Name = 'DAL2TO00200-1-CA-DAL-SERVER FOR DB2';
        productRelease.Product_Material__c = productMaterial.Id; 
        insert productRelease;
        
        
        testCAProduct2 = new CA_Product_Controller__c();
        testCAProduct2.Name = 'Aditya' ;
        testCAProduct.Troubleshooting_Stage_Threshold_Calc__c = false;
        insert testCAProduct2 ; 
        
        testCAComponent1 = new CA_Product_Component__c();
        testCAComponent1.Name = 'APPLICATION PERFORMANCE MANAGEMENT CEMINT';
        testCAComponent1.CA_Product_Controller__c = testCAProduct2.Id ; 
        testCAComponent1.Default_Component_for_this_CA_Product__c = true;
        insert testCAComponent1;
        
        productMaterial2 = new Product_Material__C();
        productMaterial2.Name = 'DAL2TO00200';
        productMaterial2.CA_Product_Controller__c = testCAProduct2.Id;
        productMaterial2.Source_System__c = 'TOPS';
        insert productMaterial2;
        
        productRelease2 =  new Product_Release__C();
        productRelease2.Name = 'DAL2TO00200-1-CA-DAL-SERVER FOR DB2';
        productRelease2.Product_Material__c = productMaterial2.Id; 
        insert productRelease2;
        
        testCAProduct3 = new CA_Product_Controller__c();
        testCAProduct3.Name = 'AGILE CENTRAL ON PREMISE' ;
        testCAProduct3.Troubleshooting_Stage_Threshold_Calc__c = false;
        insert testCAProduct3; 
        
        testCAComponent2 = new CA_Product_Component__c();
        testCAComponent2.Name = 'AGILE CENTRAL ON PREMISE ACAPI';
        testCAComponent2.CA_Product_Controller__c = testCAProduct3.Id ; 
        testCAComponent2.Default_Component_for_this_CA_Product__c = true;
        testCAComponent2.Component_Code__c = 'ACAPI';
        insert testCAComponent2;
        
        productMaterial3 = new Product_Material__C();
        productMaterial3.Name = 'ACNADS99000';
        productMaterial3.CA_Product_Controller__c = testCAProduct3.Id;
        productMaterial3.Source_System__c = 'TOPS';
        insert productMaterial3;
        
        productRelease3 =  new Product_Release__C();
        productRelease3.Name = 'ACNADS99000-1-Agile Central-Advanced Security';
        productRelease3.Product_Material__c = productMaterial3.Id; 
        insert productRelease3;
        
        Emails_List__c email = new Emails_List__c();
        email.Name = 'greg.petras@nyfixtest.com' ;
        insert email ; 
        Sites_List__c site = new Sites_List__c();
        site.Name = '123456' ;
        insert site ; 
        Products_List__c product = new Products_List__c();
        product.Name = 'TSEECT';
        insert product;
        
        PilotProduct__c pilotProduct = new PilotProduct__c();
        pilotProduct.Name = 'Dummy';
        pilotProduct.Pilot_Product_Id__c = testCAProduct3.Id;
        insert pilotProduct;
        
        excludedSite = new Site_Association__c();
        excludedSite.Name = 'FINANCIAL SERVICES & THE TREASURY BUREA';
        excludedSite.Enterprise_ID__c =  testAccount.Id; 
        excludedSite.SC_SITE_Sanctioned_Party__c = 'No';
        excludedSite.SC_TOPS_ID__c = '123456111';
        excludedSite.SC_SITE_Source__c = 'Support' ; 
        excludedSite.Country_picklist__c ='US - UNITED STATES';
        excludedSite.State__c = 'california';
        excludedSite.ProviSite__c  = 9999999; 
        insert excludedSite ; 
        
        /*Certifications__c certificateObj = new Certifications__c();
        certificateObj.Active__c = true;
        certificateObj.CA_Product__c = testCAProduct.Id;
        certificateObj.Certification_End_Date__c = system.today().addDays(10);
        certificateObj.Certification_Start_Date__c = system.today();
        certificateObj.Certification_Level__c = 'Certified';
        certificateObj.Contact__c = testContact.Id;
        insert certificateObj;*/
        
        offeringBusinessRulesObj = new Offering_Business_Rules__c();
        offeringBusinessRulesObj.Name='test Code 123';
        offeringBusinessRulesObj.Offering_Code__c = 'Code 123'; 
        offeringBusinessRulesObj.Precedence__c='1';
        insert offeringBusinessRulesObj; 
        
        List<Offering_Feature__c> offeringFeatureList = new List<Offering_Feature__c>();
        
        Offering_Feature__c offeringObject = new Offering_Feature__c();
        offeringObject.Case_Severity__c = '3';
        offeringObject.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        offeringObject.SLO_Type__c = 'Standard';
        offeringObject.SLO_Value__c = '2';
        offeringObject.Type__c = 'Certified Bypass Routing';
        offeringObject.Unit__c = 'Minutes';
        offeringFeatureList.add(offeringObject);
        
        Offering_Feature__c offeringObject1 = new Offering_Feature__c();
        offeringObject1.Case_Severity__c = '3';
        offeringObject1.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        offeringObject1.SLO_Type__c = 'Standard';
        offeringObject1.SLO_Value__c = '2';
        offeringObject1.Type__c = 'Workaround';
        offeringObject1.Unit__c = 'Minutes';
        offeringFeatureList.add(offeringObject1);
        
        
        Offering_Feature__c offeringObject2 = new Offering_Feature__c();
        offeringObject2.Case_Severity__c = '3';
        offeringObject2.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        offeringObject2.SLO_Type__c = 'Standard';
        offeringObject2.SLO_Value__c = '2';
        offeringObject2.Type__c = 'Resolution';
        offeringObject2.Unit__c = 'Minutes';
        offeringFeatureList.add(offeringObject2);
        
        offeringBusinessRulesObj2 = new Offering_Business_Rules__c();   
        offeringBusinessRulesObj2.Name='Test Code 234';
        offeringBusinessRulesObj2.Offering_Code__c = 'Code 234'; 
        offeringBusinessRulesObj2.Precedence__c='2';        
        insert offeringBusinessRulesObj2; 
        
        Offering_Feature__c offeringObject3 = new Offering_Feature__c();
        offeringObject3.Case_Severity__c = '3';
        offeringObject3.Offering_Business_Rules__c = offeringBusinessRulesObj2.Id;
        offeringObject3.SLO_Type__c = 'Standard';
        offeringObject3.SLO_Value__c = '2';
        offeringObject3.Type__c = 'Initial Callback';
        offeringObject3.Unit__c = 'Minutes';
        offeringFeatureList.add(offeringObject3);
        insert offeringFeatureList;
        
        Contract_Support_Offerings__c CCRmockedRequest = new Contract_Support_Offerings__c();
        CCRmockedRequest.ca_product_name__c=testCAProduct.Name;
        CCRmockedRequest.clarity_key__c='ABCD';
        CCRmockedRequest.contract_line_num__c='10';
        CCRmockedRequest.dse_pmf_key__c='GOVAD01';
        CCRmockedRequest.dse_role__c='P';
        CCRmockedRequest.offering_cd__c=offeringBusinessRulesObj.Offering_Code__c;
        CCRmockedRequest.offering_end_dtm__c=System.now();
        CCRmockedRequest.offering_start_dtm__c=System.now();
        CCRmockedRequest.sap_contract_num__c=10+'';
        CCRmockedRequest.tops_site_id__c=testSite.SC_TOPS_ID__c;    
        insert CCRmockedRequest;
        
        Contract_Support_Offerings__c CCRmockedRequest2 = new Contract_Support_Offerings__c();
        CCRmockedRequest2.ca_product_name__c=testCAProduct2.Name;
        CCRmockedRequest2.clarity_key__c='ABCD1';
        CCRmockedRequest2.contract_line_num__c='10';
        CCRmockedRequest2.dse_pmf_key__c='GOVAD01';
        CCRmockedRequest2.dse_role__c='P';
        CCRmockedRequest2.offering_cd__c=offeringBusinessRulesObj.Offering_Code__c;
        CCRmockedRequest2.offering_end_dtm__c=System.now().addDays(20);
        CCRmockedRequest2.offering_start_dtm__c=System.now().addDays(-10);
        CCRmockedRequest2.sap_contract_num__c=10+'';
        CCRmockedRequest2.tops_site_id__c='00000'+testSite.SC_TOPS_ID__c;       
        insert CCRmockedRequest2;
        
        Contract_Support_Offerings__c CCRmockedRequest3 = new Contract_Support_Offerings__c();
        CCRmockedRequest3.ca_product_name__c=testCAProduct3.Name;
        CCRmockedRequest3.clarity_key__c='ABCD';
        CCRmockedRequest3.contract_line_num__c='10';
        CCRmockedRequest3.dse_pmf_key__c='GOVAD01';
        CCRmockedRequest3.dse_role__c='P';
        CCRmockedRequest3.offering_cd__c=offeringBusinessRulesObj.Offering_Code__c;
        CCRmockedRequest3.offering_end_dtm__c=System.now();
        CCRmockedRequest3.offering_start_dtm__c=System.now();
        CCRmockedRequest3.sap_contract_num__c=10+'';
        CCRmockedRequest3.tops_site_id__c=testSite.SC_TOPS_ID__c;    
        insert CCRmockedRequest3;
        
        Non_Contract_Offering_Business_Rules__c ncr=new Non_Contract_Offering_Business_Rules__c();
        ncr.CA_Product_Controller__c=testCAProduct.ID;
        ncr.End_Date__c=System.today().addDays(5);
        ncr.Start_Date__c=System.today();
        ncr.Site_Association__c=testSite.ID;
        ncr.Offering_Business_Rules__c=offeringBusinessRulesObj.ID;
        insert ncr;
        
        /*Emails_List__c emailListObj = new Emails_List__c();
        emailListObj.Name = testContact.Email;
        insert emailListObj;
        
        Products_List__c productList = new Products_List__c();
        productList.Name = 'dummmmy';//testCAComponent2.Component_Code__c;        
        insert productList;
        
        Sites_List__c siteList = new Sites_List__c();
        siteList.Name = testSite.SC_TOPS_ID__c;
        insert siteList;
        */
        
       /* Profile adminProfile1 = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR']; 
        supportUser = [select Id from User where IsActive = true AND  ProfileId = :adminProfile1.Id limit 1] ;   */
        supportUser = new User(Id= UserInfo.getUserId());
       // List<sObject> ls = Test.loadData(User.sObjectType, 'TestData_User');
       // supportUser = (User)ls[0];
    }  
        
    static testmethod void testAInsertCaseCAProductCaseGateway() {
        system.runAs(createDataUser()){
            createTestData();
        }
        system.runAs(supportUser){ 
            Test.StartTest(); 
            Case caseRec = new Case();
            caseRec.Site_Association__c = testSite.Id ;
            caseRec.subject = 'Test Subject' ; 
            caseRec.Description = 'Test Description' ; 
            caseRec.ContactId = testContact.Id ; 
            caseRec.CA_Product_Controller__c = testCAProduct3.Id;
            caseRec.Origin = 'Phone Call';       
            caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
            caseRec.Status = 'Open';
            caseRec.Severity__c = '3';   
            caseRec.Queue_Jumping__c = true;
            caseRec.Certified_Bypass_Routing_Qualified__c = true;
            UtilityFalgs.isQueueJumpingEnabled = true;
            insert caseRec;
            
            Case case1 =[select id,Troubleshooting_Stage__c, Status,Reason,Category__c,Subcategory__c, CA_Product_Controller__c, Resolution__c,Product_Material__c,Product_Release_Selection__c from case where id =: caseRec.id];
            case1.Troubleshooting_Stage__c = '7. Closed';
            case1.Status = 'Closed';
            case1.Do_Not_Survey__c = false;
            case1.Internal_CA__c = false;
            case1.Case_Type__c = 'Standard';
            case1.Reason = 'Answer - Available';
            case1.Category__c = 'Documentation';
            case1.Subcategory__c = 'Education';
            case1.Resolution__c = 'Test Case Closure';
            case1.Product_Material__c = productMaterial3.Id;
            case1.Language__c = 'ENG ENGLISH';
            case1.Alt_Contact_Preferred_Language__c = 'English';
            case1.Product_Release_Selection__c = productRelease3.Id; 
            case1.Reopen_Count__c = 0;  
            case1.Eligible_For_Survey__c = true;
            //case1.closeddate = system.today();
            update case1;
            
            system.debug(case1.closeddate+'$$$$$$CASSSSSSSSSSSSEEEEEEEEEEEEEEEEEEEEEEEE');
            Boolean returnVal = CaseGateway.checkSurveyEligibility(case1);
            Test.StopTest();
        }
    }
    
    static testmethod void testInsertCaseCAProductCaseGateway1() {
        system.runAs(createDataUser()){
            createTestData();
        }
        system.runAs(supportUser){ 
            Test.StartTest(); 
            Case caseRec = new Case();
            caseRec.Site_Association__c = testSite.Id ;
            caseRec.subject = 'Test Subject' ; 
            caseRec.Description = 'Test Description' ; 
            caseRec.ContactId = testContact.Id ; 
            caseRec.CA_Product_Controller__c = testCAProduct3.Id;
            caseRec.Origin = 'Phone Call';       
            caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
            caseRec.Status = 'Open';
            caseRec.Severity__c = '3';   
            insert caseRec;
            
            Case case1 =[select id,Troubleshooting_Stage__c, Status,Reason,Category__c, CA_Product_Controller__c,Subcategory__c,Resolution__c,Product_Material__c,Product_Release_Selection__c from case where id =: caseRec.id];
            case1.Troubleshooting_Stage__c = '7. Closed';
            case1.Status = 'Closed';
            case1.Do_Not_Survey__c = true;
            case1.Internal_CA__c = false;
            case1.Case_Type__c = 'Standard';
            case1.Reason = 'Answer - Available';
            case1.Category__c = 'Documentation';
            case1.Subcategory__c = 'Education';
            case1.Resolution__c = 'Test Case Closure';
            case1.Product_Material__c = productMaterial3.Id;
            case1.Language__c = 'ENG ENGLISH';
            case1.Alt_Contact_Preferred_Language__c = 'English';
            case1.Product_Release_Selection__c = productRelease3.Id; 
            case1.Reopen_Count__c = 0;  
            case1.Next_Action_Due_Date__c = system.now().addDays(5);
            case1.Next_Action_Due_Date__c = system.now().addDays(5);
            case1.Eligible_For_Survey__c = true;
            update case1;
            
            Boolean returnVal = CaseGateway.checkSurveyEligibility(case1);
            Test.StopTest();
        }
    }
    
    static testmethod void testInsertCase () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest(); 
            //SupportOfferingsFlowController sp=new SupportOfferingsFlowController();
            //sp.fetchExternalObjectData();
            
            Case case1 = TestCaseHandler.prepareCase('3');  
            insert case1;
            
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            
            case1.Troubleshooting_Stage__c = '2. Knowledge Search';
            case1.Product_Material__c = productMaterial.Id;
            case1.Language__c = 'ENG ENGLISH';
            case1.Alt_Contact_Preferred_Language__c = 'English';
            case1.Product_Release_Selection__c = productRelease.Id; 
            update case1;
            Test.StopTest();
            
        }   
    }
    
    static testmethod void testInsertProactiveCaseFromGainsight () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest(); 
            Case case1 = TestCaseHandler.prepareCase('3');  
            case1.Troubleshooting_Stage__c = '1. Triage';
            case1.Playbook__C = 'testPlaybook';
            case1.Origin = 'Gainsight';
            case1.Case_type__C = 'Proactive';
            case1.AccountId = testAccount.ID;
            insert case1; 
            Test.StopTest();            
        }   
    }
    
    static testmethod void testGainsightActivitiesCreation(){
        system.runAs(createDataUser()){
           createTestData();
        } 
        system.runAs(supportUser){
           Test.StartTest(); 
            Case case1 = TestCaseHandler.prepareCase('3'); 
            //case1.recordtype.Id='0121h0000004QvaAAE';
            case1.Troubleshooting_Stage__c = '1. Triage';
            case1.Playbook__C = 'testPlaybook';
            case1.Origin = 'Gainsight';
            case1.Case_type__C = 'Proactive';
            case1.AccountId = testAccount.ID;
            //insert case1;
            //Task taskRec = new Task(RecordTypeId='01230000001IZDdAAO',Subject='Test',Source__c='Other',Status='Open',Priority='Low',WhatId=case1.id,Type='Gainsight',IsVisibleInSelfService=true);
           // taskRec.Status = 'Completed';
           // case1.ownerId ='005a000000C0Uy9';
            Test.StopTest();    
        }
    }
    static testmethod void testInsertCaseCAProduct () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest(); 
            //SupportOfferingsFlowController sp=new SupportOfferingsFlowController();
            //sp.fetchExternalObjectData();
            
            Case case1 = TestCaseHandler.prepareCase('3');  
            insert case1;
            
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            
            case1.CA_Product_Controller__c = testCAProduct2.id;
            case1.CA_Product_Component__c = testCAComponent1.id;
            
            update case1;
            Test.StopTest();
            
        }   
    }
    
    static testmethod void testInsertCaseCAProduct2 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest(); 
            //SupportOfferingsFlowController sp=new SupportOfferingsFlowController();
            //sp.fetchExternalObjectData();
            
            Case case1 = TestCaseHandler.prepareCase1('3');  
            insert case1;
            
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            
            case1.Severity__c = '3';
            update case1;
            Test.StopTest();
            
        }   
    }
    
    
    static testmethod void testInsertCase1 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest();         
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('2');                       
            caseList.add(case1);             
            insert caseList;             
            Test.StopTest();
        }   
    } 
    
    static testmethod void testInsertCase3 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest();
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCaseforComments('3'); 
            //case1.Offering_Code_Configuration_Issue__c = true;
            //case1.Offering_Code_Ref__c = 'Code 123';
            //case1.Offering_Name__c = offeringBusinessRulesObj.Id;
            caseList.add(case1);
            insert caseList; 
            system.debug('=====>>>>'+caseList);
            system.debug('query: '+[Select site_association__r.sc_tops_id__c, Tops_Support_Site_ID__c from case where id=:caseList[0].Id]);
            system.debug('query: '+[Select sc_tops_id__c, id from site_association__c where id=:testsite.id]);
            Test.StopTest();
        }   
    }
   
    static testmethod void testInsertCase4 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('1');                       
            caseList.add(case1); 
            FutureMethod_Assign_support_Generic.isFutureRunning = true;            
            insert caseList;   
            Test.StartTest();         
            caseRunOnceFlag.caseRunOnce = true;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            TaskGateway.skipForNewtaskTypes = true; // set this to skip task trigger here

            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;            
            
            case1.Status = 'Verify';
            case1.Resolution__c = 'test';
            case1.Root_Cause__c = 'test';
            case1.Category__c = 'Test';
            case1.Subcategory__c = 'test';
            case1.Reason = 'testing';
            update case1;
            
            Test.StopTest();
        }   
    }
    
    static testmethod void testInsertCase5 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
                   
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('1');                       
            caseList.add(case1);     
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            insert caseList;   
            Test.StartTest();  
            caseRunOnceFlag.caseRunOnce = true;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            TaskGateway.skipForNewtaskTypes = true; // set this to skip task trigger here

            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            
            case1.Troubleshooting_Stage__c = '4. Solution Identification';
            case1.Status = 'Open';
            case1.Resolution__c = 'test';
            case1.Root_Cause__c = 'test';
            case1.Category__c = 'Test';
            case1.Subcategory__c = 'test';
            case1.Reason = 'testing';
            case1.Product_Material__c = productMaterial.Id;
            case1.Language__c = 'ENG ENGLISH';
            case1.Alt_Contact_Preferred_Language__c = 'English';
            case1.Product_Release_Selection__c = productRelease.Id; 
            update case1;
            
            Test.StopTest();
        }   
    }
    // /*****
/*    static testmethod void testInsertCase6 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
                  
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('1');                       
            caseList.add(case1);  
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            insert caseList;   
            Test.StartTest();   
            caseRunOnceFlag.caseRunOnce = true;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            TaskGateway.skipForNewtaskTypes = true; // set this to skip task trigger here

            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            case1.Severity__c='3';
            update case1;
            
            Test.StopTest();
        }   
    }*/
    
    /*static testmethod void testInsertCaseBoth () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
                   
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('1');                       
            caseList.add(case1);   
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            insert caseList;   
            Test.StartTest();  
            caseRunOnceFlag.caseRunOnce = true;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            TaskGateway.skipForNewtaskTypes = true; // set this to skip task trigger here
            
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            case1.Severity__c='3';
            case1.Troubleshooting_Stage__c = '4. Solution Identification';
            update case1;
            
            Test.StopTest();
        }   
    }
    
    static testmethod void testInsertCase7 () {
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
                    
            List<Case> caseList = new List<Case>();            
            Case case1 = TestCaseHandler.prepareCase('1');                       
            caseList.add(case1);
            FutureMethod_Assign_support_Generic.isFutureRunning = true;            
            insert caseList;   
            Test.StartTest(); 
            FutureMethod_Assign_support_Generic.isFutureRunning = true;            
            caseRunOnceFlag.caseRunOnce = true;
            TaskGateway.skipForNewtaskTypes = true; // set this to skip task trigger here
            
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=case1.Id);
            insert t;
            UtilityFalgs.isSEActionTaskCreated = true;
            case1.Troubleshooting_Stage__c = '4. Solution Identification';
            update case1;
            
            Test.StopTest();
        }   
    }
    */
    
    
    static testmethod void testCaseSevChange(){
     system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){            
            Test.StartTest(); 
        //    SupportOfferingsFlowController sp=new SupportOfferingsFlowController();
         //   sp.fetchExternalObjectData();
            List<Case> caseList = new List<Case>(); 
            
            Case case1 = TestCaseHandler.prepareCase('3');                       
            caseList.add(case1);             
            insert caseList;   
            
            case1.Severity__c = '1';
            case1.Sev_1_Impact_c__c = 'Test';
            case1.Production_Down_Status__c = 'Test';
            update case1;
            
            case1.Manager_Action__c = 'Manager Action Taken';
            case1.Manager_Action_Comment__c = 'test';
            update case1;
            
            Test.StopTest();
        }        
    }
    
    static testmethod void testDeleteCase (){
        try{
            delete [select Id from Case where Status ='Open' limit 1];
        }catch(exception e){}   
    }
    
    static testmethod void validationsOnStage(){
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){
            Test.startTest();
            try{
                Case caseObj = TestCaseHandler.prepareCase('1');
                caseObj.Troubleshooting_Stage__c = '7. Closed';
                insert caseObj;
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot select Troubleshooting Staged as 7. Closed') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);  
            }  
            
            try{
                caseRunOnceFlag.caseRunOnce = true;
                System.debug('In try block');
                Case caseObj = TestCaseHandler.prepareCase('1');
                insert caseObj;
                caseObj = [select id, Status,Troubleshooting_Stage__c from Case where id = :caseObj.Id];
                System.debug('caseObj:'+caseObj);
                caseObj.Status = 'Open';
                caseObj.Troubleshooting_Stage__c = '7. Closed';
                caseRunOnceFlag.caseRunOnce = true;
                update caseObj;
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Invalid Data.Troubleshooting Stage field cannot be set to Closed for Updating Case') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
            Test.stopTest();
        }        
    }
    
    static testmethod void validationOnNextActionDueDate(){
        system.runAs(createDataUser()){
            createTestData();
        }     
        system.runAs(supportUser){
            Test.startTest();
            try{
                Case caseObj = TestCaseHandler.prepareCase('1');
                caseObj.Next_Action__c = null;
                caseObj.Next_Action_Due_Date__c = System.now()+1;
                insert caseObj;
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.NextActionOwnerMustnotBeBlank.trim()) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }            
            Test.stopTest();
        }
    }
    
    static testmethod void  validateCaseClosureAndReopen(){
        system.runAs(createDataUser()){
            createTestData();
        } 
        system.runAs(supportUser){
            Test.startTest();
            Case caseObj = TestCaseHandler.prepareCase('1');
            insert caseObj;   
            caseObj = TestCaseHandler.closeCase(caseObj.Id);
            //caseRunOnceFlag.caseRunOnce = false;
            update caseObj;
            
            caseObj = [select Troubleshooting_Stage__c,status,Reason_for_Reopen__c from Case where id =:caseObj.Id];
            System.debug('caseObj Status:'+caseObj.Status);
            caseObj.Troubleshooting_Stage__c = '1. Problem Identification';
            caseObj.status = 'Open';
            caseObj.Reason_for_Reopen__c = 'Test case reopen';
            caseObj.Next_Action__c = 'Issue Closed';
            caseObj.Next_Action_Due_Date__c = system.now().addDays(5);
            caseObj.Next_Action_Date__c = system.today().addDays(1);
            caseObj.Reopen_Count__c = 2;
            //caseRunOnceFlag.caseRunOnce = true;
            UtilityFalgs.callbackCreated = false;
            update caseObj;             
            Test.stopTest();
        }
    }
    
    static testmethod void  validateCaseClosure(){
        system.runAs(createDataUser()){
            createTestData();
        } 
        system.runAs(supportUser){
            Test.startTest();
            Case caseObj = testCaseHandler.prepareCase('3');
            insert caseObj;   
            caseObj = TestCaseHandler.closeCase(caseObj.Id);
            //caseRunOnceFlag.caseRunOnce = false;
            update caseObj;
            Task t = new Task(Subject='Test SE Action',RecordTypeId = Label.Other_Support_Task_Record_Type,Type = 'SE Action',whatId=caseObj.Id);
            insert t;
             
           Test.stopTest();
        }
    }
    
    static testmethod void caseGatewayDummy(){
        CaseGateway CaseGatewayObj = new CaseGateway();
        CaseGatewayObj.caseGatewayTestData();        
    }
    
    static testmethod void caseHandlerDummy(){
        CaseHandler CaseHandlerObj = new CaseHandler();
        CaseHandlerObj.caseHandlerTestData();
    }
    
    static testmethod void  validateCaseClosureAndReopen1(){
        system.runAs(createDataUser()){
            createTestData();
        } 
        system.runAs(supportUser){
            Test.startTest();
            Case caseObj = TestCaseHandler.prepareCase('1');
            insert caseObj;   
            caseObj = TestCaseHandler.closeCase1(caseObj.Id);
            //caseRunOnceFlag.caseRunOnce = false;
            update caseObj;
            
            caseObj = [select Troubleshooting_Stage__c,status,Reason_for_Reopen__c from Case where id =:caseObj.Id];
            System.debug('caseObj Status:'+caseObj.Status);
            caseObj.Troubleshooting_Stage__c = '1. Problem Identification';
            caseObj.status = 'Open';
            caseObj.Reason_for_Reopen__c = 'Test case reopen';
            caseObj.Next_Action__c = 'Issue Closed';
            caseObj.Next_Action_Due_Date__c = system.now().addDays(5);
            caseObj.Next_Action_Date__c = system.today().addDays(1);
            caseObj.Reopen_Count__c = 2;
            //caseRunOnceFlag.caseRunOnce = true;
            UtilityFalgs.callbackCreated = false;
            update caseObj;             
            Test.stopTest();
        }
    }
    
    static testmethod void testSendNotificationonEmailTask(){
        User u;
        system.runAs(createDataUser()){
            createTestData();
            u = new User(Alias = 'test12', Email='test@ca.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId() , 
                         TimeZoneSidKey='America/Los_Angeles', UserName='testSendMail@ca.com');
            insert u;
        }
        system.runAs(supportUser){
            Test.startTest();
            Case caseObj = TestCaseHandler.prepareCase('1');
            caseObj.OwnerId = u.id;
            insert caseObj;
            CaseTeamRole ctr = new CaseTeamRole(Name = 'TestRole',AccessLevel = 'Edit');
            insert ctr;
            CaseTeamMember ctm = new CaseTeamMember(ParentId = caseObj.id,MemberId = createDataUser().id,TeamRoleId = ctr.Id);
            insert ctm;
            
            CaseComment caseCommentRec = new CaseComment(ParentId =caseObj.id,commentBody = 'Test Comment');
            insert caseCommentRec;
            
            Task taskRec = new Task(Type='Email',Status = 'Completed',Description='test task',whatid=caseObj.Id);
            insert taskRec;
            
             Task taskRec1 = new Task(Subject='test',Type='SaaS Ops Request',Status = 'Completed',Description='test task',whatid=caseObj.Id);
            insert taskRec1;
            taskRec1.Subject='test123';
            //update taskRec1 ;
            
           
            
        }
    } 
    
    static testmethod void testUpdateTask(){       
        system.runAs(createDataUser()){
            createTestData();            
        }
        system.runAs(supportUser){
            TPC_Team__c tpcTeamRec= new TPC_Team__C (Name = 'TestTPCTeam');
            insert tpcTeamRec;
            Case caseObj = TestCaseHandler.prepareCase('1');
            caseObj.TPC_Team__c = tpcTeamRec.Id;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            insert caseObj;
            Test.startTest();           
            Task taskRec1 = new Task(Subject='test',Type='SaaS Ops Request',Status = 'Completed',Description='test task',whatid=caseObj.Id);
            insert taskRec1;
            taskRec1.Subject='test123';
            update taskRec1 ; 
            Test.stopTest();             
            delete taskRec1;                      
        }
    } 

     static testmethod void testRestorationTask(){       
        system.runAs(createDataUser()){
            createTestData();            
        }
        system.runAs(supportUser){
            TPC_Team__c tpcTeamRec= new TPC_Team__C (Name = 'TestTPCTeam');
            insert tpcTeamRec;
            Case caseObj = TestCaseHandler.prepareCase('1');
            caseObj.TPC_Team__c = tpcTeamRec.Id;
            FutureMethod_Assign_support_Generic.isFutureRunning = true;
            insert caseObj;
            Test.startTest();           
            Task taskRec1 = new Task(Subject='Restoration',Type='Retsoration',Status = 'Completed',Description='test task',whatid=caseObj.Id);
            insert taskRec1;
            
            Test.stopTest();                     
        }
    }


     
    private static Case prepareCaseforComments(String severity){
        Case caseRec = new Case();
        caseRec.Site_Association__c = testSite.Id ;
        caseRec.subject = 'Test Subject' ; 
        caseRec.Description = 'Test Description' ; 
        caseRec.ContactId = testContact.Id ; 
        caseRec.CA_Product_Controller__c = testCAProduct2.Id; 
        caseRec.CA_Product_Component__c = testCAComponent1.id;
        caseRec.Origin = 'Phone Call';       
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
        caseRec.Status = 'Open';
        caseRec.Offering_Tops_Product_Code_Selected__c='ABCD1234';
        caseRec.Offering_Code_Ref__c='Code 123';
        caseRec.Offering_Name__c=offeringBusinessRulesObj.Id;
        caseRec.Offering_Support_Engineer__c='GOVAD01';
        caseRec.Offering_Code_Configuration_Issue__c=true;
        caseRec.Severity__c = severity;       
        if(severity == '1'){
            caseRec.Sev_1_Impact_c__c = 'Production Down';
            caseRec.Production_Down_Status__c = 'Investigating';
        }
        return caseRec;
    }
    @TestVisible
    public static Case prepareCase(String severity){
        Case caseRec = new Case();
        caseRec.Site_Association__c = testSite.Id ;
        caseRec.subject = 'Test Subject' ; 
        caseRec.Description = 'Test Description' ; 
        caseRec.ContactId = testContact.Id ; 
        caseRec.CA_Product_Controller__c = testCAProduct.Id; 
        caseRec.Origin = 'Phone Call';       
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
        caseRec.Status = 'Open';
        caseRec.Severity__c = severity; 
        if(severity == '1'){
            caseRec.Sev_1_Impact_c__c = 'Production Down';
            caseRec.Production_Down_Status__c = 'Investigating';
        }
        return caseRec;
    }
    
    @TestVisible
    private static Case prepareCase1(String severity){
        Case caseRec = new Case();
        caseRec.Site_Association__c = testSite.Id ;
        caseRec.subject = 'Test Subject' ; 
        caseRec.Description = 'Test Description' ; 
        caseRec.Internal_Contact__c = testUser.id;
        caseRec.CA_Product_Controller__c = testCAProduct2.Id; 
        caseRec.Origin = 'Phone Call';       
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
        caseRec.Status = 'Open';
        caseRec.Severity__c = severity; 
        if(severity == '1'){
            caseRec.Sev_1_Impact_c__c = 'Production Down';
            caseRec.Production_Down_Status__c = 'Investigating';
        }
        return caseRec;
    }
    
    private static Case prepareCaseClosed(String severity){
        Case caseRec = new Case();
        caseRec.Site_Association__c = testSite.Id ;
        caseRec.subject = 'Test Subject' ; 
        caseRec.Description = 'Test Description' ; 
        caseRec.Internal_Contact__c = testUser.id;
        caseRec.CA_Product_Controller__c = testCAProduct2.Id; 
        caseRec.Origin = 'Phone Call';       
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
        caseRec.Status = 'Open';
        //caseRec.Next_Action__c = 'Issue Closed';
        caseRec.Severity__c = severity; 
        if(severity == '1'){
            caseRec.Sev_1_Impact_c__c = 'Production Down';
            caseRec.Production_Down_Status__c = 'Investigating';
        }
        return caseRec;
    }
    
    private static Case closeCase(Id caseId){
        case caseRec = [select id,Troubleshooting_Stage__c, Status,Reason,Category__c,Subcategory__c,Resolution__c,Product_Material__c,Product_Release_Selection__c from case where id =: caseId];
        caseRec.Troubleshooting_Stage__c = '7. Closed';
        caseRec.Status = 'Closed';
        caseRec.Reason = 'Answer - Available';
        caseRec.Category__c = 'Documentation';
        caseRec.Subcategory__c = 'Education';
        caseRec.Resolution__c = 'Test Case Closure';
        caseRec.Product_Material__c = productMaterial.Id;
        caseRec.Product_Release_Selection__c = productRelease.Id; 
        caseRec.Reopen_Count__c = 2;      
        return caseRec;
    } 
    
    private static Case closeCase1(Id caseId){
        case caseRec = [select id,Troubleshooting_Stage__c, Status,Reason,Category__c,Subcategory__c,Resolution__c,Product_Material__c,Product_Release_Selection__c from case where id =: caseId];
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';
        caseRec.Status = 'Open';
        caseRec.Reason = 'Answer - Available';
        caseRec.Category__c = 'Documentation';
        caseRec.Subcategory__c = 'Education';
        caseRec.Resolution__c = 'Test Case Closure';
        caseRec.Product_Material__c = productMaterial.Id;
        caseRec.Product_Release_Selection__c = productRelease.Id;    
        caseRec.Reopen_Count__c = 2;   
        return caseRec;
    }
    
}