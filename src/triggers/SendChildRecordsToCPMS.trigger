trigger SendChildRecordsToCPMS on Account (after update) {
    if(SystemIdUtility.skipAccount == true)
        return;
    set<ID> newAccountIdList=new set<ID>();
    for(Account acc:Trigger.new)
    {
        Account oldAccount=Trigger.oldMap.get(acc.Id);
        if(acc.CPMS_ID__c!=null && acc.CPMS_ID__c!=oldAccount.CPMS_ID__c)
        {
            newAccountIdList.add(acc.Id);
        }
    }
    
    if(newAccountIdList.size()>0)
    {
        //update child opps
        List<Opportunity> childOpps=[Select Id from Opportunity where AccountId in:newAccountIdList Limit 500];
        if(childOpps.size()>0)
        {
            Database.update(childOpps,false);
        } 
        //update associated sites
        List<Associated_Site__c> childSites=[Select Id from Associated_Site__c where Account__c in:newAccountIdList Limit 500];
        if(childSites.size()>0)
        {
            Database.update(childSites,false);
        }
        //update child leads
        List<Lead> childLeads=[Select Id from Lead where Isconverted=false and Reseller__c in:newAccountIdList Limit 500];
        if(childLeads.size()>0)
        {
            Database.update(childLeads,false);
        }       
    }
}