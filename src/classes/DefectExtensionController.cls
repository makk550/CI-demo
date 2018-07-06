/*
 * This class is used for creating new defect and associate to case 
 * New defect is created from Rally and details are stored in Service Cloud once Rally sends success message with Defect number
 */
public class DefectExtensionController{
    public Defect__c defect;
    public Defect_Comment__c comment {get;set;}
    public Id caseId{get;set;}
    public Case caseRec {get;set;}
    public List<Defect_Case_Association__c> defCaseRef;
    private String requestor=''; 
    public Boolean showSave {get;set;}
    public String host{get;set;}
    public Boolean showContinue {get;set;} 
    public String responseFromService;
    public Boolean showCancel{get;set;}
    
    Id devRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Other Support Task').getRecordTypeId();
     DateTime d = datetime.now();
     String timeStr = d.format('yyyy-MM-dd hh:mm a');
    
    public DefectExtensionController(ApexPages.StandardController stdController) {
        showSave = true ; 
        showContinue = false;
        showCancel=false;
        this.defect= (Defect__c)stdController.getRecord();
        caseId = apexpages.currentpage().getparameters().get('caseid');
        comment = new Defect_Comment__c();
        host = 'https://' + apexpages.currentPage().getHeaders().get('Host') + '/' + caseId;
        caseRec = [select Id,casenumber,BusinessHoursId,Business_Impact__c,Contact.Email,Contact.Phone, contact.Name, Priority , Severity__c , CA_Product_Controller__r.Name,CA_Product_Controller__r.Product_ID__c,ContactId,Product_Material__r.Product_ID__c,
                          CA_Product_Component__r.Component_Code__c,CA_Product_Component__r.Name,Site_Name__c, Tops_Support_Site_ID__c,
                          Customer_Environment__c,owner.type , ownerId ,CreatedDate ,Product_Release__c,subject,description,Product_Material__c,Product_Release_Selection__c
                   from Case
                   where Id =:caseId limit 1
                  ];
        defect.Subject__c = caseRec.casenumber + '-'+ caseRec.subject ;
        defect.Description__c =caseRec.description ;
        defCaseRef = [select Case__c,Defect__c from Defect_Case_Association__c where case__c =:caseId limit 1];
        requestor = [select pmfkey__c from user where Id = :Userinfo.getuserid() limit 1].pmfkey__c;
   }
    
    public class comment{
        public string comment ;
        public string cdate ;
        public string author ;
    }
    
    public pageReference save(){
       /* if(defect.Type__c =='Notification Only'){
            
            Task t = new Task();        
            t.whatId =caseId ;      
            t.whoId =caseRec.ContactId;     
            t.recordTypeId =devRecordTypeId ;
             t.ownerId=Label.Support_Integration_User_Id;       
            t.Status = 'Not Started';       
            t.Severity__c = caseRec.Severity__c;        
            t.Priority ='Normal'; 
            t.subject ='Notification Only';      
            t.description='Task auto created by Notification Only  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' '+ timeStr + ')';        
            t.Type ='SE Info';
            
            insert t;
            pageReference page = new pageReference('/'+caseId);
             return page;
            
        }
        else{ */
            showSave = false ; 
            defect.Priority__c = caseRec.Priority;
            defect.Severity__c = caseRec.Severity__c;
        if((String.isBlank(caseRec.Product_Material__c)) || (String.isBlank(caseRec.Product_Release_Selection__c)) )
            {
                 ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Product code and Product Release Selection must be selected on case page to create or associate a defect');
               showCancel=true;
                ApexPages.addmessage(errorMsg);   
                return null;
            }
        
            createDefectCallout();
       // }
        return null;
        
    }
    public pageReference continueToCase(){
      pageReference page = new pageReference('/'+caseId);
      return page;
    }
    public void caseUpdateonDefectCreate()
    {
        Case caseRef = new Case();
        caseRef.Id = caseRec.id;
        Datetime currentDate=System.now();
        Datetime finalDate = null;
        Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
         if(defCaseRef.size()<=0)   
        {   
        caseRef.Troubleshooting_Stage__c = '3. Cause Determination';
        }
        caseRef.Next_Action__c = 'Pending CA Engineering (L2)';
        String severity =caseRec.Severity__c;
    
    
    if(caseRec.BusinessHoursId!=null){
        for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:caseRec.BusinessHoursId])
        taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
        
    }
        
        if(severity=='1' || severity=='2')
        {
            finalDate=BusinessHours.addGmt(caseRec.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseRec.BusinessHoursId)*Integer.valueOf('1'))*long.Valueof('3600000')));
        }
        else if(severity=='3' || severity=='4' ||  severity=='5')
        {
            finalDate=BusinessHours.addGmt(caseRec.BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseRec.BusinessHoursId)*Integer.valueOf('5'))*long.Valueof('3600000')));
        }
        
        caseRef.Next_Action_Due_Date__c =finalDate;
        if(!Test.isrunningTest()){
                update caseRef;
            }
    }
    public  void createAndAssociateDefect(){
        insert defect; 
       
        Defect_Case_Association__c defectCaseAssociation = new Defect_Case_Association__c();
        defectCaseAssociation.Defect__c = defect.Id ; 
        defectCaseAssociation.case__c = caseId;
        insert defectCaseAssociation;
        
        
        
            
        comment.Defect__c = defect.Id;
       
        //Start :US122267       
                
        Task t = new Task();        
        t.whatId =caseId ;      
        t.whoId =caseRec.ContactId;     
        t.recordTypeId =devRecordTypeId ; 
        t.ownerId=Label.Support_Integration_User_Id;      
        t.Status = 'Not Started';       
        t.Severity__c = caseRec.Severity__c;        
        t.Priority ='Normal'; 
        t.subject =defect.name;      
        t.description='Task auto created by Defect Integration  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' '+ timeStr + ')';        
        t.Type ='SE Action';        
                    
        insert t;       
         caseUpdateonDefectCreate();      

        //End
        if(comment.Comments__c!=null && comment.Comments__c!=''){
            insert comment;
            CaseComment caseCommentObject = new CaseComment();
            caseCommentObject.CommentBody = 'Defect # '+defect.Name+' Updated from ServiceCloud Case # '+caseRec.CaseNumber+'\nDiscussion: '+comment.Comments__c;
            caseCommentObject.ParentId = caseId;
            if(!Test.isrunningTest()){
                insert caseCommentObject;
            }
        }
        
    }
    public void createDefectCallout(){
       try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(buildEndpoint());
            req.setMethod('POST');
            req.setTimeout(Integer.valueof(Label.RallyTimeout));
            req.setHeader('Content-Type', 'application/json');
            req.setBody(createBody());
            HTTPResponse res;   
            String response ;
            if(!Test.isRunningTest()){
               Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
               responseFromService = Layer7UtilCalloutObj.processLayer7Services(req);
               system.debug('responseFromService---->'+responseFromService);
            }
            else{
                responseFromService = http.send(req).getBody();
                //res = http.send(req);
            }
            
            if(responseFromService == null || responseFromService ==''){
                 DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
                 defectErrorLogObj.defectErrorLogMethod(caseRec.casenumber,'',req.getBody(),responseFromService,req.getMethod(),0,req.getEndpoint());
                 CaseComment caseCommentObject = new CaseComment();
                 ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
                 ApexPages.addmessage(errMsg); 
                 caseCommentObject.CommentBody = 'Error- '+errMsg.getSummary();
                 caseCommentObject.ParentId = caseId;
                 UtilityFalgs.isDefectUpdate = true;
                 insert caseCommentObject;
            }else{
                parseResponse(responseFromService,req);
            }
        }Catch(Exception serviceException){
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(caseRec.casenumber,'','',serviceException.getMessage(),'',0,'');   
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'The defect you submitted timed out.  Thus, the defect has not been linked to the ServiceCloud case and might not have even been created in Rally.  If the Rally defect was created then it would contain the ServiceCloud case number in the Salesforce Case Number field in the defect and you can associate the defect to your ServiceCloud case.  If the defect was not created in Rally then you need to resubmit it');
            ApexPages.addmessage(errMsg); 
        }
        /*if(res.getStatusCode()==200 || res.getStatusCode()==400){
            response = res.getBody();
            parseResponse(response,req,res);
        }
        else{
             DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
             defectErrorLogObj.defectErrorLogMethod(caseRec.casenumber,'',req.getBody(),res.getBody(),req.getMethod(),res.getStatusCode(),req.getEndpoint());
             CaseComment caseCommentObject = new CaseComment();
             ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
             ApexPages.addmessage(errMsg); 
             caseCommentObject.CommentBody = 'Error- '+errMsg.getSummary();
             caseCommentObject.ParentId = caseId;
             UtilityFalgs.isDefectUpdate = true;
             insert caseCommentObject;
        }*/
    }
    /*
     * This method is used to create the JSON request for sending HHTP request to RALLY for new defect creation
     */
    public string createBody(){
        comment commentReq = new comment();
        commentReq.comment = comment.Comments__c;
        commentReq.author = requestor.toLowerCase();
        commentReq.cDate =  String.valueof(DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        List<comment> commentreqList = new List<comment>();
        if(commentReq.comment!=null && commentReq.comment!=''){
            commentreqList.add(commentReq);
        }
        JSONGenerator jGenerator = JSON.createGenerator(true);
        jGenerator.writeStartObject();
        jGenerator.writeStringField('subject',defect.subject__c);
        jGenerator.writeStringField('description',defect.Description__c);
        jGenerator.writeStringField('product',caseRec.CA_Product_Component__r.Name);
        jGenerator.writeStringField('component',caseRec.CA_Product_Component__r.Component_Code__c);
        jGenerator.writeStringField('externalSystemNumber',caseRec.casenumber);
        jGenerator.writeStringField('externalSystemID',caseRec.Id);
        jGenerator.writeStringField('severity',caseRec.Severity__c); 
        jGenerator.writeStringField('priority',caseRec.Priority);
        if(caseRec.Customer_Environment__c!=null && caseRec.Customer_Environment__c!=''){
            jGenerator.writeStringField('environment',caseRec.Customer_Environment__c);
        }
                
        jGenerator.writeStringField('contactName',(caseRec.contact.Name!=null && caseRec.contact.Name!='')?caseRec.contact.Name:'');
        jGenerator.writeStringField('contactEmail',(caseRec.contact.Email!=null && caseRec.contact.Email!='')?caseRec.contact.Email:'');
        jGenerator.writeStringField('contactPhone',(caseRec.Contact.Phone!=null && caseRec.Contact.Phone!='')?caseRec.Contact.Phone:'');
         if(caseRec.Business_Impact__c!=null && caseRec.Business_Impact__c!=''){
            jGenerator.writeStringField('businessImpact',caseRec.Business_Impact__c);
        } 
        
        jGenerator.writeStringField('caseURL',host);

        jGenerator.writeStringField('requestor',requestor.toLowerCase());
        jGenerator.writeStringField('customer',caseRec.Site_Name__c+' ('+caseRec.Tops_Support_Site_ID__c+')');
        jGenerator.writeStringField('createdDate',caseRec.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        if(caseRec.Product_Release__c!=null && caseRec.Product_Release__c!=''){
            jGenerator.writeStringField('productRelease',caseRec.Product_Release__c);
        }
        //Start :US352825
        if(caseRec.CA_Product_Controller__r.Product_ID__c!=null && caseRec.CA_Product_Controller__r.Product_ID__c!=''){
            jGenerator.writeStringField('productMaterialProdId',caseRec.CA_Product_Controller__r.Product_ID__c);
            
        }
        else{
            jGenerator.writeStringField('productMaterialProdId','');
        }
        //end
        
        //start : US348147      
        jGenerator.writeStringField('defectType',defect.Type__c);       
        //end
        if(commentReq.comment !=null && commentReq.comment!='' && commentreqList!=null){
            jGenerator.writeObjectField('comments', commentreqList);  
        }         
        jGenerator.writeEndObject();
        String jsonReq = jGenerator.getAsString();
        jsonReq = jsonReq.replace('cdate','date');
        system.debug('jsonReq===='+jsonReq);
        return jsonReq;
    }
   /*
    * This method is used to pasre the JSON response and add proper message on screen depending on success or failure
    */
         @TestVisible  
         private void parseResponse(String res,HttpRequest req){
         system.debug('response'+res);
         res = res.replace('\\"','\\\"');
         res = res.removeStart('[');
         res = res.removeEnd(']');
         
         DefectResponse defectRes = (DefectResponse)JSON.deserialize(res, DefectResponse.class);
         CaseComment CaseCommentObject = new CaseComment();
         if(defectRes.successful){
             showContinue = true;
             defect.name = defectRes.uiId;
             defect.Defect_URL__c = defectRes.uiURL;
             defect.Defect_Submitted_By__c = UserInfo.getName();
             defect.Defect_UUID__c = defectRes.uiURL.substringAfterLast('/'); // extract the UUID of defect      
             defect.Defect_Object_ID__c = defectRes.objectId;
             defect.Priority__c = defectRes.defectPriority;
             defect.Severity__c = defectRes.defectSeverity;
             defect.R_D_System__c = defectRes.workspaceName;
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Defect Creation Successful <br/> Defect Id : '+defectRes.uiId+'<br/> Workspace '+defectRes.workspaceName+' <br/> Click on Continue');
             ApexPages.addmessage(msg);
             caseCommentObject.CommentBody = 'Defect '+ defectRes.uiId +' successfully created';
             if(defectRes.warnings!=null && defectRes.warnings.size()>0){
                ApexPages.Message warningMsg = new ApexPages.Message(ApexPages.Severity.WARNING, defectRes.warnings[0].detail);
                ApexPages.addmessage(warningMsg);
                caseCommentObject.CommentBody = caseCommentObject.CommentBody + '\r\n Warning-'+warningMsg.getSummary();
                
             }
             createAndAssociateDefect(); 
         }else{
             
             DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
             defectErrorLogObj.defectErrorLogMethod(caseRec.casenumber,'',req.getBody(),responseFromService,req.getMethod(),0,req.getEndpoint());
             ApexPages.Message errMsg;
             if(defectRes.errors[0].detail != null && defectRes.errors[0].detail.contains('Your Product on this Case does not have a Project mapping in CA Agile Central')){
                   Task t = new Task();        
                    t.whatId =caseId ;      
                    t.whoId =caseRec.ContactId;
                    t.ownerId =Label.Support_Integration_User_Id;       
                    t.recordTypeId =devRecordTypeId ;       
                    t.Status = 'Not Started';       
                    t.Severity__c = caseRec.Severity__c;        
                    t.Priority ='Normal'; 
                    t.subject ='Auto-Created by SE Engagement – No associated Agile Central Project';      
                    t.description='Task auto created by Defect Integration  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' '+ timeStr + ')';        
                    t.Type ='SE Action';        
                                
                    insert t;
                  showCancel=true;
                  errMsg = new ApexPages.Message(ApexPages.Severity.WARNING, Label.Rally_Prodcut_Mapping_Warning_msg);
             }
             else{
                 errMsg = new ApexPages.Message(ApexPages.Severity.FATAL, defectRes.errors[0].detail);
             }
             ApexPages.addmessage(errMsg);
             caseCommentObject.CommentBody = 'Error- '+errMsg.getSummary();
         }
         caseCommentObject.ParentId = caseId;
         UtilityFalgs.isDefectUpdate = true;
         if(!Test.isrunningTest()){
             insert caseCommentObject;
         }
    }
   /*
    * Method used to determine if org instance is sandbox or production and use endpoint respectively 
    */
    public string buildEndpoint(){
        String endpoint ;
        Organization org = [select Id, IsSandbox from Organization limit 1 ];
        if(org.IsSandbox){
             endpoint = Label.RallyEndpointQA;
        }
        else {
             endpoint = Label.RallyProductionEndpoint;
        }
        return endpoint;
    }
}