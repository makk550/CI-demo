public class XMLGenerationDemo {
    public String xmlString { get; set;} 
    public void generateXML(){
        List<Knowledge__kav> knowledgeList = [SELECT ArticleNumber, UrlName, Title, Summary, Request_Type__c, ValidationStatus, 
                                              Content1__c, Background__c,Environment__c, Instructions__c, Additional_Information__c, 
                                              Id, KnowledgeArticleId, RecordTypeId, Legacy_Approval_History__c, Auto_Article_Numbers__c, 
                                              Product_Names__c, CADocid__c, LastPublishedDate, CreatedDate, LastModifiedDate, 
                                              Product_Association__c, CreatedById, Component_Names__c, Component_Codes__c, Releases__c, 
                                              ECM_Created_Date__c, ECM_Last_Modified_Date__c, ECM_Modified_Date__c, PublishStatus, 
                                              LastModifiedById, CMS_IDs__c, VersionNumber, Keywords__c, Notes__c, Legacy_Source__c, 
                                              Legacy_Current_Author__c FROM Knowledge__kav where PublishStatus = 'archived' 
                                              AND articlenumber='000136877'];    
        for(Knowledge__kav knowledge : knowledgeList){
            generateXMLDocument(knowledge);
        }
    }
    
    public String generateXMLDocument(knowledge__kav knowledgeObject){
        String knowledgeArticleId = '';
        final String BUCKET = 'case-archive-qa';
        final String FOLDER = 'KnowledgeArchival-Backup/Best-Practices-Files';
        System.debug('***************'+knowledgeObject.ArticleNumber);
        DOM.Document document = new DOM.Document();
        try{
            DOM.XmlNode caseDetails = document.createRootElement('CaseDetails', null, null);
            DOM.XmlNode caseNode = caseDetails.addChildElement('Case', null, null);
            DOM.XmlNode fields= caseNode.addChildElement('Fields', null, null);
            addFirstSection(knowledgeObject, fields);
            addSecondSection(knowledgeObject, fields, BUCKET, FOLDER);
            addThirdSection(knowledgeObject, fields);
            addRelatedContent(knowledgeObject, caseDetails);
            uploadAttachments(knowledgeObject, BUCKET, FOLDER);
            addLinkedCases(knowledgeObject, BUCKET, FOLDER);
            uploadToAmazonS3(BUCKET, FOLDER+'/'+knowledgeObject.ArticleNumber+'_case_details.xml', Blob.valueOf(document.toXmlString()));
            knowledgeArticleId = knowledgeObject.KnowledgeArticleId;
            System.debug('Article :  '+knowledgeObject.ArticleNumber+' Successfully Archived');
        }catch(Exception reason){
            System.debug('************** Exception Occured While Archiving Article Number : '+knowledgeObject.ArticleNumber);
            System.debug('************** Exception Is : '+reason);
            return knowledgeArticleId;
        }
        return knowledgeArticleId;
    }

    private void addFirstSection(Knowledge__kav knowledgeObject, DOM.XmlNode fields){
        DOM.XmlNode section1= fields.addChildElement('section', null, null);
        section1.setAttribute('A_visible', 'true');
        section1.setAttribute('column', '2');
        section1.setAttribute('name', 'Basic Details');
        section1.setAttribute('widentity', 'Section-Name-1');

        addChild(section1, 'CASENUMBER', 'Article Number', formatData(null != knowledgeObject.ArticleNumber ? knowledgeObject.ArticleNumber : ''));
        addChild(section1, 'Title', 'Title', formatData(null != knowledgeObject.Title ? knowledgeObject.Title : ''));
        addChild(section1, 'UrlName', 'URL Name', formatData(null != knowledgeObject.UrlName ? knowledgeObject.UrlName : ''));
        addChild(section1, 'Summary', 'Summary', formatData(null != knowledgeObject.Summary ? knowledgeObject.Summary : ''));
        addChild(section1, 'ValidationStatus', 'Validation Status', formatData(null != knowledgeObject.ValidationStatus ? knowledgeObject.ValidationStatus : ''));
        addChild(section1, 'Kb_Template_Type', 'Article Record Type', 'Best Practices / How-To');
    } 

    private void addSecondSection(Knowledge__kav knowledgeObject, DOM.XmlNode fields, String bucket, String folder){
        DOM.XmlNode section2= fields.addChildElement('section', null, null);
        section2.setAttribute('A_visible', 'true');
        section2.setAttribute('column', '1');
        section2.setAttribute('name', 'Best Practices/How To');
        section2.setAttribute('widentity', 'Section-Name-2');

        addChild(section2, 'Content1__c', 'Introduction', formatRichText(null != knowledgeObject.Content1__c ? uploadEmbeddedImage(knowledgeObject.Content1__c, bucket, folder) : ''));
        addChild(section2, 'Background__c', 'Background', formatRichText(null != knowledgeObject.Background__c ? uploadEmbeddedImage(knowledgeObject.Background__c, bucket, folder) : ''));
        addChild(section2, 'Environment', 'Environment', formatData(null != knowledgeObject.Environment__c ? uploadEmbeddedImage(knowledgeObject.Environment__c, bucket, folder) : ''));
        addChild(section2, 'Instructions__c', 'Instructions', formatRichText(null != knowledgeObject.Instructions__c ? uploadEmbeddedImage(knowledgeObject.Instructions__c, bucket, folder) : ''));
        addChild(section2, 'Additional_Information__c', 'Additional Information', formatRichText(null != knowledgeObject.Additional_Information__c ? uploadEmbeddedImage(knowledgeObject.Additional_Information__c, bucket, folder) : ''));
    }

    public void addThirdSection(Knowledge__kav knowledgeObject, DOM.XmlNode fields){

        DOM.XmlNode section3= fields.addChildElement('section', null, null);
        section3.setAttribute('A_visible', 'true');
        section3.setAttribute('column', '2');
        section3.setAttribute('name', 'Information');
        section3.setAttribute('widentity', 'Section-Name-3');

        addChild(section3, 'Auto_Article_Numbers__c', 'External Document ID', formatData(null != knowledgeObject.Auto_Article_Numbers__c ? knowledgeObject.Auto_Article_Numbers__c : ''));
        addChild(section3, 'CMS_IDs__c', 'CMSID', formatData(null != knowledgeObject.CMS_IDs__c ? knowledgeObject.CMS_IDs__c : ''));
        addChild(section3, 'Product_Names__c', 'Product Name(s)', formatData(null != knowledgeObject.Product_Names__c ? knowledgeObject.Product_Names__c : ''));
        addChild(section3, 'Component_Codes__c', 'Component Code(s)', formatData(null != knowledgeObject.Component_Codes__c ? knowledgeObject.Component_Codes__c : ''));
        addChild(section3, 'Releases__c', 'Release(s)', formatData(null != knowledgeObject.Releases__c ? knowledgeObject.Releases__c : ''));
        addChild(section3, 'Notes__c', 'Internal Notes', formatData(null != knowledgeObject.Notes__c ? knowledgeObject.Notes__c : ''));
        addChild(section3, 'PublishStatus', 'Publish Status', formatData(null != knowledgeObject.PublishStatus ? knowledgeObject.PublishStatus : ''));
        addChild(section3, 'Legacy_Current_Author__c', 'Current Author', formatData(null != knowledgeObject.Legacy_Current_Author__c ? knowledgeObject.Legacy_Current_Author__c : ''));
        addChild(section3, 'CreatedById', 'Created By', formatData(null != knowledgeObject.CreatedById ? [Select Name from User where Id = :knowledgeObject.CreatedById].Name : ''));
        addChild(section3, 'CreatedDate', 'Created Date', null != knowledgeObject.CreatedDate ? knowledgeObject.CreatedDate.format('MM/dd/YYYY') : '');
        addChild(section3, 'LastModifiedById', 'Modified By', formatData(null != knowledgeObject.LastModifiedById ? [Select Name from User where Id = :knowledgeObject.LastModifiedById].Name : ''));
        addChild(section3, 'LastModifiedDate', 'Modified Date', null != knowledgeObject.LastModifiedDate ? knowledgeObject.LastModifiedDate.format('MM/dd/YYYY') : '');
        String actualPublisherValue = '';
        if(null != knowledgeObject.CreatedById){
            List<ProcessInstance> processInstanceList = [Select LastActorId From ProcessInstance where TargetObjectId = :knowledgeObject.Id];
            if(null != processInstanceList && processInstanceList.size()>0){
                actualPublisherValue = [Select Name from User where Id = :processInstanceList[0].LastActorId].Name;
            }
        }
        addChild(section3, 'ActualPublisher', 'Last Published By', null != actualPublisherValue ? actualPublisherValue : '');
        addChild(section3, 'LastPublishedDate', 'Last Published Date', null != knowledgeObject.LastPublishedDate ? knowledgeObject.LastPublishedDate.format('MM/dd/YYYY') : '');
        addChild(section3, 'VersionNumber', 'Version Number', formatData(null != knowledgeObject.VersionNumber ? knowledgeObject.VersionNumber+'' : ''));
        addChild(section3, 'CADocid__c', 'Legacy Article Number', formatData(null != knowledgeObject.CADocid__c ? knowledgeObject.CADocid__c : ''));
        addChild(section3, 'Legacy_Source__c', 'Legacy Source', formatData(null != knowledgeObject.Legacy_Source__c ? knowledgeObject.Legacy_Source__c : ''));
        addChild(section3, 'Keywords__c', 'Keywords', formatData(null != knowledgeObject.Keywords__c ? knowledgeObject.Keywords__c : ''));        
        addChild(section3, 'Legacy_Approval_History__c', 'Legacy Approval History', formatData(null != knowledgeObject.Legacy_Approval_History__c ? knowledgeObject.Legacy_Approval_History__c : ''));
    }
    
    private void addRelatedContent(Knowledge__kav knowledgeObject, DOM.XmlNode caseDetails){
        DOM.XmlNode relatedAttachments = caseDetails.addChildElement('relatedList ', null, null);
        relatedAttachments.setAttribute('name', 'Attachments');
        addChild(relatedAttachments, 'relatedListURL', 'Attachments', '/RelatedXMLs/'+knowledgeObject.ArticleNumber+'_RelatedList_Attachments.xml');
        
        DOM.XmlNode relatedLinkedCases = caseDetails.addChildElement('relatedList ', null, null);
        relatedLinkedCases.setAttribute('name', 'Linked Cases');        
        addChild(relatedLinkedCases, 'relatedListURL', 'Linked Cases', '/RelatedXMLs/'+knowledgeObject.ArticleNumber+'_RelatedList_LinkedCases.xml');
    }

    private void uploadAttachments(Knowledge__kav knowledgeObject, String bucket, String folder){
        Knowledge__kav attachment = [SELECT ArticleNumber,File_attachment__Body__s,File_attachment__Name__s,File_attachment__Length__s FROM Knowledge__kav where language='en_US' AND PublishStatus = 'archived' AND ArticleNumber=:knowledgeObject.ArticleNumber];

        if(null != attachment.File_attachment__Body__s){
            String fileName = knowledgeObject.ArticleNumber+'_'+attachment.File_attachment__Name__s.replaceAll(' ', '');
            uploadToAmazonS3(bucket, folder+'/Attachments/'+fileName, attachment.File_attachment__Body__s);
            DOM.Document attachmentsDocument = new DOM.Document();
            DOM.XmlNode relatedContentFields = attachmentsDocument.createRootElement('RelatedContent_Fields', null, null);
            relatedContentFields.setAttribute('Name', 'Attachments');
            DOM.XmlNode relatedContent = relatedContentFields.addChildElement('RelatedContent', null, null);
            addChild(relatedContent, 'Attachments_name', 'Name', folder+'/Attachments/'+fileName+'uniqueAttachmentContent'+fileName.substring(0, fileName.lastIndexOf('.')));
            uploadToAmazonS3(bucket, folder+'/RelatedXMLs/'+knowledgeObject.ArticleNumber+'_RelatedList_Attachments.xml', Blob.valueOf(attachmentsDocument.toXmlString()));
        }
    }

    private void addLinkedCases(Knowledge__kav knowledgeObject, String bucket, String folder){
        DOM.Document linkedCasesDocument = new DOM.Document();
        DOM.XmlNode relatedContentFields = linkedCasesDocument.createRootElement('RelatedContent_Fields', null, null);
        relatedContentFields.setAttribute('Name', 'Linked Cases');
        List<CaseArticle> caseArticles = [SELECT Case.CaseNumber, Case.Account.Name, Case.CreatedDate, Case.ClosedDate, Case.Status FROM CaseArticle where KnowledgeArticleId =:knowledgeObject.KnowledgeArticleId];
        if(caseArticles.size() > 0){
            for(CaseArticle caseArticle : caseArticles){
                DOM.XmlNode relatedContent = relatedContentFields.addChildElement('RelatedContent', null, null);
                addChild(relatedContent, 'LinckedCases_Case__c', 'Case Number', null != caseArticle.Case.CaseNumber ? caseArticle.Case.CaseNumber : '');
                addChild(relatedContent, 'LinckedCases_AssignedById', 'Account Name', null != caseArticle.Case.Account.Name ? caseArticle.Case.Account.Name : '');
                addChild(relatedContent, 'LinckedCases_AssignmentDate', 'Date/Time opened', null != caseArticle.Case.CreatedDate ? caseArticle.Case.CreatedDate.format('MM/dd/YYYY') : '');
                addChild(relatedContent, 'LinckedCases_AssignmentDueDate', 'Date/Time closed', null != caseArticle.Case.ClosedDate ? caseArticle.Case.ClosedDate.format('MM/dd/YYYY'): '');
                addChild(relatedContent, 'LinckedCases_Migrated_Status__c', 'Status', null != caseArticle.Case.Status ? caseArticle.Case.Status : '');
            }
            uploadToAmazonS3(bucket, folder+'/RelatedXMLs/'+knowledgeObject.ArticleNumber+'_RelatedList_LinkedCases.xml', Blob.valueOf(linkedCasesDocument.toXmlString())); 
        }
    }    

    private void addChild(DOM.XmlNode xmlNode, String nodeName, String attributeValue, String nodeValue){
        DOM.XmlNode child = xmlNode.addChildElement(nodeName, null, null);
        child.setAttribute('Name', AttributeValue);
        child.addTextNode(nodeValue);
    }
    
    private static void uploadToAmazonS3(String bucket, String fileName, Blob fileContent) {
            AWS_credentials__c credentials = AWS_credentials__c.getValues(System.Label.AWS_CaseArchival_Credential_Name);
            String S3Key = credentials.Key__c;
            String fname = EncodingUtil.urlEncode(fileName, 'UTF-8');
            Datetime now = DateTime.now();
            Datetime expireson = now.AddSeconds(120);
            Long Lexpires = expireson.getTime()/1000;

            String stringtosign = 'PUT\n\n\n'+Lexpires+'\n/'+bucket+'/'+fileName;
            String signed = make_sig(stringtosign,credentials);
            String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        
           
            String url = System.Label.AWS_CaseArchival_Root_URL+bucket+'/'+fileName+'?AWSAccessKeyId='+S3Key+'&Expires='+Lexpires+'&Signature='+codedsigned;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            if(String.isNotBlank(url)){
                System.debug('URL : ' +url);
                request.setEndpoint(url);
                request.setMethod('PUT');                
                request.setBodyAsBlob(fileContent);
            }
            Http httpObj = new Http();
            response = httpObj.send(request);
            System.debug('Response Code Is : '+response.getStatus());
            System.debug('Response Code Is : '+response.toString());
            //
            System.debug('*************************************************');
              String endpoint = System.Label.AWS_CaseArchival_Root_URL+ bucket+'/'+fileName;
            HttpRequest requestPerm = new HttpRequest();
            HttpResponse responsePerm = new HttpResponse();
            if(String.isNotBlank(endpoint)){
                System.debug('Endpoint is :' +endpoint);
                requestPerm.setEndpoint(endpoint);
                requestPerm.setMethod('PUT');
                requestPerm.setHeader('Content-Type','text/plain');
                request.setHeader('x-amz-acl','public-read');
                requestPerm.setHeader('Authorization', 'AWS AKIAIXRMUKP2XKCSHNBA:nZOOCL0j+NDww7rfrjA0WDzkx+g9a5OTA+YHaZ/w');
            
            }
            Http httpObjPerm = new Http();
            responsePerm = httpObjPerm.send(requestPerm);
            System.debug('responsePerm Code Is : '+responsePerm.getStatus());
            //
 } 
    private static String make_sig(string canonicalBuffer, AWS_credentials__c credentials) {        
        String macUrl ;
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(credentials.Secret__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    private String uploadEmbeddedImage(String richTextValue, String bucket, String folder){
        if(richTextValue.contains('src=')){
             richTextValue =  richTextValue.replaceAll('\\?', '');
             while(richTextValue.contains('src="https://ca')){
                    String locationURL = richTextValue.substring(richTextValue.indexOf('src="https://ca')+5, richTextValue.indexOf('" width'));
                    String url = locationURL.replace('amp;', '');
                    url = url.replace('rtaImage', 'rtaImage?');
                    String name = url.substring(url.indexOf('refid=')+6);
                    if(url.contains('FileDownloadfile')){
                        url = url.replace('FileDownloadfile', 'FileDownload?file');
                        if(url.contains('alt')){
                            url = url.substring(0, url.indexOf(' alt')-1);
                        }
                        name = url.substring(url.indexOf('=')+1);
                    }
                    PageReference pageReference = new PageReference(url);
                    richTextValue = richTextValue.replaceFirst(locationURL, 'https://s3.amazonaws.com/' + bucket + '/' + folder+'/EmbeddedImages/'+name+'.png');
                    richTextValue = richTextValue.replaceFirst('width', 'wwwww');
                    System.debug('****************: '+url);
                    uploadToAmazonS3(bucket, folder+'/EmbeddedImages/'+name+'.png', pageReference.getContent());
                }
         }
        if(null != richTextValue && !richTextValue.equalsIgnoreCase('')){
            richTextValue = richTextValue.replaceAll('wwwww', 'width');
        }
        return richTextValue;
    }

    private String formatData(String value){
        while(value.contains('<a ')){
            if(value.contains('<a href="http')){
                value = value.replace(value.subString(value.indexOf('<a href=\"http'), value.indexOf('</a>') + 4), '');
            }else{
                value = value.replace(value.subString(value.indexOf('<a href'), value.indexOf('target="_blank">') + 16), '');
                value = value.replace('</a>', '');
            }
        }

        value = (value.contains('\r') ? value.replaceAll('\r', '') : value);
        value = (value.contains('\'') ? value.replaceAll('\'', '&#39;') : value);
        //value = (value.contains('\\') ? value.replaceAll('\\', '&#92;') : value);
        
        //value = (value.contains('N/A') ? '' : value);
        //value = (value.contains('This field is applicable only for articles migrated from ECM.') ? '' : value);
        //value = (value.contains('This field is applicable only for articles migrated from legacy sources.') ? '' : value);
        value = (value.equalsIgnoreCase('null') ? '' : value.trim());
        return value;
    }

    private String formatRichText(String value){
        //value = (value.contains('N/A') ? '' : value);
        value = (value.equalsIgnoreCase('null') ? '' : value.trim());
        value = (value.contains('\r') ? value.replaceAll('\r', '') : value);
        //value = (value.contains('<') ? value.replaceAll('<', '&#60;') : value);
        //value = (value.contains('>') ? value.replaceAll('>', '&#62;') : value);
        value = (value.contains('\'') ? value.replaceAll('\'', '&#39;') : value);
        //value = (value.contains('\\') ? value.replaceAll('\\', '&#92;') : value);
        //value = (value.contains('This field is applicable only for articles migrated from ECM.') ? '' : value);
        //value = (value.contains('This field is applicable only for articles migrated from legacy sources.') ? '' : value);
        return value;
    }
}