public class ApproveAccessRequestFuture {

    @future
   public static void approverSDRequest(String requestId, String approverComments, String SDTicket){
    
     // Approving the records
     
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Approve');
         
         ProcessInstanceWorkitem wt = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: requestId limit 1];  
         
          if(wt != NULL)
          {
             req.setWorkitemId(wt.Id);
             Approval.ProcessResult result =  Approval.process(req);
          }
         
         Access_Request__c request = [Select Id,Status__c, RecordTypeId,Access_Granted_Through__c  from  Access_Request__c where Id =:requestId];
         request.RecordTypeId = Schema.SObjectType.Access_Request__c.getRecordTypeInfosByName().get('AfterApproval').getRecordTypeId();
         request.Access_Granted_Through__c = approverComments;
         request.Approver__c = UserInfo.getuserId();
         request.SD_Ticket__c = SDTicket;
         request.Status__c= 'Approved and Service Desk Ticket Created';
       	 request.Source_of_SD_Ticket__c = 'Approver';
        
         update(request);
        
     
     }
     
     
  /*   @future
   public static void requestorSDRequest(String requestId, String approverComments, String SDTicket){
    
     // Approving the records
     
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Approve');
         
         ProcessInstanceWorkitem wt = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: requestId limit 1];  
         
          if(wt != NULL)
          {
             req.setWorkitemId(wt.Id);
             Approval.ProcessResult result =  Approval.process(req);
          }
         
         Access_Request__c request = [Select Id,Status__c, RecordTypeId,Description__c  from  Access_Request__c where Id =:requestId];
         request.RecordTypeId = Schema.SObjectType.Access_Request__c.getRecordTypeInfosByName().get('AfterApproval').getRecordTypeId();
         request.Description__c = approverComments;
         request.Approver__c = UserInfo.getuserId();
         
         request.SD_Ticket__c = SDTicket;
         request.Status__c= 'Approved & SD Ticket Created by Requestor';
        
         update(request);
        
     
     }
*/
    
}