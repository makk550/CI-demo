trigger AccountOwnerTransfer on Account (after update) {
        for(Account a : trigger.new)
     {
         if(a.Count_of_Sites__c==9950 && a.Count_of_Sites__c!=Trigger.oldmap.get(a.id).Count_of_Sites__c && a.name.contains('Generic Support Account'))
         {
                            String str=a.name;
                            integer i=Integer.ValueOf(str.substring(23,24));
                            integer j=i+1;
                            Account acc = new Account(Name='Generic Support Account'+j ,RecordTypeId='012f00000000QQY');
                            acc.BillingStreet='Street';
                            acc.BillingCountry='US';
                            acc.BillingCity='Islandia'; 
                            insert acc;
          }                  
                                 
     }     
     if(SystemIdUtility.isneeded)
        return;
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    AccountOwnerTransferSynchronizer sync = new AccountOwnerTransferSynchronizer();
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Account Team Covered Account');
    Id recEnterpriseId = rec.RecordType_Id__c; // record type id for enterprise accounts   
    try {    
        
        //find the number of accounts whose owners have changed
        Integer  accountsWithOwnerChange=0;
        for (Account a : trigger.new) 
        {
            Account oldAccount = trigger.oldMap.get(a.Id);
            if (oldAccount.OwnerId != a.OwnerId && a.recordtypeid == recEnterpriseId) {
                accountsWithOwnerChange++;
            }
        }
        if(accountsWithOwnerChange>0)
        {
            map<Id, Account> accountMap = new map<Id, Account>([select id, lastmodifiedby.title from account where id in : trigger.newMap.keySet()]);                     
            for (Account a : trigger.new) {   
                string userTitle = accountMap.get(a.Id).LastModifiedBy.Title;  
                if(userTitle == AccountOwnerTransferSynchronizer.INTEGRATION_ACCOUNT_TITLE) {           
                    Account oldAccount = trigger.oldMap.get(a.Id);                  
                    if (oldAccount.OwnerId != a.OwnerId) {
                        sync.addRequest(a, oldAccount.OwnerId, a.OwnerId);
                    }
                }
            }        
            // Execute
            if (sync.hasRequests) sync.executeTransferRequests();
        }
    }
    catch (Exception ex) {
        System.debug(ex.getMessage());        
        sync.logError(ex);
    }
    finally {
        sync.commitErrorLog(); 
    }

}