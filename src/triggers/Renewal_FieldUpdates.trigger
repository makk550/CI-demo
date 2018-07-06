/* ********************************************************************************************
* Modified By  Date   			User Story		Details
* SAMAP01		24/8/2017		US384990   		Convert ACL Process Builder workflows to Triggers
* SAMAP01		04/01/2018		US424523		iF mATERIAL_TARR_LC CHANGES - Update oli as well
* ********************************************************************************************/
trigger Renewal_FieldUpdates on Active_Contract_Line_Item__c (before update, before insert,after insert, after update ) {
    List<Active_Contract__c> lstcheckfromlineitem = new List<Active_Contract__c>(); //SAMAP01
    Set<Id> ActiveContractIds = new Set<Id>(); 
    Map<Id, Active_Contract_Line_Item__c>  oliAcliMap = new  Map<Id, Active_Contract_Line_Item__c>();  //merha02 - need to update oli
    if(Trigger.isupdate && Trigger.isbefore) //samap01
    {
          // amili01 - US453781 Increase field calculations      
          // get all Contract_Product__c ids
         set<id> Cpids=new set<id>();
         Map<id,Active_Contract_Line_Item__c> AclMap=new Map<id,Active_Contract_Line_Item__c>();
        for(Integer i=0;i<Trigger.new.size();i++){
            Cpids.add(trigger.new[i].Contract_Product__c);
        }
        if(Cpids != null && Cpids.size()>0){
        ACL_Increase_calc IncCal=new ACL_Increase_calc();
          AclMap=IncCal.CalculateIncStep1_2_3(Cpids,Trigger.new);
        }
                      
        for(Integer i=0;i<Trigger.new.size();i++)
        {  
           if(AclMap.containsKey(trigger.new[i].id) ){
                
            trigger.new[i].Increase_Step_1_text2__c=AclMap.get(trigger.new[i].id).Increase_Step_1_text2__c;
            System.debug('-------trigger step 1------'+trigger.new[i].Increase_Step_1_text2__c);
            trigger.new[i].Increase_Step_2_text__c=AclMap.get(trigger.new[i].id).Increase_Step_2_text__c;
            trigger.new[i].Increase_Step_3_text__c=AclMap.get(trigger.new[i].id).Increase_Step_3_text__c;
              
            }
          
            // end of US453781
            
            if(trigger.new[i].AOCV__c != trigger.old[i].AOCV__c && trigger.new[i].TRR__c == trigger.old[i].TRR__c && trigger.new[i].stop_sync_trr_lc__c != true )      
            {         
                if(trigger.old[i].AOCV__c==trigger.old[i].TRR__c){
                    trigger.new[i].TRR__c=trigger.new[i].AOCV__c;                          
                }        
                else{
                    trigger.new[i].stop_sync_trr_lc__c = true;  
                } 
            }
            
            if(trigger.new[i].Orig_ATTRF_LC__c != trigger.old[i].Orig_ATTRF_LC__c && trigger.new[i].Adjusted_ATTRF_LC__c == trigger.old[i].Adjusted_ATTRF_LC__c && trigger.new[i].stop_sync_attrf__c != true )
            { 
                if(trigger.old[i].Orig_ATTRF_LC__c==trigger.old[i].Adjusted_ATTRF_LC__c)
                {
                    trigger.new[i].Adjusted_ATTRF_LC__c=trigger.new[i].Orig_ATTRF_LC__c;
                    
                } 
                else
                {
                    trigger.new[i].stop_sync_attrf__c = true;
                }  
            }
            //merha02 -- US432438 -- to skip valuation status update when ACLI renewal valuation type changes
            if((trigger.new[i].Renewal_Valuation_Type__c )!=(trigger.old[i].Renewal_Valuation_Type__c ))
                Renewal_CRVController.valuation_status_flag=true;
            
        }
    }
    if(Trigger.isinsert && Trigger.isbefore)
    {
         // amili01 - US453781 Increase field calculations
         set<id> Cpids=new set<id>();
         Map<id,Active_Contract_Line_Item__c> AclMap=new Map<id,Active_Contract_Line_Item__c>();
        for(Integer i=0;i<Trigger.new.size();i++){
            Cpids.add(trigger.new[i].Contract_Product__c);
        }
        if(Cpids != null && Cpids.size()>0){
        ACL_Increase_calc IncCal=new ACL_Increase_calc();
          AclMap=IncCal.CalculateIncStep1_2_3(Cpids,Trigger.new);
        }
                    
        for(Integer i=0;i<Trigger.new.size();i++){
            
           if(AclMap.containsKey(trigger.new[i].id) ){
                
            trigger.new[i].Increase_Step_1_text2__c=AclMap.get(trigger.new[i].id).Increase_Step_1_text2__c;
            System.debug('-------trigger step 1------'+trigger.new[i].Increase_Step_1_text2__c);
            trigger.new[i].Increase_Step_2_text__c=AclMap.get(trigger.new[i].id).Increase_Step_2_text__c;
            trigger.new[i].Increase_Step_3_text__c=AclMap.get(trigger.new[i].id).Increase_Step_3_text__c;
            }
            // end of US453781
            
            if(trigger.new[i].TRR__c==null){    
                trigger.new[i].TRR__c=trigger.new[i].AOCV__c;    
            }   
            else{    
                trigger.new[i].stop_sync_trr_lc__c = true;  
            }
            // US388344 MERHA02 starts here to include Material TARR
            if(trigger.new[i].TARR_No_of_Days__c!=null && trigger.new[i].TARR_No_of_Days__c!=0 && trigger.new[i].OCV__c!=null){               
                trigger.new[i].Material_TARR_LC__c= (trigger.new[i].OCV__c/trigger.new[i].TARR_No_of_Days__c) * 365;
            }
            else{
                trigger.new[i].Material_TARR_LC__c=0;
            }
            
            // US388344 MERHA02 ends here
            
            
            if(trigger.new[i].Adjusted_ATTRF_LC__c==null){
                trigger.new[i].Adjusted_ATTRF_LC__c=trigger.new[i].Orig_ATTRF_LC__c;
            }
            else{
                trigger.new[i].stop_sync_attrf__c = true;
            } 
        }
    }
    
    
    //samap01 -US384990
    if(Trigger.isafter) 
    {     
        
        {
            for(Integer i=0;i<Trigger.new.size();i++)
            {
                if(trigger.new[i].Contract_Product__c !=null ) 
                {
                    if(Trigger.isupdate)
                    {
                        //added Material TARR MERHA02 US388344
                        if(trigger.new[i].Adjusted_ATTRF_LC__c != trigger.old[i].Adjusted_ATTRF_LC__c ||trigger.new[i].Material_TARR_LC__c!=trigger.old[i].Material_TARR_LC__c ||
                           trigger.new[i].Revenue_Per_Day__c != trigger.old[i].Revenue_Per_Day__c ||  trigger.new[i].Raw_Maint_Calc_LC__c != trigger.old[i].Raw_Maint_Calc_LC__c ||
                           trigger.new[i].ATTRF_CRV__c != trigger.old[i].ATTRF_CRV__c || trigger.new[i].Contracted_Renewal_Amount__c != trigger.old[i].Contracted_Renewal_Amount__c ||
                           trigger.new[i].Current_Annu_Existing_Maintenance__c != trigger.old[i].Current_Annu_Existing_Maintenance__c || trigger.new[i].AOCV__c != trigger.old[i].AOCV__c ||
                           trigger.new[i].OCV__c != trigger.old[i].OCV__c )
                            
                        {
                            ActiveContractIds.add(trigger.new[i].ActiveContractId__c);  
                        }
                        // US450593 -- exclusion of EOL products -- MERHA02 -- start
                        if(trigger.new[i].Material_TARR_LC__c!=trigger.old[i].Material_TARR_LC__c 
                           || trigger.new[i].Orig_ATTRF_LC__c!=trigger.old[i].Orig_ATTRF_LC__c|| trigger.new[i].AOCV__c!=trigger.old[i].AOCV__c
                           || trigger.new[i].Install_Dismantle_Duration_months__c!=trigger.old[i].Install_Dismantle_Duration_months__c
                           || trigger.new[i].Dismantling_Date__c!=trigger.old[i].Dismantling_Date__c
                           || trigger.new[i].Raw_Maintenance_LC__c!=trigger.old[i].Raw_Maintenance_LC__c
                           || trigger.new[i].Renewal_Valuation_Type__c!=trigger.old[i].Renewal_Valuation_Type__c){
                               if(trigger.new[i].Opportunity_Product__c != null)
                               {
                                   
                                   oliAcliMap.put(trigger.new[i].Opportunity_Product__c, trigger.new[i]);
                                   System.debug('-----------ATTRF------'+trigger.new[i].Orig_ATTRF_LC__c+'----'+trigger.old[i].Orig_ATTRF_LC__c);
                               }
                           }
                        // US450593 -- exclusion of EOL products -- MERHA02 -- end
                    }
                    if(Trigger.isinsert)
                        ActiveContractIds.add(trigger.new[i].ActiveContractId__c);  
                }
            }
            
            // US450593 -- exclusion of EOL products -- MERHA02 -- start
            IF(oliAcliMap!=null && oliAcliMap.size() >0)
            {
                LIST<opportunitylineitem> olitoupdate = new LIST<opportunitylineitem>();
                
                for(OpportunityLineItem lineitm:[select Id,TARR__c,ATTRF__c,Contract_Length__c,
                                                 Old_TRR__c ,Original_CV__c,Original_Deal_Term_Months__c,Original_Expiration_Date__c ,
                                                 Raw_Maintenance__c,
                                                 Baseline_ATTRF_LC__c from opportunitylineitem 
                                                 where Id in :oliAcliMap.keySet()]){
                                                     System.debug('-------line item---------'+lineitm);
                                                     if(oliAcliMap!=null && oliAcliMap.size()>0 && oliAcliMap.containsKey(lineitm.id)){
                                                         decimal materialtarr = oliAcliMap.get(lineitm.id).Material_TARR_LC__c;
                                                         System.debug('samap01 materialtarr'+ materialtarr );
                                                         lineitm.TARR__c =  materialtarr;
                                                         
                                                         lineitm.Original_CV__c = oliAcliMap.get(lineitm.id).OCV__c; 
                                                         lineitm.Original_Expiration_Date__c  = oliAcliMap.get(lineitm.id).Dismantling_Date__c;
                                                         lineitm.Original_Deal_Term_Months__c = oliAcliMap.get(lineitm.id).Install_Dismantle_Duration_months__c;
                                                         lineitm.Baseline_ATTRF_LC__c = oliAcliMap.get(lineitm.id).Baseline_ATTRF_LC__c;
                                                         
                                                         
                                                         if(oliAcliMap.get(lineitm.id).Renewal_Valuation_Type__c=='Invalid-EOL-No Replacement Product'
                                                            ||oliAcliMap.get(lineitm.id).Renewal_Valuation_Type__c=='Invalid - Federal Rebook'){
                                                                lineitm.ATTRF__c = 0.0;
                                                                lineitm.Old_TRR__c = 0.0;
                                                                lineitm.Raw_Maintenance__c  = 0.0;
                                                            }else{
                                                                lineitm.ATTRF__c = oliAcliMap.get(lineitm.id).Orig_ATTRF_LC__c;
                                                                lineitm.Old_TRR__c = oliAcliMap.get(lineitm.id).AOCV__c;
                                                                lineitm.Raw_Maintenance__c  = oliAcliMap.get(lineitm.id).Raw_Maintenance_LC__c;
                                                            }
                                                         olitoupdate.add(lineitm);  
                                                     }
                                                 }
                if(olitoupdate.size()>0){
                    System.debug('--------OLI to update---------'+olitoupdate);
                    OpportunityHandler.renewalToOppConversion = true;
                    update olitoupdate;
                }
            }
            // US450593 -- exclusion of EOL products -- MERHA02 -- end
            //SAMAP01
            if(ActiveContractIds.size()>0)
            {
                List<Active_Contract__c>  aclist = [Select id, CRV_Process_completed__c,checkfromlineitem__c  from Active_Contract__c where id in : ActiveContractIds];
                for(Active_Contract__c ac : aclist)
                {
                    if(ac.CRV_Process_completed__c ==true)
                    {
                        ac.checkfromlineitem__c =true;
                        ac.CRV_Process_completed__c =false;
                        lstcheckfromlineitem.add(ac) ; 
                        SYSTEM.debug('samap01 - valuation complete set to false for ' +ac.id);
                    }
                    
                }
                if(lstcheckfromlineitem.size()>0)
                    Database.update(lstcheckfromlineitem,false);
                
            }
            
            
        }
        
    }
    
}