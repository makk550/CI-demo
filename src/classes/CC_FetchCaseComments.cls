@RestResource(urlMapping='/casecomments')
global class CC_FetchCaseComments  {
    
    //This will return only Private Comments of a Give ID
    @HttpGet
    global static List<CaseComment> getCasePrivateComments() {
    
        system.debug(RestContext.request+'*****');
        String caseID = RestContext.request.params.get('caseID');
        String commentID = RestContext.request.params.get('commentID');
        System.debug('caseID:'+caseID+' commentID='+commentID);
        Integer pendingCustomerCaseCount = 0;
        try {
            if(String.isNotBlank(caseID)){
                String query='select id,CommentBody,CreatedBy.Name,CreatedDate from CaseComment where ParentID=\''+ caseID + '\' and IsPublished=false ';
                if (commentID!='' && commentID!=null){
                    commentID = commentID.replaceAll('"','');
                    query += ' and ID=\''+commentID+'\'' ;
                }    
                List<CaseComment> caseList = Database.query(query); 
                pendingCustomerCaseCount = caseList.size();
               return caseList;
            }else
                return null;
            
        } catch (Exception e) {
            return null;
        }
    }
    
    @HttpPost
    global static ID InsertCasePrivateComments(String commentbody, ID caseID) {
        CaseComment thisCaseCom = new CaseComment(
            Commentbody=commentbody.unescapeUnicode(),
            IsPublished=false,
            ParentID=caseID);
        insert thisCaseCom;
        return thisCaseCom.Id;
    }    
}