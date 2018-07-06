global class CI_Batch_Scheduler implements Schedulable{
global void execute(SchedulableContext sc) {
      BatchContactUpdateDuprecordset b = new BatchContactUpdateDuprecordset(); 
      database.executebatch(b);
   }
}