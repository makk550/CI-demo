/*
* Test Class = TestSoxTriggersAndClasses
* Updated by - BAJPI01
* Coverage = 100%
*/
global class schedulePriceBookBatchJobs implements Schedulable{
    
    global void execute(SchedulableContext sc){
        
        sfcpq_sox_pricebookentry_batch pbeBatch = new sfcpq_sox_pricebookentry_batch();
        database.executeBatch(pbeBatch, 1000);
        
        sfcpq_sox_deleted_pbentry_batch soxPbeBatch = new sfcpq_sox_deleted_pbentry_batch();
		database.executeBatch(soxPbeBatch, 1000);
        
    }


}