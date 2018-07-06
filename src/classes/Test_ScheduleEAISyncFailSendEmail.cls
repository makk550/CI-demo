/**************************************************************************************************
* Test Class for Unit testing Schedule EAI-Account & TAQ Account Failed Summary Send Email.
* 
*Version Date         Owner                         Description
****************************************************************************************************
* 1.0    24/03/2015   Manikandan Raju               Created.
**************************************************************************************************/

@isTest
                                
private class Test_ScheduleEAISyncFailSendEmail {

    // CRON expression
    public static String CRON_EXP = '0 0 7 * * ?';
    
    static testmethod void test() {
     
        //Start Test
        Test.startTest();
        
        // Schedule the test job. Name the JOB, Set the CRON Expression, Define the Schedule Class.
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new ScheduleEAISyncFailSendEmail());

        // Get the information from the CronTrigger API object which we will assert.
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        //Stop Test
        Test.stopTest();

    }
}