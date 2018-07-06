trigger invalidateACP on Active_Contract_Product__c (before insert, before update) {
	set<Id> productIds = new set<id>();

    for(Active_Contract_Product__c acp : trigger.new)
    {
        if(acp.name == 'Services')
        acp.Reason_for_invalidation__c = 'Invalid – Professional Services';
        else if(acp.name == 'Training')
        acp.Reason_for_invalidation__c = 'Invalid – Education';

        productIds.add(acp.Product__c);
    }

 	//sunji03 - Tensor H2 US466298 - Tensor H2: ACL/Mods for renewals
	//Get the flag Can_Be_Quoted_By_Sterling_And_SFCPQ__c from parent product, and assign to the same flag on Active Contract Product, which will be used in rollup summary filter in Active Contrat.
	//Only do it before insert, not update. Active Contract Product comes from Informatica feed, user is not supposed to be change product. 
    if (trigger.isinsert)
    {
	      List<product2> products = new List<product2>();
	    if (productIds.size() > 0)
	    {
	    	products = new List<product2>([select id, Can_Be_Quoted_By_Sterling_And_SFCPQ__c from product2 where id in: productIds]);
	    }

	    if (products != null && products.size() > 0)
	    {
		    for(Active_Contract_Product__c acp : trigger.new)
		    {
		    	for(product2 p : products)
		    	{
		    		if (p.id == acp.product__c && acp.Can_Be_Quoted_By_Sterling_And_SFCPQ__c != p.Can_Be_Quoted_By_Sterling_And_SFCPQ__c)
		    		{
		    			acp.Can_Be_Quoted_By_Sterling_And_SFCPQ__c = p.Can_Be_Quoted_By_Sterling_And_SFCPQ__c;
		    		}
		    	}
		    }
		}
	}
}