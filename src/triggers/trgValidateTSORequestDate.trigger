trigger trgValidateTSORequestDate on TSO_Request__c (before insert,before update) 
{
 if(SystemIdUtility.skipTSORequestTriggers)
            return;


    Integer one_day = 1000*60*60*24;
    for(TSO_Request__c tsoreq : Trigger.new)
    {
        if(tsoreq.Start_Date_Time__c!=null && tsoreq.End_Date__c!=null)
        {
            if(tsoreq.Start_Date_Time__c>tsoreq.End_Date__c)
            {
                tsoreq.End_Date__c.addError('End date should be greater than Start date');
            }
            else
            {
                Long diff_ms = Math.abs(tsoreq.End_Date__c.getTime()-tsoreq.Start_Date_Time__c.getTime());
                Integer days = Math.round(diff_ms/one_day);
                if(days>=14)
                {
                    tsoreq.End_Date__c.addError('End date cannot be greater than 14 days');
                }
            } 
        }
    }
}