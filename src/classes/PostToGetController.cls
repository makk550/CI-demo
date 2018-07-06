public class PostToGetController {

    public String redirect {get;set;}

    public PostToGetController() {
    
    
       Organization  orgDetails = [SELECT Id, IsSandbox , InstanceName , Name  FROM Organization WHERE Id = : UserInfo.getOrganizationId()];

        System.debug('or'+orgDetails);
        
        if (orgDetails != null )   {
            
            if (orgDetails.isSandbox == true )
            {        
                   redirect = 'https://samlgwsm-qa.ca.com/affwebservices/public/saml2sso?SPID=saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
            } else {
                   redirect = 'https://samlgwsm.ca.com/affwebservices/public/saml2sso?SPID=saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
                //System.debug('Prod URl here');
            
            }
        
        } // end not null;
    
       
       
    }
    
}