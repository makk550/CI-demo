@isTest(seealldata=true)
private class TestAttachPocExt{
    public static testmethod void AttachPocExt(){
        
        Opportunity opp = new Opportunity(Name = 'oppInsertTrigger1' , StageName = 'test' , CloseDate = Date.today());
        insert opp;
        ApexPages.currentPage().getParameters().put('oppid',opp.id);
        Trial_Request__c trialreq = new Trial_Request__c();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(trialreq);
        AttachPocExt poc= new AttachPocExt(controller);
        Attachment att = new Attachment();
        Blob b = Blob.valueOf('Parsing string to Blob');
        att.body = b;
        att.name = 'some attachment';
        poc.att = att;
        poc.save();
        
    }
}