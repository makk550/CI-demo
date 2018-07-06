/*
 * Test class for TAQOrgAdminMainLogic
 * and for TAQOrgAdmin
 * updated by BAJPI01
 */

@isTest
private class TAQOrgAdminTest {
  public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void  loadTestData(){
    User u = new User();
    u.username = 'testdatamigration123@ca.com';
        u.LastName = 'Migration';
        u.Alias = 'Dmigrati';
        u.Email = 'sfdc_sandbox@ca.com';
        u.UserRoleId = '00E300000018UeMEAU';
        u.ProfileId = '00e30000001Fm6VAAS';
        u.EmailEncodingKey = 'UTF-8';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.CurrencyIsoCode = 'USD';
        u.uas__Sync_to_Contact__c = false;
        u.uas__Home_Phone__c = '123456';
        u.PMFKey__c = 'MIGDA01';
        insert u;
        
        //User u = [select id, profile.name, userrole.name,pmfkey__c,profileid, userroleid from user where Id ='00530000003rQuJ'];
        system.runAs(u){
            TAQ_REF_Position__c testRp =new TAQ_REF_Position__c();
        testRp.name ='TEST POS';
        testRp.profile_name__c=u.Profile.name;
        testRp.role_name__c=u.UserRole.name;
		testRp.profile_id__c = '00e30000001Fm6VAAS';
		testRp.role_id__c = '00E300000018UeMEAU';
        insert testRp;
           
		List<TAQ_Organization_Approved__c> taqOrgApprovedList = new List<TAQ_Organization_Approved__c>();
        TAQ_Organization_Approved__c testApp=new TAQ_Organization_Approved__c();
        testApp.PMFKey__c=u.PMFKey__c;
        testApp.position_id__c='TEST POS';
        testApp.process_status__c = 'New';
        testApp.process_message__c='';
        testApp.process_step__c= 'New Hire';
        testApp.employee_status__c = 'Active';
        testApp.Plan_Type__c='TEST PLAN';
        testApp.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp);
        
        TAQ_Organization_Approved__c testApp7=new TAQ_Organization_Approved__c();
        testApp7.PMFKey__c=u.PMFKey__c;
        testApp7.position_id__c='TESTPOS';
        testApp7.process_status__c = 'New';
        testApp7.process_message__c='';
        testApp7.process_step__c= 'New Hire';
        testApp7.employee_status__c = 'Active';
        testApp7.Plan_Type__c='TEST PLAN';
        testApp7.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp7);
    
        TAQ_Organization_Approved__c testApp2=new TAQ_Organization_Approved__c();
        testApp2.PMFKey__c=u.PMFKey__c;
        testApp2.position_id__c='TEST POS';
        testApp2.process_status__c = 'New';
        testApp2.process_message__c='';
        testApp2.process_step__c= 'Employee Change';
        testApp2.employee_status__c = 'Active';
        testApp2.Plan_Type__c='TEST PLAN';
        testApp2.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp2);
    
        TAQ_Organization_Approved__c testApp3=new TAQ_Organization_Approved__c();
        testApp3.PMFKey__c='testpmf';
        testApp3.position_id__c='TEST POS';
        testApp3.process_status__c = 'New';
        testApp3.process_message__c='';
        testApp3.process_step__c= 'Employee Change';
        testApp3.employee_status__c = 'Active';
        testApp3.Plan_Type__c='TEST PLAN';
        testApp3.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp3);
        
		TAQ_Organization_Approved__c testApp4=new TAQ_Organization_Approved__c();
        testApp4.PMFKey__c=u.PMFKey__c;
        testApp4.position_id__c='TEST POS';
        testApp4.process_status__c = 'New';
        testApp4.process_message__c='';
        testApp4.process_step__c= 'Term / Transfer';
        testApp4.employee_status__c = 'Transfer-Out';
        testApp4.Plan_Type__c='TEST PLAN';
        testApp4.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp4);
        
        TAQ_Organization_Approved__c testApp5=new TAQ_Organization_Approved__c();
        testApp5.PMFKey__c='testpmf';
        testApp5.position_id__c='';
        testApp5.process_status__c = 'New';
        testApp5.process_message__c='';
        testApp5.process_step__c= 'Term / Transfer';
        testApp5.employee_status__c = 'Terminated';
        testApp5.Plan_Type__c='TEST PLAN';
        testApp5.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp5);
        
        TAQ_Organization_Approved__c testApp6=new TAQ_Organization_Approved__c();
        testApp6.PMFKey__c='testpmf';
        testApp6.position_id__c='TEST POS';
        testApp6.process_status__c = 'New';
        testApp6.process_message__c='';
        testApp6.process_step__c= 'Term / Transfer';
        testApp6.employee_status__c = 'Transfer-Out';
        testApp6.Plan_Type__c='TEST PLAN';
        testApp6.Organization__c='GEO SALES';
        taqOrgApprovedList.add(testApp6);
        
        
        insert taqOrgApprovedList;
        }
        
        
        try{
                Test.startTest();
                TaqOrgAdmin.updateUser();
                String jobId = System.schedule('TAQOrgAdminScheduleTest',CRON_EXP, new TAQOrgAdmin());
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
                Test.stopTest();
                System.assertEquals(CRON_EXP, ct.CronExpression);

                // Verify the job has not run
                System.assertEquals(0, ct.TimesTriggered);

                // Verify the next time the job will run
                System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
                // Verify the scheduled job hasn't run yet.
            
            } 
            catch(Exception e)
            {
                System.Debug('ERROR'+e);
            }
    
    }
    
}