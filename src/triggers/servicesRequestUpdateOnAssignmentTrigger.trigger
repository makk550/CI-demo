trigger servicesRequestUpdateOnAssignmentTrigger on Services_Request__c (before update) {

//## Summary: update the Request Status field on the field.
for (Services_Request__c srold: Trigger.old){

  Services_Request__c srnew = Trigger.newMap.get(srold.Id);
  String srnewOwnerIdStr = String.valueOf(srnew.OwnerId); 
   if (srnewOwnerIdStr.substring(0,3) != '005') {           
       break;        
   }
   if ((srold.OwnerId != srnew.OwnerId && (srnew.Services_Request_Status__c == 'New' || srnew.Services_Request_Status__c == 'Accepted') )  ){
     
      srnew.Services_Request_Status__c = 'Accepted';      
   }   
 
}

}