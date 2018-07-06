public with sharing class RFP_RedirectToAttachment {

    public PageReference redirectURL() {
        string newRFPId = ApexPages.CurrentPage().getParameters().get('newid');
        if(newRFPId <> null)
        {
            RFP_Qualification__c rfpQual = [Select id,name, rfp__c from RFP_Qualification__c where id =: newRFPId ];
      
           //  return new Pagereference('/p/attach/NoteAttach?pid='+newRFPId + '&parentname=' + rfpQual.name + '&retURL=' + rfpQual.rfp__c);
             return new Pagereference('/p/attach/NoteAttach?pid='+rfpQual.rfp__c + '&parentname=' + rfpQual.name + '&retURL=' + rfpQual.rfp__c);
            
        }
        else
            return null;    
        
    }

}