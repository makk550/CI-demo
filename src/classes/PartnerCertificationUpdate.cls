global class PartnerCertificationUpdate  implements Schedulable
{

    // Run the job every day at 6 am
    public static String CRON_EXP = '0 0 6 * * ?';
    
    global void execute(SchedulableContext ctx) 
    {    
        // Create a new batch object
    	PartnerCertificationUpdate_Batch PCA_Batch = new PartnerCertificationUpdate_Batch();
        
        PCA_Batch.query = 'SELECT Id,BP_Solutions__c,Contact__c,Resource_Type__c,Contact_Email__c,Certification_Level__c,Approved__c,Product_Group__c FROM BP_Training_Contact__c';        
            
        // Execute the batch
        // The default batch size is 200. To avoid exceeding guvernor limits we use 20.
        database.executebatch(PCA_Batch, 20);
	 }
}