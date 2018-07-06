@istest
public class GlobalLeaderboardSchedule_Test{

public static testMethod void  testschedule() {
Test.StartTest();
GlobalLeaderboardSchedule sh1 = new GlobalLeaderboardSchedule();      
 String sch = '0 9 13 ? * MON-FRI *';
        system.schedule('Test check', sch, sh1);
Test.stopTest();
}
}