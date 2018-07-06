trigger au_CopyQuoteNumberToTR on Quote_Request__c (after update) 
{
    //Updated by Nomita on 04/06/2010
    //The SOQL was present inside a FOR loop which was hitting the governor limits on number of SOQLs,
    //Hence made the correction by removing the query from the FOR loop
    Set<String> setTrialReq = new Set<String>();
    List<Quote_Request__c> qr1 = new List<Quote_Request__c>();
    for(Quote_Request__c qr:Trigger.new)
    {
        if(qr.Request_Status__c=='Complete' && qr.Trial_Request__c!=null)
        {
            setTrialReq.add(qr.Trial_Request__c);
            qr1.add(qr);
        }
    }
    if(setTrialReq.size()>0)
    {
        List<Trial_Request__c> tr = new List<Trial_Request__c>();
        tr = [select Quote_Number__c,Id from Trial_Request__c where id in: setTrialReq];
        if(tr.size()>0)
        {
            for(Quote_Request__c temp_qr:qr1)
            {
                for(Trial_Request__c tr1 : tr)
                {
                    if(tr1.Id == temp_qr.Trial_Request__c)
                        tr1.Quote_Number__c = temp_qr.Quote_Number__c;
                       
                }
            }
            try{
                update tr;
            }catch(DMLException ex){
                System.debug(ex);
            }
        }
    }
    //ORIGINAL CODE -- COMMENTED OUT
    /*
    for(Quote_Request__c qr:Trigger.new){
        if(qr.Request_Status__c=='Complete' && qr.Trial_Request__c!=null){
            //qr.Request_Status__c.addError(qr.Trial_Request__c);
            Trial_Request__c tr = [select Quote_Number__c from Trial_Request__c where id=:qr.Trial_Request__c];
            try{    
                    if(tr!=null){
                        tr.Quote_Number__c = qr.Quote_Number__c;
                        update tr;
                    }
               }
            catch (Exception e) {
              }      
        }
    }
    */
}