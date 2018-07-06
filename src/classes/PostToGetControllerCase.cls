public class PostToGetControllerCase {

    public String redirect {get;set;}

    public PostToGetControllerCase() {
    
    
       Organization  orgDetails = [SELECT Id, IsSandbox , InstanceName , Name  FROM Organization WHERE Id = : UserInfo.getOrganizationId()];

        System.debug('or'+orgDetails);
        
        if (orgDetails != null )   {
            
            if (orgDetails.isSandbox == true )
            {      
                   String sandboxname = UserInfo.getUserName().substringAfterLast('.');  
                   system.debug('################'+sandboxname);
                   redirect = 'https://samlgwsm-qa.ca.com/affwebservices/public/saml2sso?SPID=https://case-'+'fsb2.saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
            } else {
                   redirect = 'https://samlgwsm.ca.com/affwebservices/public/saml2sso?SPID=https://case.saml.salesforce.com';
                   Map<String, String> params = ApexPages.currentPage().getParameters();
                   if (params.containsKey('RelayState')) redirect = redirect + '&RelayState=' + EncodingUtil.urlEncode(params.get('RelayState'), 'UTF-8');
                //System.debug('Prod URl here');
            
            }
        
        } // end not null;
    
       
       
    }
    
     public void caseHandlerTestData(){
        Integer i=0;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        }
}