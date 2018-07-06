public class KBArticleHandler {
    public static KB_Article__c validateSyncKBArticle(String kbArticleNo) {
        String inputRequest = '?kbid='+kbArticleNo;
        String responseFromService;
        String getSavedAccessToken=null;
        String getOnFlyccessToken=null;       
        String getAccessToken=null;
        String clientAPIKey=System.Label.GatewayAPIClientKey;
        HttpRequest req =null;
        String currentEnvironment=System.URL.getSalesforceBaseUrl().getHost();
        String endPoint=null;
        KB_Article__c kbArticle=new KB_Article__c();
        kbarticle.KB_Article_No__c=kbArticleNo;
        
        try {
            //SiteUtilServicesCallout sitetilCallout = new SiteUtilServicesCallout();
            /*getSavedAccessToken=sitetilCallout.getStoredToken();         
            if(getSavedAccessToken==null || getSavedAccessToken=='') {
                getOnFlyccessToken=sitetilCallout.getAccessToken(); 
                getAccessToken=getOnFlyccessToken;
            } else {
                getAccessToken=getSavedAccessToken;
            }*/
            if(currentEnvironment.containsIgnoreCase('cs')) {
                endPoint=System.Label.KBArticleLayer7EndpointQA+inputRequest  ;
            } else {   
                endPoint=System.Label.KBArticleLayer7EndpointProd+inputRequest;
            }
            req=new HttpRequest(); 
            req.setMethod('GET');
            req.setEndpoint(endPoint);
            /*req.setHeader('API-Key',clientAPIKey);
            req.setHeader('Authorization','Bearer '+getAccessToken);*/
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(120000);
            
            if(Test.isRunningTest()) {
                if (kbArticleNo.equalsIgnoreCase('TEC12341')) {
                    responseFromService = tempResponseSuccess();
                    parseResponse(responseFromService, req, kbArticle);
                } else if (kbArticleNo.equalsIgnoreCase('testinvalid')) {
                    responseFromService = tempResponseNoData();
                    parseResponse(responseFromService, req, kbArticle);
                    parseLayer7Response(responseFromService, req, kbArticle);
                }
            } else {
                //responseFromService=sitetilCallout.invokeServiceAPI(inputRequest,'KBArticle',null,req);
                system.debug('request----->>>>'+req);
                Layer7UtilCallout service=new Layer7UtilCallout();
                responseFromService=service.processLayer7Services(req);
                system.debug('responseFromService:'+responseFromService);
                
                if(responseFromService == null || responseFromService =='') {
                    RelateKBArticleToCase.statusCode = 1051;
                    createErrorLog(req.toString(),responseFromService);
                }else{
                   //parseResponse(responseFromService,req,kbArticle);  
                   parseLayer7Response(responseFromService,req,kbArticle);  
                }
                /*if(responseFromService<>null && responseFromService<>''){
                    if(responseFromService.contains('error')){
                        responseFromService=executeTokenExpiryCheck(inputRequest,'KBArticle',responseFromService,req,sitetilCallout);
                        if(responseFromService == null || responseFromService =='') {
                            RelateKBArticleToCase.statusCode = 1051;
                            createErrorLog(req.toString(),responseFromService);
                        }else{
                            parseResponse(responseFromService,req,kbArticle);    
                        }
                    }else{
                        parseResponse(responseFromService,req,kbArticle);
                        if(getSavedAccessToken==null || getSavedAccessToken==''){
                            sitetilCallout.saveorUpdateToken(getOnFlyccessToken);
                        } 
                    }            
                }else{
                    RelateKBArticleToCase.statusCode = 1051;
                    createErrorLog(req.toString(),responseFromService);
                } */
                
            }            
        } catch(System.CalloutException e) {
            RelateKBArticleToCase.statusCode = 1212;
            createErrorLog(req.toString(), e.getStackTraceString());
        } catch(System.Exception e) {
            createErrorLog(req.toString(), e.getStackTraceString());
            throw new KBAutheringCustomException(e.getMessage());
        }
        System.debug('kbarticle==='+kbarticle);
        return kbarticle;
    }
    
    /*public static String executeTokenExpiryCheck(String inputRequest,String serviceName,String response,HttpRequest kbRequest,SiteUtilServicesCallout sitetilCallout){
        String errorName=null;
        String getOnFlyccessToken=null;
        List<String> errorlist=response.split(',');
        for(String s: errorlist){
            if(s.contains('error')){
                errorName=s;
                break;
            }
        }
        errorName=errorName.substringAfter(':');                       
        errorName=errorName.replace('"','');
        if(errorName.trim().equalsIgnoreCase('invalid_request')){
            getOnFlyccessToken=sitetilCallout.getAccessToken();
            kbRequest.setHeader('Authorization','Bearer '+getOnFlyccessToken);
            response= sitetilCallout.invokeServiceAPI(inputRequest,serviceName,null,kbRequest); 
            if(response<>null){
                if(!(response.contains('error'))){
                    if(getOnFlyccessToken<>null){                                  
                        sitetilCallout.saveorUpdateToken(getOnFlyccessToken);
                    } 
                }                            
            }
        }  
        return response;
    }*/
    public static void parseLayer7Response(String resBody,HttpRequest req,KB_Article__c kbArticle){
        
       
        JSONParser parser =  JSON.createParser(resBody);
        
         while (parser.nextToken() != null) {
       
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                system.debug('1==='+text);
               
                if(text =='Id'){
                    parser.nextToken();
                    kbarticle.id =parser.getIdValue();
                   System.debug('Current token: ' +kbarticle.id); 
                }
                else if(text =='error'){
                    
                    if(parser.nextToken() == JSONToken.START_OBJECT){
                    
                        parser.nextToken();
                        
                        String errCodeVal = parser.getText();
                        
                        if(errCodeVal =='code'){
                            parser.nextToken();
                            integer statuscode = parser.getIntegerValue();
                            RelateKBArticleToCase.statusCode = statuscode;
                            
                            if (statuscode != 2016) {
                                createErrorLog(req.toString(), resBody);
                            }
                             
                             System.debug('Current token1: ' +parser.getIntegerValue());
                        }
                        else if (errCodeVal == 'error_code' || errCodeVal == 'error_description') {
                            
                            RelateKBArticleToCase.statusCode = 1051;
                            createErrorLog(req.toString(), resBody);
                        }
                    }
                
                }    
                
            }
              
        }
                      
                 
                   
                
        
    }
    
    public static void parseResponse(String resBody, HttpRequest req, KB_Article__c kbArticle) {
  
    system.debug('====###'+resBody);
        JSONParser parser = JSON.createParser(resBody);
        
        while (parser.nextToken() != null) {
       
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                system.debug('1==='+text);
               
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'Status__c') {
                        String status = parser.getText();
                        System.debug('2===='+status);
                        if (status == 'Published' || status == 'Retired') {
                            kbarticle.Status__c = parser.getText();
                        } else {
                            kbarticle.Status__c = 'In Progress';
                        }
                    } else if (text == 'KB_Article_Title__c') {
                        kbarticle.KB_Article_Title__c = parser.getText();
                    } else if (text == 'Author__c') {
                        kbarticle.Author__c = parser.getText();
                    } else if (text == 'Modified_date') {
                        kbarticle.Status_Change_Date__c=parser.getDateTimeValue();
                    } else if (text == 'code') {
                        system.debug('3===='+parser.getIntegerValue());
                        integer statuscode = parser.getIntegerValue();
                        RelateKBArticleToCase.statusCode = statuscode;
                        if (statuscode != 2016) {
                            createErrorLog(req.toString(), resBody);
                        }                 
                    } else if (text == 'error_code' || text == 'error_description') {
                        RelateKBArticleToCase.statusCode = 1051;
                        createErrorLog(req.toString(), resBody);
                    }
                    
                    
                }
            }  
        }
        if (kbarticle.KB_Article_Title__c != null) {
            insert kbarticle;
            System.debug('Inserted KB Article:'+kbarticle);
        }

    }
    
    public static void createErrorLog(String req, String res) {
        KBAutheringErrorLog__c kbErrLog = new KBAutheringErrorLog__c();
        kbErrLog.KBRequestSent__c = datetime.now();
        kbErrLog.KB_Request__c = req;
        kbErrLog.KB_Response__c = res;
        insert kbErrLog;
        System.debug('Inserted KBAutheringErrorLog__c record:'+kbErrLog);
    }
    
    public static String tempResponseSuccess(){
        String response='{'+
            '\"KB_Article_No__c\":\"TEC12341\", '+
            '\"Author__c\":\"Munnuru, Venu Gopal\", '+
            '\"KB_Article_Title__c\":\"test relate\", '+
            '\"Modified_date\":\"2015-10-20T06:45:38Z\", '+
            '\"Status__c\": \"Draft\" '+
            '}';     
        return response;    
    }
    
    public static String tempResponseNoData(){
        String response='{'+
            '\"status":\"failure\", '+
            '\"error\":{ '+
            '   \"code\":2016, '+
            '   \"error_code\":\"test\", '+
            '   \"description\":\"No data found for the KB Article\", '+
            '   \"message":\"Mandatory response fields missing\" '+
            '   } '+
            '}';     
        return response;    
    }
    
}