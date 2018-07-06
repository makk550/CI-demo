trigger PRM_AddRemoveProductAlignment on Route_To_Market__c (after insert,after update, before delete, after undelete) 
{

    if((trigger.isInsert || trigger.isUndelete) && Trigger.IsAfter)
    {
        //Populate Agreement end date on Quote Expires on field
        if(Trigger.Isinsert){
            List<Route_To_Market__c> RouteMKtAgreemtDates=new List<Route_To_Market__c>();
            for(Route_To_Market__c rmt:Trigger.New){
                if(rmt.Agreement_End_Date__c != null){
                    RouteMKtAgreemtDates.add(rmt);
                }
            }
            
            if(RouteMKtAgreemtDates != null && RouteMKtAgreemtDates.size()>0){
                PopulateExpireDt_Quote Exp_Quote=new PopulateExpireDt_Quote();
             	Exp_Quote.PopulateExpDate_Insert(RouteMKtAgreemtDates);
            }
        }
        
        try{
            set<string> routes = new set<string>();
            for(Route_To_Market__c rtm:Trigger.New)
            {
                routes.add(rtm.RTM__c); 
            }
            List<Product_Alignment__c> lstPA = new List<Product_Alignment__c>(); 
            CA_TAQ_Account_Approval_Class cls = new CA_TAQ_Account_Approval_Class();
            Map<string, Set<String>> mapPA = cls.getProductAlignment(routes);
            if(mapPA <> null)
                for(Route_To_Market__c rtm:Trigger.New)
                {
                     Set<String> setPA = mapPA.get(rtm.RTM__c);
                     system.debug('setPA=' + setPA);
                     if(setPA <> null)
                         for(string s:setPA)
                         {
                            string prodgroup = s.split(':', 2)[0];
                            string bu = s.split(':', 2)[1];
                            Product_Alignment__c pa = new Product_Alignment__c(Route_To_Market__c=rtm.id, Related_Account__c=rtm.Account__c,
                                                Authorized_Agreement__c=true,Product_Group__c=prodgroup,Business_Unit__c= bu, Partner_Approved__c=true );   
                            lstPA.add(pa);
                         }
                }
            
            if(lstPA.size() > 0)
                database.insert(lstpa,false);
        }
        catch(exception ex)
        {
            system.debug('Error:'+ ex);
        }    
    	
    
    }
    else if(Trigger.isDelete && Trigger.IsBefore)
    {
        try
       {
            List<Product_Alignment__c> lstPA = [Select id from Product_Alignment__c where Route_To_Market__c in : Trigger.Old ];
            if(lstPA <> null && lstPA.size() > 0)
                database.delete(lstPA);
        }
        catch(exception ex)
        {
            system.debug('Error:'+ ex);
        }    
    } 
    
      
    if(Trigger.isAfter && Trigger.IsUpdate){
        if(Trigger.new != null && Trigger.oldMap != null && Trigger.new.size()>0 && Trigger.oldMap.size()>0 ){
            // After update populate the agreement end data on qoutes
       		 PopulateExpireDt_Quote Exp_Quote=new PopulateExpireDt_Quote();
             Exp_Quote.PopulateExpDate_Update(Trigger.new,Trigger.oldMap);
        }
    }
}