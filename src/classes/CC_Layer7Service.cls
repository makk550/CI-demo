public without sharing class CC_Layer7Service implements I {

  public interface I {
    Map<String,String> getSitesAndProducts(String siteId, String connectId);
    Map<String,Set<String>> getSitesAndProductsFromEER(String connectId);
    String callToFetchSitesAndProductsFromEER(String connectId); //***
    List<String> getSitesForUser(String connectSiteId,String connectId);
    String getLDAPID(String emailID);
    String getSAMLResponse(String emailID);
    String callLayer7ToCreateVirtualFolderInEFT(String email,String caseNumber,String siteId);
  }

  @TestVisible 
  private Layer7UtilCallout.I layer7Callout { get; set; }

  public CC_Layer7Service() {
    layer7Callout = new Layer7UtilCallout();
  }
  //public static boolean retryGetTokenCall = false;
  public static Integer currentAttempt = 0;
  public static String responseBodyFromAWS ='';

  //US388915
    public Map<String,String> getSitesAndProducts(String siteId, String connectId) {
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getSitesAndProducts';
        System.debug('invocationPath:'+CC_ngTurkeyController.invocationPath);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', connectId);
        gen.writeStringField('siteId', siteId);
        String params = gen.getAsString();
        
        try{           
            String awstoken=CC_Layer7Service.getAWSToken();
            String relativeEndpoint = '/products/get-entitled-ca-products-for-user-v2';
            String responseFromGetSitesandProducts = callAWSWebService(awstoken,'POST',params,relativeEndpoint);
            System.debug('responseFromGetSitesandProducts: '+responseFromGetSitesandProducts);
            
            Util_JSONParser parserUtil = Util_JSONParser.createParser(responseFromGetSitesandProducts);
            if(parserUtil.get('error').get('details').get('errorCode').Value != null ){ return null; }
            
            Map<String,String> sitesAndProductsMap = new Map<String,String>();
            sitesAndProductsMap.put('productsWithSiteIds',parserUtil.get('data').get('details').get('products').Value);
            sitesAndProductsMap.put('siteIds',parserUtil.get('data').get('details').get('siteIdList').Value);       
            return sitesAndProductsMap;
        } catch(Exception e){CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath,false); return null; }
    }
    
    public String callToFetchSitesAndProductsFromEER(String connectId) {
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.callToFetchSitesAndProductsFromEER';
        try{            
            String baseEndpoint = System.Label.CommonStackEndpoint_UserEntitlements + 'userid=';
            HttpRequest req = new HttpRequest(); 
            req.setMethod('GET');
            req.setHeader('authorize', System.Label.CommonStack_APIKey ); 
            req.setTimeout(Integer.valueOf(System.Label.CommonStack_UserEntitlements_Timeout));
            req.setEndpoint(baseEndpoint + connectId );
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('BODY: '+res.getBody());
            return res.getBody();
            //return '{ "entitlements":  [], "username": "foo@bar.com",  "id": "foo@bar.com"  }';
            //return '{"entitlements":[{"topsproductcode":"AGCUNL99000","supportsiteids":["00000206339"],"sfdcaccountid":"0013000000HQXhHAAX","name":"CA Agile Central Unlimited Edition SaaS ","instanceid":"I0040246402000025201610160725155779950","roles":[],"software_type":"saas","status":"active","materialid":"AGCUNL990"},{"topsproductcode":"AGUELA99000","supportsiteids":["00000206339","00000100116"],"sfdcaccountid":"0013000000HQXhHAAX","name":"AGL CNTRL UNLMT ED ELA TRANS","instanceid":"I0040246402000025201610160725155779950","roles":[],"software_type":"saas","status":"active","materialid":"AGUELA990"}],"username":"manar08","id":"manar08"}';
        } catch(Exception e){
             System.debug('Exception :'+e.getMessage());
            CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath,false); return null;
        }
}

    public Map<String,Set<String>> getSitesAndProductsFromEER(String connectId){
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getSitesAndProductsFromEER';
        
        Set<String> topsSiteIdSet = new Set<String>();
        Map<String,String> topsCodeProdIDMap = new Map<String,String>();
        Map<String,Set<String>> topsCodeSiteMap = new Map<String,Set<String>>();
        
        try{
            //String response = callToFetchSitesAndProductsFromEER(connectId);
            
           Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.CCCache');
           String cacheKey = CC_Utils.removeNonAlphChars(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAPID__c);
           String response = (String) sessionPart.get(CC_CacheSitesAndProductsInfo.class, cacheKey+'SandPFromEER');     
            
            System.debug('************response:'+response);
            Util_JSONParser parserUtil = Util_JSONParser.createParser(response);        
            List<String> topsproductcodeList = new List<String>();
            if(parserUtil.get('entitlements').Value != null && Boolean.valueOf(parserUtil.get('user_deleted').Value) == false && Boolean.valueOf(parserUtil.get('user_disabled').Value) == false){               
                List<Util_JSONParser> entlList = Util_JSONParser.parseArray(parserUtil.get('entitlements').Value);
                for(Util_JSONParser p: entlList){
                    if( p.get('status').Value == 'active' && p.get('entitlement_type').Value == 'paid'){
                        topsproductcodeList.add(p.get('topsproductcode').Value);
                    }                   
                }
                
                System.debug('topsproductcodeList:'+topsproductcodeList);
                if(topsproductcodeList != null && topsproductcodeList.size()>0 ){
                    for(Product_Material__c prodMaterail :  [SELECT  Id,Name,CA_Product_Controller__c,CA_Product_Controller__r.Name FROM Product_Material__c WHERE   Name in :topsproductcodeList]){                  
                        topsCodeProdIDMap.put(prodMaterail.Name , prodMaterail.CA_Product_Controller__r.Name );                      
                    }                       
                }
                
            }
            
            if(parserUtil.get('entitlements').Value != null && Boolean.valueOf(parserUtil.get('user_deleted').Value) == false && Boolean.valueOf(parserUtil.get('user_disabled').Value) == false){
                List<Util_JSONParser> entlList = Util_JSONParser.parseArray(parserUtil.get('entitlements').Value);                     
                List<String> tempext_EntSiteList = new List<String>();
                //List<String> tempSiteList = new List<String>();
                String tempSiteListStr ;
                for(Util_JSONParser p: entlList){
                    if( p.get('status').Value == 'active'){
                        tempSiteListStr = p.get('supportsiteids').Value ;
                        tempSiteListStr = tempSiteListStr.removeStart('[');
                        tempSiteListStr = tempSiteListStr.removeEnd(']');
                        tempext_EntSiteList = tempSiteListStr.split(',');
                        System.debug('SmallestValue:'+CC_Utils.fetchSmallestSiteId(tempext_EntSiteList));
                        //topsSiteIdSet.add(fetchSmallestSiteId(tempext_EntSiteList));
                        if(topsCodeSiteMap.containsKey(topsCodeProdIDMap.get(p.get('topsproductcode').Value))){
                            Set<String> tempSiteList = new Set<String>();
                            tempSiteList = topsCodeSiteMap.get(topsCodeProdIDMap.get(p.get('topsproductcode').Value));
                            tempSiteList.add(CC_Utils.fetchSmallestSiteId(tempext_EntSiteList));
                            topsCodeSiteMap.put(topsCodeProdIDMap.get(p.get('topsproductcode').Value),tempSiteList);
                        } else {
                            topsCodeSiteMap.put(topsCodeProdIDMap.get(p.get('topsproductcode').Value), new Set<String>{CC_Utils.fetchSmallestSiteId(tempext_EntSiteList)});
                        }                          
                        //topsCodeSiteMap.put(topsCodeProdIDMap.get(p.get('topsproductcode').Value),CC_Utils.fetchSmallestSiteId(tempext_EntSiteList));
                    }   
                }                                
                return topsCodeSiteMap;
            }
            return null;
        } catch(Exception e){
            System.debug('Exception :'+e.getMessage());
            CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath,false); return null;        
        }              
    }
    
   /* @Future
    public static void checkAndUpdateAccountOnContact(Id contactId) { //, Id accountIdFromEER) {  
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getSitesAndProductsFromEER'
        
        
        Contact cnt = [select id, AccountId, Account.Name from Contact where id = : contactId];
        String accountName = cnt.Account.Name;
        System.debug('accountName:'+accountName);
        if(accountName.startsWithIgnoreCase('Generic Support Account') || cnt.AccountId == CC_Settings.communityUserDefaultAccountId ){
            cnt.AccountId = accountIdFromEER;
        }
        update cnt;        
    } */
    
    @Future(callout=true)
    public static void updateAccountOnContact(Id contactId, string contactEmail ) { //, Id accountIdFromEER) {  
        //CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.updateAccountOnContact';
        Id sfdcaccountidFromEER = null;
        CC_Layer7Service obj = new CC_Layer7Service();
        String response = obj.callToFetchSitesAndProductsFromEER(contactEmail);
        System.debug('************response:'+response);
        Util_JSONParser parserUtil = Util_JSONParser.createParser(response);
        if(parserUtil.get('entitlements').Value != null && Boolean.valueOf(parserUtil.get('user_deleted').Value) == false && Boolean.valueOf(parserUtil.get('user_disabled').Value) == false){
            List<Util_JSONParser> entlList = Util_JSONParser.parseArray(parserUtil.get('entitlements').Value);
            for(Util_JSONParser p: entlList){
                if( p.get('status').Value == 'active' && p.get('entitlement_type').Value == 'paid') {
                    sfdcaccountidFromEER = p.get('sfdcaccountid').Value;
                    System.debug('1.sfdcaccountidFromEER:'+sfdcaccountidFromEER);
                    break;
                } 
            }
            if(sfdcaccountidFromEER == null) {
                
                for(Util_JSONParser p: entlList){
                    if(p.get('status').Value == 'active'){
                        sfdcaccountidFromEER = p.get('sfdcaccountid').Value;
                        System.debug('2.sfdcaccountidFromEER:'+sfdcaccountidFromEER);
                        break;                   
                    } 
                }
                
            }
            
            
            if(sfdcaccountidFromEER == null) {
                for(Util_JSONParser p: entlList){    
                    sfdcaccountidFromEER = p.get('sfdcaccountid').Value;
                    System.debug('3.sfdcaccountidFromEER:'+sfdcaccountidFromEER);
                    break;
                }
            }
        }
        
        System.debug('sfdcaccountidFromEER:'+sfdcaccountidFromEER);
        List<Contact> cnt = [select id, AccountId, Account.Name from Contact where id = : contactId limit 1];
        if(cnt!=null && cnt.size() >0 ) {
            cnt[0].AccountId = sfdcaccountidFromEER;
            update cnt[0];
        }
    }

 //get ldap id  
  public String getLDAPID(String emailID){

    CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getLDAPID';
      try{
          JSONGenerator gen = JSON.createGenerator(true);
          gen.writeStartObject();
          gen.writeStringField('connectUserID', '');
          gen.writeStringField('emailID', emailID);
          String params='{"connectUserID":"","emailID":"'+emailID+'"}';
          String urlPart = '/esupport/v.2/profile/user';
          String resJson = callLayerSeven(urlPart,'POST',params,'application/json');
          System.debug('resJson data='+resJson);
          Util_JSONParser parserUtil = Util_JSONParser.createParser(resJson);
          String LDAPID=parserUtil.get('ConnectUserID').Value;
          return LDAPID;
      }
      catch(Exception e){CC_ngTurkeyController.insertCCErrorLog(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath); return null; }  
      return null;

  }  
  //get ldap id  
  public String getSAMLResponse(String connectID){

    CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.connectID';
      try{
          //JSONGenerator gen = JSON.createGenerator(true);
          //gen.writeStartObject();
          //gen.writeStringField('connectUserID', '');
          //gen.writeStringField('emailID', emailID);
          //String params='{"connectUserID":"","emailID":"'+emailID+'"}';
          String urlPart = '/saml/v.1?lookupUser='+connectID;
          String resJson = callLayerSeven(urlPart,'GET','','text/plain');
          System.debug('saml response='+resJson);
          return resJson;
      }
      catch(Exception e){CC_ngTurkeyController.insertCCErrorLog(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath); return null; }  
      return null;
  }  
    
  public List<String> getSitesForUser(String connectSiteId,String connectId) {

        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getSitesForUser';
        System.debug('invocationPath:'+CC_ngTurkeyController.invocationPath);
        List<String> siteIds = new List<String>();

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('userId', connectId);
        gen.writeStringField('connectSiteId', connectSiteId);
        gen.writeStringField('projectFlag', '1');
        String params = gen.getAsString();
        String relativeEndpoint = '/site/get-sites-for-user';
        try{
              String awstoken=CC_Layer7Service.getAWSToken();
              String responseFromGetSitesForUser = callAWSWebService(awstoken,'POST',params,relativeEndpoint);             
              System.debug('responseFromGetSitesForUser:'+responseFromGetSitesForUser);
              Util_JSONParser parserUtil = Util_JSONParser.createParser(responseFromGetSitesForUser);
              String sites = parserUtil.get('data').get('details').Value;
              System.debug('details - sites:'+sites);

              if(sites != null && ! sites.contains ('NoDataFound')) {
                sites = sites.removeStart('[');
                sites = sites.removeEnd(']');
                siteIds = sites.split(',');
                System.debug('siteIds:'+siteIds);
                return siteIds;   
              } else { CC_ngTurkeyController.prepareErrorLogRecord('params:\n' + params + '\nresponseFromGetSitesForUser:\n' + responseFromGetSitesForUser , CC_ngTurkeyController.invocationPath,false);
                    //return null; 
                    return new List<String>{'NoSitesFound'};
              }
          }catch(Exception e) {  System.debug('Exception :' + e.getStackTraceString());  throw e;}
           return new List<String>{'NoSitesFound'}; //return null;
  }

    //GlobalScape Integration - Step1: Call Layer7 service to create the virtual folder structure for the logged in user
    public  String  callLayer7ToCreateVirtualFolderInEFT(String email,String caseNumber,String siteId){
      
      String paddedSiteId = CC_Utils.padSiteIdforGS(siteId);        
      String endpoint =  CC_Settings.L7GlobalScapeUrl + email + '/' + paddedSiteId + '/' + caseNumber;
      System.debug('endpoint:'+endpoint);
      try{
          Http httpObj = new Http();
          HttpRequest req = new HttpRequest();
          req.setEndpoint(endpoint);
          req.setMethod('POST');
          req.setTimeout(Integer.valueOf(System.Label.GlobalScapeServiceTimeOut));
          HttpResponse response= httpObj.send(req);    
          String responseBody = response.getBody();
          System.debug('responseBody:'+response.getBody());
          if(responseBody.contains('error')){
              CC_ngTurkeyController.prepareErrorLogRecord('Response from url:' + endpoint + '\n Response:\n'+responseBody , 'In callLayer7ToCreateVirtualFolderInEFT',false);return 'error';
          }
          return response.getStatus();
        }
        catch(Exception e){
               System.debug('Exception Message : '+e.getMessage());
               System.debug('Stacktrace : '+e.getStackTraceString() );
                CC_ngTurkeyController.prepareErrorLogRecord(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString(), 'In callLayer7ToCreateVirtualFolderInEFT',false);return null;
        }
  }
    
  private String callLayerSeven(String urlPart,String method,String params,String contenttype) {
    log.debug(urlPart);
    CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.callLayerSeven';
    String url = layer7Callout.getLayer7BaseUrl() + urlPart;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod(method);
    if(contenttype!='')
      req.setHeader('content-type', contenttype);
    req.setTimeout(20*1000);
    System.debug(params);
    if (params!='')
        req.setBody(params);
    String resBody = layer7Callout.processLayer7Services(req);
    System.debug('resBody='+resBody);
    if(resBody.contains('error')){
      CC_ngTurkeyController.prepareErrorLogRecord('Response from url:' + urlPart + '\n Response:\n'+resBody , CC_ngTurkeyController.invocationPath,false);
    }
    return resBody;
  }
  //get solutions from AWS web service call
  public static String getSolution(String awstoken,String product,String release,String solID,String solType) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('function', 'SLN');
        if(product != null)
            gen.writeStringField('product', product);
        else
            gen.writeStringField('product', '');
       
        if(release != null)
            gen.writeStringField('prodrel', release);
        else
            gen.writeStringField('prodrel', '');

        gen.writeStringField('solution', solID);
        if (solType!=null)
            gen.writeStringField('soltype', solType);
        else
            gen.writeStringField('soltype', '');    
        String serviceURL='/star/get-solutions-from-star';
        String params = gen.getAsString();
        String serurl='/star/get-solutions-from-star';
        return callAWSWebService(awstoken, 'POST', params,serurl);
    } 

    public static String callAWSWebService(String AWSToken, String httpMethod, String params,String serviceurl){
        //String responseBody = '';
        CC_ngTurkeyController.invocationPath += '=CC_Layer7Service.callAWSWebService';
        System.debug(' currentAttempt:'+currentAttempt);
        if(currentAttempt == 2 ){ CC_ngTurkeyController.prepareErrorLogRecord('currentAttempt:'+ currentAttempt+ '\nInput Params:\n' + params  +'\n Endpoint:' + CC_Settings.AWSAPIGatewayBaseURL+serviceURL + '\n Response Body:\n'+responseBodyFromAWS , CC_ngTurkeyController.invocationPath,false); }
        
       if( currentAttempt<=1 ){  
                HttpRequest req = new HttpRequest(); 
                req.setMethod(httpMethod);
                req.setEndpoint(CC_Settings.AWSAPIGatewayBaseURL+serviceURL);
                req.setHeader('Authorization', AWSToken);
                req.setBody(params);
                System.debug('params:'+params);
                Http http = new Http();
                HTTPResponse res = http.send(req);
                responseBodyFromAWS = res.getBody();
                System.debug('RESPONSE BODY: '+responseBodyFromAWS);                
                  if(res.getStatusCode() != 200) {
                      System.debug('Starting retry logic...');
                      String newToken = generateAWSToken();
                      currentAttempt++;
                      callAWSWebService(newToken, httpMethod, params, serviceurl);
                      updateAWSToken(newToken);                     
                }
        }
        return responseBodyFromAWS;
    }

    public class JSON2Token {
            public String token;
    }
    public static JSON2Token parse(String json) {
        return (JSON2Token) System.JSON.deserialize(json, JSON2Token.class);
    }
    public static String getAWSToken(){
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.getAWSToken';
        String awstoken='';
        try{    
          awstoken=(aws_security_token__c.getvalues('awstoken').token_str1__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str1__c:'')+
                (aws_security_token__c.getvalues('awstoken').token_str2__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str2__c:'')+
                (aws_security_token__c.getvalues('awstoken').token_str3__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str3__c:'')+
                (aws_security_token__c.getvalues('awstoken').token_str4__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str4__c:'')+
                (aws_security_token__c.getvalues('awstoken').token_str5__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str5__c:'')+
                (aws_security_token__c.getvalues('awstoken').token_str6__c!=NULL?aws_security_token__c.getvalues('awstoken').token_str6__c:'');
        }catch(Exception e){ CC_ngTurkeyController.insertCCErrorLog(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath);return ''; }   
         return awstoken;
    }
    
    @Future
    public static void updateAWSToken(String token){
        CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=CC_Layer7Service.updateAWSToken';
        aws_security_token__c tokenstr;
        try{
            tokenstr = aws_security_token__c.getValues('awstoken');
            tokenstr.token_str2__c = '';
            tokenstr.token_str3__c = '';
            tokenstr.token_str4__c = '';
            tokenstr.token_str5__c = '';
            tokenstr.token_str6__c = '';    
        }catch(NullPointerException e){ CC_ngTurkeyController.insertCCErrorLog(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath); return ; }
    
        integer tokenLength = token.length();
        if(tokenLength <= 250)
        {
            tokenstr.token_str1__c = token;
        }
        else if(tokenLength > 250 && tokenLength < = 500)
       {
            tokenstr.token_str1__c = token.substring(0, 250);
            tokenstr.token_str2__c = token.substring(250);
        }
        else if(tokenLength > 500 && tokenLength <= 750)
        {
            tokenstr.token_str1__c = token.substring(0, 250);        
            tokenstr.token_str2__c = token.substring(250, 500);
            tokenstr.token_str3__c = token.substring(500);
        }
        else if(tokenLength > 750 && tokenLength <= 1000)
        {
            tokenstr.token_str1__c = token.substring(0, 250);        
            tokenstr.token_str2__c = token.substring(250, 500);
            tokenstr.token_str3__c = token.substring(500, 750);
            tokenstr.token_str4__c = token.substring(750);
        }
        else if(tokenLength > 1000 && tokenLength <= 1250)
        {
            tokenstr.token_str1__c = token.substring(0, 250);        
            tokenstr.token_str2__c = token.substring(250, 500);
            tokenstr.token_str3__c = token.substring(500, 750);
            tokenstr.token_str4__c = token.substring(750, 1000);
            tokenstr.token_str5__c = token.substring(1000);         
        }
        else if(tokenLength > 1250 && tokenLength <= 1500)
        {
            tokenstr.token_str1__c = token.substring(0, 250);        
            tokenstr.token_str2__c = token.substring(250, 500);
            tokenstr.token_str3__c = token.substring(500, 750);
            tokenstr.token_str4__c = token.substring(750, 1000);
            tokenstr.token_str5__c = token.substring(1000, 1250);  
            tokenstr.token_str6__c = token.substring(1250);             
        }        
        update tokenstr;
        return;

    }
    public static string generateAWSToken(){
    JSON2Token jsontoken;
        System.debug('aws token generation======');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CC_Settings.eaiAWSTokenURL);
        req.setMethod('GET');
        req.setTimeout(20*1000);
        req.setHeader('consumerUserName', 'IntegrationEAICSO');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        jsontoken = parse(res.getBody());
        System.debug('token======'+jsontoken.token);
        return jsontoken.token;
    }
    
    //Added for Private Comments
    //Generate Salesforce Token
    public static string generateSFDCAccessToken()
    { 
        JSONParser parser1;
        HttpRequest req = new HttpRequest();
        String token= System.label.Salesforce_Token_URL; //'https://ca--fsb2.cs19.my.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9Vik22TUgUphKhs9dOlQTsqcv6xlM9jJiyyoRT2y9jY_x7MMYcV.sQGlVc5PfPQqcRnsbK6.OxiWLhtPG&client_secret=2657247594032780130&username=awslambda@ca.com.fsb2&password=salesforce@143'; //
        req.setEndpoint(token);
        req.setMethod('POST');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('*** After Authentication...'+res.getBody());
        String accsToken = '';
        parser1 = JSON.createParser(res.getBody());
        while (parser1.nextToken() != null) {
            
            if ((parser1.getCurrentToken() == JSONToken.FIELD_NAME) && (parser1.getText() == 'access_token')) {
                system.debug('accsToken before nextToken'+parser1.getText());
                // Get the value.
                parser1.nextToken();
                system.debug('accsToken After nextToken'+parser1.getText());
                accsToken = parser1.getText();
            }
        }
        return accsToken;
    }
    
    public static String  InsertPrivateComments(ID caseID,String commentBody) {
        String accsToken=generateSFDCAccessToken();
        String url =System.label.CC_InternalCommentsAPI;
        String auth='Bearer '+accsToken;
        commentBody=commentBody.escapeUnicode();
        String reqcommBody='{"commentbody" : "' + commentBody + '","caseID":"' + caseID + '"}';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json;');
        req.setHeader('Authorization', auth);
        req.setBody(reqcommBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
        
    }
    public static String  fetchPrivateComments(ID caseID) {
        String commentID='';
        return GetPrivateComments(caseID,commentID);
    }
    public static String  fetchPrivateComments(ID caseID,String commentID) {
        return GetPrivateComments(caseID,commentID);
    }
    static String  GetPrivateComments(ID caseID,String commentID) {
        String accsToken=generateSFDCAccessToken();
        String url =System.label.CC_InternalCommentsAPI + '?caseID=' + caseID  + '&commentID=' + commentID;
        String auth='Bearer '+accsToken;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json;');
        req.setHeader('Authorization', auth);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String response=res.getBody();
        response=response.replaceall('\\n','<br/>');
        return response;
    }

    
}