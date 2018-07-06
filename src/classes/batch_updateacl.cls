global class batch_updateacl implements Database.Batchable<sObject>,Database.Stateful   
{
    String query ;
    String failedDML = '';
    Date currentdate = System.today();
    global batch_updateacl()
    {
        
    }
    /* Batch class constructor */
    //Start method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        query='select Id,Material_TARR_LC__c,Do_Not_Use_Material_TARR_LC__c	from '+
            	' Active_Contract_Line_Item__c  where Material_TARR_LC__c =null  ';
        
        
        System.debug('samap01 +string query' + query);
        return Database.getQueryLocator(query);
    }
    
    //Excute method
    
    global void execute(Database.BatchableContext BC, List<Active_Contract_Line_Item__c> scope)
    {
        //Excution logic
        //List<Opportunity> opp= new List<Opportunities>();
     List<Active_Contract_Line_Item__c> updatedacllist = 
        new List<Active_Contract_Line_Item__c>();
       for(Active_Contract_Line_Item__c ac: scope)
        {
             ac.Material_TARR_LC__c = ac.Do_Not_Use_Material_TARR_LC__c;
               updatedacllist.add(ac);
        }
               
          IF(updatedacllist.size()>0)
              update updatedacllist;
              
        
    }
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'samap01@ca.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Schedule Job- Slipped Deal ' + a.Status);
        mail.setPlainTextBody
            ('The Slipped deal Batch job processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.' +  failedDML);
        If(a.NumberOfErrors>0)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
    }
}