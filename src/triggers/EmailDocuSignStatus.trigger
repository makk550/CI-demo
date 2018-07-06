/************************************************************************************************
* Test Class : EmailRecipientStatus_Test
* Code Coverage : 	74%
* Modified By        Date           User Story              Details
* SAMAP01           02/23/2018      Prod Issue-100-514161   Docusign email recipient status

* **********************************************************************************************/
trigger EmailDocuSignStatus on dsfs__DocuSign_Status__c (before update) {
   Boolean sendEmailFlag = false ;
     String Message1 ='<p style="font-family:calibri">The following DocuSign Status records are tried to be updated by User: <b>'+UserInfo.getName()+'</b> <br/>';
     String Message = '';
     Map<Id,String> recMap = new Map<Id,String>();
     //samap01  -dsfs__DocuSign_Recipient_Status__c.id 
    Set<Id> docsignids = Trigger.oldMap.keySet();    
    Set<Id> scbookids = new Set<Id>();
    for (dsfs__DocuSign_Status__c rsc : Trigger.old) 
    {
        System.debug('samap01 rsc.SA_Booking__c' + rsc.SA_Booking__c +'-id' + rsc.id);
         scbookids.add(rsc.SA_Booking__c);      
    }
       
    System.debug('samap01 scbookids'+scbookids);
     Map<Id,SA_Booking__c> SAbookingMap =new Map<Id,SA_Booking__c>();
     SAbookingMap.putAll([Select Id,Name from SA_Booking__C where Id in :scbookids ]);
      Boolean skip = false ; 
     List<String> escapeList = Label.DocuSignEscapeUsers.split(',');
    for(string es :escapeList)
    {
        if(es==UserInfo.getUserName())
        {
          skip=true;
           System.debug('Escaping User'+UserInfo.getUserName());
        }
        
        
    }
    
    if(!skip)
    {
     
   for (dsfs__DocuSign_Status__c doc : trigger.new){
       if(trigger.oldmap.get(doc.id).SA_Booking__c !=null)
       {
          sendEmailFlag = false ;
          Message ='<br/><b>-->SA Booking number</b>'+SAbookingMap.get(trigger.oldmap.get(doc.id).SA_Booking__c).name+'<br/><b>&nbsp  Envelope#: </b>'+trigger.oldmap.get(doc.id).name+'<br/>&nbsp  Changes are : ';
        if( trigger.oldmap.get(doc.id).dsfs__Completed_Date_Time__c != null && trigger.oldmap.get(doc.id).dsfs__Completed_Date_Time__c != doc.dsfs__Completed_Date_Time__c){
              sendEmailFlag = true;
              Message+='<br/><b>&nbsp Completed Date Time </b> from: '+trigger.oldmap.get(doc.id).dsfs__Completed_Date_Time__c+' to : '+doc.dsfs__Completed_Date_Time__c;
              doc.dsfs__Completed_Date_Time__c=trigger.oldmap.get(doc.id).dsfs__Completed_Date_Time__c;
    
        }
        if( trigger.oldmap.get(doc.id).dsfs__Declined_Date_Time__c != null && trigger.oldmap.get(doc.id).dsfs__Declined_Date_Time__c != doc.dsfs__Declined_Date_Time__c){
              sendEmailFlag = true;
              Message+='<br/><b>&nbsp Declined Date Time </b> from: '+trigger.oldmap.get(doc.id).dsfs__Declined_Date_Time__c+' to: '+doc.dsfs__Declined_Date_Time__c;
              doc.dsfs__Declined_Date_Time__c=trigger.oldmap.get(doc.id).dsfs__Declined_Date_Time__c;
        }
        if( trigger.oldmap.get(doc.id).dsfs__Viewed_Date_Time__c != null && trigger.oldmap.get(doc.id).dsfs__Viewed_Date_Time__c != doc.dsfs__Viewed_Date_Time__c){
              sendEmailFlag = true;
              Message+='<br/><b>&nbsp Viewed Date Time </b> from: '+trigger.oldmap.get(doc.id).dsfs__Viewed_Date_Time__c+' to: '+doc.dsfs__Viewed_Date_Time__c;
              doc.dsfs__Viewed_Date_Time__c=trigger.oldmap.get(doc.id).dsfs__Viewed_Date_Time__c;
    
        }
        if( trigger.oldmap.get(doc.id).dsfs__Sent_Date_Time__c != null && trigger.oldmap.get(doc.id).dsfs__Sent_Date_Time__c != doc.dsfs__Sent_Date_Time__c){
              sendEmailFlag = true;
              Message+='<br/><b>&nbsp Sent Date Time </b> from: '+trigger.oldmap.get(doc.id).dsfs__Sent_Date_Time__c+' to: '+doc.dsfs__Sent_Date_Time__c;
              doc.dsfs__Sent_Date_Time__c=trigger.oldmap.get(doc.id).dsfs__Sent_Date_Time__c;
        }
        
        if( trigger.oldmap.get(doc.id).dsfs__Voided_Date_Time__c != null && trigger.oldmap.get(doc.id).dsfs__Voided_Date_Time__c != doc.dsfs__Voided_Date_Time__c){
              sendEmailFlag = true;
              Message+='<br/><b>&nbsp  Voided Date Time </b> from: '+trigger.oldmap.get(doc.id).dsfs__Voided_Date_Time__c+' to: '+doc.dsfs__Voided_Date_Time__c+' ';
              doc.dsfs__Voided_Date_Time__c=trigger.oldmap.get(doc.id).dsfs__Voided_Date_Time__c;
        }
        
         if(sendEmailFlag){
            recMap.put(doc.id,Message);  
          }
   
        }
   }
      
      if(recMap.size()>0){
        // call email service
         String body = message1+'';
        for(dsfs__DocuSign_Status__c doc1 : trigger.new){
        
                if(recMap!=null && recMap.get(doc1.id)!=null)
                     body+=recMap.get(doc1.id)+'<br>';
        
        } 
      DocusignEmailAlert alert = new DocusignEmailAlert();
         alert.sendAlert(body);
      
      }
}
}