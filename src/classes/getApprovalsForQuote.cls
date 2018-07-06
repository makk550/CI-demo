public class getApprovalsForQuote {

    // 7-20-2017 Chad Borer Code Zero
    // Used with ApprovalsForQuote Component and CPQ Advanced Approvals VisualForce email templates
    // Displays all applicable Approval triggers and their assignees in emails sent to approvers

    public String Quote;
    public String getQuote()
    {
        return quote;
    }
    public void setQuote(String q)
    {
        Quote = q;
        getApprovalsForQuote();
    }
    
    public List <SBAA__Approval__c> Approvals;

    public void getApprovalsForQuote() {
        try
        {
            Datetime lastApprovalCreated = [select CreatedDate from SBAA__Approval__c where Quote__c =: quote order by CreatedDate desc limit 1].CreatedDate.addSeconds(-10);
            Approvals = [select Approval_Rule_Name__c, ApproverName__c from SBAA__Approval__c where Quote__c =: quote AND CreatedDate >: lastApprovalCreated ];
        }
        catch (Exception e) { }
    }
    
    public List <SBAA__Approval__c> getApprovals() {
        return approvals;
    }

}