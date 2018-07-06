trigger valiateUniqueness on POC_Escalation_Matrix__c (before insert) {
  
      Set<string> countRecord = new Set<string>();

      for(POC_Escalation_Matrix__c req:Trigger.new){
           req.Name = req.Region__c+'_'+req.Area1__c+'_'+req.Business_Unit__c;
           countRecord.add(req.Name);
      }
     
     /*List<POC_Escalation_Matrix__c> lstEscMatrix = [select POC_Escalation_Manager__c,POC_Approver_Email__c from POC_Escalation_Matrix__c where name = :countRecord];     
      
      for(POC_Escalation_Matrix__c req:Trigger.new){
           req.Name = req.Region__c+'_'+req.Area__c+'_'+req.Business_Unit__c;
           countRecord.add(req.Name);
      }*/
}