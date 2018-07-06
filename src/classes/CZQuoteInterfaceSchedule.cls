global class CZQuoteInterfaceSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CZQuoteInterfaceBatch(), 1);
   }
}