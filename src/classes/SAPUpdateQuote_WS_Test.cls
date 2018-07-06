@isTest
public class SAPUpdateQuote_WS_Test {
    
public static testMethod void testSAPQuoteUpdate(){
      testCreateQuoteAndQuoteLine.createTestData();
    
    SBQQ__Quote__c squte=[select id,Name from SBQQ__Quote__c LIMIT 1];
    
SAPUpdateQuote_WS.IncomplitionLog incomltlog=new  SAPUpdateQuote_WS.IncomplitionLog();
    incomltlog.Message='Quote Save Successfully';
SAPUpdateQuote_WS.LogMessages Messaglog=new  SAPUpdateQuote_WS.LogMessages();
      Messaglog.item.add(incomltlog);
    
SAPUpdateQuote_WS.RequestInputData reqlog=new  SAPUpdateQuote_WS.RequestInputData();
    reqlog.quoteStatus='SUCCESS';
    reqlog.SAPQuoteNumber='0001241380';
    reqlog.Messages=Messaglog;
    
 SAPUpdateQuote_WS.RequestWrapper reqwrap=new  SAPUpdateQuote_WS.RequestWrapper();
       reqwrap.quoteNumber=squte.Name;
    
       reqwrap.requestInputs=reqlog;
    
    
    
   Test.startTest();

   //RestRequest req = new RestRequest(); 
   //RestResponse res = new RestResponse();

   // req.requestURI = '/services/apexrest/updateQuote';  //Request URL
   // req.httpMethod = 'PUT';//HTTP Request Type
   // req.requestBody = Blob.valueof(JsonMsg);
   // RestContext.request = req;
   // RestContext.response= res;
 SAPUpdateQuote_WS.updateQuote(reqwrap);
    Test.stopTest();
        
    
        
    }
    
    
public static testMethod void testErrorLogSAPQuoteUpdate(){
     
SAPUpdateQuote_WS.IncomplitionLog incomltlog=new  SAPUpdateQuote_WS.IncomplitionLog();
    incomltlog.Message='Quote Save Successfully';
SAPUpdateQuote_WS.LogMessages Messaglog=new  SAPUpdateQuote_WS.LogMessages();
      Messaglog.item.add(incomltlog);
    
SAPUpdateQuote_WS.RequestInputData reqlog=new  SAPUpdateQuote_WS.RequestInputData();
    //reqlog.quoteStatus='';
    reqlog.SAPQuoteNumber='0001241380';
    reqlog.Messages=Messaglog;
    
 SAPUpdateQuote_WS.RequestWrapper reqwrap=new  SAPUpdateQuote_WS.RequestWrapper();
       reqwrap.quoteNumber='';
    
       reqwrap.requestInputs=reqlog;
    
    
    
   Test.startTest();

  
 SAPUpdateQuote_WS.updateQuote(reqwrap);
    Test.stopTest();
        
    
        
    }
    
    
    public static testMethod void testErrorLogforStatuesSAPQuoteUpdate(){
      testCreateQuoteAndQuoteLine.createTestData();
    
    SBQQ__Quote__c squte=[select id,Name from SBQQ__Quote__c LIMIT 1];
    
SAPUpdateQuote_WS.IncomplitionLog incomltlog=new  SAPUpdateQuote_WS.IncomplitionLog();
    incomltlog.Message='Quote Save Successfully';
SAPUpdateQuote_WS.LogMessages Messaglog=new  SAPUpdateQuote_WS.LogMessages();
      Messaglog.item.add(incomltlog);
    
SAPUpdateQuote_WS.RequestInputData reqlog=new  SAPUpdateQuote_WS.RequestInputData();
    reqlog.quoteStatus='';
    reqlog.SAPQuoteNumber='0001241380';
    reqlog.Messages=Messaglog;
    
 SAPUpdateQuote_WS.RequestWrapper reqwrap=new  SAPUpdateQuote_WS.RequestWrapper();
       reqwrap.quoteNumber=squte.Name;
    
       reqwrap.requestInputs=reqlog;
    
    
    
   Test.startTest();

   //RestRequest req = new RestRequest(); 
   //RestResponse res = new RestResponse();

   // req.requestURI = '/services/apexrest/updateQuote';  //Request URL
   // req.httpMethod = 'PUT';//HTTP Request Type
   // req.requestBody = Blob.valueof(JsonMsg);
   // RestContext.request = req;
   // RestContext.response= res;
 SAPUpdateQuote_WS.updateQuote(reqwrap);
    Test.stopTest();
        
    
        
    }
    
    
    
    
    

}