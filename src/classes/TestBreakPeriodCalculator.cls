@istest
public class TestBreakPeriodCalculator {
    
    public static testmethod void testValidation(){
String stTime,EnTime, Timezone;
Time busStTime, busEnTime;
        stTime = '11:00 AM';
        EnTime = '01:00 PM';
        busStTime = System.now().time();
        busEnTime = busStTime.addHours(5);
        Timezone = 'Asia/Dubai';
        test.startTest();
        boolean flag1 = BreakPeriodCalculator.validateBreakPeriod(stTime, EnTime);
        boolean flag2 = BreakPeriodCalculator.validateWithBusinessHours(stTime, EnTime, busStTime, busEnTime);
        boolean flag3 = BreakPeriodCalculator.validateAutoassign(stTime, EnTime, Timezone);
        test.stopTest();
        
            }
}