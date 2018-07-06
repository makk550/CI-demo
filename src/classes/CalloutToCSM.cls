public Class CalloutToCSM {

    private static External_RnD__c externalRequest;
    private static External_Request_Comments__c comment ;
    private static Attachment attachment ; 
    
    public static void createLog(String externalRequestId){
        
        List<External_RnD__c> externalRndList = [select id,case__c from External_RnD__c where id =: externalRequestId limit 1];
              String body = setCreateRequestBody(externalRequestId);
            CSMErrorLog__c Log = new CSMErrorLog__c();
            Log.External_Request__c = externalRequestId;
            Log.Case__c = externalRndList.get(0).Case__C;
            Log.Request_Payload__c = body;
             Log.Request_Sent__c = datetime.now();
            try{insert Log;
                system.debug('A*A logInserId'+Log.Id);
                }
            catch(DMLException e){
                
                system.debug(e.getMessage());}
        
        
    }
    
    
    @future(callout=true)
    public static void createIncident(String externalRequestId){   
         try{
             HttpRequest req = new HttpRequest();
             req.setEndpoint(Label.CSM_Integration_Endpint);
             req.setMethod('POST');
             req.setHeader('Content-Type', 'application/json');
             req.setHeader('Authorization', Label.CSM_Authorization_Code);
             req.setTimeout(Integer.valueof(Label.CSMTimeout));
               String body = setCreateRequestBody(externalRequestId);
             if(string.IsNotBlank(body)){
                 req.setBody(body);
                 Http http = new Http();
                 HTTPResponse res;
                 if(!Test.isRunningTest()){
                     res = http.send(req);
                 }
                 String response = res.getBody();
                 system.debug('A*A responseBody '+response);
                  List<CSMErrorLog__c> updateLog = [select id from CSMErrorLog__C where External_Request__c =: externalRequestId ];
                 system.debug('A*A updateLog '+updateLog);
                 if(updateLog!=null && updateLog.size()>0){
                 try{updateLog.get(0).response_Message__c = response;
                     update updateLog.get(0);
                     system.debug('A*A update SUccessfull updated Log id '+ updateLog.get(0).response_Message__c);}
                 catch(DMLException e){}
                 }
                 parseResponse(response);
             }
         }catch(Exception e){
            sendExceptionMail(e.getTypeName()+' '+e.getMessage()+'  '+e.getStackTraceString());
         }
    }
    public static void updateIncident(IncidentUpdateRequest incident,String Id){ 
        try{     
            externalRequest = queryExternalRequest(Id);
            String body = setUpdateRequestBody(incident,externalRequest);
            if(string.IsNotBlank(body) && externalRequest.Reference_ID__c!=null){
                updateIncidentCallout(externalRequest.Reference_ID__c,body);
            }
        }catch(Exception e){
            sendExceptionMail(e.getTypeName()+' '+e.getMessage()+'  '+e.getStackTraceString());
        }
    }
    public static void createComment(String Id){
        try{
            comment = queryComment(Id);
            String body = setCommentCreateBody(comment);
            if(string.IsNotBlank(body) && comment.ParentId__r.Reference_ID__c!=null){
                createCommentCallout(comment.ParentId__r.Reference_ID__c,body);
            }
        }catch(Exception e){
            sendExceptionMail(e.getTypeName()+' '+e.getMessage()+'  '+e.getStackTraceString());
        }
    }
    public static void createAttachemnt(String Id){
        try{
            attachment =  queryAttachment(Id);
            externalRequest = queryExternalRequest(attachment.parentId);
            String body = setCreateAttachmentBody();
            createAttachmentCallout(body,externalRequest.Reference_ID__c);
        }catch(Exception e){
            //sendExceptionMail(e.getTypeName()+' '+e.getMessage()+'  '+e.getStackTraceString());
            sendAttachmentExceptionMail();
        }
        
    } 
    public static void cancelIncident(String Id){
        try{
            String body = setCancelIncidentBody();
            updateIncidentcallout(Id,body);
        }catch(Exception e){
            sendExceptionMail(e.getTypeName()+' '+e.getMessage()+'  '+e.getStackTraceString());
        }
    }   
    @future(callout=true)
    public static void createAttachmentCallout(String body,String incidentNumber){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.CSM_Integration_Endpint+'/'+incidentNumber);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', Label.CSM_Authorization_Code);
        req.setTimeout(Integer.valueof(Label.CSMTimeout));
        system.debug('reuqest body-----'+body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res;
        String response ;
        if(!Test.isRunningTest()){
             res = http.send(req);
             response = res.getBody();
        }
       
        system.debug('response body-----'+response);
    }
    @future(callout=true)
    public static void createCommentCallout(String incidentNumber,String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.CSM_Integration_Endpint+'/'+incidentNumber+'/comment');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', Label.CSM_Authorization_Code);
        req.setTimeout(Integer.valueof(Label.CSMTimeout)); 
        system.debug('request body-----'+body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res;
        String response;
        if(!Test.isRunningTest()){
             res = http.send(req);
             response = res.getBody();
        }
        system.debug('response body-------'+response); 
    }    
    
    @future(callout=true)
    public static void updateIncidentcallout(String  incidentNumber,String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.CSM_Integration_Endpint+'/'+incidentNumber);
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', Label.CSM_Authorization_Code);
        req.setTimeout(Integer.valueof(Label.CSMTimeout)); 
        system.debug('request body-----'+body);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res;
        String response;
        if(!Test.isRunningTest()){
             res = http.send(req);
             response = res.getBody();
        }
        system.debug('response body-----'+response); 
        
    }
    public static String setCancelIncidentBody(){
        JSONGenerator jGenerator = JSON.createGenerator(true);
        jGenerator.writeStartObject();
        jGenerator.writeStringField('status','Closed');
        List<IncidentRequest.fieldProperty> fieldPropertyList  = new List<IncidentRequest.fieldProperty>();
            
        IncidentRequest.fieldProperty fieldProperty = new IncidentRequest.fieldProperty();
        fieldProperty.name = 'lastSyncTime__c';
        fieldProperty.value = String.valueof(DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        fieldPropertyList.add(fieldProperty);
        fieldProperty = new IncidentRequest.fieldProperty();
        fieldProperty.name = 'phase__c';
        fieldProperty.value = 'Closure';
        fieldPropertyList.add(fieldProperty);
        fieldProperty = new IncidentRequest.fieldProperty();
        fieldProperty.name = 'reasonCode__c';
        fieldProperty.value = 'Cancelled';
        fieldPropertyList.add(fieldProperty);
        jGenerator.writeFieldName('customproperties');
        jGenerator.writeStartObject();
        jGenerator.writeObjectField('property', fieldPropertyList); 
        jGenerator.writeEndObject();
        jGenerator.writeEndObject();
        // Get the JSON string
        String jsonReq = jGenerator.getAsString();
        system.debug('jsonReq===='+jsonReq);
        return jsonReq;
        
    }
    public static String setCreateAttachmentBody(){
        AttachmentRequest  attachmentreq = new AttachmentRequest();
        attachmentreq.contentType = 'text/JSON' ;
        attachmentreq.data = EncodingUtil.base64Encode(attachment.body);
        attachmentreq.description  = 'attachment';
        attachmentreq.fileName = attachment.Name;
        List<AttachmentRequest> attachmentreqList = new List<AttachmentRequest>(); 
        attachmentreqList.add(attachmentreq);
        
        JSONGenerator jGenerator = JSON.createGenerator(true);
        jGenerator.writeStartObject();
        jGenerator.writeFieldName('attachments');
        jGenerator.writeStartObject();
        jGenerator.writeObjectField('attachment', attachmentreqList); 
        jGenerator.writeEndObject();
        jGenerator.writeEndObject();
        // Get the JSON string
        String jsonReq = jGenerator.getAsString();
        system.debug('jsonReq===='+jsonReq);
        return jsonReq;
        
    }
    public static String setCommentCreateBody(External_Request_Comments__c iComment){
        JSONGenerator jGenerator = JSON.createGenerator(true);
        jGenerator.writeStartObject();
        jGenerator.writeStringField('commentText',iComment.Comments__c);
        jGenerator.writeStringField('commentType','Update');
         jGenerator.writeEndObject();
        // Get the JSON string
        String jsonReq = jGenerator.getAsString();
        system.debug('jsonReq===='+jsonReq);
        return jsonReq;
    }
    public static String setUpdateRequestBody(IncidentUpdateRequest incident,External_RnD__c iExternalRequest){
        
        List<IncidentRequest.fieldProperty> fieldPropertyList  = new List<IncidentRequest.fieldProperty>();
            
        IncidentRequest.fieldProperty fieldProperty = new IncidentRequest.fieldProperty();
        fieldProperty.name = 'lastSyncTime__c';
        fieldProperty.value = String.valueof(DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        fieldPropertyList.add(fieldProperty);
        
        JSONGenerator jGenerator = JSON.createGenerator(true);
        jGenerator.writeStartObject();
        if(incident.severity){
            jGenerator.writeStringField('severity',iExternalRequest.Severity__c);
        }
        if(incident.priority){
            jGenerator.writeStringField('priority',iExternalRequest.Priority__c);
        }
        if(incident.label){
            jGenerator.writeStringField('label',iExternalRequest.Subject__c);
        }
        if(incident.description){
            jGenerator.writeStringField('description',iExternalRequest.SaaS_Description__c);
        }
        jGenerator.writeFieldName('customproperties');
        jGenerator.writeStartObject();
        jGenerator.writeObjectField('property', fieldPropertyList); 
        jGenerator.writeEndObject();
        jGenerator.writeEndObject();
        // Get the JSON string
        String jsonReq = jGenerator.getAsString();
        system.debug('jsonReq===='+jsonReq);
        return jsonReq;
    }
    public static String setCreateRequestBody(String Id){
        String jsonReq;
        externalRequest = queryExternalRequest(Id);
        if(externalRequest!=null){
            List<User> assignedUserList = [select Id , Name , FirstName , LastName , pmfkey__c ,email
                                           from User 
                                           where Id =:externalRequest.CreatedById  
                                           limit 1
                                          ];
            List<IncidentRequest.fieldProperty> fieldPropertyList  = new List<IncidentRequest.fieldProperty>();
            
            IncidentRequest.fieldproperty fieldProperty = new IncidentRequest.fieldproperty(); 
            fieldProperty.name = 'siteAssociation__c';
            fieldProperty.value = externalRequest.case__r.Site_Name__c;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldproperty(); 
            fieldProperty.name = 'topsSiteId__c';
            fieldProperty.value = externalRequest.case__r.Tops_Support_Site_ID__c;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldproperty(); 
            fieldProperty.name = 'caProduct__c';
            fieldProperty.value = externalRequest.case__r.CA_Product_Controller__r.Name;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldproperty(); 
            fieldProperty.name = 'caProductComponent__c';
            fieldProperty.value = externalRequest.case__r.CA_Product_Component__r.Name;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'sevOneImpact__c';
            fieldProperty.value = externalRequest.case__r.Sev_1_Impact_c__c;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'productionDownStatus__c';
            fieldProperty.value = externalRequest.case__r.Production_Down_Status__c;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'environmentType__c';
            fieldProperty.value = externalRequest.case__r.Customer_Environment__c;
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'dueDate__c';
            if(externalRequest.Due_Date__c!=null){
                fieldProperty.value = String.valueof(externalRequest.Due_Date__c.format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
                fieldPropertyList.add(fieldProperty);
            }
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'lastSyncTime__c';
            fieldProperty.value = String.valueof(DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
            fieldPropertyList.add(fieldProperty);
            
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'externalRequestType__c';
            fieldProperty.value = externalRequest.SaaS_Type__c;
            fieldPropertyList.add(fieldProperty);
                 
            fieldProperty = new IncidentRequest.fieldProperty();
            fieldProperty.name = 'externalRequestId__c';
            fieldProperty.value = externalRequest.Id;
            fieldPropertyList.add(fieldProperty);
            
            if(assignedUserList!=null && assignedUserList.Size()>0){
                    fieldProperty = new IncidentRequest.fieldProperty();
                    fieldProperty.name = 'scOwnerFirstName__c';
                    fieldProperty.value = assignedUserList[0].firstName ; 
                    fieldPropertyList.add(fieldProperty);
                    
                    fieldProperty = new IncidentRequest.fieldProperty();
                    fieldProperty.name = 'scOwnerLastName__c';
                    fieldProperty.value = assignedUserList[0].lastName ; 
                    fieldPropertyList.add(fieldProperty);
                    
                    fieldProperty = new IncidentRequest.fieldProperty();
                    fieldProperty.name = 'scOwnerEmail__c';
                    fieldProperty.value = assignedUserList[0].email ; 
                    fieldPropertyList.add(fieldProperty);
                    
                    fieldProperty = new IncidentRequest.fieldProperty();
                    fieldProperty.name = 'scOwnerPMFKey__c';
                    fieldProperty.value = assignedUserList[0].pmfkey__c ; 
                    fieldPropertyList.add(fieldProperty);
            }
            IncidentRequest.cProperty property = new IncidentRequest.cProperty(fieldPropertyList);
            
            IncidentRequest iRequest = new IncidentRequest(externalRequest.SaaS_Description__c,externalRequest.Severity__c,externalRequest.Subject__c,externalRequest.Priority__c,property);
            jsonReq = JSON.serialize(iRequest);
            system.debug('======'+jsonReq);
            
        }
        return jsonReq;
    }
    public static void  parseResponse(String res){
        system.debug('res======='+res);
        IncidentResponse incident = (IncidentResponse)JSON.deserialize(res, IncidentResponse.class);
        system.debug('Incident-------'+incident);
        externalRequest.Reference_ID__c = incident.incidentId;
        externalRequest.SaaS_Incident_Group_Owner__c = incident.assigneeGroup;
        if(incident.customproperties!=null && incident.customproperties.property!=null && incident.customproperties.property.size()>0){
            for(Integer i=0 ; i<incident.customproperties.property.size() ; i++ ){
                if(incident.customproperties.property[i].name.equalsIgnoreCase('reasonCode__c')){
                    externalRequest.SaaS_Incident_Status__c = incident.customproperties.property[i].value;
                }
            }
        }
        update externalRequest; 
        
    }
    public static External_RnD__c queryExternalRequest(String Id){
       List<External_RnD__c> externalRequestList = [Select Id ,Name , Case__c , Case__r.Id, case__r.Sev_1_Impact_c__c,
                                                            case__r.Production_Down_Status__c,case__r.Site_Name__c,
                                                            case__r.Tops_Support_Site_ID__c,due_date__c,CreatedById,
                                                            case__r.CA_Product_Controller__r.Name, case__r.CA_Product_Component__r.Name,
                                                            case__r.Customer_Environment__c,Subject__c , Severity__c , SaaS_Description__c ,
                                                            Priority__c ,Reference_ID__c,SaaS_Type__c,task_Id__c
                                                     from External_RnD__c 
                                                     where Id =: Id 
                                                    ];                                        
        if(externalRequestList!=null && externalRequestList.Size()>0){   
            externalRequest = new External_RnD__c();
            externalRequest = externalRequestList[0];
        }
        return externalRequest;
    }
    public static External_Request_Comments__c queryComment(String Id){
       List<External_Request_Comments__c> commentList = [Select Id ,Name ,Comments__c,ParentId__c,ParentId__r.Reference_ID__c
                                                         from External_Request_Comments__c 
                                                         where Id =: Id 
                                                        ];                                        
        if(commentList!=null && commentList.Size()>0){   
            comment = new External_Request_Comments__c();
            comment = commentList[0];
        }
        return comment;
    }
    public static Attachment queryAttachment(String Id){
        List<Attachment> attachmentList = [Select Id , Name , Body , ParentId
                                           from Attachment 
                                           where Id = :Id 
                                          ];
       if(attachmentList!=null && attachmentList.Size()>0){
          attachment = new Attachment();
          attachment = attachmentList[0];
       }
       return attachment;                                     
    }    
    private static void sendExceptionMail(String mailBody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String emailAdd = Label.CSM_Exception_Mail_Recipient ;
        String[] toAddresses = new String[] {emailAdd};
        mail.setToAddresses(toAddresses);
        mail.setSubject('CSM Integration Exception');
        mail.setUseSignature(false);
        mail.setPlainTextBody(mailBody);
        List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
        mails.add(mail);
        Messaging.sendEmail(mails);
    } 
    private static void sendAttachmentExceptionMail(){
        Task task = [Select OwnerId from Task where Id =: externalRequest.task_Id__c limit 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('SC to CSM Attachment Failure Notification');
        mail.setUseSignature(false);
        mail.setTargetObjectId(task.OwnerId);
        mail.setSaveAsActivity(false);
        mail.setHTMLBody('Hi <br/> <br/> The Attachment : '+attachment.Name +' for External Request '+externalRequest.Name+' failed to upload on CSM due to exceeded size limit.') ;
        List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
        mails.add(mail);
        Messaging.sendEmail(mails);
    }  
}