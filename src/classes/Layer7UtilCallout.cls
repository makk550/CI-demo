public class Layer7UtilCallout implements I {

    public interface I {
        String processLayer7Services(HttpRequest httpInputRequest);
        String getLayer7BaseUrl();
    }

    private String m_layer7BaseUrl;
    public String getLayer7BaseUrl() {
        return m_layer7BaseUrl;
    }

    public Layer7UtilCallout() {
        String urlAsString = System.Label.GatewayAPITokenEndPoint;
        System.Url parsedUrl = new System.Url(urlAsString);
        m_layer7BaseUrl = parsedUrl.getProtocol()+'://'+parsedUrl.getHost();
    }
    
    public String processLayer7Services(HttpRequest httpInputRequest){        
        String getSavedAccessToken=null;
        String getOnFlyccessToken=null;       
        String getAccessToken=null;
        String response=null;
        try{
            getSavedAccessToken=getStoredToken();         
            if(getSavedAccessToken==null || getSavedAccessToken==''){
                getOnFlyccessToken=getAccessToken(); 
                getAccessToken=getOnFlyccessToken;
            }else{
                getAccessToken=getSavedAccessToken;
            }            
            response=invokeLayer7ServiceAPI(httpInputRequest,getAccessToken);
            if(response<>null){
                if(response.contains('error')){
                    response=invokeLayer7ServiceForTokenExpiry(httpInputRequest,response,getOnFlyccessToken);
                }else {
                    if(getSavedAccessToken==null || getSavedAccessToken==''){
                        saveorUpdateToken(getOnFlyccessToken);
                    } 
                }            
            }            
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage()); 
        }
        finally{
            if(getSavedAccessToken<>null){
                getSavedAccessToken=null;
            }
            if(getOnFlyccessToken<>null){
                getOnFlyccessToken=null;
            }
            if(getAccessToken<>null){
                getAccessToken=null;
            }
        }
        return response;
    }
    public String getAccessToken(){
        HttpRequest reqToken =null;
        Http httpToken =null;
        HTTPResponse resToken=null;
        String responseTokenFromService=null;
        String tokenId=null;
        String actualToken=null;
        String endPointTokenUrl=System.Label.GatewayAPITokenEndPoint+'?grant_type=client_credentials&scope=oob&client_id='+System.Label.GatewayAPIClientKey+'&client_secret='+System.Label.GatewayAPIClientSecret;
        try{
            if(Test.isRunningTest()){
               responseTokenFromService = tokenResponse();
               responseTokenFromService=tokenErrorResponse();
            }else{
                reqToken=new HttpRequest(); 
                reqToken.setMethod('POST');
                reqToken.setEndpoint(endPointTokenUrl);
                //reqToken.setHeader('usePortal', 'true');
                reqToken.setHeader('Content-Type', 'application/json');                   
                httpToken= new Http();
                resToken= httpToken.send(reqToken); 
                responseTokenFromService=resToken.getBody(); 
            }                 
                if(responseTokenFromService<>null){
                    actualToken=getActualTokenFormat(responseTokenFromService);
                } 
          }catch(System.CalloutException e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }
        catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }finally{
            if(responseTokenFromService<>null){
                responseTokenFromService=null;
            }
            if(httpToken<>null){
                httpToken=null;
            }
            if(reqToken<>null){
                reqToken=null;
            }
            if(resToken<>null){
                resToken=null;
            }
            if(endPointTokenUrl<>null){
                endPointTokenUrl=null;
            }
        }
        return actualToken;
    }
    
    public String getStoredToken(){
        Gateway_API_Ref__c[] tokenValue=null;
        try{
            tokenValue=[SELECT Name FROM Gateway_API_Ref__c where Client_API_Key__c=:System.Label.GatewayAPIClientKey]; 
            if (tokenValue.size() != 1)
            {
                return '';
            }
            else
            {
                return tokenValue[0].Name;
            }
        }catch(System.DmlException e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }       
    }
    public void saveorUpdateToken(String getAccessToken){        
        try{
            Gateway_API_Ref__c tokenSave=new Gateway_API_Ref__c();
            tokenSave.Name=getAccessToken;
            tokenSave.Client_API_Key__c=System.Label.GatewayAPIClientKey;
            upsert tokenSave Client_API_Key__c;
        }catch(System.DmlException e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }
    }
    
    public String getActualTokenFormat(String responseTokenFromService){
        String tokenId=null;
        String actualToken=null;
        List<String> tokenList=responseTokenFromService.split(',');
        for(String s: tokenList){
            if(s.contains('access_token')){
                tokenId=s;
                break;
            }
        }
        tokenId=tokenId.substringAfter(':');
        actualToken=tokenId.replace('"','');
        return actualToken;
    } 
    
    public String invokeLayer7ServiceAPI(HttpRequest httpInputRequest,String accessToken){
        Http http =new Http();
        HTTPResponse res=null;
        String responseFromService=null;
        String currentEnvironment=System.URL.getSalesforceBaseUrl().getHost();
        String clientAPIKey=System.Label.GatewayAPIClientKey;        
        try{
            //httpInputRequest.setHeader('API-Key',clientAPIKey);
            httpInputRequest.setHeader('Authorization','Bearer '+accessToken);
            res= http.send(httpInputRequest);
            if(httpInputRequest.getEndPoint() == System.label.CFTP_CaseFolderCreationOnSiteIdChangeEndpoint)
                	responseFromService=res.getBody()+'@@'+res.getStatusCode();
            else
            	responseFromService=res.getBody();
            System.debug('responseFromService'+res);
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }
        finally{
            if(http<>null){
                http=null;
            }
            if(res<>null){
                res=null;
            }
            if(currentEnvironment<>null){
                currentEnvironment=null;
            }
            if(clientAPIKey<>null){
                clientAPIKey=null;
            }
        }
        return responseFromService;         
    }
    
    public String invokeLayer7ServiceForTokenExpiry(HttpRequest httpInputRequest,String response,String getOnFlyccessToken){
        String errorName=null;
        List<String> errorlist=null;
        try{
            errorlist=response.split(',');
            for(String s: errorlist){
                if(s.contains('error')){
                    errorName=s;
                    break;
                }
            }
            errorName=errorName.substringAfter(':');                       
            errorName=errorName.replace('"','');
            if(errorName.trim().equalsIgnoreCase('invalid_request')){
                getOnFlyccessToken=getAccessToken();
                response= invokeLayer7ServiceAPI(httpInputRequest,getOnFlyccessToken); 
                if(response<>null){
                    if(!(response.contains('error'))){
                        if(getOnFlyccessToken<>null){                                  
                            saveorUpdateToken(getOnFlyccessToken);
                        } 
                    }                            
                }
            }        
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }finally{
            if(errorName<>null){
                errorName=null;
            }
            if(errorlist<>null){
                errorlist=null;
            }            
        }       
        return response;
    }
    
    public string tokenResponse(){
        String response='{'+
            '\"access_token\": \"e1ddf7da-2950-4aca-bc7d-84ac070aa0b4\", '+
            '\"token_type\": \"Bearer\",'+
            '\"expires_in\": \"3600\",'+
            '\"scope\": \"oob\"'+
            '}' ;   
        
        return response;
    }
    
    public string tokenErrorResponse(){
        String response='{'+            
            '\"error\": \"invalid_request\", '+
            '\"error_description\": \"Invalid grant_type\"'+          
            '}' ;         
        return response;
    }    
}