trigger CZQuoteInterfaceTrigger on Input_Quote_Header__c (after update) {
    
    Set<Id> toProcess = new Set<Id>();
    
    
    for (Id headerId : Trigger.newMap.keySet()) {
        if (Trigger.newMap.get(headerId).Status__c == CZQuoteInterfaceConstants.PROCESS_QUOTE_STATUS &&
            Trigger.newMap.get(headerId).Status__c != Trigger.oldMap.get(headerId).Status__c) {
                system.debug('passed');
                toProcess.add(headerId);
        }
    }
    
    if (!toProcess.isEmpty()) {
        System.debug('processing...');
        
        CZQIQuoteProcessor.processQuotes(toProcess);
    }
}