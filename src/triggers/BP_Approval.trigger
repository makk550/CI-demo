trigger BP_Approval on Business_Plan_New__c (before update,after update) 
{
   
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Business_Plan_New__c bp : Trigger.new)
        {
           if(Trigger.oldmap.get(bp.Id).Status__c != 'Pending CA Approval' && bp.Status__c == 'Pending CA Approval')bp.Submitted_By__c = UserInfo.getUserId();
           if((Trigger.oldmap.get(bp.Id).Status__c != 'CA & Partner Approved' && bp.Status__c == 'CA & Partner Approved') ||
           (Trigger.oldmap.get(bp.Id).Status__c != 'CA Rejected' && bp.Status__c == 'CA Rejected') ||
           (Trigger.oldmap.get(bp.Id).Status__c != 'Partner Rejected' && bp.Status__c == 'Partner Rejected'))
            {
                 //System.debug('Before : bp.Initial_Approval_Date__c:'+bp.Initial_Approval_Date__c);
                 if(bp.Initial_Approval_Date__c == null){
                    bp.Initial_Approval_Date__c = System.now();
                    //System.debug('After : bp.Initial_Approval_Date__c:'+bp.Initial_Approval_Date__c);
                 }
                 bp.Last_Approval_Date__c = System.now();           
            }
            if(bp.CA_Business_Plan_Owner__c != Trigger.oldmap.get(bp.Id).CA_Business_Plan_Owner__c ) bp.OwnerId = bp.CA_Business_Plan_Owner__c;
            if((Trigger.oldmap.get(bp.Id).Status__c != 'CA & Partner Approved' && bp.Status__c == 'CA & Partner Approved') && bp.Incentive_Readonly__c == false){
                bp.Incentive_Readonly__c = true;
            }
        }
    }
        
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Business_Plan_New__c bp : Trigger.new){
		          
           if((bp.status__c == 'Pending Partner Approval'  && Trigger.oldmap.get(bp.Id).Status__c != 'Partner Rejected' && bp.SendPartnerEmail__c==true )||(bp.status__c == 'Pending Partner Approval'  && Trigger.oldmap.get(bp.Id).Status__c != 'Partner Rejected' && bp.SendPartnerEmail__c==true && bp.TriggerApproval__c==true  )){            
                  
               Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                  //req.setComments('Submitted for approval. Please approve.');
                  req.setObjectId(trigger.new[0].Id);
                  req.setSubmitterId(bp.Submitted_By__c);
                  system.debug('approval process'+req );
                  Approval.ProcessResult result = Approval.process(req);
                  
            }
            //else if(bp.Status__c  == 'CA & Partner Approved' || bp.Status__c  == 'CA Rejected' || bp.Status__c == 'Partner Rejected' || bp.Status__c == 'Recalled')   
            else if( (Trigger.oldmap.get(bp.Id).Status__c != bp.Status__c) && ( bp.Status__c  == 'CA & Partner Approved' || bp.Status__c  == 'CA Rejected' || bp.Status__c == 'Partner Rejected' || bp.Status__c == 'Recalled'))   
            {             system.debug('in addPDFAttach');    
                  BPApprovalTriggerHandler.addPDFAttach(UserInfo.getSessionId(),String.valueOf(bp.Id));
            }            
        }
    }
      
}