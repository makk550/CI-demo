global class CZQuoteInterfaceBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, Quote_Number__c, Status__c from Input_Quote_Header__c where Status__c = ' + CZQuoteInterfaceConstants.START_STATUS;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('We\'ve received ' + scope.size() + ' records.');
        Set<Id> scopeIds = (new Map<Id,SObject>(scope)).keySet();
        
        CZQuoteInterfaceExecutor executor = new CZQuoteInterfaceExecutor();
        executor.input = scopeIds;
        
        executor.execute();
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}