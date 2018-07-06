public with sharing class Dismiss_selected_Callbacks_ext {
    Public List<Task> taskList {get;set;}
    Public List<Case> casRec{get;set;}
    public List<TaskWrapper> listTasksWrapper{get;set;}
    public boolean checkAll{get;set;}  //CR:400-1228

    public Dismiss_selected_Callbacks_ext(ApexPages.StandardController controller) {
        //taskList=[select Subject,Status,id,Whatid,CallType,ActivityDate,OwnerId from Task where whatid=:ApexPages.currentPage().getParameters().get('caseid') and Status NOT in('Completed','Closed') and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Support Callback')];
        //***MANAR08 - Filetring workaround and resolution tasks from Dismiss callback functionality
        taskList=[select Subject,Status,id,Whatid,CallType,ActivityDate,OwnerId from Task 
                        where whatid=:ApexPages.currentPage().getParameters().get('caseid') and Status NOT in('Completed','Closed') and Type NOT IN ('Workaround','Resolution') and 
                        RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Support Callback')];
        listTasksWrapper=new List<TaskWrapper>();
        checkAll=false; //CR:400-1228
        if(taskList!=null && taskList.size()>0)
        {    
            checkAll=true; //CR:400-1228
            for(Task recTask:taskList)
            {
                TaskWrapper recTW=new TaskWrapper(recTask);
               // recTW.bChecked=false; //CR:400-1228
                listTasksWrapper.add(recTW);
            }
               
        }            
    }
    public pagereference Save()
    {
		casRec=[select id,open_cb__c from Case where id=:ApexPages.currentPage().getParameters().get('caseid') ]; //taskList[0].whatId];
        List<Task> listUpdateTasks=new List<Task>();
        if(listTasksWrapper!=null && listTasksWrapper.size()>0)
        {
            for(TaskWrapper recTW:listTasksWrapper)
            {
                if(recTW.bChecked)
                {
                    recTW.objTask.Status='Closed';
                    listUpdateTasks.add(recTW.objTask);
                }
            }
        }
        if(listUpdateTasks!=null && listUpdateTasks.size()>0)
        {
          update listUpdateTasks;
            if(casRec.size()>0 && listUpdateTasks.size()==listTasksWrapper.size())
            {
          for(Case caseRec:casRec)
            caseRec.Open_cb__c='N';
            }
            System.debug('dismiss cb page'+casRec);
          
        }
        return (new pagereference('/'+ApexPages.currentPage().getParameters().get('caseId')));
    }
    public pagereference Cancel()
    {
        return (new pagereference('/'+ApexPages.currentPage().getParameters().get('caseId')));
    }
    public class TaskWrapper
    {
        public boolean bChecked{get;set;}
        public Task objTask{get;set;}
        TaskWrapper(Task recTask)
        {
            objTask=recTask;
            bChecked=true;// change for select and dismiss callback issue. CR:400-1228
        }
    }
}