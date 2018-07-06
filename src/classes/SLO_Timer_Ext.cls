public with sharing class SLO_Timer_Ext {
    public Double dueDateMS{get; set;}
    Task t;
    public SLO_Timer_Ext(ApexPages.StandardController controller) {
        t = (Task)controller.getRecord();
        
        Task tskRec =[select id,status,Due_Date_SLO__c from Task where id=:t.id];
        if(tskRec.Due_Date_SLO__c!=null && tskRec.Status!='Closed')
        dueDateMS = (tskRec.Due_Date_SLO__c.getTime()-System.now().getTime())/1000;
    }

}