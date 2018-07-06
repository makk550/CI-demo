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
trigger sfcpq_sox_PriceAction on SBQQ__PriceAction__c (after insert,after delete) {
    
    List<SFCPQ_SOX_Tracking__c> sfcpqSoxTrackList = new List<SFCPQ_SOX_Tracking__c>();
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            for(SBQQ__PriceAction__c action:trigger.new){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Insert';
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
                
                sfcpqSoxTrackList.add(temp);
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
            
        }
        
        if(Trigger.isDelete){
            
            for(SBQQ__PriceAction__c action:trigger.old){
                
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
                
                sfcpqSoxTrackList.add(temp);
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
            
        }
        
    }
    
}