public class BPAttachmentsViewController {
    public Id AccountId{set;get;}
	public String AccountName{set;get;}
    public string BackUrl{set;get;}
    private Id bpId;
    
    public BPAttachmentsViewController(){
        bpId = apexpages.currentpage().getparameters().get('id');
        AccountId = apexpages.currentpage().getparameters().get('aid');
        
        List<Account> account = new List<Account>([select name from account where id =:AccountId]);
        
        if (account.size()> 0)
            AccountName = account[0].name;
        
        BackUrl = URL.getSalesforceBaseUrl().getHost() + '/' + AccountId;
    }
    
    public List<Attachment> getAttachments()
    {
        List<Attachment> attachmentList = [SELECT Id, Name, Description, CreatedDate, lastModifiedDate, bodyLength from Attachment where parentId =:bpId and Description != 'Business Plan Approval Process Generated Attachments - Do not change Description' and (not name like 'Business Plan-%-Modifying.pdf')];
        
        return attachmentList;
    }
}