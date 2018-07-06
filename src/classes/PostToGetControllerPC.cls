public class PostToGetControllerPC {

    public String redirect {get;set;}

    public PostToGetControllerPC() {
    
    
       Organization  orgDetails = [SELECT Id, IsSandbox , InstanceName , Name  FROM Organization WHERE Id = : UserInfo.getOrganizationId()];

        System.debug('or'+orgDetails);
        
        if (orgDetails != null )   {
            
            if (orgDetails.isSandbox == true )
            {      
                   String sandboxname = UserInfo.getUserName().substringAfterLast('.');  
                   redirect = 'https://samlgwsm-qa.ca.com/affwebservices/public/saml2sso?SPID=partner.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
            } else {
                   redirect = 'https://samlgwsm.ca.com/affwebservices/public/saml2sso?SPID=partner.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
                //System.debug('Prod URl here');
            
            }
        
        } // end not null;
    
       
       
    }
    
}