public with sharing class AttachPocExt{
    public Attachment att {get; set;}
    public ID oppid;
    public Opportunity opprec;
    public Trial_Request__c trialreq;
    public AttachPocExt(ApexPages.StandardController controller) {
        
        att = new Attachment ();
        
        trialreq = (Trial_Request__c)controller.getRecord();
        
        //get Oppid from URL
        this.oppid = ApexPages.currentPage().getParameters().get('oppid');
        
        //Soql query to get AccountId,sRecordTypeName
        opprec = [select AccountId,id,RecordType.Name from Opportunity where id = :oppid];
    }
    
    public pagereference save()
    {
        trialreq.Account_Name__c =opprec.AccountId; 
        trialreq.Opp_Name__c = opprec.Id; 
        trialreq.Request_Type__c = 'POC Request'; 
        trialreq.Request_Status__c = 'New'; 
        trialreq.Record_Type__c = opprec.RecordType.Name;
      
        insert trialreq;
        if(att.name != ''&& att.body != null)
        {
            att.ParentId = trialreq.id;
            insert att;
        }
        return new PageReference('/'+trialreq.id);
         
    }
   
}