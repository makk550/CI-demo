@RestResource(urlMapping='/UpdateDefect/*')

    global class RallyCustomRestService{
       public static  Response resMsg;
       global class Defect {
        
          global String defectNumber ;
          global String defectId ;
          global String subject ;
          global String description ;
          global String status; 
          global String defectSeverity; 
          global String defectPriority;
          global String defectOwner;
          global String targetedReleaseNumber;
          global String targetReleaseDate ;
          global String resolution ;
          global String updatedBy;
          global String blocked;
          global String blockedReason;
          global String workspaceName ;
          public String defectType;
          global List<comment> comments;
    }

       
       @HttpPut
        global static void callDefectUpdate(Defect defect) {
             
             system.debug('Request Object--------'+defect);
             String jsonRequest = JSON.serialize(defect);
             RestResponse res = RestContext.response;
             resMsg = new response();
             String existingStatus='';
             res.addHeader('Content-Type', 'application/json');
             if(validateRequest(defect)){
             
                 String caseCommentBody ='';
                  String commentHeader ='';
                 Boolean isOldNull = false;
                 Boolean isNewNull = false;
                 Savepoint sp = Database.setSavepoint();
                 try{
                     Defect__c defectRec = new Defect__c();  
                     String UUID = defect.defectId.substringAfterLast('/'); // extract the UUID of defect 
                     List<Defect__c> defectRecList = [select id ,Name ,Type__c,Status__c,Defect_Owner__c,Priority__c ,Severity__c ,Subject__c ,    Description__c ,Resolution__c ,Targeted_Release_Number__c , Target_Release_date__c,Blocked__c,Blocked_Reason__c,R_D_System__c 
                                                      from Defect__c 
                                                      where name =: defect.defectNumber and Defect_UUID__c  =: uuid and R_D_System__c =:defect.workspaceName 
                                                      limit 1
                                                     ];                           
                     List<Defect_Case_Association__c> defectCaseAssociationList = new List<Defect_Case_Association__c>();                               
                     List<caseComment> caseCommentList = new List<caseComment>(); 
                     List<Defect_Comment__c>defectCommentList = new  list<Defect_Comment__c> ();  
                     List<caseComment> caseCommLst = new List<caseComment>();                        
                     if(defectRecList !=null && defectRecList.size()>0){
                        defectRec = defectRecList[0];
                        existingStatus=defectRec.Status__c;
                        defectCaseAssociationList = [select id , case__c,case__r.status from Defect_Case_Association__c where defect__c =:defectRec.Id]; 
                      //  defectCaseAssociationList = [select id , case__c from Defect_Case_Association__c where defect__c =:defectRec.Id];                             
                        //US218164: DefectInteg: Stop adding empty (Ghost) case comments for fields that are not tracked
                        String ghostComment = 'Rally Defect #  '+defectRec.Name+' Updated by '+defect.updatedBy;
                        commentHeader = caseCommentBody = 'Rally Defect #  '+defectRec.Name+' Updated by '+defect.updatedBy;
                        
                        
                        if(defect.defectType!=null && defect.defectType!='' && defectRec.Type__c !=defect.defectType && defect.defectType !='Information Request'){
                            caseCommentBody+= '\r\n Defect type changed from '+defectRec.Type__c +' to '+ defect.defectType;
                            defectRec.Type__c = defect.defectType;
                            }
                         
                         //Made change as part of a defect user story 
                          if(defect.defectType!=null && defect.defectType!='' && defect.defectType =='Information Request' && defectRec.Type__c !='Request for Information'){
                            caseCommentBody+= '\r\n Defect type changed from '+defectRec.Type__c +' to  Request for Information';
                            defectRec.Type__c = 'Request for Information';   
                          }
                         
                         
                         
                        if(defect.status!=null && defect.status!='' && defectRec.Status__c!=defect.status ){
                            caseCommentBody+= '\r\n Defect Status changed from '+defectRec.Status__c +' to '+ defect.status;
                            defectRec.Status__c = defect.status;
                            
                        }
                        if(defect.defectPriority!=null && defect.defectPriority!='' && defectRec.Priority__c!=defect.defectPriority ){
                            caseCommentBody+= '\r\n Defect Priority changed from '+ defectRec.Priority__c+' to '+defect.defectPriority;
                            defectRec.Priority__c = defect.defectPriority;
                            
                        }
                        if(defectRec.Defect_Owner__c!=defect.defectOwner){
                            isOldNull = checkEmpty(defectRec.Defect_Owner__c);
                            isNewNull = checkEmpty(defect.defectOwner);
                            if(!(isOldNull && isNewNull)){ 
                                caseCommentBody+= '\r\n Defect Owner changed from '+ defectRec.Defect_Owner__c+' to '+defect.defectOwner;
                            }
                            defectRec.Defect_Owner__c = defect.defectOwner; 
                            
                        }
                        if(defectRec.Targeted_Release_Number__c!=defect.targetedReleaseNumber){
                            
                           // if(defectRec.Targeted_Release_Number__c==null || defectRec.Targeted_Release_Number__c=='' ||  defectRec.Targeted_Release_Number__c.trim().length()==0){
                                isOldNull = checkEmpty(defectRec.Targeted_Release_Number__c);
                           // }
                          //  if(defect.targetedReleaseNumber==null ||defect.targetedReleaseNumber==''||defect.targetedReleaseNumber.trim().length()==0){
                                isNewNull = checkEmpty(defect.targetedReleaseNumber);
                           // }
                           
                           
                            if(!(isOldNull && isNewNull)){  
                                caseCommentBody+= '\r\n Targeted Release Number changed from '+ defectRec.Targeted_Release_Number__c+' to '+defect.targetedReleaseNumber;                        
                        
                            }
                            defectRec.Targeted_Release_Number__c = defect.targetedReleaseNumber;
                            
                        }
                       
                        list<String> splitDateFormat = new List<String>();
                        Date targetDate;
                        String formattedTargetReleaseDate='';
                        if(defect.targetReleaseDate!=null && defect.targetReleaseDate.contains('T')){
                                String targetReleaseDate = defect.targetReleaseDate.replace('.','K').replace('T',' ');
                                splitDateFormat = targetReleaseDate.split('K');
                                targetDate =  Date.valueOf(splitDateFormat[0]); 
                                formattedTargetReleaseDate = splitDateFormat[0];
                        }
 
                          if(defectRec.Target_Release_date__c!= targetDate){
                            if(String.valueof(defectRec.Target_Release_date__c)!=null && String.valueof(defectRec.Target_Release_date__c)!=''){
                                caseCommentBody+= '\r\n Targeted Release Date changed from '+ defectRec.Target_Release_date__c;//.format('yyyy-MM-dd HH:mm:ss');
                               
                                
                            }
                            else{
                               caseCommentBody+= '\r\n Targeted Release Date changed from '+ defectRec.Target_Release_date__c;
                               
                            }
                             if(formattedTargetReleaseDate!=''){
                                caseCommentBody+= ' to '+Date.valueOf(formattedTargetReleaseDate);
                            }
                            else{
                                 caseCommentBody+= ' to null';
                                
                            }
                            defectRec.Target_Release_date__c = targetDate;

                        }
                      /* if(defect.comments!=null && defect.comments.size()>0){
                            caseCommentBody+= '\r\n Discussion '+defect.comments[0].comment;
                        }*/
                        if(defect.resolution !=null && defect.resolution!='' && defectRec.Resolution__c!=defect.resolution){
                            caseCommentBody+= '\r\n Resolution changed from '+ defectRec.Resolution__c+' to '+defect.resolution;
                            defectRec.Resolution__c = defect.resolution;
                        }
                        if(defectRec.Blocked__c != Boolean.valueof(defect.blocked)){                        
                            caseCommentBody+= '\r\n Blocked changed from '+ String.valueof(defectRec.Blocked__c)+' to '+defect.blocked;
                            defectRec.Blocked__c = Boolean.valueof(defect.blocked);
                        }
                        if( defectRec.Blocked_Reason__c != defect.blockedReason){
                            isOldNull = checkEmpty(defectRec.Blocked_Reason__c);
                            isNewNull = checkEmpty(defect.blockedReason);
                            if(!(isOldNull && isNewNull)){ 
                                  if(isNewNull)
                            {
                             caseCommentBody+= '\r\n Blocked Reason changed from '+ defectRec.Blocked_Reason__c+' to Blank';
                            }
                            else{
                                caseCommentBody+= '\r\n Blocked Reason changed from '+ defectRec.Blocked_Reason__c+' to '+defect.blockedReason;
                                }
                            }
                            defectRec.Blocked_Reason__c = defect.blockedReason;
                        }
                         if(String.isNotBlank(defect.defectSeverity) && defectRec.Severity__c != defect.defectSeverity){
                             caseCommentBody+= '\r\n Severity changed from '+ defectRec.Severity__c +' to '+defect.defectSeverity;
                             defectRec.Severity__c = defect.defectSeverity;    
                         }
                        
                         if(defectRec.Subject__c != defect.subject){
                             caseCommentBody+= '\r\n Subject changed from '+ defectRec.Subject__c +' to '+defect.subject;
                             defectRec.Subject__c = defect.subject;    
                         }
                         system.debug(defectRec.Subject__c+'********'+defect.subject+'********'+defectRec.Description__c+'*************'+defect.description);
                         if(defectRec.Description__c != defect.description){
                             caseCommentBody+= '\r\n The description was updated';
                             defectRec.Description__c = defect.description;   
                         }
                         system.debug('******caseCommentBody******'+caseCommentBody);
                         if(ghostComment==caseCommentBody){
                             caseCommentBody = '';                            
                         }
                        
                         
                           boolean isCaseVal=false;
                        if(defect.status!=null && defect.status!='' && ( existingStatus=='Closed' && defect.status=='Fixed')){
                                                       
                                isCaseVal=false;
                        }
                        if(defect.status!=null && defect.status!='' && (existingStatus=='Fixed' && defect.status=='Closed')){
                           
                            isCaseVal=false;
                        }
                         
                         if(defect.status!=null && defect.status!='' && (existingStatus!='Fixed' && existingStatus!='Closed') && ((defect.status=='Closed') || (defect.status=='Fixed'))){
                           
                            isCaseVal=true;
                        }
                         

                        Integer t = [select count() from Defect_Case_Association__c where case__c=:defectCaseAssociationList[0].case__c];
                        
                         if(t>1)
                         {
                             isCaseVal=false;
                            }
                            
                        
                        
                        update defectRec;
                        if(isCaseVal && defectCaseAssociationList[0].case__r.Status!='Closed'){
                        
                            Case c = new Case();
                            c.id = defectCaseAssociationList[0].case__c;
                            
                            c = [select Id,BusinessHoursId,Severity__c  from Case where Id =:c.id limit 1];
                                    Datetime currentDate=System.now();
       								 Datetime finalDate = null;
        							Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
                               if(c.BusinessHoursId!=null){
        for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:c.BusinessHoursId])
        taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
        
    }
     String severity =c.Severity__c;
    
    
    if(c.BusinessHoursId!=null){
        for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:c.BusinessHoursId])
        taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
        
    }                            
        
        if(severity=='1' || severity=='2')
        {
            finalDate=BusinessHours.addGmt(c.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(c.BusinessHoursId)*Integer.valueOf('1'))*long.Valueof('3600000')));
        }
        else if(severity=='3' || severity=='4' ||  severity=='5')
        {
            finalDate=BusinessHours.addGmt(c.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(c.BusinessHoursId)*Integer.valueOf('5'))*long.Valueof('3600000')));
        }
        
        c.Next_Action_Due_Date__c =finalDate;
    

                           
                            
                            
                            
                            c.Next_Action__c = 'Pending CA Support';
                         //   c.Next_Action_Due_Date__c    = System.now()+ (24/24);
                            UtilityFalgs.isDefectUpdate = true;
                            update c;
                         }
                        
                       
                        if(defect.comments!=null && defect.comments.size()>0 ){
                            for(comment  rallyComment : defect.comments){
                                Defect_Comment__c commentRec = new Defect_Comment__c();
                                commentRec.Comments__c = rallyComment.comment;
                                commentRec.Defect__c = defectRec.Id;
                                commentRec.From__c = rallyComment.authorName;
                                defectCommentList.add(commentRec);
                            }
                            insert defectCommentList;
                        }
                        
                        for(Defect_Case_Association__c defectCaseAssociation :defectCaseAssociationList){
                            
                            if(defect.comments!=null && defect.comments.size()>0){
                                    for(comment  rallyComment : defect.comments){
                                        casecomment caseCommentRec= new casecomment();
                                        caseCommentRec.parentId = defectCaseAssociation.case__c;
                                        caseCommentRec.commentBody = commentHeader +'\r\n'+rallyComment.comment ;
                                        caseCommentList.add(caseCommentRec);
                                    }
                            }
                            if(String.isNotBlank(caseCommentBody)){
                                
                                    casecomment caseCommentRec= new casecomment();
                                    caseCommentRec.parentId = defectCaseAssociation.case__c;
                                    caseCommentRec.commentBody = caseCommentBody;
                                    caseCommentList.add(caseCommentRec);
                              
                            }
                        } 
                        UtilityFalgs.isDefectUpdate = true;
                        for(Integer i = caseCommentList.size() - 1; i >= 0; i--){
                            
                            caseCommLst.add(caseCommentList[i]);
                        }
                        //insert caseCommentList;
                       
                            insert caseCommLst;
                     
                        res.statusCode = 200;
                        resMsg.status = 'Success';
                        resMsg.message = 'Defect Updated';  
                        
                     }  
                     else{
                      res.statusCode = 404;
                      resMsg.status = 'Failure';
                      resMsg.message = 'Defect doesnt exist';
                     }                             
                 }catch(exception e){
                          Database.rollback(sp);
                          res.statusCode = 500;
                          resMsg.status = 'Failure';
                          resMsg.message = e.getMessage();
                          system.debug('=================='+e.getMessage()+' '+e.getLineNumber()+' '+e.getStackTraceString());
                 }
            }
            else{
                 res.statusCode = 400;
            }                  
            String jsonResponse = JSON.serialize(resMsg);
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(null,defect.defectNumber,jsonRequest,jsonResponse,'PUT',res.statusCode, System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/UpdateDefect');   
            res.responseBody = blob.valueOf(jsonResponse);
            return;

        }
        global static boolean validateRequest (Defect defectReq){
            boolean validate = true ; 
            resMsg = new response();
            if(defectReq.defectNumber =='' || defectReq.defectNumber == null){
                validate = false ;
                resMsg.message = 'defectNumber is required';
            }
            if(defectReq.defectId =='' || defectReq.defectId == null){
                validate = false ;
                resMsg.message += '\r\n defectId is required';
            }
            if(!validate){
                resMsg.status = 'Failure';
            }
            return validate ;
        }
        global static boolean checkEmpty(String fieldValue){
           if(fieldValue==null || fieldValue=='' ||  fieldValue.trim().length()==0){
               return true;
           }
           else return false;
        }

        global class Comment {

           global string comment ;
           global string cdate ;
           global string author ;
           global string authorName;
        }
        public class Response{
            public string status ;
            public string message ; 
        }

        }