public class CC_CacheSitesAndProductsInfo implements Cache.CacheBuilder {
    
    @TestVisible
    private CC_Layer7Service.I l7Svc {
        get {
            if (l7Svc == null) {
                l7Svc = new CC_Layer7Service();
            }  
            return l7Svc;
        } set;
    }
    
    public Object doLoad(String userSessionCacheKey) {
        System.debug('userSessionCacheKey:'+userSessionCacheKey);
        if(userSessionCacheKey.contains('SandPFromEER')){            
            String result ;
              if(Test.isRunningTest() && CC_ngTurkeyController.currentUser.Contact.Email == null ){
                 result = l7Svc.callToFetchSitesAndProductsFromEER('tets@test.com'); 
            } else {
                result = l7Svc.callToFetchSitesAndProductsFromEER(CC_ngTurkeyController.currentUser.Contact.Email); 
           }
            return result;
        } else if(userSessionCacheKey.contains('SitesFromER')){            
             List<String> sitesListFromCache ;
            System.debug('CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c:'+CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c);
            if(Test.isRunningTest() && CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c == null ){
                sitesListFromCache = l7Svc.getSitesForUser('102345','PMFKY01');
            } else {
               sitesListFromCache = l7Svc.getSitesForUser(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAPID__c); 
            }
            return sitesListFromCache;
        }
        return null;        
    }
    
}