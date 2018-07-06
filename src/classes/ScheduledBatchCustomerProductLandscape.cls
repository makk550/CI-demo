//Associated Test Class : Test_BatchCustomerProductLandscape
global class ScheduledBatchCustomerProductLandscape implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new BatchToPopulateCustomerProductLandscape(),150);
    }    
}