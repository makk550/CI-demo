@isTest
public class PLD_Schedulable_Test {
    
    public static testMethod void testschedule() {
Test.StartTest();
PartnerLeadDistribution_Schedulable sh1 = new PartnerLeadDistribution_Schedulable();
 String CRON_EXP = '0 00 04,16 * * ?';
 system.schedule('PLD scheduleJob Check', CRON_EXP, sh1); Test.stopTest(); }

}