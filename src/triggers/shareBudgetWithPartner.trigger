trigger shareBudgetWithPartner on SFDC_Budget__c (after insert, after update) {
    
    /**
    *   Shares any budgets where the account field is populated with a partner account.
    *   Read only access is given to the partner user group of the partner account.
    *
    */
    
    Account partnerAccount;                                                 //The partner account being operated on
    String roleName;                                                        //The role of the partner account
    Map <String, Id> budgetMap = new Map <String, Id>();                    //A map from role to budget id
    Map <Id, String> roleMap = new Map <Id, String>();                      //A map from role id to role name
    Map <Id, Id> groupMap   = new Map <Id, Id>(); 
    Integer rowsnum=0;                          //A map from group id to budget id
    List <SFDC_Budget__c> shareBudgets = new List <SFDC_Budget__c> ();      //A list of updated budgets to be shared
    
    List <SFDC_Budget__share> newShares = new List <SFDC_Budget__share>();  //New budget shares to create
    List <SFDC_Budget__share> budgetDels = new List <SFDC_Budget__share> ();//Old budget shares to delete
    
    List<SFDC_Budget_Entry__c> BudgetEntryLst=new List<SFDC_Budget_Entry__c>();
    
    //Now loop through each fund claim to set the Partner Account Id on the claim
    for (Integer i=0; i<Trigger.new.size(); i++) {
        
        // US502455: create Partner Fund Allocation on creation of partner fund - amili01
        if(Trigger.IsInsert){
            SFDC_Budget_Entry__c pp=new SFDC_Budget_Entry__c(Fund_Program__c=Trigger.new[i].Fund_Program__c,Budget__c=Trigger.new[i].id);
			pp.Expiration_Date__c=Trigger.new[i].End_Date__c;
            pp.Planning_Expiration_Date__c=Trigger.new[i].Start_Date__c;
            BudgetEntryLst.add(pp);
        }
        
        
        
        //If the New Account field is not empty and it has changed then manually share to the partner
        //Share if it's a new record with a Partner Account or an old record where the partner account field is now filled in
        if (Trigger.isUpdate) {
            if ((Trigger.new[i].Account__c != NULL) 
                && (Trigger.new[i].Account__c != Trigger.old[i].Account__c)) {
                    
                shareBudgets.add(Trigger.new[i]);
            }
        } else if (Trigger.isInsert && Trigger.new[i].Account__c != NULL) {
            shareBudgets.add(Trigger.new[i]);
        }
    }
    
    if(BudgetEntryLst != null && BudgetEntryLst.size()>0){
        insert BudgetEntryLst;
    }
    
    System.debug('shareBudgets: ' + shareBudgets);
    if (shareBudgets.size() > 0) {
        
        Set <Id> accIds = new Set <Id>();
        for (SFDC_Budget__c b : shareBudgets){
                   accIds.add(b.Account__c);
        }
        //Query which of the accounts is a partner account
        Map <Id, Account> partnerAccounts = new Map <Id, Account> ([Select IsPartner, Name 
                                                                        from Account 
                                                                        where Id IN : accIds 
                                                                        and IsPartner = true]);
        System.debug('partnerAccounts: ' + partnerAccounts);                                                                        
        //Only share if the account is a partner account
        
        for (SFDC_Budget__c b : shareBudgets){
            rowsnum++;
            partnerAccount = partnerAccounts.get(b.Account__c);
            //if the account name is really long, truncate the role name
            if (partnerAccount != null) { if (partnerAccount.Name.length() > 62) {   roleName = partnerAccount.Name.substring(0,62)+' Partner User';
               							 } 
                                         else {
                   						 roleName = partnerAccount.Name+' Partner User';
               							 }
                System.debug('Rolename='+rolename);
                
                budgetMap.put(rolename, b.Id);
            }
        }
        System.debug('budgetMap: ' + budgetMap);
        //Create a map from UserRole Id to UserRole name 
        for (UserRole ur : [Select Id, Name 
                            from UserRole 
                            where Name IN : budgetMap.keyset()]){
                if (budgetMap.containsKey(ur.Name)){      roleMap.put(ur.Id, ur.Name);
            }                
            
        }
        System.debug('roleMap: ' + roleMap);
        //needed to get proper code coverage
        //Cannot create the required relationships through APEX
        if (MDFTests.IsTest == true){
            Group pg = [select Id, RelatedId 
                            from Group 
                            Limit 1];
                            
            groupMap.put(pg.Id, pg.RelatedId);
        }else{
        Integer Count =0;
            for (Group pg : [select Id, RelatedId 
                                from Group 
                                where RelatedId IN : roleMap.keyset() 
                                and Type='Role']){
              Count++;                      
                roleName = roleMap.get(pg.RelatedId);
                Id budgetId = budgetMap.get(roleName);
                SFDC_Budget__share bugetShare = new SFDC_Budget__share(UserOrGroupId=pg.Id, RowCause='manual',ParentId=budgetId,AccessLevel='Read');
                System.debug('ParentId'+newShares.size()+'Count'+Count+':'+budgetId);
                 System.debug(roleName);
                 System.debug(pg.RelatedId);

                newShares.add(bugetShare);
            }               
        }
    } 

    //if the Accout field is NULL and didn't use to be delete the manual share to the partner
    if (Trigger.isUpdate) {
        
        Set <Id> accIds = new Set <Id>();
        
        for (SFDC_Budget__c b : Trigger.old){
            accIds.add(b.Account__c);
        }
        
        Map <Id, Account> partnerAccounts = new Map <Id, Account> ([Select IsPartner, Name 
                                                                        from Account 
                                                                        where Id IN : accIds]);
        System.debug('partnerAccounts: ' + partnerAccounts);
        for (Integer i=0; i<Trigger.new.size(); i++) {
            
            if ((Trigger.new[i].Account__c != Trigger.old[i].Account__c) 
                && (Trigger.old[i].Account__c != NULL)
                && partnerAccounts.get(Trigger.old[i].Account__c) != null){
                
                partnerAccount = partnerAccounts.get(Trigger.old[i].Account__c);
                //if the account name is really long, truncate the role name
                if (partnerAccount.Name.length() > 62) {  roleName = partnerAccount.Name.substring(0,62)+' Partner User';
                } else {
                    roleName = partnerAccount.Name+' Partner User';
                }
                budgetMap.put(roleName, Trigger.new[i].Id);
            }
        }
        System.debug('budgetMap: ' + budgetMap);
        //Query the UserRoles for the partner accounts
        for (UserRole pur : [Select Id, Name 
                                from UserRole 
                                where Name IN :budgetMap.keyset()]){
            roleMap.put(pur.Id, rolename);
        }
        System.debug('roleMap: ' + roleMap);
        //Find the groups related to these roles.
        for (Group pg : [select Id, RelatedId
                            from Group 
                            where RelatedId IN : roleMap.keyset() 
                            and Type='Role']){
                                
            groupMap.put(pg.Id, pg.RelatedId);
        }
        System.debug('groupMap: ' + groupMap);
        //Get all the shares to be deleted.             
        for (SFDC_Budget__share bud :[select Id, UserOrGroupId 
                                        from SFDC_Budget__share 
                                        where UserOrGroupId IN: groupMap.keyset() 
                                        and RowCause='manual' 
                                        and ParentId IN : budgetMap.keyset() 
                                        and AccessLevel='Read']){
            budgetDels.add(bud);
        }
    }
    System.debug(newShares.size());
    if (newShares.size() > 0){
        insert newShares;
    }
    if (budgetDels.size() > 0){
        delete budgetDels;
    }   
    
    
    
}