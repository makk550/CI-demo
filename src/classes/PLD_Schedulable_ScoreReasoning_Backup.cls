global class PLD_Schedulable_ScoreReasoning_Backup implements Schedulable
{
/*  Execute this in the Anonymous Window to setup the job
 	PartnerLeadDistribution_Schedulable batchSch = new PartnerLeadDistribution_Schedulable();
    // Run the job twice a day at 4 am and 4 pm
    String CRON_EXP = '0 00 04,16 * * ?';
    system.schedule('PartnerLeadDistributionJob', CRON_EXP, batchSch);
*/    
    global void execute(SchedulableContext ctx) 
    {    
        // Create a new batch object
    	PartnerLeadDistributionBatch PCA_Batch = new PartnerLeadDistributionBatch();
        
        // Execute the batch
        // The default batch size is 200. 
        database.executebatch(PCA_Batch, 8);
	 }
}