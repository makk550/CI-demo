@RestResource(urlMapping='/attachments_insertSFTP')
global class CaseAttachments_InsertSFTPRec {
    
    global class ResponseMessage {           
        public String statusCode;
        public String statusMessage;
        public String path;
    }
    
      @HttpPost
    global static ResponseMessage updateCaseWithSFTPRecDetails(){
        
         ResponseMessage resp = new ResponseMessage();
        
        List<CrushFTP_SFDC_Logs__c> errorLogList = new List<CrushFTP_SFDC_Logs__c>();
        
        RestRequest req = RestContext.request;
        System.debug('***req:'+ req.requestBody );        
        //String path = req.requestBody.toString(); //  RestContext.request.params.get('file');
        String path = RestContext.request.params.get('file');  
        String parentPath = RestContext.request.params.get('parentPath'); // : /0103524/00784012/files_from_customer/
        String size =  RestContext.request.params.get('size');
        String fileName =  RestContext.request.params.get('name');
        String userName =  RestContext.request.params.get('user');
        String dt = RestContext.request.params.get('dt');
        String event = RestContext.request.params.get('action');
        
        String returnMessage = null;
        
        System.debug('path:'+path); 
        System.debug('parentPath:'+parentPath); 
        System.debug('size:'+size); 
        System.debug('fileName:'+fileName); 
        System.debug('userName:'+userName); 
        System.debug('dt:'+dt); 
        // System.debug('*** req.requestBody.toString():' + req.requestBody.toString());
        
        if(username.contains('prodrunuser')){
            username = username.removeStart('prodrunuser#');
        }
        
        if(path!=null && path.startsWithIgnoreCase(System.Label.CFTP_Internal_Path)){
                System.debug('Before, path:'+path);
                path = path.removeStartIgnoreCase(System.Label.CFTP_Internal_Path);
                System.debug('After, path:'+path);
        }
        
        if(parentPath!=null && parentPath.startsWithIgnoreCase(System.Label.CFTP_Internal_Path)){
                System.debug('Before, parentPath:'+path);
                parentPath = parentPath.removeStartIgnoreCase(System.Label.CFTP_Internal_Path);
                System.debug('After, parentPath:'+parentPath);
            }
         
        Savepoint sp = Database.setSavepoint();
        try{
            if(path!=null){  
                List<String> ls = path.split('/');
                System.debug('ls:'+ls + ';ls[ls.size()-3]:'+ls[ls.size()-3]);   
                
                Case caseRec;
                List<Case> caseList = [select id, caseNumber from Case where caseNumber = : ls[ls.size()-3]];
                if(caseList != null && caseList.size()>0){                    
                    caseRec = caseList[0] ;                    
                    if(event == 'update'){                            
                        insertSFTPFileAttachment(caseRec.caseNumber, parentPath, fileName, size, userName);                    
                    } else if(event == 'delete'){
                        deleteSFTPFileAttachment(caseRec.Id, path );
                    }
                    returnMessage = 'success';
                    resp = prepareResponseObj('success', 'success', path);
                }else {
                    caseRec = null;
                    returnMessage = 'Case Not found';
                    resp = prepareResponseObj('failure', 'Case Not found', path);
                    errorLogList.add(CaseAttachments_UpdateCase.prepareErrorLog(null, event ,path,'Case Not found.File might have been placed at wrong location.'));
                }                 
            } else { 
                returnMessage = 'file path is null.'; 
                resp = prepareResponseObj('failure', 'file path is null', path);
                errorLogList.add(CaseAttachments_UpdateCase.prepareErrorLog(null,event, path, 'file path is null'));
            }
            
        } catch(Exception e){
            Database.rollback(sp);            
            System.debug('exception message:'+ e.getMessage());
            System.debug('exception stackTrace:'+ e.getStackTraceString());
            errorLogList.add(CaseAttachments_UpdateCase.prepareErrorLog(e,event,path,null));
            returnMessage = 'Exception occured...Please recheck.';
            resp = prepareResponseObj('failure', e.getStackTraceString(), path);
        }finally{
            System.debug('In finally block:' + errorLogList); 
            if(errorLogList!=null && errorLogList.size()>0 ){
                insert errorLogList;
            }
        }  
        return resp ; //returnMessage;
        
    }
    
    public static void insertSFTPFileAttachment(String CaseNumber, String path, String fileName, String size, String userName ){
        try{
            List<AggregateResult> agrCnt =  [select count(case_number__c) from sftp_file_attachments__c where case_number__c = :CaseNumber];
            List<Case> caseRec =  [select id,casenumber from case where CaseNumber = :CaseNumber];
            
            List<SFTP_File_Attachments__c> existingRecList = [SELECT Id,Case_Number__c ,File_Name__c FROM SFTP_File_Attachments__c WHERE Case_Number__c = :CaseNumber AND File_Name__c = :fileName]; 
                        
            SFTP_File_Attachments__c sftpRec;        
            if( existingRecList != null && existingRecList.size() > 0){
                sftpRec = existingRecList[0];
                sftpRec.Action__c = 'U';
                sftpRec.File_Size__c = Long.valueOf(size);
                                
            } else{
                sftpRec= new SFTP_File_Attachments__c();
                sftpRec.Case_Number__c = caseNumber;
                sftpRec.Case__c = caseRec[0].Id;
                sftpRec.File_Name__c = fileName;
                sftpRec.File_Size__c = Long.valueOf(size);                   
                sftpRec.Attachment_Link__c = System.label.CFTP_SFTPRec_BaseUrl + path + fileName; 
                
                sftpRec.HSS_Type__c = 'nonHss' ; //hardcoded by GS. TODO: Is this field still needed?
                sftpRec.HSSAccess__c = 'unrestricted';
                if( path.containsIgnoreCase('files_from_customer')){
                    sftpRec.Location__c = 'N';
                } else if(path.containsIgnoreCase('files_from_ca')){
                    sftpRec.Location__c = 'Y';
                }
                sftpRec.Virus_Status_CD_c__c = 'C';
                sftpRec.Attachment_Seq_No__c = ((Integer)agrCnt[0].get('expr0'))+1; 
                sftpRec.Action__c = 'A'; 
            }
            sftpRec.Updated_by__c = userName;
            sftpRec.Updated_date__c = System.now();         
            upsert sftpRec; 
        } catch(Exception e){
            CrushFTP_SFDC_Logs__c logRec = CaseAttachments_UpdateCase.prepareErrorLog(e,'insertSFTPFileAttachment',path,null);
            insert logRec;
        }
        
    }
    
    
     public static void deleteSFTPFileAttachment(Id caseRecId, String path){
        try {
            //String attachmentLinkFilter = '%' + path + '%' ;
            String temp ; 
            if(path.startsWithIgnoreCase(System.Label.CFTP_Internal_Path)){
                path.removeStartIgnoreCase(System.Label.CFTP_Internal_Path);               
            }
            String attachmentLinkFilter = '%' + path + '%' ;
            System.debug('attachmentLinkFilter:'+attachmentLinkFilter);
            System.debug('****caseRec.Id:'+caseRecId);
            List<SFTP_File_Attachments__c> sftpListToDelete = [select id from SFTP_File_Attachments__c
                                                               where 
                                                               Case__c = :caseRecId and 
                                                               Attachment_Link__c LIKE :attachmentLinkFilter 
                                                              ];
            System.debug('sftpListToDelete:'+sftpListToDelete);
            delete sftpListToDelete;
        } catch(Exception e){
            CrushFTP_SFDC_Logs__c logRec = CaseAttachments_UpdateCase.prepareErrorLog(e, 'deleteSFTPFileAttachment' ,path, null);
            insert logRec;
        }
    } 
    

	 public static ResponseMessage prepareResponseObj(String statusCode, String statusMessage, String path){        
        ResponseMessage response = new ResponseMessage();
        response.statusCode = statusCode;
        response.statusMessage = statusMessage;
        response.path = path;
        return response;        
    }    
        
    

}