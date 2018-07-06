public with sharing class Service_Request {
    public  Services_Request__c sr {get; set;}
    opportunity opp;   

    public Service_Request(ApexPages.StandardController controller) {
        sr = new Services_Request__c();
        opp = (opportunity)(controller.getrecord());
    }
    
    public pagereference ApplySelection()
    {        
           if(opp!= null && opp.id != null)
           {   
            opp = [Select accountid, ownerid,CurrencyIsoCode from opportunity where id=: opp.id]; // to retrieve the accountid ,CurrencyIsoCode AR3894  
               
            sr.Oppty_Name__c = opp.id;
            sr.Account_Name__c = opp.accountId;
            sr.ownerid = opp.ownerid;
            

            /* Anthony Russell - commented this line of code out to enable the replacement of the Service Note Oppty_Owner field with a new formula based field.
            sr.Oppty_Owner__c =opp.ownerid ; 
            */

            
            sr.CurrencyIsoCode = opp.CurrencyIsoCode;   //AR 3894
            insert sr;
            return new pagereference('/p/attach/NoteAttach?pid=' + sr.id + '&retURL=%2F' + sr.id);
           }
           
           Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Please select opportunity'));
           return null;
    }
    
}