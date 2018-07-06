public class UtilityFalgs
{
    
     public static boolean bCaseAssignedFlag=true;
    public static boolean bCaseClosedFlag=true;
    public static boolean bCaseTransferredFlag=true;
    public static boolean bCaseReOpenedFlag=true;
    public static boolean bCaseSLOFlag=true;
    public static boolean callbackCreated=false;
    Public static boolean relatedcaseFlag=true;
    public static string  callbackSubject='Call';
    public static string  callbackSource='Phone';
    public static boolean createGSS=false;
    public static boolean sentAlert=false;
    public static boolean updateTask = false;
    public static boolean updateExternalRequest = false;
    public static boolean isDefectUpdate = false;
    public static boolean createWRTasks = false; // flag to track creation of workaround and resolution tasks
    public static boolean isCaseReopend = false; // flag to check if reopen scenario is executed  US133511
    //US134926
    public static boolean isInitialCallBackTaskCreated;
    public static boolean oneTaskCreate = true;
    //US138062
    public static boolean recursiveCheck = true;
    public static boolean skipSftpCallback=false;
    public static boolean isQueueJumpingEnabled=false;
    public static boolean isCaseInsert = false; //flag to keep track of new case inserted  
    public static boolean isCaseConcern = false; //US447507  flag to check caseconcern record type 
    //***US108116 - Lifecycle: Troubleshooting Stage Reporting
    public static boolean createStageGSSTransactions=false;
    public static boolean isSEActionTaskCreated = false; //Timeboxing
    public static boolean clearManagerActionValues = false; //Timeboxing
    public static string caseCommentBodyValue = ''; //US367725
    public Static boolean caseConcernparentComment=false;
    public static string skipPrivateCaseCommentTrigger = '';//US289127--enhancement to remove case comment trigger
    public static Map<String,String> stageGSSTransCode = new Map<String,String>{'1. Problem Identification'=>'LC1',
                                                                  '2. Knowledge Search'=>'LC2',
                                                                  '3. Cause Determination'=>'LC3',
                                                                  '4. Solution Identification'=>'LC4',
                                                                  '5. Solution Provided'=>'LC5',
                                                                  '6. Solution Deferred'=>'LC6',
                                                                  '7. Closed'=>'LC7',
                                                                  '1. Initial Customer Contact'=>'LC1',
                                                                  '2. Determine Cause'=>'LC2',
                                                                  '3. Address Concern'=>'LC3',
                                                                  '4. Communicate Resolution'=>'LC4',
                                                                  '5. Close Concern'=>'LC5',
                                                                  '1. Initial Triage'=>'LC1',      
                                                                  '2. Knowledge Transfer'=>'LC2',
                                                                  '3. Customer Engagement'=>'LC3',
                                                                  '4. Validate Barrier'=>'LC4',    
                                                                  '5. Mitigate Barrier'=>'LC5',    
                                                                  '6. Capture Knowledge'=>'LC6',    
                                                                  '7. End Engagement'=>'LC7'       
                                                                  };

    public static boolean isTPCLogicExecuted = false;  
    public static boolean isVDALogicExecuted = false;                                                                  
    public static boolean isSDMOwnerLogicExecuted = false;
    //Commmented as part of US78177 - Usability: In email notifications, include the Case Comment that was added to the case
    /*                                                                   
    public static void sendMail(LIST<Case> caseId)
    {
       List<Messaging.SingleEmailMessage> emails=new List<Messaging.SingleEmailMessage>();
       String user_info=UserInfo.getUserid();
       Map<Id,User> toUser;
       List<Id> emailId=new List<Id>();
       List<Case> casedet=new List<Case>([select id,OwnerId,caseNumber,site_id__c,site_name__c,Severity__c,Subject from Case where id in :caseId]);
        if(casedet!=null && casedet.size()>0)
        {
         for(Case caseRec:casedet)
         {   
           String body='A case for which you are an owner or Case Team Member has been updated.<br/><br/>';
           body += 'Case : '+caseRec.CaseNumber  +'<br/>' ;
           body += 'Tops Site ID : '+caseRec.Site_Id__c  +'<br/>';
           body += 'Site Association : '+caseRec.site_name__c+'<br/>';
           body += 'Severity : '+caseRec.Severity__c  +'<br/>';
           body += 'Subject : '+caseRec.Subject +'<br/>';
           body += 'Last Updated By : '+UserInfo.getName() +'<br/><br/><br/>';
           body += 'Thanks & Regards,<br/>' +
          'CA Support.';

      String owner=caseRec.OwnerId;
            List<CaseTeamMember> team=new List<CaseTeamMember>();
             if(!Test.isRunningTest())
             {  if( caseRec.OwnerId!=user_info && (!owner.startsWith('00G')))  
                    emailId.add(caseRec.OwnerId);
       
                team = [select Id,parentid,memberid from CaseTeamMember where ParentId =: caseRec.Id and  MemberId !=: user_info ];
             }
             else
             {
                  emailId.add(caseRec.OwnerId);
                 team = [select Id,parentid,memberid from CaseTeamMember ];
             }
              System.debug('size of team'+team.size()); 
            if(team!=null && team.size()>0)
            {
               
                for(CaseTeamMember memRec:team )
                {
                    if(memRec.MemberId!=user_info)
                        emailId.add(memRec.MemberId);
                }
            }
            if(emailId!=null)
             toUser=new Map<Id,User>([select id,email from User where id in :emailId]);
              
              for(User userRec : toUser.values())
              {
                Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                email.setSubject('SC Case :'+caseRec.caseNumber+' Updated');
                email.setHTMLBody(body);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(UserRec.id);
                emails.add(email);
              }  
             
         }
         
        if(emails!=null)
        {
            Messaging.sendEmail(emails);
        } 
      }
    } */
    
    public static void sendNotificationToAssgnUser(LIST<Case> caseList)
    {
       List<Messaging.SingleEmailMessage> emails=new List<Messaging.SingleEmailMessage>();
       String user_info=UserInfo.getUserid();
       Map<Id,User> toUser;
       List<Id> emailId=new List<Id>();

        if(caseList!=null && caseList.size()>0)
        {
         for(Case caseRec:caseList)
         {   
           String body='Case ' + caseRec.caseNumber + ' has been assigned to you. Please click on the link below to view the record.<br/><br/>';
           String urlCode = System.Label.Salesforce_Base_Url ; //String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
           body = body + '<a href="' + urlCode + '/'+caseRec.Id + '">'+urlCode+ '/'+caseRec.Id +'</a>';

            String owner=caseRec.OwnerId;
            List<CaseTeamMember> team=new List<CaseTeamMember>();
             if(!Test.isRunningTest())
             {
                 if( caseRec.OwnerId!=user_info && (!owner.startsWith('00G')))  
                 {
                     emailId.add(caseRec.OwnerId);
                 }
             }
             else
             {
                emailId.add(caseRec.OwnerId);
             }

            if(emailId!=null)
            {
                toUser=new Map<Id,User>([select id,email from User where id in :emailId]);
            }
              
            for(User userRec : toUser.values())
            {
                Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                email.setSubject('Case : '+caseRec.caseNumber+' assigned to you.');
                email.setHTMLBody(body);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(UserRec.id);
                emails.add(email);
            }  
             
         }
         
        if(emails!=null)
        {
            Messaging.sendEmail(emails);
        } 
      }
    }  
    
    //US78177 - Usability: In email notifications, include the Case Comment that was added to the case
    @InvocableMethod
    public static void sendEmailNotifications(List<CaseComment> caseCommentList){
      Set<Id> setOfCaseIds = new Set<Id>();
      Map<Id,Boolean> mapOfPublicComment = new Map<Id,Boolean>();
      if(!isAttachmenFileUploadUser()){
          List<Id> caseIdList = new List<Id>();
          Map<Id,String> caseIdCommentTextMap = new Map<Id,String>();
          set<Id> setOfCase = new set<Id>();//US197882
          for(CaseComment caseCommentRec:caseCommentList){
              caseIdList.add(caseCommentRec.parentId);
              if(caseCommentRec.IsPublished){
                 mapOfPublicComment.put(caseCommentRec.parentId, caseCommentRec.IsPublished); 
              }
              setOfCase.add(caseCommentRec.parentId);//US197882
              caseIdCommentTextMap.put(caseCommentRec.parentId,caseCommentRec.CommentBody); //TODO: check if multiple comments are added at a time.
          }
    
          if(caseIdList!= null && caseIdList.size()>0 && setOfCase<>null && setOfCase.size()>0){//US197882---START
              system.debug('setOfCase: '+setOfCase);
              List<Task> listOfTask = [Select id, whatId, Source__c, subject from Task where whatId IN:setOfCase AND status!=:'Closed' AND subject=:'File'];
              if(listOfTask<>null && listOfTask.size()>0){
                  List<Id> listOfCaseIds = new List<Id>();
                  for(Task taskObj:listOfTask){
                      if(caseIdCommentTextMap.get(taskObj.whatId).contains(system.Label.files_from_customer) || (caseIdCommentTextMap.get(taskObj.whatId).contains('Attachments:'))){   
                      }else{
                          listOfCaseIds.add(taskObj.whatId);
                      }
                  }
                  
                  if(listOfCaseIds<>null && listOfCaseIds.size()>0){
                    sendNotificationToCaseOwnerandTeamMemebers(listOfCaseIds,caseIdCommentTextMap,mapOfPublicComment);    
                  }
              }else{//US197882---END
                  sendNotificationToCaseOwnerandTeamMemebers(caseIdList,caseIdCommentTextMap,mapOfPublicComment);
              }
          }
      }else{//US303641
          if(caseCommentList<>null && caseCommentList.size()>0){
              for(CaseComment caseCommentRec:caseCommentList){
                  if(caseCommentRec.IsPublished){
                    setOfCaseIds.add(caseCommentRec.ParentId);   
                  }
              }
          }
          
          if(setOfCaseIds<>null && setOfCaseIds.size()>0){
              List<Case> listOfCase = new List<Case>();
              for(Id idValue:setOfCaseIds){
                  Case caseRecObj = new Case(id=idValue,Case_mgmt_LastUpdatedBy_User__c=userinfo.getUserId(),Case_mgmt_LastUpdateDT__c=system.now()); //Case_mgmt_LastUpdatedBy__c=userinfo.getName(),
                  listOfCase.add(caseRecObj);
              }
              if(listOfCase<>null && listOfCase.size()>0){
                  try{
                      update listOfCase;    
                  }Catch(DMLException e){
                      System.debug('Exception e:'+e.getMessage());    
                  }
              }
          }
      }//US303641
    }
    
    public static void sendNotificationToCaseOwnerandTeamMemebers(List<Id> caseIdList,Map<Id,String> idTextMap,Map<Id,Boolean> mapOfPublicComment){
              try{
                    List<Messaging.SingleEmailMessage> emails=new List<Messaging.SingleEmailMessage>();
                    List<Case> caseList = [select id,Confidential_Attachments__c,Case_mgmt_LastUpdatedBy_User__c,Case_mgmt_LastUpdateDT__c,caseNumber,Site_Id__c,site_name__c,Severity__c,OwnerId,Subject from case where id = : caseIdList]; //Case_mgmt_LastUpdatedBy__c, 
                    Map<Id,List<Id>> caseNotifyToUsersMap = UtilityFalgs.toUserList(caseList);
                    System.debug('caseNotifyToUsersMap:'+caseNotifyToUsersMap); 
                    String emailbody ='';
                    List<Case> listOfCase = new List<Case>();//US303641
                    
                     for(Case caseRec: caseList){
                                //US303641
                                 if(mapOfPublicComment<>null && mapOfPublicComment.get(caseRec.Id)==true){
                                    //caseRec.Case_mgmt_LastUpdatedBy__c = userinfo.getName();
                                    caseRec.Case_mgmt_LastUpdatedBy_User__c = userinfo.getUserId();
                                    caseRec.Case_mgmt_LastUpdateDT__c = system.now();
                                    listOfCase.add(caseRec);    
                                 }
                                //US303641
                                List<Id> userIdList = caseNotifyToUsersMap.get(caseRec.Id);
                                /*
                                //DE199235 user story change
                                if(caseRec.Confidential_Attachments__c){
                                    // when case team member empty it will throw a null point exception
                                    if(userIdList ==null){
                                        userIdList = new List<Id>(); 
                                    }
                                   userIdList.add(userInfo.getUserId()); 
                                } */
                             //US208994 - starts - Notify all(including the comment originator) if a case with Confidnetial Attachment is closed

                                String str = label.ClousreCommentBody_ConfidentialAttachment;
                                String target = '00xxxxxx';
                                String replacement = caseRec.CaseNumber;
                                String finalComment = str.replace(target ,replacement);

                                String commentTxt = idTextMap.get(caseRec.Id);

                                if(commentTxt == finalComment){
                                     if(userIdList ==null){
                                        userIdList = new List<Id>(); 
                                    }
                                   userIdList.add(userInfo.getUserId()); 
                                }

                                //US208994 - ends                                  
                                System.debug('######'+userIdList);
                                if(userIdList!=null && userIdList.size()>0){
                                    Set<Id> duplicateRemove = new Set<Id>();
                                    duplicateRemove.addAll(userIdList);
                                        for(Id userId: duplicateRemove){
                                              emailbody = UtilityFalgs.emailBody(caseRec, idTextMap.get(caseRec.Id)); 
                                              System.debug('userId:'+userId+'\n Email body:'+emailbody);
                                              Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                                              email.setSubject(System.label.SCCase+' :'+caseRec.caseNumber+' '+System.label.Updated);
                                              //email.setPlainTextBody(emailbody);                                                    email.setPlainTextBody(emailbody);
                                              email.setHtmlBody(emailbody);
                                              email.setSaveAsActivity(false);
                                              email.setTargetObjectId(userId);
                                              emails.add(email);
                                        }
                                }
                      }
                      System.debug('###$$$$'+emails);
                      if(emails!=null)
                      {
                          System.debug('emails.size:'+emails.size());
                          Messaging.sendEmail(emails);
                          //US303641
                          try{
                            update listOfCase;    
                          }Catch(DMLException e){
                            system.debug('Case update exception: '+e.getMessage());    
                          }
                          //US303641
                      }   
              }
              catch(Exception e){
                  System.debug('Exception e:'+e.getStackTraceString());
              }

      }
    
    public static String emailbody(Case caseRec,String commentBody){
            System.debug('====='+commentBody);
            String body = System.label.CaseUpdated+' <br/><br/>';
         // body += '\n' +System.label.Case+' : '+caseRec.CaseNumber ;
            body += '\n' +System.label.Case+' : '+'<a href="'+System.Label.Salesforce_Base_Url+'/'+caseRec.id+'">'+caseRec.CaseNumber+'</a> <br/>' ;
            body += '\n' +System.label.TopsSiteID+' : '+String.valueOf(caseRec.Site_Id__c)+'<br/>' ; 
            body += '\n' +System.label.SiteAssociation+' : '+String.valueOf(caseRec.site_name__c) + '\t\n <br/>';
            body += System.label.Severity+' : '+String.valueOf(caseRec.Severity__c) + '\t\n <br/>'; 
            body += System.label.Subject+' : '+String.valueOf(caseRec.Subject )+ '\t\n <br/>'; 
            body += System.label.LastUpdatedBy+' : '+String.valueOf(UserInfo.getName())+ '\t\n <br/>' ; 
            body += System.label.DetailsoftheUpdate+': <br/>'; 
            //body += '\n' +commentBody+'\n';
            body += '\n' +commentBody.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>')+'\n'; 
            return body;
    }
    
    public static Map<Id,List<Id>> toUserList(List<Case> caseList){
      Map<Id,List<Id>> caseIdToUserMap = new Map<Id,List<Id>>();      
      List<Id> caseIdList = new List<Id>();
      for(Case caseRec : caseList){
        caseIdList.add(caseRec.Id);
      }

      List<CaseTeamMember> caseTeamMemberList =  new List<CaseTeamMember>();
      caseTeamMemberList = [select id,parentid,memberid from CaseTeamMember where parentid= :caseIdList
                                                    and memberid!= :UserInfo.getUserid()];
      System.debug('caseTeamMemberList:'+caseTeamMemberList);
       System.debug('CaseConcern Test:'+caseTeamMemberList);
       List<Id> teamMemberIDList;
       for(CaseTeamMember ctm : caseTeamMemberList){
               teamMemberIDList = new List<Id>();
                if(caseIdToUserMap.containsKey(ctm.parentid)){
                       teamMemberIDList =  caseIdToUserMap.get(ctm.parentid);
                       teamMemberIDList.add(ctm.memberId);
                       caseIdToUserMap.put(ctm.parentid,teamMemberIDList);
                }
                else{
                        teamMemberIDList.add(ctm.memberId);
                        caseIdToUserMap.put(ctm.parentId,teamMemberIDList);
                }
       }
        
       //For adding case owner
       for(Case c : caseList){
          teamMemberIDList = new List<Id>();
          if( !String.valueOf(c.OwnerId).startsWith('00G') && c.OwnerId != UserInfo.getUserid()){
                    System.debug('c.OwnerId:'+c.OwnerId+'-String.valueOf(c.OwnerId).startsWith(00G):'+String.valueOf(c.OwnerId).startsWith('00G'));
                    if(caseIdToUserMap.containsKey(c.Id)){
                          teamMemberIDList = caseIdToUserMap.get(c.Id);
                          teamMemberIDList.add(c.OwnerId);
                          caseIdToUserMap.put(c.Id,teamMemberIDList);
                    }
                    else{
                          teamMemberIDList.add(c.OwnerId);
                          caseIdToUserMap.put(c.Id,teamMemberIDList);
                    }
          }
       }
      System.debug('###################caseIdToUserMap:'+caseIdToUserMap);      
      return caseIdToUserMap;
    } 
    // Method to check if current user is EAI attachment integration user 
    public static Boolean isAttachmenFileUploadUser(){
        return Label.Service_Cloud_Attachment_User.contains(userinfo.getUserId().substring(0,15)) ;
    }
}