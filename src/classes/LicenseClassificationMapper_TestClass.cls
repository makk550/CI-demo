@isTest
public  class LicenseClassificationMapper_TestClass {
    
     static testMethod void LicenseClassificationMapper_Test()
     {
         
          Opportunity opp;
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        Set<Opportunity> OppSet = oppAndLineItemMap.keySet();
        for(Opportunity tempOpp:Oppset){
            Opp = tempOpp;
        }
        List<OpportunityLineItem> OppItmList = oppAndLineItemMap.get(Opp);
         
          Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c='AB');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200, Stretch__c=1000, License__c='Subscription',Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00,License_Classification_Override__c='UMF');
        
        insert oli;
         
         OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200, Stretch__c=1000, 
                                                            License__c='Upfront',Business_Type__c = 'Capacity',
                                  raw_maintenance__c=1.00);
        
        insert oli1;
		
        system.debug('----size----'+OppItmList.size());
         
         
       //  LicenseClassificationMapper lcm = new LicenseClassificationMapper();
           List<SelectOption> licenseclassify = LicenseClassificationMapper.LicenseClassification();
        List<SelectOption> licenseclassifyoveride = LicenseClassificationMapper.LicenseClassificationOverride();
        oli = LicenseClassificationMapper.LicenseClassifcationset(oli,'Mainframe','');
          oli = LicenseClassificationMapper.LicenseClassifcationset(oli,'MF Capacity','Perpetual');
          oli.License__C ='Ratable';
           oli = LicenseClassificationMapper.LicenseClassifcationset(oli,'MF Capacity','');
         oli1 = LicenseClassificationMapper.LicenseClassifcationset(oli1,'Capacity','');
          oli1.License__C ='SAAS';
           oli1 = LicenseClassificationMapper.LicenseClassifcationset(oli1,'Upgrade','');
           oli1.License__C ='UMF';
           oli1 = LicenseClassificationMapper.LicenseClassifcationset(oli1,'Capacity','');
          oli1.License__C ='Subscription';
           oli1 = LicenseClassificationMapper.LicenseClassifcationset(oli1,'Upgrade','');
       
     }

}