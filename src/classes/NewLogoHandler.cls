public class NewLogoHandler
{
    NewLogoHandler()
    {
    }
    
    @future(callout=true)
    public static void callEAIforNewLogo(List<String> xmlStrings)
    {
        System.debug('---In NewLogo Handler---');    
        boolean isProd = false;
        boolean isDev = false;
        boolean isQA = false;
        
        if(UserInfo.getOrganizationId().contains('00D300000006yn4'))
        {
            isProd = true;
        }
        else {
            String userName = UserInfo.getUserName();
            if(userName.contains('ca.com.fsb'))
            {
                isQA = true;
            }
            else
            {
                isDev = true;
            }
        }
        
        String endPoint = '';
        String authorizationHeader = '';          
        
        if(isProd)
        {
            endPoint = Label.New_Logo_EAI_Prod_Endpoint;
            authorizationHeader = 'Basic '+Label.New_Logo_Credentials_Prod;
        }
        else if(isQA)
        {
            endPoint = Label.New_Logo_EAI_QA_Endpoint;  
            authorizationHeader = 'Basic '+Label.New_Logo_Credentials_QA;      
        }
        else if(isDev)
        {
            endPoint = Label.New_Logo_EAI_Dev_Endpoint; 
            authorizationHeader = 'Basic '+Label.New_Logo_Credentials_Dev;       
        }
        
        for(String xmlString : xmlStrings)
        {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setBody(xmlString);
            
            /*String username = 'sfdc_service_user';
            String password = 'sfdc_nl_@1';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode(headerValue);   
            req.setHeader('Authorization', authorizationHeader); */  
              

            req.setHeader('Authorization', authorizationHeader); 
            req.setHeader('Content-Type', 'text/xml');     
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Result - ' + res.getBody());  
        }                    
    }
}