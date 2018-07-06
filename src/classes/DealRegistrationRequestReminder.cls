global class DealRegistrationRequestReminder implements Schedulable {

    // Run the job every day at 9 amselect
   // public static String CRON_EXP = '0 0 9 * * ?';
    global void execute(SchedulableContext ctx) 
    {    
          DealRegistrationRequestReminder_Batch AREL = new DealRegistrationRequestReminder_Batch();
           // the batch size can be no larger than 10 due to current apex email limits
           integer batchSize = 10;
           database.executebatch(AREL, batchSize);
    }
    

}