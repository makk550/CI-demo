public class CustomKnowledgeApprovalController {
    public String processId {get;set;}
    public String articleId {get;set;}
    public ProcessInstanceWorkitem piw {get;set;}
    public Knowledge__kav objArticle {get; set;}
    public String comments {get;set;}
    public PageReference redirectPage {get;set;}
    public AQI_Rating__c rating {get;set;}
    public List<SelectOption> aqiOptions {get;set;}
    public Boolean aqiOnly {get;set;}
    public Boolean hasRating {get;set;}
    public Boolean isPublisher {get;set;}

    public CustomKnowledgeApprovalController(){
        articleId = ApexPages.currentPage().getParameters().get('articleId');
        objArticle = [select Id,ArticleNumber,VersionNumber,Title,LastModifiedById,CreatedById from Knowledge__kav where id =:articleId];
        
        redirectPage = new PageReference('/apex/CustomKnowledgeEdit?articleId'+articleId);
        redirectPage.getParameters().put('articleId',articleId);
        redirectPage.setRedirect(true);
        
        aqiOnly = false;
        hasRating = false;

        rating = new AQI_Rating__c(Article_Id__c = objArticle.ArticleNumber,
                                   Article_Version_Id__c = objArticle.Id,
                                   Author__c = objArticle.CreatedById,
                                   Reviewer__c = UserInfo.getUserId()
                                   /*No_Duplicates__c = 'Yes',
                                   Appropriate_Template__c = 'Yes',
                                   Title_Reflects_Content__c = 'Yes',
                                   Search_Summary__c = 'Yes',
                                   Relevant_Resolution__c = 'Yes',
                                   Concise__c = 'Yes',
                                   Sensitive_Information_Removed__c = 'Yes',
                                   User_s_Perspective__c = 'Yes'*/);
        
        aqiOptions = setAQIOptionValues();
        isPublisher = userIsPublisher();
        
        try {
            processId = ApexPages.currentPage().getParameters().get('id');
            piw = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId = :processId];
        } catch (Exception e) {
            aqiOnly = true;
        }  
    }

    public Boolean userIsPublisher() {
        isPublisher = false;
        String userId = UserInfo.getUserId() ;
        for (PermissionSetAssignment psa : [SELECT PermissionSetId,AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Knowledge_Approver_Permission' ORDER BY Assignee.Name ASC]) {
            if (psa.AssigneeId == userId) {
                isPublisher = true;
            }
        }
        return isPublisher;
    }
    public PageReference Approve(){
        if (!validateAQI()) {
            return null;
        }
        if (!isPublisher) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Only approvers may approve or reject an article'));
            return null;
        }   
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        //req.setComments(objLead.Comments__c);
        req.setAction('Approve');
        req.setWorkitemId(piw.id);
        req.setComments(comments);
        if (hasRating) {
            insert rating;
        }
        Approval.ProcessResult result =  Approval.process(req);
        //update objLead;
        return redirectPage ;
    }
   
    public PageReference Reject(){
        if (!validateAQI()) {
            return null;
        }
        if (String.isBlank(comments)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Comments are required when rejecting an article.'));
            return null;
        }
        if (!isPublisher) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Only approvers may approve or reject an article'));
            return null;
        }
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        //req.setComments(objLead.Comments__c);
        req.setAction('Reject');
        req.setWorkitemId(piw.id);
        req.setComments(comments);
        if (hasRating) {
            insert rating;
        }
        Approval.ProcessResult result =  Approval.process(req);
        //update objLead;
        return redirectPage ;      
    }
   
    public PageReference Cancel(){
        return redirectPage ;
    }

    public Boolean validateAQI() {
        Boolean valid = true;
        if ((rating.No_Duplicates__c != null) || (rating.Appropriate_Template__c != null) || (rating.Title_Reflects_Content__c != null) || (rating.Search_Summary__c != null) || (rating.Relevant_Resolution__c != null) || (rating.Concise__c != null) || (rating.Sensitive_Information_Removed__c != null) || (rating.User_s_Perspective__c != null)) {
            if ((rating.No_Duplicates__c == null) || (rating.Appropriate_Template__c == null) || (rating.Title_Reflects_Content__c == null) || (rating.Search_Summary__c == null) || (rating.Relevant_Resolution__c == null) || (rating.Concise__c == null) || (rating.Sensitive_Information_Removed__c == null) || (rating.User_s_Perspective__c == null)) {
                valid = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'All AQI Questions must be answered to submit.'));
            }
            hasRating = true;
        }
        return valid;

    }

    public PageReference submitAQI() {
        if (!validateAQI()) {
            return null;
        }
        insert rating;
        return redirectPage;
    }
    
    public List<SelectOption> setAQIOptionValues() {
        List<SelectOption> aqiOptions = new List<SelectOption>();
        aqiOptions.add(new SelectOption('Yes','Yes'));
        aqiOptions.add(new SelectOption('No','No'));
        return aqiOptions;
    }
}