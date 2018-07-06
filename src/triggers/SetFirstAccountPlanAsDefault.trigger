trigger SetFirstAccountPlanAsDefault on Account_Plan__c (before insert) {
	//prepare parent account id list
    Set<Id> parentAccountList=new Set<Id>();
    for(Account_Plan__c ap:Trigger.new )
    {
        if(ap.Account__c!=null) 
        {
            parentAccountList.add(ap.Account__c);         
        }
    }
    //prepare a bucket for accounts with defaults
    set<Id> accountsWithDefaultPlanList=new set<Id>();    
     
    if(parentAccountList.size()>0)
    {
    	//get existing account plans from the system    	
    	List<Account_Plan__c> existingAccountPlans=[select Id,Account__c,Default_Plan__c from Account_Plan__c 
    	where Account__c in:parentAccountList];
    	Map<Id,List<Account_Plan__c>> accountPlanMap=new Map<Id,List<Account_Plan__c>>();
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
    	
    	//set the first account plans as default
    	for(Account_Plan__c ap:Trigger.new )
	    {
	        if(ap.Account__c!=null) 
	        {
	        	if(accountPlanMap.get(ap.Account__c)==null && accountsWithDefaultPlanList.contains(ap.Account__c)==false)
	        	{
	            	ap.Default_Plan__c=true;
	            	accountsWithDefaultPlanList.add(ap.Account__c);
	        	}       
	        }
	    }
    }
}