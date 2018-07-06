@isTest
public class ScheduledSupportOfferingsJOBTest {
public static testMethod void testschedule() {
Test.StartTest();   
System.enqueueJob(new ScheduledSupportOfferingsQueuable());

ScheduledSupportOfferingsJOB sh1 = new ScheduledSupportOfferingsJOB();
String sch = '0 0 23 * * ?'; 
system.schedule('ScheduledSupportOfferingJobTest', sch, sh1); 
Test.stopTest(); 
}
}