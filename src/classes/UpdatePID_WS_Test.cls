@isTest
public class UpdatePID_WS_Test {
    
public static testMethod void testPIDService(){
        testCreateQuoteAndQuoteLine.createTestData();
        
  SBQQ__QuoteLine__c squoteLin=[select id,Quote__c,SBQQ__ProductCode__c,End_Date_Price_Rule__c,End_Date__c,Start_Date__c,Instance_Id__c from SBQQ__QuoteLine__c LIMIT 1 ];
     System.debug('=======squoteLin'+squoteLin.Start_Date__c);
         System.debug('=======squoteLin'+squoteLin.End_Date__c);


    List< UpdatePID_WS.QuoteLineInfo> listQuoteinfo=new  List<UpdatePID_WS.QuoteLineInfo>();
    UpdatePID_WS.QuoteLineInfo quoteLineInfo=new  UpdatePID_WS.QuoteLineInfo();
    quoteLineInfo.PRODUCT_CODE=squoteLin.SBQQ__ProductCode__c;
    quoteLineInfo.START_DATE=String.valueOf(squoteLin.Start_Date__c);
    quoteLineInfo.END_DATE=String.valueOf(squoteLin.End_Date__c);
    quoteLineInfo.Instance_Id='55457';
    listQuoteinfo.add(quoteLineInfo);
   UpdatePID_WS.RequestWrapperInfo quoterequestWraper=new  UpdatePID_WS.RequestWrapperInfo();
      quoterequestWraper.QUOTE_NUMBER=squoteLin.Quote__c;
      quoterequestWraper.Line_Info=listQuoteinfo;
             
    Test.startTest();
    UpdatePID_WS.updateQuote(quoterequestWraper);
    Test.stopTest();

        
        
        
    }
    
    
    public static testMethod void testPIDErrorLogService(){
        testCreateQuoteAndQuoteLine.createTestData();
        
  SBQQ__QuoteLine__c squoteLin=[select id,Quote__c,SBQQ__ProductCode__c,End_Date__c,Start_Date__c,Instance_Id__c from SBQQ__QuoteLine__c LIMIT 1 ];
    List< UpdatePID_WS.QuoteLineInfo> listQuoteinfo=new  List<UpdatePID_WS.QuoteLineInfo>();
    UpdatePID_WS.QuoteLineInfo quoteLineInfo=new  UpdatePID_WS.QuoteLineInfo();
    quoteLineInfo.PRODUCT_CODE=squoteLin.SBQQ__ProductCode__c;
    quoteLineInfo.START_DATE='2017-11-03';
    quoteLineInfo.END_DATE='2018-06-09';
    quoteLineInfo.Instance_Id='55457';
    listQuoteinfo.add(quoteLineInfo);
   UpdatePID_WS.RequestWrapperInfo quoterequestWraper=new  UpdatePID_WS.RequestWrapperInfo();
      quoterequestWraper.QUOTE_NUMBER='Q-000234';
      quoterequestWraper.Line_Info=listQuoteinfo;
             
    Test.startTest();
    UpdatePID_WS.updateQuote(quoterequestWraper);
    Test.stopTest();

        
        
        
    }
    
    

}