/* Test Class: updateOppPdtTest
* Code Coverage: 85%
*/


trigger updateOppPdt on Active_Contract_Product__c (after update) {
    List<OpportunityLineItem> oppitem = new List<OpportunityLineItem>();
    List<CA_Product_Renewal__c> renewalContractProd = new List<CA_Product_Renewal__c>();
    //  Set<Id> oppProdsIds = new Set<Id>(); 
    Map<Id,Active_Contract_Product__c> acpProdsIds = new Map<Id,Active_Contract_Product__c>();  
    Map<Id,Decimal > acpIds = new Map<Id,Decimal >(); 
    
    if(Trigger.isUpdate)
    {
        
        for (Active_Contract_Product__c acp : [Select id,  Active_Contract__r.Contract_Term_Months__c from Active_Contract_Product__c where id in : Trigger.NewMap.KeySet()])
        {
            acpIds.put(acp.Id,  acp.Active_Contract__r.Contract_Term_Months__c  );
        }
        
        for(Integer i=0;i<Trigger.new.size();i++) {
            if(Trigger.new[i].ATTRF_CRV__c != Trigger.old[i].ATTRF_CRV__c                 
               
               || Trigger.new[i].AOCV__c != Trigger.old[i].AOCV__c
               || Trigger.new[i].Raw_Maint_Calc_LC__c != Trigger.old[i].Raw_Maint_Calc_LC__c
               || Trigger.new[i].Active_Contract__r.Contract_Term_Months__c != Trigger.old[i].Active_Contract__r.Contract_Term_Months__c
               || Trigger.new[i].Pre_Segmentation__c != Trigger.old[i].Pre_Segmentation__c
               || Trigger.new[i].Segmentation__c != Trigger.old[i].Segmentation__c
               || Trigger.new[i].Product_Baseline_ATTRF_LC__c != Trigger.old[i].Product_Baseline_ATTRF_LC__c)  
            {             
                if(Trigger.new[i].id!= null)
                {
                    acpProdsIds.put(Trigger.new[i].Id,Trigger.new[i]);
                }         
            }
        }
    }
    if(acpProdsIds.size()>0)
    {
        // US450593 -- to update oli -- MERHA02
        for(OpportunityLineItem lineitm:[select Contract_Length__c,Segmentation__c ,Active_Contract_Product__c from opportunitylineitem 
                                         where Active_Contract_Product__c in:acpProdsIds.keyset()]) { 
                                             String segment;
                                             
                                             If(acpProdsIds.get(lineitm.Active_Contract_Product__c).Segmentation__c =='HT'||
                                                acpProdsIds.get(lineitm.Active_Contract_Product__c).Segmentation__c =='MT'||
                                                acpProdsIds.get(lineitm.Active_Contract_Product__c).Segmentation__c =='LT'||
                                                acpProdsIds.get(lineitm.Active_Contract_Product__c).Segmentation__c =='NT'){
                                                    segment=acpProdsIds.get(lineitm.Active_Contract_Product__c).Segmentation__c;  
                                                }
                                             else{ 
                                                 segment = acpProdsIds.get(lineitm.Active_Contract_Product__c).Pre_Segmentation__c; 
                                             }
                                             
                                             lineitm.Segmentation__c = segment ;              
                                             
                                             if (acpIds.size()>0 )
                                             {
                                                 lineitm.Contract_Length__c = acpIds.get(lineitm.Active_Contract_Product__c);            
                                                 
                                             }    
                                             system.debug('@@@@@@@@'+ lineitm );
                                             oppitem.add(lineitm); 
                                         }
        /************ Renewal COntract Products *******************/
        for(CA_Product_Renewal__c RenewalLineItem:[select Active_Contract_Product__c,ATTRF__c,Raw_Maintenance__c,TRR__c,Baseline_ATTRF__c from CA_Product_Renewal__c  where Active_Contract_Product__c in:acpProdsIds.keyset()]){
            
            RenewalLineItem.ATTRF__c = acpProdsIds.get(RenewalLineItem.Active_Contract_Product__c).ATTRF_CRV__c;
            RenewalLineItem.Raw_Maintenance__c = acpProdsIds.get(RenewalLineItem.Active_Contract_Product__c).Raw_Maint_Calc_LC__c;
            RenewalLineItem.TRR__c = acpProdsIds.get(RenewalLineItem.Active_Contract_Product__c).AOCV__c;
            RenewalLineItem.Baseline_ATTRF__c = acpProdsIds.get(RenewalLineItem.Active_Contract_Product__c).Product_Baseline_ATTRF_LC__c;
            
            system.debug('@@@@@@@@'+ RenewalLineItem);
            renewalContractProd.add(RenewalLineItem); 
        }
    }
    if(oppitem.size()>0)
        Database.update(oppitem,false);
    if(renewalContractProd.size() > 0)
        Database.update(renewalContractProd,false);
}