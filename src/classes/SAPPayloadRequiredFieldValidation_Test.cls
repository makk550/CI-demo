@isTest
public class SAPPayloadRequiredFieldValidation_Test {
    
    
   
    
    public static string productTestData(){
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
                                     ProductCode = 'ACNUNL990',
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
                                     CA_License_Type__c = 'Subscription',
                                     Pricing_Group__c = 'Saas',
                                     Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry inserted');
        return prod.id;
        
    }
    
    
    
    
    public static testMethod void testrequiredfieldValidation(){
       

        testOpportunityTriggersClass.createTestData();
            
          String oppid=[select id from Opportunity limit 1].id;
        
        Test.startTest();
        
         SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft');
        
        insert quote;
      
        
        
        SAPPayloadRequiredFieldsValidations.validationProcess(quote.id);
        Test.stopTest();
         
        
    }
    
    public static testMethod void testrequiredfieldValidation1(){

        testOpportunityTriggersClass.createTestData();
            
          String oppid=[select id from Opportunity limit 1].id;
          String prodid=SAPPayloadRequiredFieldValidation_Test.productTestData();

        Test.startTest();
         SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = false,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'draft');
        
        insert quote;
        quote.SBQQ__Status__c='Quote Validate';
        
        update quote;
        
        
        Payment_Plan__c paymentplan=new Payment_Plan__c(Quote__c=quote.id);
        
        insert paymentplan;
        
         SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000);  
        
        insert qli1;
        
      
        SAPPayloadRequiredFieldsValidations.validationProcess(quote.id);
        Test.stopTest();
         
        
    }

}