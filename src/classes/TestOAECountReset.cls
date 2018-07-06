@isTest(seeAlldata=true)
public class TestOAECountReset {
    
    static testMethod void OAEtest1()
    {
        
        User Usrrec=[select id,TimeZoneSidKey from User where id=:UserInfo.getUserId()];
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
        
       
        //objUS.Time_to_Reset_US= datetime.valueof(DateTime.parse(String.valueOf((Datetime.now()).format('MM/dd/yyyy'))+' 05:40 PM').format('yyyy-MM-dd HH:mm:ss',Usrrec.TimeZoneSidKey));   
        insert objUS;
        
        
        Auto_Assign_Locations__c testAAL= new Auto_Assign_Locations__c();
        testAAL.Name='Test';
        Component__c   testcom = new Component__c();
        testcom.Name='Test';
       // TOPs__c testtops = new TOPs__c();
        //testtops.Name='Test';
            }
}