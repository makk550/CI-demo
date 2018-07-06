global class ScheduledCaseAutoAssign implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
        BatchCaseAutoAssign b = new BatchCaseAutoAssign(); 
        database.executebatch(b,1);
    }
}