@RestResource(UrlMapping='/updatePID')
global class UpdatePID_WS {
    
    
    global class RequestWrapperInfo{
        global string QUOTE_NUMBER;
        
        global List<QuoteLineInfo> Line_Info;
        
    }
    
    global class QuoteLineInfo{
        global string PRODUCT_CODE;
        global String START_DATE;
        global String END_DATE;
        global String Instance_Id;
        
    }
    
   global class MessageResponse{
       
       global List<SuccesLog> SuccessStatus=new List<SuccesLog>();
       global List<ErrLog> ErrorStatus=new List<ErrLog>();  
       global List<MisMatchLog> MissMatchStatus=new List<MisMatchLog>();


       
   }
    
    
    
    global class ErrLog{
        global string ErrorCode;
        global String ErrStatus;
        global string ErrMessage;
    }
    
    global class SuccesLog{
        global string StatusCode;
        global String Status;
        global string Message;

        
        
    }
    
    global class MisMatchLog{
        global String StatusCode;
        global string Message;
        global string PID;
        
        
    }
    
       @HttpPut 
  global static MessageResponse updateQuote(RequestWrapperInfo requestwraper){
      MessageResponse respMessage=new MessageResponse();
          Map<Date,string> InsataneStartDateMap=new Map<Date,String>();
           Map<Date,String> InstanceIdWithEndDateMap=new Map<Date,String>();
           Map<id,SBQQ__QuoteLine__c> quoteLinesMap=new Map<id,SBQQ__QuoteLine__c>();  
           Set<string> productcodes=new Set<string>();
          Set<string> parentmaintainLineitem=new Set<string>();
       if(requestwraper!=null){
          
         
         for(QuoteLineInfo sub:requestwraper.Line_Info){
               InsataneStartDateMap.put(Date.valueOf(sub.START_DATE), sub.Instance_Id);
               InstanceIdWithEndDateMap.put(Date.valueOf(sub.END_DATE), sub.Instance_Id);
               productcodes.add(sub.PRODUCT_CODE);
             System.debug('=======sub====='+sub);

            }
     if(InsataneStartDateMap.size()>0&&InstanceIdWithEndDateMap.size()>0&&productcodes.size()>0&&requestwraper.QUOTE_NUMBER!=null){
         
         Map<string,SBQQ__QuoteLine__c> mismatchMap=new Map<string,SBQQ__QuoteLine__c> ();
         
            List<String> instanceIds=new List<string>();
         Map<Date,SBQQ__QuoteLine__c> StartdateMesage=new Map<Date,SBQQ__QuoteLine__c>();
         Map<Date,SBQQ__QuoteLine__c> EndtDateMesage=new Map<Date,SBQQ__QuoteLine__c>();

     try{  
        
      for(SBQQ__QuoteLine__c squoteLin:[select id,Name,SBQQ__Quote__r.Ramp_Indicator__c,Quote__c,SBQQ__ProductCode__c,End_Date__c,Start_Date__c,Instance_Id__c from SBQQ__QuoteLine__c where Quote__c=:requestwraper.QUOTE_NUMBER  and SBQQ__ProductCode__c=:productcodes ]){
            mismatchMap.put(squoteLin.Quote__c,squoteLin);
           StartdateMesage.put(squoteLin.Start_Date__c, squoteLin);
           EndtDateMesage.put(squoteLin.End_Date__c, squoteLin);
          
          parentmaintainLineitem.add(squoteLin.Name);
          System.debug('======enter no of times'+squoteLin);
        if(InsataneStartDateMap.containsKey(squoteLin.Start_Date__c)&&InstanceIdWithEndDateMap.containsKey(squoteLin.End_Date__c)&&InsataneStartDateMap.get(squoteLin.Start_Date__c)==InstanceIdWithEndDateMap.get(squoteLin.End_Date__c)&&productcodes.contains(squoteLin.SBQQ__ProductCode__c)){
                  squoteLin.Instance_Id__c=InsataneStartDateMap.get(squoteLin.Start_Date__c);
                   instanceIds.add(InsataneStartDateMap.get(squoteLin.Start_Date__c));
                           System.debug('======enter no of times in Instance Id'+ squoteLin.Instance_Id__c);

                   quoteLinesMap.put(squoteLin.id,squoteLin);
                                           
                }
          if(quoteLinesMap.size()>0&&instanceIds.size()>0&&squoteLin.SBQQ__Quote__r.Ramp_Indicator__c==true){
                 squoteLin.Instance_Id__c=instanceIds[0];
                   
                   quoteLinesMap.put(squoteLin.id,squoteLin);  
              
              }
          
                               
            }
         
       for(SBQQ__QuoteLine__c squoteLin:[select id,Quote__c,SBQQ__ProductCode__c,End_Date__c,Start_Date__c,Instance_Id__c from SBQQ__QuoteLine__c where Maintenance_Parent_Quote_Line__c IN :parentmaintainLineitem and Quote__c=:requestwraper.QUOTE_NUMBER]){
            if(InsataneStartDateMap.containsKey(squoteLin.Start_Date__c)&&InstanceIdWithEndDateMap.containsKey(squoteLin.End_Date__c)&&InsataneStartDateMap.get(squoteLin.Start_Date__c)==InstanceIdWithEndDateMap.get(squoteLin.End_Date__c)){
                  squoteLin.Instance_Id__c=InsataneStartDateMap.get(squoteLin.Start_Date__c);
                   instanceIds.add(InsataneStartDateMap.get(squoteLin.Start_Date__c));
                  quoteLinesMap.put(squoteLin.id,squoteLin);
                                           
                }   
             
         }      
         
   }catch(Exception ex){
      ErrLog resperr=new ErrLog();
      resperr.ErrorCode='450';
      resperr.ErrStatus='ERROR';
      resperr.ErrMessage=ex.getMessage(); 
      respMessage.ErrorStatus.add(resperr);
       return respMessage;
                         
       }
       for(QuoteLineInfo sub:requestwraper.Line_Info){
           if(!StartdateMesage.containsKey(Date.valueOf(sub.START_DATE))||!EndtDateMesage.containsKey(Date.valueOf(sub.END_DATE))||!mismatchMap.containsKey(requestwraper.QUOTE_NUMBER)){
                  MisMatchLog missMat=new MisMatchLog();
                  missMat.StatusCode='101';
                  missMat.PID=sub.Instance_Id;
                  missMat.Message='Quote Line items not found with given Start date and End date and Quote Number';
              respMessage.MissMatchStatus.add(missMat); 
                  
              }
              
            }
            
      
     if(quoteLinesMap.size()>0&&quoteLinesMap.values()!=null&&quoteLinesMap.values().size()>0){
            DataBase.SaveResult[] srRes=DataBase.Update(quoteLinesMap.values(),false);
             //responseLogs(srRes,instanceIds); 
   if(srRes!=null){
       for(Integer i=0;i<srRes.size();i++){

          if (!srRes[i].isSuccess()) {
        // Operation failed, so get all errors  

           for(Database.Error err : srRes[i].getErrors()) {
              ErrLog resperr=new ErrLog();
               resperr.ErrorCode='500'; 
                resperr.ErrStatus='ERROR';
                resperr.ErrStatus=err.getMessage();
               respMessage.ErrorStatus.add(resperr);
    
            }
           
   
    }
    
     if(srRes[i].isSuccess()){
       SuccesLog SucceL=new SuccesLog();
          SucceL.StatusCode='200';
          SucceL.Status='SUCCESS';
          SucceL.Message='Record updated successfully';
           respMessage.SuccessStatus.add(SucceL);
          
     
          }
    }
      
   }   
            
    }
            
 }             
                       
    }
  return respMessage; 
        
 }
    


}