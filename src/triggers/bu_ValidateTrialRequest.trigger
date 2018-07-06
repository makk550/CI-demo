//US471855 GPOC: Extend Request -Only End date editable -SAMAP01

trigger bu_ValidateTrialRequest on Trial_Request__c (before update) {
         //User usr= [select Id from user where Id='005f00000019tb9'];
         
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
        return;
    
    Set<id> userId=new Set<id>();
    List<String> AccArea=new List<string>();
    List<String> bussinessUnit=new List<string>();
    List<String> accRegion=new List<string>();
    Map<Id,User> umap = new Map<id,User>();
    List<POC_Escalation_Matrix__c> lstEscMatrix = new List<POC_Escalation_Matrix__c>();
    Map<String,Id> pocEscalationManagerMap = new Map<String,Id>();
    String key;
    Boolean sendextnapprovalemail = false ; //samap01

    for(Trial_Request__c req:Trigger.new){
        if(Trigger.old!=null){
            string strStatus = req.Request_Status__c;
            string strOldStatus = Trigger.old[0].Request_Status__c;
          
             Trial_Request__c oldPoc = Trigger.oldMap.get(req.Id);    //SAMAP01 -US471855
              System.debug('samap01 reached bu_ValidateTrialRequest' + oldPoc.End_Date__c  + '-' + req.End_Date__c);
             if( oldPoc.End_Date__c  != req.End_Date__c  &&  req.Request_Status__c == 'Extension for Approval')            
             {
                sendextnapprovalemail =true;                 
             }
            else
            {
                sendextnapprovalemail =false;
                
            }
            //US471855
                 
            if(strOldStatus!='New' && strStatus=='New' && strStatus == 'On Hold' ){
                req.Request_Status__c.addError('Cannot reset status to New, after the requested status has been changed.');
            }
        }
         if(req.Request_Status__c == 'Extension Approved' || req.Request_Status__c == 'Request Approved' || req.Request_Status__c == 'DDR Request Approved' || req.Request_Status__c == 'On Hold' )
        {
            userId.add(req.CreatedById);
            AccArea.add(req.Acc_Area__c);
            bussinessUnit.add(req.Business_Unit__c);
            accRegion.add(req.Acc_Region__c);
       }
    
    }

    
    
    if(userId.size()>0){
      umap = new Map<id,User>([SELECT Id,CreatedById, IsActive FROM User WHERE id = :userId]);
    } 
    
    if(AccArea.size()>0&&bussinessUnit.size()>0&&accRegion.size()>0){
      lstEscMatrix = [SELECT POC_Escalation_Manager__c,POC_Approver_Email__c,Area1__c,Business_Unit__c,Region__c
                      FROM POC_Escalation_Matrix__c WHERE Area1__c = :AccArea AND 
                        Business_Unit__c =:bussinessUnit  AND Region__c =:accRegion];
    }
    if(lstEscMatrix.size()>0){
        
        for(POC_Escalation_Matrix__c poc:lstEscMatrix){
            key = poc.Area1__c+poc.Business_Unit__c+poc.Region__c;
            pocEscalationManagerMap.put(key,poc.POC_Escalation_Manager__c);
        }
    }
              
        for(Trial_Request__c req:Trigger.new){
            key = req.Acc_Area__c+req.Business_Unit__c+req.Acc_Region__c;
             if(req.Request_Status__c == 'Extension Approved' || req.Request_Status__c == 'Request Approved' || req.Request_Status__c == 'DDR Request Approved' || req.Request_Status__c == 'On Hold' )
        {

            if(umap.get(req.CreatedById).IsActive == true){
              req.ownerID =req.CreatedById;
            }else{
              if(pocEscalationManagerMap!= null && pocEscalationManagerMap.size() > 0){
                if(pocEscalationManagerMap.containsKey(key))
                    req.ownerID = pocEscalationManagerMap.get(key); 
              }
            }
        }
        }
       
      for(Trial_Request__c req:Trigger.new){
         // System.debug('samap01 Trigger.old[0].OwnerId' + Trigger.old[0].OwnerId +'-' +Trigger.new[0].OwnerId );
        if(((Trigger.old[0].OwnerId != Trigger.new[0].OwnerId) && (req.Request_Status__c == 'Request for Approval')) || (req.Request_Status__c == 'Extension for Approval'))
        {           
           List<POC_Escalation_Matrix__c> lstEscMatrixMang = [select POC_Escalation_Manager__c,POC_Approver_Email__c from POC_Escalation_Matrix__c where Area1__c = :req.Acc_Area__c  and Business_Unit__c =:req.Business_Unit__c  and  Region__c =:req.Acc_Region__c];     
   
           if(lstEscMatrixMang != null && lstEscMatrixMang.size() > 0)
           {    
             if(lstEscMatrixMang[0].POC_Escalation_Manager__c != null)                
                 req.POC_Escalation_Manager__c = lstEscMatrixMang[0].POC_Escalation_Manager__c;                                                
              
             if(lstEscMatrixMang[0].POC_Approver_Email__c != null)
             {      

                    String strRecipients = lstEscMatrixMang[0].POC_Approver_Email__c;          
                    String[] ArrstrRecipients = strRecipients.split(',');                        
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setWhatId(req.Id);
                    if(req.Request_Status__c == 'Request for Approval' && req.StdLicAgr__c == true)
                       email.setTemplateId(Label.POC_Approval_Email_Template);
                    else if(req.Request_Status__c == 'Request for Approval' && req.StdLicAgr__c == false)
                        email.setTemplateId(Label.POC_Approval_Email_Template);
                    else
                       email.setTemplateId(Label.POC_Extension_Email_Template);
                 //added by jagan 
                
                    if(req.Request_Status__c == 'Extension for Approval' && req.StdLicAgr__c == true)
                       {
                        email.setTemplateId(Label.Approve_Extension_Request_Template);  
                        system.debug('Label.Approve_Extension_Request_Template '+Label.Approve_Extension_Request_Template);
                       }
                 //change ends
                 
                    email.setToAddresses(ArrstrRecipients);
                    //email.setCCAddresses(new String[]{'GlobalPOCTeam@ca.com'});
                    
                    email.setTargetObjectId(Label.POC_GlobalPOCTeam);
                    system.debug('***');
                  //samap01 - Send Extension approval email only when end date is changed -US471855
               
                  if(req.Request_Status__c != 'Extension for Approval')
                  {
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email }); 
                  }  
                  else if( req.Request_Status__c == 'Extension for Approval'  && sendextnapprovalemail == true )
                  {
                      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                      system.debug('samap01 finally send extn approval email');
                  }
                //samap01 -US471855
             }
             else
             {
                req.addError('ERROR MESSAGE:The GPOC Request for Approval email could not be triggered. Please contact GlobalPOCTeam@ca.com to identify the correct  Business Unit Presales Management contact for the GEO and Operating Area.');
             }
        }   
        }
        }
    
    
    
}