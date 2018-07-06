trigger SFTPAttachment_caseupdate on SFTP_File_Attachments__c (Before insert, Before update,after insert, after update, before delete) {

    set<String> CaNumSet=new set<String>();
    List<Case> CaseList=new List<Case>(); 
    Map<String,id> caseNumMap = new Map<String,id>();
    

    if(Trigger.isBefore&&(trigger.isupdate || trigger.isinsert))
       {
            for(SFTP_File_Attachments__c recSFTP: Trigger.new)
            {
              
                if(recSFTP.Case_Number__c!=null && recSFTP.Case__c==null)
                {
                    CaNumSet.add(recSFTP.Case_Number__c);
                    
                }
            }
            
            
                caseList=[select id,CaseNumber from case where CaseNumber in :CaNumSet];
           system.debug('caseList: '+caseList);
                   if(caseList!=null && caseList.size()>0)
                    {
                        for(Case caseRec:caseList)
                        caseNumMap.put(caseRec.CaseNumber,caseRec.id);
                    }
           system.debug('caseNumMap: '+caseNumMap); 
            if(caseNumMap!=null)
            {
                for(SFTP_File_Attachments__c recSFTP: Trigger.new)
                  {
                  
                    if(recSFTP.Case_Number__c!=null && recSFTP.Case__c==null)
                      recSFTP.Case__c=caseNumMap.get(recSFTP.Case_Number__c);
                
                    }
            }
    }

    if((Trigger.isAfter && (trigger.isupdate || trigger.isinsert))||(trigger.isbefore && trigger.isDelete))
    {
       
             //UtilityFalgs.callbackSubject='File'; 
             //UtilityFalgs.callbackSource='File Attachment';
          Set<String> fileName = new Set<String>();
          if(Trigger.isdelete&&trigger.isbefore)
          {
                 for(SFTP_File_Attachments__c recSFTP: Trigger.old)
              {
                
                CaNumSet.add(recSFTP.Case__c);
             }
            
          }
          else
          {
                for(SFTP_File_Attachments__c recSFTP: Trigger.new)
                    {
                      CaNumSet.add(recSFTP.Case__c);
                        //US201990
                        if(String.isNotBlank(recSFTP.Attachment_Link__c) && recSFTP.Attachment_Link__c.contains('files_from_ca')){
                            fileName.add(recSFTP.Attachment_Link__c);
                        }
                        //US201990
                    }
          }
           if(CaNumSet.size()>0&&CaNumSet!=null)
           caseList=[select id from case where id in :CaNumSet]; //,Case_mgmt_LastUpdatedBy__c
           Set<id>caseIdSet = new Set<id>();
           for(Case caseRec: caseList){
              caseIdSet.add(caseRec.Id);
           }
           List<task> callbackList = [select Id , whatId from Task where subject ='File' AND whatId IN :CaseList AND Status !=:'Closed']; //caseIdSet
            //US201990---START
            if((callbackList==null || (callbackList<>null && callbackList.size()==0)) && ((fileName<>null && fileName.size()==0) || fileName==null)){
                UtilityFalgs.callbackSubject='File'; 
                UtilityFalgs.callbackSource='File Attachment';
            }else{
                UtilityFalgs.callbackSubject=''; 
                UtilityFalgs.callbackSource='';
            }
            //US201990---END
            for(Task callbackFile :callbackList ){
                
                if(caseList!=null && caseIdSet.contains(callbackFile.whatId)){
                    caseIdSet.remove(callbackFile.whatId);
                }
             
            }
           List<case>updateCaseList = new List<Case>();
            for(Case caseRec: caseList){
              if(caseIdSet.contains(caseRec.Id)){
                //US303641----START
                /*if(Trigger.isInsert){
                    caseRec.Case_mgmt_LastUpdateDT__c = system.now();
                    caseRec.Case_mgmt_LastUpdatedBy__c = userinfo.getName();    
                }*/
                //US303641---END
                updateCaseList.add(caseRec);
              }
            }
           if(updateCaseList!=null && updateCaseList.size()>0)
           {
               //US78177 - Commented as part of US78177
               /*
             if((userinfo.getProfileId().substring(0,15)!=label.EAI_Integration_NON_SSO_Profile)&& (!UtilityFalgs.sentAlert))
            {
             UtilityFalgs.sendMail(caseList);
             UtilityFalgs.sentAlert=true;
            } */
            try
            {
                update updateCaseList;
            }
            catch(Exception ex)
            {
                String msg=ex.getMessage();
                if(ex.getMessage().contains('VALIDATION_EXCEPTION'))
                    msg=msg.substring(10+msg.indexof('EXCEPTION,'),msg.indexof(': ['));
                if(!Trigger.isDelete)
                    Trigger.new[0].addError(msg+' on Case');
                else
                    Trigger.old[0].addError(msg+' on Case');
            }
           }
            
    }
 
}