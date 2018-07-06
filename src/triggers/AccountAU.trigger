trigger AccountAU on Account (after update) {
     if(SystemIdUtility.skipAccount == true)
        return;
        
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    Set<Id> accountIds = new Set<Id>();     
    for (Account a : Trigger.new){ 
//        System.debug('Old Owner:' + Trigger.oldMap.get(a.Id).OwnerId);
//        System.debug('New Owner:' + a.OwnerId);
        if(a.Account_Owner_Name__c=='NA' || Trigger.oldMap.get(a.Id).OwnerId!=a.OwnerId){
            accountIds.add(a.Id);
        } 
    }  

//    System.debug('Total Acc Ids:' + accountIds.size());
    if(accountIds.size()>0)
    {
        List<Account> updatedAccounts = new List<Account>();
    
        for(Account a:[select Account_Owner_Name__c, Owner.Name from Account where id in :accountIds]){
            a.Account_Owner_Name__c = a.Owner.Name;
            updatedAccounts.add(a);
       }
        update updatedAccounts;
    }
}