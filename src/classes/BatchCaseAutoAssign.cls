global class BatchCaseAutoAssign implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        Set<String> QueSet = new Set<String>();
        List<Auto_Assign_Queues__c> AssList = new List<Auto_Assign_Queues__c>();
        AssList=Auto_Assign_Queues__c.getAll().Values();
        for(Auto_Assign_Queues__c Aq:AssList)
        {
            if(Aq.Auto_Assign_Batch_Job__c)
            {
                QueSet.add(Aq.Queue_Id__c);  
            }
        }
        
        String query = 'Select id from case where ownerid IN :QueSet and status!=\'Closed\' and createddate > 2015-01-23T00:00:00Z'; 
        
        //Case[] myCases = [Select id from case where casenumber IN ('00276012','00276013','00276014')];     
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Case> myCases) 
    {
        if(myCases != null && myCases.size() > 0)
        {
         update myCases;
        }
    }   
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}