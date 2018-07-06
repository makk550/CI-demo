public class AccountView extends SalesCoachAbstractBase {
    private final Account ac;
    public AccountView(ApexPages.StandardController stdController) {
        ac = [Select Name, Website, BillingState, BillingCountry from Account WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }   
    
    public override String getCampaigns() {
    	return '';
    }
    
    public override String getABMRequestURL() {
        system.debug('START getABMRequestURL()');
        
        //Mintigo_Account_Market__c market = Mintigo_Account_Market__c.getOrgDefaults();
        Mintigo_Account_Market__c market = Mintigo_Account_Market__c.getInstance(); 
        
        //String url_template = 'https://demo.devtigo.com/api/v1.0/enrich_sales/bd8636a97efb48c8bb8c28adfab90426?customer_company_name={0}&state={1}&url={2}&country={3}&multiprod={4}';   
        String url_template = market.Mintigo_API_URL__c + '/api/v1.0/enrich_sales/' + getABMMarketID() + '?customer_company_name={0}&state={1}&url={2}&country={3}';
     
        String company_name = system.EncodingUtil.urlEncode(nullToEmpty(ac.Name), 'UTF-8');
        String state = system.EncodingUtil.urlEncode(nullToEmpty(ac.BillingState), 'UTF-8');           
        String url = system.EncodingUtil.urlEncode(nullToEmpty(ac.Website), 'UTF-8');
        String country = system.EncodingUtil.urlEncode(nullToEmpty(ac.BillingCountry), 'UTF-8');
        
        List<String> fillers = new String[]{company_name, state, url, country};
       
        String request_url = String.format(url_template, fillers);

        // Append user parameters
        request_url = request_url + getUserDetailsParams(ac.Id);        
        return request_url;
   }
   
   public override String getLBMRequestURL() {
        return 'Not Implemented';
   }
  
}