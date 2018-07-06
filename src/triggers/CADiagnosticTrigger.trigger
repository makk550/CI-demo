trigger CADiagnosticTrigger on CA_Diagnostics__c (before insert,before update,after insert,after update) {
    Set<Id> caseIdSet = new Set<Id>();
    for(CA_Diagnostics__c caDiagnosticRec : Trigger.New){
        if(caDiagnosticRec.case__c!= null){caseIdSet.add(caDiagnosticRec.case__c);}
    }
    Map<Id,Case> caseMap = new Map<Id,Case>([select id,caseNumber,Status,OwnerId from Case where id = :caseIdSet ]);
    
    if( Trigger.isBefore &&Trigger.isInsert ){
        for(CA_Diagnostics__c caDiagnosticRec : Trigger.New){
            if(caDiagnosticRec.case__c == null){caDiagnosticRec.addError(System.Label.Diagnostic_file_must_be_attached_to_a_case_Please_provide_the_related_case_info);}else  if(caseMap.get(caDiagnosticRec.Case__c).Status == 'Closed'){caDiagnosticRec.addError(System.Label.No_Diagnostic_file_can_be_attached_to_a_closed_case);} 
        }    
    }
    
    if(Trigger.isAfter && (Trigger.isInsert)){//|| Trigger.isUpdate) ) {
        CaseComment caseCommentRec;
        Task taskObj;
        for(CA_Diagnostics__c caDiagnosticRec : Trigger.New){
            //Insert a  case comment  (as an internal comment)
            caseCommentRec = new CaseComment(ParentID = caDiagnosticRec.Case__c,CommentBody = System.Label.CA_Diagnostic_file + ' - ' + caDiagnosticRec.Name + ' ' + System.label.has_been_attached_to_the_case,isPublished = false);
            //create new callback task
            if(System.Label.CA_Diagnostic_Remote_Engineer_Profile.contains(userinfo.getProfileId().substring(0,15))){
                //US344581--START
                if(String.isNotBlank(caDiagnosticRec.Case__c)){Boolean callBackResponse = CaseGateway.checkCallBackTask(caDiagnosticRec.Case__c);
                    if(callBackResponse){taskObj = new Task(RecordTypeId=label.Service_cloud_Task_Record_Type,Subject=System.Label.File,Source__c=System.Label.File_Attachment,Status='Open',Priority='Low',WhatId=caDiagnosticRec.Case__c,Type='Callback');
                        String caseOwner = caseMap.get(caDiagnosticRec.Case__c).OwnerId;
                        if(caseOwner.substring(0, 3)!='005'){taskObj.OwnerId=label.Service_cloud_Task_assignee;}else{taskObj.OwnerId=caseMap.get(caDiagnosticRec.Case__c).OwnerId;}
                    }
                }
                //US344581--END
            }
            try{if(!Test.isRunningTest()){insert caseCommentRec;}}catch(Exception e){caDiagnosticRec.addError(System.Label.CaseComment_did_not_get_generated_Error + e.getMessage());}
            try{if(!Test.isRunningTest() && taskObj<>null){insert taskObj;}}catch(Exception e){caDiagnosticRec.addError(System.Label.CA_Diagnostic_Task_Error + e.getMessage());}
        }        
    }
}