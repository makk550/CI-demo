global class AccountPlanUtility {
    webservice static string  setAccountPlanAsDefault(string accPlanId)
    {
        Id currentUserId=UserInfo.getUserId();
        System.debug('Current User Id: '+currentUserId);
        String callStatus='Account Plan Set as Default';
        List<Account_Plan__c> accPlan=[Select Id,Account__c,Default_Plan__c 
        from Account_Plan__c where Id=:accPlanId];
        if(accPlan.size()>0) 
        {
            if(accPlan[0].Default_Plan__c==false)
            {           
                if(accPlan[0].Account__c==null)  
                {
                    callStatus='Account Plan is not Associated to an Account!';
                }
                else
                {
                    //get parent account
                    Account acc=[Select Id,OwnerId from Account Where Id=:accPlan[0].Account__c]; 
                    if(currentUserId!=acc.OwnerId)
                    {
                        callStatus='Only The Parent Account owner can set an Account Plan as Default!';
                    }
                    else
                    {
                        //get other account plans associated to the account
                        List<Account_Plan__c> accPlans=[Select Id,Default_Plan__c from Account_Plan__c where 
                        Default_Plan__c=true and Account__c=:accPlan[0].Account__c and Id!=:accPlan[0].Id];
                        if(accPlans.size()>0)
                        {
                            for(Account_Plan__c ap:accPlans)
                            {
                                ap.Default_Plan__c=false;
                            }
                            update accPlans;
                        }
                        accPlan[0].Default_Plan__c=true;
                        update accPlan[0];
                    }
                }
            }
        }
        else
        {
            callStatus='No account Plan Found!';
        }
        System.debug('Call status: '+callStatus);
        return callStatus;          
    }
    static testMethod void testSetAccountPlanAsDefault()
    {
        String uid = UserInfo.getUserId();
        
        User[] users = [select id from user where isactive = true and id != :uid limit 2];
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingState = 'NY';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        // create a test account plans
        Account_Plan__c ap1 = new Account_Plan__c();
        ap1.Name = 'Acc Plan1';
        ap1.Account__c = acc1.Id; 
        ap1.Plan_Status__c = 'Draft';
        insert  ap1;
        
        //create an account plan with out an account       
        Account_Plan__c ap2 = new Account_Plan__c();
        ap2.Name = 'Acc Plan2';
        ap2.Plan_Status__c = 'Draft';              
        insert ap2; 
        
        Account_Plan__c ap3 = new Account_Plan__c();
        ap3.Name = 'Acc Plan3';
        ap3.Account__c = acc1.Id; 
        ap3.Plan_Status__c = 'Draft';
        insert  ap3;
         
        string response1=setAccountPlanAsDefault(ap1.Id);
        System.assert(response1.equalsIgnoreCase('Account Plan Set as Default'));
        
        string response2=setAccountPlanAsDefault(ap2.Id);
        System.assert(response2.equalsIgnoreCase('Account Plan is not Associated to an Account!')); 
         
        //test deleteing a default account plan
        try
        {
            Database.delete(ap1); 
        }
        catch(Exception ex){}  
        
        //update account plan 2 with account    
        ap2.Account__c = acc1.Id; 
        update ap2;      
        string response3=setAccountPlanAsDefault(ap2.Id);
        System.assert(response1.equalsIgnoreCase('Account Plan Set as Default'));
        
        //try to make an account plan default as a user different than the acount owner
        System.runAs(users[0])
        {
            //string response4=setAccountPlanAsDefault(ap3.Id);         
        }
    } 
}