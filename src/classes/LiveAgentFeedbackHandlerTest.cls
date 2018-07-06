@isTest
private class LiveAgentFeedbackHandlerTest {
    public static testMethod void testlinkToAnswers(){
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        
        insert lcv;
        
        List<LiveChatTranscript> chatList = new List<LiveChatTranscript>();
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.ChatKey = 'chatkey';  
        lct.LiveChatVisitorId = lcv.Id;
        chatList.add(lct);
        
        insert chatList;
        
        LiveAgent_Post_Survey_Answers__c lpsa= new LiveAgent_Post_Survey_Answers__c();
        lpsa.Live_Chat_Transcript__c = lct.Id;
        lpsa.Chat_Key__c = 'chatkey';
        insert lpsa;
        Test.startTest();
        	LiveAgentFeedbackHandler.linkToAnswers(chatList);
        Test.stopTest();
        
    }
     public static testMethod void testlinkToCases(){
        
        LiveChatVisitor lcv = new LiveChatVisitor();
        
        insert lcv;
        
        List<LiveChatTranscript> chatList = new List<LiveChatTranscript>();
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.ChatKey = 'chatkey';  
        lct.LiveChatVisitorId = lcv.Id;
        chatList.add(lct);
        
        insert chatList;
        
        LiveAgent_Post_Survey_Answers__c lpsa= new LiveAgent_Post_Survey_Answers__c();
        lpsa.Live_Chat_Transcript__c = lct.Id;
        lpsa.Chat_Key__c = 'chatkey';
        insert lpsa;
        Test.startTest();
        	LiveAgentFeedbackHandler.linkToCases(chatList);
        Test.stopTest();
        
    }
    
 static testMethod void createCase1()
    {
        TestSLOMilestonesDataSetup.createTestDataforMilestones();        
        SystemIdUtility.skipAccount = true;
         SystemIdUtility.skipAccountOnMIPSUpdate = true;
         SystemIdUtility.skipProductTriggers = true;
        
         Account testAccount = new Account() ; 
         testAccount.Name = 'Generic Support Account Test'; 
         testAccount.Enterprise_ID__c = 'AR51855';
         testAccount.BillingStreet = 'Admiralty Ctr';
         testAccount.BillingCountry = 'HK';
         testAccount.BillingCity = 'ADMIRALTY';
         insert testAccount ; 
         
         Contact testContact = new Contact();
         testContact.LastName = 'test' ;
         testContact.FirstName = 'test' ; 
         testContact.Email = 'govda@ca.com';
         testcontact.SC_CONTACT_LDAPID__c='GOVDA01';    
         testContact.Phone = '1234567';
         insert testContact ; 
         
         Site_Association__c testSite = new Site_Association__c();
         testSite.Name = 'FINANCIAL SERVICES & THE TREASURY BUREA';
         testSite.ProviSite__c = 2; 
         testSite.Enterprise_ID__c =  testAccount.Id; 
         testSite.SC_SITE_Sanctioned_Party__c = 'No';
         testSite.SC_TOPS_ID__c = '788689';
         testSite.SC_SITE_Source__c = 'Support' ; 
         testSite.State__c = 'california';
         testSite.Country_picklist__c ='US - UNITED STATES';
         insert testSite ;    
        
        CA_Product_Controller__c testCAProduct = new CA_Product_Controller__c();
        testCAProduct.Name = 'testtest' ;
        insert testCAProduct ;
        CA_Product_Controller__c testCAProduct1 = new CA_Product_Controller__c();
        testCAProduct1.Name = 'GLOBAL SERVICE CENTER' ;
        insert testCAProduct1;
        
        CA_Product_Component__c testCAComponent = new CA_Product_Component__c();
        testCAComponent.Name = 'APPLICATION PERFORMANCE MANAGEMENT CEMINT';
        testCAComponent.CA_Product_Controller__c = testCAProduct.Id ; 
        testCAComponent.Default_Component_for_this_CA_Product__c = true;
        insert testCAComponent;
        
        CA_Product_Component__c testCAComponent1 = new CA_Product_Component__c();
        testCAComponent1.Name = 'GLOBAL SERVICE CENTER SCBUG';
        testCAComponent1.Component_Code__c = 'SCBUG';
        testCAComponent1.CA_Product_Controller__c = testCAProduct1.Id ; 
        testCAComponent1.Default_Component_for_this_CA_Product__c = true;
        insert testCAComponent1;
        
        Product_Material__C productMaterial = new Product_Material__C();
        productMaterial.Name = 'DAL2TO00200';
        productMaterial.CA_Product_Controller__c = testCAProduct.Id;
        productMaterial.Source_System__c = 'TOPS';
        insert productMaterial;
        
        Product_Material__C productMaterial1 = new Product_Material__C();
        productMaterial1.Name = 'GSCSPT99000';
        productMaterial1.CA_Product_Controller__c = testCAProduct1.Id;
        productMaterial1.Source_System__c = 'TOPS';
        insert productMaterial1;
        
        Product_Release__C productRelease =  new Product_Release__C();
        productRelease.Name = 'DAL2TO00200-1-CA-DAL-SERVER FOR DB2';
        productRelease.Product_Material__c = productMaterial.Id; 
        insert productRelease;
        
        Product_Release__C productRelease1 =  new Product_Release__C();
        productRelease1.Name = 'GSCSPT99000-1-Generic Non Product';
        productRelease1.Product_Material__c = productMaterial1.Id; 
        insert productRelease1;
        
        Case caseRec = new Case();
        caseRec.Site_Association__c = testSite.Id ;
        caseRec.subject = 'Test Subject' ; 
        caseRec.Description = 'Test Description' ; 
        caseRec.ContactId = testContact.Id ; 
        caseRec.CA_Product_Controller__c = testCAProduct.Id; 
        caseRec.Origin = 'Phone Call';       
        caseRec.Troubleshooting_Stage__c = '1. Problem Identification';     
        caseRec.Status = 'Open';
        caseRec.Severity__c = '2';
         
        insert caseRec;
        LiveChatVisitor lcv = new LiveChatVisitor();
        
        insert lcv;
        //List<LiveChatTranscript> chatList = new List<LiveChatTranscript>();
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.ChatKey = 'chatkey';  
        lct.LiveChatVisitorId = lcv.Id;
        
        lct.caseid=caseRec.id;
        insert lct;
        
        lct.closure_reason__c='Closed - Assisted Issue Created (Transferred to Service Cloud Case)';
        update lct;
        
        
    }
     
    
    
}