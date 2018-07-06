trigger CaseReviewTrigger on Case_Review__c (before insert,after insert,before delete) {
    
    
    if(trigger.isBefore && trigger.isDelete){
        for(Case_Review__c cr: Trigger.old){
            if(!Label.Admin_Profile_Label.contains(userinfo.getProfileId().subString(0,15))){            
                cr.addError('You are not allowed to delete the case review record. Please contact your system administrator or Open a Service Desk ticket.');
            }
        }
    }
    
    
    if(trigger.isBefore && trigger.isInsert){
        
        Set<id> caseIdSet = new Set<id>();
        Set<String> combinationSet = new set<String>();
        /*Set<id> userId = new Set<id>();
        
        List<PermissionSetAssignment> caseReviewManagerPermissionList =[select id,AssigneeId from PermissionSetAssignment 
                                                                        where PermissionSetId =:Label.Case_Review_Manager_Label];
        
        if(!caseReviewManagerPermissionList.isEmpty()){
            for(integer i=0;i<caseReviewManagerPermissionList.size();i++){
                userId.add(caseReviewManagerPermissionList.get(i).AssigneeId);
            }
            
        }*/
        
        for(Case_Review__c cr: Trigger.new){
            //if((cr.Reviewer_Name__c==cr.Engineer_Name__c)|| userId.contains(cr.Reviewer_Name__c))
                caseIdSet.add(cr.Case__c);
            
            //else
              //  cr.addError('You are not allowed to create a case Review.You have to be an owner or a Manager of the owner of a case to create a case review.');
            
        }
        
        
        List<Case> caseList = [select caseNumber,(select name,Case__c,Reviewer_Name__c,Review_Type__c,Engineer_Name__c from Case_Reviews__r)
                               from Case where id in: caseIdSet];   
        
        if(!caseList.isEmpty()){
            for(Case c: caseList){                
                for(Case_Review__c cr: c.Case_Reviews__r){
                    String s = String.valueOf(cr.Reviewer_Name__c)+String.ValueOf(cr.Engineer_Name__c)+String.valueOf(cr.Case__c)+String.valueOf(cr.Review_Type__c);
                    combinationSet.add(s);
                }                
            }            
        }
      
        for(Case_Review__c cr: Trigger.new){
            String s = String.valueOf(cr.Reviewer_Name__c)+String.valueOf(cr.Engineer_Name__c)+String.valueOf(cr.Case__c)+String.valueOf(cr.Review_Type__c);
            if(combinationSet.contains(s)){
                cr.addError('You can\'t add another case record.As, a reviewer-engineer pair record of case review already exists.');
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        Set<id> userId = new Set<id>();
        
        List<PermissionSetAssignment> caseReviewManagerPermissionList =[select id,AssigneeId from PermissionSetAssignment 
                                                                        where PermissionSetId =:Label.Case_Review_Manager_Label];
        
        if(!caseReviewManagerPermissionList.isEmpty()){
            for(integer i=0;i<caseReviewManagerPermissionList.size();i++){
                userId.add(caseReviewManagerPermissionList.get(i).AssigneeId);
            }
        }
        
        List<sObject> caseReviewShareList = new List<sObject>();
        List<Id> listOfIds = new List<Id>();
        for(Case_Review__c cr: Trigger.new){
            if(cr.Engineer_Name__c!=cr.Reviewer_Name__c || cr.Engineer_Name__c==cr.Reviewer_Name__c){
                Case_Review__Share caseReviewShare = new Case_Review__Share();
                caseReviewShare.parentId = cr.id;
                caseReviewShare.UserOrGroupId = cr.Engineer_Name__c;
                caseReviewShare.RowCause = Schema.Case_Review__Share.RowCause.Is_Engineer__c;
                caseReviewShare.AccessLevel = 'Read';
                caseReviewShareList.add(caseReviewShare);
            }
        }
        
        try{
            if(!caseReviewShareList.isEmpty())
            insert caseReviewShareList;
        }
        
        catch(DMLException e){
            system.debug(e.getMessage());
        }
    }    
}