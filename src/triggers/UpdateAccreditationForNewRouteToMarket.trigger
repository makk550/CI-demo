trigger UpdateAccreditationForNewRouteToMarket on Product_Alignment__c (before insert) { //before update,
	
	set<id> SetRelatedAccount = new set<ID>();
	set<string> SetProductGroup = new set<string>();
	set<string> SetAlignment = new set<String>();
	
	for(Product_Alignment__c AddRelateddAlignment : trigger.new)
	{
		SetRelatedAccount.add(AddRelateddAlignment.Related_Account__c);
		SetProductGroup.add(AddRelateddAlignment.Product_Group__c);
	}
	
	system.debug('SetRelatedAccount'+SetRelatedAccount);
	system.debug('SetProductGroup'+SetProductGroup);
	
	for(Product_Alignment__c LstQueryProdAlin : [SELECT id,Product_Group__c,Related_Account__c,Accreditation_Certification__c 
                                                 FROM Product_Alignment__c 
												 WHERE Related_Account__c IN : SetRelatedAccount 
												 AND Product_Group__c IN : SetProductGroup
												 AND Accreditation_Certification__c = true]){
	
	SetAlignment.add(LstQueryProdAlin.Related_Account__c+'~'+LstQueryProdAlin.Product_Group__c);							   
    }

	system.debug('SetAlignment record:'+SetAlignment);												   
	system.debug('SetAlignment:'+SetAlignment.size());
	
	List<Product_Alignment__c> ProdAlignmentToUpdate = new List<Product_Alignment__c>{};
	for(Product_Alignment__c PA : trigger.new)
	{
		system.debug('PA:'+PA);
		if(SetAlignment.contains(PA.Related_Account__c+'~'+PA.Product_Group__c)){
			system.debug('PA.Accreditation_Certification__c:'+PA.Accreditation_Certification__c);
			PA.Accreditation_Certification__c = true;
			system.debug('PA.Accreditation_Certification__cAfter:'+PA.Accreditation_Certification__c);
		}
		system.debug('ProdAlignmentToUpdate'+ProdAlignmentToUpdate);
	}
	//Update ProdAlignmentToUpdate;		
}