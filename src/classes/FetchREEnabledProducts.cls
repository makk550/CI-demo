public class FetchREEnabledProducts {
  
    public String fetchOauthToken(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setEndpoint(System.Label.REProducts_Login_Endpoint);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        String requestBody = System.Label.REProducts_Login_RequestBody;
        request.setBody(requestBody);        
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            return response.getHeader('OAuth');
        } else {
            return null;
        }
    }
    
    public void fetchREEnabledProductsFromService() {
        String response='';
        String token = '';
        try {
            token = fetchOauthToken();
            if( token != null ) {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(System.Label.REProducts_Fetch_Endpoint);
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Authorization', 'bearer ' + token );
                request.setMethod('GET');
                
                HttpResponse responseObj = http.send(request);  
                System.debug('responseObj:'+responseObj);
                //System.debug('responseObj:'+ responseObj.getBody());
                if(responseObj.getStatusCode() == 200){
                    insertREProducts(getProductsList(responseObj.getBody()));
                } else {
                    //TODO: Send email notification to a group on failure of this service.                
                    String emailBody = 'Scheduled Job of RE Enabled Products Failed. Next attempt will be done tomorrow at 12:30 AM EST';
                    emailBody += '\nEndpoint:'+ System.Label.REProducts_Fetch_Endpoint;
                    emailBody += 'Response:' + responseObj ;  
                    sendEmailonError(emailBody);                
                }
            }
        } catch(Exception e){
            String emailBody = 'Scheduled Job of RE Enabled Products Failed. Next attempt will be done tomorrow at 12:30 AM EST';
            emailBody += '\nEndpoint:'+ System.Label.REProducts_Fetch_Endpoint;
            emailBody += '\nException Message:' + e.getMessage() ; 
            emailBody += '\nException StackTrace:' + e.getStackTraceString() ;  
            sendEmailonError(emailBody);
        }
    
    }
    
    public List<String> getProductsList(String responseFromService){
        List<String> prodList = new List<String>();
    Util_JSONParser parser = Util_JSONParser.createParser(responseFromService);
        String productsArray = parser.get('products').Value;
        List<Util_JSONParser> arrayParser = Util_JSONParser.parseArray(productsArray);
        for (Util_JSONParser p : arrayParser) {
            prodList.add(p.get('name').Value);
        }        
        System.debug('From service:prodList.size():'+prodList.size());
        return prodList;
    }
  
    public void insertREProducts(List<String> productsList){        
        List<Remote_Engineer_Products__c> reProductsList = Remote_Engineer_Products__c.getall().values();
        System.debug('Initial reProductsList size:'+reProductsList.size());        
        //Savepoint sp = Database.setSavepoint(); 
        database.delete(reProductsList);        
        List<Remote_Engineer_Products__c> reProductsListToInsert = new List<Remote_Engineer_Products__c>();
        Integer i = 0;
        for(String product : productsList ) {
            Remote_Engineer_Products__c rep = new Remote_Engineer_Products__c();
            rep.name= String.valueOf(++i);
            rep.Product_Name__c = product;
            reProductsListToInsert.add(rep);
        }
       Database.insert(reProductsListToInsert,false);
    }
    
    public void sendEmailonError(String emailContent){
        List<String> toAddressList = System.Label.RE_Error_Send_Notification.Split(';');
        //String[] toAddressList = new String[]{  System.Label.RE_Error_Send_Notification }; 
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddressList);
        email.setSubject('Scheduled Job of RE Enabled Products Failed');                       
        email.setHtmlBody(emailContent);
        email.setSaveAsActivity(false);
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { email} );
        
    }
    
}