@IsTest(seeAlldata=true)
public class TestCaseComment{
static testMethod void caseCommentTest0(){
 
  
        
      
        
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
        
         Account testAccount1 = new Account();
        testAccount1.Name = 'TestAutoAssign'; 
        testAccount1.Enterprise_ID__c = '7777777777';
        testAccount1.BillingStreet='Street';
        testAccount1.BillingCountry='US';
        testAccount1.BillingCity='Islandia'; 
        insert testAccount1 ; 
        
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        insert testContact ;
        Contacts_Site_Association__c csa = new Contacts_Site_Association__c();
        csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
        csa.SC_CSA_CONTACTS__c = testContact.Id; 
        insert csa; 
        
         
        
        Component_Release__c componentRelease = new Component_Release__c();
        componentRelease.Name = 'EARL';
        componentRelease.Component_Release__c = '6.1';
        componentRelease.Component_Code__c='Tape ';
        insert componentRelease;
        
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
       Test.startTest();   
        Case testCase=new Case();
        testCase.Accountid=testAccount.Id;
        testCase.Site_Association__c=testSiteAssociation.Id;
        testCase.CA_Product_Controller__c=prodCtl.id;
        testCase.CA_Product_Component__c=prodcomp.id;

        testCase.ContactId=testContact.Id;
        
        testCase.Origin='Email';
        
        testCase.Case_Type__c='Standard';
        testCase.Subject='test subject';
        testCase.Description='asdf';
        testCase.Reason='Instructions Not Clear';
        testCase.Priority='P5';
        //testCase.Component_Release_Only_Selection__c='EARL';

        testCase.Status='Open';
        testCase.Severity__c='4';
       // testCase.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        testCase.Internal_Priority__c='4';
        //testCase.Production_Down_Status__c='Investigating';
        testCase.Alternate_email__c='vamsi.r@gmail.com';
        //testCase.BusinessHours='IN - INDIA';
        
        testCase.Component_Release_Only_Selection__c=  componentRelease.Id;
        insert testCase;
        
        CaseComment testCaseComment=new CaseComment();
        testCaseComment.ParentID=testCase.id;
        testCaseComment.CommentBody=label.Email2Case_subject;
        insert testCaseComment;
        
        CaseComment testCaseComment1=new CaseComment();
        testCaseComment1.ParentID=testCase.id;
        testCaseComment1.CommentBody='CSO';
        
              try{      
        insert testCaseComment1;
        Delete testCaseComment1;
            }
              
              catch(Exception e){}
              
              try{      

        Delete testCase;
            }
              
              catch(Exception e){}              
        Test.stopTest();  
        
        
}
    




static testMethod void SFTPAttachmentsMethod(){
 
  
        
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
        
         Account testAccount1 = new Account();
        testAccount1.Name = 'TestAutoAssign'; 
        testAccount1.Enterprise_ID__c = '7777777777';
        testAccount1.BillingStreet='Street';
        testAccount1.BillingCountry='US';
        testAccount1.BillingCity='Islandia'; 
        insert testAccount1 ; 
        
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        insert testContact ;
        Contacts_Site_Association__c csa = new Contacts_Site_Association__c();
        csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
        csa.SC_CSA_CONTACTS__c = testContact.Id; 
        insert csa; 
        
         
        
        Component_Release__c componentRelease = new Component_Release__c();
        componentRelease.Name = 'EARL';
        componentRelease.Component_Release__c = '6.1';
        componentRelease.Component_Code__c='Tape ';
        insert componentRelease;
        
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
       Test.startTest();   
        Case testCase=new Case();
        testCase.Accountid=testAccount.Id;
        testCase.Site_Association__c=testSiteAssociation.Id;
        testCase.CA_Product_Controller__c=prodCtl.id;
        testCase.CA_Product_Component__c=prodcomp.id;

        testCase.ContactId=testContact.Id;
        
        testCase.Origin='Email';
        
        testCase.Case_Type__c='Standard';
        testCase.Subject='test subject';
        testCase.Description='asdf';
        testCase.Reason='Instructions Not Clear';
        testCase.Priority='P5';
        //testCase.Component_Release_Only_Selection__c='EARL';

        testCase.Status='Open';
        testCase.Severity__c='4';
       // testCase.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        testCase.Internal_Priority__c='4';
        //testCase.Production_Down_Status__c='Investigating';
        testCase.Alternate_email__c='vamsi.r@gmail.com';
        //testCase.BusinessHours='IN - INDIA';
        
        testCase.Component_Release_Only_Selection__c=  componentRelease.Id;
        insert testCase;
        Test.stopTest();  
        SFTP_File_Attachments__c testSFTP=new SFTP_File_Attachments__c ();
        testSFTP.Case__c=testCase.id;
        testSFTP.File_Name__c='testFile';
        insert testSFTP;
              try{
                  update testSFTP;
              }catch(Exception e){}
        
    	LIST<Case> caseList = new List<Case>();
    caseList.add(testCase);
      UtilityFalgs.sendNotificationToAssgnUser(caseList);
        
        
        
}


    
}