public class AttachDealRegCertificate {
    public AttachDealRegCertificate(){
        
    }
    public static void attachPDFtodeaHistory(Opportunity opp,Blob bodyy){
        list<DealRegistrationApproved__c> dlalist= new list<DealRegistrationApproved__c>();
        for(DealRegistrationApproved__c dra:[select id,IsLatest__c from DealRegistrationApproved__c where Opportunity_Name__c=:opp.id]){
            dra.IsLatest__c=false;
            dlalist.add(dra);
        }
        if(dlalist.size()>0){
        update dlalist;
            }
        //Deal_Registration_Status__c
        PageReference pdf = Page.DealReg_DealCertificate;
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id',opp.Id);
        // create the new attachment
        DealRegistrationApproved__c dealHistory=new DealRegistrationApproved__c();
        dealHistory.Opportunity_Name__c =opp.Id;
        dealHistory.IsLatest__c =true;
        insert dealHistory;
        Attachment attach = new Attachment();
    
        attach.Body = bodyy;
        // add the user entered name
        attach.Name = 'certicate.pdf';
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = dealHistory.Id;
        insert attach;
        list<opportunity> oplist= [select id,IsLatestAttachmentid__c from opportunity where id=:opp.Id limit 1];
        
        oplist[0].IsLatestAttachmentid__c=attach.id;
        dealHistory.AttachmentID__c=attach.id;
       update oplist;
        update dealHistory;
    }
    public static Blob getCertifiacteBody(Opportunity opp){
        PageReference pdf = Page.DealReg_DealCertificate;
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id',opp.Id);
        Blob body;
     // returns the output of the page as a PDF
            body = pdf.getContent();
        return body;
        
    }

}