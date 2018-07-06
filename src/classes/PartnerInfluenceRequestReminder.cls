global class PartnerInfluenceRequestReminder implements Schedulable{

    // Run the job every day at 9 am
    public static String CRON_EXP = '0 0 9 * * ?';
    global void execute(SchedulableContext ctx) 
    {    
          PartnerInfluenceRequestReminder_Batch ARE = new PartnerInfluenceRequestReminder_Batch();
           // the batch size can be no larger than 10 due to current apex email limits
           integer batchSize = 10;
           database.executebatch(ARE, batchSize);
    }
    

}