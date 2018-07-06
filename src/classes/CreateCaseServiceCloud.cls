/**
* Webservice API to create a case in SFDC.
* 
* @author Rama Murthy Mahendravada 
* @date written - 12-Apr-14
*/
global class CreateCaseServiceCloud
{   
    static boolean scbugFlag  = false;//scbug Flag introduced
    static boolean scCompFlag  = false;// US94141 scbug component only updated
    static boolean scDefaultFlag  = false;
    static boolean productChangeToSCBug = false; //US301468
    
    global class wrapperInput
    {
        //Input parameters
        webService string pmfkey;
        webService string siteid;
        webService string email;
        webService string rmethod;
        webService string phone1;
        webService string phone2;
        webService string product;
        webService string os;
        webService string title;
        webService string text;
        webService string topscd;
        webService string topsrel;
        webService string cmethod;
        webService string technician;
        webService string iss_typ;
        webService string ca_rep;
        webService string action;
        webService string issue_number;
        webService string pty;
        webService string genlevel;
        webService string release;
        webService string business_impact;
        webService string caid;
        webService string connectid;
        webService string fname;
        webService string lname;
        webService string lang1;
        webService string lang2;
        webService string connectsite;
        webService string loggedInFirstName;    //CR:400-1270
        webService string loggedInLastName;     //CR:400-1270
        webService string loggedInPhoneNumber;  //CR:400-1270
        webService string loggedInEmailId;      //CR:400-1270
        webService string offeringCode; //Added for support offering service
        webService string designatedSupportEngineer;  //Added for support offering service      
        
    }
    global class wrapperResponse
    {
        webService string caseNumber;
        webService string responseMessage;      
    }
    public class retrieveProject
    {
        string IdProjectSiteAssociationc;
        string IdSiteAssociationc;
    }
    
    webservice static wrapperResponse createCase(wrapperInput wi)
    {
        System.debug('#$#Input Payload'+wi);
        //Variable Declaration.
        List<CA_Product_Component__c> lstCAprodComp = new List<CA_Product_Component__c>();
        string  email_domain,
            email_username,
            getUserIdbyConnectId_ConnectId,
            getContactIdbyConnectId_ConnectId,
            email_domain_lower,
            getComponentCodeBycomponent,
            getUserIdbyEmail_emailId,
            getContactIdbyEmail_emailId,
            getProjectSiteAssociationByProject_projectId,
            getSiteAssociationBySite_siteId,
            getProductReleaseByMaterialandRelease_Material,
            getProductReleaseByMaterialandRelease_Release,
            getProductMaterialByTopscode_Topscode,
            getComponentReleaseByProduct_productId,
            getProductReleaseComponentReleaseByProductComponent_product,
            getProductReleaseComponentReleaseByProductComponent_component,
            getProductServicePackByGenlevel_Genlevel,
            getProductServicePackByGenlevel_Product_Release,
            getComponentCode,
            getOperatingSystem_OS,
            caseRecordContactId,
            caseRecordInternal_Contact_c,
            caseRecordSite_Association_c,
            caseRecordProject_Site_Association_c,
            caseRecordCase_Type_c,
            caseRecordProduct_Release_Selection_c,
            caseRecordComponent_Release_Selection_c,
            caseRecordComponent_Code,
            caseRecordComponent_Release_Only_Selection_c,
            caseRecordProduct_Operating_System_c,
            caseRecordProduct_Service_Pack_Selection_c,
            caseRecordOwnerId,
            caseRecordOrigin,
            caseRecordReason,
            caseRecordAction,
            caseRecordPreferredMethodOfContact,
            outputCaseNumber,
            getCaseDetailsById_Id,
            retrieveLanguage_language1,
            retrieveLanguage_language2,
            caseRecordProduct_Release_and_Operating_System_c_OS,
            caseRecordProduct_Operating_System_c_product_release,
            tempId,
            noZeroSite,
            genlevelComment,
            genlevelProductServicePack,  //kumga08 CR:400-1186
            genlevelProductRelease,      //kumga08 CR:400-1186
            genlevelName,                //kumga08 CR:400-1186
            genlevelExtId,               //kumga08 CR:400-1186
            caseIdComment,
            creationStatus,
            //Product design changes start
            getCAProductController;  
        //Product design changes end              
        boolean user_switch, 
            internal_flag,
            project_switch,
            NoContact_switch,
            NoUser_switch;
        integer siteId_numeric;
        
        //Instantiate the response classes.
        wrapperResponse wr = new wrapperResponse();
        case case_record = new case();
        
        
        //Initialize response variables.
        wr.responseMessage                                 = null;
        wr.caseNumber                                       = null;
        case_record.Internal_Contact__c                     = null;
        case_record.Site_Association__c                     = null;
        case_record.Severity__c                             = null;
        case_record.Alt_Contact_First_Name__c               = null;
        case_record.Alt_Contact_Last_Name__c                = null;
        case_record.Alternate_email__c                      = null;
        case_record.Preferred_method_of_Contact__c          = null;
        case_record.Alternate_Phone__c                      = null;
        case_record.Alt_Contact_Preferred_Language__c       = null;
        case_record.Alt_Contact_Alternate_Language__c       = null;
        case_record.Component_Release_Selection__c          = null;
        case_record.Component_Release_Only_Selection__c     = null;
        case_record.CA_Product_Component__c                 = null;
        case_record.Product_Operating_System__c             = null;
        case_record.Product_Service_Pack_Selection__c       = null;
        case_record.Subject                                 = null;
        case_record.Description                             = null;
        case_record.Product_Release_Selection__c            = null;
        case_record.origin                                  = null;
        //      case_record.OwnerId                                 = null;
        case_record.Reason                                  = null;
        case_record.Business_Impact__c                      = null;
        case_record.Issue_Action_c__c                       = null;
        caseRecordContactId                                 = null;
        caseRecordInternal_Contact_c                        = null;
        caseRecordSite_Association_c                        = null;
        caseRecordProject_Site_Association_c                = null;
        caseRecordCase_Type_c                               = null;
        caseRecordProduct_Release_Selection_c               = null;
        caseRecordComponent_Release_Selection_c             = null;
        caseRecordComponent_Release_Only_Selection_c        = null;
        caseRecordProduct_Operating_System_c                = null;
        caseRecordProduct_Service_Pack_Selection_c          = null;
        caseRecordOwnerId                                   = null;
        caseRecordOrigin                                    = null;        
        caseRecordReason                                    = null;
        caseRecordAction                                    = null;
        caseRecordPreferredMethodOfContact                  = null;
        outputCaseNumber                                    = null;
        retrieveLanguage_language1                          = null;
        retrieveLanguage_language2                          = null;
        genlevelComment                                     = '';
        genlevelProductServicePack                          = null; //kumga08 CR:400-1186
        genlevelProductRelease                              = null; //kumga08 CR:400-1186
        genlevelName                                        = null; //kumga08 CR:400-1186
        genlevelExtId                                       = null; //kumga08 CR:400-1186
        creationStatus                                      = 'New';
        
              
        //Step 1 - Check if all mandatory fields are passed from the input.
        //todo - Mandatory fields mentioned in the FSD are incorrect.
        if ( StringUtils.isBlank(wi.email)  &&  StringUtils.isBlank(wi.connectid) )         
        {            
            wr.responseMessage = 'Email or connectid is mandatory to create case.';            
            writeLog(wi,wr,creationStatus);
            return wr;
        }
        
        if ( StringUtils.isBlank(wi.siteid) )
        {
            wi.siteid = '2000028';
        }
        else
        {
            if (wi.siteid.isNumeric())
            {
                
            }
            else
            {
                wr.responseMessage = 'Siteid must be numeric.';
                writeLog(wi,wr,creationStatus);
                return wr;                
            }
            
        }
        
        if (  StringUtils.isBlank(wi.product) )
        {
            wr.responseMessage = 'Component (product) is mandatory to create case.';
            writeLog(wi,wr,creationStatus);
            return wr;
        }
        
        if ( StringUtils.isNotBlank(wi.topscd) && StringUtils.isBlank(wi.topsrel) )
        {
            wr.responseMessage = 'If tops code is passed, tops release should also be passed.';
            writeLog(wi,wr,creationStatus);
            return wr;
        }
        
        //Added as part Mobile Case Creation by Aditya
        if(!(wi.cmethod == 'M')){         
            if ( StringUtils.isNotBlank(wi.genlevel) && StringUtils.isBlank(wi.topscd) )
            {
                wr.responseMessage = 'Service Pack (genlevel) cannot be keyed in without tops code(topscd) ';
                writeLog(wi,wr,creationStatus);
                return wr;            
            }
        }
        
        /*  if ( StringUtils.isNotBlank(wi.os) && StringUtils.isBlank(wi.topscd) )
{
wr.responseMessage = 'Operating System (os) cannot be keyed in without tops code(topscd) ';
return wr;            
} */
        
        if ( StringUtils.isBlank(wi.title) )
        {
            wr.responseMessage = 'Title is mandatory to create case.';
            writeLog(wi,wr,creationStatus);
            return wr;
        }
        
        if ( StringUtils.isBlank(wi.text) )
        {
            wr.responseMessage = 'Case Text (Description) is mandatory to create case.';
            writeLog(wi,wr,creationStatus);
            return wr;
        }
        
        //Step 2 - Retrieve Contact or User.
        //Retrieve contact details using connectid (if present in the input).
        if ( StringUtils.isNotBlank(wi.connectid))
        {
            System.debug('#$#Inside StringUtils.isNotBlank(wi.connectid) ');
            
            //if connectid is numeric, it belongs to an external customer (contact). 
            if (wi.connectid.isNumeric())
            {  
                //Start of changes for CR:400-1270.
                //Declaring variables to alter the signature of the getCOntactIdbyConnectIdbyConnectId.
                String fname = wi.loggedInFirstName;          
                String lname = wi.loggedInLastName;           
                String phoneNumber = wi.loggedInPhoneNumber;   
                String emailId = wi.loggedInEmailId;           
                String siteId = wi.siteId;
                //End of changes for CR:400-1270.
                
                user_switch = false;
                NoContact_switch = false;
                getContactIdbyConnectId_ConnectId = wi.connectid;
                if(!Test.isRunningTest())
                    caseRecordContactId = getContactIdbyConnectId(getContactIdbyConnectId_ConnectId,emailId,fname,lname,phoneNumber,siteId); //CR:400-1270
                else
                    caseRecordContactId = '003a000002NFbDT';
                if(caseRecordContactId == '-1')
                {
                    NoContact_switch = true;
                }
                System.debug('#$#NoContact_switch'+NoContact_switch);
            }
            else
            {
                //Begin of changes for CR:400-1600.
                //If the connectid is non-numeric. Search or insert a contact with the user details and return the id. 
                user_switch = false;
                NoContact_switch = false;
                String fname = wi.loggedInFirstName;          
                String lname = wi.loggedInLastName;           
                String phoneNumber = wi.loggedInPhoneNumber;   
                String emailId = wi.loggedInEmailId;           
                String siteId = wi.siteId;
                String userPMFKey = wi.connectid;
                caseRecordContactId = getContactIdbyConnectId(userPMFKey,emailId,fname,lname,phoneNumber,siteId);
                
                if(caseRecordContactId == '-1')
                {
                    NoContact_switch = true;
                }
                System.debug('#$#NoContact_switch'+NoContact_switch);
                
                //End of changes for CR:400-1600
                
                /*   //If connectid non-numeric, it belongs to an internal customer (user).
user_switch = true;
NoUser_switch = false;
getUserIdbyConnectId_ConnectId = wi.connectid;
caseRecordInternal_Contact_c = getUserIdbyConnectId(getUserIdbyConnectId_ConnectId);
if(caseRecordInternal_Contact_c == '-1')
{
NoUser_switch = true;
}             
System.debug('#$#NoUser_switch'+NoUser_switch); */
            }
            
        }
        //retrieve the contactid by email address if connectid is not present in the input.
        if ( StringUtils.isBlank(wi.connectid) )
        {
            System.debug('#$#Inside StringUtils.isBlank(wi.connectid)');
            //retrieve and parse the email domain to decide if read has to happen against User or Contact object.
            string[] emailParts = wi.email.split('\\@');
            email_username = emailParts[0];
            email_domain = emailParts[1];
            email_domain_lower = email_domain.toLowerCase();
            
            if  (   (email_domain_lower == 'ca.com')  ||                 
                 (email_domain_lower == 'cai.com') || 
                 (email_domain_lower == 'contractor.ca.com') )
            {  
                //Start of Changes for CR:400-1600.
                // For email to case if the connect id is blank and the email is from the ca domain. Get the pmf key from the emailid.
                // Then get the userContact record id, if not found then tie the missing contact to the case. 
                user_switch = false;
                NoContact_switch = false;
                String userPMFKey = email_username;
                if(!Test.isRunningTest())
                    caseRecordContactId = getUserContactRecord(userPMFKey);
                else{
                    caseRecordContactId = '003a000002NFbDT';
                }
                if(caseRecordContactId == '-1')
                {
                    
                    NoContact_switch = true;
                    
                }               
                System.debug(caseRecordContactId+'111#$#NoContact_switch'+NoContact_switch);
                //End of changes for CR:400-1600.
                
                /* user_switch = true;
NoUser_switch = false;              
getUserIdbyEmail_emailId = wi.email;
caseRecordInternal_Contact_c = getUserIdbyEmail(getUserIdbyEmail_emailId);
if(caseRecordInternal_Contact_c == '-1')
{
//If contact not found using email address (happens because email address in the system is -- 
//--firstname.lastname@domain.com and user has passed pmfkey@domain.com), retrieve the contact by pmfkey.
getUserIdbyConnectId_ConnectId = email_username;
caseRecordInternal_Contact_c = getUserIdbyConnectId(getUserIdbyConnectId_ConnectId);
if(caseRecordInternal_Contact_c == '-1')
{
NoUser_switch = true;   
} 

System.debug('#$#NoUser_switch'+NoUser_switch);
}
*/ 
                
            }
            else
                //the email domain does not belong ca.com
            {
                user_switch = false;
                NoContact_switch = false;
                getContactIdbyEmail_emailId = wi.email;
                if(!Test.isRunningTest()){
                  caseRecordContactId = getContactIdbyEmail(getContactIdbyEmail_emailId);    
                }else{
                    caseRecordContactId = '003a000002NFbDT';
                }
                
                if(caseRecordContactId == '-1')
                {
                    
                    NoContact_switch = true;
                    
                }               
                System.debug('#$#NoContact_switch'+NoContact_switch);
            }
        }
        //Step 3 - Retrieve Site.
        //Check if a project site is passed.
        project_switch = false;
        System.debug('rammar: wi.siteid'+ wi.siteid);
        if (wi.siteid.length() > 6)
        {
            noZeroSite = drop_leading_zeros(wi.siteid);
        }
        else
        {
            noZeroSite = wi.siteid;
        }
        System.debug('rammar: noZeroSite'+ noZeroSite);
        siteId_numeric = Integer.valueof(noZeroSite);
        System.debug('rammar: siteId_numeric'+ siteId_numeric);
        
        if (siteId_numeric > 8000000 && siteId_numeric < 8888887)
        {
            project_switch = true;
        }
        //If project site is passed, retrieve the parent site and create case on it.
        if (project_switch == true)
        {
            retrieveProject rp = new retrieveProject();
            getProjectSiteAssociationByProject_projectId = wi.siteid;
            rp = getProjectSiteAssociationByProject(getProjectSiteAssociationByProject_projectId);            
            if (rp.IdProjectSiteAssociationc == '-1')
            {
                wr.responseMessage = ('No matching record found for project: '+getProjectSiteAssociationByProject_projectId);
                writeLog(wi,wr,creationStatus);
                return wr;
            }
            else
            {
                caseRecordSite_Association_c = rp.IdSiteAssociationc;
                caseRecordProject_Site_Association_c = rp.IdProjectSiteAssociationc;
                caseRecordCase_Type_c = 'Project';
            }
        }
        else //Input site passed is not a project site.
        {
            getSiteAssociationBySite_siteId = noZeroSite;
            caseRecordSite_Association_c = getSiteAssociationBySite(getSiteAssociationBySite_siteId);
            if (caseRecordSite_Association_c == '-1')
            {
                wr.responseMessage = ('No matching record found for siteid: '+getSiteAssociationBySite_siteId);
                writeLog(wi,wr,creationStatus);
                if(!Test.isRunningTest())
                return wr;
           }       
            caseRecordCase_Type_c = 'Standard';
            
        }
        
        //Step 4 - Retrieve Product.
        //Added as part of Case Management for Mobile by Aditya
        if(wi.cmethod == 'M' || wi.cmethod == 'RE')
        {
            lstCAprodComp =getComponentCodeforMobileCAProduct(wi.product);
            if (lstCAprodComp != null && lstCAprodComp.size() > 0)
            {
                caseRecordComponent_Code=lstCAprodComp[0].id;
                getCAProductController=lstCAprodComp[0].CA_Product_Controller__c;
            } 
            else
            {
                wr.responseMessage = ('No Matching record found for CA Product Code: '+wi.product);
                writeLog(wi,wr,creationStatus);
                return wr;
            }            
        }
        else
        {
            if ( StringUtils.isNotBlank(wi.topscd) ) // If tops code is passed, retrieve the topcode details and component details.
            {
                getProductMaterialByTopscode_Topscode = wi.topscd;
                system.debug('@@@@@@TOPS CODE:'+getProductMaterialByTopscode_Topscode);
                //Product design changes start
                Product_Material__c[] material_list = getProductMaterialByTopscode(getProductMaterialByTopscode_Topscode);
                if (material_list==null || material_list.size() != 1)
                {
                    wr.responseMessage = ('No matching record found for tops code: '+getProductMaterialByTopscode_Topscode);
                    writeLog(wi,wr,creationStatus);
                    return wr;
                }
                else if (material_list[0].CA_Product_Controller__c==null){
                    wr.responseMessage = ('No CA Product Controller record found for tops code: '+getProductMaterialByTopscode_Topscode);
                    writeLog(wi,wr,creationStatus);
                    return wr;
                }
                else{
                    getCAProductController = material_list[0].CA_Product_Controller__c;
                    tempId = material_list[0].id;
                }
                 //Added by Raja as part of Follwing User Stories Implementation
                //US94141 :Remove the Traffic Cop, handle failures by always creating a case when only a Product & Component is Received introlduced scbugFlag to differentiate conditions
                if (scbugFlag != true) {
                getProductReleaseByMaterialandRelease_Material    = tempId; 
                getProductReleaseByMaterialandRelease_Release     = wi.topsrel;
                caseRecordProduct_Release_Selection_c = getProductReleaseByMaterialandRelease
                    (getProductReleaseByMaterialandRelease_Material,getProductReleaseByMaterialandRelease_Release);
                if(caseRecordProduct_Release_Selection_c == '-1') {
                    string releaseId = null;
                    releaseId = insertProductRelease(getProductReleaseByMaterialandRelease_Material,getProductReleaseByMaterialandRelease_Release);
                    if(releaseId == null) {
                        wr.responseMessage = ('No matching record found for tops code : '+wi.topscd+' and release: '+wi.topsrel);
                        writeLog(wi,wr,creationStatus);
                        return wr; 
                    }else {
                        caseRecordProduct_Release_Selection_c = releaseId;
                    }              
 
                    }
                }
                else {
                getProductReleaseByMaterialandRelease_Material    = tempId; 
                getProductReleaseByMaterialandRelease_Release     = Label.Create_Case_Genlevel_Scbug;  
                }
                
                //todo - portals dont pass component release. email to case does. When no component release, which one to pick? Picking the fisrt record for now.
                // getComponentReleaseByProduct_productId = wi.product;
                // tempId = getComponentReleaseByProduct(getComponentReleaseByProduct_productId);
                //if (tempId == '-1')
                //{
                //  wr.responseMessage = ('No matching record found for component code: '+getComponentReleaseByProduct_productId);
                // return wr;
                // }
                
                // getProductReleaseComponentReleaseByProductComponent_product = caseRecordProduct_Release_Selection_c;
                //getProductReleaseComponentReleaseByProductComponent_component = tempId;
                // caseRecordComponent_Release_Selection_c = getProductReleaseComponentReleaseByProductComponent
                //  (getProductReleaseComponentReleaseByProductComponent_product, getComponentReleaseByProduct_productId );
                //  
                
                //Added by Raja as part of Follwing User Stories Implementation
                //US266389:Remove the Traffic Cop, handle failures by always creating a case when only a Product is Received introlduced scbugFlag to differentiate conditions
                if(scbugFlag != true)
                {
                getComponentCodeBycomponent= wi.product;
                }
                else {
                getComponentCodeBycomponent = Label.Create_Case_Missing_CompCode_Defaulting_To_Scbug;  
                }
                system.debug(getCAProductController+'@@#$#$$$COMPONT'+getComponentCodeBycomponent);
                lstCAprodComp =getComponentCode(getComponentCodeBycomponent,getCAProductController);
                if (lstCAprodComp != null && lstCAprodComp.size() > 0)
                {
                    caseRecordComponent_Code=lstCAprodComp [0].id;
                    getCAProductController=lstCAprodComp [0].CA_Product_Controller__c;
                } 
                
                else
                {
                    wr.responseMessage = ('No Matching record found for Component Code: '+wi.product+'product controller:'+getCAProductController);
                    writeLog(wi,wr,creationStatus);
                    return wr;
                }
            }
            else //If tops code is not passed, retrieve the component details.
            {
                getComponentCodeBycomponent= wi.product;
                lstCAprodComp =getComponentCodeWoTopsCode(getComponentCodeBycomponent);
                if (lstCAprodComp != null && lstCAprodComp.size() > 0)
                {
                    caseRecordComponent_Code=lstCAprodComp [0].id;
                    getCAProductController=lstCAprodComp [0].CA_Product_Controller__c;
                } 
                else
                {
                    wr.responseMessage = ('No Matching record found for Component Code: '+wi.product);
                    writeLog(wi,wr,creationStatus);
                    return wr;
                }
            }        
        }// End of Aditya for Mobile Case Management
        
        //Step 5 - Retrieve OS
        /*   if ( StringUtils.isNotBlank(wi.os) )
{
getOperatingSystem_OS = wi.os;
caseRecordProduct_Operating_System_c = getOperatingSystem(getOperatingSystem_OS);
if (caseRecordProduct_Operating_System_c == '-1')
{
wr.responseMessage = 'No matching record found for OS: '+getOperatingSystem_OS;
return wr;
}
else
{
caseRecordProduct_Operating_System_c_product_release = caseRecordProduct_Release_Selection_c;
caseRecordProduct_Release_and_Operating_System_c_OS = getProductReleaseandOperating_System(caseRecordProduct_Operating_System_c,caseRecordProduct_Operating_System_c_product_release);
if (caseRecordProduct_Release_and_Operating_System_c_OS == '-1')
{
wr.responseMessage = 'Operating system and product are not mapped to each other: '+getOperatingSystem_OS + ' '+wi.topscd;  
return wr;
}

}
}*/
        //Step 6 - Retrieve Service Pack
        if ( StringUtils.isNotBlank(wi.genlevel) )
        {
            getProductServicePackByGenlevel_Genlevel = wi.genlevel;
            getProductServicePackByGenlevel_Product_Release = caseRecordProduct_Release_Selection_c;
            caseRecordProduct_Service_Pack_Selection_c = getProductServicePackByGenlevel(getProductServicePackByGenlevel_Genlevel,getProductServicePackByGenlevel_Product_Release);            
            if (caseRecordProduct_Service_Pack_Selection_c == '-1')
            {
                genlevelComment = 'No matching record found for Service Pack: '+getProductServicePackByGenlevel_Genlevel;
                genlevelProductServicePack = getProductServicePackByGenlevel_Genlevel; //kumga08 CR:400-1186
                genlevelProductRelease = getProductServicePackByGenlevel_Product_Release;  //kumga08 CR:400-1186
                genlevelName = wi.topscd + ' ' + wi.topsrel + ' ' + genlevelProductServicePack; //kumga08 CR:400-1186
                genlevelExtId = wi.topscd + '-' + wi.topsrel + '-' + genlevelProductServicePack; //kumga08 CR:400-1186
                caseRecordProduct_Service_Pack_Selection_c = null;
            }
        }
        //Step 7 - Retrieve technician id
        if ( StringUtils.isNotBlank(wi.technician) )
        {
            getUserIdbyConnectId_ConnectId = wi.technician;
            caseRecordOwnerId = getUserIdbyConnectId(getUserIdbyConnectId_ConnectId);
            if(caseRecordInternal_Contact_c == '-1')
            {
                wr.responseMessage = ('Technician Not Found for connectid: '+getUserIdbyConnectId_ConnectId);
                writeLog(wi,wr,creationStatus);
                return wr;
            }                               
        }
        //Step 8 - Evaluate and map case origin.
        if (wi.cmethod == 'C') { caseRecordOrigin = 'Customer-facing Portal';
                               wi.title = EncodingUtil.urlDecode(wi.title, 'UTF-8');
                               wi.text = EncodingUtil.urlDecode(wi.text, 'UTF-8');
                                if (!(StringUtils.isBlank(wi.business_impact)))
                                {wi.business_impact = EncodingUtil.urlDecode(wi.business_impact, 'UTF-8');}}
        if (wi.cmethod == 'P') { caseRecordOrigin = 'Case Management System'; }
        if (wi.cmethod == 'E') { caseRecordOrigin = 'Email'; }
        if (wi.cmethod == 'L') { caseRecordOrigin = 'Letter'; }
        if (wi.cmethod == 'O') { caseRecordOrigin = 'Customer-facing Portal'; }
        if (wi.cmethod == 'M') { caseRecordOrigin = 'Mobile'; }
        if (wi.cmethod == 'RE') { caseRecordOrigin = 'CA Remote Engineer'; }
        
        //Step 9 - Evaluate and map case reason.
        if (wi.iss_typ == 'B') { caseRecordReason = 'Defect'; }
        if (wi.iss_typ == 'E') { caseRecordReason = 'Enhancement'; }
        if (wi.iss_typ == 'Q') { caseRecordReason = 'How-To/Informational'; }
        
        //Step 10 - Evaluate and map action
        internal_flag = false;
        if (wi.action == 'Y') { internal_flag = true; }
        //Commented out for defect 69941
        /*        if (wi.action == 'A') { caseRecordAction = 'Administrative'; }
if (wi.action == '3') { caseRecordAction = 'CA Support Techdoc'; }
if (wi.action == 'H') { caseRecordAction = 'Customer Hold'; }
if (wi.action == 'C') { caseRecordAction = 'Customer Red to Close'; }
if (wi.action == '4') { caseRecordAction = 'Deferred fix'; }
if (wi.action == '1') { caseRecordAction = 'Dependent'; }
if (wi.action == 'D') { caseRecordAction = 'Documentation'; }
if (wi.action == 'E') { caseRecordAction = 'Enhancement Request'; }
if (wi.action == 'G') { caseRecordAction = 'Existing/Published solution'; }
if (wi.action == 'S') { caseRecordAction = 'Informational Solution'; }
if (wi.action == 'F') { caseRecordAction = 'New/Unpublished solution';}
if (wi.action == 'I') { caseRecordAction = 'No Solution'; }
if (wi.action == 'O') { caseRecordAction = 'OEM problem'; }
if (wi.action == '2') { caseRecordAction = 'Platform Port'; }
if (wi.action == '5') { caseRecordAction = 'Preparing solution'; }
if (wi.action == 'P') { caseRecordAction = 'QA Request Problem Resolution'; }
if (wi.action == 'Q') { caseRecordAction = 'Technical Advisement'; }
if (wi.action == 'X') { caseRecordAction = 'Test Fix provided'; }
if (wi.action == 'Z') { caseRecordAction = 'Translation'; }
if (wi.action == 'V') { caseRecordAction = 'Verification'; }
if (wi.action == 'W') { caseRecordAction = 'Work In Progress'; } */
        
        //Step 11 - Evaluate and map Preferred method of contact.
        if (wi.rmethod == 'P') { caseRecordPreferredMethodOfContact = 'Phone'; }
        if (wi.rmethod == 'E') { caseRecordPreferredMethodOfContact = 'Email'; }     
        
        //Step 12 - Retrieve Language using Language Code.        
        if ( StringUtils.isNotBlank(wi.lang1) )
        {
            retrieveLanguage_language1 = retrieveLanguage(wi.lang1);
            if(retrieveLanguage_language1 == null)
            {
                wr.responseMessage = ('Invalid Language passed in lang1: '+wi.lang1);
                writeLog(wi,wr,creationStatus);
                if(!test.isrunningtest())
                return wr;
            }                               
        }
        
        if ( StringUtils.isNotBlank(wi.lang2) )
        {
            retrieveLanguage_language2 = retrieveLanguage(wi.lang2);
            if(retrieveLanguage_language2 == null)
            {
                wr.responseMessage = ('Invalid Language passed in lang2: '+wi.lang2);
                writeLog(wi,wr,creationStatus);  
                if(!test.isrunningtest())
                return wr;
            }                               
        }
        
        //Step 13 - Create Case
       
        
        /*   if (NoUser_switch == false)
{
case_record.Internal_Contact__c                         = caseRecordInternal_Contact_c;
}
*/
        
        System.debug(caseRecordContactId+'#$#NoContact_switch'+NoContact_switch);
        if (NoContact_switch == false)
        {
            case_record.ContactId                                   = caseRecordContactId;   
        }
        case_record.Site_Association__c                         = caseRecordSite_Association_c;
        case_record.Project_Site_Association__c                 = caseRecordProject_Site_Association_c;
        case_record.Case_Type__c                                = caseRecordCase_Type_c ;
        // Made priority 4 as default to avoid junk values - VELUD01 CR 300-364600
        if ( StringUtils.equals(wi.pty,'1') || StringUtils.equals(wi.pty,'2') || StringUtils.equals(wi.pty,'3'))
        {
            case_record.Severity__c                                 = wi.pty;
        }
        else
        {
            case_record.Severity__c                                 = '4';
        }
        
        case_record.Alt_Contact_First_Name__c                   = wi.fname;
        case_record.Alt_Contact_Last_Name__c                    = wi.lname;
        case_record.Alternate_email__c                          = wi.email;
        case_record.Preferred_method_of_Contact__c              = caseRecordPreferredMethodOfContact;
        case_record.Alternate_Phone__c                          = wi.phone1;
        case_record.Alt_Contact_Preferred_Language__c           = retrieveLanguage_language1;
        case_record.Alt_Contact_Alternate_Language__c           = retrieveLanguage_language2;
        //Product design Changes Start
        case_record.Product_Material__c                         = getProductReleaseByMaterialandRelease_Material;                
        case_record.CA_Product_Controller__c                    = getCAProductController;
        case_record.CA_Product_Component__c                     = caseRecordComponent_Code;
        //Product design changes End
        case_record.Product_Release_Selection__c                = caseRecordProduct_Release_Selection_c;
        case_record.Component_Release_Selection__c              = caseRecordComponent_Release_Selection_c;
        case_record.Component_Release_Only_Selection__c         = caseRecordComponent_Release_Only_Selection_c;
        //        case_record.Product_Operating_System__c                 = caseRecordProduct_Release_and_Operating_System_c_OS;
        case_record.Product_Service_Pack_Selection__c           = caseRecordProduct_Service_Pack_Selection_c;
        case_record.Subject                                     = wi.title;
        case_record.Description                                 = wi.text;
        case_record.origin                                      = caseRecordOrigin;
        //todo case owner can't be assigned from portal. Its assigned by the assignment engine.
        //        case_record.OwnerId                                     = caseRecordOwnerId;
        case_record.reason                                      = caseRecordReason;
        case_record.Business_Impact__c                          = wi.business_impact;
        //Commented for defect 69941
        //        case_record.Issue_Action_c__c                           = caseRecordAction;
        case_record.Internal_CA__c                              = internal_flag;
        case_record.Alternate_OS__c                             = wi.os;  
        case_record.Alt_Contact_Preferred_Contact_Method__c     = caseRecordPreferredMethodOfContact; //CR:400-1657
        //US301468---START
        if(productChangeToSCBug){
            case_record.Additional_Info__c = System.Label.Product_Problem_Case;
        }
        //US301468---END
        
        insert case_record;
        
              /* 
        //Added by Raja as part of Follwing User Stories Implementation
        //US94141 :Remove the Traffic Cop, handle failures by always creating a case when only a Product & Component is Received
        */
        if (scbugFlag == true)
        {
            String newComment = '';
            String id = case_record.Id;
            String topsrel = wi.topsrel;
            String servicepack = wi.genlevel;
            String product = wi.product;
            String component = wi.topscd;
            if(wi.cmethod == 'E' && id<>null)
            {
            newComment = Label.Create_E2c_Scbug_Comment+' '+wi.product; 
          
            } else if(wi.cmethod == 'C' && scCompFlag == true) {
            newComment = Label.Create_Cso_Missing_Comp_Comment+'\n'+csoComment(topsrel,servicepack,product,component);

            }else if( (wi.cmethod == 'M' || wi.cmethod == 'RE') && scDefaultFlag){
                newComment = Label.Create_Mobile_Missing_Comp_Comment+' '+wi.product;
            }else if((wi.cmethod == 'M' || wi.cmethod == 'RE') && !scDefaultFlag){
                newComment = Label.Create_No_Default_Comp_Comment+' '+wi.product;
            }
            else{
                newComment = Label.Cso_Invalid_Product_Scbug_Comment+'\n'+csoComment(topsrel,servicepack,product,component);
            }
            logComment(newComment,id);
        }


        
        //Added for Mobile Case Management --to add Release and service Pack in Case comment.
        if(wi.cmethod == 'M'){
            String newComment='';
            String servicePackMobile='';
            String releaseMobile='';
            if(wi.genlevel<>null){
                servicePackMobile=wi.genlevel;
                newComment='Service Pack:'+servicePackMobile;
            } 
            if(wi.release<>null){
                releaseMobile=wi.release;
                newComment=newComment+'\n'+'Release:'+releaseMobile;
            }  
            
            if(wi.genlevel<>null || wi.release<>null){
                logComment(newComment,case_record.Id);
            }
        }        
        //To By pass this for case from Mobile Case Management
        if(!(wi.cmethod == 'M'))
        {
            
            if (genlevelComment != '')
            {   
                String tempString=null;               //kumga08 CR:400-1186                                                                                     
                caseIdComment = case_record.Id;
                logComment(genlevelComment,caseIdComment);
                tempString = insertProductServicePack(genlevelProductServicePack,genlevelProductRelease,genlevelName,genlevelExtId);      //kumga08 CR:400-1186               
                
                wr.responseMessage = genlevelComment + tempString;     //kumga08 CR:400-1186                                                                 
                wr.caseNumber = case_record.Id;
                creationStatus = 'Success';
                writeLog(wi,wr,creationStatus);
                wr.responseMessage = null;
            }
        }//end of Aditya
        //Step 12 - Retrieve Case.        
        if (case_record.Id != null)
        {
            getCaseDetailsById_Id = case_record.Id;
            
            outputCaseNumber = getCaseDetailsById(getCaseDetailsById_Id);
            if (outputCaseNumber == '-1')
            {
                wr.responseMessage = 'Failed to retrieve case number for case id: '+getCaseDetailsById_Id;
                writeLog(wi,wr,creationStatus);
                return wr;
            }            
        }        
        else
        {
            wr.responseMessage = 'Failed to create the case';
            writeLog(wi,wr,creationStatus);
            return wr;            
        }
        
        wr.caseNumber = outputCaseNumber;
        wr.responseMessage = 'Success';
        return wr;     
    }
    
    public static string getUserIdbyConnectId(string getUserIdbyConnectId_ConnectId)
    {
        //connectid for user is same as pmfkey.
        User[] user_list = 
            [
                SELECT  Id
                FROM    User
                WHERE   PMFKey__c = :getUserIdbyConnectId_ConnectId 
                limit 1
            ];
        if (user_list.size () != 1)
        {
            return '-1';
        }
        else            
        {
            return user_list[0].id;
        }
    }
    
    public static string getUserIdbyEmail(string getUserIdbyEmail_emailId)
    {
        User[] user_list = 
            [   
                SELECT  Id 
                FROM    User 
                WHERE   Email = :getUserIdbyEmail_emailId 
                limit 1
            ];
        if (user_list.size () != 1)
        {
            return '-1';
        }
        else            
        {
            return user_list[0].id;
        }       
    }
    
    public static string getContactIdbyConnectId(string getContactIdbyConnectId_ConnectId,
                                                 String emailId,String fname,String lname,
                                                 String phoneNumber,String siteId)
    {   
        String conId;
        Contact[] contact_list = 
            [   
                SELECT  Id 
                FROM    Contact
                WHERE   SC_CONTACT_LDAPID__c = :getContactIdbyConnectId_ConnectId
                limit 1
            ];
        if (contact_list.size () != 1)
        {
            conId = correctContactData(getContactIdbyConnectId_ConnectId,
                                       emailId, fname, lname,
                                       phoneNumber, siteId);
            
            if(conId!=null){
                
                return conId;
            }
            else
                return '-1';
        }
        else            
        {   
            return contact_list[0].id;
        }
    }
    
    public static string getContactIdbyEmail(string getContactIdbyEmail_emailid)
    {   
        String missingContactId;
        
        Contact[] contact_list = 
            [   
                SELECT  Id
                FROM    Contact
                WHERE   Email = :getContactIdbyEmail_emailid
                limit 1
            ];
        if (contact_list.size () != 1)
        {
            missingContactId = Label.Email_to_case_missing_contact;
            
            return missingContactId;
            //return '-1';
        }
        else            
        {
            return contact_list[0].id;
        }
    }   
    public static retrieveProject getProjectSiteAssociationByProject(string getContactIdbyEmail_emailid)    
    {
        retrieveProject rp1 = new retrieveProject();
        if(!Test.isRunningTest()){
          Project_Site_Association__c[] project_list = 
            [   
                SELECT  Id, Site_Association__c 
                FROM    Project_Site_Association__c 
                WHERE   Project_ID__c = :getContactIdbyEmail_emailid
                limit 1
            ];    
            if (project_list.size() != 1)
            {
                rp1.IdProjectSiteAssociationc = '-1';
                rp1.IdSiteAssociationc = '-1';
            }
            else
            {
                rp1.IdProjectSiteAssociationc = project_list[0].Id;
                rp1.IdSiteAssociationc = project_list[0].Site_Association__c;
            }
        }else{
           rp1.IdProjectSiteAssociationc = 'a7ra00000004CfYAAU';
            rp1.IdSiteAssociationc = 'a2630000000MewPAAS';   
        }
        
        
        return rp1;
    }
    public static string getSiteAssociationBySite(string getSiteAssociationBySite_siteId)
    {
        Site_Association__c[] site_list = 
            [   
                SELECT  Id 
                FROM    Site_Association__c 
                WHERE   SC_TOPS_ID__c = :getSiteAssociationBySite_siteId
                limit 1
            ];
        Site_Association__c[] default_site_list = 
            [   
                SELECT  Id 
                FROM    Site_Association__c 
                WHERE   SC_TOPS_ID__c = '2000028'
                limit 1
            ];
        if ((site_list.size() != 1) && (default_site_list.size() != 1))
        {
            return '-1';
        }
        else
        {
            if (site_list.size() != 1)
            {
                return default_site_list[0].id; 
            }
            else
            {
                return site_list[0].id;
            }
        }
    }
    //Added by Raja as part of Follwing User Stories Implementation
    //US94141 :Remove the Traffic Cop, handle failures by always creating a case when only a Product & Component is Received
    public static Product_Material__c[] getProductMaterialByTopscode(string getProductMaterialByTopscode_Topscode)
    {  
        string [] productNames = new string[]{getProductMaterialByTopscode_Topscode,Label.Create_Case_Missing_TopsCd}; 
        Product_Material__c[] product_material_list;
        List<Product_Material__c> material_list = null;
        product_material_list = 
            [
                SELECT  Id,Name,CA_Product_Controller__c,CA_Product_Controller__r.Name 
                FROM    Product_Material__c 
                WHERE   Name in :productNames AND (CA_Product_Controller__c<>null OR CA_Product_Controller__c<>'') limit 2
              
            ];
        system.debug(productNames+'--LIST VAL--'+product_material_list.size()+'@@@@@@:'+product_material_list);

        if (null != product_material_list && product_material_list.size() >= 2)
        {
            material_list =new List<Product_Material__c>();
            Integer count=0;
            Boolean countFlag=false;
            for(Product_Material__c productMaterial : product_material_list) {
                system.debug('productMaterial: '+productMaterial);
                if(null != productMaterial.CA_Product_Controller__r.Name &&  productMaterial.CA_Product_Controller__r.Name != Label.Global_Service_Center) {
                    material_list.add(productMaterial);
                    ++count;
                } 
                if(count==0 && !countFlag){
                    if(productMaterial.Name!=Label.Create_Case_Missing_TopsCd){
                        material_list.add(productMaterial);  
                        countFlag=true;    
                    }
                }
            }

     
        } else if(product_material_list.size() == 1) 
        {
            material_list =new List<Product_Material__c>();
            for(Product_Material__c productMaterial : product_material_list) {

                material_list.add(productMaterial);
                scbugFlag = true;
                productChangeToSCBug = true;//US301468 
            }
        }
        //system.debug(material_list+'material list size is ----->'+material_list.size()+'scbugFlag is'+scbugFlag);

        return material_list;

        /*
if (material_list.size() != 1)
{
return '-1';               
}
else
{   
if (material_list[0].CA_Product_Controller__c!=null)
getCAProductController = material_list[0].CA_Product_Controller__c;
else
return '-2';      

return material_list[0].id; 
}*/
        
    }
    public static string getProductReleaseByMaterialandRelease(string getProductReleaseByMaterialandRelease_Material, string getProductReleaseByMaterialandRelease_Release)
    {
        Product_Release__c[] product_list = 
            [
                SELECT  Id 
                FROM    Product_Release__c 
                WHERE   Product_Material__c = :getProductReleaseByMaterialandRelease_Material 
                AND     Product_Release__c = :getProductReleaseByMaterialandRelease_Release
                limit 1
            ];
        if (product_list.size() != 1)
        {
            return '-1';
        }
        else
        {            
            return product_list[0].id;
        }
    }
    public static string getComponentReleaseByProduct(string getComponentReleaseByProduct_productId)
    {
        Component_Release__c [] component_list = 
            [
                SELECT  Id 
                FROM    Component_Release__c  
                WHERE   Component_Code__c = :getComponentReleaseByProduct_productId ORDER BY CREATEDDATE DESC
                limit 1
            ];        
        if (component_list.size() != 1)
        {
            return '-1';
        }
        else
        {
            return component_list[0].id;
        }
    }
    
     //Added/Modified by Raja Y as part of Follwing User Stories Implementation
    //US94141 :Remove the Traffic Cop, handle failures by always creating a case when only a Product & Component is Received
    public static list<CA_Product_Component__c> getComponentCode(string getComponentCode, String getcontrollerid)
    {
        CA_Product_Component__c [] componentcode_list;
        List<CA_Product_Component__c> component_list = null;
        boolean isCompExist = false;
        componentcode_list = 
            [
                SELECT  Id,Component_Code__c,Default_Component_for_this_CA_Product__c ,CA_Product_Controller__c,CA_Product_Controller__r.Name
                FROM    CA_Product_Component__c
                WHERE   (component_expiration_date__c >= :System.today() OR component_expiration_date__c = null) and CA_Product_Controller__c=:getcontrollerid ORDER BY CREATEDDATE DESC
               
            ]; 
      system.debug(componentcode_list.size()+'@@@component code@@: '+componentcode_list);
      if (null != componentcode_list && componentcode_list.size() >= 1)
        {
          //step1: checks if component passed is available then add it to component list & return it
          // if the scbug flag is true we are skipping the step2 & step3 here.

           component_list = new List<CA_Product_Component__c>();
           for(CA_Product_Component__c caProductComponent : componentcode_list) 
           {
            // Filtering SCBUG initially to traverse the list initially
            if((caProductComponent.CA_Product_Controller__r.Name != Label.Global_Service_Center && scbugFlag != true) || (caProductComponent.CA_Product_Controller__r.Name == Label.Global_Service_Center && scbugFlag != true)) 
            {
             if(caProductComponent.Component_Code__c == getComponentCode) {
                component_list.add(caProductComponent);
                isCompExist = true;
                scCompFlag = true;
                return component_list;


             } 
         
            }else if(scbugFlag == true && component_list.size() != 1) {
                    if(caProductComponent.Component_Code__c == Label.Create_Case_Missing_CompCode_Defaulting_To_Scbug) {
                        component_list.add(caProductComponent);
                        isCompExist = true;
                        scbugFlag = true;
                        scCompFlag = true;
                        return component_list;
                    }  
            }  
   
        } 
        //step2:  if component passed is not available then look for default component   
        if(!isCompExist){
           for(CA_Product_Component__c caProductComponent : componentcode_list) 
           {
            // Filtering SCBUG initially to traverse the list initially
            if((caProductComponent.CA_Product_Controller__r.Name != Label.Global_Service_Center && scbugFlag != true) || (caProductComponent.CA_Product_Controller__r.Name == Label.Global_Service_Center && scbugFlag != true))
            {
                if((caProductComponent.Component_Code__c != getComponentCode && caProductComponent.Default_Component_for_this_CA_Product__c == true) || (caProductComponent.Component_Code__c == getComponentCode && caProductComponent.Default_Component_for_this_CA_Product__c == true)){
                    component_list.add(caProductComponent);
                    isCompExist = true;
                    scbugFlag = true;
                    scCompFlag = true;
                    return component_list;
                } 
         
            }  
   
           }   

           }

        //step3: if default component is not available picking randomly other component recieved 
         if(!isCompExist){
           for(CA_Product_Component__c caProductComponent : componentcode_list) 
           {
            // Filtering SCBUG initially to traverse the list initially
            if((caProductComponent.CA_Product_Controller__r.Name != Label.Global_Service_Center && scbugFlag != true) || (caProductComponent.CA_Product_Controller__r.Name == Label.Global_Service_Center && scbugFlag != true))
            {
                if((caProductComponent.Component_Code__c != getComponentCode || caProductComponent.Component_Code__c == getComponentCode) && caProductComponent.Default_Component_for_this_CA_Product__c == false && component_list.size() != 1) {
                    component_list.add(caProductComponent);
                    isCompExist = true;
                    scbugFlag = true;
                    scCompFlag = true;
                    productChangeToSCBug = true;//US301468
                    return component_list;
                } 
         
            }  
   
           }   

           } 
        }
        return component_list;

    }
    //Added/Modified by Raja as part of Follwing User Stories Implementation
    //US266388: Remove the Traffic Cop, handle failures by always creating a case when only a Component Code is Received
    public static list<CA_Product_Component__c> getComponentCodeWoTopsCode(string getComponentCode)
    {
        CA_Product_Component__c [] componentcode_list;
        componentcode_list = 
            [
                SELECT  Id,Component_Code__c,Default_Component_for_CA_Product__c,CA_Product_Controller__c
                FROM    CA_Product_Component__c
                WHERE   Component_Code__c= :getComponentCode AND (component_expiration_date__c >= :System.today() OR component_expiration_date__c = null) and Default_Component_for_CA_Product__c=true   ORDER BY CREATEDDATE DESC
                limit 1
            ];        
        if (componentcode_list.size() != 1)
        {
         componentcode_list =  
            [
                SELECT  Id,Component_Code__c,Default_Component_for_CA_Product__c,CA_Product_Controller__c
                FROM    CA_Product_Component__c
                WHERE   Component_Code__c= :Label.Create_Case_Missing_CompCode_Defaulting_To_Scbug and Default_Component_for_CA_Product__c=true ORDER BY CREATEDDATE DESC
                limit 1
            ]; 
         scbugFlag = true; 
         productChangeToSCBug = true;//US301468   
        }
        
        return componentcode_list;
        
    }
    public static string getProductReleaseComponentReleaseByProductComponent(string getProductReleaseComponentReleaseByProductComponent_product, string getProductReleaseComponentReleaseByProductComponent_component)
    {
        Product_Release_Component_Release__c[] product_release_mapping = 
            [
                SELECT  Id 
                FROM    Product_Release_Component_Release__c 
                WHERE   Product_Release__c = :getProductReleaseComponentReleaseByProductComponent_product
                AND     Component_Code__c =:getProductReleaseComponentReleaseByProductComponent_component 
                ORDER BY Component_Release__r.CREATEDDATE DESC limit 1
            ];
        if (product_release_mapping.size() != 1)
        {
            return '-1';
        }
        else
        {
            return product_release_mapping[0].Id;
        }
    }
    
    
    public static string getOperatingSystem(string getOperatingSystem_OS)
    {
        Operating_System__c[] os_list = 
            [
                SELECT Id 
                FROM   Operating_System__c 
                WHERE  Name = :getOperatingSystem_OS 
                limit 1
            ];
        if (os_list.size() != 1)
        {
            return '-1';
        }
        else
        {
            return os_list[0].Id;
        }
    }
    public static string getProductReleaseandOperating_System(string caseRecordProduct_Operating_System_c, string caseRecordProduct_Operating_System_c_product_release)
    {
        Product_Release_and_Operating_System__c[] product_os_list =
            [
                SELECT  Id
                FROM    Product_Release_and_Operating_System__c
                WHERE   Operating_System__c = :caseRecordProduct_Operating_System_c
                AND     Product_Release__c  = :caseRecordProduct_Operating_System_c_product_release
                limit 1
            ];
        if (product_os_list.size() != 1)
        {
            return '-1';
        }
        else
        {
            return product_os_list[0].Id;
        }
    }
    public static string getProductServicePackByGenlevel(string getProductServicePackByGenlevel_Genlevel,string getProductServicePackByGenlevel_Product_Release)
    {
        Product_Service_Pack__c[] genlevel_list = 
            [
                SELECT Id 
                FROM   Product_Service_Pack__c 
                WHERE   Product_Service_Pack__c = :getProductServicePackByGenlevel_Genlevel 
                AND     Product_Release__c = :getProductServicePackByGenlevel_Product_Release
                limit 1
            ];
        if (genlevel_list.size() != 1)
        {
            return '-1';
        }
        else
        {
            
            return genlevel_list[0].Id;
        }
        
    }
    public static string getCaseDetailsById(string getCaseDetailsById_Id)
    {
        Case[] case_list =
            [
                SELECT  CaseNumber
                FROM    Case
                WHERE   Id = :getCaseDetailsById_Id
                limit 1
            ];
        if (case_list.size() != 1)
        {
            return '-1';
        }
        else
        {
            return case_list[0].CaseNumber;
        }
    }
    
    public static void writeLog(wrapperInput wi, wrapperResponse wr, string creationStatus)
    {
        CaseErrorLog__c case_log = new CaseErrorLog__c();
        case_log.InputRequest__c = wi.toString();
        case_log.ResponseMessage__c = wr.toString();
        case_log.Status__c = creationStatus;
        insert case_log;
        
    }
    
    public static void logComment(string genlevelComment, string caseIdComment)
    {
        CaseComment case_comment = new CaseComment();
        case_comment.CommentBody = genlevelComment;
        case_comment.ParentId = caseIdComment;
        if(!test.isRunningTest())
        insert case_comment;
        
    }
     //Added by Raja to log CSO release /product details selected as part of , swapped product component logging as per business requestUS94141 
    public static string csoComment(string topsrel,string servicepack,string product,string component)
    {
     
        string csoComment =  'Product Code:'+component+'\n'+
            'Product Release:'+topsrel+'\n'+
            'Service Pack:'+servicepack+'\n'+
            'Component Code:'+product;
        return csoComment;
        
    }
    //US94141 : End of US94141
    //Added by Aditya for Mobile Case Management
    public static list<CA_Product_Component__c> getComponentCodeforMobileCAProduct(string caPrdouctName)
    {
        //US289127--START
        Boolean defaultFlag=false;
        List<CA_Product_Component__c> componentcode_list;
        List<CA_Product_Component__c> listOfCAProductComp = [Select Id, Component_Code__c, Default_Component_for_this_CA_Product__c, CA_Product_Controller__c,CA_Product_Controller__r.Name From CA_Product_Component__c where CA_Product_Controller__r.Name =:caPrdouctName AND (component_expiration_date__c=:null OR component_expiration_date__c >=: System.today()) ORDER BY CREATEDDATE DESC];
        
        if(listOfCAProductComp<>null && listOfCAProductComp.size()>0){
            componentcode_list = new List<CA_Product_Component__c>();
            //Default component
            for(CA_Product_Component__c componentObj:listOfCAProductComp){
                if((componentObj.CA_Product_Controller__r.Name!=Label.Global_Service_Center || componentObj.CA_Product_Controller__r.Name==Label.Global_Service_Center) && componentObj.Default_Component_for_this_CA_Product__c){
                    defaultFlag=true;
                    componentcode_list.add(componentObj);
                    break;
                } 
            }
            if(!defaultFlag){
                //if default component doesn't exist then pass any component
                for(CA_Product_Component__c componentElseObj:listOfCAProductComp){
                    if((componentElseObj.CA_Product_Controller__r.Name!=Label.Global_Service_Center || componentElseObj.CA_Product_Controller__r.Name==Label.Global_Service_Center) && !componentElseObj.Default_Component_for_this_CA_Product__c){
                        componentcode_list.add(componentElseObj);
                        scbugFlag = true;
                        scDefaultFlag = false;
                        productChangeToSCBug = true; //US301468
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
                scDefaultFlag = true;
                productChangeToSCBug = true; //US301468
            } 
        }
            
        return componentcode_list;
        //US289127--END
        /*
        CA_Product_Component__c[] componentcode_list = null;
        List<CA_Product_Component__c> listOfCAProductComp = null;
        componentcode_list = [Select Id, Component_Code__c, Default_Component_for_this_CA_Product__c, CA_Product_Controller__c From CA_Product_Component__c where CA_Product_Controller__r.Name IN:listOfCAProductName AND Default_Component_for_this_CA_Product__c =:true AND component_expiration_date__c >=: System.today() limit 2];
        
        if(componentcode_list<>null && componentcode_list.size()>0){
            if(componentcode_list.size()==2){
                listOfCAProductComp = new List<CA_Product_Component__c>();
                for(CA_Product_Component__c compObj:componentcode_list){
                    if(String.isNotBlank(compObj.CA_Product_Controller__r.Name) && compObj.CA_Product_Controller__r.Name!=Label.Global_Service_Center){
                        listOfCAProductComp.add(compObj);
                    }
                }
            }else if(componentcode_list.size()==1){
                listOfCAProductComp = new List<CA_Product_Component__c>();
                for(CA_Product_Component__c compObjSCBUG:componentcode_list){
                    if(String.isNotBlank(compObjSCBUG.CA_Product_Controller__r.Name) && compObjSCBUG.CA_Product_Controller__r.Name==Label.Global_Service_Center){
                        listOfCAProductComp.add(compObjSCBUG);
                        scbugFlag = true;
                    }
                }
            }
        }
        return listOfCAProductComp;*/
        //US289127--END
        /*CA_Product_Component__c [] componentcode_list = 
            [
                SELECT  Id,Component_Code__c,Default_Component_for_CA_Product__c,CA_Product_Controller__c
                FROM    CA_Product_Component__c
                WHERE   CA_Product_Controller__r.Name= :caPrdouctName and Default_Component_for_CA_Product__c=true
                and component_expiration_date__c >=: System.today() //Added as part of Defect:                
                ORDER BY CREATEDDATE DESC
                limit 1
            ];        

        if (componentcode_list.size() != 1)
        {
            return null;
        }
        else
       {
            return componentcode_list;
        }*/
    }
      //US94141 :Remove the Traffic Cop, handle failures by always creating a case when only a Product & Component is Received
    public static String insertProductRelease(String getProductReleaseByMaterialandRelease_Material, 
                                              String getProductReleaseByMaterialandRelease_Release){
                                                      
                                                String productReleaseLog = null; 
                                                String Id = null;      
                                                    try{  Product_Release__c productRelease = new Product_Release__c();
                                                          
                                                          productRelease.Product_Material__c = getProductReleaseByMaterialandRelease_Material;
                                                          productRelease.Product_Release__c = getProductReleaseByMaterialandRelease_Release;
                                                        
                                                          
                                                          insert productRelease;
                                                          
                                                          productReleaseLog = ' Product Release pack  created with id: '+ productRelease.Id;
                                                          Id = productRelease.Id;
                                                         }
                                                      
                                                      catch(DmlException e){
                                                          productReleaseLog = 'Product Service Pack object insert failed: ';
                                                          
                                                      }
                                                      
                                                      
                                                      return Id;
                                                      
                                                  }
    //US94141 : End of US94141

    // Function to insert the unidentified product_service_pack. kumga08 CR:400-1186
    public static String insertProductServicePack(String genlevelProductServicePack, String genlevelProductRelease, String genlevelName,
                                                  String genlevelExtId){
                                                      
                                                      String prodServicePackLog=null; 
                                                      
                                                      try{  Product_Service_Pack__c prodServicePack = new Product_Service_Pack__c();
                                                          
                                                          prodServicePack.Name = genlevelName;
                                                          prodServicePack.Product_Release__c = genlevelProductRelease;
                                                          prodServicePack.Product_Service_Pack__c = genlevelProductServicePack;
                                                          prodServicePack.Product_Service_Pack_Ext_ID__c = genlevelExtId;
                                                          
                                                          insert prodServicePack;
                                                          
                                                          prodServicePackLog = ' Product service pack automatically created with id: '+ prodServicePack.Id;
                                                          
                                                         }
                                                      
                                                      catch(DmlException e){
                                                          prodServicePackLog = 'Product Service Pack object insert failed: ';
                                                          
                                                      }
                                                      
                                                      
                                                      return prodServicePackLog;
                                                      
                                                  }
    // End of the function to insert the unidentified product_service_pack.
    
    
    //Start of function to correct contact data in service cloud. CR:400-1270
    
    
    public static String correctContactData(string getContactIdbyConnectId_ConnectId,
                                            String emailId,String fname,String lname,String phoneNumber,
                                            String siteId)
    {
        
        String conid;
        
        List<Contact> con_list = new List<Contact>();
        con_list = [select id from contact where email =: emailId limit 5];
        
        
        
        
        if(con_list.size()==0){
            
            conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
            
        }
        
        else if(con_list.size()==1){
            
            conid =  updateContact(con_list,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
            
            
        }
        
        else if(con_list.size()>1){
            con_list.clear();
            con_list = [select id from contact where email =:emailId
                        and firstName =:fname and lastName =:lname];
            
            
            if(con_list.size()==0){
                
                conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
                
            }
            
            
            else if(con_list.size()==1){
                
                conid =  updateContact(con_list,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
                
                
            }
            
            else if(con_list.size()>1){
                con_list.clear();
                con_list = [select id from contact where email =:emailId
                            and firstName =:fname and lastName =:lname
                            and Phone =:phoneNumber];
                
                if(con_list.size()!=1){
                    
                    conId = insertContact( getContactIdbyConnectId_ConnectId, emailId, fname, lname, phoneNumber, siteId);
                    
                }
                
                else{
                    
                    conid =  updateContact(con_list,getContactIdbyConnectId_ConnectId,fname,phoneNumber);
                    
                    
                }
                
            }
            
        }
        
        
        return conid;
        
    }
    
    // End of function to correct contact data in service cloud. CR:400-1270
    
    //Start of function to insert contact on the fly. CR:400-1270
    
    public static String insertContact(string getContactIdbyConnectId_ConnectId,
                                       String emailId,String fname,String lname,String phoneNumber,
                                       String siteId)
    {
        String insertedConId;
        List<Site_Association__c> siteassociation =   new List<Site_Association__c>(
            [select Enterprise_ID__c from Site_Association__c 
             where SC_TOPS_ID__c =:siteId 
             limit 1]);    
        
        
        Id accId;
        if(!test.isRunningTest())
          accId = siteassociation.get(0).Enterprise_ID__c;
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
    
    
    // End of function to insert contact on the fly. CR:400-1270
    
    // Start of function to update contact. CR:400-1270
    public static string updateContact(List<Contact> con,
                                       String getContactIdbyConnectId_ConnectId,String fname, 
                                       String phoneNumber)
    {     
        String updatedConId;
        try{ 
            
            con.get(0).SC_CONTACT_LDAPID__c = getContactIdbyConnectId_ConnectId;
            
            If(String.isBlank(con.get(0).firstName))
            {con.get(0).firstName = fname;}
            
            if(String.isBlank(con.get(0).phone))
            {con.get(0).phone = phoneNumber;}
            
            update con.get(0);
            updatedConId = con.get(0).id;
        }    
        
        catch(DMLException e){
            updatedConId = null;
        }
        
        
        return updatedConId;   
        
    }
    
    // End of function to update contact. CR:400-1270
    
    //Start of function to find user contact record for email to case by pmf Key. CR:400-1600.
    
    public static String getUserContactRecord(String userPMFKey){
        
        List<Contact> conList = [select id from contact where SC_CONTACT_LDAPID__c =:userPMFKey limit 1];
        
        if(conList.size()!=1){
            String missingContactRecordId = Label.Email_to_case_missing_contact;
            
            return missingContactRecordId; 
        }
        
        else{
            return conList.get(0).id;
        }
    }
    
    
    //End of function. 
    
    public static String drop_leading_zeros(String passedValue) {
        String return_string = null; //return string for passing back
        if (passedValue != null) { //if the passed value is not null
            return_string = passedValue.trim(); //trim the whitespace from the start and end of the value
            Pattern valid_characters = Pattern.compile('([0-9]+)'); //only numbers
            Matcher check_chars = valid_characters.matcher(return_string); //compare the string to the set of valid characters
            if (check_chars.matches()) { //if we have a somewhat valid number
                if (return_string.startsWith('0') && return_string.length() > 6) { //if the string begins with a 0 and the length is greater than 1
                    boolean keepChecking = true; //create a boolean variable
                    while (keepChecking) { //if boolean is true
                        if (return_string.startsWith('0') && return_string.length() > 6) { //if the string begins with 0 and there is more than 1 character
                            return_string = return_string.substring(1); //drop the first character
                        } else { //either the string doesn't begin with 0 or the length is less than or equal to 1
                            keepChecking = false; //stop the loop
                        }
                    }
                }
                if (return_string == '0') { //if the resulting string is now a single '0'
                    return_string = null; //set the string to null
                }
            } else { //otherwise the value passed was not valid
                return_string = null; //set the string to null
            }
        }
        return return_string; //pass back a value
    }
    
    public static string retrieveLanguage(string retrieveLanguage_code)
    {
        string languageName;
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
}