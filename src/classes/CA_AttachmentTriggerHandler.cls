public Class CA_AttachmentTriggerHandler{
    public static void NotDeleteAutoPDF(List<Attachment> attList)
    {
        for(Attachment a : attList) {
             if (a.Description == 'Business Plan Approval Process Generated Attachments - Do not change Description')
             {
                 a.addError(label.BP_Auto_PDF_can_not_be_deleted);
             }
        }
    }

    public static void PopulateBPUserAttachmentLink(list<Attachment> attList)
    {
        list<Business_Plan_New__C> bpFieldsToUpdate = new list<Business_Plan_New__C>();
        Business_Plan_New__C tempBP;
        
        list<Id> parentIds = new list<Id>();
        for(Attachment a : attList) {
             parentIds.add(a.parentId);
        }

        System.debug(' parentids ' + parentIds);
        
        try 
        {
        	list<Business_Plan_New__C> bpList = new list<Business_Plan_New__C>([select Id,(SELECT Id, Name FROM Attachments where Description != 'Business Plan Approval Process Generated Attachments - Do not change Description' and (not name like 'Business Plan-%-Modifying.pdf')) from business_plan_new__c where id in: parentIds]);
        
             System.debug(' bpList.size ' + bpList.size());
            
            if (bpList.size() > 0)
            {
                for(Business_Plan_New__C bp: bpList)
                {
                    if (bp.Attachments == null || bp.Attachments.Size() == 0)
                    {
                        tempBP = new Business_Plan_New__C();
                        tempBP.id = bp.id;
                        tempBP.UserAttachmentID__c = '';
                        tempBP.UserAttachmentName__c = '';
                        bpFieldsToUpdate.add(tempBP);
                    }
                    else if (bp.Attachments.Size() == 1)
                    {
                        tempBP = new Business_Plan_New__C();
                        tempBP.id = bp.id;
                        tempBP.UserAttachmentID__c = bp.Attachments[0].Id;
                        tempBP.UserAttachmentName__c = bp.Attachments[0].Name;
                        bpFieldsToUpdate.add(tempBP);
                    }
                    else if (bp.Attachments.Size() > 1)
                    {
                        tempBP = new Business_Plan_New__C();
                        tempBP.id = bp.id;
                        tempBP.UserAttachmentID__c = 'multiple';
                        tempBP.UserAttachmentName__c = 'Click for details';
                        bpFieldsToUpdate.add(tempBP);
                    }
                }
            }
           
            //update bpFieldsToUpdate;
            Database.SaveResult[] srList = Database.Update(bpFieldsToUpdate, false);

            for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred updating bpFieldsToUpdate in CA_AttachmentTriggerHandler.PopulateBPUserAttachmentLink.');                   
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                		} 
            		}
			}   
        }
        catch(Exception e)
        {
            //don't throw the error, just log the message.
             system.debug('Error in CA_AttachmentTriggerHandler.PopulateBPUserAttachmentLink'+e.getMessage());
        }           
    }
                    
	public static void updateAgreementStatus(List<Attachment> attList) {
        try {
            system.debug('Update Agreement Status -- Attachment');
            
            Set<Id> agrIds = new Set<Id>();
            
            for(Attachment att : attList) {
                Schema.DescribeSObjectResult r = Apttus__APTS_Agreement__c.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();
                String pId = string.valueof(att.ParentId).substring(0, 3);
                if(pId == keyPrefix) {
                    agrIds.add(att.ParentId);
                }
            }
            
            Map<Id,Apttus__APTS_Agreement__c> mapAgrvalues = new Map<Id,Apttus__APTS_Agreement__c>([Select Id, RecordType.Name, CA_NDA_Flag__c, Name, Apttus__Status_Category__c, Apttus__Status__c, CA_Is_Legacy_Contract__c from Apttus__APTS_Agreement__c where Id =: agrIds]);
            List<Apttus__APTS_Agreement__c> updateAgrList = new List<Apttus__APTS_Agreement__c>();
            
            //system.debug('Agreement List -- Attachment:::'+agrList);
            for(Attachment at : attList) {
                if(mapAgrvalues.containsKey(at.ParentId)) {
                    Apttus__APTS_Agreement__c agr = mapAgrvalues.get(at.ParentId);
                    if(Approval.isLocked(agr.Id) && agr.Apttus__Status_Category__c == Label.In_Approval && agr.Apttus__Status__c == Label.Pending_Approval) {
                        throw new TriggerException(Label.Attachment_Locked_Error_Message);
                    }
                     
                    if(agr.CA_Is_Legacy_Contract__c == Label.CA_Yes) {
                        agr.Apttus__Status_Category__c = Label.In_Authoring;
                        agr.Apttus__Status__c = Label.Author_Contract;
                        updateAgrList.add(agr);
                    }
                    
                }
            }
            if(updateAgrList.size() > 0) {
                update updateAgrList;
            }
        } catch(Exception e) {
            for(Attachment att : attList){
                att.addError(e.getMessage());
            }
            system.debug('Error Message::::'+e.getMessage());
        }
    }
}