@isTest

private class TestScheduledUserSkillsCountCorrection
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void test() {
      Test.startTest();
      String jobId = System.schedule('Test 111',
                        CRON_EXP,
                        new ScheduledUserSkillsCountCorrection ());
      Test.stopTest();
      } 
}