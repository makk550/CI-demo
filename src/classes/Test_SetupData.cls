/*
Created By: Tarun Sharma
Created On: 10/13/2015
Purpose: Test Class for setup data
Modified By:
*/
@isTest
public class Test_SetupData{
   
   public static Id caseNumberId;
   public static String siteIdNumber;
   public static String projectIdNumber; 
   public static String caProduct;
   public static String caSiteId;
   public static Id siteId; 
   public static String productAreaId;
   public static List<CA_Product_Component__c> compId;
   public static List<Product_area__c> productAreaObject;
    
   public static testMethod void createTestData(){
       SystemIdUtility.skipAccount = true;
       SystemIdUtility.skipProductTriggers = true;
       SystemIdUtility.skipAccountOnMIPSUpdate = true;    
       FutureMethod_Assign_support_Generic.isFutureRunning = true;
       
       TestSLOMilestonesDataSetup.createTestDataforMilestones();
       List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
       RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
       recordTypeObj.Name = 'SMB';
       recordTypeObj.SObject_Name__c = 'Account';
       recordTypeObj.RecordType_Id__c = '01230000001L55j';
       listOfRecordType.add(recordTypeObj);
       
       RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
       recordTypeObj1.Name = 'Territory Covered Account';
       recordTypeObj1.SObject_Name__c = 'Account';
       recordTypeObj1.RecordType_Id__c = '01230000001L55o';
       listOfRecordType.add(recordTypeObj1);
       
       RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
       recordTypeObj2.Name = 'Account Team Covered Account';
       recordTypeObj2.SObject_Name__c = 'Account';
       recordTypeObj2.RecordType_Id__c = '01230000001L55e';
       listOfRecordType.add(recordTypeObj2);
       
       RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
       recordTypeObj3.Name = 'Commercial Account';
       recordTypeObj3.SObject_Name__c = 'Account';
       recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
       listOfRecordType.add(recordTypeObj3);
       
       RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
       recordTypeObj4.Name = 'CA Enterprise Account';
       recordTypeObj4.SObject_Name__c = 'Account';
       recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
       listOfRecordType.add(recordTypeObj4);
       
       RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
       recordTypeObj5.Name = 'Support Account';
       recordTypeObj5.SObject_Name__c = 'Account';
       recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
       listOfRecordType.add(recordTypeObj5);
       
       RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
       recordTypeObj6.Name = 'Acquisition';
       recordTypeObj6.SObject_Name__c = 'Account';
       recordTypeObj6.RecordType_Id__c = '012300000013vtw';
       listOfRecordType.add(recordTypeObj6);
       
       RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
       recordTypeObj7.Name = 'Approved Quote';
       recordTypeObj7.SObject_Name__c = 'Account';
       recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
       listOfRecordType.add(recordTypeObj7);
       
       RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
       recordTypeObj8.Name = 'CA Global Lead';
       recordTypeObj8.SObject_Name__c = 'Account';
       recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
       listOfRecordType.add(recordTypeObj8);
       
       RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
       recordTypeObj9.Name = 'CA Indirect Lead';
       recordTypeObj9.SObject_Name__c = 'Account';
       recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
       listOfRecordType.add(recordTypeObj9);
       
       RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
       recordTypeObj10.Name = 'Deal Registration';
       recordTypeObj10.SObject_Name__c = 'Account';
       recordTypeObj10.RecordType_Id__c = '01230000000yspg';
       listOfRecordType.add(recordTypeObj10);
       
       RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
       recordTypeObj11.Name = 'Reseller/Distributor Account';
       recordTypeObj11.SObject_Name__c = 'Account';
       recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
       listOfRecordType.add(recordTypeObj11);
       
       insert listOfRecordType;
       
       Account accountObj = new Account();
       accountObj.Name = 'Generic Support Account'; 
       accountObj.Enterprise_ID__c = '7777777777';
       accountObj.BillingStreet='Street';
       accountObj.BillingCountry='US';
       accountObj.BillingCity='Islandia'; 
       insert accountObj;
       
       Account accountObj1 = new Account();
       accountObj1.Name = 'Support Ops'; 
       accountObj1.Enterprise_ID__c = '7777777777';
       accountObj1.BillingStreet='Street';
       accountObj1.BillingCountry='US';
       accountObj1.BillingCity='Islandia'; 
       insert accountObj1;
       
       List<Site_Association__c> listOfSiteAssociationObj = new List<Site_Association__c>();
       Site_Association__c siteAssociationObj = new Site_Association__c();
       siteAssociationObj.Name = 'IBM';
       siteAssociationObj.SAP_Site_ID__c = '280125';
       siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
       siteAssociationObj.Enterprise_ID__c = accountObj.Id;
       siteAssociationObj.SC_TOPS_ID__c = '1299636';
       siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
       siteAssociationObj.State__c='New York';
       siteAssociationObj.ProviSite__c = 1;
       listOfSiteAssociationObj.add(siteAssociationObj);
       
       Site_Association__c siteAssociationObj1 = new Site_Association__c();
       siteAssociationObj1.Name = 'CA TECHNOLOGIES';
       siteAssociationObj1.SAP_Site_ID__c = '105246';
       siteAssociationObj1.SC_SITE_Sanctioned_Party__c = 'NO';
       siteAssociationObj1.Enterprise_ID__c = accountObj.Id;
       siteAssociationObj1.SC_TOPS_ID__c = '105246';
       siteAssociationObj1.Country_picklist__c= 'US - UNITED STATES';
       siteAssociationObj1.State__c='New York';
       //siteAssociationObj1.ProviSite__c = ;
       listOfSiteAssociationObj.add(siteAssociationObj1);
       insert listOfSiteAssociationObj;
       siteIdNumber = listOfSiteAssociationObj[1].SC_TOPS_ID__c;
       List<Site_Association__c> SiteAssociationlist = [Select Id from Site_Association__c  where SC_TOPS_ID__c = '105246' limit 1];
       if(SiteAssociationlist<>null && SiteAssociationlist.size()>0)
       siteId = SiteAssociationlist[0].Id;
       
       List<Project_Site_Association__c> listOfProjectSiteAssociationObj = new List<Project_Site_Association__c>();
       Project_Site_Association__c projectSiteAssociationObj = new project_Site_Association__c();
       projectSiteAssociationObj.Name = 'TestProject1';
       projectSiteAssociationObj.Description__c = 'TestDesc1';
       projectSiteAssociationObj.Site_Association__c = siteId;
       projectSiteAssociationObj.Project_ID__c = '0';
       listOfProjectSiteAssociationObj.add(projectSiteAssociationObj);
       
      /* Project_Site_Association__c projectSiteAssociationObj1 = new Project_Site_Association__c();
       projectSiteAssociationObj1.Name = 'TestProject2';
       projectSiteAssociationObj1.Description__c = 'TestDesc2';
       projectSiteAssociationObj1.Site_Association__c ='201347';
       projectSiteAssociationObj1.Project_ID__c = '0';
       listOfProjectSiteAssociationObj.add(projectSiteAssociationObj1); */
       insert listOfProjectSiteAssociationObj;
       List<Project_Site_Association__c> listOfProjectSite = [Select Id, Project_ID__c from Project_Site_Association__c where id=:listOfProjectSiteAssociationObj[0].id limit 1];
       if(listOfProjectSite<>null && listOfProjectSite.size()>0)
 	   projectIdNumber = listOfProjectSite[0].Project_ID__c;  

       Contact contactObj = new Contact();
       contactObj.FirstName ='testAuto';
       contactObj.LastName ='contact';
       contactObj.Email ='shata07@ca.com';
       insert contactObj;
       
       Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
       csaObj.SC_CSA_SITE__c = listOfSiteAssociationObj[1].Id ;
       csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
       insert csaObj; 
       
       List<CA_Product_Controller__c> listOfCA = new List<CA_Product_Controller__c>();
       CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
       caProductObj.name='2E';
       listOfCA.add(caProductObj);
       
       CA_Product_Controller__c caProductObj1 = new CA_Product_Controller__c();
       caProductObj1.name='WORKLOAD AUTOMATION AE';
       listOfCA.add(caProductObj1);
       
       CA_Product_Controller__c caProductObj2 = new CA_Product_Controller__c();
       caProductObj2.name='GLOBAL SERVICE CENTER';
       listOfCA.add(caProductObj2);
       insert listOfCA;
       
       List<CA_Product_Component__c> listOfComp = new List<CA_Product_Component__c>();
       CA_Product_Component__c prodcomp = new CA_Product_Component__c();
       prodcomp.Name='2E';
       prodcomp.CA_Product_Component_Ext_ID__c='Test';
       prodcomp.Default_Component_for_CA_Product__c=True;
       prodcomp.CA_Product_Controller__c=listOfCA[0].id;
       prodcomp.CA_Product_Text__c='Test';
       prodcomp.Component_Code__c='Test';
       prodcomp.Component_Text__c='Test';
       prodcomp.Default_Component_for_this_CA_Product__c=True;
       prodcomp.SFDC_Support_System__c=True;
       listOfComp.add(prodcomp);
       
       CA_Product_Component__c prodcomp1 = new CA_Product_Component__c();
       prodcomp1.Name='WORKLOAD AUTOMATION AE ATSYS';
       prodcomp1.CA_Product_Component_Ext_ID__c='Test';
       prodcomp1.Default_Component_for_CA_Product__c=True;
       prodcomp1.CA_Product_Controller__c=listOfCA[1].id;
       prodcomp1.CA_Product_Text__c='Test';
       prodcomp1.Component_Code__c='ATSYS';
       prodcomp1.Component_Text__c='Test';
       prodcomp1.Default_Component_for_this_CA_Product__c=True;
       prodcomp1.SFDC_Support_System__c=True;
       prodcomp1.component_expiration_date__c = system.today().addDays(2);
       listOfComp.add(prodcomp1);
       
       CA_Product_Component__c prodcomp2 = new CA_Product_Component__c();
       prodcomp2.Name='GLOBAL SERVICE CENTER SCBUG';
       prodcomp2.CA_Product_Component_Ext_ID__c='Test';
       prodcomp2.Default_Component_for_CA_Product__c=True;
       prodcomp2.CA_Product_Controller__c=listOfCA[2].id;
       prodcomp2.CA_Product_Text__c='Test';
       prodcomp2.Component_Code__c='SCBUG';
       prodcomp2.Component_Text__c='Test';
       prodcomp2.Default_Component_for_this_CA_Product__c=True;
       prodcomp2.SFDC_Support_System__c=True;
       prodcomp2.component_expiration_date__c = system.today().addDays(2);
       listOfComp.add(prodcomp2);
       insert listOfComp;
       
       compId = listOfComp;   
       
       List<Product_area__c> listOfPA = new List<Product_area__c>();
       Product_area__c productAreaObj = new product_area__c();
       productAreaObj.Name = 'test';
       productAreaObj.CA_Product__c = listOfCA[0].Id;
       productAreaObj.Default_Group_Component__c = listOfComp[0].Id;
       listOfPA.add(productAreaObj);
       
       Product_area__c productAreaObj1 = new product_area__c();
       productAreaObj1.Name = 'testing';
       productAreaObj1.CA_Product__c = listOfCA[1].Id;
       productAreaObj1.Default_Group_Component__c = listOfComp[1].Id;
       listOfPA.add(productAreaObj1);
       
       Product_area__c productAreaObj2 = new product_area__c();
       productAreaObj2.Name = 'testing';
       productAreaObj2.CA_Product__c = listOfCA[1].Id;
       listOfPA.add(productAreaObj2); 
       insert listOfPA;
       
       productAreaObject = listOfPA;
       Product_Area_Components__c pacObj = new Product_Area_Components__c();
       pacObj.CA_Product_Component__c = listOfComp[0].Id;
       pacObj.Product_Area__c = listOfPA[0].Id;
       insert pacObj;
       
       id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
       
       Component_Release__c componentReleaseObj = new Component_Release__c();
       componentReleaseObj.Name = 'EARL';
       componentReleaseObj.Component_Release__c = '6.1';
       componentReleaseObj.Component_Code__c='Tape ';
       insert componentReleaseObj;
       
       caSiteId =listOfSiteAssociationObj[0].id;
       caProduct = listOfCA[0].id;
       
       /*List<Offering_Business_Rules__c> listOfOfferings = new List<Offering_Business_Rules__c>();
       
       Offering_Business_Rules__c obj1 = new Offering_Business_Rules__c();
       obj1.Name = 'Custom Poste Italiane';
       obj1.Offering_Code__c = 'CPI';
       obj1.Precedence__c = '70';
       listOfOfferings.add(obj1);
       
       Offering_Business_Rules__c obj2 = new Offering_Business_Rules__c();
       obj2.Name = 'Guaranteed Restoration Service';
       obj2.Offering_Code__c = 'GUAR';
       obj2.Precedence__c = '2';
       listOfOfferings.add(obj2);
       
       Offering_Business_Rules__c obj3 = new Offering_Business_Rules__c();
       obj3.Name = 'Select Support Experience';
       obj3.Offering_Code__c = 'SSE';
       obj3.Precedence__c = '98';
       listOfOfferings.add(obj3);
       
       Offering_Business_Rules__c obj4 = new Offering_Business_Rules__c();
       obj4.Name = 'Internal Fast Track Support';
       obj4.Offering_Code__c = 'IFTK';
       obj4.Precedence__c = '51';
       listOfOfferings.add(obj4);
       
       Offering_Business_Rules__c obj5 = new Offering_Business_Rules__c();
       obj5.Name = 'CSA';
       obj5.Offering_Code__c = 'CSA';
       obj5.Precedence__c = '99';
       listOfOfferings.add(obj5);
       
       Offering_Business_Rules__c obj6 = new Offering_Business_Rules__c();
       obj6.Name = 'Enhanced Support Services Silver';
       obj6.Offering_Code__c = 'ESS SLVR';
       obj6.Precedence__c = '25';
       listOfOfferings.add(obj6);
       
       Offering_Business_Rules__c obj7 = new Offering_Business_Rules__c();
       obj7.Name = 'Enhanced Support Services Gold';
       obj7.Offering_Code__c = 'ESS GOLD';
       obj7.Precedence__c = '1';
       listOfOfferings.add(obj7);
       
       Offering_Business_Rules__c obj8 = new Offering_Business_Rules__c();
       obj8.Name = 'Enhanced Support Services Platinum';
       obj8.Offering_Code__c = 'ESS PLAT';
       obj8.Precedence__c = '15';
       listOfOfferings.add(obj8);
       
       Offering_Business_Rules__c obj9 = new Offering_Business_Rules__c();
       obj9.Name = 'Upgrade Support Services';
       obj9.Offering_Code__c = 'USS';
       obj9.Precedence__c = '40';
       listOfOfferings.add(obj9);
       
       Offering_Business_Rules__c obj10 = new Offering_Business_Rules__c();
       obj10.Name = 'Fast Track Support';
       obj10.Offering_Code__c = 'FTK';
       obj10.Precedence__c = '50';
       listOfOfferings.add(obj10);
       
       Offering_Business_Rules__c obj11 = new Offering_Business_Rules__c();
       obj11.Name = 'CSA SC1';
       obj11.Offering_Code__c = 'CSA SC1';
       obj11.Precedence__c = '32';
       listOfOfferings.add(obj11);
       
       Offering_Business_Rules__c obj12 = new Offering_Business_Rules__c();
       obj12.Name = 'CSA SC2';
       obj12.Offering_Code__c = 'CSA SC2';
       obj12.Precedence__c = '31';
       listOfOfferings.add(obj12);
       
       Offering_Business_Rules__c obj13 = new Offering_Business_Rules__c();
       obj13.Name = 'Test OBR';
       obj13.Offering_Code__c = 'TOBR';
       obj13.Precedence__c = '1';
       listOfOfferings.add(obj13);
       insert listOfOfferings;*/
       
       Case caseObject =new Case();
       caseObject.Accountid=accountObj.Id;
       caseObject.Site_Association__c=listOfSiteAssociationObj[0].Id;
       caseObject.CA_Product_Controller__c=listOfCA[0].id;
       caseObject.CA_Product_Component__c=listOfComp[0].id;
       caseObject.ContactId=contactObj.Id;        
       caseObject.Origin='Email';
       caseObject.OwnerId=queueGroupId;
       caseObject.Case_Type__c='Standard';
       caseObject.Subject='test subject TPC';
       caseObject.Description='asdf';
       caseObject.Reason='Instructions Not Clear';
       caseObject.Priority='3';        
       caseObject.Status='Open';
       caseObject.Severity__c='1';
       caseObject.Sev_1_Impact_c__c='Production down';
       caseObject.Internal_Priority__c='2';
       caseObject.Production_Down_Status__c='Investigating';
       caseObject.Alternate_email__c='vamsi.r@gmail.com';        
       caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
       caseObject.Product_Area__c = listOfPA[0].Id;
       caseObject.Alternate_OS__c = 'PS';
       caseObject.Next_Action_Due_Date__c = system.now().addDays(2);
       caseObject.Next_Action__c = 'Pending Customer';
       insert caseObject;
       caseNumberId = caseObject.id;
       
       
       Defect__c defectObject = new Defect__c();
       defectObject.Defect_URL__c = 'https://www.abc.com';
       defectObject.Defect_Object_ID__c = 'https://www.abc.com';
       defectObject.Defect_Submitted_By__c = 'tarun';
       defectObject.Defect_Owner__c = 'tarun';
       defectObject.Name = 'DE1111';
       //defectObject.OwnerId = queueGroupId;
       defectObject.Priority__c = '1';
       defectObject.Targeted_Release_Number__c = '8';
       defectObject.Target_Release_date__c = system.today();
       defectObject.Type__c = 'Defect';
       defectObject.Subject__c = 'test';
       defectObject.Status__c = 'New';
       defectObject.Severity__c = '1';
       defectObject.Resolution__c = 'fixed';
       defectObject.R_D_System__c = 'Rally';
       defectObject.Description__c = 'test testclass';
       insert defectObject;
       
       Defect_Case_Association__c defectAssociationObject = new Defect_Case_Association__c();
       defectAssociationObject.Case__c = caseObject.Id;
       defectAssociationObject.Defect__c = defectObject.Id;
       insert defectAssociationObject;
       
       apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
            
   }   
    
    public static testMethod void createTestProductData(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = true;
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        Account accountObj = new Account();
        accountObj.Name = 'Generic Support Account'; 
        accountObj.Enterprise_ID__c = '7777777777';
        accountObj.BillingStreet='Street';
        accountObj.BillingCountry='US';
        accountObj.BillingCity='Islandia'; 
        insert accountObj;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = accountObj.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName ='testAuto';
        contactObj.LastName ='contact';
        contactObj.Email = 'shata07@ca.com';
        insert contactObj;
        
        Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
        csaObj.SC_CSA_SITE__c = siteAssociationObj.Id ;
        csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
        insert csaObj; 
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='Alpha';
        insert caProductObj;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='Alpha';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=caProductObj.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
      
        Component_Release__c componentReleaseObj = new Component_Release__c();
        componentReleaseObj.Name = 'EARL';
        componentReleaseObj.Component_Release__c = '6.1';
        componentReleaseObj.Component_Code__c='Tape ';
        insert componentReleaseObj;
        
        Case caseObject =new Case();
        caseObject.Accountid=accountObj.Id;
        caseObject.Site_Association__c=siteAssociationObj.Id;
        caseObject.CA_Product_Controller__c=caProductObj.id;
        caseObject.CA_Product_Component__c=prodcomp.id;
        caseObject.ContactId=contactObj.Id;        
        caseObject.Origin='Email';
        caseObject.OwnerId=queueGroupId;
        caseObject.Case_Type__c='Standard';
        caseObject.Subject='test subject TPC';
        caseObject.Description='asdf';
        caseObject.Reason='Instructions Not Clear';
        caseObject.Priority='3';        
        caseObject.Status='Open';
        caseObject.Severity__c='1';
        caseObject.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        caseObject.Internal_Priority__c='2';
        caseObject.Production_Down_Status__c='Investigating';
        caseObject.Alternate_email__c='vamsi.r@gmail.com';        
        caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
        insert caseObject;
        
        Defect__c defectObject = new Defect__c();
        defectObject.Defect_URL__c = 'https://www.abc.com';
        defectObject.Defect_Object_ID__c = 'https://www.abc.com';
        defectObject.Defect_Submitted_By__c = 'tarun';
        defectObject.Defect_Owner__c = 'tarun';
        defectObject.Name = 'DE1111';
        //defectObject.OwnerId = queueGroupId;
        defectObject.Priority__c = '1';
        defectObject.Targeted_Release_Number__c = '8';
        defectObject.Target_Release_date__c = system.today();
        defectObject.Type__c = 'Defect';
        defectObject.Subject__c = 'test';
        defectObject.Status__c = 'New';
        defectObject.Severity__c = '1';
        defectObject.Resolution__c = 'fixed';
        defectObject.R_D_System__c = 'Rally';
        defectObject.Description__c = 'test testclass';
        insert defectObject;
        
        Defect_Case_Association__c defectAssociationObject = new Defect_Case_Association__c();
        defectAssociationObject.Case__c = caseObject.Id;
        defectAssociationObject.Defect__c = defectObject.Id;
        insert defectAssociationObject;
        
        apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
            
   }   
    /*    
    public static testMethod case createTestSuccessData(){
        SystemIdUtility.skipAccount = true;
         SystemIdUtility.skipAccountOnMIPSUpdate = true;
         SystemIdUtility.skipProductTriggers = true;
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        Account accountObj = new Account();
        accountObj.Name = 'Generic Support Account'; 
        accountObj.Enterprise_ID__c = '7777777777';
        accountObj.BillingStreet='Street';
        accountObj.BillingCountry='US';
        accountObj.BillingCity='Islandia'; 
        insert accountObj;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = accountObj.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName ='testAuto';
        contactObj.LastName ='contact';
        insert contactObj;
        
        Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
        csaObj.SC_CSA_SITE__c = siteAssociationObj.Id ;
        csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
        insert csaObj; 
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='APPLICATION PERFORMANCE MANAGEMENT';
        insert caProductObj;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='APPLICATION PERFORMANCE MANAGEMENT';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=caProductObj.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        
        Component_Release__c componentReleaseObj = new Component_Release__c();
        componentReleaseObj.Name = 'EARL';
        componentReleaseObj.Component_Release__c = '6.1';
        componentReleaseObj.Component_Code__c='Tape ';
        insert componentReleaseObj;
        
        Case caseObject =new Case();
        caseObject.Accountid=accountObj.Id;
        caseObject.Site_Association__c=siteAssociationObj.Id;
        caseObject.CA_Product_Controller__c=caProductObj.id;
        caseObject.CA_Product_Component__c=prodcomp.id;
        caseObject.ContactId=contactObj.Id;        
        caseObject.Origin='Email';
        caseObject.OwnerId=queueGroupId;
        caseObject.Case_Type__c='Standard';
        caseObject.Subject='test subject TPC';
        caseObject.Description='asdf';
        caseObject.Reason='Instructions Not Clear';
        caseObject.Priority='3';        
        caseObject.Status='Open';
        caseObject.Severity__c='1';
        caseObject.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        caseObject.Internal_Priority__c='2';
        caseObject.Production_Down_Status__c='Investigating';
        caseObject.Alternate_email__c='vamsi.r@gmail.com';        
        caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
        insert caseObject;
                
        Defect__c defectObject = new Defect__c();
        defectObject.Defect_URL__c = 'https://www.abc.com';
        defectObject.Defect_Object_ID__c = 'https://www.abc.com';
        defectObject.Defect_Submitted_By__c = 'tarun';
        defectObject.Defect_Owner__c = 'tarun';
        defectObject.Name = 'DE1111';
        //defectObject.OwnerId = queueGroupId;
        defectObject.Priority__c = '1';
        defectObject.Targeted_Release_Number__c = '8';
        defectObject.Target_Release_date__c = system.today();
        defectObject.Type__c = 'Defect';
        defectObject.Subject__c = 'test';
        defectObject.Status__c = 'New';
        defectObject.Severity__c = '1';
        defectObject.Resolution__c = 'fixed';
        defectObject.R_D_System__c = 'Rally';
        defectObject.Description__c = 'test testclass';
        insert defectObject;
        ApexPages.StandardController sc = new ApexPages.standardController(defectObject);
        Defect_Case_Association__c defectAssociationObject = new Defect_Case_Association__c();
        defectAssociationObject.Case__c = caseObject.Id;
        defectAssociationObject.Defect__c = defectObject.Id;
        insert defectAssociationObject;
        
        apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
        return caseObject ; 
    }
    
    public static testMethod case createTestDMSuccessData(){
        SystemIdUtility.skipAccount = true;
         SystemIdUtility.skipAccountOnMIPSUpdate = true;
         SystemIdUtility.skipProductTriggers = true;
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        Account accountObj = new Account();
        accountObj.Name = 'Generic Support Account'; 
        accountObj.Enterprise_ID__c = '7777777777';
        accountObj.BillingStreet='Street';
        accountObj.BillingCountry='US';
        accountObj.BillingCity='Islandia'; 
        insert accountObj;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = accountObj.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName ='testAuto';
        contactObj.LastName ='contact';
        insert contactObj;
        
        Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
        csaObj.SC_CSA_SITE__c = siteAssociationObj.Id ;
        csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
        insert csaObj; 
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='IDENTITY MGMT AND GOVRNCE';
        insert caProductObj;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='IDENTITY MGMT AND GOVRNCE SIGMA';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=caProductObj.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        
        Component_Release__c componentReleaseObj = new Component_Release__c();
        componentReleaseObj.Name = 'EARL';
        componentReleaseObj.Component_Release__c = '6.1';
        componentReleaseObj.Component_Code__c='Tape ';
        insert componentReleaseObj;
        
        Case caseObject =new Case();
        caseObject.Accountid=accountObj.Id;
        caseObject.Site_Association__c=siteAssociationObj.Id;
        caseObject.CA_Product_Controller__c=caProductObj.id;
        caseObject.CA_Product_Component__c=prodcomp.id;
        caseObject.ContactId=contactObj.Id;        
        caseObject.Origin='Email';
        caseObject.OwnerId=queueGroupId;
        caseObject.Case_Type__c='Standard';
        caseObject.Subject='test subject TPC';
        caseObject.Description='asdf';
        caseObject.Reason='Instructions Not Clear';
        caseObject.Priority='3';        
        caseObject.Status='Open';
        caseObject.Severity__c='1';
        caseObject.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        caseObject.Internal_Priority__c='2';
        caseObject.Production_Down_Status__c='Investigating';
        caseObject.Alternate_email__c='vamsi.r@gmail.com';        
        caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
        insert caseObject;
        
        DefectMigration__c dmObj = new DefectMigration__c();
        dmObj.CaseId__c = caseObject.id;
        dmObj.Defect_Object_Id__c = 'https://rally1.rallydev.com:443/slm/webservice/1.43/defect/12245610760.js';
        dmObj.Migrated__c = false;
        insert dmObj;
        
        Defect__c defectObject = new Defect__c();
        defectObject.Defect_URL__c = 'https://www.abc.com';
        defectObject.Defect_Object_ID__c = 'https://www.abc.com';
        defectObject.Defect_Submitted_By__c = 'tarun';
        defectObject.Defect_Owner__c = 'tarun';
        defectObject.Name = 'DE1111';
        //defectObject.OwnerId = queueGroupId;
        defectObject.Priority__c = '1';
        defectObject.Targeted_Release_Number__c = '8';
        defectObject.Target_Release_date__c = system.today();
        defectObject.Type__c = 'Defect';
        defectObject.Subject__c = 'test';
        defectObject.Status__c = 'New';
        defectObject.Severity__c = '1';
        defectObject.Resolution__c = 'fixed';
        defectObject.R_D_System__c = 'Rally';
        defectObject.Description__c = 'test testclass';
        insert defectObject;
        ApexPages.StandardController sc = new ApexPages.standardController(defectObject);
        Defect_Case_Association__c defectAssociationObject = new Defect_Case_Association__c();
        defectAssociationObject.Case__c = caseObject.Id;
        defectAssociationObject.Defect__c = defectObject.Id;
        insert defectAssociationObject;
        
        apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
        return caseObject ; 
    }
    public static testMethod void createTestNoDefectData(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        Account accountObj = new Account();
        accountObj.Name = 'Generic Support Account'; 
        accountObj.Enterprise_ID__c = '7777777777';
        accountObj.BillingStreet='Street';
        accountObj.BillingCountry='US';
        accountObj.BillingCity='Islandia'; 
        insert accountObj;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = accountObj.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName ='testAuto';
        contactObj.LastName ='contact';
        insert contactObj;
        
        Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
        csaObj.SC_CSA_SITE__c = siteAssociationObj.Id ;
        csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
        insert csaObj; 
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='APPLICATION PERFORMANCE MANAGEMENT';
        insert caProductObj;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='APPLICATION PERFORMANCE MANAGEMENT';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=caProductObj.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        
        Component_Release__c componentReleaseObj = new Component_Release__c();
        componentReleaseObj.Name = 'EARL';
        componentReleaseObj.Component_Release__c = '6.1';
        componentReleaseObj.Component_Code__c='Tape ';
        insert componentReleaseObj;
        
        Case caseObject =new Case();
        caseObject.Accountid=accountObj.Id;
        caseObject.Site_Association__c=siteAssociationObj.Id;
        caseObject.CA_Product_Controller__c=caProductObj.id;
        caseObject.CA_Product_Component__c=prodcomp.id;
        caseObject.ContactId=contactObj.Id;        
        caseObject.Origin='Email';
        caseObject.OwnerId=queueGroupId;
        caseObject.Case_Type__c='Standard';
        caseObject.Subject='test subject TPC';
        caseObject.Description='asdf';
        caseObject.Reason='Instructions Not Clear';
        caseObject.Priority='3';        
        caseObject.Status='Open';
        caseObject.Severity__c='1';
        caseObject.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        caseObject.Internal_Priority__c='2';
        caseObject.Production_Down_Status__c='Investigating';
        caseObject.Alternate_email__c='vamsi.r@gmail.com';        
        caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
        insert caseObject;
        
        Defect__c defectObject = new Defect__c();
        defectObject.Defect_URL__c = 'https://www.abc.com';
        defectObject.Defect_Object_ID__c = 'https://www.abc.com';
        defectObject.Defect_Submitted_By__c = 'tarun';
        defectObject.Defect_Owner__c = 'tarun';
        defectObject.Name = 'DE12345';
        //defectObject.OwnerId = queueGroupId;
        defectObject.Priority__c = '1';
        defectObject.Targeted_Release_Number__c = '8';
        defectObject.Target_Release_date__c = system.today();
        defectObject.Type__c = 'Defect';
        defectObject.Subject__c = 'test';
        defectObject.Status__c = 'New';
        defectObject.Severity__c = '1';
        defectObject.Resolution__c = 'fixed';
        defectObject.R_D_System__c = 'Rally';
        defectObject.Description__c = 'test testclass';
        insert defectObject;
        
        Defect_Case_Association__c defectAssociationObject = new Defect_Case_Association__c();
        defectAssociationObject.Case__c = caseObject.Id;
        defectAssociationObject.Defect__c = defectObject.Id;
        insert defectAssociationObject;
        
        apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
    }
    
    public static testMethod void createTestNoDefectAssociateData(){
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        Account accountObj = new Account();
        accountObj.Name = 'Generic Support Account'; 
        accountObj.Enterprise_ID__c = '7777777777';
        accountObj.BillingStreet='Street';
        accountObj.BillingCountry='US';
        accountObj.BillingCity='Islandia'; 
        insert accountObj;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = accountObj.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName ='testAuto';
        contactObj.LastName ='contact';
        insert contactObj;
        
        Contacts_Site_Association__c csaObj = new Contacts_Site_Association__c();
        csaObj.SC_CSA_SITE__c = siteAssociationObj.Id ;
        csaObj.SC_CSA_CONTACTS__c = contactObj.Id; 
        insert csaObj; 
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='APPLICATION PERFORMANCE MANAGEMENT';
        insert caProductObj;
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='APPLICATION PERFORMANCE MANAGEMENT';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=caProductObj.id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='Test';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        insert prodcomp;
        
        id queueGroupId= [Select Id from Group where type='Queue' limit 1].Id;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        
        Component_Release__c componentReleaseObj = new Component_Release__c();
        componentReleaseObj.Name = 'EARL';
        componentReleaseObj.Component_Release__c = '6.1';
        componentReleaseObj.Component_Code__c='Tape ';
        insert componentReleaseObj;
        
        Case caseObject =new Case();
        caseObject.Accountid=accountObj.Id;
        caseObject.Site_Association__c=siteAssociationObj.Id;
        caseObject.CA_Product_Controller__c=caProductObj.id;
        caseObject.CA_Product_Component__c=prodcomp.id;
        caseObject.ContactId=contactObj.Id;        
        caseObject.Origin='Email';
        caseObject.OwnerId=queueGroupId;
        caseObject.Case_Type__c='Standard';
        caseObject.Subject='test subject TPC';
        caseObject.Description='asdf';
        caseObject.Reason='Instructions Not Clear';
        caseObject.Priority='3';        
        caseObject.Status='Open';
        caseObject.Severity__c='1';
        caseObject.Sev_1_Impact_c__c='Customer set Sev 1 for focus';
        caseObject.Internal_Priority__c='2';
        caseObject.Production_Down_Status__c='Investigating';
        caseObject.Alternate_email__c='vamsi.r@gmail.com';        
        caseObject.Component_Release_Only_Selection__c=  componentReleaseObj.Id;
        insert caseObject;
        
        Defect__c defectObject = new Defect__c();
        defectObject.Defect_URL__c = 'https://www.abc.com';
        defectObject.Defect_Object_ID__c = 'https://www.abc.com';
        defectObject.Defect_Submitted_By__c = 'tarun';
        defectObject.Defect_Owner__c = 'tarun';
        defectObject.Name = 'DE1111';
        //defectObject.OwnerId = queueGroupId;
        defectObject.Priority__c = '1';
        defectObject.Targeted_Release_Number__c = '8';
        defectObject.Target_Release_date__c = system.today();
        defectObject.Type__c = 'Defect';
        defectObject.Subject__c = 'test';
        defectObject.Status__c = 'New';
        defectObject.Severity__c = '1';
        defectObject.Resolution__c = 'fixed';
        defectObject.R_D_System__c = 'Rally';
        defectObject.Description__c = 'test testclass';
        insert defectObject;
        
        apexpages.currentpage().getparameters().put('caseId',caseObject.Id); 
    }*/
}