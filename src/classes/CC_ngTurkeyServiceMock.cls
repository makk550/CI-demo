@IsTest
public class CC_ngTurkeyServiceMock implements CC_ngTurkeyService.I {
 
  public CC_MockCallRecorder callLogger { get; private set; }

  public CC_ngTurkeyServiceMock() {
    callLogger = new CC_MockCallRecorder();
  }

  public Case[] fetchMyCases() {
    String methodName = 'fetchMyCases';
    Map<String, Object> params = new Map<String, Object> {};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Case[])returnValue;
  }
  public Case[] fetchCasesByCriteria(CC_ngTurkeyService.CaseSearchCriteria criteria) {
    String methodName = 'fetchCasesByCriteria';
    Map<String, Object> params = new Map<String, Object> {'criteria' => criteria};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Case[])returnValue;
  }
  public Case fetchCaseById(Id caseId) {
    String methodName = 'fetchCaseById';
    Map<String, Object> params = new Map<String, Object> {'caseId' => caseId};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Case)returnValue;
  }
  public User[] fetchCaTechniciansForCases(Case[] cases) {
    String methodName = 'fetchCaTechniciansForCases';
    Map<String, Object> params = new Map<String, Object> {'cases' => cases};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (User[])returnValue;
  }
  public CC_ngTurkeyService.SiteProductAssociation[] fetchSitesAndProducts(String siteId, String connectId) {
    String methodName = 'fetchSitesAndProducts';
    Map<String, Object> params = new Map<String, Object> {'siteId' => siteId, 'connectId' => connectId};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (CC_ngTurkeyService.SiteProductAssociation[])returnValue;
  }
  public Case createCase(Case aCase) {
    String methodName = 'createCase';
    Map<String, Object> params = new Map<String, Object> {'aCase' => aCase};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Case)returnValue;
  }
  public Case createCaseConcern(Case aCase) {
    String methodName = 'createCaseConcern';
    Map<String, Object> params = new Map<String, Object> {'aCase' => aCase};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (Case)returnValue;
  }
  public CC_ngturkeyController.CaseCommentType addCaseComment(CaseComment caseComment) {
    String methodName = 'addCaseComment';
    Map<String, Object> params = new Map<String, Object> {'caseComment' => caseComment};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (CC_ngturkeyController.CaseCommentType)returnValue;
  }

  public void changeSeverity(Id caseId, String newSeverity, String commentBody) {
    String methodName = 'changeSeverity';
    Map<String, Object> params = new Map<String, Object> {'caseId' => caseId, 'newSeverity' => newSeverity, 'commentBody' => commentBody};
    callLogger.getRecordedCall(methodName, params);
    callLogger.logCall(methodName, params, null);
  }

  public void closeCase(Id caseId, String commentBody) {
    String methodName = 'closeCase';
    Map<String, Object> params = new Map<String, Object> {'caseId' => caseId, 'commentBody' => commentBody};
    callLogger.getRecordedCall(methodName, params);
    callLogger.logCall(methodName, params, null);
  }

  public void reopenCase(Id caseId, String commentBody) {
    String methodName = 'reopenCase';
    Map<String, Object> params = new Map<String, Object> {'caseId' => caseId, 'commentBody' => commentBody};
    callLogger.getRecordedCall(methodName, params);
    callLogger.logCall(methodName, params, null);
  }

  public void updateConfAtth(Id caseId, Boolean stat) {
    String methodName = 'updateConfAtth';
    Map<String, Object> params = new Map<String, Object> {'caseId' => caseId, 'stat' => stat};
    callLogger.getRecordedCall(methodName, params);
    callLogger.logCall(methodName, params, null);
  }

  public CA_Product_Controller__c fetchRecentProduct(List<Id> productIdList){
    String methodName = 'fetchRecentProduct';
    Map<String, Object> params = new Map<String, Object> {'productIdList' => productIdList};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (CA_Product_Controller__c)returnValue;
  }
  public CC_ngTurkeyService.ProductWithSite fetchRecentproductAreaWithSite(List<Id> productIdList){
    String methodName = 'fetchRecentproductAreaWithSite';
    Map<String, Object> params = new Map<String, Object> {'productIdList' => productIdList};
    Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
    callLogger.logCall(methodName, params, returnValue);
    return (CC_ngTurkeyService.ProductWithSite)returnValue;
  } 
    
   public Set<Id> fetchEntitledSitesofUser(String connectSiteId,String connectId) {
        String methodName = 'fetchEntitledSitesofUser';
        Map<String, Object> params = new Map<String, Object> {'connectSiteId' => connectSiteId, 'connectId' => connectId};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (Set<Id>)returnValue;
    }
    
    public List<Object> fetchSites(String connectSiteId, String connectId) {
        String methodName = 'fetchSites';
        Map<String, Object> params = new Map<String, Object> {'connectSiteId' => connectSiteId, 'connectId' => connectId};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (List<Object>)returnValue;
    }
    
    public String fetchCaseActivitiesById(Id caseId) {
        String methodName = 'fetchCaseActivitiesById';
        Map<String, Object> params = new Map<String, Object> {'caseId' => caseId };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (String)returnValue;        
    }

    public String invokeL7GSService(String siteId, String caseNumber) {
         String methodName = 'invokeL7GSService';
        Map<String, Object> params = new Map<String, Object> {'siteId' => siteId , 'caseNumber' => caseNumber };
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (String)returnValue;     
    }

     public boolean getIsRECapabale(String prodName) {
         String methodName = 'getIsRECapabale';
        Map<String, Object> params = new Map<String, Object> {'prodName' => prodName};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (boolean)returnValue;     
    }

    public List<Object> getProductAreas(String productName) {
         String methodName = 'getProductAreas';
        Map<String, Object> params = new Map<String, Object> {'productName' => productName};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (List<Object>)returnValue;     
    }
    
    public List<Case> fetchCasesByCriteria(CC_ngTurkeyService.CaseSearchCriteria criteria, boolean allCases) {
         String methodName = 'fetchCasesByCriteria';
        Map<String, Object> params = new Map<String, Object> {'criteria' => criteria , 'allCases' => allCases};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (List<Case>)returnValue;     
    }
    
    public List<Case> fetchMyCases(boolean allCases) {
         String methodName = 'fetchMyCases';
        Map<String, Object> params = new Map<String, Object> {'allCases' => allCases};
        Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
        callLogger.logCall(methodName, params, returnValue);
        return (List<Case>)returnValue;     
    }

    public Product_Area__c fetchRecentProductArea(List<Id> productIdList) {
         String methodName = 'fetchRecentProductArea';
         Map<String, Object> params = new Map<String, Object> {'productIdList' => productIdList};
         Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
         callLogger.logCall(methodName, params, returnValue);
         return (Product_Area__c)returnValue;     
    }
    
        public boolean hasAccesstoThisSiteandProductFromEER(String connectId,Case fetchedCase, Id siteId) {
         String methodName = 'hasAccesstoThisSiteandProductFromEER';
         Map<String, Object> params = new Map<String, Object> {'connectId' => connectId,'fetchedCase' => fetchedCase,'siteId' => siteId};
         Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
         callLogger.logCall(methodName, params, returnValue);
         return (boolean)returnValue;     
    }


  //public Map<String, Site_Association__c> fetchSiteAssociationsByTopsSiteIds(Set<String> topsSiteIds) {
  //  String methodName = 'fetchSiteAssociationsByTopsSiteIds';
  //  Map<String, Object> params = new Map<String, Object> {'topsSiteIds' => topsSiteIds};
  //  Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
  //  callLogger.logCall(methodName, params, returnValue);
  //  return (Map<String, Site_Association__c>)returnValue;
  //}
  
  //public Map<String, CA_Product_Controller__c> fetchCaProductControllersByProductNames(Set<String> productNames) {
  //  String methodName = 'fetchCaProductControllersByProductNames';
  //  Map<String, Object> params = new Map<String, Object> {'productNames' => productNames};
  //  Object returnValue = callLogger.getRecordedCall(methodName, params).returnValue;
  //  callLogger.logCall(methodName, params, returnValue);
  //  return (Map<String, CA_Product_Controller__c>)returnValue;
  //}
  //public void updateContactSiteAssociations(Id contactId, Set<Id> siteIds) {
  //  String methodName = 'updateContactSiteAssociations';
  //  Map<String, Object> params = new Map<String, Object> {'contactId' => contactId, 'siteIds' => siteIds};
  //  callLogger.getRecordedCall(methodName, params);
  //  callLogger.logCall(methodName, params, null);
  //}
}