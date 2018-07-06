/** This class contains the code to call the class that execute as part of batch process
*   This class has to be scheduled to run once a day or according to the requirement.
**/
global class batch_EmailPartner_Products implements Schedulable{
 
   global void execute(SchedulableContext sc){
        Batch_EmailPartnerOnProductUpdate controller = new Batch_EmailPartnerOnProductUpdate () ;   
        Integer batchSize = 1;   
        database.executebatch(controller , batchSize);  
   }
}