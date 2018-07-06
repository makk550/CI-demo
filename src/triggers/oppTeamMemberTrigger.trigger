trigger oppTeamMemberTrigger on OpportunityTeamMember (before delete,Before insert) {
    
    if (SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
        return;
    
        
        
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            for(OpportunityTeamMember otm : Trigger.old){
                if(otm.TeamMemberRole.containsignorecase('PreSales') && PreSalesEditController.canDeletePresales==false){ 
                    otm.adderror('Presales roles must be managed via the Presales request form.');
                }
            }
        }
    }

}