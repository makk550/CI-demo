public class AccountPlanApproverControllerExtension {
    
    public Id apapprover {get;set;}
    private Apexpages.StandardController controller; 
    //public map<Task, Boolean> tasks {get; set;}
   
    
    public integer pageNumber {get; set;}
    public String activityType {get; set;}
    private final Account_Plan3__c ap;
    
     public AccountPlanApproverControllerExtension(ApexPages.StandardController stdController) {
         system.debug('checking');
        activityType = 'Events';
        pageNumber = 1;
        this.controller = stdController;
        this.ap = (Account_Plan3__c)stdController.getRecord();
     }
     public pagereference saveapprover()
   {
           apapprover=ap.Account_Plan_Approver__c;
           //Id accplanapprover=apapprover;
           Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
          //req3.setComments('Submitting request for approval.');
          req3.setObjectId(ap.Id);
          req3.setNextApproverIds(new Id[] {apapprover});

        
          // Submit the approval request for the account
          Approval.ProcessResult result = Approval.process(req3);
      
          // update the approval status
          ap.Account_Plan_Status__c = [SELECT Account_Plan_Status__c FROM Account_Plan3__c WHERE Id=:ap.Id][0].Account_Plan_Status__c;
      
          return new pageReference('/' + ap.Id);
            
   }

}