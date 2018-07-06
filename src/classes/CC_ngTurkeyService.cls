public without sharing class CC_ngTurkeyService implements I {
  public interface I {    
    boolean hasAccesstoThisSiteandProductFromEER(String connectId,Case fetchedCase, Id siteId);  
    Case[] fetchMyCases(boolean allCases);
    Case[] fetchCasesByCriteria(CaseSearchCriteria criteria);
    Case[] fetchCasesByCriteria(CaseSearchCriteria criteria, boolean allCases);  
    Case fetchCaseById(Id caseId);
    String fetchCaseActivitiesById(Id caseId);
    User[] fetchCaTechniciansForCases(Case[] cases);
    SiteProductAssociation[] fetchSitesAndProducts(String siteId, String connectId);
    CA_Product_Controller__c fetchRecentProduct(List<Id> productIdList);
    Product_Area__c fetchRecentProductArea(List<Id> productIdList); //*** PA Changes
    boolean getIsRECapabale(String prodName);    
    Case createCase(Case aCase);
    Case createCaseConcern(Case aCase);
    CC_ngturkeyController.CaseCommentType addCaseComment(CaseComment caseComment);
    void changeSeverity(Id caseId, String severity, String commentBody);
    void reopenCase(Id caseId, String commentBody);
    void updateConfAtth(Id caseId, Boolean stat);
    void closeCase(Id caseId, String commentBody);
    Set<Id> fetchEntitledSitesofUser(String connectSiteId,String connectId);
    List<Object> fetchSites(String connectSiteId, String connectId);
    String invokeL7GSService(String siteId, String caseNumber);
    ProductWithSite fetchRecentproductAreaWithSite(List<Id> productIdList);
    //List<Object> getProductAreas(String productName);    
  }
    
   //public boolean checkSiteValidation{ get{return checkSiteValidation;} set {checkSiteValidation=value;}}
  public static boolean checkSiteValidation=true;
    
  @TestVisible
  private final String[] caseRequiredFields = new String[]{
    'Subject',
    'Description',
    'Site_Association__c',
    'CA_Product_Controller__c',
    'Severity__c',
    'ContactId'
  };

  private Set<String> validSeverities {
    get {
      if (validSeverities == null) {
        validSeverities = new Set<String>();
        List<Schema.PicklistEntry> ple = Case.Severity__c.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry entry : ple) {
          validSeverities.add(entry.getValue());
        }
      }
      return validSeverities;
    }
    private set;
  }

  private CasesData casesDal { get; set; }

  @TestVisible
  private Id contactId { get; set; }

  @TestVisible
  private String connectId { get; set; }

  @TestVisible
  private boolean canSearchAcrossSites { get; set; }
  
  @TestVisible
  private boolean canViewPrivate { get; set; } 

  // Service class for API Gateway callouts
  @TestVisible
  private CC_Layer7Service.I l7Svc {
    get {
      if (l7Svc == null) {
        l7Svc = new CC_Layer7Service();
      }  
      return l7Svc;
    } set;
  }

  public CC_ngTurkeyService(Id contactId, boolean searchAllSites, boolean viewPrivate,String connectId) {
    this.casesDal = new CasesData();
    this.contactId = contactId;
    this.connectId = connectId;  
    this.canSearchAcrossSites = searchAllSites;
    this.canViewPrivate = viewPrivate;    
    if (contactId == null) { throw new ValidationException('You must provide a ContactId for security purposes.');   }
  }
    
       public SiteProductAssociation[] fetchSitesAndProducts(String siteId, String connectId) {
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_ngTurkeyService.fetchSitesAndProducts';
        try{            
          //*** EER Call Starts  
            System.debug('**CC_ngTurkeyController.hasSaasUserRole:'+CC_ngTurkeyController.hasSaasUserRole);
            List<String> entitledSitesListFromEER = new List<String>();
           Set<String> prodNamesFromEER = new set<String>();
           Map<String,Set<String>> prodAndsiteIdMap ;
           if(CC_ngTurkeyController.hasSaasUserRole){
                    prodAndsiteIdMap = l7Svc.getSitesAndProductsFromEER(CC_ngTurkeyController.currentUser.Contact.Email);
                     System.debug('prodAndsiteIdMap:'+prodAndsiteIdMap); //prodAndsiteIdMap: {a7Za0000000KymFEAS=206339}
                     if(prodAndsiteIdMap!= null){
                            prodNamesFromEER.addAll(prodAndsiteIdMap.keySet());
                            for(Set<String> siteSet: prodAndsiteIdMap.values()){
                                entitledSitesListFromEER.addAll(siteSet);
                            }
                     }                                    
           }

           //*** EER Call Ends 
                  
            Map<String,String> sitesAndProductsMap =  l7Svc.getSitesAndProducts(siteId, connectId);
            List<String> siteIdList = new List<String>();
            //TODO : Add GSC product.
            //          sitesAndProducts.add(new CC_Layer7Service.JsonSiteProduct(siteId, 'GLOBAL SERVICE CENTER'));
            
            if( sitesAndProductsMap != null ){
                String sites = sitesAndProductsMap.get('siteIds');
                sites = sites.removeStart('[');
                sites = sites.removeEnd(']');
                siteIdList = sites.split(',');
            }
            System.debug('siteIdList:'+siteIdList); 
            
            Set<String> siteIds = new Set<String>();
            Set<String> projectSiteIds = new Set<String>();
            Set<String> normalSiteIds = new Set<String>();
            for(String jsonSiteId : siteIdList) {
                String paddedSiteId = CC_Utils.padSiteId(jsonSiteId);
                if ( Integer.valueOf(paddedSiteId) >= 8000000 && Integer.valueOf(paddedSiteId) <= 8888887 ) {
                    projectSiteIds.add(paddedSiteId);
                } 
                else {
                    normalSiteIds.add(paddedSiteId);
                }
            }
            
            Set<String> normalSiteIdsFromClassicEnt = new Set<String>();
            normalSiteIdsFromClassicEnt.addAll(normalSiteIds);
            
          if(entitledSitesListFromEER!=null && entitledSitesListFromEER.size()>0)
            normalSiteIds.addAll(entitledSitesListFromEER);//Sites from EER
            
            System.debug('normalSiteIds:'+normalSiteIds); 
            
            Set<String> productNames = new Set<String>();
            String productsWithSiteIds; 
            if( sitesAndProductsMap != null ){
                productsWithSiteIds = sitesAndProductsMap.get('productsWithSiteIds');
                List<Util_JSONParser> arrayParser = Util_JSONParser.parseArray(productsWithSiteIds);
                for(Util_JSONParser p : arrayParser){
                    productNames.add(p.get('product').Value);
                }
            }
            System.debug('productsWithSiteIds:'+productsWithSiteIds);
            
            if(prodNamesFromEER!= null && prodNamesFromEER.size()>0)
                productNames.addAll(prodNamesFromEER);  ////Products from EER
            
            Map<String, Site_Association__c> sfSiteMap1 = fetchSiteAssociationsByTopsSiteIds(normalSiteIds);
            Map<String, AllSites> sfSiteMap = fetchAllSitesByTopsSiteIds(normalSiteIds,projectSiteIds);
            Map<String, CA_Product_Controller__c> sfProductMap = fetchCaProductControllersByProductNames(productNames);
            Map<String, List<Product_Area__c>> sfProductPAMap = fetchProductAreasByProductNames(productNames);  //***Newly added - PA Changes
            
            Map<String, Site_Association__c> sfSiteMapFromER = fetchSiteAssociationsByTopsSiteIds(normalSiteIdsFromClassicEnt);
            Set<Id> sfSiteIds = new Set<Id>();
            for (Site_Association__c site : sfSiteMapFromER.values()) {
                sfSiteIds.add(site.Id);
            }
            
            System.debug('sfProductPAMap:'+sfProductPAMap);
            SYstem.debug('sfSiteIds:'+sfSiteIds);
            /*Set<Id> sfSiteIds = new Set<Id>();
            for (Site_Association__c site : sfSiteMap1.values()) {
                sfSiteIds.add(site.Id);
            }*/
            
            // side effect! Save contact's entitled sites in SF. This is important because we use these sites for security.
            // update contact site associations using full list of site ids          
            if( sfSiteIds != null && sfSiteIds.size()>0)
                updateContactSiteAssociations(this.contactId, sfSiteIds);
            
            return convertToSiteProductAssociation(productsWithSiteIds, sfSiteMap, sfProductMap, sfProductPAMap , prodAndsiteIdMap); // - Added for EER Call            
      
        } catch(Exception e){ System.debug('Exception:'+e.getMessage() + 'Stacktrace:'+e.getStackTraceString());return null; }
        
    } 
    
    private List<SiteProductAssociation> convertToSiteProductAssociation(String productsWithSiteIds, Map<String, AllSites> sfSiteMap, Map<String, CA_Product_Controller__c> sfProductMap, Map<String, List<Product_Area__c>> sfProductPAMap , Map<String,Set<String>> prodAndsiteIdMap ) {
        
        List<SiteProductAssociation> returnList = new List<SiteProductAssociation>();
        if(productsWithSiteIds != null){
            List<Util_JSONParser> arrayParser = Util_JSONParser.parseArray(productsWithSiteIds);
            for(Util_JSONParser p : arrayParser){
                String sites = p.get('site_ids').Value;
                sites = sites.removeStart('[');
                sites = sites.removeEnd(']');
                List<String> siteIdList = sites.split(',');
                List<AllSites> allSitesList = new List<AllSites>();
                
                for(String s: siteIdList){
                    if(sfSiteMap.get(s)!=null) {  allSitesList.add(sfSiteMap.get(s));}            
                }
                
                List<Product_Area__c> paListofProduct = sfProductPAMap.get(p.get('product').Value);
                if( paListofProduct != null && paListofProduct.size()>0 ){
                    for(Product_Area__c pa : sfProductPAMap.get(p.get('product').Value) ){
                        SiteProductAssociation spAssociation = new SiteProductAssociation(allSitesList,sfProductMap.get(p.get('product').Value), pa);        
                        if (spAssociation.isValid()) {  returnList.add(spAssociation);} 
                        else { log.warn('Ignoring invalid Site/Product Association: Site ID List:' + allSitesList + ', Produce Name: ' + p.get('product').Value);}
                    }        
                }
            }
        }
        
        
        //From EER - Starts        
        if(prodAndsiteIdMap!=null){
            for(String prod : prodAndsiteIdMap.keySet()){
                List<AllSites> allSitesList2 = new List<AllSites>();
                for(Set<String> siteSet: prodAndsiteIdMap.values()){
                    for(String site:siteSet){ allSitesList2.add( sfSiteMap.get(site)); }
                }
                
                List<Product_Area__c> paListofProduct2 = sfProductPAMap.get(prod);
                if( paListofProduct2 != null && paListofProduct2.size()>0 ){
                    for(Product_Area__c pa : paListofProduct2){
                        SiteProductAssociation spAssociation = new SiteProductAssociation(allSitesList2,sfProductMap.get(prod), pa);
                        if (spAssociation.isValid()) { returnList.add(spAssociation);}
                        else {log.warn('Ignoring invalid Site/Product Association: Site ID List:' + allSitesList2 + ', Produce Name: ' + prod );}           
                    }            
                }
            }
        }
        //EER Ends        
 
        log.debug(returnList);
        return returnList;   
    }    

    //Tesnor
    public List<String>  fetchSitesFromEER() {        
        List<String> userSiteListFromEER = new List<String>();
        Map<String,Set<String>> prodAndsiteIdMap = l7Svc.getSitesAndProductsFromEER(CC_ngTurkeyController.currentUser.Contact.Email); //this.connectId
        System.debug('prodAndsiteIdMap:'+prodAndsiteIdMap);
        if( prodAndsiteIdMap !=null ){
            for(Set<String> siteSet: prodAndsiteIdMap.values()){
                userSiteListFromEER.addAll(siteSet);
            }
        }
        System.debug('****userSiteListFromEER:'+userSiteListFromEER);
        return userSiteListFromEER;
    }
    
        public List<Object> fetchSites(String connectSiteId, String connectId) {
        List<String> userSiteListFromEER = new List<String>();
        if(CC_ngTurkeyController.hasSaasUserRole){
              userSiteListFromEER = fetchSitesFromEER();
        }        
        System.debug('****userSiteListFromEER:'+userSiteListFromEER);
        
        //List<String> sitesOfUser = l7Svc.getSitesForUser(connectSiteId, connectId);
         Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.CCCache');
         String cacheKey = CC_Utils.removeNonAlphChars(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAPID__c);
        List<String> sitesOfUser = (List<String>) sessionPart.get(CC_CacheSitesAndProductsInfo.class, cacheKey+'SitesFromER');
        System.debug('***sitesOfUserFromClassicER - After CacheCall:'+sitesOfUser);
        if(sitesOfUser.get(0) == 'NoSitesFound' ){
              sitesOfUser.clear();
        }
        System.debug('***sitesOfUserFromClassicER:'+sitesOfUser);
        
        Set<String> projectSiteIds = new Set<String>();
        Set<String> normalSiteIds = new Set<String>();
        if( sitesOfUser!= null && sitesOfUser.size() >0 ){
            for(String s : sitesOfUser) {
                s=s.removeStart('"');
                s = s.removeEnd('"'); 
                String paddedSiteId = CC_Utils.padSiteId(s);
                if ( Integer.valueOf(paddedSiteId) >= 8000000 && Integer.valueOf(paddedSiteId) <= 8888887 ) {
                    projectSiteIds.add(paddedSiteId);
                } 
                else {
                    normalSiteIds.add(paddedSiteId);
                }
            }
        }
        if(userSiteListFromEER!= null && userSiteListFromEER.size()>0){
            normalSiteIds.addAll(userSiteListFromEER);
        }
        
        Map<String, AllSites> sfSiteMap = fetchAllSitesByTopsSiteIds(normalSiteIds,projectSiteIds);
        System.debug('sfSiteMap.values():'+sfSiteMap.values());        
        return sfSiteMap.values();
    }


  public Case[] fetchMyCases(boolean allCases) {
    CaseSearchCriteria criteria = new CaseSearchCriteria();
    criteria.contactId = this.contactId;
    if(CC_ngTurkeyController.isPartnerUser){
        criteria.contactEmail = CC_ngTurkeyController.currentUser.Contact.Email;
    }
    Case[] cases = fetchCasesByCriteria(criteria, allCases);
    return cases;
  }

  public Case[] fetchCasesByCriteria(CaseSearchCriteria criteria) {
      return fetchCasesByCriteria(criteria, false);
  }

  public Case[] fetchCasesByCriteria(CaseSearchCriteria criteria, boolean allCases) {
          Set<Id> entitledSites = fetchEntitledSites(this.contactId);
      //List<String> userSiteListFromEER= new List<String>(); //***Tensor    
      Set<Id> entitledSitesFromEER = new Set<Id>();
      Map<String,Set<String>> prodAndsiteIdMapFromEER = new Map<String,Set<String>>();
      if(CC_ngTurkeyController.hasSaasUserRole){
          prodAndsiteIdMapFromEER = l7Svc.getSitesAndProductsFromEER(CC_ngTurkeyController.currentUser.Contact.Email);
           List<String>  userSiteListFromEER = fetchSitesFromEER();
            for(Site_Association__c siteAssoc : [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c IN :userSiteListFromEER]) {
                entitledSitesFromEER.add(siteAssoc.Id);
            }
      }
      Case[] cases = casesDal.fetchCasesByCriteriaFlyweight(entitledSites,entitledSitesFromEER,prodAndsiteIdMapFromEER, criteria, canSearchAcrossSites, canViewPrivate, allCases);
      //Case[] cases = casesDal.fetchCasesByCriteriaFlyweight(entitledSites,entitledSitesFromEER, criteria, canSearchAcrossSites, canViewPrivate, allCases); //, fromMyCases
      return cases;
  }

  public Case fetchCaseById(Id caseId) {
    Case fetchedCase = casesDal.fetchCaseById(caseId);
    if (fetchedCase == null) {
      throw new ValidationException('You do not have access to this case.');
    } 
      if(CC_ngTurkeyController.hasSaasUserRole && hasAccesstoThisSiteandProductFromEER(connectId,fetchedCase,null)) {
          return fetchedCase;
      }
      else{
          if(fetchedCase.Case_Type__c == 'Project')
              validateSiteAccess(fetchedCase.Project_Site_Association__c);
          else 
              validateSiteAccess(fetchedCase.Site_Association__c);
      }
    return fetchedCase;
  }
    
   @TestVisible
   public String invokeL7GSService (String siteId, String caseNumber) {
        String responseStatus = l7Svc.callLayer7ToCreateVirtualFolderInEFT(UserInfo.getUserEmail(),caseNumber , siteId);
        System.debug('In ngTurkeyService, invokeL7GSService() responseStatus:'+responseStatus);
        return responseStatus;
    }

  @TestVisible
  private List <CaseActivityRecord> caseActivities = new List<CaseActivityRecord>();

  @TestVisible
  private List <CaseActivityRecord> sortedCaseActivities = new List<CaseActivityRecord>();
    
  public String fetchCaseActivitiesById(Id caseId)
  {
      String s = '';
      Integer activitiesCounter = 0;
      String dateformat = 'yyyy-MM-dd\'T\'HH:mm:ss.sssZ';
      
      String[] fieldsCaseComment = new String[]{'Id','ParentId','CommentBody','CreatedBy.Name','CreatedDate','IsPublished'};      
      String soql = 'SELECT ' + String.join(fieldsCaseComment, ', ') + ' FROM CaseComment';
      soql += ' WHERE parentId = :caseId AND IsPublished=true';
      CaseComment[] comments = Database.query(soql);
      System.debug('Comments Size ******** ' + comments.size());
      
      if(comments.size() > 0)
      {
          activitiesCounter = comments.size();
          for(Integer i = 0; i < comments.size(); i++)
          {
              CaseActivityRecord myCaseActivity = new CaseActivityRecord();
              CaseComment tmpComment = comments[i];
              myCaseActivity.commentBody=tmpComment.CommentBody;
              myCaseActivity.commentDateTime=tmpComment.CreatedDate;
              myCaseActivity.commentCreatedBy=tmpComment.CreatedBy.Name;
              myCaseActivity.commentIsPublished= true;//tmpComment.IsPublished;
              caseActivities.add(myCaseActivity);
          }
      }
      System.debug('Checking Private Comments. User is '+CC_ngTurkeyController.canViewPrivate);
      // Fetch Case Private Comments if the logged in user is Internal User
      if (CC_ngTurkeyController.canViewPrivate){
                String Privatecommentsresp =CC_Layer7Service.fetchPrivateComments(caseId);
                caseActivities.addAll(retriveParsedComments(Privatecommentsresp,caseId)); 
                
                /*List<CaseCommentParser> tt =   (List<CaseCommentParser>)System.JSON.deserialize(Privatecommentsresp, List<CaseCommentParser>.class);
                String temp;    
                for(CaseCommentParser t : tt){
                    System.debug('t:'+ t);
                    CaseActivityRecord myCaseActivity = new CaseActivityRecord();
                    myCaseActivity.commentBody= t.commentBody.replace('<br/>', '\n');                   
                   
                    //DateTime dt = DateTime.valueofGMT(t.CreatedDate.replace('T',' '));
                    myCaseActivity.commentDateTime=t.CreatedDate;
                    myCaseActivity.commentCreatedBy=t.CreatedBy.Name;
                    myCaseActivity.commentIsPublished=false;    
                    System.debug('****myCaseActivity='+myCaseActivity); 
                    caseActivities.add(myCaseActivity); 
                } */
                
                
                //Privatecommentsresp=Privatecommentsresp.replace('\\<', '&lt;');
               /* Privatecommentsresp = Privatecommentsresp.unescapeEcmaScript();
                System.debug('***Private Comments='+Privatecommentsresp);
                List<Util_JSONParser> parserUtil = Util_JSONParser.parseArray(Privatecommentsresp);
                for(Util_JSONParser p : parserUtil){
                    CaseActivityRecord myCaseActivity = new CaseActivityRecord();
                    //CaseComment tmpComment = comments[i];
                    String comment=p.get('CommentBody').Value;
                    System.debug('Private Comments='+comment);  
                    myCaseActivity.commentBody= comment.replaceall('\n','\\');                    
                    DateTime dt=DateTime.valueofGMT((p.get('CreatedDate').Value).replace('T',' '));
                    myCaseActivity.commentDateTime=dt;
                    myCaseActivity.commentCreatedBy=p.get('CreatedBy').get('Name').Value;
                    myCaseActivity.commentIsPublished=false;
                    System.debug('myCaseActivity='+myCaseActivity);  
                    caseActivities.add(myCaseActivity); 
                }  */
      }

      String[] fieldsCaseHistory = new String[]{'CreatedDate','Field','CreatedBy.Name','NewValue','OldValue'}; 
      Set<String> fieldsSet = new Set<String>();     
      fieldsSet.add('CA_Product_Controller__c');
      fieldsSet.add('Severity__c');
      fieldsSet.add('reason');            
      Map<String,String> field2label= new Map<String,String>();
      field2label.put('CA_Product_Controller__c','CA PRODUCT');
      field2label.put('Severity__c','SEVERITY');
      field2label.put('Reason','CASE REASON');            
      String historySoql = 'SELECT ' + String.join(fieldsCaseHistory, ', ') + ' FROM CaseHistory';
      historySoql += ' WHERE caseId= :caseId AND Field IN :fieldsSet';
      CaseHistory[] historyEntries = Database.query(historySoql);
      System.debug('historyEntries Size ******** ' + historyEntries.size());

      if(historyEntries.size() > 0)
      {
          activitiesCounter = activitiesCounter + historyEntries.size();
          for(Integer i = 0; i < historyEntries.size(); i++)
          {
              CaseActivityRecord myCaseActivity = new CaseActivityRecord();
              CaseHistory tmpComment = historyEntries[i];
              String oldValue=null;
              if(tmpComment.OldValue != null) oldValue = (String)tmpComment.OldValue;
              String newValue=null;
              if(tmpComment.NewValue != null) newValue = (String)tmpComment.NewValue;
              
              String fieldName = field2label.get(tmpComment.Field);
              if(fieldName == null) { fieldName = tmpComment.Field; }              
              if(oldValue != null) {
                  if((newValue != null && !((newValue instanceOf Id) && (oldValue instanceOf Id))) || (newValue == null && !(oldValue instanceOf Id)))
                  {
                      if(newValue!=null)
                          myCaseActivity.commentBody='Changed ' + fieldName + ' from ' + tmpComment.OldValue + ' to ' + tmpComment.NewValue;
                      else
                          myCaseActivity.commentBody='Changed ' + fieldName + ' from ' + tmpComment.OldValue + ' to BLANK';
                      myCaseActivity.commentDateTime=tmpComment.CreatedDate;
                      myCaseActivity.commentCreatedBy=tmpComment.CreatedBy.Name;
                      myCaseActivity.commentIsPublished=true;
                      caseActivities.add(myCaseActivity);
                  }
              }
              else {
                  if(newValue != null && !(newValue instanceOf Id)) {
                      myCaseActivity.commentBody='Changed ' + fieldName + ' to ' + tmpComment.NewValue;
                      myCaseActivity.commentDateTime=tmpComment.CreatedDate;
                      myCaseActivity.commentCreatedBy=tmpComment.CreatedBy.Name;
                      myCaseActivity.commentIsPublished=true;
                      caseActivities.add(myCaseActivity);                      
                  }
              }              
          }
      }

      String[] fieldsCaseEmail = new String[]{'id', 'toaddress','ccaddress','textbody','HTMLbody','CreatedBy.Name','messagedate','subject'};      
      String emailsoql = 'SELECT ' + String.join(fieldsCaseEmail, ', ') + ' FROM EmailMessage';
      emailsoql += ' WHERE parentId = :caseId';
      EmailMessage[] emails = Database.query(emailsoql);
      System.debug('Eamils Size ******** ' + emails.size());
      Set<Id> emailSet = new Set<Id>();
      
      if(emails.size() > 0) {
          for(Integer i = 0; i < emails.size(); i++) { emailSet.add(emails[i].Id); }
      }
      
      String emailAttsoql = 'SELECT Id,parentId FROM Attachment where parentId IN :emailSet';
      Attachment[] myAttachments = Database.query(emailAttsoql);    
      Map<Id,Integer> attachCountMap = new Map<Id,Integer>();  
      
      if(myAttachments.size() > 0) {
          for(Integer i = 0; i < myAttachments.size(); i++) {
              Attachment myAttach = myAttachments[i];
              if(attachCountMap.get(myAttach.parentId) != null) {
                  Integer count = attachCountMap.get(myAttach.parentId);
                  attachCountMap.put(myAttach.parentId, count+1);
              } else {
                  attachCountMap.put(myAttach.parentId, 1);              
              }
          } 
      }
      
      if(emails.size() > 0) {
          activitiesCounter = activitiesCounter + emails.size();
          for(Integer i = 0; i < emails.size(); i++) {
              CaseActivityRecord myCaseActivity = new CaseActivityRecord();
              EmailMessage tmpComment = emails[i];
              Integer attCount = 0;
              if(attachCountMap.get(tmpComment.id) != null) { attCount = attachCountMap.get(tmpComment.id); }
              String ccAddress = (tmpComment.ccaddress)==null?'': tmpComment.ccaddress;
              String tmpBody;// = 'To: ' + tmpComment.toaddress + '\r\n';
                  tmpBody =  'To: ' + tmpComment.toaddress + '\r\n';
                  tmpBody = tmpBody + 'CC: ' + ccAddress + '\r\n';
                  tmpBody = tmpBody + 'Subject: ' + tmpComment.subject + '\r\n';
              if(tmpComment.HTMLbody!=NULL && tmpComment.HTMLbody!=''){
                  tmpBody =  tmpBody +  tmpComment.HTMLbody  + '\r\n' ;  
                  myCaseActivity.htmltemp=true;
                }
              else{
                  tmpBody = tmpBody + 'Body: \r\n' + tmpComment.textbody + '\r\n';  
                  myCaseActivity.htmltemp=false;}
              tmpBody = tmpBody + 'Number of Attachments: ' + attCount + '\r\n';              
              
              myCaseActivity.commentBody=tmpBody;                        
              myCaseActivity.commentDateTime=tmpComment.messagedate;
              myCaseActivity.commentCreatedBy=tmpComment.CreatedBy.Name;
              myCaseActivity.commentIsPublished=true;
              caseActivities.add(myCaseActivity);
          }
      }
      
      integer tmpSize = caseActivities.size();
      
      while(sortedCaseActivities.size() != tmpSize) { findMinDateValue(); }
            
      String commentStr = '';
      for(CaseActivityRecord rec:sortedCaseActivities)
      {
          String tmpBody = rec.getNormalizedCommentBody();
          String tmpName = rec.commentCreatedBy;
          Boolean IsPublished = rec.commentIsPublished;
          DateTime tmpDate = rec.commentDateTime;
          System.debug('tmpBody ***** ' + tmpBody);          
          System.debug('tmpDate ***** ' + tmpDate);
          String tmpDateString = tmpDate.formatGMT(dateformat);
          Boolean Ishtmltemp=rec.htmltemp ;
          System.debug('tmpDateString ***** ' + tmpDateString);          
          String tmp = '{"attributes":{"type":"CaseComment"},"CommentBody":"'+tmpBody+'","Ishtmltemp":'+Ishtmltemp+',"CreatedDate":"'+tmpDateString+'","IsPublished":'+IsPublished+',"CreatedBy":{"attributes":{"type":"Name"},"Name":"'+tmpName+'"}}';
          if(commentStr=='') {  commentStr = ''+tmp; }
          else { commentStr=commentStr+','+tmp; }
      }
      //String formattedString = '{\"attributes\":{\"type\":\"CaseComment\"},\"CommentBody\":\"'+tmpBody+'\",\"CreatedDate\":\"'+tmpDateString+'\",\"IsPublished\":true,\"CreatedBy\":{\"attributes\":{\"type\":\"Name\"},\"Name\":\"+tmpName+'\"}}';
          String tmpFinalString = '"CaseComments":{"totalSize":1,"records":['+commentStr+']}';
          s=tmpFinalString;      
      return s;
  }
  
  private void findMinDateValue()
  {
        datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); // if decending
       
        integer i = 0;
        integer mini = 0;
        
        System.debug('caseActivities size *** ' + caseActivities.size());
        System.debug('caseActivities *** ' + caseActivities);
        System.debug('dt *** ' + dt);
       
        for (i = 0; i != caseActivities.size() ; i ++){
              if(caseActivities[i].commentDateTime > dt){ 
                    dt = caseActivities[i].commentDateTime;
                    mini = i;
              }
        }
       
       System.debug('mini *** ' + mini);
       System.debug('case mini *** ' + caseActivities[mini]);
       
        sortedCaseActivities.add(caseActivities[mini]);
        caseActivities.remove(mini);
       
  }

  public User[] fetchCaTechniciansForCases(Case[] cases) {
    Set<Id> userIds = new Set<Id>();
    for (Case aCase : cases) {
      userIds.add(aCase.OwnerId);
    }
    return [SELECT Id
                  ,Name
                  ,Phone
                  ,Email
                  ,Preferred_Contact_Method__c
            FROM User
            WHERE Id IN :userIds];
  }

  

    //*** PA Changes *** //
    @TestVisible
    private Map<String, List<Product_Area__c>> fetchProductAreasByProductNames(Set<String> productNames) {        
        Map<String, List<Product_Area__c>> productPAMap = new Map<String, List<Product_Area__c>>();
        List<Product_Area__c> paList = [select id,name,CA_Product__c,CA_Product__r.Name,Default_Group_Component__c  from Product_Area__c where CA_Product__r.Name IN  :productNames]; 
        for( Product_Area__c pa : paList ){   
            if(productPAMap.containsKey(pa.CA_Product__r.Name)){
                List<Product_Area__c> tempPAList =   productPAMap.get(pa.CA_Product__r.Name);
                tempPAList.add(pa);
                productPAMap.put(pa.CA_Product__r.Name , tempPAList);     
            } else {
                productPAMap.put(pa.CA_Product__r.Name ,new List<Product_Area__c> { pa }  );
            }
        }
        return productPAMap;        
    }
    
    public Product_Area__c fetchRecentProductArea(List<Id> productIdList){         
        List<Case> recentlyOpenedCase = [select id, CA_Product_Controller__c,CA_Product_Controller__r.Name,Product_Area__c,Product_Area__r.Name from Case 
                                         where ContactId =: this.contactId 
                                         and (CA_Product_Controller__c IN :productIdList and CA_Product_Controller__r.Name != 'GLOBAL SERVICE CENTER' )
                                         order by createdDate desc limit 1];
        
        if( recentlyOpenedCase != null && recentlyOpenedCase.size()>0 ){      
            //If there is a Product Area on that case, use that to populate the Product field on the open case page
            if(recentlyOpenedCase[0].Product_Area__c != null){
                List<Product_Area__c> productAreaList = [select id,name,CA_Product__c,CA_Product__r.Name,Default_Group_Component__c  
                                                         from Product_Area__c
                                                         where id = :recentlyOpenedCase[0].Product_Area__c ];
                return productAreaList[0];
            }
            //If there is no Product Area on that case, take the CA Product from the case and look it up in the table, and choose the 1st Product Area for that CA Product.
            else {
                List<Product_Area__c> productAreaList= [ select id,name,CA_Product__c,CA_Product__r.Name,Default_Group_Component__c from Product_Area__c where CA_Product__c = : recentlyOpenedCase[0].CA_Product_Controller__c];
                if( productAreaList != null && productAreaList.size() > 0 ) {
                    return productAreaList[0];
                }
                else {
                    return null;
                }
            }
        } else {
            return null;
        }        
    }    
    //*** PA Changes *** //
   
  //US249096 - Remeber Recent CA Product
  public CA_Product_Controller__c fetchRecentProduct(List<Id> productIdList){
      List<Case> recentlyOpenedCase = [select id, CA_Product_Controller__c,CA_Product_Controller__r.Name from Case 
            where ContactId =: this.contactId 
            and (CA_Product_Controller__c IN :productIdList and CA_Product_Controller__r.Name != 'GLOBAL SERVICE CENTER' )
            order by createdDate desc limit 1];     
      if( recentlyOpenedCase != null && recentlyOpenedCase.size()>0 ){
          List<CA_Product_Controller__c> productControllerList =  [select id,name from CA_Product_Controller__c where id = :recentlyOpenedCase[0].CA_Product_Controller__c ];
          if( productControllerList!= null && productControllerList.size() > 0 ){
              return productControllerList[0];
          }
          else { return null;}       
      }
      else { return null;  }
  }
    
  public ProductWithSite fetchRecentproductAreaWithSite(List<Id> productIdList){
    ProductWithSite prodwithSite = new ProductWithSite();
      List<Case> recentlyOpenedCase = [select id, CA_Product_Controller__c,CA_Product_Controller__r.Name,Product_Area__c,Product_Area__r.Name,Case_Type__c,
      Site_Association__r.Id,Tops_Support_Site_ID__c,Site_Name__c,Project_Site_Association__r.Id,project_Site_Association__r.Name,Project_Site_Association__c,Project_ID__c  from Case where ContactId =: this.contactId 
                                         and (CA_Product_Controller__c IN :productIdList and CA_Product_Controller__r.Name != 'GLOBAL SERVICE CENTER' )
                                         order by createdDate desc limit 1];
                                         System.debug('-recentlyopendCase-'+recentlyOpenedCase[0]);
    if( recentlyOpenedCase != null && recentlyOpenedCase.size()>0 )
    {      
            //If there is a Product Area on that case, use that to populate the Product field on the open case page
            if(recentlyOpenedCase[0].Product_Area__c != null){
                List<Product_Area__c> productAreaList = [select id,name,CA_Product__c,CA_Product__r.Name,Default_Group_Component__c  
                                                         from Product_Area__c
                                                         where id = :recentlyOpenedCase[0].Product_Area__c ];                
                prodwithSite.productArea = productAreaList[0];
                System.debug('-----------prodwithSite-------'+prodwithSite);
            }
            //If there is no Product Area on that case, take the CA Product from the case and look it up in the table, and choose the 1st Product Area for that CA Product.
            else{
                List<Product_Area__c> productAreaList= [ select id,name,CA_Product__c,CA_Product__r.Name,Default_Group_Component__c from Product_Area__c where CA_Product__c = : recentlyOpenedCase[0].CA_Product_Controller__c];
                if( productAreaList != null && productAreaList.size() > 0 ) {
                   prodwithSite.productArea = productAreaList[0];
                }                
            }
            System.debug('-casetype------'+recentlyOpenedCase[0].Case_Type__c);
            // prepopulating site id from previous case
             if (recentlyOpenedCase[0].Case_Type__c.equalsIgnoreCase('project')){
                  AllSites allSitesRec = new AllSites(recentlyOpenedCase[0].Project_Site_Association__r.Name,recentlyOpenedCase[0].Project_Site_Association__r.Id,recentlyOpenedCase[0].Project_ID__c,'Project Site');
                  prodwithSite.sites = allSitesRec;
            }else
            {
                  AllSites allSitesRec = new AllSites(recentlyOpenedCase[0].Site_Name__c,recentlyOpenedCase[0].Site_Association__r.Id,recentlyOpenedCase[0].Tops_Support_Site_ID__c,'Normal Site');
                  prodwithSite.sites = allSitesRec;
            }
            System.debug('-----------prodwithsite:'+prodwithSite);
            return prodwithSite;
      }else { return null; }  
   }
  

  public Case createCase(Case aCase) {
    //aCase.Origin = 'Community';
    //aCase.Case_Type__c = 'Standard';
    validateCaseCreate(aCase);
    insert aCase;
    log.debug('Case Created and ID is='+aCase);  
    return aCase;
  }

    public Case createCaseConcern(Case aCase) {
    //aCase.Origin = 'Community';
    //aCase.Case_Type__c = 'Standard';
    //validateCaseCreate(aCase);
    insert aCase;
    log.debug('Case Concern Created and ID is='+aCase);  
    System.debug('aCase.caseNumber:'+aCase.caseNumber);
    return aCase;
  }



    public CC_ngTurkeyController.CaseCommentType addCaseComment(CaseComment caseComment) {
        validateCaseCommentCreate(caseComment);
        System.debug('caseComment.isPublished='+caseComment.isPublished);
        CC_ngTurkeyController.CaseCommentType retcomment=new CC_ngTurkeyController.CaseCommentType();
        if (caseComment.isPublished==true && CC_ngTurkeyController.canViewPrivate  ){
            String commentbody='Added By '+  CC_ngTurkeyController.currentUser.FirstName + ' ' + CC_ngTurkeyController.currentUser.LastName + '. \\n ' + (caseComment.CommentBody).replace('\\','\\\\');
            log.debug('This is a private comment .caseComment.ParentId='+caseComment.ParentId + 'caseComment.CommentBody='+commentbody);
            String commentID=CC_Layer7Service.InsertPrivateComments(caseComment.ParentId,commentbody);
            System.debug('commentID='+commentID);
            String Privatecommentsresp =CC_Layer7Service.fetchPrivateComments(CaseComment.parentID,commentID);
            Privatecommentsresp=Privatecommentsresp.replace('\\<br/>','@@@');
            System.debug('Privatecommentsresp='+Privatecommentsresp);
            //caseActivities.addAll(retriveParsedComments(Privatecommentsresp)); 
            List<CC_ngTurkeyController.CaseCommentType> tt =   (List<CC_ngTurkeyController.CaseCommentType>)System.JSON.deserialize(Privatecommentsresp, List<CC_ngTurkeyController.CaseCommentType>.class);                    
                for(CC_ngTurkeyController.CaseCommentType t : tt){
                    //CaseActivityRecord myCaseActivity = new CaseActivityRecord();
                    retcomment.ID = t.Id;
                    retcomment.commentBody= t.CommentBody.replace('@@@', '\\n');
                    retcomment.commentBody= retcomment.commentBody.replace('<br/>', '\n');                  
                    retcomment.CreatedDate=t.CreatedDate;
                    retcomment.CreatedBy = t.CreatedBy;
                    retcomment.CreatedById = t.CreatedBy.Id;
                    retcomment.IsPublished =false;    
                }
        }
        else{    
            insert caseComment;
            CaseComment newcasecomment=casesDal.fetchCaseCommentById(caseComment.Id);
            retcomment.ID=newcasecomment.ID;
            retcomment.ParentID=CaseComment.parentID;
            retcomment.commentBody=newcasecomment.commentBody;
            String dt=newcasecomment.CreatedDate.format('yyyy-MM-dd HH:mm:ss');
            dt=dt.replace(' PM','Z').replace(' ','T');
            retcomment.CreatedDate=dt;
            retcomment.CreatedById=newcasecomment.CreatedById;
            retcomment.IsPublished=true;
            retcomment.CreatedBy = new CC_ngTurkeyController.UserType(newcasecomment.CreatedBy.Name,newcasecomment.CreatedBy.Id);
        }  
        return retcomment;
    }


  public void closeCase(Id caseId, String commentBody) {
    CaseComment comment = new CaseComment(
      ParentId = caseId,
      CommentBody = 'Request Case Close: \n' + commentBody
    );
    addCaseComment(comment);
    
    Case aCase = new Case(
      Id = caseId
    );
    update aCase;
  }
    
   public void updateConfAtth(Id caseId, Boolean conf) {
    String msg;   
    validateCaseAccess(caseID);
    Case aCase = new Case(
      Id = caseId,
      Confidential_Attachments__c =  conf 
    );
    
    update aCase;
    if(conf)
        msg='Confidential File Attachment Flag is Checked';
    else
        msg='Confidential File Attachment Flag is unchecked';   
    // no need check the site validation again as its validated already    
    checkSiteValidation=false;           
    CaseComment comment = new CaseComment(
      ParentId = caseId,
      CommentBody = msg
    );
    addCaseComment(comment);
  }

  public boolean getIsRECapabale(String prodName)
  {
      List<Remote_Engineer_Products__c> REList= new List<Remote_Engineer_Products__c>();
      REList=Remote_Engineer_Products__c.getAll().Values();      
      List<String> productList = new List<String>();
      boolean isCapable = false;
      for(Remote_Engineer_Products__c tmp:REList){
            if(tmp.Product_Name__c == prodName){
                isCapable = true;
                break;
            }
      }
      return isCapable;
  }
  
  public void reopenCase(Id caseId, String commentBody) {
    CaseComment comment = new CaseComment(
      ParentId = caseId,
      CommentBody = 'Request Case Reopen: \n' +commentBody
    );
    addCaseComment(comment);
    updateCaseForReopen(caseId);
    /*Case aCase = new Case(
      Id = caseId,
      Reason_for_Reopen__c = 'Case Reopen Requested',
      Troubleshooting_Stage__c = '1. Problem Identification',
      Next_Action_Due_Date__c = DateTime.now().addHours(25),
      Next_Action__c = 'Pending CA Support'
    );
    update aCase; */
  }
    
    @Future
    public static void updateCaseForReopen(Id caseId){
         Case aCase = new Case(
          Id = caseId,
          Reason_for_Reopen__c = 'Case Reopen Requested',
          Troubleshooting_Stage__c = '1. Problem Identification',
          Next_Action_Due_Date__c = DateTime.now().addHours(25),
          Next_Action__c = 'Pending CA Support'
        );
        update aCase;
    }

  public void changeSeverity(Id caseId, String newSeverity, String commentBody) {
    Case existingCase = casesDal.fetchCaseById(caseId);

    String[] validationErrors = new String[]{};
    checkSeverity(validationErrors, newSeverity);
    if (newSeverity == '1' && existingCase.Severity__c != '1') {
      validationErrors.add('Cannot change case severity to "1"');
    }
    throwValidationError(validationErrors);
    
    CaseComment comment = new CaseComment(
      ParentId = caseId,
      CommentBody = 'Severity change comments: \n' + commentBody
    );
    addCaseComment(comment);

    Case aCase = new Case(
      Id = caseId,
      Severity__c = newSeverity
    );
    update aCase;
  }

  @TestVisible
  private void updateContactSiteAssociations(Id contactId, Set<Id> siteIds) {
    Contacts_Site_Association__c[] csas = casesDal.fetchContactSiteAssociations(contactId);
    Set<Id> newSites = siteIds;
    Map<Id, Contacts_Site_Association__c> csasBySiteId = new Map<Id, Contacts_Site_Association__c>();
    Contacts_Site_Association__c[] upsertCsas = new Contacts_Site_Association__c[]{};
    for (Contacts_Site_Association__c csa : csas) {
      csasBySiteId.put(csa.SC_CSA_SITE__c, csa);
      if (!newSites.contains(csa.SC_CSA_SITE__c)) {
        // deactivate this csa
        upsertCsas.add(new Contacts_Site_Association__c(Id = csa.Id, SC_CSA_ACTIVE_ON_SITE__c = false));
      }
    }
    
    for(Id siteId: siteIds){
      Contacts_Site_Association__c csa =  csasBySiteId.get(siteId);
      if (csa == null) {
        // add new csa for this site
        upsertCsas.add(new Contacts_Site_Association__c(SC_CSA_CONTACTS__c = contactId, SC_CSA_SITE__c = siteId));
      } else if (csa.SC_CSA_ACTIVE_ON_SITE__c == false) {
        // reactivate old csa for this site
        upsertCsas.add(new Contacts_Site_Association__c(Id = csa.Id, SC_CSA_ACTIVE_ON_SITE__c = true));
      }
    }

    upsert upsertCsas;
  }

  @TestVisible
  private Map<String, Site_Association__c> fetchSiteAssociationsByTopsSiteIds(Set<String> topsSiteIds) {
    Map<String, Site_Association__c> sfSiteMap = new Map<String, Site_Association__c>(); 
    for (Site_Association__c site : [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c IN :topsSiteIds]) {
      sfSiteMap.put(site.SC_TOPS_ID__c, site);
    }
    return sfSiteMap;
  }
    
  @TestVisible
  private Map<String, AllSites> fetchAllSitesByTopsSiteIds(Set<String> normalSiteIds, Set<String>projectSiteIds) {
      Map<String,AllSites> sfSiteMap = new Map<String,AllSites>();
      //AllSites(String name, Id sfId, String siteId, String siteType)
      for (Site_Association__c site : [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c IN :normalSiteIds]) {
        //System.debug('*******site:'+site);
        AllSites allSitesRec = new AllSites(site.Name, site.Id, site.SC_TOPS_ID__c, 'Normal Site');
        sfSiteMap.put( site.SC_TOPS_ID__c, allSitesRec);
      }
      
      for(Project_Site_Association__c projectSite : [select id,Name, Project_ID__c,Site_Association__c from Project_Site_Association__c where Project_ID__c IN :projectSiteIds]){
        AllSites allSitesRec = new AllSites(projectSite.Name, projectSite.Id, projectSite.Project_ID__c, 'Project Site');
        sfSiteMap.put( projectSite.Project_ID__c, allSitesRec);
      }
      System.debug('sfSiteMap:'+sfSiteMap);
      return sfSiteMap; 
  }

  @TestVisible
  private Map<String, CA_Product_Controller__c> fetchCaProductControllersByProductNames(Set<String> productNames) {
    Map<String, CA_Product_Controller__c> sfProductMap = new Map<String, CA_Product_Controller__c>();

    // fetch all prodcut controllers
    //CA_Product_Controller__c[] sfProducts = [SELECT Id, Name FROM CA_Product_Controller__c WHERE Name IN : productNames ORDER BY Name ASC];
    //for (CA_Product_Controller__c sfProduct : sfProducts) {
    //  sfProductMap.put(sfProduct.Name, sfProduct);
    //}

    // fetch only valid ca product controllers
    // HACK: workaround the component handling logic in AutoAssign.trigger
    CA_Product_Component__c[] components = [SELECT CA_Product_Controller__r.Id, CA_Product_Controller__r.Name FROM CA_Product_Component__c 
      WHERE CA_Product_Controller__r.Name in :productNames 
      AND Default_Component_for_this_CA_Product__c = true 
      AND (component_expiration_date__c >= :System.today() OR component_expiration_date__c = null OR Internal_Presentation_Only__c = true) 
      ORDER BY CA_Product_Controller__r.Name];
    for (CA_Product_Component__c component : components) {
      sfProductMap.put(component.CA_Product_Controller__r.Name, (CA_Product_Controller__c)component.CA_Product_Controller__r);
    }

    return sfProductMap;
  }
 
   public Set<Id> fetchEntitledSitesofUser(String connectSiteId,String connectId) {
    Set<Id> entitledSites = new Set<Id>();
   //List<String> sitesOfUser = l7Svc.getSitesForUser(connectSiteId, connectId);
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.CCCache');
    String cacheKey = CC_Utils.removeNonAlphChars(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAPID__c);
     List<String> sitesOfUser = (List<String>) sessionPart.get(CC_CacheSitesAndProductsInfo.class, cacheKey+'SitesFromER');
     System.debug('***sitesOfUserFromClassicER - After CacheCall:'+sitesOfUser);
        if(sitesOfUser.get(0) == 'NoSitesFound' ){
              sitesOfUser.clear();
        }
        System.debug('***sitesOfUser:'+sitesOfUser);

    if( sitesOfUser!= null && sitesOfUser.size() >0 ){
        Set<String> projectSiteIds = new Set<String>();
        Set<String> normalSiteIds = new Set<String>();

        for(String s : sitesOfUser) {
          s=s.removeStart('"');
          s = s.removeEnd('"'); 
          String paddedSiteId = CC_Utils.padSiteId(s);
          if ( Integer.valueOf(paddedSiteId) >= 8000000 && Integer.valueOf(paddedSiteId) <= 8888887 ) {
            projectSiteIds.add(paddedSiteId);
          } 
          else {
            normalSiteIds.add(paddedSiteId);
          }
        }

        for(Site_Association__c siteAssoc : [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c IN :normalSiteIds]) {
                entitledSites.add(siteAssoc.Id);
        }
        for(Project_Site_Association__c projectSiteAssoc : [select id,Name, Project_ID__c,Site_Association__c from Project_Site_Association__c where Project_ID__c IN :projectSiteIds]) {
                entitledSites.add(projectSiteAssoc.Id);
        }
    }


    return entitledSites;
  }

  private Set<Id> fetchEntitledSites(Id contactId) {
    return CC_ngTurkeyController.entitledSitesofUser;
  }
     public boolean hasAccesstoThisSiteandProductFromEER(String connectId,Case fetchedCase, Id siteId){
         System.debug('In hasAccesstoThisSiteandProductFromEER...');
            Map<String,Set<String>> prodAndsiteIdMap = l7Svc.getSitesAndProductsFromEER(CC_ngTurkeyController.currentUser.Contact.Email);
            
            if(prodAndsiteIdMap != null ){      
                if(fetchedCase == null){ //Enters this block only in case creation scenario
                        List<String> userSiteList = new List<String>(); //prodAndsiteIdMap.values();
                    for(Set<String> siteList : prodAndsiteIdMap.values()){
                        userSiteList.addAll(siteList);
                    }
                        Map<Id,Site_Association__c> siteAssocList = new Map<Id,Site_Association__c>([select id, SC_TOPS_ID__c from Site_Association__c where SC_TOPS_ID__c IN :userSiteList]);
                        if(siteAssocList.containsKey(siteId)){
                          return true;
                        }
                        return false;
                } else {
                        String case_prodName = fetchedCase.CA_Product_Controller__r.Name;
                        String case_siteID = fetchedCase.Site_Association__r.SC_TOPS_ID__c;              
                        if( prodAndsiteIdMap.containsKey(case_prodName)){
                          if( prodAndsiteIdMap.get(case_prodName).contains(case_siteID) && connectId == fetchedCase.Contact.SC_CONTACT_LDAPID__c){
                            return true;
                          }
                          return false;
                        } 
                }
            } 
            return false;
     }

  private void validateCaseAccess(Id caseId) {
      Case fetchedCase = [SELECT ID, Case_Type__c, Site_Association__c,Project_Site_Association__c,CA_Product_Controller__c,CA_Product_Controller__r.Name,Site_Association__r.SC_TOPS_ID__c,Contact.SC_CONTACT_LDAPID__c FROM Case WHERE ID = :caseId];
      if(CC_ngTurkeyController.hasSaasUserRole && hasAccesstoThisSiteandProductFromEER( connectId,fetchedCase,null))
          return;
      else {          
          if(fetchedCase.Case_Type__c == 'Project')
              validateSiteAccess(fetchedCase.Project_Site_Association__c);
          else 
              validateSiteAccess(fetchedCase.Site_Association__c);
      }
  }

  private void validateSiteAccess(ID siteId) {
        log.debug('returning without validation. checkSiteValidation'+checkSiteValidation);
      if (!checkSiteValidation){
          return;
      }      
    if(!canSearchAcrossSites)
    {  
        Set<Id> entitledSites = fetchEntitledSites(this.contactId);
        if (!entitledSites.contains(siteId)) {
          throw new ValidationException('You do not have access to this case.');
        }
    }
  }

  private void validateCaseCreate(Case aCase) {
    String[] validationErrors = new String[]{};
    checkRequiredFields(validationErrors, aCase);
    checkSeverity(validationErrors, aCase.Severity__c);
    if (aCase.Severity__c == '1') {
      validationErrors.add('Cannot create a case with severity "1"');
    }
    throwValidationError(validationErrors);
    log.debug('validating the site access. case site id='+aCase.Site_Association__c ); 
    if (aCase.Site_Association__c !=CC_Settings.defaultSiteIDforNoAccess)  
     if(aCase.Case_Type__c == 'Project'){
              validateSiteAccess(aCase.Project_Site_Association__c);
          } else {
              validateSiteAccess(aCase.Site_Association__c);
          }
    log.debug('site access validated.');  
  }

  private void checkRequiredFields(String[] validationErrors, Case aCase) {
    String[] missingFields = new String[]{};
    for (String field : caseRequiredFields) {
      String value = String.valueOf(aCase.get(field));
      if (aCase.get(field) == null || String.isBlank(value)) {
        missingFields.add(field);
      }
    }
    if (missingFields.size() > 0) {
      validationErrors.add('Missing required fields: ' + String.join(missingFields, ', '));
    }
  }

  private void checkSeverity(String[] validationErrors, String severity) {
    if (!validSeverities.contains(severity)) {
      validationErrors.add('Severity "' + severity + '" is invalid');
    }
  }

  private void validateCaseCommentCreate(CaseComment aCaseComment) {
    String[] validationErrors = new String[]{};

    // validate case comment body is not blank
    String value = aCaseComment.CommentBody;
    if(aCaseComment.CommentBody == null || String.isBlank(value)){
      validationErrors.add('Missing required fields: CommentBody');
    }
    throwValidationError(validationErrors);
    validateCaseAccess(aCaseComment.ParentId);
  }

  private void throwValidationError(String[] validationErrors) {
    if (validationErrors.size() > 0) {
      throw new ValidationException().fromErrors(validationErrors);
    }
  }

  public class CaseActivityRecord
  {
    public String commentBody {get;set;}
    public DateTime commentDateTime {get;set;}
    public String commentCreatedBy {get;set;}
    public boolean commentIsPublished {get;set;}
    public boolean htmltemp {get;set;}
    public String getNormalizedCommentBody()
    {
      String s3 = this.commentBody;
      s3=s3.escapeUnicode(); 
      /*s3 = s3.replace('\\', '\\\\');
      s3 = s3.replace('\n', '\\n');
      s3 = s3.replace('\r', '\\r');
      s3 = s3.replace('\t', '\\t');
      s3 = s3.replace('<', '&lt;');            
      s3 = s3.replace('\"', '\\"');
      s3 = s3.replace('\u001a', ''); */
      return s3;    
    }    
  }

  public class CaseSearchCriteria {
    public String caseNumber {get;set { caseNumber = String.escapeSingleQuotes(value); }}
    public String title {get;set { title = String.escapeSingleQuotes(value); }}
    public String contactEmail {get;set { contactEmail = String.escapeSingleQuotes(value); }}
    public String status {get;set { status = String.escapeSingleQuotes(value); }}
    public String severity {get;set { severity = String.escapeSingleQuotes(value); }}
    public Id product {get;set;}
    public Id site {get;set;}
    public String topsSiteID {get;set;}
    public DateTime createdDateFrom {get;set;}
    public DateTime createdDateTo {get;set;}
    public DateTime lastModifiedDateFrom {get;set;}
    public DateTime lastModifiedDateTo {get;set;}
    public Id contactId {get;set;}
    public String[] buildClauses(boolean viewPrivate) {
      String[] clauses = new String[]{};
      if(!viewPrivate)
      {
        clauses.add('Internal_CA__c = false');
      }      
      if (this.caseNumber != null) {
        clauses.add('CaseNumber LIKE \'%' + this.caseNumber + '%\'');
      }
      if (this.title != null) {
        clauses.add('Subject LIKE \'%' + this.title + '%\'');
      }
      if (this.contactEmail != null) {
        clauses.add('Contact.Email LIKE \'%' + this.contactEmail + '%\'');
      }
      if (this.status != null) {
        //DE310729 - Cases with status of Verify are not being returned when performing case search 
        if(this.status == 'Open'){
            clauses.add( '(Status = \''+ System.Label.Case_Status_Verify + '\'  OR  Status = \'' + this.status + '\')');
        } else
          clauses.add('Status = \'' + this.status + '\'');
      }
      if (this.severity != null) {
        clauses.add('Severity__c = \'' + this.severity + '\'');
      }
      if (this.product != null) {
        clauses.add('CA_Product_Controller__c = \'' + this.product + '\'');
      }
      if (this.createdDateFrom != null) {
        //clauses.add('CreatedDate >= ' + this.createdDateFrom.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.sssZ'));
        clauses.add('CreatedDate >= ' + formatDateToString(this.createdDateFrom));
      }
      if (this.createdDateTo != null) {
        //clauses.add('CreatedDate <= ' + this.createdDateTo.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.sssZ'));
       clauses.add('CreatedDate <= ' + formatDateToString(this.createdDateTo));
      }
      if (this.lastModifiedDateFrom != null) {
        //clauses.add('LastModifiedDate >= ' + this.lastModifiedDateFrom.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.sssZ'));
        clauses.add('LastModifiedDate >= ' + formatDateToString(this.lastModifiedDateFrom));
      }
      if (this.lastModifiedDateTo != null) {
        //clauses.add('LastModifiedDate <= ' + this.lastModifiedDateTo.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.sssZ'));
        clauses.add('LastModifiedDate <= ' + formatDateToString(this.lastModifiedDateTo));
      }

       if(! CC_ngTurkeyController.isPartnerUser) {
           if (this.contactId != null) {
                  clauses.add('ContactId = \'' + this.contactId + '\'');
          }
       }

   


      return clauses;
    }

    public String formatDateToString(DateTime dt){
        String formattedDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        formattedDateTime = formattedDateTime.replace(' ','T');
        formattedDateTime = formattedDateTime+'Z';
        return formattedDateTime;
    }
      
  }

 
  public class ValidationException extends Exception {
    public String[] errors { get; private set; }
    public ValidationException fromErrors(String[] validationErrors) {
      String message = 'Validation errors: ' + String.join(validationErrors, ', ');
      ValidationException ex = new ValidationException(message);
      ex.errors = validationErrors;
      return ex;
    }
  }

  public without sharing class CasesData {

    private String[] fieldsCasesFlyweight = new String[] {
      'Id'
      ,'Business_Impact__c'
      ,'CA_Product_Controller__c'
      ,'CaseNumber'
      ,'ContactId'
      ,'CreatedDate'
      ,'Confidential_Attachments__c'
      ,'ClosedDate'
      ,'Description'
      ,'Resolution__c'
      ,'LastModifiedDate'
      ,'OwnerId'
      ,'Severity__c'
      ,'Status'
      ,'Subject'
      ,'Next_Action__c'
      ,'Product_Area__c'
      ,'Product_Area__r.Name'
      ,'CA_Product_Controller__r.Name'
      ,'CA_Product_Controller__r.Case_Concern_Allowed__c'
      ,'ParentId'
      ,'Contact.Email'
      ,'Site_Association__c'
      ,'Site_Association__r.Name'
      ,'Site_Association__r.SC_TOPS_ID__c'
      ,'Alternate_OS__c'
      ,'CA_Product_Component__c'
      ,'Product_Release_Selection__c'
      ,'Component_Release_Selection__c'
      ,'recordTypeId'
      ,'recordType.Name'
      ,'Product_Material__c'
      ,'Contact.Name'
      ,'Contact.Phone'
      ,'Contact.SC_CONTACT_Preferred_Contact_Method__c'
      ,'Contact.SC_CONTACT_LDAPID__c'    
      ,'Internal_CA__c'
      ,'Project_Site_Association__c'
      ,'Project_Site_Association__r.Name'
      ,'Project_ID__c'
      ,'Case_Type__c'
      ,'Tops_Support_Site_ID__c'
      ,'Case_mgmt_LastUpdateDT__c'
      ,'Case_mgmt_LastUpdatedBy_User__c'
      ,'Case_mgmt_LastUpdatedBy_User__r.ContactId'
      ,'(select id,Case__c,Contact_Information__c,Last_Viewed_Date__c from Activity_Tracking__r where Contact_Information__c = \'' +CC_ngTurkeyController.currentUser.contact.Id  + '\')'
      ,'(SELECT Portal_View_Date__c FROM Case_Portal_Views__r ORDER BY Portal_View_Date__c DESC LIMIT 1)'
    };

    private String[] fieldsCaseComment = new String[]{
      'Id', 
      'ParentId', 
      'CommentBody', 
      'CreatedBy.Name', 
      'CreatedDate',
      'IsPublished'
    };
    private String[] fieldsCaseKBArticles = new String[]{
      'KB_Article__r.KB_Article_No__c', 
      'KB_Article__r.KB_Article_Link__c', 
      'KB_Article__r.KB_Article_Title__c', 
      'KB_Article__r.Status_Change_Date__c'
    };
   private String[] fieldsCaseRelatedContent = new String[]{
      'name',
      'Source__c', 
      'Title__c',
      'URL__c',
      'LastModifiedDate'  
    };
    private String[] fieldsCaseExternalReq = new String[]{
      'Subject__c', 
      'Reference_ID__c', 
      'Component_ID__c', 
      'Solution_Type__c', 
      'Component_Release__c',
      'External_System__c',
      'Type__c',
      'CreatedDate'    
    }; 
    private String[] fieldsCasesFull = concatLists(fieldsCasesFlyweight, new String[] {
      /*'(SELECT ' + String.join(fieldsCaseComment, ', ') +
        ' FROM CaseComments' +
        ' ORDER BY CreatedDate DESC) '
      ,*/'(SELECT ' + String.join(fieldsCaseKBArticles, ', ') +
        ' FROM KB_Article__r ' +
        ' WHERE KB_Article__r.Status__c=\'PUBLISHED\' ) '  
          
      ,'(SELECT ' + String.join(fieldsCaseRelatedContent, ', ') +
        ' FROM CaseKnowledgeArticles__r WHERE Source__c IN  (\'Recommended Reading\',\'Product Status\',\'Guides\',\'Communities\',\'Solutions\',\'Documentation\') )' 
      ,'(SELECT ' + String.join(fieldsCaseExternalReq, ', ') +
      ' FROM external_RnDs__r where External_System__c=\'STAR\' AND Type__c=\'Solution\' AND Reference_ID__c != \'\' )' 
      ,'(SELECT Id' +
            ',Type' +
            ',Due_Date_SLO__c' +
            ',CallBackEndTime__c' +
        ' FROM Tasks' +
        ' WHERE Type IN (\'Initial Callback\', \'Workaround\', \'Resolution\'))' 
       });

    private String[] concatLists(String[] list1, String[] list2) {
      String[] newList = new List<String>(list1);
      newList.addAll(list2);
      return newList;
        
    }
   
   public Case[] fetchCasesByCriteriaFlyweight(Set<Id> entitledSites,Set<Id> entitledSitesFromEER, Map<String,Set<String>> prodAndsiteIdMapFromEER, CaseSearchCriteria criteria, boolean canSearchAcrossSites, boolean viewPrivate) {
        return fetchCasesByCriteriaFlyweight(entitledSites,entitledSitesFromEER, prodAndsiteIdMapFromEER , criteria, canSearchAcrossSites, viewPrivate, false);
    }

    //public Case[] fetchCasesByCriteriaFlyweight(Set<Id> entitledSites, CaseSearchCriteria criteria, boolean canSearchAcrossSites, boolean viewPrivate, boolean allCases) {
    public Case[] fetchCasesByCriteriaFlyweight(Set<Id> entitledSites, Set<Id> entitledSitesFromEER, Map<String,Set<String>> prodAndsiteIdMapFromEER, CaseSearchCriteria criteria, boolean canSearchAcrossSites, boolean viewPrivate, boolean allCases) { //, boolean fromMyCases
      String soql = '';
      if(!allCases){
      soql = 'SELECT ' + String.join(fieldsCasesFlyweight, ', ') + ' FROM Case';}else{
      soql = 'SELECT casenumber, Case_Type__c,contact.name,contact.email,Contact.SC_CONTACT_LDAPID__c, subject, status, severity__c, CA_Product_Controller__r.Name,  Project_Site_Association__r.Name, Project_ID__c, Site_Association__r.Name, Site_Association__r.SC_TOPS_ID__c, CreatedDate, LastModifiedDate FROM Case';
      }
      String[] clauses = criteria.buildClauses(viewPrivate);
      Set<Id> normalSiteIds = new Set<Id>();
      Set<Id> projectSiteIds = new Set<Id>();
       
      
       String[]  subclauses = new List<String>();
       if(prodAndsiteIdMapFromEER != null && prodAndsiteIdMapFromEER.size()>0){
           for(String prodName : prodAndsiteIdMapFromEER.keySet()){
               Set<String> temp = prodAndsiteIdMapFromEER.get(prodName) ;
               subclauses .add ('(CA_Product_Controller__r.Name =  \'' + prodName  + '\' AND Site_Association__r.SC_TOPS_ID__c IN :temp   AND ContactId = \''+ CC_ngTurkeyController.currentUser.ContactId + '\')' );
           }
       }      
        String siteProductClause = String.join(subclauses, ' OR ') ;
        System.debug('siteProductClause:'+siteProductClause);
       
//if(!fromMyCases){ ////***Tensor - if block starts            
          if (entitledSites == null) {
            entitledSites = new Set<Id>();
          } else {
           for(Id siteId : entitledSites) {
               if(siteId.getSobjectType() == Project_Site_Association__c.sObjectType) {
                      projectSiteIds.add(siteId);
               } else if(siteId.getSobjectType() == Site_Association__c.sObjectType) {
                      normalSiteIds.add(siteId);
               }
           }
        }
        System.debug('projectSiteIds:'+projectSiteIds);
        System.debug('normalSiteIds:'+normalSiteIds);
    
       // if( !(CC_ngTurkeyController.isPartnerUser && CC_ngTurkeyController.invocationPath.contains('fetchMyCases') ) ) {  //For Partner Users MyCases - Skip entitled sites check
        //  System.debug('Entered the entitled check of sites in SOQL clauses...');
        if( (!canSearchAcrossSites) || (canSearchAcrossSites && criteria.caseNumber==null)  )
        {             
            if(CC_ngTurkeyController.isCAInternalSG && criteria.topsSiteID != null){
                String topsSiteID = CC_Utils.padSiteId(criteria.topsSiteID) ;
                if ( Integer.valueOf(topsSiteID) >= 8000000 && Integer.valueOf(topsSiteID) <= 8888887 ) {
                    clauses.add('Project_ID__c = \'' + topsSiteID + '\'');
                }
                else {
                    clauses.add('Tops_Support_Site_ID__c = \'' + topsSiteID + '\'');
                }
            }
            else if(criteria.site != null) {
                if( entitledSites!=null && entitledSites.size()>0 && entitledSites.contains(criteria.site)){ //***Added for Tensor
                    System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');                    
                    if(criteria.site.getSobjectType() == Project_Site_Association__c.sObjectType)
                        clauses.add('Project_Site_Association__c = \'' + criteria.site + '\'');
                    else if(criteria.site.getSobjectType() == Site_Association__c.sObjectType)
                        clauses.add('Site_Association__c = \'' + criteria.site + '\'');
                }else if( prodAndsiteIdMapFromEER!=null && prodAndsiteIdMapFromEER.size()>0 && entitledSitesFromEER.contains(criteria.site) ){  //***Added for Tensor
                    System.debug('!!!!!!!!!!!Tensor Site Check Block1!!!!!!!!!!!!!!');
                    String tempQStr1 =  '( (Site_Association__c = \'' + criteria.site + '\'' + 'AND ContactId = \'' + CC_ngTurkeyController.currentUser.ContactId + '\')' ;
                     tempQStr1 += ' AND ' + siteProductClause + ')';
                     clauses.add(tempQStr1);
                }
            }
            else {
                //clauses.add(' ( (Project_Site_Association__c=\'\' AND  Site_Association__c IN :normalSiteIds) OR (Project_Site_Association__c IN :projectSiteIds) )');          
                String tempQStr ='( ( (Project_Site_Association__c=\'\' AND  Site_Association__c IN :normalSiteIds) OR (Project_Site_Association__c IN :projectSiteIds) )';              
                if(prodAndsiteIdMapFromEER!=null && prodAndsiteIdMapFromEER.size()>0 ){
                    tempQStr += ' OR ' + siteProductClause + ')';
                }
                else {  tempQStr += ')';  }
                clauses.add(tempQStr);
            }
        }
       //   } //***Tensor - if block ends

        
       // }//End of if (For Partner Users MyCases - Skip entitled sites check)

        //DE310769 - Case Type / Case Origin = Chat / Chat should not been seen by Portal users and is seen       
        clauses.add( '(  (origin = \'Chat\' AND Case_Type__C != \'Chat\' ) OR (origin != \'Chat\' AND Case_Type__C != \'Chat\') )' );
        
        
        List<String> restrictedRecordTypes = CC_Settings.restrictedRecordTypes;
        clauses.add(' (RecordTypeID NOT IN :restrictedRecordTypes) ');
        
      soql += ' WHERE ' + String.join(clauses, ' AND ');
      
      String soqlPendingCustomerCases =  soql + ' AND Case_Type__c!=\'Proactive\' AND Next_Action__c = \'Pending Customer\''; 
      soqlPendingCustomerCases += ' ORDER BY LastModifiedDate DESC';
      if(!allCases)
      {      
          soqlPendingCustomerCases+= ' LIMIT ' + CC_Settings.caseSearchMaxResults;
      }
      else
      {
          soqlPendingCustomerCases+= ' LIMIT ' + CC_Settings.caseExcelMaxResults;
      }
      System.debug('soqlPendingCustomerCases:'+soqlPendingCustomerCases);

      Case[] casesPendingCustomer =  Database.query(soqlPendingCustomerCases);

      soql += ' AND Case_Type__c!=\'Proactive\' AND Next_Action__c NOT IN ( \'Pending Customer\'  ) '; 
      soql += ' ORDER BY LastModifiedDate DESC';
      if(!allCases)
      {       
          soql+= ' LIMIT ' + (CC_Settings.caseSearchMaxResults - casesPendingCustomer.size());
      }
      else
      {
          soql+= ' LIMIT ' + (CC_Settings.caseExcelMaxResults - casesPendingCustomer.size());    
      }
      System.debug('soql:'+soql);
      Case[] cases2 =  Database.query(soql);
        
        Case[] caseResults;
        
        if( casesPendingCustomer != null && casesPendingCustomer.size()>0 ){
            casesPendingCustomer.addAll(cases2);
            caseResults = casesPendingCustomer;
        } else {
            caseResults = cases2;
        }
        
      if(!caseResults.isEmpty())
        System.debug('caseResults.size():'+caseResults.size());  
      return caseResults;
        
      /*soql += ' WHERE ' + String.join(clauses, ' AND ');
      soql += ' ORDER BY LastModifiedDate DESC';
      soql+= ' LIMIT ' + CC_Settings.caseSearchMaxResults;
      System.debug('soql:'+soql);
      return Database.query(soql); */
    }
     
    public Case fetchCaseById(Id caseId) {
        String soql = 'SELECT ' + String.join(fieldsCasesFull, ', ') + ' FROM Case';
      soql += ' WHERE Id = :caseId AND Case_Type__c!=\'Proactive\' ';
      Case[] cases = Database.query(soql);
      if (cases.size() > 0) {
        return cases[0];
      }
      return null;
    }

    public CaseComment fetchCaseCommentById(Id commentId) {
      String soql = 'SELECT ' + String.join(fieldsCaseComment, ', ') + ' FROM CaseComment';
      soql += ' WHERE Id = :commentId';
      CaseComment[] comments = Database.query(soql);
      if (comments.size() > 0) {
        return comments[0];
      }
      return null;
    }

    public Contacts_Site_Association__c[] fetchContactSiteAssociations(Id contactId) {
      return [SELECT SC_CSA_CONTACTS__c
                    ,SC_CSA_SITE__c
                    ,SC_CSA_ACTIVE_ON_SITE__c 
              FROM Contacts_Site_Association__c 
              WHERE SC_CSA_CONTACTS__c = :contactId];
    }
  }
    
    public class AllSites {
      public String Name;
      public Id Id;
      public String siteId;
      public String siteType;
      public AllSites(String name, Id sfId, String siteId, String siteType){
          this.Name = name + ' (' + siteId + ')';
          this.Id = sfId;
          this.siteId = siteId;
          this.siteType = siteType;
      }
   }
   /*
  public class ProductAreas {
      public String Name;
      public Id Id;
      public Id compId;
      public ProductAreas(String name, Id sfId, Id sfCompId){
          this.Name = name;
          this.Id = sfId;
          this.compId = sfCompId;
      }
   } */
  
     //US388915
    public class SiteProductAssociation {
        public CA_Product_Controller__c product {get; set;}
        //public AllSites site {get; set;}
        public List<AllSites> siteList {get; set;}
        public Product_Area__c productArea { get; set;} //***Newly added - PA Changes
        
        public SiteProductAssociation(List<AllSites> sitelist, CA_Product_Controller__c product, Product_Area__c productArea) { //PA Changes 
            this.sitelist = sitelist;
            this.product = product;
            this.productArea = productArea; //***Newly added - PA Changes
        }
        public Boolean isValid() {
            
            return product != null && sitelist != null;
        } 
    }
    
    public class ProductWithSite {
        public Product_Area__c productArea { get; set;}        
        public AllSites sites {get; set;}        
    } 
    
    public List<CaseActivityRecord> retriveParsedComments(String Privatecommentsresp,ID caseId){
      List <CaseActivityRecord> actList = new List<CaseActivityRecord>();
      /* We have a special scenario where one of the comment itself having string like 'oss\jts\integration\main\narayana-jts-integration' which is having the \n in it which is valid
      but JSON is unable to recognize it and throrowin error. to handle this, we are replaceing it with @@@ and after the deserialze, replacing back to the \n */
      Privatecommentsresp=Privatecommentsresp.replace('\\<br/>','@@@');
      System.debug('Privatecommentsresp2='+Privatecommentsresp); 
      try{
        List<CC_ngTurkeyController.CaseCommentType> tt =   (List<CC_ngTurkeyController.CaseCommentType>)System.JSON.deserialize(Privatecommentsresp, List<CC_ngTurkeyController.CaseCommentType>.class);                    
                for(CC_ngTurkeyController.CaseCommentType t : tt){
                    CaseActivityRecord myCaseActivity = new CaseActivityRecord();
                    myCaseActivity.commentBody= t.CommentBody.replace('@@@', '\\n');
                    myCaseActivity.commentBody= myCaseActivity.commentBody.replace('<br/>', '\n');
                    myCaseActivity.commentDateTime=DateTime.valueofGMT(t.CreatedDate.replace('T',' '));
                    myCaseActivity.commentCreatedBy=t.CreatedBy.Name;
                    myCaseActivity.commentIsPublished=false;    
                    System.debug('****myCaseActivity='+myCaseActivity); 
                    actList.add(myCaseActivity); 
                }
                return actList;
       }catch(Exception e){ CC_ngTurkeyController.prepareErrorLogRecord('Error for Case:'+ caseId + ' \n ' +e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , 'CC_ngTurkeyService.retriveParsedComments' , false); return actList; }         
    }      
    
}