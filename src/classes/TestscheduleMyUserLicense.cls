@isTest(SeeAllData=true)
public class TestscheduleMyUserLicense {
    public static testMethod void testMethodscheduleMyUserLicense (){
        test.startTest();
        scheduleMyUserLicense ul= new scheduleMyUserLicense ();
        String schedule = '0 0 12 * * ?';
        system.schedule('License Monitoring test', schedule, ul);
        test.stopTest();
    }  
}