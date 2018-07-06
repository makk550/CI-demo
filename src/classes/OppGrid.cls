global class OppGrid
{
    public static void updateOpportunityGridList(List<Account_Plan__c> apList, Map<Id,Account> parentAccountMap,
    Map<Id,List<Account_Plan__c>> accountPlanMap,Map<Id,List<Opportunity_Grid__c>> oppGridMap)
    {       
        List<Opportunity_Grid__c> deletedOpportunityGrids=new List<Opportunity_Grid__c>();
        List<Opportunity_Grid__c> newOppGridItems=new List<Opportunity_Grid__c>();
        set<Id> accountsWithOppGrid=new set<Id>();
                    
        //get list of active ncv drivers
        NCV_Driver_Info__c[] activeNcvDrivers=[Select Id from NCV_Driver_Info__c where Is_Active__c=true]; 
        System.debug('Existing NCV Drivers: '+activeNcvDrivers.size());   
        
        //create opportunity grid items for missing NCV Drivers
        for(Account_Plan__c ap:apList)
        {
            //get existing opportunity grids for the account plan
            List<Opportunity_Grid__c> currentOppGrids=new List<Opportunity_Grid__c>();
            if(oppGridMap.get(ap.Id)!=null)
            {
                currentOppGrids=oppGridMap.get(ap.Id); 
            }
            //update opportunity grid list with existing account plans opportunity grid info
            if(accountPlanMap.get(ap.Account__c)!=null)
            {
                for(Account_Plan__c accountPlan:accountPlanMap.get(ap.Account__c))
                {
                    if(accountPlan.Id!=ap.Id)
                    {
                        if(oppGridMap.get(accountPlan.Id)!=null)
                        {
                            List<Opportunity_Grid__c> OldOppGrids=oppGridMap.get(accountPlan.Id);
                            for(Opportunity_Grid__c oldGrid:OldOppGrids)
                            {
                                boolean matchFound=false;
                                for(Opportunity_Grid__c existingGrid:currentOppGrids)
                                {
                                    if(oldGrid.NCV_Driver_Info__c==existingGrid.NCV_Driver_Info__c)
                                    {
                                        matchFound=true;
                                        break;
                                    }
                                }
                                if(matchFound==false)
                                {
                                    Opportunity_Grid__c newOg=new Opportunity_Grid__c();
                                    newOg.Acct_Plan__c=ap.Id;
                                    newOg.NCV_Driver_Info__c=oldGrid.NCV_Driver_Info__c;    
                                    newOg.CA_License__c=oldGrid.CA_License__c;
                                    newOg.Competitor__c=oldGrid.Competitor__c;
                                    newOg.Competitor_Name__c=oldGrid.Competitor_Name__c;
                                    newOg.Don_t_Know__c=oldGrid.Don_t_Know__c;
                                    newOg.Pipeline__c=oldGrid.Pipeline__c;                              
                                    currentOppGrids.add(newOg);
                                }
                                //delete the old grid
                                addOpportunityGridToDeletedList(oldGrid,deletedOpportunityGrids);
                            }
                        }
                    }
                }
            }
            
            //update opportunity grid list with active ncv drivers          
            for(NCV_Driver_Info__c ncvDriver:activeNcvDrivers)
            {
                boolean matchFound=false;
                for(Opportunity_Grid__c og:currentOppGrids)
                {
                    if(og.Acct_Plan__c==ap.Id && og.NCV_Driver_Info__c==ncvDriver.Id)
                    {
                        matchFound=true;
                    }
                }
                if(matchFound==false)
                {
                    Opportunity_Grid__c newOg=new Opportunity_Grid__c();
                    newOg.Acct_Plan__c=ap.Id;
                    newOg.NCV_Driver_Info__c=ncvDriver.Id;
                    newOg.Responded__c=true;
                    currentOppGrids.add(newOg);
                }               
            }
            
            //add new opp grid items to the new list
            for(Opportunity_Grid__c og:currentOppGrids)
            {
                if(og.Id==null)
                {
                    newOppGridItems.add(og);
                }
            }
            
        }
        //create or update 
        if(newOppGridItems.size()>0)
        {
            insert newOppGridItems;
        }   
        if(deletedOpportunityGrids.size()>0)
        {
            delete deletedOpportunityGrids;
        }       
    }    
    private static void addOpportunityGridToDeletedList(Opportunity_Grid__c og,List<Opportunity_Grid__c> deletedOpportunityGrids)
    {
        
        boolean isInList=false;
        for(Opportunity_Grid__c oppGrid:deletedOpportunityGrids)
        {
            if(oppGrid.Id==og.Id)
            {
                isInList=true;
                break;
            }
        }
        if(isInList==false)
        {
            deletedOpportunityGrids.add(og);
        }
        
    }
    static testMethod void testUpdateOpportunityGridList()
    {
        
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        // create a test account plan with Create opportunity flagged
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        insert ap;      
        
        Opportunity_Grid__c newOg=new Opportunity_Grid__c();
        newOg.Acct_Plan__c=ap.Id;
        newOg.Responded__c=true;  
        insert newOg;
        System.assert([Select count() from Opportunity_Grid__c where Acct_Plan__c=:ap.Id]>0);        
    }
}