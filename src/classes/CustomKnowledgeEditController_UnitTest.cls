@isTest
private class CustomKnowledgeEditController_UnitTest {
	private static String articleNumber;
    private static String productId1;
    private static String productId;
    private static String componentString;
    private static String releaseString;
    private static String articleKnwId;
    private static List<knowledge__kav> listKnowledgeObj;
    private static String URLNameVal;
    private static String kavid;

	@isTest static void testExistingArticle() {
		system.runAs(createDataUser()){
            //createTestData();
        }
        system.runAs(createDataUser()){
			Test.startTest();
	        createArticles();
	        //String rtId = [Select id, Name from RecordType where Name='Case / Issue' limit 1].Id;
	        //Case c = [SELECT Id FROM Case LIMIT 1];
	        List<Knowledge__kav> onlineArticles = getOnlineArticles();
	        Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
			System.currentPageReference().getParameters().put('articleId', onlineArticles[0].Id);
	        CustomKnowledgeEditController ckec = new CustomKnowledgeEditController();
	        Test.setCurrentPageReference(ckec.createNewVersion());
	        ckec = new CustomKnowledgeEditController();
	        ckec.save();
	        Test.stopTest();
	    }
	}

	@isTest static void testNewArticle() {
		system.runAs(createDataUser()){
            //createTestData();
        }
        system.runAs(createDataUser()){
			Test.startTest();
	        //createArticles();
	        String rtId = [Select id, Name from RecordType where Name='Case / Issue' limit 1].Id;
	        //Case c = [SELECT Id FROM Case LIMIT 1];
	        List<Knowledge__kav> onlineArticles = getOnlineArticles();
	        Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
			System.currentPageReference().getParameters().put('recordTypeId', rtId);
	        CustomKnowledgeEditController ckec = new CustomKnowledgeEditController();
	        ckec.kav.Content1__c = 'test';
	        ckec.kav.Content2__c = 'test';
	        ckec.kav.Title = 'test';
	        ckec.kav.UrlName = 'test-url';
	        ckec.kav.Summary = 'test summary';
	        ckec.d.Body = Blob.valueOf('test');
	        ckec.d.Name = 'test.txt';
	        ckec.save();
	        ckec.replaceAttachment();
	        ckec.allowAttachment();
	        ckec.cancelAttachment();
	        PageReference submitforApproval = ckec.submitForApproval();

	        ckec.publishPopup();
	        ckec.closePublishPopup();
	        ckec.enableAssignment();
	        ckec.disableAssignment();
	        ckec.assignmentAssigneeId = UserInfo.getUserId();
	        ckec.assignmentInstructions = 'test';
	        ckec.assignmentDueDate = Date.today();
	        ckec.assignmentSendEmail = false;
	        ckec.assignArticle();
	        PageReference newVersion = ckec.createNewVersion();
	        ckec.publishOption = 'now';
	        PageReference publish = ckec.publishArticle();


	        Test.stopTest();
	    }
	}

    @isTest static void testCustomApproval() {
        system.runAs(createDataUser()){
            //createTestData();
        }
        system.runAs(createDataUser()){
            Test.startTest();
            //createArticles();
            String rtId = [Select id, Name from RecordType where Name='Case / Issue' limit 1].Id;
            //Case c = [SELECT Id FROM Case LIMIT 1];
            List<Knowledge__kav> onlineArticles = getOnlineArticles();
            Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
            System.currentPageReference().getParameters().put('recordTypeId', rtId);
            CustomKnowledgeEditController ckec = new CustomKnowledgeEditController();
            ckec.kav.Content1__c = 'test';
            ckec.kav.Content2__c = 'test';
            ckec.kav.Title = 'test';
            ckec.kav.UrlName = 'test-url';
            ckec.kav.Summary = 'test summary';
            ckec.kav.Component_Names__c = 'test';
            ckec.kav.Component_Codes__c = 'test';
            ckec.d.Body = Blob.valueOf('test');
            ckec.d.Name = 'test.txt';
            ckec.save();

            PageReference submitforApproval = ckec.submitForApproval();
            Test.setCurrentPageReference(submitforApproval);
            ckec = new CustomKnowledgeEditController();
            String apprId = ckec.approvals[0].Id;
            String kavid = ckec.kav.Id;
            Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeApproval')); 
            System.currentPageReference().getParameters().put('id', apprId);
            System.currentPageReference().getParameters().put('articleId', kavid);
            CustomKnowledgeApprovalController ckac = new CustomKnowledgeApprovalController();
            ckac.cancel();
            ckac.reject();
            ckac.comments = 'bad';
            ckac.reject();
            Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
            System.currentPageReference().getParameters().put('articleId', kavid);
            ckec = new CustomKnowledgeEditController();
            submitforApproval = ckec.submitForApproval();
            Test.setCurrentPageReference(submitforApproval);
            ckec = new CustomKnowledgeEditController();
            apprId = ckec.approvals[0].Id;
            Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeApproval')); 
            System.currentPageReference().getParameters().put('id', apprId);
            System.currentPageReference().getParameters().put('articleId', kavid);
            ckac = new CustomKnowledgeApprovalController();
            ckac.approve();
            //ckac.approve();
			Map<String,String> fileTypes = ckec.attachmentFileTypes();
            PageReference ci = ckec.cancelIt();
            

            Test.stopTest();
        }
    }

	@isTest static void testNewArticleFromCase() {
		system.runAs(createDataUser()){
            createTestData();
        }
        system.runAs(createDataUser()){
			Test.startTest();
	        //createArticles();
	        String rtId = [Select id, Name from RecordType where Name='Case / Issue' limit 1].Id;
	        Case c = [SELECT Id FROM Case LIMIT 1];
	        List<Knowledge__kav> onlineArticles = getOnlineArticles();
	        Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
			System.currentPageReference().getParameters().put('recordTypeId', rtId);
			System.currentPageReference().getParameters().put('caseId', c.Id);
	        CustomKnowledgeEditController ckec = new CustomKnowledgeEditController();
	        ckec.kav.Content1__c = 'test';
	        ckec.kav.Content2__c = 'test';
	        ckec.kav.Title = 'test';
	        ckec.kav.UrlName = 'test-url';
	        ckec.kav.Summary = 'test summary';
	        ckec.save();
	        //ckec.initializeProductSelection();
	        PageReference returnToCase = ckec.returnToCase();
	        PageReference attachToCase = ckec.attachAndReturnToCase();
	        ckec.publishOption = 'future';
	        ckec.t.ActivityDate = Date.today().addDays(1);
	        PageReference publish = ckec.publishArticle();

	        Test.stopTest();
	    }
	}

	private static testMethod void productAssociationMethod(){
        Test.startTest();
        createTestDataProducts();
        Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
        System.currentPageReference().getparameters().put('articleId', kavid);
        System.currentPageReference().getparameters().put('aId', articleNumber);
        CustomKnowledgeEditController controller = new CustomKnowledgeEditController();
        System.currentPageReference().getparameters().put('productName', productId);
        controller.productComponent();
        controller.getProductComponent();
        controller.getSelectedComponents();
        controller.getRelease();
        controller.getSelectedReleases();
        System.currentPageReference().getparameters().put('productId', productId);
        System.currentPageReference().getparameters().put('articleNum', articleNumber);
        System.currentPageReference().getparameters().put('prepareCompString', componentString);
        System.currentPageReference().getparameters().put('prepareReleaseString', releaseString);
        controller.createPrimaryProductAssociation();
        controller.cancelDetails();
        System.currentPageReference().getparameters().put('productRecordId', productId);
        controller.fetchValuesForEdit();
        System.currentPageReference().getparameters().put('buttonId', 'saveAndCloseButton');
        controller.submitProductAssociation();
        
        System.currentPageReference().getparameters().put('productId', productId);
        System.currentPageReference().getparameters().put('productFlag', 'true');
        System.currentPageReference().getparameters().put('productComponent', componentString);
        System.currentPageReference().getparameters().put('productRelease', releaseString);
        System.currentPageReference().getparameters().put('artNum', articleNumber);
        controller.callRemoveProduct();
        Test.stopTest();
    }
    
    private static testMethod void productAssociationMethod2(){
        Test.startTest();
        createTestDataProducts();
        Test.setCurrentPageReference(new PageReference('Page.CustomKnowledgeEdit')); 
        System.currentPageReference().getparameters().put('articleId', kavid);
        System.currentPageReference().getparameters().put('aId', articleNumber);
        CustomKnowledgeEditController controller = new CustomKnowledgeEditController();
        System.currentPageReference().getparameters().put('productName', productId1);
        controller.productComponent();
        controller.getProductComponent();
        controller.getSelectedComponents();
        controller.getRelease();
        controller.getSelectedReleases();
        System.currentPageReference().getparameters().put('productId', productId1);
        System.currentPageReference().getparameters().put('articleNum', articleNumber);
        System.currentPageReference().getparameters().put('prepareCompString', componentString);
        System.currentPageReference().getparameters().put('prepareReleaseString', releaseString);
        controller.createPrimaryProductAssociation();
        controller.cancelDetails();
        System.currentPageReference().getparameters().put('productRecordId', productId1);
        controller.fetchValuesForEdit();
        System.currentPageReference().getparameters().put('buttonId', 'saveAndCloseButton');
        controller.submitProductAssociation();
        
        System.currentPageReference().getparameters().put('productId', productId1);
        System.currentPageReference().getparameters().put('productFlag', 'true');
        System.currentPageReference().getparameters().put('productComponent', componentString);
        System.currentPageReference().getparameters().put('productRelease', releaseString);
        System.currentPageReference().getparameters().put('artNum', articleNumber);
        controller.callRemoveProduct();
        Test.stopTest();
    }

	private static List<Knowledge__kav> getOnlineArticles() {
		return [SELECT Id, Title, UrlName, Summary, RecordTypeId, ArticleNumber, PublishStatus, KnowledgeArticleId FROM Knowledge__kav WHERE PublishStatus = 'Online'];
	}

	private static void createArticles() {
		      List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        List<knowledge__kav> listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        listKnowledgeObj.add(knowledgeObj1);
        
        knowledge__kav knowledgeObj2 = new knowledge__kav();
        knowledgeObj2.Title = 'test11112';
        knowledgeObj2.UrlName = 'testing12111';
        knowledgeObj2.Summary = 'testingning121111';
        knowledgeObj2.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1';
        knowledgeObj2.Product_Names__c = 'CA PPM';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.IsVisibleInPkb = true;
        knowledgeObj2.Introduction__c = '<a></a>';
        knowledgeObj2.Additional_Information__c = '<a></a>';
        knowledgeObj2.Answer__c = '<a></a>';
        knowledgeObj2.Background__c = '<a></a>';
        knowledgeObj2.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj2);
        
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112x';
        knowledgeObj3.UrlName = 'testing12111x';
        knowledgeObj3.Summary = 'testingning121x111';
        knowledgeObj3.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1';
        knowledgeObj3.Product_Names__c = 'CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.IsVisibleInPkb = true;
        knowledgeObj3.Introduction__c = '<a></a>';
        knowledgeObj3.Additional_Information__c = '<a></a>';
        knowledgeObj3.Answer__c = '<a></a>';
        knowledgeObj3.Background__c = '<a></a>';
        knowledgeObj3.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj3);
        insert listKnowledgeObj;
        
        List<knowledge__kav> testingKav = [Select id, knowledgeArticleId from knowledge__kav where Id=:listKnowledgeObj[2].Id];
        KbManagement.PublishingService.publishArticle(testingKav[0].knowledgeArticleId, true);
	}

	private static void createTestData(){

        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
    	SystemIdUtility.skipAccountOnMIPSUpdate = true;    
    	TestSLOMilestonesDataSetup.createTestDataforMilestones(); 
        Account testAccount = new Account();
        testAccount.Name = 'test CAAcc';
        testAccount.Country_Picklist__c = 'AL - ALBANIA';
        testAccount.Account_Status__c = 'New';
        testAccount.Geo__c = 'EMEA';
        testAccount.BillingStreet='Arlington';
        testAccount.BillingCity='NY';
        testAccount.BillingCountry='US';
        insert testAccount ;
        
        Provisional_Site_Number__c provSiteNum = new Provisional_Site_Number__c();
        provSiteNum.Name = 'Last Site No';
        provSiteNum.Prov_Site_Number__c=9999909;
        insert provSiteNum;
        Site_Association__c testSiteAssociation = new Site_Association__c();
        testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
        testSiteAssociation.SAP_Site_ID__c = '280125';
        testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
        testSiteAssociation.Enterprise_ID__c = testAccount.Id;
        testSiteAssociation.SC_TOPS_ID__c = '1299636';
        //testSiteAssociation.Country_picklist__c= 'US - UNITED STATES';
        //testSiteAssociation.State__c='New York';
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

        /*XMD_Product__c xmd = new XMD_Product__c();
        xmd.name='Test';
        insert xmd;

        CA_XMD_Product_Mapping__c xmdmap = new CA_XMD_Product_Mapping__c();
        xmdmap.CA_Product__c = prodCtl.Id;
        xmdmap.XMD_Product__c = xmd.Id;
        insert xmdmap;*/
        
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
        testCase.Sev_1_Impact_c__c='Production Down';
        testCase.Internal_Priority__c='2';
        testCase.Production_Down_Status__c='Investigating';
        testCase.Alternate_email__c='vamsi.r@gmail.com';
        //testCase.BusinessHours='IN - INDIA';
        
        testCase.Component_Release_Only_Selection__c=  componentRelease.Id;
        
        insert testCase;
        /*Case c = new Case();
        c.Subject = 'test subject';
        c.Description = 'test description';
        insert c;*/
    }

    public static User createDataUser(){
       /* adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO' limit 1];
        testUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
        return testUser ; */
        User testUser = new User(id = UserInfo.getUserId());
        return testUser;
    }

    private static void createTestDataProducts(){
        List<XMD_Product__c> xmdProductList = new List<XMD_Product__c>();
        XMD_Product__c xmdObj = new XMD_Product__c();
        xmdObj.Name = 'CA Application Performance Management';
        xmdObj.CMS_ID__c = '5974';
        xmdProductList.add(xmdObj);
        
        XMD_Product__c xmdObj1 = new XMD_Product__c();
        xmdObj1.Name = 'CA PPM';
        xmdObj1.CMS_ID__c = '5590';
        xmdProductList.add(xmdObj1);
        
        XMD_Product__c xmdObj2 = new XMD_Product__c();
        xmdObj2.Name = 'CA Service Desk Manager';
        xmdObj2.CMS_ID__c = '8165';
        xmdProductList.add(xmdObj2);
        
        XMD_Product__c xmdObj3 = new XMD_Product__c();
        xmdObj3.Name = 'CA Single Sign-On';
        xmdObj3.CMS_ID__c = '5262';
        xmdProductList.add(xmdObj3);
        
        insert xmdProductList;
        productId = xmdProductList[1].id;
        productId1 = xmdProductList[0].id;
        
        List<CA_Product_Controller__c> listOfCA = new List<CA_Product_Controller__c>();
        CA_Product_Controller__c caProductObj1 = new CA_Product_Controller__c();
        caProductObj1.name='CLARITY ON DEMAND';
        listOfCA.add(caProductObj1);
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='CLARITY ON PREMISE';
        listOfCA.add(caProductObj);
        
        CA_Product_Controller__c caProductObj2 = new CA_Product_Controller__c();
        caProductObj2.name='SERVICE DESK MANAGER';
        listOfCA.add(caProductObj2);
        
        CA_Product_Controller__c caProductObj3 = new CA_Product_Controller__c();
        caProductObj3.name='SINGLE SIGN ON';
        listOfCA.add(caProductObj3);
        insert listOfCA; 
        
        List<Product_Names__c> listOfPN = new List<Product_Names__c>();
        Product_Names__c pnObj = new Product_Names__c();
        pnObj.CA_Product_Controller__c = listOfCA[0].Id;
        pnObj.Product_Synonyms__c = 'testing';
        pnObj.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj);
        
        Product_Names__c pnObj1 = new Product_Names__c();
        pnObj1.CA_Product_Controller__c = listOfCA[1].Id;
        pnObj1.Product_Synonyms__c = 'testing1';
        pnObj1.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj1);
        
        Product_Names__c pnObj2 = new Product_Names__c();
        pnObj2.CA_Product_Controller__c = listOfCA[1].Id;
        pnObj2.Product_Synonyms__c = 'testing2';
        pnObj2.Product_Usage__c = 'Documentation';
        listOfPN.add(pnObj2);
        
        insert listOfPN;
        
        List<CA_Product_Component__c> listOfComp = new List<CA_Product_Component__c>();
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='CLARITY ON DEMAND ODMNTR';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='ODMNTR';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp);
        
        CA_Product_Component__c prodcomp1 = new CA_Product_Component__c();
        prodcomp1.Name='SERVICE DESK MANAGER SMDOC';
        prodcomp1.CA_Product_Component_Ext_ID__c='Test';
        prodcomp1.Default_Component_for_CA_Product__c=True;
        prodcomp1.CA_Product_Controller__c=listOfCA[2].id;
        prodcomp1.CA_Product_Text__c='Test';
        prodcomp1.Component_Code__c='Test';
        prodcomp1.Component_Text__c='SMDOC';
        prodcomp1.Default_Component_for_this_CA_Product__c=True;
        prodcomp1.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp1);
        
        CA_Product_Component__c prodcomp2 = new CA_Product_Component__c();
        prodcomp2.Name='CLARITY ON PREMISE ODPRD';
        prodcomp2.CA_Product_Component_Ext_ID__c='Test';
        prodcomp2.Default_Component_for_CA_Product__c=True;
        prodcomp2.CA_Product_Controller__c=listOfCA[1].id;
        prodcomp2.CA_Product_Text__c='Test';
        prodcomp2.Component_Code__c='ODPRD';
        prodcomp2.Component_Text__c='Test';
        prodcomp2.Default_Component_for_this_CA_Product__c=True;
        prodcomp2.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp2);
        
        CA_Product_Component__c prodcomp3 = new CA_Product_Component__c();
        prodcomp3.Name='SINGLE SIGN ON SSODOC';
        prodcomp3.CA_Product_Component_Ext_ID__c='Test';
        prodcomp3.Default_Component_for_CA_Product__c=True;
        prodcomp3.CA_Product_Controller__c=listOfCA[3].id;
        prodcomp3.CA_Product_Text__c='Test';
        prodcomp3.Component_Code__c='SSODOC';
        prodcomp3.Component_Text__c='Test';
        prodcomp3.Default_Component_for_this_CA_Product__c=True;
        prodcomp3.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp3);
        
        CA_Product_Component__c prodcomp4 = new CA_Product_Component__c();
        prodcomp4.Name='CLARITY ON DEMAND 22';
        prodcomp4.CA_Product_Component_Ext_ID__c='Test';
        prodcomp4.Default_Component_for_CA_Product__c=True;
        prodcomp4.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp4.CA_Product_Text__c='Test';
        prodcomp4.Component_Code__c='22';
        prodcomp4.Component_Text__c='Test';
        prodcomp4.Default_Component_for_this_CA_Product__c=True;
        prodcomp4.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp4);
        insert listOfComp;
        
        List<Product_Material__c> productMaterialList = new List<Product_Material__c>();
        Product_Material__c productMaterialObj = new Product_Material__c();
        productMaterialObj.Name = 'ITMEBM9900';
        productMaterialObj.CA_Product_Controller__c = listOfCA[0].Id;
        productMaterialObj.Source_System__c = 'TOPS';
        productMaterialList.add(productMaterialObj);
        
        Product_Material__c productMaterialObj1 = new Product_Material__c();
        productMaterialObj1.Name = 'ITMEBM9900';
        productMaterialObj1.CA_Product_Controller__c = listOfCA[0].Id;
        productMaterialObj1.Source_System__c = 'TOPS';
        productMaterialList.add(productMaterialObj1);
        
        insert productMaterialList;
        
        Product_Release__c productReleaseObj =  new Product_Release__c();
        productReleaseObj.Name = 'ITMEBM99000-5.6-IT Process Manager-Enterprise Bundle';
        productReleaseObj.Product_Release__c = '1';
        productReleaseObj.Product_Material__c = productMaterialList[0].Id; 
        insert productReleaseObj;
        
        releaseString = productReleaseObj.Product_Release__c;
        List<CA_XMD_Product_Mapping__c> mappingList = new List<CA_XMD_Product_Mapping__c>();
        CA_XMD_Product_Mapping__c mappingObj = new CA_XMD_Product_Mapping__c();
        mappingObj.CA_Product__c = listOfCA[0].id;
        mappingObj.XMD_Product__c = xmdProductList[1].Id;
        mappingList.add(mappingObj);
        
        CA_XMD_Product_Mapping__c mappingObj1 = new CA_XMD_Product_Mapping__c();
        mappingObj1.CA_Product__c = listOfCA[1].id;
        mappingObj1.XMD_Product__c = xmdProductList[1].Id;
        mappingList.add(mappingObj1);
        
        CA_XMD_Product_Mapping__c mappingObj2 = new CA_XMD_Product_Mapping__c();
        mappingObj2.CA_Product__c = listOfCA[2].id;
        mappingObj2.XMD_Product__c = xmdProductList[2].Id;
        mappingList.add(mappingObj2);
        
        CA_XMD_Product_Mapping__c mappingObj3 = new CA_XMD_Product_Mapping__c();
        mappingObj3.CA_Product__c = listOfCA[3].id;
        mappingObj3.XMD_Product__c = xmdProductList[3].Id;
        mappingList.add(mappingObj3);        
        insert mappingList;
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        listKnowledgeObj.add(knowledgeObj1);
        
        knowledge__kav knowledgeObj2 = new knowledge__kav();
        knowledgeObj2.Title = 'test11112';
        knowledgeObj2.UrlName = 'testing12111';
        knowledgeObj2.Summary = 'testingning121111';
        knowledgeObj2.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1;2;3;4';
        knowledgeObj2.Product_Names__c = 'CA PPM';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.IsVisibleInPkb = true;
        knowledgeObj2.Introduction__c = '<a></a>';
        knowledgeObj2.Additional_Information__c = '<a></a>';
        knowledgeObj2.Answer__c = '<a></a>';
        knowledgeObj2.Background__c = '<a></a>';
        knowledgeObj2.Cause__c = '<a></a>';
        
        listKnowledgeObj.add(knowledgeObj2);
        
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112xxx';
        knowledgeObj3.UrlName = 'testing12111xxx';
        knowledgeObj3.Summary = 'testingning121111xxxx';
        knowledgeObj3.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1';
        knowledgeObj3.Product_Names__c = 'CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.IsVisibleInPkb = true;
        knowledgeObj3.Introduction__c = '<a></a>';
        knowledgeObj3.Additional_Information__c = '<a></a>';
        knowledgeObj3.Answer__c = '<a></a>';
        knowledgeObj3.Background__c = '<a></a>';
        knowledgeObj3.Cause__c = '<a></a>';
        
        listKnowledgeObj.add(knowledgeObj3);
        
        insert listKnowledgeObj;
        
        List<knowledge__kav> knowledgeObject = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[0].id];
        List<knowledge__kav> knowledgeObject1 = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[1].id];
        List<knowledge__kav> knowledgeObject2 = [Select id, URLName, articleNumber,knowledgeArticleId from knowledge__kav where id=:listKnowledgeObj[2].id];
        articleNumber = knowledgeObject[0].articleNumber;
        kavid = knowledgeObject[0].Id;
        articleKnwId = knowledgeObject[0].knowledgeArticleId;
        URLNameVal = knowledgeObject[0].URLName;
        
        componentString = listOfComp[0].Id+'; '+listOfComp[1].Id+'; '+listOfComp[2].Id;
        
        List<KCS_Association__c> kcsObj = new List<KCS_Association__c>();
        KCS_Association__c kObj = new KCS_Association__c();
        kObj.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj.Component_ID__c = listOfComp[0].id;
        kObj.Primary__c = true;
        kObj.Product_ID__c = xmdProductList[1].Id;
        kObj.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj);
        
        KCS_Association__c kObj1 = new KCS_Association__c();
        kObj1.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj1.Component_ID__c = listOfComp[1].id;
        kObj1.Primary__c = true;
        kObj1.Product_ID__c = xmdProductList[1].Id;
        kObj1.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj1);
        
        KCS_Association__c kObj2 = new KCS_Association__c();
        kObj2.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj2.Component_ID__c = listOfComp[2].id;
        kObj2.Primary__c = true;
        kObj2.Product_ID__c = xmdProductList[1].Id;
        kObj2.Release_ID__c = '';
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj2);
        
        KCS_Association__c kObj3 = new KCS_Association__c();
        kObj3.Article_Id__c = knowledgeObject[0].knowledgeArticleId;
        kObj3.Component_ID__c = '';
        kObj3.Primary__c = true;
        kObj3.Product_ID__c = xmdProductList[1].Id;
        kObj3.Release_ID__c = productReleaseObj.id;
        kObj.Product_Count__c = 1;
        kcsObj.add(kObj3);    
        
        KCS_Association__c kObj4 = new KCS_Association__c();
        kObj4.Article_Id__c = knowledgeObject1[0].knowledgeArticleId;
        kObj4.Component_ID__c = listOfComp[0].id;
        kObj4.Primary__c = true;
        kObj4.Product_ID__c = xmdProductList[1].Id;
        kObj4.Release_ID__c = '';
        kObj4.Product_Count__c = 2;
        kcsObj.add(kObj4);
        
        KCS_Association__c kObj5 = new KCS_Association__c();
        kObj5.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj5.Component_ID__c = listOfComp[1].id;
        kObj5.Primary__c = true;
        kObj5.Product_ID__c = xmdProductList[1].Id;
        kObj5.Release_ID__c = '';
        kObj5.Product_Count__c = 3;
        kcsObj.add(kObj5);
        
        KCS_Association__c kObj6 = new KCS_Association__c();
        kObj6.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj6.Component_ID__c = listOfComp[2].id;
        kObj6.Primary__c = true;
        kObj6.Product_ID__c = xmdProductList[1].Id;
        kObj6.Release_ID__c = '';
        kObj6.Product_Count__c = 3;
        kcsObj.add(kObj6);
        
        KCS_Association__c kObj7 = new KCS_Association__c();
        kObj7.Article_Id__c = knowledgeObject2[0].knowledgeArticleId;
        kObj7.Component_ID__c = '';
        kObj7.Primary__c = true;
        kObj7.Product_ID__c = xmdProductList[1].Id;
        kObj7.Release_ID__c = productReleaseObj.id;
        kObj7.Product_Count__c = 3;
        kcsObj.add(kObj7); 
        insert kcsObj;
    }
	
}