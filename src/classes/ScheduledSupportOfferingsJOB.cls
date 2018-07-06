global class ScheduledSupportOfferingsJOB implements Schedulable { 
    global void execute(SchedulableContext SC) {
        System.enqueueJob(new ScheduledSupportOfferingsQueuable());      
    }    
}