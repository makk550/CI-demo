public class CaseDirectoryCreateThroughL7 {
    public static String caseNum,oldSiteId,newSiteId;
    public static void parseValuesFromRequestPayLoad(String requestPayload)
    {
        JSONParser parser = JSON.createParser(requestPayLoad);
        parser.nextToken();
        System.debug('parser.nextToken();'+parser.nextToken());
        parser.nextValue();
        String oldPath = parser.getText();
        System.debug('oldpath'+oldPath);
        String []oldValues = oldPath.split('/');
        oldSiteId = oldValues[1];
        caseNum = oldValues[2];
        System.debug(oldValues[1]+','+oldValues[2]);
        parser.nextToken();
        parser.nextValue();
        String newPath = parser.getText();
        System.debug('new'+newPath);
        newSiteId = newPath.subString(1,newPath.length()-1);
        System.debug(newPath.subString(1,newPath.length()-1));
        
    }
    @Future(Callout = true)
    public  static void createOrMoveCaseDirectory(List<String> reqPayloadList,String action){
        List<CrushFTP_SFDC_Logs__c> errorLogList = new List<CrushFTP_SFDC_Logs__c>();
		String methodtype,EndPoint,statusCode;
        if (action=='CreateCase')
        {
            System.debug('Inside create case directory --');
            methodtype='POST';
            EndPoint = System.label.CFTP_CaseFolderCreationEndpoint;
        }
        else if (action=='MoveCaseDirectory')
        {
            System.debug('Inside move case directory --');
        	methodtype='PUT';
            EndPoint = System.label.CFTP_CaseFolderCreationOnSiteIdChangeEndpoint;
        }
        for(String s : reqPayloadList){
            System.debug('Input payload --------->:'+ s);
            try{
                HttpRequest req = new HttpRequest();
                req.setEndpoint(EndPoint);
                req.setMethod(methodtype);
                req.setHeader('Content-Type', 'application/json');   
                req.setBody(s);
                Layer7UtilCallout layer7Callout=new Layer7UtilCallout();
                STring responseFromService =  layer7Callout.processLayer7Services(req);
                if(req.getEndPoint() == System.label.CFTP_CaseFolderCreationOnSiteIdChangeEndpoint)
                	statusCode = responseFromService.split('@@')[1];
                System.debug('responseFromService'+responseFromService);
                if(responseFromService.contains('failure')){
                     errorLogList.add(CaseDirectoryCreateThroughL7.prepareErrorLog(null,System.label.CFTP_CaseFolderCreationEndpoint,s,responseFromService));
                }
                if(action=='MoveCaseDirectory' && statusCode == '200'){
                    System.debug('inside case comment');
                    CaseDirectoryCreateThroughL7.parseValuesFromRequestPayLoad(s);
                    CaseDirectoryCreateThroughL7.insertCaseComment();
                }
                else if(action=='MoveCaseDirectory' && statusCode!='200'){
                    errorLogList.add(CaseDirectoryCreateThroughL7.prepareErrorLog(null,System.label.CFTP_CaseFolderCreationOnSiteIdChangeEndpoint,s,responseFromService));
                }
                    
            } catch(Exception e){
                System.debug('Exception details:'+e.getStackTraceString());
                errorLogList.add(CaseDirectoryCreateThroughL7.prepareErrorLog(e,System.label.CFTP_CaseFolderCreationEndpoint,s,null));
            }finally{
                System.debug('In finally block'); 
                if(errorLogList!=null && errorLogList.size()>0 ){
                    System.debug('errorLogList:'+errorLogList);
                    insert errorLogList;
                }
            }  
        }        
    }   
    public static void insertCaseComment()
    {
		Case caseRec;
        List<Case> caseList = [select id, caseNumber, Case_Type__c from Case where caseNumber =: caseNum];
        if(caseList != null && caseList.size()>0){                    
            caseRec = caseList[0] ;
            CaseComment comment = new CaseComment();
            comment.ParentID = caseRec.Id;
            comment.CommentBody = 'Site has been changed on this case and Case Attachments have been moved from ('+oldSiteId.replaceFirst( '^0+', '') +') to ('+newSiteId.replaceFirst( '^0+', '') +')';  
            comment.IsPublished = true;
            insert comment;    
            updateSFTPLinks();
   	 	}
    }
    public static void updateSFTPLinks()
    {
        System.debug('inside fileatatchemnts');
        List<SFTP_File_Attachments__c> oldSftpLinks = [select Id,Attachment_Link__c from SFTP_File_Attachments__c where case_number__c =: caseNum]; 
        System.debug('links'+oldSftpLinks);
        List<SFTP_File_Attachments__c> newSftpLinks = new List<SFTP_File_Attachments__c>(); 
        for (SFTP_File_Attachments__c s : oldSftpLinks)
        {
           SFTP_File_Attachments__c sftpRec = new SFTP_File_Attachments__c();
            System.debug('inside for'+oldSiteId+','+newSiteId);
          	sftpRec.id = s.id;
            sftpRec.Attachment_Link__c = s.Attachment_Link__c.replace(oldSiteId,newSiteId);
    		newSftpLinks.add(sftpRec);
        }
        System.debug(newSftpLinks);
        update newSftpLinks;
    }
    public static CrushFTP_SFDC_Logs__c prepareErrorLog(Exception e,String endpoint,String input,String responseBody){        
        CrushFTP_SFDC_Logs__c obj = new CrushFTP_SFDC_Logs__c();
        obj.Event__c = 'createCaseFolder';
        obj.Request__c ='\nEndpoint:'+ endpoint + '\nRequest Body:' + input ;
        obj.Response_Error__c = '';
        if( e != null){
            obj.Response_Error__c = 'Exception Message:' + e.getMessage(); 
        }
        if(responseBody != null){
            obj.Response_Error__c = 'response:' + responseBody ;
        }    
        System.debug('CrushFTP_SFDC_Logs__c record:'+obj);
        return obj;
    }
   
}