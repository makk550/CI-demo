trigger TAQOrgAfterInsertAfterUpdate on TAQ_Organization__c (after insert,after update) {

    if(SystemIdUtility.skipTAQ_Organization) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;


        if(trigger.isUpdate){
            List<TAQ_Org_Quota__c> relQuotas = [SELECT Id, Plan_Type__c,TAQ_Organization__c from TAQ_Org_Quota__c where TAQ_Organization__c in: trigger.new];
            Map<Id,List<TAQ_Org_Quota__c>> quotaMap = new Map<Id, List<TAQ_Org_Quota__c>>();
            
            for(TAQ_Org_Quota__c toq: relQuotas){
                if(quotaMap.containskey(toq.TAQ_Organization__c)){
                    quotaMap.get(toq.TAQ_Organization__c).add(toq);
                }
                else{
                   quotaMap.put(toq.TAQ_Organization__c, new List<TAQ_Org_Quota__c>());
                   quotaMap.get(toq.TAQ_Organization__c).add(toq);
                }
            }
            List<TAQ_Org_Quota__c> orgQuotasToBeUpdated = new List<TAQ_Org_Quota__c>();
            for(TAQ_Org_Quota__C toq: relQuotas){
                if(trigger.newMap.containsKey(toq.TAQ_Organization__c) && 
                trigger.oldMap.get(toq.TAQ_Organization__c).Plan_Type__c!=trigger.newMap.get(toq.TAQ_Organization__c).Plan_Type__c ){
                    toq.Plan_Type__c = trigger.newMap.get(toq.TAQ_Organization__c).Plan_Type__c;
                 orgQuotasToBeUpdated.add(toq);
                }
            }
            database.update(orgQuotasToBeUpdated,false);
        }

}