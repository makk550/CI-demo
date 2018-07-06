@isTest(SeeAllData=True)
public class AutomicVersion_Test {
    static testMethod void testAutomicVersion(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'TestAutoAssign'; 
        acc.Enterprise_ID__c = '7777777777';
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia'; 
        insert acc ;
        Contact contact1 = new Contact();
        contact1.FirstName ='testAuto';
        contact1.LastName ='contact';
        contact1.email='shata07@ca.com';
        insert contact1 ;
        Site_Association__c testSiteAssociation = new Site_Association__c();
        testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
        testSiteAssociation.SAP_Site_ID__c = '280125';
        testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
        testSiteAssociation.Enterprise_ID__c = acc.Id;
        testSiteAssociation.SC_TOPS_ID__c = '1299636';
        testSiteAssociation.Country_picklist__c= 'US - UNITED STATES';
        testSiteAssociation.State__c='New York';
        insert testSiteAssociation ;
        Component_Release__c CR=new Component_Release__c();
        CR.Name='Test Component'; CR.Component_Code__c='AAUTWI'; CR.Component_Text__c='AUTOMIC WEB INTERFACE';  CR.Component_Release__c='11.1';
        insert CR;
        CA_Product_Controller__c CAC = new CA_Product_Controller__c();
        CAC.name='Test';
        insert CAC;
        
        CA_Product_Component__c CPC = new CA_Product_Component__c();
        CPC.Name='Test';
        CPC.CA_Product_Component_Ext_ID__c='Test';
        CPC.Default_Component_for_CA_Product__c=True;
        CPC.CA_Product_Controller__c=CAC.id;
        CPC.CA_Product_Text__c='Test';
        CPC.Component_Code__c='Test';
        CPC.Component_Text__c='Test';
        CPC.Default_Component_for_this_CA_Product__c=True;
        CPC.SFDC_Support_System__c=True;
        insert CPC;
        
        
        Case problem=new Case();
       // problem.recordtypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
        problem.Accountid=acc.Id;
        problem.Site_Association__c=testSiteAssociation.Id;
        problem.CA_Product_Controller__c=CAC.id;
        problem.CA_Product_Component__c=CPC.id;
        problem.ContactId=contact1.Id;
        
        problem.Origin='Email';
        problem.Case_Type__c='Standard';
        problem.Subject='test subject';
        problem.Description='asdf';
        problem.Reason='Instructions Not Clear';
        problem.Priority='P5';
        //testCase.Component_Release_Only_Selection__c='EARL';
        
        problem.Status='Open';
        problem.Severity__c='1';
        problem.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        //testCase.Internal_Priority__c='2';
        problem.Production_Down_Status__c='Investigating';
        problem.Alternate_email__c='vamsi.r@gmail.com';
        //testCase.BusinessHours='IN - INDIA';
        
        problem.Component_Release_Only_Selection__c=CR.Id;
        insert problem;
        ApexPages.currentPage().getParameters().put('caseId',problem.Id);
        List<Automic_R_D_Component_Version__c> ACV=new List<Automic_R_D_Component_Version__c>();
        ACV.add(new Automic_R_D_Component_Version__c(name='Test 0',Problem__c=problem.id));
        ACV.add(new Automic_R_D_Component_Version__c(name='Test 1',Problem__c=problem.id));
        insert ACV;
        
        ApexPages.StandardController stdCase = new ApexPages.StandardController(ACV[0]);
        AutomicVersion bpc=new AutomicVersion(stdCase);
        bpc.selectedOptions.add(new SelectOption(CR.id,'Test'));
        bpc.save();
        Test.stopTest();
    }
    static testMethod void testMultiSelect(){
        Test.startTest();
        AutomicVersion bmc=new AutomicVersion();
        bmc.leftOptions=new List<SelectOption>();
        bmc.leftOptions.add(new SelectOption('Test 1','Test 2'));
        bmc.rightOptions=new List<SelectOption>();
        bmc.rightOptions.add(new SelectOption('Test 3','Test 4'));
        bmc.leftOptionsHidden='Test 1&Test 2';
        bmc.rightOptionsHidden='Test 3&Test 4';
        Test.stopTest();
    }
}