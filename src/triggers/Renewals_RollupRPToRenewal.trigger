/**    
Trigger Name: Renewals_RollupRPToRenewal    
Object Name : Renewal_Product__c    
Event : After Insert, After Update, After Delete    
Number of SOQLs : 1        
Author: Accenture    
Last Modified: Mohammad Swaleh, 09/27/10
*/

trigger Renewals_RollupRPToRenewal on Renewal_Product__c (after insert, after update, after delete){
    if(Renewal_ConvertActiveContracts.fromClass !=null && Renewal_ConvertActiveContracts.fromClass== true)
        return;
    
    if(Renewals_Util.fromAfterTrigger)return;
    
    Set<Id> renewalsIds = new Set<Id>();       
    
    if(Trigger.isInsert){    
        for(Renewal_Product__c rp : trigger.new){ 
            
            if((rp.ATTRF_CRV__c != 0 || rp.OCV__c != 0 || rp.Raw_Maintenance_Calc__c != 0 || rp.Projected_Renewal_LC__c != 0
                || rp.Revenue_Per_Day__c != 0 || rp.Current_Ann_Existing_Maintenance_LC__c != 0 || rp.Baseline_ATTRF_LC__c!=0 || rp.Expiring_ARR_LC__c != 0 //PORAS01 - US500913 - Adding the Expiring ARR field 
               )
               && rp.Renewal__c != null){        
                   renewalsIds.add(rp.Renewal__c);
               }
        }
    }
    
    if(Trigger.isUpdate){    
        for(Integer i=0;i<Trigger.new.size();i++){        
            if((Trigger.new[i].ATTRF_CRV__c != Trigger.old[i].ATTRF_CRV__c 
                || Trigger.new[i].OCV__c != Trigger.old[i].OCV__c 
                || Trigger.new[i].Annual_OCV_LC__c != Trigger.old[i].Annual_OCV_LC__c 
                || Trigger.new[i].Raw_Maintenance_Calc__c != Trigger.old[i].Raw_Maintenance_Calc__c
                || Trigger.new[i].Projected_Renewal_LC__c != Trigger.old[i].Projected_Renewal_LC__c
                || Trigger.new[i].Current_Ann_Existing_Maintenance_LC__c != Trigger.old[i].Current_Ann_Existing_Maintenance_LC__c
                || Trigger.new[i].Revenue_Per_Day__c != Trigger.old[i].Revenue_Per_Day__c
                || Trigger.new[i].Baseline_ATTRF_LC__c != Trigger.old[i].Baseline_ATTRF_LC__c
                || Trigger.new[i].Expiring_ARR_LC__c != Trigger.old[i].Expiring_ARR_LC__c //PORAS01 - US500913 - Adding the Expiring ARR field 
               ) 
               && Trigger.new[i].Renewal__c != null){
                   renewalsIds.add(Trigger.new[i].Renewal__c);
               }
        }
    }
    
    
    if(Trigger.isDelete){    
        for(Renewal_Product__c rp : trigger.old){ 
            
            if((rp.ATTRF_CRV__c != 0 || rp.OCV__c != 0 || rp.Raw_Maintenance_Calc__c != 0 || rp.Projected_Renewal_LC__c != 0 || rp.Annual_OCV_LC__c != 0
                || rp.Revenue_Per_Day__c != 0 || rp.Current_Ann_Existing_Maintenance_LC__c != 0 || rp.Baseline_ATTRF_LC__c!=0 || rp.Expiring_ARR_LC__c != 0 //PORAS01 - US500913 - Adding the Expiring ARR field 
               )
               && rp.Renewal__c != null){
                   renewalsIds.add(rp.Renewal__c);
               }
        }     
    } 
    
    if(renewalsIds.size() > 0){   
        Map<Id,Renewal__c> renewalsToUpdate = new Map<Id,Renewal__c>([SELECT Id, Name,
                                                                      Annual_OCV__c,Annual_OCV_LC__c, OCV__c, Projected_Renewal__c, Raw_Maint_Calc__c, ATTRF_CRV__c, 
                                                                      Expiring_ARR_LC__c, //PORAS01 - US500913 - Adding Expiring_ARR_LC field to query
                                                                      Revenue_Per_Day__c , Current_Ann_Existing_Maintenance_LC__c,Baseline_ATTRF_LC__c,
                                                                      (SELECT Id, OCV__c, Annual_OCV_LC__c,Projected_Renewal_LC__c, Raw_Maintenance_Calc__c, ATTRF_CRV__c, Expiring_ARR_LC__c, //PORAS01 - US500913 - Adding Expiring_ARR_LC field to query
                                                                       Current_Ann_Existing_Maintenance_LC__c,Revenue_Per_Day__c,Baseline_ATTRF_LC__c FROM Renewal_Products__r)
                                                                      FROM Renewal__c WHERE Id IN : renewalsIds]);
        
        for(Renewal__c ren: renewalsToUpdate.values()){
            Double attrf = 0;
            Double ocv = 0;
            Double rawMaintCalc = 0; 
            Double projRenewal = 0;      
            Double aocv = 0;
            Double currExMaint = 0;      
            Double rpd = 0;
            double baselineattrf = 0;
            //PORAS01 - US500913 - Declaring variable to hold expiring arr value.
            double expiringArr = 0;
            //PORAS01 - US500913 -End
            
            for (Renewal_Product__c rp: ren.Renewal_Products__r){
                if(rp.ATTRF_CRV__c != null) attrf += rp.ATTRF_CRV__c;
                if(rp.OCV__c != null) ocv += rp.OCV__c;
                if(rp.Annual_OCV_LC__c != null) aocv += rp.Annual_OCV_LC__c;
                if(rp.Current_Ann_Existing_Maintenance_LC__c != null) currExMaint += rp.Current_Ann_Existing_Maintenance_LC__c;
                if(rp.Revenue_Per_Day__c != null) rpd += rp.Revenue_Per_Day__c;
                if(rp.Raw_Maintenance_Calc__c != null) rawMaintCalc += rp.Raw_Maintenance_Calc__c;
                if(rp.Projected_Renewal_LC__c != null) projRenewal += rp.Projected_Renewal_LC__c;
                if(rp.Baseline_ATTRF_LC__c != null) baselineattrf += rp.Baseline_ATTRF_LC__c;
                //PORAS01 - US500913 - Calculating value for Expiring ARR (LC)
                if(rp.Expiring_ARR_LC__c != null) expiringArr += rp.Expiring_ARR_LC__c;
                //PORAS01 - US500913 - End
            }
            ren.Annual_OCV_LC__c = aocv; 
            ren.ATTRF_CRV__c = attrf;
            ren.OCV__c = ocv;
            ren.Current_Ann_Existing_Maintenance_LC__c = currExMaint;
            ren.Revenue_Per_Day__c = rpd;
            ren.Raw_Maint_Calc__c = rawMaintCalc;
            ren.Projected_Renewal__c = projRenewal;
            ren.Baseline_ATTRF_LC__c = baselineattrf;
            //PORAS01 - US500913 - Calculating value for Expiring ARR (LC)
            ren.Expiring_ARR_LC__c = expiringArr;
            //PORAS01 - US500913 - End
            
        }
        
        Renewals_Util.fromRenewals_RollupRPToRenewal = true;
        //update the database
        Database.update(renewalsToUpdate.values(),false);        
    }
    
}