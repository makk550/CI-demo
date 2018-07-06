/***************************************************************************
Name : SAPUpdateQuote_WS
Created By :Patsa27
Created Date : August 17, 2017
Description : SAPUpdateQuote_WS class update the Quote Data from SAP.
***************************************************************************/
@RestResource(urlMapping='/updateQuote')
global class SAPUpdateQuote_WS {
    
     global class RequestWrapper{
          global String quoteNumber;
          global RequestInputData requestInputs;
     } 
    
    global class RequestInputData{
        
         global String quoteStatus;
         global string SAPQuoteNumber;
		 global LogMessages Messages;
        
    }
	global class LogMessages{
	   global List<IncomplitionLog> item=new List<IncomplitionLog>() ;	
	}
	
	
    global class IncomplitionLog{
        
        global string Message;
    }
    
   
    global class ResponseLog{
		global string QuoteId;
        global string Status;
		global List<MesageResponse> Log_Messages=new List<MesageResponse>();
        
        
    }
     global class MesageResponse{
        global string Message;        
       
        
    }
    
   
   

      @HttpPut
  global static ResponseLog updateQuote(RequestWrapper requestwraper)
    {
        System.debug('=============SAP');
       ResponseLog Messages=new ResponseLog();
       MesageResponse resperr=new MesageResponse();

  if(requestwraper!=null&&requestwraper.requestInputs!=null&&String.isNotBlank(requestwraper.quoteNumber)){
       SBQQ__Quote__c squote=new SBQQ__Quote__c() ;
           try{
               System.debug('requestwraper.quoteNumber===='+requestwraper.quoteNumber);
             squote=[select id,SAP_Quote_Status__c,SAP_Quote_Number__c,Name from SBQQ__Quote__c where Name =:requestwraper.quoteNumber];
             System.debug('========'+requestwraper.requestInputs.Messages);
		     inCompliteLogs(requestwraper.requestInputs,requestwraper.quoteNumber,squote);				
                  
           }catch(Exception ex){
             Messages.Status='ERROR';
             resperr.Message=ex.getMessage();
             Messages.QuoteId=requestwraper.quoteNumber;  
             Messages.Log_Messages.add(resperr);
                       System.debug('======Json=='+JSON.serialize(Messages));

             return Messages; 
                  
              }
	      if(squote!=null&&String.isNotBlank(requestwraper.requestInputs.quoteStatus)){
              
			  squote.SAP_Quote_Status__c=requestwraper.requestInputs.quoteStatus;
			  squote.SAP_Quote_Number__c=requestwraper.requestInputs.SAPQuoteNumber;
			  DataBase.SaveResult saveRes=DataBase.update(squote,false);
			  Messages=responseLogs(saveRes,squote);
				  				  
          }else {
              Messages.Status='ERROR ';
              resperr.Message='Quote Status should not be blank ';
              Messages.QuoteId=requestwraper.quoteNumber;  
              Messages.Log_Messages.add(resperr);
                      System.debug('======Json=='+JSON.serialize(Messages));

              return Messages;         
              }
			     
      }else{
            Messages.Status='ERROR';
            resperr.Message='Data not exist with given Request inputs ';
            Messages.QuoteId=requestwraper.quoteNumber;  
            Messages.Log_Messages.add(resperr);
                  System.debug('======Json=='+JSON.serialize(Messages));

            return Messages;
		  	  		  
	  }
        
        System.debug('======Json=='+JSON.serialize(Messages));
    
  return Messages;
 }
 /*This method to process the SAP Log messages and stored in Object. 
  **/
 
 public static void inCompliteLogs(RequestInputData inputs,String QuoteNumber,SBQQ__Quote__c squte){
	 
	 List<SAPLog_Message__c> InsertLoglist=new List<SAPLog_Message__c>();
	 

	  if(inputs!=null&&squte!=null&&String.isNotBlank(inputs.quoteStatus)&&(inputs.quoteStatus.containsIgnoreCase('SUCCESS')||inputs.quoteStatus.containsIgnoreCase('ERROR'))){
				 for(IncomplitionLog log: inputs.Messages.ITEM){
					SAPLog_Message__c SAPmessage= new SAPLog_Message__c();
					  SAPmessage.Messages__c=log.Message;
					 // SAPmessage.Name=QuoteNumber;                 
					  SAPmessage.Status__c=inputs.quoteStatus;
                      SAPmessage.Log_Date__c=System.now();
                      SAPmessage.Quote__c=squte.id;
                      SAPmessage.SAP_Quote_Number__c=inputs.SAPQuoteNumber;
					  InsertLoglist.add(SAPmessage);					 
				 }
				 
			if(InsertLoglist.size()>0){
				insert InsertLoglist;
				
			} 
			 
			 
		 }
	 
	 
	 
	 
 }
	
	
	
public static ResponseLog responseLogs(DataBase.SaveResult srRes,SBQQ__Quote__c quote){
    
         ResponseLog Messages=new ResponseLog();
    if(srRes!=null&&quote!=null){

          if (!srRes.isSuccess()) {
        // Operation failed, so get all errors  
            ResponseLog ErrorrespLog=new ResponseLog();

           for(Database.Error err : srRes.getErrors()) {
                MesageResponse resperr=new MesageResponse();
                ErrorrespLog.Status='ERROR';
                resperr.Message=err.getMessage();
                ErrorrespLog.QuoteId=quote.name;
                ErrorrespLog.Log_Messages.add(resperr);
    
            }
           
                Messages=ErrorrespLog;
   
    }
    
     if(srRes.isSuccess()){
	   ResponseLog SuccessrespLog=new ResponseLog();
          MesageResponse sucresp=new MesageResponse();
          SuccessrespLog.Status='SUCCESS';
          sucresp.Message='Record updated successfully';
          SuccessrespLog.QuoteId=quote.Name;
          SuccessrespLog.Log_Messages.add(sucresp);
           Messages=SuccessrespLog;
     
          }
      
}   
   return Messages;
	
		
	}
}