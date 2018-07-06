trigger MoveAttachmentToAgreement on Apttus__APTS_Agreement__c (after insert) {
    List<Attachment> updateattachmentlist = new List<Attachment>();//adding attachment to agreement
    List<Attachment> deleteattachmentlist = new List<Attachment>();//deleting attachment from ddr
    
    for(Apttus__APTS_Agreement__c agreement : [SELECT Id, CA_DDR__c FROM Apttus__APTS_Agreement__c Where Id IN: trigger.new]) //always returns one row
    {
        if(agreement.CA_DDR__c != null) {
            List<Attachment> atch =[select Id,ParentId, Name, Body from Attachment where ParentId = :agreement.CA_DDR__c];
            for(Attachment at: atch)
            {    
                Attachment a = new attachment();
                a.Name = at.Name;
                a.ParentId=agreement.Id;
                a.body = at.body;
                deleteattachmentlist.add(at);
                updateattachmentlist.add(a);
                //  delete at;
            }
        }
        
    }
    if(updateattachmentlist != null)
    {
        insert updateattachmentlist;
    }
    if(deleteattachmentlist != null)
    {
        delete deleteattachmentlist;
    }
}