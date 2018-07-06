public class DealRegApprovalRejectionController {
    public opportunity opportunity {get;set;}
    public String processId;
    public String oppId;
    public ProcessInstance objProcessInstance;
    public PageReference redirectPage;
    @TestVisible private boolean testApprovalException = false ;

    public DealRegApprovalRejectionController(){
        oppId = ApexPages.currentPage().getParameters().get('OppId');
        opportunity = [select Name,Owner.Name,Owner.Id,Deal_Rejection_Reason__c,Comments__c, Deal_Registration_Rejection_Reason_Other__c from Opportunity where id =: oppId];
        redirectPage = new PageReference('/'+oppId);
    }
    
    public PageReference Approve(){
        try{
                //Save comments
                update opportunity;
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                 req.setComments(opportunity.Comments__c);
                 req.setAction('Approve');
                 
                 ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: oppId];

                 req.setWorkitemId(pItem.Id);
                 Approval.ProcessResult result =  Approval.process(req);

                if (!result.isSuccess() || testApprovalException)
                 {
                    return ReturnError(result);
                 }
            }
            catch(Exception e){
                   System.debug('DealRegApprovalRejectionController.Approve() failes :'+e.getMessage() + ', opportunity id ' + oppId);
                    return null;
            }
        return redirectPage ;
    }

    public PageReference Reject(){
    //if reason is "Other", reason detail is required, but it's handled by valiation rule.
        if(opportunity.Deal_Rejection_Reason__c == null || opportunity.Deal_Rejection_Reason__c == '--None--') {
            
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Rejection Reason to reject');            
                ApexPages.addMessage(msg);
                return null;
         }
         else
         {
            ApexPages.getMessages().clear();
            try{
                //Save comments and rejection reason, and rejection reason details.
                update opportunity;
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                 req.setComments(opportunity.Comments__c);
                 req.setAction('Reject');
                 
                 ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: oppId];

                 req.setWorkitemId(pItem.Id);
                 Approval.ProcessResult result =  Approval.process(req);

                 if (!result.isSuccess() || testApprovalException)
                 {
                    return ReturnError(result);
                 }
            }
            catch(Exception e){
                   System.debug('DealRegApprovalRejectionController.Reject() failed :'+e.getMessage() + ', opportunity id ' + oppId);
                   return null;
            }
         }

        return redirectPage ;      
    }

    public PageReference Cancel(){
        return redirectPage;
    }

    private PageReference ReturnError(Approval.ProcessResult result)
    {
        string error = '';
        for ( Database.error strError : result.getErrors() )
        {
            error += strError.getMessage();
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Rejection failed, please contact system administrator.'));
        system.debug('Rejection failed for opportunity ' + oppId + ' due to error: ' + error);
        return null;
    }
}