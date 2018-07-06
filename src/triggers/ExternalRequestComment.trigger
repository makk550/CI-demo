trigger ExternalRequestComment on External_Request_Comments__c (after insert , after update) {
    
     //Whenever a comment is created , callout is made to CSM to create Work Log    
     
     Map <Id,External_RnD__c> externalRequestMap = new Map<Id,External_RnD__c>();
     Map<Id, CaseComment> caseCommentMap = new Map<Id,CaseComment>();
     set<Id> externalRequestIdSet = new set<Id>();
     List<CaseComment> caseCommentList = new List<CaseComment>();
     if((trigger.isInsert) && trigger.isAfter){
           for(External_Request_Comments__c comment : Trigger.New){
                 if(!(UserInfo.getUserId().contains(Label.saas_ops_integration_user))){
                    CalloutToCSM.createComment(comment.Id);    
                 }
                 externalRequestIdSet.add(comment.parentId__c); 
           }  
           externalRequestMap =  new Map<Id,External_RnD__c>([select id ,Name, case__c,Reference_ID__c from External_RnD__c where Id IN :externalRequestIdSet ]);
           for(External_Request_Comments__c comment : Trigger.New){
                CaseComment caseComment = new CaseComment();
                caseComment.ParentId = externalRequestMap.get(comment.parentId__c).case__c ;
                caseComment.CommentBody = 'CSM Incident Id # '+externalRequestMap.get(comment.parentId__c).Reference_ID__c+'\r\n'+'External Request # '+externalRequestMap.get(comment.parentId__c).Name+'\r\n'+comment.Comments__c;
                caseCommentList.add(caseComment);
           }
           system.debug('++++++++++++++LIST'+caseCommentList);
           insert caseCommentList;
      }
}