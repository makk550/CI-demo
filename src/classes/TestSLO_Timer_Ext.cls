@isTest
public class TestSLO_Timer_Ext {
 static testMethod void TaskSLO_Timer_Ext_Test()
 {
 Task testTask = new Task();
  
 testTask.Due_Date_SLO__c=datetime.newInstance(2014, 9, 23, 12, 30, 0);
 Double dueDateMS=(testTask.Due_Date_SLO__c.getTime()-System.now().getTime())/1000;
 insert testTask;
 ApexPages.StandardController stdController = new ApexPages.StandardController(testTask);
 SLO_Timer_Ext controller = new SLO_Timer_Ext(stdController);
 
 }
}