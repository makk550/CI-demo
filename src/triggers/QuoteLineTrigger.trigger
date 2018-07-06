trigger QuoteLineTrigger on SBQQ__QuoteLine__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    // Lines 5-17 check DisableCustomTriggers custom setting
    // Line 19 called QuoteLineTriggerHandler where all logic resides
    
    Boolean disableCustomTriggers = false;
    
    try {
        List<DisableCustomTriggers__c> dCTs = DisableCustomTriggers__c.getall().values();
        if ( dCTs[0].Disable_Custom_Triggers__c )
        {
            disableCustomTriggers = true;
        }
    }
    catch (Exception e) {}    
    
    if (!disableCustomTriggers)
    {
        new QuoteLineTriggerHandler().run();
    }

}