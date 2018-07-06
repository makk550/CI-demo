global class Batch_OppSlippedDealUpdate implements Database.Batchable<sObject>,Database.Stateful   
{
    String query ;
    String failedDML = '';
    Date currentdate = System.today();
    global Batch_OppSlippedDealUpdate()
    {
        
    }
    /* Batch class constructor */
    //Start method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        query='SELECT id, CA_Renewal_Product_Count__c,Slipped_Deal__c from Opportunity WHERE CA_Renewal_Product_Count__c > 0  AND HasOpportunityLineItem =true '+
            ' and Opportunity_Type__c LIKE  \'%Renewal%\' and IsClosed =false ';
        
        
        System.debug('samap01 +string query' + query);
        return Database.getQueryLocator(query);
    }
    
    //Excute method
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
        //Excution logic
        //List<Opportunity> opp= new List<Opportunities>();
        Set<id> Oppidlist = new Set<id>();
        map<id,integer> opplinemap = new map<id,integer>();
        for(Opportunity o:scope){
            oppidlist.add(o.id);
        }
        System.debug('samap01 +oppidlist' + oppidlist.size());
        if(oppidlist.size() >0)
        {
            AggregateResult[] aggresults = [SELECT SUM(Dismantle_Date_Slipped__c) dismantleddatecount, OpportunityId
                                            FROM OpportunityLineItem  where OpportunityId IN: oppidlist
                                            group by  OpportunityId ];				  		
            
            if(aggresults.size()>0)
            {
                System.debug('samap01 +aggresults.size()' + aggresults.size());
                for(AggregateResult ag : aggresults)
                {
                    opplinemap.put((ID)ag.get('OpportunityId'), Integer.valueof(ag.get('dismantleddatecount')));
                    System.debug('samap01 +opplinemap' + opplinemap);
                }
            }
            List<Opportunity> opplist = new list<Opportunity>();
            for(Opportunity opp:scope){
                integer dismantleddatecount = opplinemap.get(opp.id);
                System.debug(' samap01 dismantleddatecount --' +dismantleddatecount);
                System.debug('samap01 CA_Renewal_Product_Count__c --' + opp.CA_Renewal_Product_Count__c);
                opp.Slipped_Deal__c= 'No';
                if(  dismantleddatecount == 0 )    
                    opp.Slipped_Deal__c= 'No';
                else
                    if(  opp.CA_Renewal_Product_Count__c.intValue() > dismantleddatecount  &&  dismantleddatecount > 0 )        	
                    opp.Slipped_Deal__c= 'Partial';
                else
                    if(  opp.CA_Renewal_Product_Count__c.intValue() == dismantleddatecount )    
                    opp.Slipped_Deal__c= 'Yes';
                
                opplist.add(opp);
                System.debug('samap01 - opp.id'+ opp.id  + '--- opp slipped deal' + opp.Slipped_Deal__c);
            }
            
            if(opplist.size() > 0)
            {
                
                // database.update(opplist);
                update scope;
                System.debug('samap01 - update opportunities');
                
                List<Database.SaveResult> updateResults = Database.update(opplist);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        
                    }else if (!updateResults.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                         failedDML =  'Failed ID'+opplist.get(i).Id ;
                        opplist.get(i);//failed record from the list
                        system.debug('Failed ID'+opplist.get(i).Id);
                    }
                    
                }
            }
        }
        
        
    }
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'samap01@ca.com;Team-GIS-Cavalry@ca.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Schedule Job- Slipped Deal ' + a.Status);
        mail.setPlainTextBody
            ('The Slipped deal Batch job processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.' +  failedDML);
        If(a.NumberOfErrors>0)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
    }
}