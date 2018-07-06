trigger CaseCommentTrigger on CaseComment (Before insert, Before update,After update,After insert,Before delete){

  //Commented the bypass code as we dont have initial case load - velud01 - dec 2,2014
    if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15)))
       return;
    
    //US371683---START
    if(String.isNotBlank(UtilityFalgs.caseCommentBodyValue) || String.isNotBlank(UtilityFalgs.skipPrivateCaseCommentTrigger)){
        return ;
    }
    //US371683---END
    
    Profile p = [select name from Profile where id =:UserInfo.getProfileId()];
    String pname=p.name;
                 
    Set<Id> caseSet=new Set<Id>();
    List<Case> caseList = new List<Case>();  
    set<Id>privateCommentCaseSet = new set<Id>();
    
    if(Trigger.isDelete){          
        for(CaseComment cc:Trigger.old){
            if(!(pname.contains('Integration') || pname.contains('Admin'))) {
                cc.addError('You are not allowed to delete the record. Please contact System Administrator.');
            }
            if(cc.isPublished){
                caseSet.add(cc.parentId);
            }
            else{
                privateCommentCaseSet.add(cc.parentId);
            }
        }
    }
    else if((Trigger.isBefore && (trigger.isupdate || trigger.isinsert))){
        for(CaseComment recCasComm: Trigger.new){
            if(trigger.isupdate  && !(pname.contains('Integration') || pname.contains('Admin'))
               && ((Trigger.oldMap.get(recCasComm.id).CommentBody)!=(recCasComm.CommentBody)))
            {
                recCasComm.addError('You are not allowed to Edit the comment body. Please contact your System Administrator.');
            }
            if(recCasComm.ispublished){            
                caseSet.add(recCasComm.parentId);
            }
            else{
                privateCommentCaseSet.add(recCasComm.parentId);
            }
            if(CaseGateway.isExternalUser()){
                if(recCasComm.CommentBody.contains(label.Email2Case_subject)){
                    recCasComm.CommentBody = recCasComm.CommentBody.replace(label.Email2Case_subject,'');
                    UtilityFalgs.callbackSubject='Email';
                    UtilityFalgs.callbackSource='Email';
                }else if(!recCasComm.CommentBody.contains(system.Label.files_from_ca) && !recCasComm.CommentBody.contains(system.Label.files_from_customer)){ //US201990 - not create case update task for files_from_ca & US344581 added condition to add only file callback
                    UtilityFalgs.callbackSubject='Case Update';
                    UtilityFalgs.callbackSource='CSO';
                }else if(recCasComm.CommentBody.contains(system.Label.files_from_ca) || recCasComm.CommentBody.contains(system.Label.files_from_customer)){ //US201990 - not create Call task for files_from_ca  & US344581 added condition to add only file callback
                    UtilityFalgs.callbackSubject='';
                    UtilityFalgs.callbackSource='';
                }
            }
        }
    }
    
    if(caseSet!=null || privateCommentCaseSet!=null){
        caseSet.addAll(privateCommentCaseSet);  
        caseList=[select id,Subject from case where id in :caseSet];        
    }    
    if(caseList!=null && caseList.size()>0)
    {
        //Commented as part of US78177
        /*
if((userinfo.getProfileId().substring(0,15)!=label.EAI_Integration_NON_SSO_Profile)&& (!UtilityFalgs.sentAlert))
{

UtilityFalgs.sendMail(caseList);
UtilityFalgs.sentAlert=true;
} */
        for(Integer i = 0 ;i<caseList.Size() ;i++){
            if(privateCommentCaseSet.contains(caseList[i].Id)){
                caseList.remove(i);
            }
        }
        Database.SaveResult[] results = Database.Update(caseList, false);
        for(Integer i=0;i<results.size();i++){
            if (!results.get(i).isSuccess()){
                String errorMsg = results.get(i).getErrors().get(0).getMessage();
                if(!Trigger.isDelete)
                    Trigger.new[0].addError(errorMsg);
                else
                    Trigger.old[0].addError(errorMsg);                    
            }
            
        }
        
    } 
}