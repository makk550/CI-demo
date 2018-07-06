@isTest
public class TestUserSkillsComponentSelection {
    
    static testMethod void TestUserSkillsComponentSelectionMethod(){
        
        
        BusinessHours objBH=[SELECT Id, IsActive, Name FROM BusinessHours where IsActive=true limit 1];
        User_Skills__c objUS=new User_Skills__c();
        objUS.User__c=UserInfo.getUserId();
        objUS.Tops_Site_ID__c='1299636';
       // objUS.Component_Code__c='CMDB;Tape';
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
        prodCtl.name='MyTest';
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
        
         CA_Product_Component__c prodcomp2 = new CA_Product_Component__c();
        prodcomp2.Name='MeTest';
        prodcomp2.CA_Product_Component_Ext_ID__c='MeTest';
        prodcomp2.Default_Component_for_CA_Product__c=True;
        prodcomp2.CA_Product_Controller__c=prodCtl.id;
        prodcomp2.CA_Product_Text__c='MeTest';
        prodcomp2.Component_Code__c='MeTest';
        prodcomp2.Component_Text__c='MeTest';
        prodcomp2.Default_Component_for_this_CA_Product__c=True;
        prodcomp2.SFDC_Support_System__c=True;
        insert prodcomp2;
        
        UserSkillProductCodeAssociation__c userprodcomp = new UserSkillProductCodeAssociation__c();
        userprodcomp.name = 'Rtest';
        userprodcomp.CA_Product_Component__c=prodcomp2.id;
        userprodcomp.CurrencyIsoCode='Nz';
        userprodcomp.User_Skills__c=objUS.id;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(objUS);
        UserSkillsComponentSelection controller = new UserSkillsComponentSelection(stdController);
        
        controller.componentresult();
        controller.save();
        
        
             
       }
        
    
    
        
        
    }