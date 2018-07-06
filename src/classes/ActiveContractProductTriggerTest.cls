@isTest(SeeAllData=true)
public class ActiveContractProductTriggerTest {
	static testMethod void TestFlagCanBeQuotedBySterlingAndSFCPQ()
    {
    	List<product2> products = new List<product2>([select id, name, Can_Be_Quoted_By_Sterling_And_SFCPQ__c from product2 where name = 'Agile Central Hosted' or name = 'Flowdock' or name = 'API Management SaaS']);

    	List<Active_contract__c> ac = new List<Active_contract__c>([Select Id from active_contract__c limit 1]);

    	List<Active_Contract_product__c> listToInsert = new List<Active_Contract_product__c>();

    	if (ac.size() > 0)
    	{
    		Active_Contract_product__c acp;
    		
    		acp = new Active_Contract_product__c();
    		acp.active_contract__c = ac[0].id;
    		acp.name = 'Test Agile Central';
    		for (product2 p: products)
    		{
    			if (p.name == 'Agile Central Hosted')
    			{
    				acp.product__c = p.id;
    			}
    		}

    		listToInsert.add(acp);

			acp = new Active_Contract_product__c();
    		acp.active_contract__c = ac[0].id;
    		acp.name = 'Test Flowdock';
    		for (product2 p: products)
    		{
    			if (p.name == 'Flowdock')
    			{
    				acp.product__c = p.id;
    			}
    		}

    		listToInsert.add(acp);

    		acp = new Active_Contract_product__c();
			acp.active_contract__c = ac[0].id;
    		acp.name = 'Test API Management SaaS';
    		for (product2 p: products)
    		{
    			if (p.name == 'API Management SaaS')
    			{
    				acp.product__c = p.id;
    			}
    		}
    		listToInsert.add(acp);
    		
    	}

    	if (listToInsert.size() > 0)
    	{
    		insert listToInsert;
    	}

    	List<Active_Contract_product__c> listToCompare = new List<Active_Contract_product__c>([select id, name, Can_Be_Quoted_By_Sterling_And_SFCPQ__c from Active_Contract_product__c where name in ('Test Agile Central Hosted','Test Flowdock','Test API Management SaaS')]);
    
    	for(Active_Contract_product__c acpToCompare : listToCompare)
    	{	
    		if (acpToCompare.name == 'Test Agile Central Hosted')
    		{
    			system.assertEquals(acpToCompare.Can_Be_Quoted_By_Sterling_And_SFCPQ__c, true);
    		}
    		else if (acpToCompare.name == 'Test Flowdock')
    		{
    			system.assertEquals(acpToCompare.Can_Be_Quoted_By_Sterling_And_SFCPQ__c, true);
    		}
    		else if (acpToCompare.name == 'Test API Management SaaS')
    		{
    			system.assertEquals(acpToCompare.Can_Be_Quoted_By_Sterling_And_SFCPQ__c, false);
    		}
    	}
    }
}