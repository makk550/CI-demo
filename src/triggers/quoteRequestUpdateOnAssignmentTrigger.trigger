trigger quoteRequestUpdateOnAssignmentTrigger on Quote_Request__c (before update) {
    //## Summary: update the Request Status field on the
    //## Quote Request record to 'Accepted' when the ownership
    //## is changed to a User.  This Trigger was written in 
    //## order to overcome an issue with SFDC.
    //Trigger was updated on 2/24/2008 to fix SOQL querys inside a loop    
    for (Quote_Request__c qrold : Trigger.old) 
    {
         Quote_Request__c qrnew = Trigger.newMap.get(qrold.Id);        
        String qrnewOwnerIdStr = String.valueOf(qrnew.OwnerId); 
        // only continue if the new Owner is a User
        if (qrnewOwnerIdStr.substring(0,3) != '005')
        {
            break;
        }        
        if ((qrold.OwnerId != qrnew.OwnerId && qrnew.OwnerId == qrnew.LastModifiedById && (qrnew.Request_Status__c == 'New' || qrnew.Request_Status__c == 'Accepted') )  )
   //##&& qrnew.OwnerId == qrnew.LastModifiedById -- Added Srini
        {                                        
            qrnew.Request_Status__c = 'Accepted';                
        } 
    }
}