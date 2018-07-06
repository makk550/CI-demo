global class CZQuoteFinisherSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CZQuoteFinisherBatch(), 50);
   }
}