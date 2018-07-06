trigger ai_OpportunityOwnerAssignemnt on Trial_Request__c (after insert){
 
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
        return;
    
    for(Trial_Request__c req:Trigger.new){
 
     try{
     if( req.Opp_Name__c != null )
         {
                
             Opportunity opp =[SELECT Id, Owner.Name  FROM Opportunity WHERE Id =: req.Opp_Name__c limit 1];
              Trial_Request__c tr = new Trial_Request__c(id= req.Id);
                 tr.Opportunity_Ownr__c = opp.Owner.Name;
                 update tr;
      
      
         }
         }
         catch(Exception ex)
         {}
 }
}