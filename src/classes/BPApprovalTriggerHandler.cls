public with sharing class BPApprovalTriggerHandler {
    
    @Future(callout=true)
    public static void addPDFAttach(String sessionId, String bpId){  //bpId
    
    //There is issue calling web service from this batch job, so move the logic to attachment to this batch job directly. 
    //Comment out this, keep it as history.
    
    /*   HttpRequest req = new HttpRequest();      
         req.setEndpoint('https://'+URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/addBPVersion/');
         req.setMethod('POST');         
         req.setBody('{"bpId":'+JSON.serialize(bpId)+'}');
         req.setHeader('Authorization', 'Bearer '+ sessionId);
         req.setHeader('Content-Type', 'application/json');
         req.setTimeout(20000);
         
         System.debug('In addPDFAttach bpId:'+bpId);
         System.debug('Req Body:'+ req.getBody());
         
         Http http = new Http();
       if(!test.isRunningTest()){
        HTTPResponse res;
        try{
           res = http.send(req);
             System.debug('res statusCode:'+ res.getStatusCode() + ';' + 'Status :'+ res.getStatus());
        }
        catch(System.CalloutException e){
            System.debug('Callout error: '+ e);
              System.debug(res.toString());
        }
            
         }  
        
    }
    */
      Attachment attachhist = new Attachment();
            Datetime curDate = Datetime.now();
            String formattedDate = curDate.format('yyyy-MM-dd');
            BP_History_Activities__c BPHA ;
            Id bpIdVal = Id.valueOf(bpId);
            system.debug('bpIdVal'+bpIdVal);
            
        list<Attachment> oldattchment=[select id,Name,Parentid,body from Attachment where parentid=:bpIdVal order by CreatedDate desc limit 1];
        system.debug('oldattchment--'+oldattchment.size());        
        Business_Plan_New__c curBp = [select Name,Status__c from Business_Plan_New__c where id =: bpIdVal ];            
                    List<BP_History_Activities__c> BPHAList = [Select Id,to_attachment_Name__c,to_attachment_Id__c from BP_History_Activities__c where Business_Plan__c =:bpId order by CreatedDate desc limit 1];
              System.debug('BPHAList ='+BPHAList);     
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
                system.debug('body'+body);
            }else{
                body=blob.valueOf('TestString');
            }            
            attach.Body = body;
            attach.Name = curBp.Name +'-'+ formattedDate +'-'+curBp.Status__c +'.pdf';
            attach.IsPrivate = false;
           
           
              attach.ParentId = bpIdVal;
              system.debug('attach.ParentId--'+attach.ParentId);
              //For system generated BP approval process attachment, set the description to fixed string to distinguish with real user attachment
              attach.Description = 'Business Plan Approval Process Generated Attachments - Do not change Description';
             if(BPHAList.size() > 0 && oldattchment.size()>0)
            {
            
            attachhist.Body = oldattchment[0].body;
            attachhist.Name = oldattchment[0].Name;
            attachhist.IsPrivate = false;
            attachhist.ParentId = BPHAList[0].Id; 
               system.debug('attach.ParentId--'+attach.ParentId);
                insert attachhist;
                system.debug('attachhist---'+attachhist.id);
            }
            
            try
            {
                insert attach;
                
                system.debug('attachid----'+attach.id);
                if(BPHAList.size() > 0 && attachhist.id!=Null){
                  BPHAList[0].to_attachment_Name__c = attachhist.Name;
                  BPHAList[0].to_attachment_Id__c = attachhist.Id;
                  update BPHAList[0];
                  system.debug('BPHAList[0]----'+BPHAList[0].id);
                }            
            }
            catch(DMLException e){
                System.debug('Error inserting Attachment or Business Plan History: '+ e.getMessage() );
            }
        
            System.debug('attach id ='+attach.Id);
         }

}