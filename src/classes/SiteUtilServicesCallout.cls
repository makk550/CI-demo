public class SiteUtilServicesCallout {
    
    public String buildServiceRequestandInvokeService(String[] inputDetails,String serviceName){
        String inputRequest=null;
        String response=null;
        String getSavedAccessToken=null;
        String getOnFlyccessToken=null;       
        String getAccessToken=null;
        try{  
            inputRequest=buildGETRequestInput(inputDetails,serviceName);
            response=invokeServiceAPI(inputRequest,serviceName);
        }catch(System.Exception e){          
            throw new SiteUtilServicesCustomException(e.getMessage());   
        }finally{
            if(inputRequest<>null){
                inputRequest=null;
            }
        }
        return response;
    }
    
    public String invokeServiceAPI(String inputRequest,String serviceName){ 
        HttpRequest req =null;
        String currentEnvironment=System.URL.getSalesforceBaseUrl().getHost();
        String endPoint=null;
        String responseFromService=null;
        Layer7UtilCallout layer7Callout=null;
        try{  
            if(currentEnvironment.containsIgnoreCase('cs')){
                if(serviceName.equalsIgnoreCase('EntitlementService')){
                    endPoint=System.Label.SiteEntitlementEndPointQA+inputRequest;
                }else if(serviceName.equalsIgnoreCase('SupportingOffering')){
                    endPoint=System.Label.SiteServiceOfferingEndPointQA+inputRequest;
                }
            }else{
                if(serviceName.equalsIgnoreCase('EntitlementService')){
                    endPoint=System.Label.SiteEntitlementEndPointProduction+inputRequest;
                }else if(serviceName.equalsIgnoreCase('SupportingOffering')){
                    endPoint=System.Label.SiteServiceOfferingEndPointProd+inputRequest;
                }
            }
            
            if(Test.isRunningTest()){
                responseFromService = tempResoponse();
                responseFromService = tempResoponseSupportOffering();
                responseFromService=tempErrorResponseOne();
            }else{
                req=new HttpRequest(); 
                req.setMethod('GET');
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type', 'application/json');
                //Fix for L7 Read time out issue in Production
                if(String.isNotBlank(serviceName) && serviceName.equalsIgnoreCase('EntitlementService')){
                  req.setTimeout(Integer.valueOf(System.Label.EntitlementServiceTimeOut));    
                }
                //Fix for L7 Read time out issue in Production
                layer7Callout=new Layer7UtilCallout();
                responseFromService= layer7Callout.processLayer7Services(req); 
            }            
        }catch(System.CalloutException e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }
        catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }
        finally{
            if(req<>null){
                req=null;
            }          
            if(currentEnvironment<>null){
                currentEnvironment=null;
            }
            if(inputRequest<>null){
                inputRequest=null;
            }
            if(endPoint<>null){
                endPoint=null;
            }
            if(serviceName<>null){
                serviceName=null;
            }
            if(layer7Callout<>null){
                layer7Callout=null;
            }
        }
        return responseFromService;
    }  
    
    public String buildGetRequestInput(String[] inputDetails,String serviceName){
        String requestInput=null;        
        try{ 
            if(serviceName.equalsIgnoreCase('EntitlementService')){
                requestInput='?topSiteId='+inputDetails[0]+'&startRecNum='+inputDetails[1]+'&recLimit='+inputDetails[2];
            }else if(serviceName.equalsIgnoreCase('SupportingOffering')){
                if(inputDetails[1]<>null && inputDetails[1]<>''){
                    if(inputDetails[1].contains(' ')){
                        String temp=inputDetails[1]+'';
                        temp=temp.replaceAll(' ', '%20');                     
                        requestInput='?topSiteId='+inputDetails[0]+'&cAProductName='+temp;
                        System.debug('requestInput-->'+requestInput);
                    }else{
                        requestInput='?topSiteId='+inputDetails[0]+'&cAProductName='+inputDetails[1];
                    }                    
                }else{
                    requestInput='?topSiteId='+inputDetails[0]+'&startRecNum='+inputDetails[2]+'&recLimit='+inputDetails[3];
                }               
            }       
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());   
        }finally{
            if(inputDetails<>null){
                inputDetails=null;
            }
        }
        return requestInput;
    }
    
    public String tempResoponse(){
        String response='{'+
            '\"status\": \"success\",    '+
            '\"data\": ['+
            '        {'+
            '            \"topsId\": null,'+
            '            \"productName\": \"CA UIM NTW ADV PK ON PREM\",'+
            '            \"productCode\": \"CNMNAP99000\",'+
            '            \"olpOrderId\": null,'+
            '            \"contractNum\": \"40210671\",'+
            '            \"maintTypeCode\": \"M\",'+
            '            \"contractEndDate\": \"2017-09-29 00:00:00.0\",'+
            '            \"maintCancelDate\": \"M\",'+
            '            \"maintTypeName\": null,'+
            '            \"contractStartDate\": \"2014-09-30 00:00:00.0\",'+
            '            \"caProductName\": \"XCOM\",'+
            '            \"suplTypeCode\": \"P\"'+
            '        },'+
            '        {'+
            '            \"topsId\": null,'+
            '            \"productName\": \"CA UIM SVR APP PK ON ADITYA\",'+
            '            \"productCode\": \"CNMSAP99000\",'+
            '            \"olpOrderId\": null,'+
            '            \"contractNum\": \"40210671\",'+
            '            \"maintTypeCode\": \"M\",'+
            '            \"contractEndDate\": \"2017-09-29 00:00:00.0\",'+
            '            \"maintCancelDate\": \"M\",'+
            '            \"maintTypeName\": null,'+
            '            \"contractStartDate\": \"2014-09-30 00:00:00.0\",'+
            '            \"caProductName\": \"APPLICATION DELIVERY ANALYSIS\",'+    
            '            \"suplTypeCode\": \"P\"'+
            '        },'+
            '        {'+
            '            \"topsId\": null,'+
            '            \"productName\": \"CA UIM SVR PK ON RAVI\",'+
            '            \"productCode\": \"CNMSPP99000\",'+
            '            \"olpOrderId\": null,'+
            '            \"contractNum\": \"40210671\",'+
            '            \"maintTypeCode\": \"M\",'+
            '            \"contractEndDate\": \"2017-09-29 00:00:00.0\",'+
            '            \"maintCancelDate\": \"M\",'+
            '            \"maintTypeName\": null,'+
            '            \"contractStartDate\": \"2014-09-30 00:00:00.0\",'+
            '            \"caProductName\": \"CLARITY ON DEMAND\",'+  
            '            \"suplTypeCode\": \"P\"'+
            '        }'+
            '     ]'+
            '}';
        
        return response;    
    }
    
    public String tempResoponseSupportOffering(){
        String response='{'+
            '\"status\": \"success\",    '+
            '\"data\": ['+
            '        {'+
            '            \"offeringCode\": \"ESS GOLD\",'+
            '            \"offeringStartDT\": \"2014-09-30 00:00:00.0\",'+
            '            \"offeringEndDT\": \"2014-09-30 00:00:00.0\",'+
            '            \"assignedEngineer\": \"GOVAD01\"'+
            '        }'+
            '     ]'+
            '}';     
        return response;    
    }
    
    public String tempErrorResponseOne(){
        String response='{'+
            '\"status\": \"success\",    '+
            '\"data\": ['+
            '        {'+
            '        }'+
            '     ]'+
            '}';     
        return response;    
    } 
}