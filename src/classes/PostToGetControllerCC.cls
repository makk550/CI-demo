public class PostToGetControllerCC {

    public String redirect {get;set;}

    public PostToGetControllerCC() {
    
    
       Organization  orgDetails = [SELECT Id, IsSandbox , InstanceName , Name  FROM Organization WHERE Id = : UserInfo.getOrganizationId()];

        System.debug('or'+orgDetails);
        
        if (orgDetails != null )   {
            
            if (orgDetails.isSandbox == true )
            {      
                   String sandboxname = UserInfo.getUserName().substringAfterLast('.');  
                   system.debug('################'+sandboxname);
                   redirect = 'https://samlgwsm-qa.ca.com/affwebservices/public/saml2sso?SPID=https://customer-'+'fsb1.saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
            } else {
                   redirect = 'https://samlgwsm.ca.com/affwebservices/public/saml2sso?SPID=https://customer.saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
                //System.debug('Prod URl here');
            
            }
        
        } // end not null;
    
       
       
    }
    
}