global without sharing class CC_ngTurkeyController {

  /* PUBLIC PROPERTIES */
  
  public static User currentUser {
    get {
      if (currentUser == null) {
        Id currentUserId = UserInfo.getUserId();
        currentUser = [SELECT Id, FirstName, LastName, TimeZoneSidKey, LDAP_Date_Format__c,LDAP_Basic_Impl_Open_Case__c, LDAP_Time_Format__c, LDAP_Roles__c, Contact.Id, Contact.SC_CONTACT_LDAPID__c, Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,Contact.Phone,Contact.Email,Contact.AccountId, Contact.Account.Name FROM User WHERE ID = :currentUserId];
      }
      return currentUser;
    }
    set;
  }

  public static boolean isPartnerUser {
      get{
          if(isPartnerUser == null){
              String  uType = UserInfo.getUserType();
              if( uType.equalsIgnoreCase('PowerPartner')) { return true;} else { return false;}
          }
          return false;
      }
      set;
  }

  // Used to pass context data to angular
  public static String userContext {
    get {
      return JSON.serialize(new Map<String, Object>{
        'userId' => currentUser.Id,
        'firstName' => currentUser.FirstName,
        'lastName' => currentUser.LastName,
        'contactId' => currentUser.Contact.Id,
        'defaultSiteId' => currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,
        'connectId' => currentUser.Contact.SC_CONTACT_LDAPID__c,
        'dateTimeFormat' => userDateTimeFormat,
        'timezoneOffsetInMillis' => userTimezoneOffsetInMillis,
        'phoneNumber' => currentUser.Contact.Phone,
        'canOpenCase' => canOpenCase,
        'canAccessSolutions' => canAccessSolutions,
        'canViewPrivate' => canViewPrivate,
        'isCAInternalSG' => isCAInternalSG ,
        'activityFlagDate' => activityFlagDate  
      });
    }
  }
  public static String invocationPath; //To capture the invocation path to trace error
  public static List<CC_Error_Log__c> ccErrorLogListToInsert = new List<CC_Error_Log__c>();
    
  public static Boolean debugEnabled {
    get { return CC_Settings.debugEnabled; }
  }

  public static String pendingCaseNumber{
      get {

            if(CC_ngTurkeyController.isPartnerUser && String.isNotBlank(currentUser.Contact.SC_CONTACT_LDAPID__c )){
                List<Case> caseList = [select id from Case where Contact.Email =:(currentUser.Contact.Email) AND  Next_Action__c =:System.label.Pending_Customer AND Case_Type__c!=:'Chat' AND Case_Type__c!=:System.Label.ProactiveCaseType];
                System.debug('PendingCases - ' + caseList.size());return ''+caseList.size();
            } else if(String.isNotBlank(currentUser.Contact.SC_CONTACT_LDAPID__c)){
                List<Case> caseList = [select id from Case where Contact.SC_CONTACT_LDAPID__c =:(currentUser.Contact.SC_CONTACT_LDAPID__c) AND  Next_Action__c =:System.label.Pending_Customer AND Case_Type__c!=:'Chat' AND Case_Type__c!=:System.Label.ProactiveCaseType];
                System.debug('PendingCases - ' + caseList.size());return ''+caseList.size();}else{return '0';}}
  }

  public static String userLDAPID{
      get {return currentUser.Contact.SC_CONTACT_LDAPID__c;}
  }

  public static String userFirstName{
      get {return currentUser.FirstName;}
  }

  public static String csoBaseUrl {
    get { return CC_Settings.csoUrl; }
  }

  public static String careURL {
    get { return CC_Settings.careUrl; }
  }
  public static String showSolURL {
    get { return CC_Settings.csoShowSolutionURL; }
  }
  public static String globalScapeURL {
    get { return CC_Settings.globalScapeUrl; }
  }
    
    public static String cftpUrl {
        get { return CC_Settings.cftp_url; }
    }
    
    public static String cftpEnabled {
        get { return CC_Settings.cftp_Enabled; }
    }
    
    public static String gsEnabled {
        get { return CC_Settings.gs_Enabled; }
    }    
    
    
  /* PRIVATE PROPERTIES */

 private static DateTime activityFlagDate {
        get{
            String s = CC_Settings.activityFlagDate;
            return DateTime.valueOf(s);
        }
  }
    
  private static Integer userTimezoneOffsetInMillis {
    get {
        TimeZone tz = UserInfo.getTimeZone();
        Date newDate = Date.today();
        Time newTime = Time.newInstance(0, 0, 0, 0);
        return tz.getOffset(Datetime.newInstanceGmt(newDate, newTime));
    }
  }

  private static String userDateTimeFormat {
    get {
      String dateFormat = currentUser.LDAP_Date_Format__c;
      String timeFormat = currentUser.LDAP_Time_Format__c;
      if (dateFormat != null && timeFormat != null) {
        return dateFormat + ' ' + timeFormat;
      }
      return '';
    }
  }
  
  @TestVisible
  public static boolean  isCAInternalSG {
      get {            
            String securityGrpName = determineSecurityGroup();
            if(securityGrpName.containsIgnoreCase('CA Internal User')){ return true; }  
             return false;          
        }
      set;
  }
    
    //Tensor
    @TestVisible
    public static boolean  hasSaasUserRole {
        get {    
            String userRoles = currentUser.LDAP_Roles__c;
            if( userRoles!=null && userRoles.contains(System.Label.CA_Saas_User) ){return true;}
            return false;                 
        }
        set;
    }
    
      //fetch help text
    @TestVisible
    public static String fetchHelpTextLinks{
        get{
            List<CC_Help_Text__mdt> helptext = CC_Settings.getHelpText;
            log.debug(helptext);
            return JSON.serialize(helptext);
        }    
        set;
    }


  // Service class for all things SF related
  @TestVisible
  private static CC_ngTurkeyService.I turkeySvc {
    get {
      if (turkeySvc == null) { turkeySvc = new CC_ngTurkeyService(currentUser.Contact.Id, canSearchAcrossSites, canViewPrivate,currentUser.Contact.SC_CONTACT_LDAPID__c); }
      return turkeySvc;
    }
    set;
  }
  
    @TestVisible
    public static String cnValues{
        get{
            if(cnValues == null)
            {
                CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
                cnValues = ldapRoles.reverseTranslateString(currentUser.LDAP_Roles__c);
            }
            return cnValues;
        }
        set;
    }  


  @TestVisible
  public static boolean isProd{
      get{
          if(isProd == null){
            if(UserInfo.getOrganizationId().contains('00D300000006yn4')) { return true; }
            else { return false; }
          }   return false;
        }
        set;
   }
   
  @TestVisible
  public static boolean isQA{
      get{
          if(isQA == null){
            if(UserInfo.getOrganizationId().contains('00D300000006yn4'))   {   return false;  }
            else {  return true; }
          }  return false;
        }
        set;
   }   
  

  @TestVisible
  public static boolean canOpenCase{
    get {
        if(canOpenCase == null)
        {
            List<CC_Security_Groups_Config__c> securityGroups = CC_Settings.securityGroups;
            String securityGrpName = determineSecurityGroup();
            for(CC_Security_Groups_Config__c tmpGroup : securityGroups)
            {
                 //if role is Basic Implementation Engineer and having business category checked then allow access to open case
                log.debug('tmpGroup.Name='+tmpGroup.Name+',currentUser.LDAP_Basic_Impl_Open_Case__c'+currentUser.LDAP_Basic_Impl_Open_Case__c);
                if (tmpGroup.Name == 'Basic Implementation Engineer' && currentUser.LDAP_Basic_Impl_Open_Case__c=='case')   return true;
                if(tmpGroup.Name!= null && tmpGroup.Name==securityGrpName) { return tmpGroup.Can_Open_Case__c; }
            }
        }
        return false;
    }
    set;
  }
  
  @TestVisible
  public static boolean canAccessSolutions{
    get {
        if(canAccessSolutions == null)
        {
            List<CC_Security_Groups_Config__c> securityGroups = CC_Settings.securityGroups;
            String securityGrpName = determineSecurityGroup();
            for(CC_Security_Groups_Config__c tmpGroup : securityGroups) {
                if(tmpGroup.Name!= null && tmpGroup.Name==securityGrpName) { return tmpGroup.Access_Solutions__c; }
            }
        }
        return false;
    }
    set;
  }  

  @TestVisible
  public static boolean canSearchAcrossSites{
    get {
        if(canSearchAcrossSites== null) {
            List<CC_Security_Groups_Config__c> securityGroups = CC_Settings.securityGroups;
            String securityGrpName = determineSecurityGroup();
            for(CC_Security_Groups_Config__c tmpGroup : securityGroups) {
                if(tmpGroup.Name!= null && tmpGroup.Name==securityGrpName) {
                    return tmpGroup.Access_Cases_of_All_Sites__c;
                }
            }
        }
        return false;
    }
    set;
  }  
  
  @TestVisible
  public static boolean canViewPrivate{
    get {
        if(canViewPrivate== null)
        {
            List<CC_Security_Groups_Config__c> securityGroups = CC_Settings.securityGroups;
            String securityGrpName = determineSecurityGroup();
            for(CC_Security_Groups_Config__c tmpGroup : securityGroups) {
                if(tmpGroup.Name!= null && tmpGroup.Name==securityGrpName) {
                    return tmpGroup.View_Private_Comments__c;
                }
            }
        }
        return false;
    }
    set;
  }
    
  @TestVisible
  public static Set<Id> entitledSitesofUser {
      get {
        if(entitledSitesofUser == null){  return turkeySvc.fetchEntitledSitesofUser(currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c, currentUser.Contact.SC_CONTACT_LDAPID__c);    }
        return entitledSitesofUser;
      }      
      set;
  }

  // Service class for search.ca.com callouts
  @TestVisible
  private static CC_SearchItService.I searchItSvc {
    get {
      if (searchItSvc == null) { searchItSvc = new CC_SearchItService();    }  
      return searchItSvc;
    } set;
  }

  /* PUBLIC WEB SERVICES */

  // Fetch Sites and Products from API Gateway and transform into SF Site_Assocaitions and Product_Controllers
  @RemoteAction
  global static List<Object> fetchSitesAndProducts() {
    log.debug(currentUser);
    invocationPath = invocationPath + '=CC_ngTurkeyController.fetchSitesAndProducts' ;
    try{
        String siteId = currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c;
        String connectId = currentUser.Contact.SC_CONTACT_LDAPID__c;
        CC_ngTurkeyService.SiteProductAssociation[] spas = turkeySvc.fetchSitesAndProducts(siteId, connectId);    
        String accountName = currentUser.Contact.Account.Name ;
        Id accountId = currentUser.Contact.AccountId;
        if(hasSaasUserRole && accountName.startsWithIgnoreCase('Generic Support Account') || accountId == CC_Settings.communityUserDefaultAccountId ){
            System.debug('Will Invoke future call checkAndUpdateAccountOnContact');
            CC_Layer7Service.updateAccountOnContact(currentUser.contactId, CC_ngTurkeyController.currentUser.Contact.Email);
        }
        //spas.add()
        log.debug(spas);
        if( CC_ngTurkeyController.ccErrorLogListToInsert!=null && CC_ngTurkeyController.ccErrorLogListToInsert.size() >0 ){
              insert CC_ngTurkeyController.ccErrorLogListToInsert;
        }
        return (List<Object>)spas;
    }
    catch(Exception e){ CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath , true); return null;}
  }
    
  @RemoteAction
  global static List<Object> fetchSites() {
      invocationPath = invocationPath + '=CC_ngTurkeyController.fetchSites' ;
      List<Object> sitesObjList = turkeySvc.fetchSites(currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c, currentUser.Contact.SC_CONTACT_LDAPID__c);     
      return sitesObjList;
  }

  //Find if a product name is supported by RE
  @RemoteAction
  global static boolean getIsRECapabale(String prodName)
  {
      System.debug('Inside getIsRECapable : '+prodName);
      invocationPath = invocationPath + '=CC_ngTurkeyController.getIsRECapabale' ;  
      try
      {
          boolean isRECapabale= turkeySvc.getIsRECapabale(prodName);
          System.debug('isRECapabale : '+isRECapabale);
          return isRECapabale;
      }
      catch(Exception ex)
      {
          insertCCErrorLog('prodName:\n'+prodName+ '\n Error Message: \n'+ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath); throw buildCommunityException(ex);
      }      
  }
  
  //Find if a product name has ProductAreas defined under it
  /*@RemoteAction
  global static List<Object> getProductAreas(String prodName)
  {
      System.debug('Inside getProductAreas : '+prodName);
      invocationPath = invocationPath + '=CC_ngTurkeyController.getProductAreas' ;  
      try
      {
          return turkeySvc.getProductAreas(prodName);
      }
      catch(Exception ex)
      {
          insertCCErrorLog('prodName:\n'+prodName+ '\n Error Message: \n'+ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath);
          return null;
      }      
  } */

    //Call L7 Globalscape service
    @RemoteAction
    global static String invokeL7GSService(String siteid,String caseNumber){
        System.debug('siteid:'+siteid + 'caseNumber:'+caseNumber);
        invocationPath = invocationPath + '=CC_ngTurkeyController.invokeL7GSService' ;
        return (turkeySvc.invokeL7GSService (siteId, caseNumber));
    } 
    
    //*** PA Changes
    //US249096 - Remeber Recent CA Product
  @RemoteAction
  global static Object fetchRecentProductArea(List<Id> productIdList){
      System.debug('productIdList:'+productIdList);
      invocationPath = invocationPath + '=CC_ngTurkeyController.fetchRecentProductArea' ;
      try
      {
          Product_Area__c productRecentlyUsed = turkeySvc.fetchRecentProductArea(productIdList);
          //CC_ngTurkeyService.CA_Product_Controller__c productRecentlyUsed = turkeySvc.fetchRecentProduct(productIdList);
          System.debug('productRecentlyUsed:'+productRecentlyUsed);
          return (Object)productRecentlyUsed; 
      }
      catch(Exception ex) {CC_ngTurkeyController.prepareErrorLogRecord('productIdList:\n'+productIdList + '\n Error Message: \n'+ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  } 

  @RemoteAction
  global static Object fetchRecentproductAreaWithSite(List<Id> productIdList)
  {
      System.debug('productIdList:'+productIdList);
      invocationPath = invocationPath + '=CC_ngTurkeyController.fetchRecentProductAreaWithSite' ;
      try{
            Object recentlyUsedProdAndSite = turkeySvc.fetchRecentProductAreaWithSite(productIdList);
            System.debug('-------recentlyUsedProdAndSite----------:'+recentlyUsedProdAndSite);
            return recentlyUsedProdAndSite; 
      }
      catch(Exception ex) {CC_ngTurkeyController.prepareErrorLogRecord('productIdList:\n'+productIdList + '\n Error Message: \n'+ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
   }
  

  // Fetch cases owned by the current user. This method returns max 5000 cases.
  @RemoteAction
  global static Case[] fetchAllMyCases() {
      return fetchMyCases(true);
  }

  // Fetch cases owned by the current user. This method returns only 200 cases.
  @RemoteAction
  global static Case[] fetchMyCases() {  return fetchMyCases(false); }
  
  global static Case[] fetchMyCases(boolean allCases) {
      invocationPath = invocationPath + '=CC_ngTurkeyController.fetchMyCases('+allCases+')' ;
      try
      {
        Case[] foundCases = turkeySvc.fetchMyCases(allCases);
        log.debug(foundCases);
        return foundCases;
      }
      catch(Exception e){CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
  }

  //US209609- Live chat
  @RemoteAction
  global static String fetchLiveChatDetails(String productName){
      invocationPath = invocationPath + '=CC_ngTurkeyController.fetchLiveChatDetails' ;
      try
      {
        if(String.isNotBlank(productName)){
            List<CA_Product_Controller__c> productControllerObj = [Select Product_Button__r.Button_Id__c from CA_Product_Controller__c where Product_Button__c<>null AND Name =:productName limit 1];
            if(productControllerObj<>null && productControllerObj.size()>0 && String.isNotBlank(productControllerObj[0].Product_Button__r.Button_Id__c)){
                return String.valueOf(productControllerObj[0].Product_Button__r.Button_Id__c).subString(0,15);
            }
          }
      }
      catch(Exception e) {CC_ngTurkeyController.prepareErrorLogRecord('productName:\n' + productName + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
      return null;
  }
  
  @RemoteAction
  global static LiveAgentDeployment__c fetchLiveChatDeploymentScriptDetails(){
      List<LiveAgentDeployment__c> lADeploymentDetails = LiveAgentDeployment__c.getall().values();
      if(lADeploymentDetails!=null && lADeploymentDetails.size()>0){
          return lADeploymentDetails[0];
      }else{
          return null;
      }
  }
    
  /* Fetch cases by search criteria, limited to current user's entitled sites
      Params:
        caseNumber (String)
        title (String)
        contactEmail (String)
        status (String)
        severity (String)
        product (ID) - CA_Product_Controller ID
        createdDateFrom (Timestamp)
        createdDateTo (Timestamp)
        lastModifiedDateFrom (Timestamp)
        lastModifiedDateTo (Timestamp)
  */
  @RemoteAction
  global static Case[] fetchAllCasesByCriteria(Map<String, Object> searchParams) {
      return fetchCasesByCriteria(searchParams, true);
  }

  @RemoteAction
  global static Case[] fetchCasesByCriteria(Map<String, Object> searchParams) {
      return fetchCasesByCriteria(searchParams, false);
  }  
  
  global static Case[] fetchCasesByCriteria(Map<String, Object> searchParams, boolean allCases) {
    System.debug('***searchParams:'+searchParams);
    invocationPath = invocationPath + '=CC_ngTurkeyController.fetchCasesByCriteria('+allCases+')' ;
    try
    {    
        CC_ngTurkeyService.CaseSearchCriteria criteria = dataToSearchCriteria(searchParams);
        CC_ngTurkeyController.entitledSitesofUser = turkeySvc.fetchEntitledSitesofUser(currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c, currentUser.Contact.SC_CONTACT_LDAPID__c);
        Case[] foundCases = turkeySvc.fetchCasesByCriteria(criteria, allCases);
        log.debug(foundCases);
        if(CC_ngTurkeyController.ccErrorLogListToInsert !=null && CC_ngTurkeyController.ccErrorLogListToInsert.size()>0){
          insert CC_ngTurkeyController.ccErrorLogListToInsert;
        }
        return foundCases;
    }
    catch(Exception e){CC_ngTurkeyController.prepareErrorLogRecord('Search Params:\n' + searchParams + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
  }

// Fetch a single case for the case details page with case number instead of case ID
  @RemoteAction
  global static Map<String, Object> fetchCaseByNumber(String caseNo) {
    log.debug(caseNo);
    invocationPath = invocationPath + '=CC_ngTurkeyController.fetchCaseByNumber' ;
    try
    {        
        Map<String, Object> jsonCase;
        List<Case> caseId;
        try{
        caseId=[SELECT ID from case where CaseNumber=:caseNo LIMIT 1 ];
          
        
        }catch(Exception e){
          return jsonCase;
        }
        if (caseId == NULL || caseId.size() ==0)
          return jsonCase;
        ID vcaseid  =caseId[0].ID;
        jsonCase = fetchCase(vcaseid);
        return jsonCase;
    }
    catch(Exception e)
    {
        insertCCErrorLog('Case No:\n' + caseNo + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath);
        throw buildCommunityException(e);    
    }
  }
  // Fetch a single case for the case details page
  @RemoteAction
  global static Map<String, Object> fetchCase(Id caseId) {
    log.debug(caseId);
    invocationPath = invocationPath + '=CC_ngTurkeyController.fetchCase' ;
    try
    {
        Case myCase = turkeySvc.fetchCaseById(caseId);
        String activitiesString = turkeySvc.fetchCaseActivitiesById(caseId);
        Map<Id, User> caTechnicians = new Map<Id, User>(turkeySvc.fetchCaTechniciansForCases(new Case[]{myCase}));
        Map<String, Object> jsonCase = toCaseJson(myCase,activitiesString);
        User caTech = caTechnicians.get(myCase.OwnerId);
        jsonCase.put('Owner', toJson(caTech)); 
       //List<CaseArticle> caseArticlesList = CC_FetchCaseArticles.fetchArticles(caseId);
        List<Knowledge__kav> caseArticlesList = CC_FetchCaseArticles.fetchArticles(caseId);
        jsonCase.put('Articles2', caseArticlesList );
       //get solutions
        /*
        String awstoken=CC_Layer7Service.getAWSToken();
        List <External_RnD__c> listrndt=myCase.external_RnDs__r;
        list<JSON2Solution> jsonSolResp=new List<JSON2Solution>();
        if(listrndt!=null){
            for(External_RnD__c ex_rnd:listrndt){
                String sol=CC_Layer7Service.getSolution(awstoken,ex_rnd.Component_ID__c,ex_rnd.Component_Release__c,ex_rnd.Reference_ID__c,ex_rnd.Solution_Type__c);
                jsonSolResp.add(JSON2Solution.parse(sol));
            }
        }
        jsonCase.put('Solutions', jsonSolResp); 
        */
        
                
        if(CC_ngTurkeyController.ccErrorLogListToInsert !=null && CC_ngTurkeyController.ccErrorLogListToInsert.size()>0){
          insert CC_ngTurkeyController.ccErrorLogListToInsert;
        }
        
        // side effect! create a portal view record whenever we fetch a case by id.
        Datetime viewDate = Datetime.now();
        //registerPortalView(myCase.Id, viewDate);
        //US319193
        registerPortalView(myCase.Id, currentUser.contact.Id,  currentUser.Contact.SC_CONTACT_LDAPID__c, viewDate);
        
        log.debug(jsonCase);
        
        return jsonCase;
    }
    catch(Exception e) {CC_ngTurkeyController.prepareErrorLogRecord('Case Id:\n' + caseId + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
  }
    //Get only solutions
  @RemoteAction
  global static  list<JSON2Solution> fetchSolutions(String caseNumber){
    log.debug(caseNumber);
    invocationPath = invocationPath + '=CC_ngTurkeyController.fetchSolutions' ;
    //try{
        String awstoken=CC_Layer7Service.getAWSToken(),query;
        list<JSON2Solution> jsonSolResp=new List<JSON2Solution>();
        List<Case> caseId;
        try{
            if(caseNumber.startswith('500')) { query='ID'; }
            else {  query='CaseNumber'; }  
            caseId=Database.query('SELECT ID from case where ' + query +' =:caseNumber LIMIT 1');
            log.debug('caseId='+caseId);
        }catch(Exception e){    return jsonSolResp;     }
        ID vcaseid  =caseId[0].ID;
        Case myCase = turkeySvc.fetchCaseById(vcaseid);
        List <External_RnD__c> listrndt=myCase.external_RnDs__r;
        if (caseId == NULL || caseId.size() ==0)
          return jsonSolResp;
        if(listrndt!=null){
            for(External_RnD__c ex_rnd:listrndt){
                if (String.isNotBlank(ex_rnd.Component_ID__c)   && String.isNotBlank(ex_rnd.Component_Release__c)  && String.isNotBlank( ex_rnd.Reference_ID__c)){
                  String sol=CC_Layer7Service.getSolution(awstoken,ex_rnd.Component_ID__c,ex_rnd.Component_Release__c,ex_rnd.Reference_ID__c,ex_rnd.Solution_Type__c);
                  jsonSolResp.add(JSON2Solution.parse(sol));
                }
            }
        }
        System.debug('jsonSolResp:'+jsonSolResp);
        return jsonSolResp;
      //  }
      //catch(Exception e) {CC_ngTurkeyController.prepareErrorLogRecord('Case Id:\n' + caseId + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
  }
  // Find related support content to display on the create case page
  @RemoteAction
  global static CC_SearchItService.SearchItResults findSupportArticles(Map<String, String> data) {
    invocationPath = invocationPath + '=CC_ngTurkeyController.findSupportArticles' ;  
    try
    {
        String title = data.get('title');
        Id productId = data.get('productId');
        return searchItSvc.doSearch(title, productId);
    }
    catch(Exception e) {CC_ngTurkeyController.prepareErrorLogRecord('Data:\n' + data + '\nError Message:\n' + e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , invocationPath, true);throw e;}
  }

  /* Create a new case for the current user
      Params:
        businessImpact (String)
        description (String, required)
        severity (String, required)
        title (String, required)
        siteId (ID, required) - CA_Product_Controller ID
        productId (ID, required) - Site_Association ID
        productName (String, required) - used to create comment
        release (String) - used to create comment
        servicePack (String) - used to create comment
        operatingSystem (String) - used to create comment
  */
  @RemoteAction
  global static Id createCase(Map<String, Object> caseData) {
    invocationPath = invocationPath + '=CC_ngTurkeyController.createCase';
    log.debug(caseData);
      Case cleanCase = dataToCase(caseData);
      if(CC_ngTurkeyController.hasSaasUserRole && turkeySvc.hasAccesstoThisSiteandProductFromEER( currentUser.Contact.SC_CONTACT_LDAPID__c,null,cleanCase.Site_Association__c) ){
              CC_ngTurkeyService.checkSiteValidation=false;
          }
      
    CC_ngTurkeyController.entitledSitesofUser = turkeySvc.fetchEntitledSitesofUser(currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c, currentUser.Contact.SC_CONTACT_LDAPID__c);
    Savepoint sp = Database.setSavepoint();
    Long startTime = System.now().getTime();
    try {
      //Case cleanCase = dataToCase(caseData);
      Case newCase = turkeySvc.createCase(cleanCase);
      CaseComment newCaseComment = buildNewCaseComment(caseData, newCase.Id);
      log.debug('newCase.Site_association__c='+newCase.Site_association__c);  
      if(newCase.Site_association__c==CC_Settings.defaultSiteIDforNoAccess)
        CC_ngTurkeyService.checkSiteValidation=false;
      turkeySvc.addCaseComment(newCaseComment);
      log.debug(newCase);
      Long endTime = System.now().getTime();
      System.debug('Time taken in milliseconds:'+ (endTime - startTime));
       if(!Test.isRunningTest())
            insertCCErrorLog( 'Time taken for Case creation (in milliseconds) :' + (endTime - startTime) , invocationPath);
      if(CC_ngTurkeyController.ccErrorLogListToInsert !=null && CC_ngTurkeyController.ccErrorLogListToInsert.size()>0){
        insert CC_ngTurkeyController.ccErrorLogListToInsert;
      }
      return newCase.Id;
    }
    catch (Exception ex) {Database.rollback(sp);CC_ngTurkeyController.prepareErrorLogRecord('Case Data:\n'+ caseData + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }

  @RemoteAction
  global static String createCaseConcern(Map<String, Object> caseData) {
    invocationPath = invocationPath + '=CC_ngTurkeyController.createCaseConcern';
    log.debug(caseData);
     Case cleanCase = dataToCase(caseData);
     System.debug('cleanCase:'+ cleanCase);
      if(CC_ngTurkeyController.hasSaasUserRole && turkeySvc.hasAccesstoThisSiteandProductFromEER( currentUser.Contact.SC_CONTACT_LDAPID__c,null,cleanCase.Site_Association__c) ){
              CC_ngTurkeyService.checkSiteValidation=false;
          }
      
    CC_ngTurkeyController.entitledSitesofUser = turkeySvc.fetchEntitledSitesofUser(currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c, currentUser.Contact.SC_CONTACT_LDAPID__c);
    Savepoint sp = Database.setSavepoint();
   // Long startTime = System.now().getTime();
    try {
      //Case cleanCase = dataToCase(caseData);
      Case newCase = turkeySvc.createCaseConcern(cleanCase);
    /*  CaseComment newCaseComment = buildNewCaseComment(caseData, newCase.Id);
      log.debug('newCase.Site_association__c='+newCase.Site_association__c);  
      if(newCase.Site_association__c==CC_Settings.defaultSiteIDforNoAccess)
        CC_ngTurkeyService.checkSiteValidation=false;
      turkeySvc.addCaseComment(newCaseComment);
      log.debug(newCase);*/
      Long endTime = System.now().getTime();
     /* System.debug('Time taken in milliseconds:'+ (endTime - startTime));
       if(!Test.isRunningTest())
            insertCCErrorLog( 'Time taken for Case creation (in milliseconds) :' + (endTime - startTime) , invocationPath);*/
      if(CC_ngTurkeyController.ccErrorLogListToInsert !=null && CC_ngTurkeyController.ccErrorLogListToInsert.size()>0){
        insert CC_ngTurkeyController.ccErrorLogListToInsert;
      }
      List<Case> createdCase = [select id,caseNumber from Case where id = :newCase.Id  limit 1];
      if( createdCase != null &&  createdCase.size() >0 ){
        String caseCommentBody = 'Case Concern '+createdCase[0].CaseNumber +' has been created for this case by '+ userinfo.getName();  
        //CC_Layer7Service.InsertPrivateComments(createdCase[0].ID,caseCommentBody);
        return createdCase[0].caseNumber;
      }
      return null;
    }
    catch (Exception ex) {Database.rollback(sp);CC_ngTurkeyController.prepareErrorLogRecord('Case Data:\n'+ caseData + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }


  /* Create comment on specified case
      Params:
        caseId (ID, required) - SF ID of case
        comment (String, required) - Text for comment
  */
   @RemoteAction
  global static CaseCommentType createCaseComment(Map<String, String> data) {
    log.debug(data);
    invocationPath = invocationPath + '=CC_ngTurkeyController.createCaseComment' ;    
    try
    {
        CaseComment comment = new CaseComment(
          ParentId = data.get('caseId'),
          CommentBody = data.get('comment')
          ,isPublished =  Boolean.valueOf(data.get('isInternal'))
        );
        return turkeySvc.addCaseComment(comment);
    }
    catch (Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }


  /* Request case close for specified case
      Params:
        caseId (ID, required) - SF ID of case
        comment (String, required) - Text for comment
  */
  @RemoteAction
  global static void closeCase(Map<String, String> data) {
    log.debug(data);
    invocationPath = invocationPath + '=CC_ngTurkeyController.closeCase' ;        
    try
    {
        Id caseId = data.get('caseId');
        String commentBody = data.get('comment');
        turkeySvc.closeCase(caseId, commentBody);
    }
    catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }

  /* Change severity for specified case
      Params:
        caseId (ID, required) - SF ID of case
        severity (String, required) - new severity for this case (i.e. 2,3,4)
        comment (String, required) - Text for comment
  */
  @RemoteAction
  global static void changeSeverity(Map<String, String> data) {
    log.debug(data);
    invocationPath = invocationPath + '=CC_ngTurkeyController.changeSeverity' ;
    try
    {            
        Id caseId = data.get('caseId');
        String newSeverity = data.get('newSeverity');
        String commentBody = data.get('comment');
        turkeySvc.changeSeverity(caseId, newSeverity, commentBody);
    }
    catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }

  /* Request reopen of previously closed case
      Params:
        caseId (ID, required) - SF ID of case
        comment (String, required) - Text for comment
  */
  @RemoteAction
  global static void reopenCase(Map<String, String> data) {
    invocationPath = invocationPath + '=CC_ngTurkeyController.reopenCase';
    log.debug(data);
    try
    {
        Id caseId = data.get('caseId');
        String commentBody = data.get('comment');
        turkeySvc.reopenCase(caseId, commentBody);
    }
    catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath,true);throw ex;}
  }


  @RemoteAction
  global static void updateConfAtth(Map<String, String> data) {
    log.debug(data);
    invocationPath = invocationPath + '=CC_ngTurkeyController.updateConfAtth' ;      
    try
    {
        Id caseId = data.get('caseId');
        Boolean stat = Boolean.valueOf(data.get('stat'))?false:true;
          turkeySvc.updateConfAtth(caseId, stat);
    }
    catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, true);throw ex;}
  }

  /* PUBLIC METHODS */
  public PageReference redirect(){  
    Boolean accessGranted = false;
    PageReference redirectToPage = null;
    CC_LDAPRoles roles = new CC_LDAPRoles();
    System.debug('currentUser.LDAP_Roles__c:'+currentUser.LDAP_Roles__c);    
    if(currentUser.LDAP_Roles__c != null){
      accessGranted = roles.allowAccessToCustomerCommunity(currentUser.LDAP_Roles__c);
    }
    System.debug('accessGranted:'+accessGranted);
    if(accessGranted == false ){
      log.debug('LDAP Roles:'+currentUser.LDAP_Roles__c);
      redirectToPage = Page.CC_AccessDenied;
      if(!(Test.isRunningTest()))
      {
        Contact tmpCont = new Contact(Id=currentUser.Contact.Id, CC_Security_Group__c=''); update tmpCont;        
      }
    }
    if(accessGranted == true)
    {
       String securityGrpName = determineSecurityGroup();
       if(!(Test.isRunningTest()))  { Contact tmpCont = new Contact(Id=currentUser.Contact.Id, CC_Security_Group__c=securityGrpName); update tmpCont;   }
       System.debug('Final SecurityGroup is - ' + securityGrpName); 
    }
    return redirectToPage;
  }
  
  public static String determineSecurityGroup()
  {
      invocationPath = invocationPath + '=CC_ngTurkeyController.determineSecurityGroup' ;    
      String securityGroupName = '';
      try
      {
          String userRoles = currentUser.LDAP_Roles__c;
          if(userRoles == null)
          {
              return securityGroupName;
          }
          
          List<CC_Security_Groups_Config__c> securityGroups = CC_Settings.securityGroups;
          for(CC_Security_Groups_Config__c tmpGroup : securityGroups)
          {
              System.debug('Security Group - ' + tmpGroup.Available_LDAP_Roles__c);
              String availableLDAPRoles = tmpGroup.Available_LDAP_Roles__c;
              List<String> LDAProles = availableLDAPRoles.split(';');
              System.debug('Tokenized - ' + LDAProles);
              for(String role : LDAProles){
                  if(userRoles.contains(role))  { return tmpGroup.Name; }
              }
          }
      }
      catch(Exception ex){insertCCErrorLog('Data:\n'+ currentUser.LDAP_Roles__c + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath);throw buildCommunityException(ex);}
      return securityGroupName;
  }    

  /* PRIVATE METHODS */

  // asynchronously insert a portal view record for this case
  private static void registerPortalView(Id caseId, Id contactId, String connectId,Datetime viewDate) {
    System.enqueueJob(new RegisterPortalViewAsync(caseId, viewDate));
    //US319193
    System.enqueueJob(new RegisterCaseView(caseId,contactId, connectId, viewDate));
  }

  // convert generic object to map
  private static Map<String, Object> toJson(Object obj) {
    return (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(obj));
  }

  // convert generic object to map
  @TestVisible
  private static Map<String, Object> toCaseJson(Object obj, String activitiesString) {
    String s = JSON.serialize(obj);
    System.debug('serialized ***** ' + JSON.serialize(obj)); 
    String s2 = s.substring(0,(s.length())-1);
    System.debug('s2 ********** ' + s2);  
    String s3 = activitiesString; 
    System.debug('s3 again 2 ********** ' + s3);
    return (Map<String, Object>)JSON.deserializeUntyped(s2+','+ s3 + '}');
    //return (Map<String, Object>)JSON.deserializeUntyped(s);
  }

// convert map to a Case object
  private static Case dataToCase(Map<String, Object> data) {
    String productAreaId = (Id)data.get('productAreaId');
    String productAreaName = (String)data.get('productAreaName');
    String product=(String)data.get('productName');

    String contactId = (String)data.get('contactId');
    if( String.isBlank(contactId) ){
        contactId = currentUser.Contact.Id;
    } 


    String caseType = 'Standard';    
    Id projectId;
    ID  productId;
    //if (product=='LICENSING' || product=='CA SUPPORT PORTAL')
    if ( product!=null &&  product.equalsIgnoreCase(System.Label.CC_Global_Service_Center)){
          productId=(Id)CC_Settings.prodGSCId;
          if(productAreaName.equalsIgnoreCase(System.Label.CC_PA_Licensing)){
              productAreaId = (Id)CC_Settings.paLicensing;
          }
          else if(productAreaName.equalsIgnoreCase(System.Label.CC_PA_CA_Support_Portal)){
              productAreaId = (Id)CC_Settings.paCSP;
          }
      }
    else  
        productId=(Id)data.get('productId');
    String componentId = (String)data.get('prodcompId');
    System.debug('dataToCase - componentId - ' + componentId);
    String site=(String)data.get('siteId');
    ID siteid;//=(Id)site;
    log.debug('product='+product+'productID='+productId+',site id='+site);
      if (site=='' || site=='0' || site==NULL || site=='null') { 
        site=CC_Settings.defaultSiteIDforNoAccess;
        siteid=site;
        log.debug('siteid is null or empty');  
      }else
          siteid=site;

    log.debug('siteid='+siteid);  
    
    if( siteid.getSobjectType() == Project_Site_Association__c.sObjectType ){
          Project_Site_Association__c  projectSite = [select id, Project_ID__c, Site_Association__c,Site_Association__r.Id from Project_Site_Association__c where id = :siteid] ;
          if(projectSite != null){
                      siteid = projectSite.Site_Association__r.Id;
                      projectId = projectSite.Id ;
                      caseType = 'Project';
          }
    } 
      
      System.debug('************************ HERE *******************');
      //,ContactId =  currentUser.Contact.Id
    Case cleanCase = new Case(
      Business_Impact__c = (String)data.get('businessImpact')
      ,ContactId = contactId 
      ,Description = (String)data.get('description')
      ,Severity__c = (String)data.get('severity')
      ,Subject = (String)data.get('title')
      ,Site_Association__c = siteid
      ,CA_Product_Controller__c = productId
      ,Product_Area__c = productAreaId
      ,Internal_CA__c = (boolean)data.get('internalCA')
      ,Case_Type__c = caseType
    );
      if (!(componentId=='' || componentId==NULL || componentId=='null')) { 
          cleanCase.CA_Product_Component__c = (Id) componentId;
      }
      if(caseType == 'Project'){
          cleanCase.Project_Site_Association__c = projectId;
      }
      if (product=='LICENSING'){
        cleanCase.CA_Product_Component__c=(Id)CC_Settings.comLPMKEY;
      }else if (product=='CA SUPPORT PORTAL') {
        cleanCase.CA_Product_Component__c=(Id)CC_Settings.comSCNECT;      
      }
      
      boolean showheaderParam = (boolean)data.get('showheaderParam');
      if(showheaderParam != null && showheaderParam == true){
            cleanCase.Origin = System.Label.CC_CaseOrigin_SupportPortal;
      } else {
             cleanCase.Origin = System.Label.CC_CaseOrigin_Community;
      }

      String recTypeName = (String)data.get('recordTypeName');
      if(String.isNotBlank(recTypeName)){
              if( recTypeName.equalsIgnoreCase('CaseConcern') ){
                  System.debug('Inside CaseConcern recType block');
                  cleanCase.Status = 'New';
                  cleanCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CaseConcern').getRecordTypeId();
                  cleanCase.Priority = 'L' ; // Check
                  cleanCase.Case_Type__c = 'Case Concern';
              }
      } else {
          cleanCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
      }

      Id parentCaseId =  (Id)data.get('parentId');
      System.debug('parentCaseId:'+parentCaseId);

      cleanCase.ParentId = parentCaseId;
      System.debug('cleanCase:'+ cleanCase);

    return cleanCase;
  }

  @TestVisible
  private static CC_ngTurkeyService.CaseSearchCriteria dataToSearchCriteria(Map<String, Object> data) {
      invocationPath = invocationPath + '=CC_ngTurkeyController.buildNewCaseComment' ;
      try
      {
          CC_ngTurkeyService.CaseSearchCriteria criteria = new CC_ngTurkeyService.CaseSearchCriteria();
          if (data.containsKey('caseNumber')) {
              criteria.caseNumber = (String)data.get('caseNumber');
          } else {
              if (data.containsKey('title')) {
                  criteria.title = (String)data.get('title');
              }
              if (data.containsKey('contactEmail')) {
                  criteria.contactEmail = (String)data.get('contactEmail');
              }
              if (data.containsKey('status')) {
                  criteria.status = (String)data.get('status');
              }
              if (data.containsKey('severity')) {
                  criteria.severity = String.valueOf(data.get('severity'));
              }
              if (data.containsKey('product')) {
                  criteria.product = (Id)data.get('product');
              }
              if(data.containsKey('site')){
                  criteria.site = (Id)data.get('site');
              }
              if(data.containsKey('topsSiteID')){
                  criteria.topsSiteID = (String)data.get('topsSiteID');
              }
              if (data.containsKey('createdDateFrom')) {
                  criteria.createdDateFrom = dateStringToDateTime((String)data.get('createdDateFrom'));
              }
              if (data.containsKey('createdDateTo')) {
                  criteria.createdDateTo = dateStringToDateTime((String)data.get('createdDateTo'));
              }
              if (data.containsKey('lastModifiedDateFrom')) {
                  criteria.lastModifiedDateFrom = dateStringToDateTime((String)data.get('lastModifiedDateFrom'));
              }
              if (data.containsKey('lastModifiedDateTo')) {
                  criteria.lastModifiedDateTo = dateStringToDateTime((String)data.get('lastModifiedDateTo'));
              }
          }
          return criteria;
      }
      catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, false);throw ex;}
  }

  private static DateTime dateStringToDateTime(String dateString) {
    String normalizedDateString = dateString.replace('T', ' ');
    //return DateTime.valueOfGmt(normalizedDateString);
    return DateTime.valueOf(normalizedDateString);
  }

  // convert map to case comment
  private static CaseComment buildNewCaseComment(Map<String, Object> data, Id caseId) {
      invocationPath = invocationPath + '=CC_ngTurkeyController.buildNewCaseComment' ;
      try
      {
          CaseComment newCaseComment = new CaseComment(ParentId = caseId);
          String commentBody = '';
          String productName = (String)data.get('productName');
          commentBody += 'Product: ' + productName;
          String release = (String)data.get('release');
          if (release != null) {
              commentBody += ', Release: ' + release;
          }
          String servicePack = (String)data.get('servicePack');
          if (servicePack != null) {
              commentBody += ', Service Pack: ' + servicePack;
          }
          String os = (String)data.get('operatingSystem');
          if (os != null) {
              commentBody += ', Operating System: ' + os;
          }
          newCaseComment.CommentBody = commentBody;
          return newCaseComment;
      }
      catch(Exception ex){CC_ngTurkeyController.prepareErrorLogRecord('Data:\n'+ data +'\n Case Id: \n' + caseId + '\nError Message:\n'+ ex.getMessage() + '\n Stacktrace:\n' + ex.getStackTraceString() , invocationPath, false); throw ex;}
  }

  @RemoteAction
  global static void insertCCErrorLog(String errorMsg, String fPath){
    List<CC_Error_Log__c> errorLogList = new List<CC_Error_Log__c>();
    CC_Error_Log__c ccErrorLog = new CC_Error_Log__c();
    ccErrorLog.Contact__c = currentUser.Contact.Id;
    ccErrorLog.Error__c = errorMsg;
    ccErrorLog.Functionality__c = fPath;
    errorLogList.add(ccErrorLog);
    if(errorLogList != null && errorLogList.size() > 0)
        insert errorLogList;
  }
  
   public static void prepareErrorLogRecord(String errorMsg, String fPath, Boolean isInsert) {
      CC_Error_Log__c ccErrorLog = new CC_Error_Log__c();
      ccErrorLog.Contact__c = currentUser.Contact.Id;
      ccErrorLog.Error__c = errorMsg;
      ccErrorLog.Functionality__c = fPath;
      CC_ngTurkeyController.ccErrorLogListToInsert.add(ccErrorLog);
      if(isInsert)
      {
          insert CC_ngTurkeyController.ccErrorLogListToInsert;
      }
  }

  // build exception to throw
  private static CommunityException buildCommunityException(Exception ex) {
    String exceptionMessage = 'Error in Salesforce Community Case Management: ';
    exceptionMessage += ex.getTypeName() + ' - ' + ex.getMessage();
    exceptionMessage += '\nLine Number: ' + ex.getLineNumber();
    exceptionMessage += '\nStack Trace: ' + ex.getStackTraceString();
    CommunityException cex = new CommunityException(exceptionMessage, ex);
    log.error(cex);
    if (CC_Settings.debugEnabled) {
      return cex;
    } else {
      return new CommunityException('Error in Salesforce Community Case Management', ex);
    }
  }
    
  /* OTHER CLASSES */

  public class CommunityException extends Exception {
  }

  public class RegisterPortalViewAsync implements Queueable {
    Id caseId;
    Datetime viewDate;
    public RegisterPortalViewAsync(Id caseId, Datetime viewDate) {
      this.caseId = caseId;
      this.viewDate = viewDate;
    }
    public void execute(QueueableContext context) {
      insert new Case_Portal_View__c(Case__c = caseId, Portal_View_Date__c = viewDate);
    }
  }
    
  //US319193 - Recording the customer viewing the case in Case Management Portal
    public class RegisterCaseView implements Queueable {
          Id caseId;
          Id contactId;
          String connectId;
          Datetime viewDateTime;
          public RegisterCaseView(Id caseId, Id contactId, String connectId, DateTime viewDateTime) {
            this.caseId = caseId;
            this.contactId = contactId;
            this.viewDateTime = viewDateTime;
            this.connectId = connectId;
          }
          
          public void execute(QueueableContext context) {
            List<Case_Management_Tracking__c> caseViewTrackingList = [select id,Name,Case__c,Contact_Information__c,Last_Viewed_Date__c from Case_Management_Tracking__c 
            where case__c = :caseId and Contact_Information__c = : contactId limit 1];
            if( caseViewTrackingList.size() >0 ){
                  caseViewTrackingList[0].Last_Viewed_Date__c = viewDateTime;
                  update caseViewTrackingList[0];
            } 
            else {
                    String userType;
                    if( connectId.isNumeric()) { userType = 'Customer';  }
                    else { userType = 'CA';  }                  
                  Case_Management_Tracking__c caseViewTracking = new Case_Management_Tracking__c(Case__c = caseId, Contact_Information__c = contactId, Last_Viewed_Date__c = viewDateTime,Method__c =System.Label.Portal, User_Type__c  = userType );
                  insert caseViewTracking;
            }
          }
    }
    
     global class CaseCommentType {
      public ID Id;
      public String ParentId;
      public String CommentBody;
      public String CreatedById;
      public String CreatedDate;
      public Boolean IsPublished;
      public UserType CreatedBy {get; set;}
    }    
    public class UserType{
      public String Name;
      public String Id;
      public UserType(String name, String sfId){
          this.Name = name;
          this.Id = sfId;
      }
    } 
    
    
}