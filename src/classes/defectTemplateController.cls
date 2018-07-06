public class defectTemplateController{
    public List<Defect_Template__c> defectTem{get;set;}
    public Boolean showBlock{get;set;}
      
    public defectTemplateController(){
        String cId = String.isNotBlank(Apexpages.currentpage().getparameters().get('caseId'))?Apexpages.currentpage().getparameters().get('caseId'):'';
        showBlock = false;
        if(String.isNotBlank(cId)){
            showBlock = true;
            List<Defect_Template__c> listOfTemp = [Select Id, Name, Description__c from Defect_Template__c where Name!=:null AND Name!=:'' order by name asc];
            if(listOfTemp<>null && listOfTemp.size()>0){
                List<Case> caseObj = [Select id, caseNumber, subject, Description, Owner.Name, contact.Name,contact.Email,contact.phone, Site_Association__c, Site_Association__r.Name, Business_Impact__c, Product_Release_Selection__c, Product_Release_Selection__r.Name, Alternate_OS__c from Case where Id=:cId limit 1];
                if(caseObj<>null && caseObj.size()>0){
                    List<CaseComment> caseCommentObj = [Select id, commentBody, createdDate from caseComment where parentId=:cId order by createdDate desc limit 1];
                    List<SFTP_File_Attachments__c> sftpObj = [select id, Attachment_Link__c from SFTP_File_Attachments__c where case__c=:cId order by createdDate desc];
                    defectTem = new List<Defect_Template__c>();
                    for(Defect_Template__c defectObj:listOfTemp){
                        if(String.isNotBlank(defectObj.Description__c)){
                            if(defectObj.Description__c.contains('{')){
                                defectObj.Description__c = defectObj.Description__c.replaceAll('\\{','');                                
                            }
                            if(defectObj.Description__c.contains('}')){
                                defectObj.Description__c = defectObj.Description__c.replaceAll('}','');                                
                            }
                            if(defectObj.Description__c.contains('caseSubject')){
                                String replaceString = String.isNotBlank(caseObj[0].subject)?caseObj[0].subject.replaceAll('(?i)[^a-z0-9]',''):'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseSubject',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseCaseNumber')){
                                String replaceString = String.isNotBlank(caseObj[0].caseNumber)?caseObj[0].caseNumber:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseCaseNumber',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseOwnerName')){
                                String replaceString = String.isNotBlank(caseObj[0].Owner.Name)?caseObj[0].Owner.Name:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseOwnerName',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseContactName')){
                                String replaceString = String.isNotBlank(caseObj[0].Contact.Name)?caseObj[0].Contact.Name:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseContactName',replaceString);
                            }
                            if(defectObj.Description__c.contains('contactEmail')){
                                String replaceString = String.isNotBlank(caseObj[0].contact.Email)?caseObj[0].contact.Email:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('contactEmail',replaceString);
                            }
                            if(defectObj.Description__c.contains('contactPhone')){
                                String replaceString = String.isNotBlank(caseObj[0].contact.phone)?caseObj[0].contact.phone:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('contactPhone',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseUrl')){
                                String baseURL = System.URL.getSalesforceBaseUrl().toExternalForm(); 
                                //String url =ApexPages.getparameters();
                                String replaceString = baseURL+'/'+cId;
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseUrl',replaceString);
                            }
                            
                            if(defectObj.Description__c.contains('caseDescription')){
                                String replaceString = String.isNotBlank(caseObj[0].Description)?Matcher.quoteReplacement(caseObj[0].Description):'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseDescription',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseSiteId')){
                                String replaceString = String.isNotBlank(caseObj[0].Site_Association__c)?caseObj[0].Site_Association__r.Name:null;
                                if(replaceString==null){
                                    replaceString = '';
                                }
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseSiteId',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseBusinessImpact')){
                                String replaceString = String.isNotBlank(caseObj[0].Business_Impact__c)?caseObj[0].Business_Impact__c:'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseBusinessImpact',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseProductRelease')){
                                String replaceString = String.isNotBlank(caseObj[0].Product_Release_Selection__c)?caseObj[0].Product_Release_Selection__r.Name:null;
                                if(replaceString==null){
                                    replaceString = '';
                                }
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseProductRelease',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseOperatingSystem')){
                                String replaceString = String.isNotBlank(caseObj[0].Alternate_OS__c )?caseObj[0].Alternate_OS__c :'';
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseOperatingSystem',replaceString);
                            }
                            if(defectObj.Description__c.contains('lastCaseComment')){
                                String replaceString = '';
                                if(caseCommentObj<>null && caseCommentObj.size()>0){
                                    replaceString = String.isNotBlank(caseCommentObj[0].commentBody)?Matcher.quoteReplacement(caseCommentObj[0].commentBody):'';
                                }
                                defectObj.Description__c = defectObj.Description__c.replaceAll('lastCaseComment',replaceString);
                            }
                            if(defectObj.Description__c.contains('caseSftpAttachment')){
                                String replaceString = '';
                                if(sftpObj<>null && sftpObj.size()>0){
                                    for(SFTP_File_Attachments__c sftpObject:sftpObj){
                                        if(String.isNotBlank(sftpObject.Attachment_Link__c)){
                                            replaceString = replaceString+sftpObject.Attachment_Link__c+'\n';
                                        }
                                    }
                                }
                                defectObj.Description__c = defectObj.Description__c.replaceAll('caseSftpAttachment',replaceString);
                            }
                            defectTem.add(defectObj);
                        }
                    }
                } 
            }
        }else{
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Please close the window and re-open the new defect page');
            ApexPages.addmessage(errMsg); 
        } 
    }
}