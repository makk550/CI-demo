global class Renewal_BatchUpdateAccount implements Database.Batchable<sObject>{
    Map<Id,Decimal> ocvMap = new Map<Id,Decimal>();
    Map<Id,Decimal> aocvMap = new Map<Id,Decimal>();
    List<Account> accountList = new List<Account>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select Calculated_AOCV_USD__c,Calculated_OCV_USD__c,account__c from active_contract__c');
    }
    global void execute(Database.BatchableContext BC, List<Active_Contract__c> scope){
          processRecords(scope);
        }
     global void processRecords(List<Active_Contract__c> scope)
     {
           for(active_contract__c ac : scope){
        if(ac.account__c != null){
            if(ocvMap.containsKey(ac.account__c)){
            ocvMap.put(ac.account__c,ocvMap.get(ac.account__c) + (ac.Calculated_OCV_USD__c== null?0:ac.Calculated_OCV_USD__c));
            }else{
                ocvMap.put(ac.account__c,(ac.Calculated_OCV_USD__c== null?0:ac.Calculated_OCV_USD__c));
            }
            if(aocvMap.containsKey(ac.account__c)){
                aocvMap.put(ac.account__c,aocvMap.get(ac.account__c) + (ac.Calculated_AOCV_USD__c== null?0:ac.Calculated_AOCV_USD__c));
            }else{
                aocvMap.put(ac.account__c,(ac.Calculated_AOCV_USD__c== null?0:ac.Calculated_AOCV_USD__c));
            }
         }   
        }
        //System.debug(' aocvMap' +aocvMap);
        for(Id id:aocvMap.keyset()){
        Account acc = new Account(
        Id = id,
        ocv__c = ocvMap.get(id),
        aocv__c = aocvMap.get(id));
        accountList.add(acc);
        }
        //System.debug('accountList'+accountList);
        if(accountList.size()>0)
            update accountList;
     }   
        
    global void finish(Database.BatchableContext BC){
    }
}