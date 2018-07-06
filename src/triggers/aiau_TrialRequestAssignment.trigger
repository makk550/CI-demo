trigger aiau_TrialRequestAssignment on Trial_Request__c (after insert, after update) {
    
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
        return;
    
    for(Trial_Request__c req:Trigger.new){
        if(Trigger.old!=null){


            string strStatus = req.Request_Status__c;
            string strOldStatus = Trigger.old[0].Request_Status__c;
            //Assignment logic
            if(strOldStatus!=strStatus && strStatus=='Accepted'){
                Trial_Request__c updateReq = [select OwnerId from Trial_Request__c where id=:req.Id];
                updateReq.OwnerId = Userinfo.getUserId();
                update updateReq;
            }else if(strOldStatus=='Accepted' && strStatus=='Approved'){ //Auto creation of a quote request
               
               //Start - code by saba
               Opportunity opp =[SELECT Id, Amount, CurrencyIsoCode, CloseDate,RecordType.Name,Ent_Comm_Account__r.Id,
                                 Ent_Comm_Account__r.Sales_Area__c, Ent_Comm_Account__r.Sales_Region__c,
                                 Ent_Comm_Account__r.Region_Country__c, Owner.Name, Account.Region_Country__c FROM Opportunity WHERE Id =: req.Opp_Name__c limit 1];
               //End- code by saba
               
                Quote_Request__c quoteReq = new Quote_Request__c();
                quoteReq.Opportunity_Amount__c = req.Opp_Amount__c;
                quoteReq.Opportunity_Close_Date__c = req.Opp_Close_Date__c;
                if(req.Opp_Closed__c!=null && req.Opp_Closed__c.toLowerCase()=='yes')
                    quoteReq.Opportunity_Closed__c = true;
                else
                    quoteReq.Opportunity_Closed__c = false;
            
                quoteReq.Opportunity_Name__c = req.Opp_Name__c;
                quoteReq.Opportunity_Number__c = req.Opp_Number__c;
                quoteReq.Type__c = req.Opportunity_Type__c;
                quoteReq.Sales_Milestone__c = req.Milestone__c;
                quoteReq.Territory__c = req.Acc_Territory__c;
                quoteReq.Region__c = req.Acc_Region__c;
                // quoteReq.Account_Name__c = req.Account_Name__c; //Commented by saba to simulate the functionality in s-control - New Quote Request (Attach)
                quoteReq.Account_Area__c = req.Acc_Area__c;
                quoteReq.Request_Type__c = 'Trial Quote';  
                quoteReq.Trial_Request__c = req.Id;  
                //Start - Code by saba to pull the missing Quote Request information
                     quoteReq.Opportunity_Owner__c = opp.Owner.Name; 
                     //Start - Code by heena to pull the missing Quote Request oppty owner information 
                      quoteReq.Oppty_Owner__c=  opp.Ownerid; 
                      //End - Code by heena to pull the missing Quote Request oppty owner information       
                     quoteReq.Area02__c = opp.Account.Region_Country__c; 
                     if(opp.RecordType.Name != 'IND-Value'){ 
                            quoteReq.Account_Name__c = opp.AccountId; 
                      }
                     else
                      { 
                            quoteReq.Account_Name__c = opp.Ent_Comm_Account__r.Id;          
                            quoteReq.Account_Area__c = opp.Ent_Comm_Account__r.Sales_Area__c;       
                            quoteReq.Territory__c = opp.Ent_Comm_Account__r.Sales_Region__c;            
                            quoteReq.Area02__c = opp.Ent_Comm_Account__r.Region_Country__c; 
                      } 
                     quoteReq.CurrencyIsoCode = opp.CurrencyIsoCode;
                //End - Code by saba to pull the missing Quote Request information
                
                insert quoteReq;
            }
        }       

        //Update opportunity record type field
        /*if(req.Opp_Name__c!=null){
            string strRecType = [select RecordType.Name from Opportunity where id=:req.Opp_Name__c].RecordType.Name;
            Trial_Request__c updateReq = [select Record_Type__c from Trial_Request__c where id=:req.Id];
            updateReq.Record_Type__c = strRecType;
            update updateReq;
        }*/         
    }
}