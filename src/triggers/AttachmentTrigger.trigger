trigger AttachmentTrigger on Attachment (after insert, after delete, before insert, before delete) {
    if(UserInfo.getUserId().contains(Label.saas_ops_integration_user))
     return;  
   if(trigger.isAfter)
   {  
       if (trigger.IsInsert)
       {
             Schema.DescribeSObjectResult result = External_RnD__c.sObjectType.getDescribe();
             String keyPrefix = result.getKeyPrefix();
             for(Attachment attachmentFile : Trigger.new){
                 if(attachmentFile.ParentId!=null && String.valueof(attachmentFile.ParentId).startsWith( result.getKeyPrefix()))
                 {
                     CalloutToCSM.createAttachemnt(attachmentFile.Id);
                 }
             }
              system.debug('Attachment -- After insert');
            // CA_AttachmentTriggerHandler.updateAgreementStatus(Trigger.New);
            //call new attachment triggerhandler
           	 CA_AttachmentTriggerHandler.PopulateBPUserAttachmentLink(Trigger.New);
       }
       else if (trigger.IsDelete)
       {
            //call new attachment triggerhandler
            CA_AttachmentTriggerHandler.NotDeleteAutoPDF(Trigger.Old);
            CA_AttachmentTriggerHandler.PopulateBPUserAttachmentLink(Trigger.Old);
       }
   }
    
    if(trigger.isBefore){
        if (trigger.IsInsert){
        List<Opportunity_Registration__C> OppPIRList = new List<Opportunity_Registration__C>();
			List<id> PIRIds = new List<id>();
           
            
			for(Attachment at : trigger.New){
			 
			 if(at.ParentId.getSobjectType() == Opportunity_Registration__C.SobjectType && at.ParentId!=null ){
				  PIRIds.add(at.ParentId);
			 }
			}
           
        
        Map<Id, Integer> attachmentcountpir = new Map<Id, Integer>();			//Map to store PIR Id and No. of attachment pair
        for(ID a:PIRIds){														//Loop to calculate no. of attachment on each PIRs
				
				if(attachmentcountpir.containskey(a)){
					Integer temp = attachmentcountpir.get(a) + 1;
					attachmentcountpir.put(a,temp);
				}
				else
					attachmentcountpir.put(a,1);
				
			}
			
        	List<Opportunity_Registration__C> pirs = [SELECT Id,hasAttachment__c From Opportunity_Registration__C where id IN :PIRIds];	
        
			for(Opportunity_Registration__C oppReg:pirs){					//Loop to check or uncheck field on PIR object
                if(oppReg.Id != null){
				Opportunity_Registration__C pirrecord= new Opportunity_Registration__C(id=oppReg.Id);
				Integer n = attachmentcountpir.get(oppReg.Id);
				if(n>0)
					pirrecord.hasAttachment__c= true;
				else if(n==0)
					pirrecord.hasAttachment__c= false;
					
				OppPIRList.add(pirrecord);
                }
			}
			
			update OppPIRList;
    }
        if(trigger.IsDelete){
			List<Opportunity_Registration__C> OppPIRList = new List<Opportunity_Registration__C>();
			List<id> PIRIds = new List<id>();
           
            
			for(Attachment at : trigger.Old){
			 
			 if(at.ParentId.getSobjectType() == Opportunity_Registration__C.SobjectType && at.ParentId!=null ){
				  PIRIds.add(at.ParentId);
			 }
			}
            
            List<Attachment> newPIRIDs= [SELECT ParentId from Attachment where ParentId IN :PIRIds];
			List<Opportunity_Registration__C> pirs = [SELECT Id,hasAttachment__c From Opportunity_Registration__C where id IN :PIRIds];
            
         		system.debug('--------attachmentsize--------------'+newPIRIDs.size());
            if(newPIRIDs.size()==1){
                system.debug('--------attachmentsize--------------'+newPIRIDs.size());
                for(Opportunity_Registration__C op:pirs){
                    
                    op.hasAttachment__c=false;
                 	OppPIRList.add(op);   
                }
                   update OppPIRList;
            }
         
         
	}
    }
}