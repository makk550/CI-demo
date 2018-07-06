trigger CA_AgreementCustomTrigger on Apttus__APTS_Agreement__c (before insert, after insert, before update, after update, before delete, after delete) {
if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      //CA_AgreementCustomTriggerHandler.updateTAVApproversonAgreement(Trigger.New);
      CA_AgreementCustomTriggerHandler.updateQuoteDataOnAgreement(null,Trigger.New);  
      //CA_AgreementCustomTriggerHandler.populateLegalEntityOnAgreement(null,Trigger.New);  
      CA_AgreementCustomTriggerHandler.updateAgreementStatusonDDR(Trigger.new);  
      //CA_AgreementCustomTriggerHandler.updateAgreementValueinUSD(Trigger.new);
    } 
    if (Trigger.isUpdate) {
      //CA_AgreementCustomTriggerHandler.updateTAVApproversonAgreement(Trigger.oldMap,Trigger.New);
      CA_AgreementCustomTriggerHandler.updateQuoteDataOnAgreement(Trigger.oldMap,Trigger.New);  
      //CA_AgreementCustomTriggerHandler.removeAgreementApprovers(Trigger.oldMap,Trigger.newMap);
     // CA_AgreementCustomTriggerHandler.updateAgreementValueinUSD(Trigger.new);
    }
    
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }

  if (Trigger.IsAfter) {
    if (Trigger.isInsert) {      
     CA_AgreementCustomTriggerHandler.insertAgreementLineItemRecords(Trigger.New); 
     CA_AgreementCustomTriggerHandler.populateLegalEntityOnAgreement(null,Trigger.New);        
     if(CA_AgreementCustomTriggerHandler.runOnce())
      {
          CA_AgreementCustomTriggerHandler.insertAggLineItem(Trigger.new,Trigger.oldMap);          
          CA_AgreementCustomTriggerHandler.insertPaymentPlansAndLineItemsFromPrimaryQuote(Trigger.new,null);
          CA_AgreementCustomTriggerHandler.insertPaymentLineItemFromAdditionalQuotes(Trigger.new,Trigger.oldMap);    
          //CA_AgreementCustomTriggerHandler.updateAgreementValueinUSD(Trigger.new);
      }      
    } 
    if (Trigger.isUpdate) {      
      CA_AgreementCustomTriggerHandler.populateLegalEntityOnAgreement(Trigger.oldMap,Trigger.New);  
      CA_AgreementCustomTriggerHandler.updateAgreementStatusonDDR(Trigger.new);
      CA_AgreementCustomTriggerHandler.updateApprovalRequestComments(Trigger.new);
      CA_AgreementCustomTriggerHandler.removeAgreementApprovers(Trigger.oldMap,Trigger.newMap);
      CA_AgreementCustomTriggerHandler.insertPaymentPlansAndLineItemsFromPrimaryQuote(Trigger.new,Trigger.oldMap);
      CA_AgreementCustomTriggerHandler.insertAggLineItem(Trigger.new,Trigger.oldMap);
      CA_AgreementCustomTriggerHandler.insertPaymentLineItemFromAdditionalQuotes(Trigger.new,Trigger.oldMap);
      //CA_AgreementCustomTriggerHandler.updateAgreementValueinUSD(Trigger.new);
      CA_AgreementCustomTriggerHandler.insertAgreementPOBtoChildAgreement(Trigger.new,Trigger.oldMap); //Added by Umang for US312688/US315198
       CA_AgreementCustomTriggerHandler.updateParentPOB(Trigger.new,Trigger.oldMAp);
    }
    if (Trigger.isDelete) {
      // Call class logic here!
    }
  }
 

}