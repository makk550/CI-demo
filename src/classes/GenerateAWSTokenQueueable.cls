public class GenerateAWSTokenQueueable implements Queueable,Database.AllowsCallouts{
    public void execute(QueueableContext context) {
        updateAWSToken(generateAWSToken());
    }
    // Below AWS Token generation process  exist in CC_Layer7Service class also, If you are doing any changes please do it on other class also 
    public static string generateAWSToken(){
    JSON2Token jsontoken;
        System.debug('aws token generation======');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CC_Settings.eaiAWSTokenURL);
        req.setMethod('GET');
        req.setTimeout(20*1000);
        req.setHeader('consumerUserName', 'IntegrationEAICSO');
        Http http = new Http();
        //if(!Test.isRunningTest()){
        HTTPResponse res = http.send(req);
            jsontoken = parse(res.getBody());
        System.debug('token======'+jsontoken.token);
         //}
        return jsontoken.token;
    }
     public class JSON2Token {
            public String token;
    }
    public static JSON2Token parse(String json) {
        return (JSON2Token) System.JSON.deserialize(json, JSON2Token.class);
    }
    public static void updateAWSToken(String token){
        aws_security_token__c tokenstr;
        try{
          tokenstr = aws_security_token__c.getValues('awstoken');
            tokenstr.token_str2__c = '';
            tokenstr.token_str3__c = '';
            tokenstr.token_str4__c = '';
            tokenstr.token_str5__c = '';
            tokenstr.token_str6__c = '';    
        }catch(NullPointerException e){
            System.debug('token exception failure in GenerateAWSTokenQueueable');
            //CC_ngTurkeyController.invocationPath = CC_ngTurkeyController.invocationPath + '=updateAWSToken';
            //CC_ngTurkeyController.insertCCErrorLog(e.getMessage() + '\n Stacktrace:\n' + e.getStackTraceString() , CC_ngTurkeyController.invocationPath);
            return ; //TODO: check this
        }
  
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
}