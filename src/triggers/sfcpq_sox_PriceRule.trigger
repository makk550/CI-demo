/*
 * This Trigger should only have After Insert, Before Delete and After Delete,
 * and is only to insert records to the SFCPQ_SOX_Tracking__c Object.
 * No other processing should be done in this trigger. This trigger
 * should not be bypassed or deactivated during dataload. 
 * 
 */
/*
 * Test Class - TestSoxTriggersAndClasses
 * Coverage - 100%
*/
trigger sfcpq_sox_PriceRule on SBQQ__PriceRule__c (before delete,after insert,after delete) {
    
    List<SFCPQ_SOX_Tracking__c> sfcpqSoxTrackList = new List<SFCPQ_SOX_Tracking__c>();
    
    List<Id> priceRuleId = new List<Id>();
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            for(SBQQ__PriceRule__c pr:trigger.old){
                priceRuleId.add(pr.id);
            }
            if(priceRuleId.size()>0)
            	sfcpq_sox_priceRuleHandler.fetchChildRecords(priceRuleId);
        }     
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            for(SBQQ__PriceRule__c pricerule:trigger.new){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Insert';
                temp.Object_Name__c = 'SBQQ__PriceRule__c';
                temp.Record_ID__c = pricerule.id;
                temp.PriceRule_Name__c = pricerule.Name;
                temp.PriceRule_Active__c = pricerule.SBQQ__Active__c;
                temp.PriceRule_Advanced_Condition__c = pricerule.SBQQ__AdvancedCondition__c;
                temp.PriceRule_EvaluationEvent__c = pricerule.SBQQ__EvaluationEvent__c;
                temp.PriceRule_ConditionsMet__c = pricerule.SBQQ__ConditionsMet__c;
                temp.PriceRule_ConfiguratorEvaluationEvent__c = pricerule.SBQQ__ConfiguratorEvaluationEvent__c;
                temp.PriceRule_Description__c = pricerule.Description__c;
                temp.PriceRule_EvaluationOrder__c = pricerule.SBQQ__EvaluationOrder__c;
                temp.PriceRule_EvaluationScope__c = pricerule.SBQQ__TargetObject__c;
                temp.PriceRule_LookupObject__c = pricerule.SBQQ__LookupObject__c;
                temp.PriceRule_TargetFields__c = pricerule.Price_Rule_Target_Fields__c;
                temp.PriceRule_Product__c = pricerule.SBQQ__Product__c;
                temp.PriceRule_UniqueId__c = pricerule.Unique_Id__c;
                
                
                sfcpqSoxTrackList.add(temp);                    
            }
            
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
        if(Trigger.isDelete){
            
            
             for(SBQQ__PriceRule__c pricerule:trigger.old){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Delete';
                temp.Object_Name__c = 'SBQQ__PriceRule__c';
                temp.Record_ID__c = pricerule.id;
                temp.PriceRule_Name__c = pricerule.Name;
                temp.PriceRule_Active__c = pricerule.SBQQ__Active__c;
                temp.PriceRule_Advanced_Condition__c = pricerule.SBQQ__AdvancedCondition__c;
                temp.PriceRule_EvaluationEvent__c = pricerule.SBQQ__EvaluationEvent__c;
                temp.PriceRule_ConditionsMet__c = pricerule.SBQQ__ConditionsMet__c;
                temp.PriceRule_ConfiguratorEvaluationEvent__c = pricerule.SBQQ__ConfiguratorEvaluationEvent__c;
                temp.PriceRule_Description__c = pricerule.Description__c;
                temp.PriceRule_EvaluationOrder__c = pricerule.SBQQ__EvaluationOrder__c;
                temp.PriceRule_EvaluationScope__c = pricerule.SBQQ__TargetObject__c;
                temp.PriceRule_LookupObject__c = pricerule.SBQQ__LookupObject__c;
                temp.PriceRule_TargetFields__c = pricerule.Price_Rule_Target_Fields__c;
                temp.PriceRule_Product__c = pricerule.SBQQ__Product__c;
                temp.PriceRule_UniqueId__c = pricerule.Unique_Id__c;
                
                
                sfcpqSoxTrackList.add(temp);                    
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
            if(sfcpq_sox_priceRuleHandler.soxList!=null && sfcpq_sox_priceRuleHandler.soxList.size()>0){
                insert sfcpq_sox_priceRuleHandler.soxList;
            }
        }
        
        
    }
    
}