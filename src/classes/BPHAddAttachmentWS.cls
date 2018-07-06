@RestResource(urlMapping='/addBPVersion/*')
global with sharing class BPHAddAttachmentWS {
    
    @HttpPost
    global static void doPost(String bpId) {
        	   
            Datetime curDate = Datetime.now();
            String formattedDate = curDate.format('yyyy-MM-dd');
            BP_History_Activities__c BPHA ;
           	Id bpIdVal = Id.valueOf(bpId);
           	           	
            Business_Plan_New__c curBp = [select Name,Status__c from Business_Plan_New__c where id =: bpIdVal ];            
            List<BP_History_Activities__c> BPHAList = [Select Id,to_attachment_Name__c,to_attachment_Id__c from BP_History_Activities__c where Business_Plan__c =:bpId order by CreatedDate desc limit 1];
           
            pageReference pdf = Page.BusinessPlanNewPDF;
            pdf.getParameters().put('id',bpIdVal);            
            pdf.getParameters().put('Profile','Profile');
            pdf.getParameters().put('Territory','Territory');
            pdf.getParameters().put('GTM','GTM');
            pdf.getParameters().put('Solutions','Solutions');
            pdf.getParameters().put('Training','Training');
            pdf.getParameters().put('Booking','Booking');
            pdf.getParameters().put('Checkout','Checkout');
            
            Attachment attach = new Attachment();
            Blob body;
            if(!test.isRunningTest()){
                body = pdf.getContent();
            }else{
                body=blob.valueOf('TestString');
            }            
            attach.Body = body;
            attach.Name = curBp.Name +'-'+ formattedDate +'-'+curBp.Status__c +'.pdf';
            attach.IsPrivate = false;
            if(BPHAList.size() > 0 )
            	attach.ParentId = BPHAList[0].Id;            	
            else
            	attach.ParentId = BPId;
            
            insert attach;
            
            if(BPHAList.size() > 0){
            	BPHAList[0].to_attachment_Name__c = attach.Name;
            	BPHAList[0].to_attachment_Id__c = attach.Id;
            	update BPHAList[0];
            }            
            System.debug('attach id ='+attach.Id);
         }
        
}