trigger accountDeleteToMDM  on Account (after delete) {
    
    if(Label.isAccountDeleteToMDMTriggerActive=='FALSE')		//label used to activate/inactivate trigger
        return;
    
    try
    {
        if(Trigger.isDelete)
        {
            List<Account> delAcc= new List<Account>();
            for(Account acc: Trigger.old)
            {  
                delAcc.add(acc);
                System.debug('account='+acc.id);
                System.debug('account='+acc.name);         
                
            }
            if(delAcc.size()>0)
            {
                account_Delete_ToMDM_class obj = new account_Delete_ToMDM_class();
                obj.pushAccountDeleteChangesToMDM(delAcc);
            }
        }
    }
    Catch(Exception e)
    {
        System.debug('Exception in accountDeleteToMDM: '+ e );
    }     
    
}