global class SFDCtoSAPIntegration {
   
   
    global Static String sendDatatoSAP(String QuoteId){  
      // SAPRequestPayLoadUtility DETAILS=new SAPRequestPayLoadUtility();
        
        SAPRequestPayload sapPayload=new SAPRequestPayload();
        
               //String json=DETAILS.toJson();
              string json=sapPayload.requestDataInjson(QuoteId);
      System.debug('-----JSONData----------'+json);     
        return json;
    }
    
    global class SAPResponseback{
       global  ResponseMessage MT_SFDC_SALES_RESTAPI_RESP=new ResponseMessage();
        
    }
	global class ResponseMessage{
		global RowresponseMessage row=new RowresponseMessage();
		
	}
	
	global class RowresponseMessage{
		global string MSG;
		
	}
	
    Webservice static String doBasicAuthenticationCalloutWithNameCreaditial(String QuoteId){
      String jsonRequest=sendDatatoSAP(QuoteId);
      String messsage='';
         Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        HttpResponse response=new HttpResponse();
        req.setMethod('POST'); 
        req.setEndpoint('callout:SFDC_XI_SAP');
        req.setTimeout(15000);
        req.setBody(jsonRequest);
        try{
          response = http.send(req); 
        }catch(System.CalloutException ex){
            try{
             response = http.send(req);     
            }catch(Exception ex1){
              messsage=ex1.getMessage(); 
              return messsage;    
            }
        
        }
     if(response.getStatusCode()==200&&response.getStatus()=='OK'){
         String jsonResponse=(String)response.getBody();
      System.debug('jsonResponse======='+jsonResponse);
		SAPResponseback RESP=(SAPResponseback)JSON.deserializeStrict(jsonResponse,SAPResponseback.class);
        System.debug('MT_SFDC_SALES_RESTAPI_RESP'+RESP);
		 messsage=RESP.MT_SFDC_SALES_RESTAPI_RESP.row.MSG;
      }else{
       String jerresponse=(String)response.getBody();
      System.debug('jerresponse======'+jerresponse);
        messsage=String.valueOf(response.getStatus());  
      }
       return messsage; 
    }
   
   

}