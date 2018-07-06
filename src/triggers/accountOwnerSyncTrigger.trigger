//This trigger updates Account Plan owners whenever Account owners are changed.
trigger accountOwnerSyncTrigger on Account bulk (after update) {
     if(SystemIdUtility.skipAccount == true)
        return;
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    try {    
        List<Account_Plan__c> accountPlans = new List<Account_Plan__c>();
        Set<Id> oldAccountOwnerIdList=new Set<Id>();        
        Set<Id> accountIds = new Set<Id>();     
        for (Account a : Trigger.new)   
        { 
            if(Trigger.oldMap.get(a.Id).OwnerId!=a.OwnerId) 
            {
                accountIds.add(a.Id);
                oldAccountOwnerIdList.add(Trigger.oldMap.get(a.Id).OwnerId);
            } 
        }  
        if(accountIds.size()>0)
        {
            Account_Plan__c[] aps = [select Id, OwnerId, Account__c from Account_Plan__c 
            where Account__c in :accountIds and OwnerId in:oldAccountOwnerIdList];
            for (Account_Plan__c ap : aps) {
                if(ap.OwnerId!=Trigger.newMap.get(ap.Account__c).OwnerId && ap.OwnerId==Trigger.oldMap.get(ap.Account__c).OwnerId) 
                {
                    ap.OwnerId=Trigger.newMap.get(ap.Account__c).OwnerId;
                    accountPlans.add(ap);
                }
            }
            update accountPlans;
            accountPlans.clear();
        }
    }catch(System.DmlException e) 
    {
        for (Integer i =0; i < e.getNumDml(); i++)
        {
            System.debug(e.getDmlMessage(i));
        }
    } 
}