public with sharing class PartnerProfileUtil {
    
    /*
    Schedule Time is randomized to break the sequence of the batch jobs for sync getting submitted.
    
    */
    public Static Integer scheduleDirectAccountSync =0;
    public Static Integer schedulePartnerAccountSync =0;
    public Static Integer accScheduleCount =-1;
    public Static Integer taqaccScheduleCount =-1;
    
    public Static Integer findaccScheduleCount()
    {
        if(accScheduleCount ==-1)
        accScheduleCount =[select count() from CronTrigger where CronJobDetail.Name like'Sch_Batch_ResendDAccountForEAIMDMSync%' and State in ('WAITING','ACQUIRED','EXECUTING')];
        
        return  accScheduleCount;
    }
    
    
    public Static Integer findtaqaccScheduleCount()
    {
        if(taqaccScheduleCount ==-1)
        taqaccScheduleCount = [select count() from CronTrigger where CronJobDetail.Name like 'Sch_Batch_ResendPAccountForEAIMDMSync%' and State in ('WAITING','ACQUIRED','EXECUTING')];
        
        return  taqaccScheduleCount;
    }
    
    public Static String encodeXmlString(String input)
    {
        
        String output ; 
        
        if (input == null || input =='') return input;
        
        output = input;
        output = output.replace('&', '&amp;');             
        output = output.replace('<', '&lt;');
        output = output.replace('>', '&gt;');
        
        
        return output;
    }
    
    
    public Static void executePartnerProfileSync(String sobjectType, String jobName)
    {
        Boolean batchSchedule = false;
        Datetime dt;
        Double random = Math.random()*10;
        
        String query = 'Select count() from '+ sobjectType + ' where Error_Sending_To_EAI__c = true limit 1000 ';
        Integer count = Database.countQuery(query);
        if (count >0)
        {
            if(([select count() from AsyncApexJob where JobType='BatchApex' and (Status = 'Processing' or Status = 'Preparing')] < 5))
            {
            Batch_ResendSobjectForEAIMDMSync SobjectPartnerProfileSyncBatch = new Batch_ResendSobjectForEAIMDMSync(sobjectType);
            Database.executeBatch(SobjectPartnerProfileSyncBatch,200);
           
            dt = Datetime.now().addMinutes(15+Integer.valueOf(random));
           
            }
            else
            {
                dt = Datetime.now().addMinutes(5);
            }
        }
        else
        {
            dt = Datetime.now().addMinutes(15+Integer.valueOf(random));
        }
       String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
       try {
       if(sobjectType == 'TAQ_Account__c')
       {
           Sch_Batch_ResendPAccountForEAIMDMSync EAISyncSch = new Sch_Batch_ResendPAccountForEAIMDMSync();
       
           if(!Test.isRunningTest())
           System.Schedule(jobName+' '+timeForScheduler,timeForScheduler,EAISyncSch);
       }
       
       if(sobjectType == 'Account')
       {
           Sch_Batch_ResendDAccountForEAIMDMSync EAISyncSch = new Sch_Batch_ResendDAccountForEAIMDMSync();
       
           if(!Test.isRunningTest())
           System.Schedule(jobName+' '+timeForScheduler,timeForScheduler,EAISyncSch);
       }
       }
       catch(Exception e)
       {
           System.debug('ProfileUtil Exception in Scheduling '+ e.getMessage());
       }
    }

}