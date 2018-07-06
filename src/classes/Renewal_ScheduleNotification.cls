global class Renewal_ScheduleNotification implements Schedulable{
    global void execute(SchedulableContext SC) {
    Renewal_Notification notification = new Renewal_Notification();
    notification.EmailReportNotification();
    }
    
    public static testMethod void testschedule() {

      /*  Test.StartTest();
        Renewal_ScheduleNotification sh =new Renewal_ScheduleNotification();
        String sch = '0 0 23 * * ?';
        System.Schedule('Renewal_ScheduleNotification',sch ,sh);        
        Test.stopTest();
        */

}
}