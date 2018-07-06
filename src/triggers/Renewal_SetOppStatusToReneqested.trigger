//Set Opportunity Status to requested on every attach/detach of ca product renewals
trigger Renewal_SetOppStatusToReneqested on CA_Product_Renewal__c (before insert, before delete) 
{
      Set<id> oppIds  = new Set<id>();
      if(Trigger.isDelete)
          for(CA_Product_Renewal__c lineItem_ACP :Trigger.old)    
                {
                 oppIds.add(lineItem_ACP.Renewal_Opportunity__c);
                }
    
      if(Trigger.isInsert)
          for(CA_Product_Renewal__c lineItem_ACP :Trigger.new)    
                {
                 oppIds.add(lineItem_ACP.Renewal_Opportunity__c);
                }
                
                
      List<Opportunity> lst = new List<Opportunity>();
      for(id vid:oppIds)
      {
          lst.add(new Opportunity(id=vId,rpd_status__c = 'Requested'));
      }
      
      update lst;          

}