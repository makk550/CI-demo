public with sharing class CQ_RedirectToAttachment {

//This class is to redirect the user to Standard Attchment page up on clicking on the Save button of the ROI Form.
   
    public PageReference redirectURL() {
        string newRFPId = ApexPages.CurrentPage().getParameters().get('newid');
        if(newRFPId <> null)
        {
            Client_Questionnaire_Request__c cqQual = [Select id,name from Client_Questionnaire_Request__c where id =: newRFPId ];
      
             return new Pagereference('/p/attach/NoteAttach?pid='+cqQual .id + '&parentname=' + cqQual .name + '&retURL=' + cqQual .id);
            
        }
        else
            return null;    
        
    }

}