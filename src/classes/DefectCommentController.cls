/*
Created By: Tarun Sharma
Created On: 10/06/2015
Purpose: B-03937: Send support defect comments from SC to Rally
Modified By:
*/
public class DefectCommentController {
    
    public Defect_Comment__c defComment;
    public List<Defect_Case_Association__c> defectAssocaitionObj;
    //public List<Defect__c> defectObj;
    public User userObj;
    public Boolean saveDefectComment{get;set;}
    public Boolean continueDefectComment{get;set;}
    public String defectComments{get;set;}
    public String responseFromService;
        
    public Class comments{
        public String comment;
        public String commentDate;
        public String author;
        public String authorName;
    }
    
    public DefectCommentController(ApexPages.StandardController defectController){
        this.defComment = (Defect_Comment__c)defectController.getRecord();
        saveDefectComment = true;
        continueDefectComment = false;        
    }

    //To send comment to rally and save comment in service cloud
    public pageReference saveComment(){
       if(String.isNotBlank(defectComments)){
            //defectObj = [Select Name, Defect_Object_ID__c from Defect__c where Id=:defComment.Defect__c limit 1];
            defectAssocaitionObj = [Select Defect__r.Name, Defect__r.Defect_Object_ID__c, Case__r.CA_Product_Controller__r.Name, Case__r.CaseNumber, Case__r.CA_Product_Component__r.Name from Defect_Case_Association__c where Defect__c=:defComment.Defect__c limit 1]; //fetch case and defect details from defect case association object on the basis of defect id
            userObj = [SELECT Id, FirstName, LastName, PMFKey__c FROM User where Id=:UserInfo.getUserId()];// fetch user details from user object on the basis of loggined user
            if(defectAssocaitionObj<>null && defectAssocaitionObj.size()>0 && userObj<>null){
                defectCommentCallout(); // to make callout
            }else{
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Defect not associatie with a case');
                ApexPages.addmessage(errMsg);
                return null;
            }
        }else{
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter the value for defect comments');
            ApexPages.addmessage(errMsg);
            return null;
        }
       return null; 
    }
    
    //to navigate back to defect detail page
    public pageReference continueUpdateComment(){
         return new pagereference('/'+defComment.Defect__c);
    }
    
    private void defectCommentCallout(){
        try{
            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();
            httpRequestObj.setEndpoint(prepareEndPoint());
            httpRequestObj.setMethod('PUT');
            httpRequestObj.setHeader('Content-Type', 'application/json');
            httpRequestObj.setBody(prepareBody());
            httpRequestObj.setTimeout(Integer.valueof(Label.RallyTimeout));
            HTTPResponse httpResponseObj;
            String jsonResponse;
            if(!Test.isRunningTest()){
                 Layer7UtilCallout Layer7UtilCalloutObj = new Layer7UtilCallout();
                 responseFromService = Layer7UtilCalloutObj.processLayer7Services(httpRequestObj);
            }else{
                responseFromService = httpObj.send(httpRequestObj).getBody();
                system.debug('--responseFromService----response -->'+httpObj.send(httpRequestObj).getBody());
            }
            
            if(responseFromService==null || responseFromService ==''){
                DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
                defectErrorLogObj.defectErrorLogMethod(defectAssocaitionObj[0].Case__r.CaseNumber,defectAssocaitionObj[0].Defect__r.Name,httpRequestObj.getBody(),responseFromService,httpRequestObj.getMethod(),0,httpRequestObj.getEndpoint());
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
                ApexPages.addmessage(errMsg);
            }else{
                prepareResponse(responseFromService,httpRequestObj);
            }
        }Catch(Exception serviceException){
            DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
            defectErrorLogObj.defectErrorLogMethod(defectAssocaitionObj[0].Case__r.CaseNumber,defectAssocaitionObj[0].Defect__r.Name,'',serviceException.getMessage(),'',0,'');   
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'The defect comment you submitted timed out.  Thus, the comment might not have been created in the Rally defect.  Please resubmit the defect comment, including stating that this might be a duplicate comment');
            ApexPages.addmessage(errMsg); 
        }
    }
    
    private String prepareEndPoint(){
        String retreiveEndPoint;
        Organization orgObj = [select Id, IsSandbox from Organization limit 1 ];
        if(orgObj.IsSandbox){
             retreiveEndPoint = Label.RallyEndpointQA;
        }
        else {
             retreiveEndPoint = Label.RallyProductionEndpoint;
        }
        system.debug('retreiveEndPoint------>'+retreiveEndPoint);
        return retreiveEndPoint;
   }
    
    private string prepareBody(){
        List<comments> listOfComments = new List<comments>();
        comments commentObj = new comments();
        commentObj.comment = defectComments;
        commentObj.commentDate = String.valueof(DateTime.Now().format('yyyy-MM-dd\'T\'HH:mm:ssXXX'));
        commentObj.author = userObj.PMFKey__c; 
        commentObj.authorName = UserInfo.getName();
        listOfComments.add(commentObj);
        
        JSONGenerator jsonGeneratorObj = JSON.createGenerator(true);
        jsonGeneratorObj.writeStartObject();
        jsonGeneratorObj.writeStringField('objectId',defectAssocaitionObj[0].Defect__r.Defect_Object_ID__c);
        jsonGeneratorObj.writeStringField('product',defectAssocaitionObj[0].Case__r.CA_Product_Component__r.Name);
        jsonGeneratorObj.writeObjectField('comments',listOfComments);
        jsonGeneratorObj.writeEndObject();
        String jsonRequest = jsonGeneratorObj.getAsString();
        if(jsonRequest.contains('commentDate')){
            jsonRequest = jsonRequest.replace('commentDate','date');
        }
        system.debug('jsonRequest----->'+jsonRequest);
        return jsonRequest;
    }
    
     private void prepareResponse(String response, HttpRequest httpRequestObj){
         system.debug('service response------------>'+response);
         response = response.replace('\\"','\\\"');
         response = response.removeStart('[');
         response = response.removeEnd(']');
         system.debug('JSON------->'+response);
         
          DefectResponse defectResponseObject = (DefectResponse)JSON.deserialize(response, DefectResponse.class);
          
            if(defectResponseObject.successful){
                Defect_Comment__c defectCommentObj = new Defect_Comment__c();
                defectCommentObj.Comments__c = defectComments;
                defectCommentObj.Defect__c = defComment.Defect__c;
                insert defectCommentObj;
                
                saveDefectComment = false;
                continueDefectComment = true; 
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Comment updated successfully');
                ApexPages.addmessage(errMsg);
                
                if(defectResponseObject.warnings<>null && defectResponseObject.warnings.size()>0){
                    ApexPages.Message warningMsg = new ApexPages.Message(ApexPages.Severity.FATAL,defectResponseObject.warnings[0].detail);
                    ApexPages.addmessage(warningMsg);
                }
                CaseComment caseCommentObject = new CaseComment();
                caseCommentObject.CommentBody = 'Defect # '+defectAssocaitionObj[0].Defect__r.Name+' Updated from ServiceCloud Case # '+defectAssocaitionObj[0].Case__r.CaseNumber+'\nDiscussion: '+defectComments;
                caseCommentObject.ParentId = defectAssocaitionObj[0].Case__c;
                insert caseCommentObject;
                
            }else{
                DefectErrorLogHelper defectErrorLogObj = new DefectErrorLogHelper();
                defectErrorLogObj.defectErrorLogMethod(defectAssocaitionObj[0].Case__r.CaseNumber,defectAssocaitionObj[0].Defect__r.Name,httpRequestObj.getBody(),responseFromService,defectResponseObject.operation,0,httpRequestObj.getEndpoint());
                if(defectResponseObject.errors<>null && defectResponseObject.errors.size()>0){
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.FATAL,defectResponseObject.errors[0].detail);
                    ApexPages.addmessage(errMsg);
                }
            }
    }
}