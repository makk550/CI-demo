@isTest
private class KBCaseToCaseArticle_UnitTest {

	@isTest static void testNewArticleFromCase() {
		system.runAs(createDataUser()){
            createTestData();
        }
        system.runAs(createDataUser()){
			Test.startTest();
	        createArticles();
	        Case c = [SELECT Id FROM Case LIMIT 1];
	        List<Knowledge__kav> onlineArticles = getOnlineArticles();
	        KB_Article__c kba = new KB_Article__c();
	        kba.KB_Article_No__c = 'TEST001';
	        insert kba;
	        KB_Article_Case__c kbc = new KB_Article_Case__c();
	        kbc.KB_Article__c = kba.Id;
	        kbc.Case__c =c.Id;
	        insert kbc;
	        KBCaseToCaseArticle sch = new KBCaseToCaseArticle();
		    Database.executeBatch(sch, 1); // integer is the size of the batch, tests can only execute one batch

	        Test.stopTest();
	    }
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
        knowledgeObj1.CADocid__c = 'TEST001';
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
        knowledgeObj2.CADocid__c = 'TEST001';
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
        knowledgeObj3.CADocid__c = 'TEST001';
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

}