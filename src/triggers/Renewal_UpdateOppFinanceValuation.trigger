/*******************
*Purpose :Trigger To Update the Finance Valuation Status of Affected Opportunities in Case the Valuation Status of the record is changed 
*Vauation Status Field depends on fields : Invalid__c In_Progress__c,CRV_Process_completed__c,Finance_Owner__c ,Valuation_Tier_Override__c, Original_Valuation_Tier__c
* 
* Author : Saba 
* Date : 10/10/2011
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       27/8/2017       US384990        Convert ACL Process Builder workflows to Triggers
* SAMAP01       27/8/2017       US384301        Optimize code for ACL load
* ********************************************************************************************/

trigger Renewal_UpdateOppFinanceValuation on Active_Contract__c (after update,after insert,before update) 
{
    
    List<Active_Contract__c> lstACLValuationChanged = new List<Active_Contract__c>();
    List<Active_Contract_Product__c> lstTrackLineItemEdit = new List<Active_Contract_Product__c>(); //SAMAP01
    Set<Id> ActiveContractProductId = new Set<Id>(); //samap01
    for(Active_Contract__c ac: Trigger.new)
    {   
        if(Trigger.isupdate)
        {
            boolean addtolist =false ;
            Active_Contract__c ac_old = Trigger.OldMap.get(ac.id);
            if(ac_old.Invalid__c <> ac.Invalid__c ||
               ac_old.In_Progress__c <> ac.In_Progress__c ||
               ac_old.CRV_Process_completed__c <> ac.CRV_Process_completed__c || 
               ac_old.Finance_Owner__c <> ac.Finance_Owner__c || 
               ac_old.Valuation_Tier_Override__c <> ac.Valuation_Tier_Override__c || 
               ac_old.Original_Valuation_Tier__c <> ac.Original_Valuation_Tier__c)
            {
                addtolist =true;
                // lstACLValuationChanged.add(ac);           samap01                
            }
            // US447735--- to update Headet TARR on opp --- MERHA02
                if(ac_old.Total_TARR_LC__c<>ac.Total_TARR_LC__c){
                    addtolist=true;
                }
           
            if(trigger.isbefore)
            {
            If(ac.Business_Transaction_Type__c =='Time' &&  ac.Valuation_Tier__c =='Tier 2' && ac.CRV_Process_completed__c ==true)
            {
                ac.CRV_Process_completed__c =True;
                addtolist =true;
                
            }
            else if((ac.checkfromlineitem__c==true) && ((ac.CRV_Process_completed__c==true) || (ac.In_Progress__c==true)) && (ac.Status_Formula__c == 'Assigned'))
            {
                ac.checkfromlineitem__c =false;
                addtolist =true;
                
            }
                //merha02 added Total TARR
            else IF( ( (ac.Local_Currency__c <> ac_old.Local_Currency__c) || (ac.OCV__c <> ac_old.OCV__c) || (ac.AOCV__c <> ac_old.AOCV__c) || (ac.ATTRF_CRV__c <> ac_old.ATTRF_CRV__c) 
                      || (ac.Raw_Maint_Calc_LC__c <>ac_old.Raw_Maint_Calc_LC__c) || (ac.Current_Ann_Existing_Maintenance_LC__c <>ac_old.Current_Ann_Existing_Maintenance_LC__c) 
                      || (ac.Contracted_Renewal_Amount_LC__c <> ac_old.Contracted_Renewal_Amount_LC__c) || (ac.Revenue_Per_Day__c <> ac_old.Revenue_Per_Day__c) ||
                      (ac.Total_TARR_LC__c <> ac_old.Total_TARR_LC__c) || (ac.Adjusted_ATTRF_LC__c <> ac_old.Adjusted_ATTRF_LC__c) || (ac.Financed_OCV__c <> ac_old.Financed_OCV__c) 
                      || (ac.Financed_TRR_LC__c <>ac_old.Financed_TRR_LC__c) || (ac.Finance_ATTRF__c <>ac_old.Finance_ATTRF__c) || (ac.USD_Conversion_Rate__c <> ac_old.USD_Conversion_Rate__c)
                      || (ac.ATTRF_USD__c <> ac_old.ATTRF_USD__c) || (ac.Raw_Maint_USD__c <>ac_old.Raw_Maint_USD__c) || (ac.Total_TARR_USD__c <>ac_old.Total_TARR_USD__c) 
                      || (ac.Adjusted_ATTRF_USD__c <> ac_old.Adjusted_ATTRF_USD__c) || (ac.Financed_OCV_USD__c <> ac_old.Financed_OCV_USD__c) || 
                      (ac.Financed_TRR_USD__c <>ac_old.Financed_TRR_USD__c) || (ac.Financed_ATTRF_USD__c <>ac_old.Financed_ATTRF_USD__c) ) && (ac.Status_Formula__c=='Validated' 
                      || ac.Status_Formula__c=='Assigned') && (ac.SAP_TOPS__c=='S' || ac.SAP_TOPS__c=='T' && ac.Valuation_Tier__c != 'Tier 2') || (ac.checkfromlineitem__c==true))   
            {
                //merha02 --- US432438
                    if(Renewal_CRVController.valuation_status_flag==false){
                        ac.checkfromlineitem__c =true;
                        ac.CRV_Process_completed__c =false;
                        ac.In_Progress__c =false;
                        addtolist =true;
                    }
                   
            }
            }
            if( addtolist==true)
            {
                lstACLValuationChanged.add(ac);
            }
            
            
           
        }
        
        if(Trigger.isinsert)
            lstACLValuationChanged.add(ac);  
        
    }
  
    if(lstACLValuationChanged.size() > 0)
    {
        Set<id> oppId_set=new Set<id>(); // US447735 -- merha02
        List<OpportunityLineItem> lst_opp_OLI = [Select Active_Contract_Product__r.Active_Contract__r.Status_Formula__c,
                                                 Active_Contract__r.Total_TARR_LC__c,Active_Contract__c,
                                                 Active_Contract_Product__c, OpportunityId
                                                 FROM OpportunityLineItem where Active_Contract__c in : lstACLValuationChanged and Business_Type__c = 'Renewal' ];    
        
        Map<id,Set<String>> mOppOLI = new Map<id,Set<String>>();
         Map<id,List<Active_Contract_Product__c>> oppAcpMap = new Map<id,List<Active_Contract_Product__c>>(); // map of opp and its acp list
        if(lst_opp_OLI <> null && lst_opp_OLI.size() >0)
        {
            
            Set<String> status_values;   
            for(OpportunityLineItem oli_temp: lst_opp_OLI)
            {
                 System.debug('1111-'+oli_temp.Active_Contract_Product__r.Active_Contract__r.Status_Formula__c); //SAMAP01
                status_values = mOppOLI.get(oli_temp.OpportunityId);
                if(status_values ==null)
                    status_values = new Set<String>();
                status_values.add(oli_temp.Active_Contract_Product__r.Active_Contract__r.Status_Formula__c);    
                mOppOLI.put(oli_temp.OpportunityId,status_values);
                
                oppId_set.add(oli_temp.OpportunityId); // set of opp ids -- US447735 merha02
            }
            // US447735--- to update Headet TARR on opp --- MERHA02 -- start
            if(oppId_set!=null && oppId_set.size()>0){
                    List<Active_Contract_Product__c> Acp_list=[select id,Opportunity__c,Active_Contract__c,Active_Contract__r.Total_TARR_LC__c from Active_Contract_Product__c where Opportunity__c in : oppId_set];
                    if(Acp_list!=null && Acp_list.size()>0){
                        for(Active_Contract_Product__c acp: Acp_list){
                            if(oppAcpMap.get(acp.Opportunity__c)!=null){
                                oppAcpMap.get(acp.Opportunity__c).add(acp);
                            }
                            else{
                                List<Active_Contract_Product__c> acplist = new List<Active_Contract_Product__c>();
                                acplist.add(acp);
                                oppAcpMap.put(acp.Opportunity__c,acplist);
                            }
                        }
                        
                    }
                }   
            // US447735--- to update Headet TARR on opp --- MERHA02 -- end
        }
        List<Opportunity> UpdateOpps = new List<Opportunity>(); 
        for(Id oppId:  mOppOLI.keySet())
        {   
            Opportunity opp = new Opportunity(id=oppId);
            List<Active_Contract_Product__c> acpList = oppAcpMap.get(oppId); // list of acp for each opp
             Map<Id,Decimal> AC_TARR = new Map<Id,Decimal>(); // map of AC id and its TARR value
            Decimal TARR_value=0; // sum of tarr values
            Boolean isValidated = true;
            Set<String> status_value=mOppOLI.get(oppId);
            System.debug('2222-'+status_value);
            // US447735--- to update Headet TARR on opp --- MERHA02 -- start
            if(acpList!=null && acpList.size()>0){
                
                for(Active_Contract_Product__c acp : acpList){
                    if(acp.Active_Contract__c!=null){
                        if(!AC_TARR.containsKey(acp.Active_Contract__c)){
                            if(acp.Active_Contract__r.Total_TARR_LC__c!=null){
                                
                                AC_TARR.put(acp.Active_Contract__c,acp.Active_Contract__r.Total_TARR_LC__c);
                                TARR_value=TARR_value+acp.Active_Contract__r.Total_TARR_LC__c;
                                
                            }
                        }
                    }
                }
            } 
            
            opp.Header_TARR_Old_SFDC__c = TARR_value; 
              // US447735--- to update Headet TARR on opp --- MERHA02 -- end
            
            if(status_value != null && status_value.size() > 0)
            {
                System.debug('status_value - '+status_value);     
                if(status_value.contains('In Progress') || status_value.contains('Assigned') || status_value.contains('In Scope'))
                    isValidated =  false;
                
                opp.Finance_Valuation_Status__c = (isValidated?'Validated':'Not Validated');
                system.debug(opp.Finance_Valuation_Status__c);
            }
            else
            {
                opp.Finance_Valuation_Status__c = '';
            }
            
            UpdateOpps.add(opp);
        }
        
        if(UpdateOpps <> null && UpdateOpps.size() > 0)
        {
            Database.Update(UpdateOpps, false);
            //update UpdateOpps;
        }
    }
}