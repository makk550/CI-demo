/*
* Test class created by BAJPI01.
* Creates account, opportunity without
* the use of seealldata = true.
* It skips account triggers.
* 
* This is to test OpportunityLineItem Triggers
* 
* NOTE - THIS CLASS IS USED IN A LOT OF OTHER TEST CLASSES. DO NOT COMMENT OUT ANY OPERATIONS WITHOUT
* LOOKING AT THE DEPENDENCY.
* 
*/ 

@isTest
public class testOppLineItemTriggerClass {
    
    public static testMethod void testoppLineItemHandler(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        oli = [select id from opportunitylineitem where id=:oli.id limit 1];
        if(oli.id!=null)
            delete oli;
        
        test.startTest();
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Services',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(oli1);
        oliList.add(oli2);
        insert oliList;
        
        test.stopTest();
        
        
        
    }
    
    
    public static testMethod void testoppLineItemwithThreeProds(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        
        
        test.startTest();
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Education',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Services',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(oli1);
        oliList.add(oli2);
        insert oliList;
        
        test.stopTest();
        
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        insert oli3;
        
    }
    
    public static testMethod void testoppLineItemServices(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        
    }
    
    public static testMethod void testoppLineItemSupport(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        
    }
    
    public static testMethod void testoppLineItemEducation(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Education',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        
    }
    
    public static testMethod void testCreateNewOppLineItem(){
        
        testOpportunityTriggersClass.createNewOpportunity();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
       
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
    }
    
    public static testMethod void testMultipleScbuProducts(){
        
        testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        Product2 prod2 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='API Management',Commissionable_BU__c ='API');
        insert prod2;
        system.assertNotEquals(null, prod2.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbe2;
        system.assertNotEquals(null, pbe2.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        
        test.startTest();
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe2.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                           raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(oli);
        oliList.add(oli1);
        
        insert oliList;
        
        
        
    }
    public static testMethod void testUpdateOppFinanceValuation(){
        
        testCreateAcAcpAcli.testACLI();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
       
        Active_Contract_Product__c acp=[select id from Active_Contract_Product__c limit 1];
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          Active_Contract_Product__c=acp.id,raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
    }
    
    
    public static testMethod void testServicesSupportEducation(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod2 = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod2;
        system.assertNotEquals(null, prod2.id, 'Product not inserted');
        

        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbe2;
        system.assertNotEquals(null, pbe2.id, 'PriceBook Entry not inserted');
                
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe2.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli2;
        
        test.startTest();
         Product2 prod3 = new Product2(Name = 'Test Product', IsActive = true,Family='Education',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod3;
        system.assertNotEquals(null, prod3.id, 'Product not inserted');
        

        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id, UnitPrice = 1000, IsActive = true);
        insert pbe3;
        system.assertNotEquals(null, pbe3.id, 'PriceBook Entry not inserted');

        
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe3.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli3;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        
       OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli5;
        
        test.stopTest();
        
    }
    
    
    public static testMethod void testProductServices(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
      public static testMethod void testProductSupport(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
       public static testMethod void testProductEducation(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Education',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
      public static testMethod void testRenewalServices(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
      public static testMethod void testRenewalSupport(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
       public static testMethod void testRenewalEducation(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Education',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
        public static testMethod void testSupportServices(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
      public static testMethod void testEducationSupport(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Education',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');


        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        

        
    }
    
          public static testMethod void testProductRenewalServices(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Services',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');

		OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli2;
        test.startTest();
        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        
		test.stopTest();
        
    }
    
      public static testMethod void testProductRenewalSupport(){
        
          testOpportunityTriggersClass.createTestData();
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook not inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Support',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli;
        
        Product2 prod4 = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod4;
        system.assertNotEquals(null, prod4.id, 'Product not inserted');

        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbe4;
        system.assertNotEquals(null, pbe4.id, 'PriceBook Entry not inserted');

		
		OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'New',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli2;
        test.startTest();
        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe4.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        
        
        insert oli4;
        test.stopTest();

        
    }
    
    
}