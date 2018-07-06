trigger AutomicVersionTrigger on Automic_R_D_Component_Version__c (after insert,before delete) {
    if(trigger.isInsert && trigger.isAfter && !CheckRecursiveTrigger.isInitiatedByJira)
    {
       Automic_VersionTriggerHelper.addVersionToJira(trigger.new);
    }
    if(System.Trigger.IsDelete && !CheckRecursiveTrigger.isInitiatedByJira){
        for (Automic_R_D_Component_Version__c  acv : trigger.old) 
           acv.addError('Error : You cannot delete Component Version from a Problem.');
    }
}