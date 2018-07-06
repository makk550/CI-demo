@istest
public class GlobalLeaderboardDealsScheduler_Test {

    
    public static testMethod void  testschedule() {
Test.StartTest();
         MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:Leaderboard_Auth/services/data/v29.0/analytics/reports/00Oa0000008sXV1?includeDetails=true','testGlobalsalesLeaderboardDeal');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
 		Test.setMock(HttpCalloutMock.class, multimock);
GlobalLeaderboardDealsScheduler sh1 = new GlobalLeaderboardDealsScheduler();      
 String sch = '0 30 9 ? * MON-FRI *';
        system.schedule('Test check', sch, sh1);
Test.stopTest();
}
}