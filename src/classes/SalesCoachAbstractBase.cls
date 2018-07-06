public abstract class SalesCoachAbstractBase {
    
    public static String nullToEmpty(String value) {
        if (value == null) {
            return '';
        }
       
        return value;
    }
    
    protected abstract String getCampaigns();
    
    protected String getUserDetailsParams(Id objectId) {
        // Bookkeeping
        String user_crm_id = system.EncodingUtil.urlEncode(UserInfo.getUserId(), 'UTF-8');
        String user_crm_email = system.EncodingUtil.urlEncode(UserInfo.getUserEmail(), 'UTF-8');
        String user_crm_firstname = system.EncodingUtil.urlEncode(UserInfo.getFirstName(), 'UTF-8');
        String user_crm_lastname = system.EncodingUtil.urlEncode(UserInfo.getLastName(), 'UTF-8');
        String object_crm_url = system.EncodingUtil.urlEncode(System.URL.getSalesforceBaseURL().toExternalForm() + '/' + objectId, 'UTF-8');
            	
        List<String> fillers = new String[]{user_crm_id, user_crm_email, user_crm_firstname, user_crm_lastname, object_crm_url};
        
        String url_template = '&user_crm_id={0}&user_crm_email={1}&user_crm_firstname={2}&user_crm_lastname={3}&object_crm_url={4}';
        
        String params = String.format(url_template, fillers);
        
        return params;
    }
    
    protected String getABMMarketID() {
        // Get Market ID from 'Custom Settings'
        Mintigo_Account_Market__c market = Mintigo_Account_Market__c.getInstance();
        
        String market_id = market.Market_ID__c;
        
        // Try to get Market ID from 'User Object'
        User current_user_obj = [Select ABM_Market_ID__c from User where id = :UserInfo.getUserId()];
        
        if (!String.isBlank(current_user_obj.ABM_Market_ID__c)) {
            market_id = current_user_obj.ABM_Market_ID__c;
        }
        return market_id;       
    }
    
    protected String getLBMMarketID() {
        // Get Market ID from 'Custom Settings'
        Mintigo_Lead_Market__c market = Mintigo_Lead_Market__c.getInstance();
        
        String market_id = market.Market_ID__c;
        
        // Try to get Market ID from 'User Object'
        User current_user_obj = [Select LBM_Market_ID__c from User where id = :UserInfo.getUserId()];
        
        if (!String.isBlank(current_user_obj.LBM_Market_ID__c)) {
            market_id = current_user_obj.LBM_Market_ID__c;
        }
        return market_id;       
    }        
    
    public abstract String getLBMRequestURL();
    
    public abstract String getABMRequestURL();
    
    public String getLBMHTML() {
        system.debug('START getLBMHTML()');
        
        String request_url = getLBMRequestURL();  
        
        system.debug('URL:' +  request_url);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(request_url);
        req.setMethod('GET');
        req.setTimeout(30000);
        System.Http http = new Http();
        System.HttpResponse response = http.send(req);
           
        system.debug('RESP::' + response.getBody());
       
        return response.getBody();      
    }
    
    public String getABMHTML() {
        system.debug('START getABMHTML()');
        
        String request_url = getABMRequestURL();  
        
        system.debug('URL:' +  request_url);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(request_url);
        req.setMethod('GET');
        req.setTimeout(30000);
        System.Http http = new Http();
        System.HttpResponse response = http.send(req);
           
        system.debug('RESP::' + response.getBody());
       
        return response.getBody();      
    }
}