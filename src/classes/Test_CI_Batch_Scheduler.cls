@istest

public class Test_CI_Batch_Scheduler {
    
    static testMethod void myUnitTest()
    {
        CI_Batch_Scheduler cibs = new CI_Batch_Scheduler();
       String sch = '0 0 23 * * ?';
system.schedule('Test Check', sch, cibs);
    }

}