/*
 * Test class created by BAJPI01.
 * Creates account, opportunity, pricebook records, product, quote and quote line without
 * the use of seealldata = true.
 * 
 * NOTE - THIS CLASS IS USED IN A LOT OF OTHER TEST CLASSES. DO NOT COMMENT OUT ANY OPERATIONS WITHOUT
 * LOOKING AT THE DEPENDENCY.
 * This will skip account triggers.
 * 
 */ 
@isTest
public class testCreateQuoteAndQuoteLine{
    
    
    public static testMethod void createTestData(){
        
        testOpportunityTriggersClass.createTestData();
        Opportunity opp = [select id from Opportunity limit 1];

        system.assertNotEquals(null, opp.id, 'Opportunity not inserted');
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook inserted');
        Product2 prod = new Product2(Name = 'CA Agile Central Unlimited Edition ELA SAAS',
                                     IsActive = true,Family='Product',
                                     Market_Focus_Area__c='Agile Central',
                                     Solution_Sets__c = 'Agile Central',
                                     CSU1__c = 'Agile Central',
                                     CSU2__c = 'Agile Central',
                                     CSU_Driver__c = 'Agile Central',
                                     Hyperion_Budget_Planning__c = 'Agile Central',
                                     Salesforce_CPQ_Product__c = true,
                                     SBQQ__QuantityEditable__c = true,
                                     SBQQ__DefaultQuantity__c = 1,
                                     SBQQ__DescriptionLocked__c = true,
                                     Material_ID__c = 'AGELA199000',
                                     Material_Status__c = 'GA',
                                     Material_Status_Code__c = 'Z5',
                                     Operational_BU__c = 'AGILE CENTRAL',
                                     Operational_BU_Code__c = '39',
                                     Platform_Category__c = 'SAAS',
                                     Platform_Category_Code__c = '5',
                                     Hosting_Type__c = 'Hosted',
                                     License_Type__c = 'SAAS',
                                     License__c = 'SAAS',
                                     Maintenance_Product__c = 'No',
                                     Source_System__c = 'TOPS',
                                     Auth_Use_Mode__c = 'D',
                                     CA_License_Type__c = 'S',
                                     Pricing_Group__c = 'Saas',
                                     Commissionable_BU__c ='AC',
                                     ProductCode = 'AGELA1990',
                                     Volume_Price_Curve_Quantity_Criteria__c = Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats,
                                    SBQQ__Component__c = true);
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.id,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft');
        quoteList.add(quote);
        
        SBQQ__Quote__c quoteRenewal = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.id,
                                                 SBQQ__Type__c = 'Renewal',
                                                 SBQQ__Status__c = 'Draft');
        quoteList.add(quoteRenewal);
        
        SBQQ__Quote__c quoteAmend = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp.id,
                                                 SBQQ__Type__c = 'Amendment',
                                                 SBQQ__Status__c = 'Draft');
        quoteList.add(quoteAmend);
        
        insert quoteList;
        
        SBQQ__Quote__c q = [select id,SBQQ__Primary__c,Ramp_Indicator__c,SBQQ__StartDate__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opp.id AND SBQQ__Primary__c=true limit 1];
         q.SBQQ__StartDate__c=Date.valueOf('2017-03-11');
         q.Ramp_Indicator__c=true;
        update q;
        System.debug('========q'+q.SBQQ__StartDate__c);
        
        List<SBQQ__QuoteLine__c> quotelineList = new List<SBQQ__QuoteLine__c>();

        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=q.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New',End_Date_Price_Rule__c=Date.valueOf('2017-03-11'));  
        quotelineList.add(qli1);
        
        
          SBQQ__QuoteLine__c qli2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=q.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Maintenance_Product__c='Yes',
                                                        Business_Type__c = 'New',SBQQ__RequiredBy__c=qli1.id,End_Date_Price_Rule__c=Date.valueOf('2017-03-11'));  
            
		quotelineList.add(qli2);
        insert quotelineList;
        system.assertNotEquals(null, qli1.id, 'Quote Line not inserted');
        
    }
    
}