trigger CSP_InsertOpportunities on Customer_Success_Program__c (after insert) 
{
   List<CSP_Opportunity__c> lst = new List<CSP_Opportunity__c>();
    
    for(Customer_Success_Program__c csp: trigger.new)
        {
            if(csp.CSP_Related_Opportunity_s__c <> null)
            {
                for(string strid : csp.CSP_Related_Opportunity_s__c.split(';'))
                    {
                        if(strid <> null && strid <> ''  && (strid.length() == 18 || strid.length() == 15))
                            {
                                lst.add(new CSP_Opportunity__c(Customer_Success_Program__c=csp.id, Opportunity__c=strid));
                            }
                    }
                         
            }
        }
        
        if(lst.size() >0)
             database.insert(lst,false); 
 
}