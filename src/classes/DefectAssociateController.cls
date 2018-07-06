/*
Created By: Tarun Sharma
Created On: 10/01/2015
Purpose: B-04030: Associate an existing Defect to Case
Modified By:
*/
public class DefectAssociateController{
    
    public String defectName{get;set;}
    public String systemName{get;set;}
    public String defectType{get;set;}
    public Boolean isUpdateCallOut = false;
    public Boolean submitRecord{get;set;}
    public Boolean continueSubmitRecord{get;set;}
    public Boolean fixedorClosed{get;set;}
    public String currentRecordId;
    public String host{get;set;}
    public List<Case> caseObj;
    public List<Defect_Case_Association__c> defCaseRef;
    private String requestor=''; 
    public String updateWarningMsg;
    public String updateSuccessMsg;
    public String insertUiURL;
    public String uuid ; // unique identifier of defect 
    public CaseComment caseCommentObject;
    public String responseFromGetService;
    public String responseFromUpdateService;
    public List<Defect__c> defRec; 
   // public List<Defect__c> defRecstat;
    
    public DefectAssociateController(){
        submitRecord = true;
        continueSubmitRecord = false;
        currentRecordId = apexpages.currentpage().getparameters().get('caseId');
        host = 'https://' + apexpages.currentPage().getHeaders().get('Host') + '/' + currentRecordId;
        systemName = 'Rally'; //Rally is default value for R&D System
        defectType = 'Defect'; //Defect is default value for defect type
    }
    
    public pageReference cancelAssociation(){
        return new pagereference('/'+currentRecordId);
    }
    
    public pageReference submitDefectAssociate(){
        list<Defect__c> defectObj;
        
        if(defectName == '' || defectName == null){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter the value for Defect ID');
            ApexPages.addmessage(errMsg);
            return null;
       }
        else{
            caseObj = [Select ContactId,BusinessHoursId,CA_Product_Component__r.Name,Product_Release__c,Product_Material__r.Product_ID__c,
                       CA_Product_Component__r.Component_Code__c,CA_Product_Controller__r.Product_ID__c,Severity__c,Priority,
                       Customer_Environment__c,contact.Name,contact.Email,Contact.Phone,Business_Impact__c,CA_Product_Controller__r.Name,CaseNumber, Subject, 
                       Id, Tops_Support_Site_ID__c, Site_Association__r.Name,description,CreatedDate,Product_Material__c,Product_Release_Selection__c
                       from 
                       Case 
                       where Id=:currentRecordId limit 1];
            defCaseRef = [select Case__c,Defect__c from Defect_Case_Association__c where case__c =:currentRecordId limit 1];
            requestor=[select pmfkey__c from user where Id = :Userinfo.getuserid() limit 1].pmfkey__c;
            
            defRec =[Select Name,Subject__c,Type__c,Description__c,Status__c from Defect__c where Name= :defectName limit 1];
            
           if((String.isBlank(caseObj[0].Product_Material__c)) || (String.isBlank(caseObj[0].Product_Release_Selection__c)))
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Product code and Product Release Selection must be selected on case page to create or associate a defect');
                ApexPages.addmessage(errorMsg);   
                return null;
            }



            checkDefectCallOut();
        }
        return null;
    }
    
    public pageReference continueSubmitAssocaite(){//After successfully inserted a record in defect case association object then navigate user back to case detail page
        if(fixedorClosed==false) {
        caseUpadteOnDefectAssociate();
        }

        return new pagereference('/'+currentRecordId);
    }
    
    public void checkDefectCallout(){
        try{
            String productName;
            if(caseObj[0].CA_Product_Component__r.Name.contains(' ')){
              productName  = caseObj[0].CA_Product_Component__r.Name.replaceAll(' ','+');
            }else{
              productName = caseObj[0].CA_Product_Component__r.Name;
            }
            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            httpRequestObj.setMethod('GET');
            httpRequestObj.setEndpoint(prepareEndPoint()+'&defectNumber='+defectName+'&product='+productName);
            httpRequestObj.setHeader('Content-Type', 'application/json');
            httpRequestObj.setTimeout(Integer.valueof(Label.RallyTimeout));
            HTTPResponse httpResponseObj;
            String jsonResponse;
            if(!Test.isRunningTest()){
                Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
                responseFromGetService = Layer7UtilCalloutObj.processLayer7Services(httpRequestObj);
                system.debug('--responseFromGetService -->'+responseFromGetService);
            }else{
                responseFromGetService = httpObj.send(httpRequestObj).getBody();
                system.debug('--responseFromGetService----response -->'+httpObj.send(httpRequestObj).getBody());
            }
            
            if(responseFromGetService== null || responseFromGetService==''){
               DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
               defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,httpRequestObj.getBody(),responseFromGetService,httpRequestObj.getMethod(),0,httpRequestObj.getEndpoint());
               ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
               ApexPages.addmessage(errMsg);
            }else{
                prepareResponse(responseFromGetService,httpRequestObj);
            }
        }Catch(Exception serviceException){
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,'',serviceException.getMessage(),'',0,'');   
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'The defect you submitted timed out.  Thus, the defect has not been linked to the ServiceCloud case and might not have even been created in Rally.  If the Rally defect was created then it would contain the ServiceCloud case number in the Salesforce Case Number field in the defect and you can associate the defect to your ServiceCloud case.  If the defect was not created in Rally then you need to resubmit it');
            ApexPages.addmessage(errMsg); 
        }
    }
    
    public String prepareEndPoint(){
        String retreiveEndPoint;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
            retreiveEndPoint = Label.RallyGetEndpointQA;
        }
        else {
             retreiveEndPoint = Label.RallyProductionGetEndpoint;
        }
        return retreiveEndPoint;
   }
   
     public void prepareResponse(String response, HttpRequest httpRequestObj){
         system.debug('service response------------>'+response);
         response = response.replace('\\"','\\\"');
         response = response.removeStart('[');
         response = response.removeEnd(']');
         system.debug('JSON------->'+response);
         
         Id devRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Other Support Task').getRecordTypeId();
          DateTime d = datetime.now();
          String timeStr = d.format('yyyy-MM-dd hh:mm a');
        
         AssociateDefectResponse associateDefectObject = (AssociateDefectResponse)JSON.deserialize(response, AssociateDefectResponse.class);
         system.debug('associateDefectObject----->'+associateDefectObject);
         //uuid = associateDefectObject.defect.defectId.substringAfterLast('/'); // extract the UUID of defect 
         if(associateDefectObject<>null){
             if((!associateDefectObject.successful)){
                 ApexPages.Message errMsg;
                 DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
                 defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,httpRequestObj.getBody(),responseFromGetService,httpRequestObj.getMethod(),0,httpRequestObj.getEndpoint());
                 if(associateDefectObject.errors <> null && associateDefectObject.errors.size()>0){ 
                   errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,associateDefectObject.errors[0].detail);
                 }else if(associateDefectObject.warnings<>null && associateDefectObject.warnings.size()>0){
                     if(associateDefectObject.warnings[0].cause<>null && associateDefectObject.warnings[0].cause.contains('Defect not found')){ 
                        errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'The Defect number does not exist in the CA or Rally workspace');
                     }else{
                        errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,associateDefectObject.warnings[0].detail);
                     }
                 }
                 ApexPages.addmessage(errMsg);
             }else{
                //US243917----START
                  uuid = associateDefectObject.defect.defectId.substringAfterLast('/'); // extract the UUID of defect
                //US243917----END
                List<Defect__c> defObj;
                 
                if(associateDefectObject.defect<>null && associateDefectObject.defect.defectNumber<>null){
                    defObj = [Select Id, Defect_Object_ID__c,Status__c, Name from Defect__c where Name=:associateDefectObject.defect.defectNumber and Defect_UUID__c  =: uuid and R_D_System__c=:associateDefectObject.defect.workspacename limit 1];
                }
                 if(associateDefectObject.defect.Status =='Closed' || associateDefectObject.defect.Status =='Fixed') {
                
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'The defect being associated is currently \'Fixed /Closed\'. No SE Action task will be created. You must leverage the details of the closed Defect to solve your case or create a new engagement/Defect if you need assistance from SE.' );
                        ApexPages.addmessage(errMsg);
                        //isUpdateCallOut=false;
                        //defObj =null;
                       // return null; 
                
                }
                if(defObj<>null && defObj.size()>0){
                   list<Defect_Case_Association__c> existingRecord = [select Case__c from Defect_Case_Association__c where Case__c=:currentRecordId AND Defect__c=:defObj[0].Id   limit 1]; // to check same record already exist in defect case association object
                
                   
                    if(existingRecord<> null  && existingRecord.size()==0){
                        if(defObj[0].Defect_Object_ID__c <> null){
                            updateDefectCaseAssociation(defObj[0].Defect_Object_ID__c,caseObj);
                        }
                        if(isUpdateCallOut){
                         System.debug('======='+isUpdateCallOut+'####'+defObj[0]);
                            submitRecord = false;
                            continueSubmitRecord = true;
                            Defect_Case_Association__c defectCaseAssociateObj = new Defect_Case_Association__c();
                            defectCaseAssociateObj.Case__c = currentRecordId;
                            defectCaseAssociateObj.Defect__c = defObj[0].Id;
                            insert defectCaseAssociateObj;
                             System.debug('======='+defectCaseAssociateObj);
                            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Association successful');
                            ApexPages.addmessage(errMsg);
                            caseCommentObject = new CaseComment();
                            caseCommentObject.CommentBody = 'Defect '+associateDefectObject.defect.defectNumber+' successfully associated';
                            caseCommentObject.ParentId = currentRecordId;
                            UtilityFalgs.isDefectUpdate = true; 
                            insert caseCommentObject;
                           
                           if(defObj[0].Status__c !='Closed' && defObj[0].Status__c !='Fixed') {
                           
                                fixedorClosed =false;
                                                                 
                                Task t = new Task();        
                                t.whatId =caseObj[0].Id;      
                                t.whoId =caseObj[0].ContactId;
                                t.ownerId=Label.Support_Integration_User_Id;     
                                t.recordTypeId =devRecordTypeId ;       
                                t.Status = 'Not Started';       
                                t.Severity__c = caseObj[0].Severity__c;        
                                t.Priority ='Normal'; 
                                t.subject =defObj[0].Name;      
                                t.description='Task auto created by Defect Integration by  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' and '+ timeStr + ')';        
                                t.Type ='SE Action';
                            
                                insert t;
                               
                            }
                            if(defObj[0].Defect_Object_ID__c <> null){
                                ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.Confirm, updateSuccessMsg);
                                ApexPages.addmessage(successMsg);
                                if(updateWarningMsg<>null){
                                    ApexPages.Message updateWarnMsg = new ApexPages.Message(ApexPages.Severity.WARNING,updateWarningMsg);
                                    ApexPages.addmessage(updateWarnMsg);
                                }
                            }
                        }
                    }else{
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, defObj[0].Name + ' already associate with the same case number');
                        ApexPages.addmessage(errMsg);
                    }
                }else{
                    
                    if(associateDefectObject.defect<>null && associateDefectObject.defect.defectId<>null){
                        updateDefectCaseAssociation(associateDefectObject.defect.defectId,caseObj);
                    }
                                    
                    if(isUpdateCallOut && associateDefectObject.defect<>null){
                        
                        Defect__c defectObject = new Defect__c();
                        if(associateDefectObject.defect.defectNumber<>null){
                            defectObject.Name = associateDefectObject.defect.defectNumber;
                        }
                        //defectObject.Defect_Id__c = associateDefectObject.uiId;
                        if(associateDefectObject.defect.defectOwner<>null){
                            defectObject.Defect_Owner__c = associateDefectObject.defect.defectOwner;
                        }
                        if(String.isNotBlank(insertUiURL)<>null){
                            defectObject.Defect_URL__c = insertUiURL;//associateDefectObject.defect.uiURL;
                            defectObject.Defect_UUID__c = insertUiURL.substringAfterLast('/'); // extract the UUID of defect    
                        }
                        if(associateDefectObject.defect.defectId<>null){
                            defectObject.Defect_Object_ID__c = associateDefectObject.defect.defectId;
                        }
                        if(associateDefectObject.defect.status<>null){
                         defectObject.Status__c = associateDefectObject.defect.status;
                        }
                        if(associateDefectObject.defect.defectPripority<>null){
                            defectObject.Priority__c = associateDefectObject.defect.defectPripority;
                        }
                        if(associateDefectObject.defect.subject<>null){
                            defectObject.Subject__c = associateDefectObject.defect.subject;
                        }
                        if(associateDefectObject.defect.defectSeverity<>null){
                            defectObject.Severity__c = associateDefectObject.defect.defectSeverity;
                        }
                        if(associateDefectObject.defect.description<>null){
                            defectObject.Description__c = associateDefectObject.defect.description;
                        }
                        //if(){
                            //defectObject.Defect_Submitted_By__c =  Userinfo.getName();
                        //}
                        if(associateDefectObject.defect.targetedReleaseNumber<>null){
                            defectObject.Targeted_Release_Number__c = associateDefectObject.defect.targetedReleaseNumber;
                        }
                        if(associateDefectObject.defect.targetReleaseDate<>null){
                           defectObject.Target_Release_date__c =  Date.valueOf(associateDefectObject.defect.targetReleaseDate);
                        }
                        if(associateDefectObject.defect.resolution<>null){
                            defectObject.Resolution__c =  associateDefectObject.defect.resolution;
                        }
                        if(associateDefectObject.defect.blocked<>null){
                            defectObject.Blocked__c =  associateDefectObject.defect.blocked;
                        }
                        if(associateDefectObject.defect.blockedReason<>null){
                            defectObject.Blocked_Reason__c =  associateDefectObject.defect.blockedReason;
                        }
                        if(associateDefectObject.defect.workspaceName<>null){
                            defectObject.R_D_System__c=  associateDefectObject.defect.workspaceName;
                        }
                        if(associateDefectObject.defect.defectType<>null){
                            
                            String type = associateDefectObject.defect.defectType;
                            if(type=='Information Request')
                                defectObject.Type__c ='Request for Information';
                            else if(type=='Certification Request')
                                defectObject.Type__c ='Certification Request';
                            else if(type=='Expected Bug')
                                defectObject.Type__c ='Expected Bug';
                        }
                        insert defectObject;
                        fixedorClosed =true;
                        if(defectObject.Status__c !='Closed' && defectObject.Status__c !='Fixed'){
                        
                            fixedorClosed =false;



                             
                            Task t = new Task();        
                            t.whatId =caseObj[0].Id;      
                            t.whoId =caseObj[0].ContactId;
                            t.ownerId =Label.Support_Integration_User_Id;     
                            t.recordTypeId =devRecordTypeId ;       
                            t.Status = 'Not Started';       
                            t.Severity__c = caseObj[0].Severity__c;        
                            t.Priority ='Normal'; 
                            t.subject =defectObject.Name;      
                            t.description='Task auto created by Defect Integration by  ('+ UserInfo.getFirstName() +' '+ UserInfo.getLastName() + ' and '+ timeStr + ')';        
                            t.Type ='SE Action';
                            
                            
                            insert t;
                        }
        

        
                        
                        Defect_Case_Association__c defectCaseAssociateObj = new Defect_Case_Association__c();
                        defectCaseAssociateObj.Case__c = currentRecordId;
                        defectCaseAssociateObj.Defect__c = defectObject.Id;
                        insert defectCaseAssociateObj;
                        submitRecord = false;
                        continueSubmitRecord = true;
                        
                        
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Association Successful');
                        ApexPages.addmessage(errMsg);
                        ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.Confirm, updateSuccessMsg);
                        ApexPages.addmessage(successMsg);
                        
                        
                        caseCommentObject = new CaseComment();
                        caseCommentObject.CommentBody = 'Defect '+associateDefectObject.defect.defectNumber+' successfully associated';
                        caseCommentObject.ParentId = currentRecordId;
                        UtilityFalgs.isDefectUpdate = true; 
                        insert caseCommentObject;
                        if(associateDefectObject.warnings<>null && associateDefectObject.warnings.size()>0){
                            ApexPages.Message warningMsg = new ApexPages.Message(ApexPages.Severity.WARNING,associateDefectObject.warnings[0].detail);
                            ApexPages.addmessage(warningMsg);
                        }
                        if(updateWarningMsg<>null){
                            ApexPages.Message updateWarnMsg = new ApexPages.Message(ApexPages.Severity.WARNING,updateWarningMsg);
                            ApexPages.addmessage(updateWarnMsg);
                        }
                    }
                }
            }
        }else{
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Response returned by service is null');
             ApexPages.addmessage(errorMsg);
    }
}
    
    public void updateDefectCaseAssociation(String defectURL,List<Case> caseObject){
        try{
            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            httpRequestObj.setMethod('PUT');
            httpRequestObj.setEndpoint(prepareUpdateEndPoint());
            httpRequestObj.setHeader('Content-Type', 'application/json');
            httpRequestObj.setBody(prepareUpdateBody(defectURL,caseObject));
            httpRequestObj.setTimeout(Integer.valueof(Label.RallyTimeout));
            HTTPResponse httpResponseObj;
            String jsonResponse;
            if(!Test.isRunningTest()){
                Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
                responseFromUpdateService = Layer7UtilCalloutObj.processLayer7Services(httpRequestObj);
                system.debug('--responseFromUpdateService -->'+responseFromUpdateService);
            }else{
                responseFromUpdateService = httpObj.send(httpRequestObj).getBody();
                system.debug('--responseFromUpdateService----response -->'+httpObj.send(httpRequestObj).getBody());
            }
            
            if(responseFromUpdateService == null || responseFromUpdateService ==''){
              DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
              defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,httpRequestObj.getBody(),responseFromUpdateService,httpRequestObj.getMethod(),0,httpRequestObj.getEndpoint());
              ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
              ApexPages.addmessage(errMsg); 
            }else{
              prepareUpdateResponse(responseFromUpdateService,httpRequestObj); 
            }
        }Catch(Exception serviceException){
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,'',serviceException.getMessage(),'',0,'');   
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'The defect you submitted timed out.  Thus, the defect has not been linked to the ServiceCloud case and might not have even been created in Rally.  If the Rally defect was created then it would contain the ServiceCloud case number in the Salesforce Case Number field in the defect and you can associate the defect to your ServiceCloud case.  If the defect was not created in Rally then you need to resubmit it');
            ApexPages.addmessage(errMsg); 
        }
    }
    
    public void caseUpadteOnDefectAssociate(){
                 system.debug('Test Defect Associate');
        Case caseRef = new Case();
        caseRef.Id = caseObj[0].Id;
        Datetime currentDate=System.now();
        Datetime finalDate = null;
        Map<id,integer> taskBusinessdayMap = new Map<id,integer>();
        if(defCaseRef.size()<=0)   
        {
        caseRef.Troubleshooting_Stage__c = '3. Cause Determination';
        }
        caseRef.Next_Action__c = 'Pending CA Engineering (L2)';
        String severity =caseObj[0].Severity__c;
       
    
    if(caseObj[0].BusinessHoursId!=null){
        for(BusinessHours br : [SELECT id,MondayEndTime,MondayStartTime FROM BusinessHours where id =:caseObj[0].BusinessHoursId])
        taskBusinessdayMap.put(br.id,(br.MondayEndTime.hour()-br.MondayStartTime.hour()));
     }
        
        if(severity=='1' || severity=='2')
        {
            finalDate=BusinessHours.addGmt(caseObj[0].BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObj[0].BusinessHoursId)*Integer.valueOf('1'))*long.Valueof('3600000')));
        }
        else if(severity=='3' || severity=='4' ||  severity=='5')
        {
            finalDate=BusinessHours.addGmt(caseObj[0].BusinessHoursId,currentDate,((long)(taskBusinessdayMap.get(caseObj[0].BusinessHoursId)*Integer.valueOf('5'))*long.Valueof('3600000')));
        }
        
        caseRef.Next_Action_Due_Date__c =finalDate;
        if(!Test.isrunningTest()){
                update caseRef;
            }
    }
    
    public String prepareUpdateEndPoint(){
        String retreiveEndPoint;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
            retreiveEndPoint = Label.RallyEndpointQA;
        }
        else {
             retreiveEndPoint = Label.RallyProductionEndpoint;
        }
        return retreiveEndPoint;
   }
    
    public string prepareUpdateBody(String defectURL, List<Case> caseObject){        
        JSONGenerator jsonGeneratorObj = JSON.createGenerator(true);
        jsonGeneratorObj.writeStartObject();
        jsonGeneratorObj.writeStringField('objectId',defectURL);
        jsonGeneratorObj.writeStringField('product',caseObject[0].CA_Product_Component__r.Name);
        jsonGeneratorObj.writeStringField('externalSystemNumber',caseObject[0].CaseNumber);
        jsonGeneratorObj.writeStringField('externalSystemID',caseObject[0].Id);
        jsonGeneratorObj.writeStringField('customer',caseObject[0].Site_Association__r.Name+' ('+caseObject[0].Tops_Support_Site_ID__c+')');
        jsonGeneratorObj.writeStringField('caseURL',host);
        jsonGeneratorObj.writeStringField('createdDate',caseObject[0].CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        
        
        if(defRec.size()>0)
        {
        jsonGeneratorObj.writeStringField('subject', String.isBlank(defRec[0].Subject__c)?'':defRec[0].Subject__c);
        jsonGeneratorObj.writeStringField('description',String.isBlank(defRec[0].Description__c)?'':defRec[0].Description__c);
        jsonGeneratorObj.writeStringField('defectType',String.isBlank(defRec[0].Type__c)?'':defRec[0].Type__c);
        }else{
        jsonGeneratorObj.writeStringField('subject','');
        jsonGeneratorObj.writeStringField('description','');
        jsonGeneratorObj.writeStringField('defectType','');  
        }
        
      //  jsonGeneratorObj.writeStringField('product',caseObject[0].CA_Product_Component__r.Name);
        jsonGeneratorObj.writeStringField('component',caseObject[0].CA_Product_Component__r.Component_Code__c);
        jsonGeneratorObj.writeStringField('severity',caseObject[0].Severity__c); 
        jsonGeneratorObj.writeStringField('priority',caseObject[0].Priority);
        if(caseObject[0].Customer_Environment__c!=null && caseObject[0].Customer_Environment__c!=''){
            jsonGeneratorObj.writeStringField('environment',caseObject[0].Customer_Environment__c);
        }
        jsonGeneratorObj.writeStringField('requestor',requestor.toLowerCase());
        
        jsonGeneratorObj.writeStringField('contactName',(caseObject[0].contact.Name!=null && caseObject[0].contact.Name!='')?caseObject[0].contact.Name:'');
        jsonGeneratorObj.writeStringField('contactEmail',(caseObject[0].contact.Email!=null && caseObject[0].contact.Email!='')?caseObject[0].contact.Email:'');
        jsonGeneratorObj.writeStringField('contactPhone',(caseObject[0].Contact.Phone!=null && caseObject[0].Contact.Phone!='')?caseObject[0].Contact.Phone:'');
         if(caseObject[0].Business_Impact__c!=null && caseObject[0].Business_Impact__c!=''){
            jsonGeneratorObj.writeStringField('businessImpact',caseObject[0].Business_Impact__c);
        }
        if(caseObject[0].Product_Release__c!=null && caseObject[0].Product_Release__c!=''){
            jsonGeneratorObj.writeStringField('productRelease',caseObject[0].Product_Release__c);
        }
        //Start :US352825
        if(caseObject[0].CA_Product_Controller__r.Product_ID__c !=null && caseObject[0].CA_Product_Controller__r.Product_ID__c !=''){
            jsonGeneratorObj.writeStringField('productMaterialProdId',caseObject[0].CA_Product_Controller__r.Product_ID__c);
        }

        jsonGeneratorObj.writeEndObject();
        String jsonRequest = jsonGeneratorObj.getAsString();
        system.debug('jsonRequestqqqq----->'+jsonRequest);
        return jsonRequest;
    }  
    
    public void prepareUpdateResponse(String response, HttpRequest httpRequestObj){
         system.debug('service responseqqq------------>'+response);
         response = response.replace('\\"','\\\"');
         response = response.removeStart('[');
         response = response.removeEnd(']');
         system.debug('JSONqqq------->'+response);
        
         DefectResponse defectResponseObject = (DefectResponse)JSON.deserialize(response, DefectResponse.class);
        if(defectResponseObject.successful){
            isUpdateCallOut = true;
            insertUiURL = defectResponseObject.uiUrl;
            updateSuccessMsg = 'Defect '+ defectResponseObject.uiId+' successfully updated in Rally System';
               
            if(defectResponseObject.warnings<>null && defectResponseObject.warnings.size()>0){
                updateWarningMsg = defectResponseObject.warnings[0].detail;
            }
        }else{
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(caseObj[0].CaseNumber,defectName,httpRequestObj.getBody(),responseFromUpdateService,httpRequestObj.getMethod(),0,httpRequestObj.getEndpoint());
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,defectResponseObject.errors[0].detail);
            ApexPages.addmessage(errMsg);
        }
        
   }
}