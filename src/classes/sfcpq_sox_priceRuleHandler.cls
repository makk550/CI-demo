/*
 * Test Class - TestSoxTriggersAndClasses
 * Coverage - 100%
*/
public class sfcpq_sox_priceRuleHandler {
    
    public static List<SBQQ__PriceAction__c> actionList = new List<SBQQ__PriceAction__c>();
    public static List<SBQQ__PriceCondition__c> condList = new List<SBQQ__PriceCondition__c>();
    public static List<SFCPQ_SOX_Tracking__c> soxList = new List<SFCPQ_SOX_Tracking__c>();
    
    public static void fetchChildRecords(List<Id> priceRuleIds){
        
        if(priceRuleIds.size()>0){
            actionList = [Select id,Name,SBQQ__Formula__c,SBQQ__Order__c,SBQQ__ParentRuleIsActive__c,
                          SBQQ__Rule__c,SBQQ__RuleLookupObject__c,SBQQ__RuleTargetsCalculator__c,SBQQ__ValueField__c,
                          SBQQ__SourceLookupField__c,SBQQ__SourceVariable__c,SBQQ__Field__c,SBQQ__TargetObject__c,
                          Unique_Id__c,SBQQ__Value__c from SBQQ__PriceAction__c where SBQQ__Rule__c IN:priceRuleIds];
            
            
            condList = [select Id,Name,SBQQ__Field__c,SBQQ__FilterFormula__c,SBQQ__FilterType__c,SBQQ__Value__c,
                        SBQQ__FilterVariable__c,SBQQ__Index__c,SBQQ__Object__c,SBQQ__Operator__c,SBQQ__ParentRuleIsActive__c,
                        SBQQ__Rule__c,SBQQ__RuleTargetsCalculator__c,SBQQ__TestedFormula__c,SBQQ__TestedVariable__c,
                        Unique_Id__c from SBQQ__PriceCondition__c where SBQQ__Rule__c IN:priceRuleIds];
            
        }
        
        if(actionList!=null && actionList.size()>0){
            
            system.debug('----action list----');
            
            for(SBQQ__PriceAction__c action:actionList){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Delete';
                temp.Object_Name__c = 'SBQQ__PriceAction__c';
                temp.Record_ID__c = action.id;
                temp.PriceAction_Name__c = action.Name;
                temp.PriceAction_Formula__c = action.SBQQ__Formula__c;
                temp.PriceAction_Order__c = action.SBQQ__Order__c;
                temp.PriceAction_ParentRuleIsActive__c = action.SBQQ__ParentRuleIsActive__c;
                temp.PriceAction_Rule__c = action.SBQQ__Rule__c;
                temp.PriceAction_RuleLookupObject__c = action.SBQQ__RuleLookupObject__c;
                temp.PriceAction_RuleTargetsCalculator__c = action.SBQQ__RuleTargetsCalculator__c;
                temp.PriceAction_SourceField__c = action.SBQQ__ValueField__c;
                temp.PriceAction_SourceLookupField__c = action.SBQQ__SourceLookupField__c;
                temp.PriceAction_SourceVariable__c = action.SBQQ__SourceVariable__c;
                temp.PriceAction_TargetField__c = action.SBQQ__Field__c;
                temp.PriceAction_TargetObject__c = action.SBQQ__TargetObject__c;
                temp.PriceAction_UniqueId__c = action.Unique_Id__c;
                temp.PriceAction_Value__c = action.SBQQ__Value__c;
                
                soxList.add(temp);
                
            }
            
        }
        
        if(condList!=null && condList.size()>0){
            
            system.debug('----cond list----');
            
            for(SBQQ__PriceCondition__c condition:condList){
                
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
                
                soxList.add(temp);
            }
            
        }
        
        
    }
    
}