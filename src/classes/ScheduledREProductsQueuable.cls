global class ScheduledREProductsQueuable implements Queueable, Database.AllowsCallouts {
    global void execute(QueueableContext context) {
        FetchREEnabledProducts obj =new FetchREEnabledProducts();
        obj.fetchREEnabledProductsFromService();
    }
}