trigger CreateOppGridItemsOnAPChange on Account_Plan__c (before update,  after insert) {	
	set<Id> parentAccountList=new Set<Id>();    	
    List<Account_Plan__c> accountPlansToProcess=new List<Account_Plan__c>();
    Map<Id,Account> parentAccountMap=new Map<Id,Account>();
    Map<Id,List<Account_Plan__c>> accountPlanMap=new Map<Id,List<Account_Plan__c>>();
    Map<Id,List<Opportunity_Grid__c>> oppGridMap=new  Map<Id,List<Opportunity_Grid__c>>();
    
    //loop through acount plans to check if they need processing
    for (Account_Plan__c ap : Trigger.new) 
    {
    	if(ap.Account__c!=null)
    	{ 
    		//consider all new account plans 
        	if(Trigger.isInsert)
        	{
        		if(ap.Default_Plan__c==true) 
        		{
	        		parentAccountList.add(ap.Account__c);
	        		accountPlansToProcess.add(ap);
	        		System.debug('Account added to List: '+ap.Account__c);
        		}
        	}
        	//consider existing records if the default flag is set or the Update Opportunity flag is set
            else 
            {
            	if(ap.Default_Plan__c)
            	{
	               Account_Plan__c oldPlan=Trigger.oldmap.get(ap.Id);
	               //consider record if account plan is updated 
	               if(ap.Default_Plan__c!=oldPlan.Default_Plan__c)
	               {
	               		parentAccountList.add(ap.Account__c);
	               		accountPlansToProcess.add(ap);
	               		System.debug('Account added to List: '+ap.Account__c);
	               }	
	               //consider record if Admin checks the Update Opportunity Grid flag for a default account plan
	               else if(ap.Update_Opportunity_Grid__c==true)
	               {
	               		parentAccountList.add(ap.Account__c);	
	               		accountPlansToProcess.add(ap);
	               		System.debug('Account added to List: '+ap.Account__c);
	               }
            	}               
            }
    	}
    }   
    if(parentAccountList.size()>0)
    {    
    	//get parent accounts from salesforce
    	parentAccountMap=new Map<Id,Account>([select Id,OwnerId from Account where Id in:parentAccountList]);
    	
    	//get other account plans associated to the account
    	List<Account_Plan__c> existingAccountPlans=[select Id,Account__c,Default_Plan__c from Account_Plan__c 
    	where Account__c in:parentAccountList]; 
    	system.debug('existing account plans: '+  existingAccountPlans.size());
    	 	
    	for(Account_Plan__c ap:existingAccountPlans)
    	{
    		if(accountPlanMap.get(ap.Account__c)==null)
    		{
    			accountPlanMap.put(ap.Account__c, new List<Account_Plan__c>{ap});
    		}
    		else
    		{
    			accountPlanMap.get(ap.Account__c).add(ap);
    		}
    	}
    	
    	//get Opportunity Grids Associated to the Account
    	Opportunity_Grid__c[] oppGridList = [select id, Acct_Plan__c,NCV_Driver_Info__c,CA_License__c,Competitor__c,Competitor_Name__c,
    	Don_t_Know__c,Pipeline__c from Opportunity_Grid__c where Acct_Plan__c in :existingAccountPlans  and NCV_Driver_Info__c!=null 
    	order by Acct_Plan__c ];   
    	System.debug('Existing Opportunity Grids: '+  oppGridList.size());
    	   
        for(Opportunity_Grid__c oppGrid: oppGridList)
        {
        	if(oppGridMap.get(oppGrid.Acct_Plan__c)==null)
        	{
        		oppGridMap.put(oppGrid.Acct_Plan__c,new List<Opportunity_Grid__c>{oppGrid});
        	}
        	else
        	{
        		oppGridMap.get(oppGrid.Acct_Plan__c).add(oppGrid);
        	}
        }  
        OppGrid.updateOpportunityGridList(accountPlansToProcess,parentAccountMap,accountPlanMap,oppGridMap);             
    } 
    
    //reset the Update Opportunity Grid flag
    if(!Trigger.isInsert)
    {
        for (Account_Plan__c ap : Trigger.new) 
        {
            ap.Update_Opportunity_Grid__c = false;            
        }
    }    
}