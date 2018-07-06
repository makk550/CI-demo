public class ContactView extends SalesCoachAbstractBase {
    private final Contact ac;
    public ContactView(ApexPages.StandardController stdController) {
        ac = [SELECT Id, Name, Email, Title, Account.Name, FirstName, LastName, Account.BillingState, Account.Website, Account.BillingCountry FROM Contact
              WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        
    public override String getCampaigns() {
        String url_template = '&crm_campaigns={0}';
        List<CampaignMember> cms = [Select ContactId, CampaignId from CampaignMember where ContactId = :ac.Id];
        List<String> campaigns = new List<String>();
        for (CampaignMember cm : cms) {
            campaigns.add(cm.CampaignId);
        }
        String campaignsStr = system.EncodingUtil.urlEncode(String.join(campaigns, ','), 'UTF-8');
        List<String> fillers = new String[]{campaignsStr};
        String params = String.format(url_template, fillers);
        return params;
    }        
    
    public override String getABMRequestURL() {
        system.debug('START getABMRequestURL()');
        // getInstance(userId) or getInstance(profileId) or getInstance()
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_custom_settings.htm
        Mintigo_Account_Market__c market = Mintigo_Account_Market__c.getInstance();
        
        String url_template = market.Mintigo_API_URL__c + '/api/v1.0/enrich_sales/' + getABMMarketID() + '?customer_company_name={0}&state={1}&url={2}&country={3}';
        
        String company_name = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.Name), 'UTF-8');
        String state = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.BillingState), 'UTF-8');
        String url = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.Website), 'UTF-8');
        String country = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.BillingCountry), 'UTF-8');
        
        List<String> fillers = new String[]{company_name, state, url, country};
       
        String request_url = String.format(url_template, fillers);      
        
        // Append user parameters
        request_url = request_url + getUserDetailsParams(ac.Id) + getCampaigns();
        return request_url;
    }
    
    public override String getLBMRequestURL() {
        system.debug('START getLBMRequestURL()');
        // getInstance(userId) or getInstance(profileId) or getInstance()
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_custom_settings.htm
        Mintigo_Lead_Market__c market = Mintigo_Lead_Market__c.getInstance();
        
        String url_template = market.Mintigo_API_URL__c + '/api/v1.0/enrich_sales/' + getLBMMarketID() + '?customer_company_name={0}&state={1}&customer_email={2}&contact_first_name={3}&contact_last_name={4}&url={5}&country={6}&customer_title={7}';
     
        String company_name = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.Name), 'UTF-8');
        String state = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.BillingState), 'UTF-8');
           
        String email = ac.Email;
        String first_name = system.EncodingUtil.urlEncode(nullToEmpty(ac.FirstName), 'UTF-8');
        String last_name = system.EncodingUtil.urlEncode(nullToEmpty(ac.LastName), 'UTF-8');
        String url = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.Website), 'UTF-8');
        String country = system.EncodingUtil.urlEncode(nullToEmpty(ac.Account.BillingCountry), 'UTF-8');
        String title = system.EncodingUtil.urlEncode(nullToEmpty(ac.Title), 'UTF-8');
        List<String> fillers = new String[]{company_name, state, email, first_name, last_name, url, country, title};
        
        String request_url = String.format(url_template, fillers);

        // Append user parameters
        request_url = request_url + getUserDetailsParams(ac.Id) + getCampaigns();            
        return request_url;
 
   }
  
}