global class ScheduledUserSkillsCountCorrection implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
        BatchUserSkillCaseCorrection b = new BatchUserSkillCaseCorrection (); 
        database.executebatch(b,20);
    }
}