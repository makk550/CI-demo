trigger OneToOneValidate on PDD__c (before insert) {
    Set<id> instIds = new Set<id>();
    Map<id, PDD__c> mapPDD = new Map<id, PDD__c>();
    
    for(PDD__c p : trigger.New){
        system.debug(p.Instance__c);
        instIds.add(p.Instance__c);
    }
    
    List<PDD__c> lstPDD = [Select Id, Instance__c from PDD__c where Instance__c = :instIds];
    if(!lstPDD.isEmpty()){
        for (PDD__c pdd : lstPDD) {
            mapPDD.put(pdd.Instance__c, pdd);
        }
    }
    
    for (PDD__c p : trigger.New){
        if(mapPDD.containsKey(p.Instance__c)){
            p.addError('A PDD record already exists for this installation!');
        }
    }
}