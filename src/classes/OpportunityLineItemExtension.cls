public class OpportunityLineItemExtension {
    public Opportunity opp{get;set;}
    public OpportunityLineItem oppLineItm{get;set;}
    
    public OpportunityLineItemExtension(ApexPages.StandardController contrl){
        oppLineItm = [SELECT Id,Business_Type__c,OpportunityId FROM OpportunityLineItem WHERE Id =:contrl.getId()];
        
        opp = [SELECT Id,RecordTypeId,Deal_Registration_Status__c,RecordType.Name FROM Opportunity WHERE Id =:oppLineItm.OpportunityId];
        
    }
}