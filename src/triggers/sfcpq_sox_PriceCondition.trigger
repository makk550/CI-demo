/*
 * This Trigger should only have After Insert and After Delete,
 * and is only to insert records to the SFCPQ_SOX_Tracking__c Object.
 * No other processing should be done in this trigger. This trigger
 * should not be bypassed or deactivated during dataload. 
 * 
 */ 
/*
 * Test Class - TestSoxTriggersAndClasses
 * Coverage - 100%
*/
trigger sfcpq_sox_PriceCondition on SBQQ__PriceCondition__c (after insert,after delete) {
    
    List<SFCPQ_SOX_Tracking__c> sfcpqSoxTrackList = new List<SFCPQ_SOX_Tracking__c>();
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            for(SBQQ__PriceCondition__c condition:trigger.new){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Insert';
                temp.Object_Name__c = 'SBQQ__PriceCondition__c';
                temp.Record_ID__c = condition.id;
                temp.PriceCondition_Name__c = condition.Name;
                temp.PriceCondition_Field__c = condition.SBQQ__Field__c;
                temp.PriceCondition_FilterFormula__c = condition.SBQQ__FilterFormula__c;
                temp.PriceCondition_FilterType__c = condition.SBQQ__FilterType__c;
                temp.PriceCondition_FilterValue__c = condition.SBQQ__Value__c;
                temp.PriceCondition_FilterVarible__c = condition.SBQQ__FilterVariable__c;
                temp.PriceCondition_Index__c = condition.SBQQ__Index__c;
                temp.PriceCondition_Object__c = condition.SBQQ__Object__c;
                temp.PriceCondition_Operator__c = condition.SBQQ__Operator__c;
                temp.PriceCondition_ParentRuleIsActive__c = condition.SBQQ__ParentRuleIsActive__c;
                temp.PriceCondition_PriceRule__c = condition.SBQQ__Rule__c;
                temp.PriceCondition_RuleTargetsCalculator__c = condition.SBQQ__RuleTargetsCalculator__c;
                temp.PriceCondition_TestedFormula__c = condition.SBQQ__TestedFormula__c;
                temp.PriceCondition_TestedVariable__c = condition.SBQQ__TestedVariable__c;
                temp.PriceRule_UniqueId__c = condition.Unique_Id__c;
                
                sfcpqSoxTrackList.add(temp);
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
        if(Trigger.isDelete){
            
            for(SBQQ__PriceCondition__c condition:trigger.old){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Delete';
                temp.Object_Name__c = 'SBQQ__PriceCondition__c';
                temp.Record_ID__c = condition.id;
                temp.PriceCondition_Name__c = condition.Name;
                temp.PriceCondition_Field__c = condition.SBQQ__Field__c;
                temp.PriceCondition_FilterFormula__c = condition.SBQQ__FilterFormula__c;
                temp.PriceCondition_FilterType__c = condition.SBQQ__FilterType__c;
                temp.PriceCondition_FilterValue__c = condition.SBQQ__Value__c;
                temp.PriceCondition_FilterVarible__c = condition.SBQQ__FilterVariable__c;
                temp.PriceCondition_Index__c = condition.SBQQ__Index__c;
                temp.PriceCondition_Object__c = condition.SBQQ__Object__c;
                temp.PriceCondition_Operator__c = condition.SBQQ__Operator__c;
                temp.PriceCondition_ParentRuleIsActive__c = condition.SBQQ__ParentRuleIsActive__c;
                temp.PriceCondition_PriceRule__c = condition.SBQQ__Rule__c;
                temp.PriceCondition_RuleTargetsCalculator__c = condition.SBQQ__RuleTargetsCalculator__c;
                temp.PriceCondition_TestedFormula__c = condition.SBQQ__TestedFormula__c;
                temp.PriceCondition_TestedVariable__c = condition.SBQQ__TestedVariable__c;
                temp.PriceRule_UniqueId__c = condition.Unique_Id__c;
                
                sfcpqSoxTrackList.add(temp);
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
    }

}