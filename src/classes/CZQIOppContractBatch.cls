global class CZQIOppContractBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        DateTime dt = System.Now().addHours(-1);
        
        String query = 'Select Id, Quote_Number__c, Status__c from Input_Quote_Header__c where LastModifiedDate >= ' + dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND Status__c = ' + CZQuoteInterfaceConstants.OPP_CONTRACT_STATUS;
        system.debug(query);
        system.debug(database.query(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('We\'ve received ' + scope.size() + ' records.');
        Set<Id> scopeIds = new Set<Id>();
        scopeIds.addAll((new Map<Id,SObject>(scope)).keySet());
        
    
        CZQIQuoteProcessor.contractOpps(scopeIds);
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}