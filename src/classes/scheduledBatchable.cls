global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      
       
       OpportunityUpdateBatchJob b = new OpportunityUpdateBatchJob(); 
          database.executebatch(b);
   }
}