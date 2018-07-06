global class ScheduleOpportunityupdate implements Schedulable {
   global void execute(SchedulableContext sc) {     
       
       Batch_OppSlippedDealUpdate b = new Batch_OppSlippedDealUpdate(); 
          database.executebatch(b);
   }
}