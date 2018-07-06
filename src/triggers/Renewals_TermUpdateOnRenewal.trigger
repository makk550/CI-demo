/**        Trigger Name: Renewals_TermUpdateOnRenewal
           Object Name : Renewal__c
           Event : Before Insert
           Number of SOQLs : 1 
           Author: Accenture
           Last Modified: Mohammad Swaleh, 09/27/10
           
*/

trigger Renewals_TermUpdateOnRenewal on Renewal__c (before insert) {
    
    Map<String,String> acIdRenIdMap = new Map<String,String>();
    Map<String,Double> acIdValueMap = new Map<String,Double>();
    Set<id> idList = new Set<id>();
    
    Map<String,String> acIdCurrIdMap = new Map<String,String>();        
    Map<String,String> acIdRenIdAllMap = new Map<String,String>();
    Set<id> idListCurrency = new Set<id>();
    for(Renewal__c ren: Trigger.new){  
        if(ren.Segmentation__c != 'High'){      
            idList.add(ren.Account__c);
            acIdRenIdMap.put(ren.Id,ren.Account__c);
        }
        idListCurrency.add(ren.Account__c);
        acIdRenIdAllMap.put(ren.Id,ren.Account__c);
    }
    for(Active_Contract__c ac: [SELECT Id, Account__c, Contract_Term_Months__c, Renewal_Currency__c FROM Active_Contract__c WHERE Account__c IN: idList OR Account__c IN: idListCurrency LIMIT 999]){
          if(ac.Account__c == null)continue;
          if(idList.contains(ac.Account__c) && ac.Contract_Term_Months__c != null){
              if(acIdValueMap.containsKey(ac.Account__c)){
                  if(acIdValueMap.get(ac.Account__c) < ac.Contract_Term_Months__c){
                      acIdValueMap.put(ac.Account__c,ac.Contract_Term_Months__c);
                  }   
              }else{
                  acIdValueMap.put(ac.Account__c,ac.Contract_Term_Months__c);
              } 
          }
          //Currency
          if(idListCurrency.contains(ac.Account__c) && ac.Renewal_Currency__c != null){
              if(acIdCurrIdMap.containsKey(ac.Account__c)){
                  continue;      
              }else{
                  acIdCurrIdMap.put(ac.Account__c,ac.Renewal_Currency__c);
              }        
          }
    }
    
    
    for(Renewal__c ren: Trigger.new){
        try{
            ren.Projected_Time_Duration_Months__c = acIdValueMap.get(acIdRenIdMap.get(ren.Id));
            ren.Renewal_Currency__c = acIdCurrIdMap.get(acIdRenIdAllMap.get(ren.Id));
        }catch(Exception e){
            System.debug('Error....'+e.getMessage());
        }
    }
}