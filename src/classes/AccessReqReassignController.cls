public class AccessReqReassignController {
    
    public Id arapprover {get;set;}
    private Apexpages.StandardController controller; 
	
   
    

    private final Access_Request__c ar;
    
     public AccessReqReassignController(ApexPages.StandardController stdController) {
         system.debug('checking');
        
        this.controller = stdController;
        this.ar = (Access_Request__c)stdController.getRecord();
     }
     public pagereference saveapprover()
   {	
       arapprover=ar.Approver__c;
       system.debug('arapprover'+arapprover);
       
       
       	Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
        
		List<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId = :ar.id]);
		system.debug('procins'+procins);
       // Retrieve the process work instance id associated to the process instance
            List<ProcessInstanceWorkitem>  workitem = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins[0].id]);
            if ((workitem != null) && (workitem.size() > 0))
            {

                pwr.setWorkItemId(workitem[0].id);
                pwr.setAction('Removed'); 
             
                
                // Execute process request
                Approval.ProcessResult pr = Approval.process(pwr);
			}
       
           Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
          //req3.setComments('Submitting request for approval.');
          req3.setObjectId(ar.Id);
         //req3.setNextApproverIds(new Id[] {arapprover});
       update ar;

        
          // Submit the approval request for the account
          Approval.ProcessResult result = Approval.process(req3);
      
          // update the approval status
          ar.Status__c = [SELECT Status__c FROM Access_Request__c WHERE Id=:ar.Id][0].Status__c;
      
          return new pageReference('/' + ar.Id);
            

		}

    
    
}