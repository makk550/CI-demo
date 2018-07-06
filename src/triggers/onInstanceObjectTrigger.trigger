trigger onInstanceObjectTrigger on InstancePDD__c (before update) {
    /*List<Id> idsToQuery = new List<Id>{};
	for(InstancePDD__c a: Trigger.old){
    	idsToQuery.add(a.id);
 	}*/

	//query all child records where parent ids were deleted
	//PDD__c[] objsToDelete = [select id, Name,Is_Deleted__c from PDD__c where Instance__c IN :idsToQuery];
	PDD__c[] objsToDelete = [select id, Name,Is_Deleted__c from PDD__c where Instance__c IN :Trigger.newMap.keySet()];
    List<PDD__c> pddsToUpdate = new List<PDD__c>{};

	//delete objsToDelete;
	for (PDD__c p :objsToDelete)
    {
        p.Is_Deleted__c = true;
        pddsToUpdate.add(p);
    }
    
    update(pddsToUpdate);

}