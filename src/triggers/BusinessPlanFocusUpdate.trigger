trigger BusinessPlanFocusUpdate on Business_Plan_New__c (after update) 
{
    for(Business_Plan_New__c bp : Trigger.new)
    {
        if(Trigger.oldmap.get(bp.Id).Status__c != 'Approved' && bp.Status__c == 'Approved')
        {
            Account myAccount = [Select Id,Alliance__c,Service_Provider__c,Solution_Provider__c,Velocity_Seller__c from Account where Id=:bp.Account__c][0];
            List<BP_Focus_Update_Errors__c> errorEntries = new List<BP_Focus_Update_Errors__c>();
            List<BP_Solutions__c> myBPSols = [Select Product_Group__c, RTM__c, Sales_Coverage_Business_Unit__c 
                                                 from BP_Solutions__c where Business_Plan__c=:bp.Id]; 
           
            List<Product_Alignment__c> allProdAligns = [Select Id, Business_Plan__c from Product_Alignment__c where
                                            Related_Account__c=:myAccount.Id];
            for(Product_Alignment__c prodA : allProdAligns)
            {
                prodA.Business_Plan__c = false;
            }                                  
            update allProdAligns;
                             
            List<Product_Alignment__c> prodAligns = new List<Product_Alignment__c>();        
            for(BP_Solutions__c bpSol : myBPSols)
            {
                boolean eligibleForUpdate = true;
                if(bpSol.RTM__c == 'Alliance' && myAccount.Alliance__c)
                {
                }
                else if(bpSol.RTM__c == 'Solution Provider' && myAccount.Solution_Provider__c)
                {
                }
                else if(bpSol.RTM__c == 'Service Provider' && myAccount.Service_Provider__c)
                {
                }
                else if(bpSol.RTM__c == 'Data Management' && myAccount.Velocity_Seller__c)
                {
                }
                else
                {
                    eligibleForUpdate = false;  
                }     
                                           
                if(eligibleForUpdate)
                {
                    try{
                    System.debug('Account ID :: ' + myAccount.Id);
                    System.debug('RTM__c :: ' + bpSol.RTM__c);
                    System.debug('PG :: ' + bpSol.Product_Group__c);
                    System.debug('BU :: ' + bpSol.Sales_Coverage_Business_Unit__c);
                    Product_Alignment__c prodAlign = [Select Id, Business_Plan__c from Product_Alignment__c where
                                                        Related_Account__c=:myAccount.Id AND RTM__c=:bpSol.RTM__c AND
                                                        Product_Group__c=:bpSol.Product_Group__c AND Business_Unit__c=:bpSol.Sales_Coverage_Business_Unit__c][0];
                    prodAlign.Business_Plan__c = true;
                    prodAligns.add(prodAlign); 
                    }                                                       
                    catch(Exception e)
                    {
                      System.debug('Exception e :: ' + e);
                      BP_Focus_Update_Errors__c entry = new BP_Focus_Update_Errors__c(Name=bpSol.Product_Group__c,Account__c=myAccount.Id, Business_Plan__c=bp.Id, Product_Group__c=bpSol.Product_Group__c,RTM__c=bpSol.RTM__c,Sales_Coverage_Business_Unit__c=bpSol.Sales_Coverage_Business_Unit__c,Error_Date__c=System.now());
                      errorEntries.add(entry);                      
                    }
                }
                
                if(!eligibleForUpdate)
                {
                      BP_Focus_Update_Errors__c entry = new BP_Focus_Update_Errors__c(Name=bpSol.Product_Group__c,Account__c=myAccount.Id, Business_Plan__c=bp.Id, Product_Group__c=bpSol.Product_Group__c,RTM__c=bpSol.RTM__c,Sales_Coverage_Business_Unit__c=bpSol.Sales_Coverage_Business_Unit__c,Error_Date__c=System.now());
                      errorEntries.add(entry);   
                }
            }
            update prodAligns;  
            insert errorEntries;                                    
        }
    }        
}