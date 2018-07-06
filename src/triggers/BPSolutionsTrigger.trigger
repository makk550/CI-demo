/*AR3371 - ensures currency on solution reocrd matches currency on business plan.*/


trigger BPSolutionsTrigger on BP_Solutions__c (before insert) {
    
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){ 
           
            List<Id> bpIdList = new List<Id>();
            for(BP_Solutions__c bpSol : Trigger.New){
                bpIdList.add(bpSol.Business_Plan__c);
            }
            
            Map<Id, Business_Plan_New__c> bpMap = new Map<Id, Business_Plan_New__c>(
                        [select id,CurrencyIsoCode,Name from Business_Plan_New__c where id IN :bpIdList]);
            
            for(BP_Solutions__c bpSol : Trigger.New){
                bpSol.CurrencyIsoCode = bpMap.get(bpSol.Business_Plan__c).CurrencyIsoCode;   
            } 
            
        }
        
    }
    
}