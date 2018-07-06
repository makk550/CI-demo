trigger DedupeLRMTrigger on LeadRoutingMatrix__c (before insert) {

List<LeadRoutingMatrix__c> HistoricalLRMlist=New List<LeadRoutingMatrix__c>();
List<LeadRoutingMatrix__c> currentLRMlist=New List<LeadRoutingMatrix__c>();
    //Data Map for LRM
   
    
if(Trigger.isBefore && Trigger.isInsert){
for(LeadRoutingMatrix__c lrm:Trigger.New){
system.debug('in loop'+lrm.Recordtype.Name+''+lrm.recordtypeid);
if(lrm.Recordtypeid==system.label.Ldm_lrmrecordtypeid){
currentLRMlist.add(lrm);
      
         }
      
    }
        
        
        HistoricalLRMlist=PartnerLeadDistribution_DynamicSOQL.getLRMList();
            system.debug('HistoricalLRMlist---'+HistoricalLRMlist.size());
            system.debug('currentLRMlist--'+currentLRMlist);
         for(LeadRoutingMatrix__c lrmh:HistoricalLRMlist){
             if(lrmh.Recordtype.Name=='Threshold'){
                 
                 for(LeadRoutingMatrix__c lrmc:currentLRMlist){
                     if(lrmh.Operating_Area__c==lrmc.Operating_Area__c && lrmh.Sales_Region__c==lrmc.Sales_Region__c && lrmh.Business_Unit__c==lrmc.Business_Unit__c && lrmh.Country_Picklist__c==lrmc.Country_Picklist__c && lrmh.GEO__c==lrmc.GEO__c ){
                         system.debug('--'+lrmh.Id);
                         lrmc.addError(system.label.Ldm_lrmError);
                     }
                     
                     
                 
             }
         
             
         }
        
            
    }
     
    }
     
    
  
}