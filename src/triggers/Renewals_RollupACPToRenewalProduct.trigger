/*    
       Trigger Name: Renewals_RollupACPToRenewalProduct
       Object Name : Active_Contract_Product__c   
       Event : After Insert, After Update, After Delete    
       Number of SOQLs : 1        
       Author: Accenture    
       Last Modified: Mohammad Swaleh, 09/23/10
*/


trigger Renewals_RollupACPToRenewalProduct on Active_Contract_Product__c (after insert, after update, after delete){
   if(Renewal_ConvertActiveContracts.fromClass !=null && Renewal_ConvertActiveContracts.fromClass== true)
       return;
   
    Set<Id> renewalProdsIds = new Set<Id>();    
    Map<Id,List<Active_Contract_product__c>> acpMap = new  Map<Id,List<Active_Contract_product__c>>();                                                 
    Map<Id,Integer> acpProdCount = new Map<Id,Integer>();
    Map<Id,Active_Contract_Product__c> contractProdsIds = new Map<Id,Active_Contract_Product__c>();    
	List<CA_Product_Renewal__c> caProdLst = new List<CA_Product_Renewal__c>();
	Set<ID> idsAC = new Set<ID>(); 
    if(Trigger.isInsert){    
        for(Active_Contract_Product__c acp : trigger.new){        
            if((acp.ATTRF_CRV__c != 0 || acp.OCV__c != 0 || acp.AOCV__c != 0 || acp.Raw_Maint_Calc_LC__c != 0 || acp.ExpiringARRLC__c != 0 //PORAS01 - US500913 - Adding the Expiring ARR field
            || acp.Current_Ann_Existing_Maintenance_LC__c != 0 || acp.Revenue_Per_Day__c != 0 || acp.Product_Baseline_ATTRF_LC__c!=0)
             && acp.Renewal_Product__c != null){        
                renewalProdsIds.add(acp.Renewal_Product__c);
            }
            if(acp.AOCV__c != 0 || acp.ATTRF_CRV__c != 0){
                contractProdsIds.put(acp.Id,acp);
            }

        }
    }

    if(Trigger.isUpdate){    
        for(Integer i=0;i<Trigger.new.size();i++){
        	//Added from here ANitha Dec' Release
        	if((Trigger.new[i].Segmentation__c == 'Unattached' && Trigger.new[i].Segmentation__c <> Trigger.old[i].Segmentation__c) 
        		|| (Trigger.new[i].Segmentation__c == 'Invalid' && Trigger.new[i].Segmentation__c <> Trigger.old[i].Segmentation__c))
        		idsAC.add(Trigger.new[i].Active_Contract__c);
        	System.debug('_______________ACP List mapUnAttachACPList'+idsAC);
			//Till here Anitha
			        	
            if(Trigger.new[i].ATTRF_CRV__c != Trigger.old[i].ATTRF_CRV__c                 
            || Trigger.new[i].OCV__c != Trigger.old[i].OCV__c
            || Trigger.new[i].AOCV__c != Trigger.old[i].AOCV__c
            || Trigger.new[i].Raw_Maint_Calc_LC__c != Trigger.old[i].Raw_Maint_Calc_LC__c
            || Trigger.new[i].Current_Ann_Existing_Maintenance_LC__c != Trigger.old[i].Current_Ann_Existing_Maintenance_LC__c
            || Trigger.new[i].Revenue_Per_Day__c != Trigger.old[i].Revenue_Per_Day__c
            || Trigger.new[i].Renewal_Product__c != Trigger.old[i].Renewal_Product__c 
            || Trigger.new[i].Product_Baseline_ATTRF_LC__c != Trigger.old[i].Product_Baseline_ATTRF_LC__c
            || Trigger.new[i].ExpiringARRLC__c != Trigger.old[i].ExpiringARRLC__c //PORAS01 - US500913 - Adding the Expiring ARR field
            )  
          {              
              /* If the active contract product IS CURRENTLY associated with any renewal product */              
                if(Trigger.new[i].Renewal_Product__c != null)
                {
                    /* Refresh the rollup value on the CURRENT renewal product */
                    renewalProdsIds.add(Trigger.new[i].Renewal_Product__c);
                }

                /* If the active contract product WAS PREVIOUSLY associated with a DIFFERENT renewal product */
                if(Trigger.new[i].Renewal_Product__c != Trigger.old[i].Renewal_Product__c && Trigger.old[i].Renewal_Product__c != null)
                {
                      /* Refresh the rollup value on the PREVIOUS renewal product */
                      renewalProdsIds.add(Trigger.old[i].Renewal_Product__c);
                }
            }
            if(Trigger.new[i].ATTRF_CRV__c != Trigger.old[i].ATTRF_CRV__c                 
            || Trigger.new[i].AOCV__c != Trigger.old[i].AOCV__c)
            {
                contractProdsIds.put(Trigger.new[i].Id,Trigger.new[i]);
            }
        }
    }

        
    if(Trigger.isDelete){    
        for(Active_Contract_Product__c acp : trigger.old){    
            if((acp.ATTRF_CRV__c != 0 || acp.OCV__c != 0 || acp.AOCV__c != 0 || acp.Raw_Maint_Calc_LC__c != 0 || acp.AOCV__c != 0 || acp.ExpiringARRLC__c != 0 //PORAS01 - US500913 - Adding the Expiring ARR field 
            || acp.Current_Ann_Existing_Maintenance_LC__c != 0 || acp.Revenue_Per_Day__c != 0 || acp.Product_Baseline_ATTRF_LC__c != 0)
             && acp.Renewal_Product__c != null){
                renewalProdsIds.add(acp.Renewal_Product__c);
            }
            if(acp.AOCV__c != 0 || acp.ATTRF_CRV__c != 0){
                contractProdsIds.put(acp.Id,acp);
            }

        }     
    } 

	//Anitha CR:192831694 from here
    Set<ID> removeFromRen = new Set<ID>();
    List<Active_Contract__c> TotACPList = new List<Active_Contract__c>();
    if(idsAC.size()>0)
    {
    	//Anitha From here Dec Release
	    TotACPList = [Select id, (select id from Contract_Products__r where Segmentation__c <> 'Unattached' AND Segmentation__c <> 'Invalid') from Active_Contract__c where id IN : idsAC];
	    for(Active_Contract__c ac : TotACPList)
	    {
	    	System.debug('_____________ac.Contract_Products__r.size()'+ac.Contract_Products__r.size());
	    	if(ac.Contract_Products__r.size() == 0 || ac.Contract_Products__r == null)
	    		removeFromRen.add(ac.id);
	    }
	    System.debug(TotACPList+'_______________Detach Anitha'+removeFromRen);
	}
    
    List<Renewal_Contracts__c> detachFromRen = new List<Renewal_Contracts__c>();   
    detachFromRen = [select id, Renewal__c from Renewal_Contracts__c where Active_Contract__c in : removeFromRen];
    //delete detachFromRen; 12-Dec-2012.
    for(Renewal_Contracts__c rc : detachFromRen)
    	rc.Renewal__c = null;
    System.debug(TotACPList+'_______________Detach RC'+detachFromRen);	
	if(detachFromRen.size()>0)
    	update detachFromRen;
    //Anitha Till here

    if(renewalProdsIds.size() > 0){   
        Map<Id,Renewal_Product__c> renewalProductsToUpdate = new Map<Id,Renewal_Product__c>([SELECT Id, Annual_OCV_LC__c,Name, OCV__c, ATTRF_CRV__c, Raw_Maintenance_Calc__c, 
                                    Current_Ann_Existing_Maintenance_LC__c,Revenue_Per_Day__c,Baseline_ATTRF_LC__c, Expiring_ARR_LC__c, //PORAS01 - US500913 - Adding the Expiring ARR field 
                                    (SELECT Id, AOCV__c, OCV__c,Current_Ann_Existing_Maintenance_LC__c, 
                                     Revenue_Per_Day__c,ATTRF_CRV__c, Raw_Maint_Calc_LC__c,Product_Baseline_ATTRF_LC__c, ExpiringARRLC__c //PORAS01 - US500913 - Adding the Expiring ARR field 
                                     FROM Contract_Products__r)
                                    FROM Renewal_Product__c WHERE Id IN : renewalProdsIds]);
                                    
        for(Renewal_Product__c rp: renewalProductsToUpdate.values()){
            Double ocv = 0;
            Double attrf = 0;
            Double rawMaintCalc = 0;
            Double aocv = 0;
            Double currExMaint = 0;
            Double rpd = 0;
			Double baselineattrf = 0;
            Double expiringARR = 0; //PORAS01 - US500913 - Declaring variable to hold expiring ARR field value.
            
            for (Active_Contract_Product__c acp: rp.Contract_Products__r)
            {
                if(acp.ATTRF_CRV__c != null)attrf += acp.ATTRF_CRV__c;
                if(acp.OCV__c != null)ocv += acp.OCV__c;
                if(acp.Raw_Maint_Calc_LC__c != null)rawMaintCalc += acp.Raw_Maint_Calc_LC__c;
                if(acp.AOCV__c != null) aocv += acp.AOCV__c;
                if(acp.Current_Ann_Existing_Maintenance_LC__c != null) currExMaint += acp.Current_Ann_Existing_Maintenance_LC__c;
                if(acp.Revenue_Per_Day__c != null) rpd += acp.Revenue_Per_Day__c;
				if(acp.Product_Baseline_ATTRF_LC__c != null) baselineattrf += acp.Product_Baseline_ATTRF_LC__c;
                //PORAS01 - US500913 - Calculating value for Expiring ARR (LC)
                if(acp.ExpiringARRLC__c != null) expiringARR += acp.ExpiringARRLC__c;
                //PORAS01 - US500913 - End
                
                
            }
            rp.Annual_OCV_LC__c = aocv ;
            rp.ATTRF_CRV__c = attrf;
            rp.OCV__c = ocv;
            rp.Raw_Maintenance_Calc__c = rawMaintCalc;
            rp.Current_Ann_Existing_Maintenance_LC__c = currExMaint;
            rp.Revenue_Per_Day__c = rpd;
			rp.Baseline_ATTRF_LC__c = baselineattrf;
            //PORAS01 - US500913 - Calculating value for Expiring ARR (LC)
			rp.Expiring_ARR_LC__c = expiringARR;            
            //PORAS01 - US500913 - End
        }
        System.debug('contractProdsIds ## '+contractProdsIds);
        if(contractProdsIds.size()>0){
            for(CA_Product_Renewal__c ca:[Select c.TRR__c, c.ATTRF__c, c.Active_Contract_Product__c,c.Baseline_ATTRF__c 
            from CA_Product_Renewal__c c where Active_Contract_Product__c in: contractProdsIds.keyset()]){
                ca.TRR__c = contractProdsIds.get(ca.Active_Contract_Product__c).AOCV__c;
                ca.ATTRF__c = contractProdsIds.get(ca.Active_Contract_Product__c).ATTRF_CRV__c;
				ca.Baseline_ATTRF__c = contractProdsIds.get(ca.Active_Contract_Product__c).Product_Baseline_ATTRF_LC__c;
                caProdLst.add(ca);
            }
        }
        //update the database
        Database.update(caProdLst,false);

        Database.update(renewalProductsToUpdate.values(),false);
    }
}