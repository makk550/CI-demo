public class CaseDirectoryCreate
{
    CaseDirectoryCreate()
    {
    }
    
    /*@future(callout=true)
    public static void callEAIforDirectoryCreate(List<String> xmlStrings)
    {
        System.debug('---In CaseDirectoryCreate---');    
        boolean isProd = false;
        boolean isDev = false;
        boolean isQA = false;
        
        if(UserInfo.getOrganizationId().contains('00D300000006yn4'))
        {
            isProd = true;
        }
        else {
            String userName = UserInfo.getUserName();
           	boolean isSandbox = [select isSandbox from Organization LIMIT 1 ].isSandbox;
            if(userName.contains('fsb') && isSandbox ) //userName.contains('ca.com.fsb')
            {
                isQA = true;
            }
            else
            {
                isDev = true;
            }
        }
        
        String endPoint = '';
        
        if(isProd)
        {
            endPoint = Label.EAI_Prod_Case_Directory_Service;
        }
        else if(isQA)
        {
            endPoint = Label.EAI_FSB_Case_Directory_Service;  
        }
        else if(isDev)
        {
            endPoint = Label.EAI_Dev_Case_Directory_Service; 
        }
        
        System.debug('Case Directory Create EndPoint - ' + endpoint);
        System.debug('Case Directory Create xmlStrings - ' + xmlStrings);
        
        for(String xmlString : xmlStrings)
        {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setBody(xmlString);
            
            req.setHeader('Content-Type', 'text/xml');     
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Result from Case Create - ' + res.getBody());  
        }                    
    } */
    
    //callEAIforDirectoryCreateWithRetry
    @future(callout=true)
    public static void callEAIforDirectoryCreate(List<String> xmlStrings) {
        
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        List<CaseDirectoryCreateErrorLog__c> errorLogList = new List<CaseDirectoryCreateErrorLog__c>();
        
        System.debug('---In CaseDirectoryCreate---');    
        boolean isProd = false;
        boolean isDev = false;
        boolean isQA = false;
        
        if(UserInfo.getOrganizationId().contains('00D300000006yn4'))
        {   isProd = true; }
        else {
            String userName = UserInfo.getUserName();
            boolean isSandbox = [select isSandbox from Organization LIMIT 1 ].isSandbox;
            if(userName.contains('fsb') && isSandbox ) //userName.contains('ca.com.fsb')
            { isQA = true; } else { isDev = true;}
        }        
        String endPoint = '';        
        if(isProd) { endPoint = Label.EAI_Prod_Case_Directory_Service; }
        else if(isQA) {  endPoint = Label.EAI_FSB_Case_Directory_Service;  }
        else if(isDev) { endPoint = Label.EAI_Dev_Case_Directory_Service;  }
        
        System.debug('Case Directory Create EndPoint - ' + endpoint);
        System.debug('Case Directory Create xmlStrings - ' + xmlStrings);
        
        for(String xmlString : xmlStrings)
        {   
             String resBody = '';
            try{
                resBody = CaseDirectoryCreate.invokeCreateDirectoryServive(endpoint,xmlString);
                System.debug('resBody:'+resBody);                               
            } catch(Exception e){
                if(e.getMessage().containsIgnoreCase(System.Label.CaseDirectory_ReadTimedOut)){
                    System.debug('Executing retry because of ' + System.label.CaseDirectory_ReadTimedOut +' issue...');
                    errorLogList.add(CaseDirectoryCreate.prepareErrorLog(e,endpoint,xmlString,null)); 
                    try{
                        CaseDirectoryCreate.invokeCreateDirectoryServive(endpoint,xmlString);
                    } catch(Exception ex){
                        errorLogList.add(CaseDirectoryCreate.prepareErrorLog(e,endpoint,xmlString,null));
                    }
                }                
            }
            finally{
                System.debug('In finally block'); 
                if(errorLogList!=null && errorLogList.size()>0 ){
                    insert errorLogList;
                }
            }        
        }    
    }
    
    public static String invokeCreateDirectoryServive(String endpoint,String xmlString){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint); 
        req.setMethod('POST');
        req.setBody(xmlString);  
        req.setTimeout(Integer.valueOf(System.Label.CaseDirectoryCreateTimeout));
        req.setHeader('Content-Type', 'text/xml');    
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Result from Case Create - ' + res.getBody()); 
            return res.getBody();                  
    }
    
    public static CaseDirectoryCreateErrorLog__c prepareErrorLog(Exception e,String endpoint,String input,String responseBody){        
        CaseDirectoryCreateErrorLog__c obj = new CaseDirectoryCreateErrorLog__c();
        obj.Request__c ='Endpoint:'+ endpoint + '\nRequest Body:' + input ;
        obj.Response_Error__c = '';
        if( e != null){
            obj.Response_Error__c = 'Exception Message:' + e.getMessage(); 
        }
        if(responseBody != null){
            obj.Response_Error__c = 'response:' + responseBody ;
        }    
        return obj;
    }
}