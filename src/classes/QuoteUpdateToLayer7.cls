public class QuoteUpdateToLayer7{

    public QuoteUpdateToLayer7(){
        
    }
    @future(callout=true)
    public static void callQuoteUpdate(List<String> requestPayload){
        List<Organization> orgObj = [select Id, IsSandbox from Organization limit 1 ];
        String endpointVal2 = Label.Cpq_end_point;
    for(String requestPayloadObj:requestPayload){
                  HttpRequest req2 = new HttpRequest();
                  req2.setHeader('Content-Type', 'text/xml');
                  req2.setTimeout(60000);
                  req2.setEndpoint(endpointVal2);
                  req2.setMethod('POST');
                  req2.setBody(requestPayloadObj);
                  system.debug('req payload:--------'+requestPayloadObj);
                  Http http2 = new Http();    
                  if(req2<>null){
                  HTTPResponse res2 = http2.send(req2);                                
                  // Log the XML content
                  system.debug(res2.getBody());
                  }
          }
    }
       
    public static void callQuoteUpdatefromFutureMethod(List<String> requestPayload){
     List<Organization> orgObj = [select Id, IsSandbox from Organization limit 1 ];
        String endpointVal2 = Label.Cpq_end_point;
    for(String requestPayloadObj:requestPayload){
                  HttpRequest req2 = new HttpRequest();
                  req2.setHeader('Content-Type', 'text/xml');
                  req2.setTimeout(60000);
                  req2.setEndpoint(endpointVal2);
                  req2.setMethod('POST');
                  req2.setBody(requestPayloadObj);
                  system.debug('callQuoteUpdateToLayer7fromFutureMethod req payload:--------'+requestPayloadObj);
                  Http http2 = new Http();    
                  if(req2<>null){
                  HTTPResponse res2 = http2.send(req2);                                
                  // Log the XML content
                  system.debug(res2.getBody());
                  }
            }
}  
}