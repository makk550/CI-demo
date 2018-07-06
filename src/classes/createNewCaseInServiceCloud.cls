@RestResource(urlMapping='/serviceCloudCaseService/*')
global class createNewCaseInServiceCloud{
    
    public Static createCasePayload createCasePayloadObj; 
    public Static createCaseResponse createCaseResponseObj;
    static boolean scbugFlag  = false;
    static boolean scCompFlag  = false;
    static boolean scDefaultFlag  = false;
    static Boolean defaultFlag = false;
    static Boolean productChangeFlag = false;
    
    global Class createCaseRequest{
        global String product;
        global String connectId;
        global String pmfKey;
        global String contactMethod;
        global String siteId;
        global String caseDescription;
        global String replyMethod;
        global String firstName;
        global String returnInput;
        global String caseTitle;
        global String firstPreferredLanguage;
        global String release;
        global String lastName;
        global String operatingSystem;
        global String email;
        global String phoneNumber;
        global String priority;
        global String type;
    }
    
    global Class createCasePayload{
        global createCaseResponse createCaseResponsePayload;
    }
    
    global Class createCaseResponse{
        global String caseNumber;
        global String priority;
        global String returnInput;
        global String messageResponse;
    }
    
    public class retrieveProject{
        string IdProjectSiteAssociationc;
        string IdSiteAssociationc;
    }
    
    global Class updateCaseRequest{
        global String pmfKey;
        global String caseNumber;
        global String activityText;
        global String connectId;
        global String status;
        global String activityDate;
    }
   
    Public Static updateCasePayload updateCasePayloadObj;
    Public Static updateCaseResponse updateCaseResponseObj;
    Public Static returnInput returnInputObj;
    
    global Class updateCasePayload{
        global updateCaseResponse updateCaseResponsePayload;    
    }
    
    global Class updateCaseResponse{
        global String ackMessage;
        global returnInput returnInput;
    }
    
    global Class returnInput{
        global String caseNumber;
        global String status;
    }
    
    //create a new case in service cloud
    @HttpPost
    global Static void createNewCaseMethod(createCaseRequest createCaseRequestPayload){
        String jsonRequest = JSON.serialize(createCaseRequestPayload);
        system.debug('@#@@@: '+jsonRequest);
        RestResponse restResponse = RestContext.response;
        String jsonResponse = null;
        createCaseResponseObj = new createCaseResponse();
        createCasePayloadObj = new createCasePayload();
        Case caseObj = new Case();
        List<CA_Product_Component__c> lstCAprodComp = new List<CA_Product_Component__c>();
        Boolean user_switch, NoContact_switch, project_switch; 
        String getContactIdbyConnectId_ConnectId, caseIdComment, caseRecordOrigin, getCaseDetailsById_Id,tempId, getComponentCodeBycomponent, getProductMaterialByTopscode_Topscode, getProductReleaseByMaterialandRelease_Release, getProductReleaseByMaterialandRelease_Material, caseRecordComponent_Release_Selection_c, caseRecordComponent_Release_Only_Selection_c, retrieveLanguage_language1, caseRecordPreferredMethodOfContact, genlevelComment, caseRecordProduct_Release_Selection_c, genlevelProductServicePack, genlevelProductRelease, genlevelName, genlevelExtId, getProductServicePackByGenlevel_Genlevel, caseRecordProduct_Service_Pack_Selection_c, getProductServicePackByGenlevel_Product_Release, caseRecordComponent_Code, getCAProductController, getSiteAssociationBySite_siteId, caseRecordSite_Association_c, caseRecordProject_Site_Association_c, caseRecordCase_Type_c, caseRecordContactId, email_username, email_domain, email_domain_lower, getContactIdbyEmail_emailId, noZeroSite, getProjectSiteAssociationByProject_projectId;
        Integer siteId_numeric;
        caseRecordComponent_Release_Selection_c=null;
        caseObj.Internal_Contact__c                     = null;
        caseObj.Site_Association__c                     = null;
        caseObj.Severity__c                             = null;
        caseObj.Alt_Contact_First_Name__c               = null;
        caseObj.Alt_Contact_Last_Name__c                = null;
        caseObj.Alternate_email__c                      = null;
        caseObj.Preferred_method_of_Contact__c          = null;
        caseObj.Alternate_Phone__c                      = null;
        caseObj.Alt_Contact_Preferred_Language__c       = null;
        caseObj.Alt_Contact_Alternate_Language__c       = null;
        caseObj.Component_Release_Selection__c          = null;
        caseObj.Component_Release_Only_Selection__c     = null;
        caseObj.CA_Product_Component__c                 = null;
        caseObj.Product_Operating_System__c             = null;
        caseObj.Product_Service_Pack_Selection__c       = null;
        caseObj.Subject                                 = null;
        caseObj.Description                             = null;
        caseObj.Product_Release_Selection__c            = null;
        caseObj.origin                                  = null;
        caseObj.Reason                                  = null;
        caseObj.Business_Impact__c                      = null;
        caseObj.Issue_Action_c__c                       = null;
        caseRecordContactId                                 = null;
        String caseRecordInternal_Contact_c                        = null;
        caseRecordSite_Association_c                        = null;
        caseRecordProject_Site_Association_c                = null;
        caseRecordCase_Type_c                               = null;
        caseRecordProduct_Release_Selection_c               = null;
        caseRecordComponent_Release_Selection_c             = null;
        caseRecordComponent_Release_Only_Selection_c        = null;
        String caseRecordProduct_Operating_System_c                = null;
        caseRecordProduct_Service_Pack_Selection_c          = null;
        String caseRecordOwnerId                                   = null;
        caseRecordOrigin                                    = null;        
        String caseRecordReason                                    = null;
        String caseRecordAction                                    = null;
        caseRecordPreferredMethodOfContact                  = null;
        String outputCaseNumber                                    = null;
        retrieveLanguage_language1                          = null;
        genlevelComment                                     = '';
        genlevelProductServicePack                          = null; //kumga08 CR:400-1186
        genlevelProductRelease                              = null; //kumga08 CR:400-1186
        genlevelName                                        = null; //kumga08 CR:400-1186
        genlevelExtId                                       = null; //kumga08 CR:400-1186
        String creationStatus                                      = 'New';
       
        if(createCaseRequestPayload<>null){
            // To check email and connectId
            if(StringUtils.isBlank(createCaseRequestPayload.email)  &&  StringUtils.isBlank(createCaseRequestPayload.connectid)){
                createCaseResponseObj.messageResponse = 'Email or connectid is mandatory to create case.';   
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            // To check site Id
            if(StringUtils.isBlank(createCaseRequestPayload.siteid)){
                createCaseRequestPayload.siteid = '2000028';
            }else{                   
                if(createCaseRequestPayload.siteid.isNumeric()){}
                else{
                    createCaseResponseObj.messageResponse = 'Siteid must be numeric.';
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;               
                }
            }
            
            // To check product
            if(StringUtils.isBlank(createCaseRequestPayload.product)){
                createCaseResponseObj.messageResponse = 'Component (product) is mandatory to create case.';
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;  
            }
            
            // To check case title
            if(StringUtils.isBlank(createCaseRequestPayload.caseTitle)){
                createCaseResponseObj.messageResponse = 'Title is mandatory to create case.';
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            //to check case description
            if(StringUtils.isBlank(createCaseRequestPayload.caseDescription)){
                createCaseResponseObj.messageResponse = 'Case Text (Description) is mandatory to create case.';
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
            if(StringUtils.isNotBlank(createCaseRequestPayload.release)){
                getProductServicePackByGenlevel_Genlevel = createCaseRequestPayload.release;
                getProductServicePackByGenlevel_Product_Release = caseRecordProduct_Release_Selection_c;
                caseRecordProduct_Service_Pack_Selection_c = getProductServicePackByGenlevel(getProductServicePackByGenlevel_Genlevel,getProductServicePackByGenlevel_Product_Release);            
                if (caseRecordProduct_Service_Pack_Selection_c == '-1'){
                    system.debug('$$$$$$$$$$$$$$$$'+getProductServicePackByGenlevel_Genlevel);
                    genlevelComment = 'No matching record found for Service Pack: '+getProductServicePackByGenlevel_Genlevel;
                    genlevelProductServicePack = getProductServicePackByGenlevel_Genlevel;
                    genlevelProductRelease = getProductServicePackByGenlevel_Product_Release;
                    genlevelName = createCaseRequestPayload.release + ' ' + genlevelProductServicePack;
                    genlevelExtId = createCaseRequestPayload.release + '-' + genlevelProductServicePack;
                    caseRecordProduct_Service_Pack_Selection_c = null;
                }
            }
            
            //Retrieve contact details using connectid (if present in the input).
            if(StringUtils.isNotBlank(createCaseRequestPayload.connectid)){
                String fname;
                String lname;
                String phoneNumber;
                String emailId;
                String siteId;
                if (createCaseRequestPayload.connectid.isNumeric()){  
                    fname = createCaseRequestPayload.firstName;          
                    lname = createCaseRequestPayload.lastName;           
                    phoneNumber = createCaseRequestPayload.phoneNumber;   
                    emailId = createCaseRequestPayload.email;           
                    siteId = createCaseRequestPayload.siteId;
                    getContactIdbyConnectId_ConnectId = createCaseRequestPayload.connectid;
                    
                    user_switch = false;
                    NoContact_switch = false;
                    caseRecordContactId = getContactIdbyConnectId(getContactIdbyConnectId_ConnectId,emailId,fname,lname,phoneNumber,siteId);
                    if(caseRecordContactId == '-1'){
                        NoContact_switch = true;
                    }
                }else{
                    user_switch = false;
                    NoContact_switch = false;
                    fname = createCaseRequestPayload.firstName;          
                    lname = createCaseRequestPayload.lastName;            
                    phoneNumber = createCaseRequestPayload.phoneNumber;  
                    emailId = createCaseRequestPayload.email;          
                    siteId = createCaseRequestPayload.siteId;
                    String userPMFKey = createCaseRequestPayload.connectid;
                    
                    caseRecordContactId = getContactIdbyConnectId(userPMFKey,emailId,fname,lname,phoneNumber,siteId);
                    
                    if(caseRecordContactId == '-1'){
                        NoContact_switch = true;
                    }
                }            
            }
           
            //Retrieve contact detail using email address
            if(StringUtils.isBlank(createCaseRequestPayload.connectid)){
                List<String> emailParts = createCaseRequestPayload.email.split('\\@');
                email_username = emailParts[0];
                email_domain = emailParts[1];
                email_domain_lower = email_domain.toLowerCase();
                
                if((email_domain_lower == 'ca.com')  || (email_domain_lower == 'cai.com') || (email_domain_lower == 'contractor.ca.com')){  
                    user_switch = false;
                    NoContact_switch = false;
                    String userPMFKey = email_username;
                    caseRecordContactId = getUserContactRecord(userPMFKey);
                    if(caseRecordContactId == '-1'){
                        NoContact_switch = true;
                    }               
                }else{
                    user_switch = false;
                    NoContact_switch = false;
                    getContactIdbyEmail_emailId = createCaseRequestPayload.email;
                    caseRecordContactId = getContactIdbyEmail(getContactIdbyEmail_emailId);
                    if(caseRecordContactId == '-1'){
                        NoContact_switch = true;
                    }               
                }    
            } 
            
            //Check if a project site is passed.
            project_switch = false;
            if(createCaseRequestPayload.siteId.length()> 6){
                noZeroSite = drop_leading_zeros(createCaseRequestPayload.siteId);
            }else{
                noZeroSite = createCaseRequestPayload.siteId;
            }
            siteId_numeric = Integer.valueof(noZeroSite);
            
            if(siteId_numeric>8000000 && siteId_numeric<8888887){
                project_switch = true;
            }
            
            if(project_switch){
                retrieveProject retrieveProjectObject = new retrieveProject();
                getProjectSiteAssociationByProject_projectId = createCaseRequestPayload.siteid;
                retrieveProjectObject = getProjectSiteAssociationByProject(getProjectSiteAssociationByProject_projectId);            
                if (retrieveProjectObject.IdProjectSiteAssociationc == '-1'){
                    createCaseResponseObj.messageResponse = 'No matching record found for project: '+getProjectSiteAssociationByProject_projectId;
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return; 
                }else{
                    caseRecordSite_Association_c = retrieveProjectObject.IdSiteAssociationc;
                    caseRecordProject_Site_Association_c = retrieveProjectObject.IdProjectSiteAssociationc;
                    caseRecordCase_Type_c = 'Project';
                }
            }else{
                getSiteAssociationBySite_siteId = noZeroSite;
                caseRecordSite_Association_c = getSiteAssociationBySite(getSiteAssociationBySite_siteId);
                if (caseRecordSite_Association_c == '-1'){
                    createCaseResponseObj.messageResponse = 'No matching record found for siteid: '+getSiteAssociationBySite_siteId;
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }       
                caseRecordCase_Type_c = 'Standard';
            }
            
            if(createCaseRequestPayload.contactMethod=='C'){
                getComponentCodeBycomponent= createCaseRequestPayload.product;
                lstCAprodComp =getComponentCodeWoTopsCode(getComponentCodeBycomponent);
                if(lstCAprodComp != null && lstCAprodComp.size()>0){
                    caseRecordComponent_Code=lstCAprodComp [0].id;
                    getCAProductController=lstCAprodComp [0].CA_Product_Controller__c;
                }else{
                    createCaseResponseObj.messageResponse = 'No Matching record found for Component Code: '+createCaseRequestPayload.product;
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return; 
                }          
            }else{
                createCaseResponseObj.messageResponse = 'Please pass the correct contact menthod.';
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;    
            }
            
            
            //code for case origin
            if(createCaseRequestPayload.contactMethod=='C'){
                caseRecordOrigin = 'Customer-facing Portal';
                createCaseRequestPayload.caseTitle = EncodingUtil.urlDecode(createCaseRequestPayload.caseTitle, 'UTF-8');
                createCaseRequestPayload.caseDescription = EncodingUtil.urlDecode(createCaseRequestPayload.caseDescription, 'UTF-8');
            }
            
            if( StringUtils.isNotBlank(createCaseRequestPayload.firstPreferredLanguage)){
                retrieveLanguage_language1 = retrieveLanguage(createCaseRequestPayload.firstPreferredLanguage);
                if(retrieveLanguage_language1 == null){
                    createCaseResponseObj.messageResponse = 'Invalid Language passed in lang1: '+createCaseRequestPayload.firstPreferredLanguage;
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }                               
            }
            
            system.debug(NoContact_switch+'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+caseRecordContactId);
            if(!NoContact_switch){
                caseObj.ContactId = caseRecordContactId;   
            }
            caseObj.Site_Association__c = caseRecordSite_Association_c;
            caseObj.Project_Site_Association__c = caseRecordProject_Site_Association_c;
            caseObj.Case_Type__c = caseRecordCase_Type_c;
            if(String.isNotBlank(createCaseRequestPayload.priority)){
                caseObj.Severity__c = createCaseRequestPayload.priority;    
            }else{
                caseObj.Severity__c = '4';    
            }
            caseObj.Alt_Contact_First_Name__c = createCaseRequestPayload.firstName;
            caseObj.Alt_Contact_Last_Name__c = createCaseRequestPayload.lastName;
            caseObj.Alternate_email__c = createCaseRequestPayload.email;
            caseObj.Preferred_method_of_Contact__c = caseRecordPreferredMethodOfContact;
            caseObj.Alternate_Phone__c = createCaseRequestPayload.phoneNumber;
            caseObj.Alt_Contact_Preferred_Language__c = retrieveLanguage_language1;
            caseObj.Product_Material__c = getProductReleaseByMaterialandRelease_Material;                
            caseObj.CA_Product_Controller__c = getCAProductController;
            caseObj.CA_Product_Component__c = caseRecordComponent_Code;
            caseObj.Product_Release_Selection__c = caseRecordProduct_Release_Selection_c;
            caseObj.Component_Release_Selection__c = caseRecordComponent_Release_Selection_c;
            caseObj.Component_Release_Only_Selection__c = caseRecordComponent_Release_Only_Selection_c;
            caseObj.Product_Service_Pack_Selection__c = caseRecordProduct_Service_Pack_Selection_c;
            caseObj.Subject = createCaseRequestPayload.caseTitle;
            caseObj.Description = createCaseRequestPayload.caseDescription;
            caseObj.origin = caseRecordOrigin;
            caseObj.Alternate_OS__c = createCaseRequestPayload.operatingSystem;  
            caseObj.Alt_Contact_Preferred_Contact_Method__c = caseRecordPreferredMethodOfContact;
            if(productChangeFlag){
                caseObj.Additional_Info__c = System.Label.Product_Problem_Case;
            }
            system.debug('Case Record: '+caseObj);
            insert caseObj;
            
            if(scbugFlag == true){
                String newComment = '';
                String id = caseObj.Id;
                String topsrel = createCaseRequestPayload.release;
                String servicepack = createCaseRequestPayload.release;
                String product = createCaseRequestPayload.product;
                //String component = createCaseRequestPayload.topscd;
                if(createCaseRequestPayload.contactMethod == 'C' && id<>null){
                    if(scbugFlag && scCompFlag && scDefaultFlag){
                        newComment = System.Label.Create_E2c_Scbug_Comment+' '+createCaseRequestPayload.product;   
                    }else if(scbugFlag && !scCompFlag && !scDefaultFlag && !defaultFlag){
                        newComment = System.Label.Create_No_Default_Comp_Comment+' '+createCaseRequestPayload.product;
                    }
                }
                logComment(newComment,id);
            }
            
            if(createCaseRequestPayload.contactMethod == 'M'){
                String newComment='';
                String servicePackMobile='';
                String releaseMobile='';
                if(createCaseRequestPayload.release<>null){
                    servicePackMobile=createCaseRequestPayload.release;
                    newComment='Service Pack:'+servicePackMobile;
                } 
                
                if(createCaseRequestPayload.release<>null){
                    logComment(newComment,caseObj.Id);
                }
            }
            
            if(!(createCaseRequestPayload.contactMethod == 'M')){
                if (genlevelComment != ''){   
                    String tempString=null;                                                                                                   
                    caseIdComment = caseObj.Id;
                    logComment(genlevelComment,caseIdComment);
                    tempString = insertProductServicePack(genlevelProductServicePack,genlevelProductRelease,genlevelName,genlevelExtId);             
                    creationStatus = 'Success';
                }
            }
            
            if(caseObj.Id != null){
                getCaseDetailsById_Id = caseObj.Id;
                outputCaseNumber = getCaseDetailsById(getCaseDetailsById_Id);
                system.debug('&&&&&&&&&&&&&output case number:'+outputCaseNumber);
                if (outputCaseNumber == '-1'){
                    createCaseResponseObj.messageResponse = 'Failed to retrieve case number for case id: '+getCaseDetailsById_Id;
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }else{
                    createCaseResponseObj.caseNumber = outputCaseNumber;
                    createCaseResponseObj.priority = caseObj.Severity__c;
                    createCaseResponseObj.returnInput = createCaseRequestPayload.returnInput;
                    createCaseResponseObj.messageResponse = 'Success';
                    createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                    jsonResponse = JSON.serialize(createCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }            
            }else{
                createCaseResponseObj.messageResponse = 'Failed to create the case';
                createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
                jsonResponse = JSON.serialize(createCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
        }else{
            createCaseResponseObj.messageResponse = 'Please enter the valid request payload';
            createCasePayloadObj.createCaseResponsePayload = createCaseResponseObj;
            jsonResponse = JSON.serialize(createCasePayloadObj);
            restResponse.responseBody = blob.valueOf(jsonResponse);
            return;
        }
    }
    
    //update a case in service cloud
    @HttpPut
    global Static void updateCaseMethod(updateCaseRequest updateCaseRequestPayload){
        String jsonRequest = JSON.serialize(updateCaseRequestPayload);
        System.debug(updateCaseRequestPayload.caseNumber+'*******'+jsonRequest);
        RestResponse restResponse = RestContext.response;  
        String jsonResponse;
        updateCasePayloadObj = new updateCasePayload();
        updateCaseResponseObj = new updateCaseResponse();
        
        if(updateCaseRequestPayload<>null){
                if(String.isNotBlank(updateCaseRequestPayload.caseNumber)){
                    List<Case> caseObj = [Select id, caseNumber, Site_Association__r.SC_TOPS_ID__c from Case where caseNumber=:updateCaseRequestPayload.caseNumber AND Status!=:'Closed'];
                    if(caseObj<>null && caseObj.size()>0){
                        caseObj[0].Status = 'Closed';
                        caseObj[0].Troubleshooting_Stage__c = '7. Closed';
                        try{
                            update caseObj;
                        }Catch(DmlException e){
                            system.debug('Case Update Exception--->:'+e.getMessage());
                        }
                        
                        try{
                            CaseComment caseCommentObj = new CaseComment();
                            caseCommentObj.ParentId = caseObj[0].Id;
                            caseCommentObj.CommentBody = String.isNotBlank(updateCaseRequestPayload.activityText)?updateCaseRequestPayload.activityText:'';
                            insert caseCommentObj;                            
                            updateCaseResponseObj.ackMessage = 'The case was successfully updated in SFDC';
                            returnInputObj = new returnInput();
                            returnInputObj.caseNumber = caseObj[0].caseNumber;
                            returnInputObj.status = 'Closed';//caseObj[0].Status;
                            updateCaseResponseObj.returnInput = returnInputObj;
                            updateCasePayloadObj.updateCaseResponsePayload = updateCaseResponseObj;
                            jsonResponse = JSON.serialize(updateCasePayloadObj);
                            restResponse.responseBody = blob.valueOf(jsonResponse);
                            return;    
                        }Catch(DmlException e){
                            system.debug('Case Comment Exception----->:'+e.getMessage());
                        }
                    }else{
                        updateCaseResponseObj.ackMessage = 'Case Number doesn\'t exist or already closed';
                        updateCaseResponseObj.returnInput = null;
                        updateCasePayloadObj.updateCaseResponsePayload = updateCaseResponseObj;
                        jsonResponse = JSON.serialize(updateCasePayloadObj);
                        restResponse.responseBody = blob.valueOf(jsonResponse);
                        return; 
                    }
                }else{
                    updateCaseResponseObj.ackMessage = 'Invalid Case Number OR Site Id';
                    updateCaseResponseObj.returnInput = null;
                    updateCasePayloadObj.updateCaseResponsePayload = updateCaseResponseObj;
                    jsonResponse = JSON.serialize(updateCasePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }
        }else{
                updateCaseResponseObj.ackMessage = 'Please send the valid request';
                updateCaseResponseObj.returnInput = null;
                updateCasePayloadObj.updateCaseResponsePayload = updateCaseResponseObj;
                jsonResponse = JSON.serialize(updateCasePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
        }
    }
    
    // fetch contact record
    public static string getContactIdbyConnectId(string getContactIdbyConnectId_ConnectId, String emailId, String fname, String lname, String phoneNumber,String siteId){   
        String conId;
        List<Contact> listOfContact = [select Id from Contact where SC_CONTACT_LDAPID__c =:getContactIdbyConnectId_ConnectId limit 1];
        
        if(listOfContact.size()!= 1){
            conId = correctContactData(getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
            if(conId!=null){
                return conId;
            }
            else
                return '-1';
        }else{   
            return listOfContact[0].Id;
        }
    }
    
    //create or update the contact data
    public static String correctContactData(string getContactIdbyConnectId_ConnectId, String emailId,String fname,String lname,String phoneNumber, String siteId){
        String conid;
        List<Contact> listOfContact = [select id from contact where email =:emailId limit 5];
        
        if(listOfContact.size()==0){            
            conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
        }else if(listOfContact.size()==1){
            conid =  updateContact(listOfContact,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
        }else if(listOfContact.size()>1){
            listOfContact.clear();
            listOfContact = [select id from contact where email =:emailId AND firstName =:fname and lastName =:lname];
            
            if(listOfContact.size()==0){
                conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
            }else if(listOfContact.size()==1){
                conid =  updateContact(listOfContact,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
            }else if(listOfContact.size()>1){
                listOfContact.clear();
                listOfContact = [select id from contact where email =:emailId and firstName =:fname and lastName =:lname and Phone =:phoneNumber];
                
                if(listOfContact.size()!=1){
                    conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
                }else{
                    conid =  updateContact(listOfContact,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
                }
            }
        }
        return conid;
    }
    
    //if no contact exist then create a new contact record
    public static String insertContact(string getContactIdbyConnectId_ConnectId, String emailId,String fname,String lname,String phoneNumber, String siteId){
        String insertedConId;
        List<Site_Association__c> siteassociation =[select Enterprise_ID__c from Site_Association__c where SC_TOPS_ID__c =:siteId limit 1];    
        system.debug('@##@siteassociation###'+siteassociation);
        Id accId;
        if(!test.isRunningTest())
            if(siteassociation<>null && siteassociation.size()>0){
                accId = siteassociation[0].Enterprise_ID__c;
            }
        else
           accId = '001a000001bzdZb'; 
                
        try{
            Contact con = new Contact();
            con.email = emailId;
            con.FirstName = fname;
            con.LastName = lname;
            con.Phone = phoneNumber;
            con.SC_CONTACT_LDAPID__c = getContactIdbyConnectId_ConnectId;
            con.AccountId = accId;
            con.Country_Picklist__c  = 'US - UNITED STATES';
            insert con;
            insertedConId = con.Id;
        }   
        catch(DMLException e){
            insertedConId = null;
        }    
        
        return insertedConId;
    }
    
    //if a contact exist then update the existing contact record
    public static string updateContact(List<Contact> con, String getContactIdbyConnectId_ConnectId, String fname, String phoneNumber){     
        String updatedConId;
        try{ 
            
            con[0].SC_CONTACT_LDAPID__c = getContactIdbyConnectId_ConnectId;
            
            If(String.isBlank(con[0].firstName)){
                con[0].firstName = fname;
            }
            
            if(String.isBlank(con[0].phone)){
                con[0].phone = phoneNumber;
            }
            update con[0];
            updatedConId = con[0].id;
        }    
        
        catch(DMLException e){
            updatedConId = null;
        }
        return updatedConId;   
    }
    
    //if email address contain ca domain
    public static String getUserContactRecord(String userPMFKey){
        
        List<Contact> conList = [select id from contact where SC_CONTACT_LDAPID__c =:userPMFKey limit 1];
        
        if(conList.size()!=1){
            return Label.Email_to_case_missing_contact;
        }else{
            return conList[0].id;
        }
    }
   
    //if email address doesn't contain ca domain
    public static string getContactIdbyEmail(string getContactIdbyEmail_emailid){   
        List<Contact> contact_list = [Select Id from Contact where Email = :getContactIdbyEmail_emailid limit 1];
        
        if(contact_list.size()!= 1){
            return Label.Email_to_case_missing_contact;
        }else{
            return contact_list[0].id;
        }
    }
    
    //if site id length greater than 6digit then trim the site id
    public static String drop_leading_zeros(String passedValue) {
        String return_string = null;
        if(String.isNotBlank(passedValue)) {
            return_string = passedValue.trim();
            Pattern valid_characters = Pattern.compile('([0-9]+)');
            Matcher check_chars = valid_characters.matcher(return_string);
            if (check_chars.matches()) {
                if (return_string.startsWith('0') && return_string.length() > 6) {
                    boolean keepChecking = true;
                    while (keepChecking) {
                        if (return_string.startsWith('0') && return_string.length() > 6) {
                            return_string = return_string.substring(1);
                        } else {
                            keepChecking = false;
                        }
                    }
                }
                if (return_string == '0') {
                    return_string = null;
                }
            } else {
                return_string = null;
            }
        }
        return return_string;
    }
    
    public static retrieveProject getProjectSiteAssociationByProject(string getContactIdbyEmail_emailid){
        retrieveProject retrieveProjectObj = new retrieveProject();
        List<Project_Site_Association__c> project_list = [Select Id, Site_Association__c from Project_Site_Association__c where Project_ID__c =:getContactIdbyEmail_emailid limit 1];
        
        if (project_list.size() != 1){
            retrieveProjectObj.IdProjectSiteAssociationc = '-1';
            retrieveProjectObj.IdSiteAssociationc = '-1';
        }else{
            retrieveProjectObj.IdProjectSiteAssociationc = project_list[0].Id;
            retrieveProjectObj.IdSiteAssociationc = project_list[0].Site_Association__c;
        }
        return retrieveProjectObj;
    }
    
    //fetch site association record
    public static string getSiteAssociationBySite(string getSiteAssociationBySite_siteId){
        List<Site_Association__c> site_list = [Select Id from Site_Association__c where SC_TOPS_ID__c =:getSiteAssociationBySite_siteId limit 1];
        List<Site_Association__c> default_site_list = [Select Id from Site_Association__c where SC_TOPS_ID__c ='2000028' limit 1];
        
        if((site_list.size()!=1) && (default_site_list.size()!=1)){
            return '-1';
        }else{
            if(site_list.size()!=1){
                return default_site_list[0].id; 
            }else{
                return site_list[0].id;
            }
        }
    }
    
    //get service pack
    public static string getProductServicePackByGenlevel(string getProductServicePackByGenlevel_Genlevel,string getProductServicePackByGenlevel_Product_Release){
        system.debug(getProductServicePackByGenlevel_Genlevel+'^^^^^^^^'+getProductServicePackByGenlevel_Product_Release);
        List<Product_Service_Pack__c> genlevel_list = [Select Id from Product_Service_Pack__c where Product_Service_Pack__c =:getProductServicePackByGenlevel_Genlevel AND Product_Release__c =:getProductServicePackByGenlevel_Product_Release limit 1];
        system.debug('@@@@@@@genlevel_list@@@'+genlevel_list);
        if(genlevel_list.size()!=1){
            return '-1';
        }else{
            return genlevel_list[0].Id;
        }
    }
    
    //language code
    public static string retrieveLanguage(String retrieveLanguage_code){
        String languageName;
        if (retrieveLanguage_code == 'ARA') { languageName = 'ARABIC'; }
        if (retrieveLanguage_code == 'ARM') { languageName = 'ARMENIAN'; }
        if (retrieveLanguage_code == 'BOS') { languageName = 'BOSNIAN'; }
        if (retrieveLanguage_code == 'BUL') { languageName = 'BULGARIAN'; }
        if (retrieveLanguage_code == 'BUR') { languageName = 'BURMESE'; }
        if (retrieveLanguage_code == 'CAT') { languageName = 'CATALAN'; }
        if (retrieveLanguage_code == 'CHI') { languageName = 'CHINESE'; }
        if (retrieveLanguage_code == 'CHS') { languageName = 'SIMPLIFIED CHINESE'; }
        if (retrieveLanguage_code == 'CHT') { languageName = 'TRADITIONAL CHINESE'; }
        if (retrieveLanguage_code == 'CRO') { languageName = 'CROATIAN'; }
        if (retrieveLanguage_code == 'CZE') { languageName = 'CZECH'; }
        if (retrieveLanguage_code == 'DAN') { languageName = 'DANISH'; }
        if (retrieveLanguage_code == 'DUT') { languageName = 'DUTCH'; }
        if (retrieveLanguage_code == 'ENG') { languageName = 'ENGLISH'; }
        if (retrieveLanguage_code == 'EPO') { languageName = 'ESPERANTO'; }
        if (retrieveLanguage_code == 'EST') { languageName = 'ESTONIAN'; }
        if (retrieveLanguage_code == 'FIN') { languageName = 'FINNISH'; }
        if (retrieveLanguage_code == 'FRC') { languageName = 'FRENCH - CANADIAN'; }
        if (retrieveLanguage_code == 'FRE') { languageName = 'FRENCH'; }
        if (retrieveLanguage_code == 'GER') { languageName = 'GERMAN'; }
        if (retrieveLanguage_code == 'GRE') { languageName = 'GREEK'; }
        if (retrieveLanguage_code == 'HEB') { languageName = 'HEBREW'; }
        if (retrieveLanguage_code == 'HIN') { languageName = 'HINDI'; }
        if (retrieveLanguage_code == 'HUN') { languageName = 'HUNGARIAN'; }
        if (retrieveLanguage_code == 'ICE') { languageName = 'ICELANDIC'; }
        if (retrieveLanguage_code == 'IND') { languageName = 'INDONESIAN'; }
        if (retrieveLanguage_code == 'IRA') { languageName = 'IRANIAN'; }
        if (retrieveLanguage_code == 'IRI') { languageName = 'IRISH'; }
        if (retrieveLanguage_code == 'ITA') { languageName = 'ITALIAN'; }
        if (retrieveLanguage_code == 'JPN') { languageName = 'JAPANESE'; }
        if (retrieveLanguage_code == 'KOR') { languageName = 'KOREA'; }
        if (retrieveLanguage_code == 'LAT') { languageName = 'LATIN'; }
        if (retrieveLanguage_code == 'MAC') { languageName = 'MACEDONIAN'; }
        if (retrieveLanguage_code == 'MLT') { languageName = 'MALTESE'; }
        if (retrieveLanguage_code == 'MON') { languageName = 'MONGOLIAN'; }
        if (retrieveLanguage_code == 'NEP') { languageName = 'NEPALIG'; }
        if (retrieveLanguage_code == 'NOR') { languageName = 'NORWEGIAN'; }
        if (retrieveLanguage_code == 'PBR') { languageName = 'PORTUGUESE - BRAZILIAN'; }
        if (retrieveLanguage_code == 'POL') { languageName = 'POLISH'; }
        if (retrieveLanguage_code == 'POR') { languageName = 'PORTUGUESE'; }
        if (retrieveLanguage_code == 'RON') { languageName = 'ROMANIAN'; }
        if (retrieveLanguage_code == 'RUS') { languageName = 'RUSSIAN'; }
        if (retrieveLanguage_code == 'SER') { languageName = 'SERBIAN'; }
        if (retrieveLanguage_code == 'SIN') { languageName = 'SINGHALESE'; }
        if (retrieveLanguage_code == 'SLA') { languageName = 'SPANISH - LATIN AMERICAN'; }
        if (retrieveLanguage_code == 'SLO') { languageName = 'SLOVAKIAN'; }
        if (retrieveLanguage_code == 'SLV') { languageName = 'SLOVENIAN'; }
        if (retrieveLanguage_code == 'SMO') { languageName = 'SAMOA'; }
        if (retrieveLanguage_code == 'SOM') { languageName = 'SOMALI'; }
        if (retrieveLanguage_code == 'SPA') { languageName = 'SPANISH'; }
        if (retrieveLanguage_code == 'SRD') { languageName = 'SARDINIAN'; }
        if (retrieveLanguage_code == 'SSW') { languageName = 'SWAZI'; }
        if (retrieveLanguage_code == 'SUN') { languageName = 'SUDANESE'; }
        if (retrieveLanguage_code == 'SWA') { languageName = 'SWAHILI'; }
        if (retrieveLanguage_code == 'SWE') { languageName = 'SWEDISH'; }
        if (retrieveLanguage_code == 'TAH') { languageName = 'TAHITIAN'; }
        if (retrieveLanguage_code == 'THA') { languageName = 'THAI'; }
        if (retrieveLanguage_code == 'TUR') { languageName = 'TURKISH'; }
        if (retrieveLanguage_code == 'UKR') { languageName = 'UKRAINIAN'; }
        if (retrieveLanguage_code == 'VIE') { languageName = 'VIETNAMESE'; }
        return languageName;
    }
    
    public static void logComment(string genlevelComment, string caseIdComment){
        CaseComment case_comment = new CaseComment();
        case_comment.CommentBody = genlevelComment;
        case_comment.ParentId = caseIdComment;
        insert case_comment;
    }
    
    public static list<CA_Product_Component__c> getComponentCodeWoTopsCode(string getComponentCode){
        List<CA_Product_Component__c> componentcode_list;
        List<CA_Product_Component__c> listOfCAProduct = [Select Id,Component_Code__c,Default_Component_for_CA_Product__c,Default_Component_for_this_CA_Product__c,CA_Product_Controller__c,CA_Product_Controller__r.Name from CA_Product_Component__c where Component_Code__c= :getComponentCode AND (component_expiration_date__c >= :System.today() OR component_expiration_date__c = null) ORDER BY CREATEDDATE DESC];        
        
        if(listOfCAProduct<>null && listOfCAProduct.size()>0){
             componentcode_list = new List<CA_Product_Component__c>();
             for(CA_Product_Component__c componentObj:listOfCAProduct){
                if((componentObj.CA_Product_Controller__r.Name!=Label.Global_Service_Center ||componentObj.CA_Product_Controller__r.Name==Label.Global_Service_Center) && componentObj.Default_Component_for_this_CA_Product__c){
                    defaultFlag=true;
                    componentcode_list.add(componentObj);
                    break;
                } 
            }
            if(!defaultFlag){
                //if default component doesn't exist then pass any component
                for(CA_Product_Component__c componentElseObj:listOfCAProduct){
                    if((componentElseObj.CA_Product_Controller__r.Name!=Label.Global_Service_Center || componentElseObj.CA_Product_Controller__r.Name==Label.Global_Service_Center) && !componentElseObj.Default_Component_for_this_CA_Product__c){
                        componentcode_list.add(componentElseObj);
                        scbugFlag = true;
                        scCompFlag = false;
                        scDefaultFlag = false;
                        productChangeFlag = true;
                        break;
                    }
                }    
            }
        }else{
            List<CA_Product_Component__c> productCompObj  = [Select Id, Component_Code__c, Default_Component_for_this_CA_Product__c, CA_Product_Controller__c,CA_Product_Controller__r.Name From CA_Product_Component__c where CA_Product_Controller__r.Name =:Label.Global_Service_Center AND Component_Code__c=:'SCBUG' AND (component_expiration_date__c=:null OR component_expiration_date__c >=: System.today()) ORDER BY CREATEDDATE DESC limit 1];
            if(productCompObj<>null && productCompObj.size()>0){
                componentcode_list = new List<CA_Product_Component__c>();
                componentcode_list.add(productCompObj[0]);   
                scbugFlag = true;
                scCompFlag = true;
                scDefaultFlag = true;
                productChangeFlag = true;
            }     
        }
        return componentcode_list;
    }
    
     public static String insertProductServicePack(String genlevelProductServicePack, String genlevelProductRelease, String genlevelName, String genlevelExtId){
         String prodServicePackLog=null; 
         try{
             Product_Service_Pack__c prodServicePack = new Product_Service_Pack__c();
             system.debug(genlevelName+'#########'+genlevelProductRelease+'$$$$$'+genlevelProductServicePack+'%%%%'+genlevelExtId);
             prodServicePack.Name = genlevelName;
             prodServicePack.Product_Release__c = genlevelProductRelease;
             prodServicePack.Product_Service_Pack__c = genlevelProductServicePack;
             prodServicePack.Product_Service_Pack_Ext_ID__c = genlevelExtId;
             insert prodServicePack;
             prodServicePackLog = ' Product service pack automatically created with id: '+ prodServicePack.Id;
         }catch(DmlException e){
             prodServicePackLog = 'Product Service Pack object insert failed: ';
         }
         return prodServicePackLog;
     }
    
    public static string getCaseDetailsById(string getCaseDetailsById_Id){
        List<Case> case_list = [Select CaseNumber from Case where Id =:getCaseDetailsById_Id limit 1];
        if(case_list.size()!= 1){
            return '-1';
        }else{
            return case_list[0].CaseNumber;
        }
    }
}