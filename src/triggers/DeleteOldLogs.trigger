trigger DeleteOldLogs on SAPLog_Message__c(before Insert){

   set<id> quoteId=new set<id>();
    List<SAPLog_Message__c> saplogs=new List<SAPLog_Message__c>();
   
   for(SAPLog_Message__c saplog:trigger.new){
   
      quoteId.add(saplog.Quote__c);
   
   
   
   }
   
   if(quoteId.size()>0){
     saplogs=[select id from SAPLog_Message__c where Quote__c=:quoteId];
     
       if(saplogs.size()>0){
         delete saplogs;
       
       }
   
   }



}