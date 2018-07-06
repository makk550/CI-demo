@isTest
private class ScheduleCaseAutoAssignTest 
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
     static testmethod void test() 
     {
        Test.startTest();
        ScheduledCaseAutoAssign pa= new ScheduledCaseAutoAssign();
        System.schedule('TestAutoAssign', CRON_EXP, pa);
        Test.stopTest();
    }
}