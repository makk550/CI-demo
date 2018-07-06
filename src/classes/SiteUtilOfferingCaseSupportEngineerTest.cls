@isTest(SEEALLDATA = TRUE)
public class SiteUtilOfferingCaseSupportEngineerTest {

public static testMethod void SiteUtilOfferingCaseSupportEngineerTest(){
List<Offering_Profiles_Check__c> offeringUserProfilesList = Offering_Profiles_Check__c.getAll().values();
String[] userDetails=null;
Boolean isValidProfile=false;
List<Case> CaseEmailAlertList = new List<Case>();
List<Case> caseList=new List<Case>();
    
    Test.startTest(); 
    User userRec = [select id, pmfkey__c from user where isActive=true and Profile.UserLicense.Name = 'Salesforce' and Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
     String userId= String.valueof(userRec.id);//[SELECT id from user where PMFKey__c='GOVAD01'].id;    
    SystemIdUtility.skipAccount = true;
    SystemIdUtility.skipProductTriggers = true;
    SystemIdUtility.skipAccountOnMIPSUpdate = true;     
    Account testAccount = new Account();
    testAccount.Name = 'TestAutoAssignOffering'; 
    testAccount.Enterprise_ID__c = '7777777777';
    testAccount.BillingStreet='Street';
    testAccount.BillingCountry='US';
    testAccount.BillingCity='Islandia'; 
    insert testAccount ; 
    
    Site_Association__c testSiteAssociation = new Site_Association__c();
    testSiteAssociation.Name = '0003 ADITYA TECHNOLOGIES, INCM';
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

CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
    prodCtl.name='TestProduct';
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
    
    Offering_Business_Rules__c offBusinessRules=new Offering_Business_Rules__c();
    offBusinessRules.Offering_Code__c='Offer1';  
    insert offBusinessRules;
    
    for(integer i=0;i<1;i++){
    Case testCase=new Case();
    testCase.Accountid=testAccount.Id;
    testCase.Site_Association__c=testSiteAssociation.Id;
    testCase.CA_Product_Controller__c=prodCtl.id;
    testCase.CA_Product_Component__c=prodcomp.id;
    testCase.ContactId=testContact.Id;        
    testCase.Origin='Email';
    testCase.OwnerId=userId;
    testCase.Case_Type__c='Standard';
    testCase.Subject='test subject TPC';
    testCase.Description='asdf';
    testCase.Reason='Instructions Not Clear';
    testCase.Priority='P5';
    testCase.Status='Open';
    testCase.Severity__c='1';
    testCase.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
    testCase.Internal_Priority__c='2';
    testCase.Production_Down_Status__c='Investigating';
    testCase.Alternate_email__c='aditya.gvs@gmail.com'; 
    testCase.Offering_Support_Engineer__c=userRec.PMFKey__c;//'GOVAD01';
    testCase.Offering_Code_Ref__c='Offer1';    
    testCase.Offering_Name__c=offBusinessRules.Id;
    caseList.add(testCase);
    }
    insert caseList;
     Test.stopTest();
    
    SiteUtilOfferingCaseSupportEngineer.executeOfferingCaseOwner(caseList);
    userDetails=SiteUtilOfferingCaseSupportEngineer.getActiveUser(userRec.PMFKey__c);//'GOVAD01'       
    SiteUtilOfferingCaseSupportEngineer.isValidProfileCheck(userDetails);        
      }    
}