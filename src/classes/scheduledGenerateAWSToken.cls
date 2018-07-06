global class scheduledGenerateAWSToken implements Schedulable {
   global void execute(SchedulableContext sc) {
       System.enqueueJob(new GenerateAWSTokenQueueable());
   }
}