trigger Opportunity_ContactRole on Opportunity (before update)
{    
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration || Opportunity_ContactRole_Class.userIsBypass)
            return;
    if(Trigger.isInsert)
    {
        for(Opportunity o : Trigger.new)
            Opportunity_ContactRole_Class.insertedOpps.add(o.Id);
            
        System.debug('+1 ' + Opportunity_ContactRole_Class.insertedOpps);
    }
    else
    {
        Integer fyMonth = Opportunity_ContactRole_Class.fymonth;
        Integer fyYear = System.today().year();

        
        Set<Id> updatedOpps = new Set<Id>();
        for(Opportunity o : Trigger.new)
        {
            if(o.createddate==o.lastmodifieddate)return;
            Integer closemonth = o.closedate.month();
            Integer closeyear = o.closedate.year();
            if ((o.Probability >= 20  && o.Probability!= 100) || (o.Probability == 100 && ((closemonth >= fymonth && closeyear == fyyear) || (closemonth < fymonth && closeyear == fyyear + 1)))  && !Opportunity_ContactRole_Class.insertedOpps.contains(o.Id))
                updatedOpps.add(o.Id);
        }        
        System.debug('upadted opps valid: '+updatedOpps);
        
        if(!updatedOpps.isEmpty())
        {
            Set<Id> oppsWithPrimaryContact = new Set<Id>();
            for(OpportunityContactRole ocr : [SELECT OpportunityId
                                             FROM OpportunityContactRole 
                                             WHERE IsPrimary=true
                                             AND OpportunityId In :updatedOpps])
            {
                oppsWithPrimaryContact.add(ocr.OpportunityId);
                System.debug('Ocr Opp Id: '+ocr.OpportunityId);
            }
            
            for(Opportunity o : Trigger.new)
            {
                Integer closemonth = o.closedate.month();
                Integer closeyear = o.closedate.year();
                System.debug('oppsWithPrimaryContact : '+oppsWithPrimaryContact);
                if ((o.Probability >= 20  && o.Probability!= 100) || (o.Probability == 100 && ((closemonth >= fymonth && closeyear == fyyear) || (closemonth < fymonth && closeyear == fyyear + 1)))  && !Opportunity_ContactRole_Class.insertedOpps.contains(o.Id))
                {                    
                    if(!oppsWithPrimaryContact.contains(o.Id))
                    {
                        System.debug('Opp checking with '+o.Id);
                        o.addError('No Primary Contact Exists. Please go to the Contact Role and select a primary contact');
                    }
                }
            }
            
            System.debug('+2 ' + Opportunity_ContactRole_Class.insertedOpps);
        }
    }
}