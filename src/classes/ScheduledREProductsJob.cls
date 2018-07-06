global class ScheduledREProductsJob implements Schedulable { 
    global void execute(SchedulableContext SC) {
        System.enqueueJob(new ScheduledREProductsQueuable());      
    }    
}