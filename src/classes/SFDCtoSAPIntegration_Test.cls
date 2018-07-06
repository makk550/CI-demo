@isTest
public class SFDCtoSAPIntegration_Test {
    
    
    public static string productTestdata(){
        
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
    
    public static testMethod void SAPintegrationTest(){
    
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
        
        string prodid=SFDCtoSAPIntegration_Test.productTestdata();
        
                
        
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
        quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
       
        
        update quote;
      
        
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New');  
        insert qli1; 
        System.debug('SBQQ__ProductCode__c==='+qli1.SBQQ__ProductCode__c);
      Test.startTest();  
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
      
          String response=SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
          System.debug('response===='+response);
        Test.stopTest();
        
        
        
    }
    
    
    public static testMethod void SAPintegrationTest_sub(){
      
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
                string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
         SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
         quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
        
     
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,CA_License_Type__c='Subscription',
                                                        Business_Type__c = 'New');  
        insert qli1; 
        System.debug('SBQQ__ProductCode__c==='+qli1.SBQQ__ProductCode__c);
       Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
      
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
    
    public static testMethod void SAPintegrationTest_Renewal(){
       
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
                string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Renewal',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
        
        quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');  
        insert qli;
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,CA_License_Type__c='Perpetual',Maintenance_Product__c='Yes',
                                                        Business_Type__c = 'New',SBQQ__RequiredBy__c=qli.id,Instance_Id__c='55786');  
        
                    SBQQ.TriggerControl.disable();

        insert qli1; 
        System.debug('SBQQ__ProductCode__c==='+qli1.SBQQ__ProductCode__c);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
     
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
     public static testMethod void SAPintegrationTest_Amendment(){
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
        string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
         
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Amendment',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
        quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
      /* Payment_Plan__c paymentplan=new Payment_Plan__c(Amount__c=2390.00,Date__c=Date.valueOf(System.now()),Quote__c=quote.id);
        
        insert paymentplan;*/
        
        
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
                                     ProductCode = 'ACEEUE990',
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
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');  
        insert qli;
        /*SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');  
        insert qli1; */
         Test.startTest();

        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
      
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
    
     public static testMethod void SAPintegrationTest_Amendment_maintains(){
       

       testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
                string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Amendment',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
         quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
        
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
                                     ProductCode = 'ACEEUS990',
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
         List<SBQQ__QuoteLine__c> listquoteline=new List<SBQQ__QuoteLine__c>();
         
           SBQQ__QuoteLine__c qlipar = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786'); 
         insert qlipar;
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786',Maintenance_Product__c='Yes',SBQQ__RequiredBy__c=qlipar.id);  
                 listquoteline.add(qli);

        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');  
                         listquoteline.add(qli1);
            SBQQ.TriggerControl.disable();

         insert listquoteline;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
       
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
   
    
     public static testMethod void SAPintegrationTest_Amendment_subscription(){
        
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
        string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
         
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Amendment',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
       quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
      /* Payment_Plan__c paymentplan=new Payment_Plan__c(Amount__c=2390.00,Date__c=Date.valueOf(System.now()),Quote__c=quote.id);
        
        insert paymentplan;*/
        
        
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
                                     ProductCode = 'AGEEUE990',
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
        
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prodId,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='Hosted',CA_License_Type__c='Subscription',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');  
        insert qli;
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='Hosted',CA_License_Type__c='Subscription',
                                                        Business_Type__c = 'New',Instance_Id__c='55786');
                     SBQQ.TriggerControl.disable();

        insert qli1; 
        System.debug('SBQQ__ProductCode__c==='+qli1.SBQQ__ProductCode__c);
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
      
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
    
    
    
    
      public static testMethod void SAPintegrationTest_Renewal_prepuUpgrade(){
        
        testOpportunityTriggersClass.createSBOppWithNoTrigger();
            
          String oppid=[select id from Opportunity limit 1].id;
                string prodid=SFDCtoSAPIntegration_Test.productTestdata();

                
       
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppid,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Renewal',
                                                 SBQQ__Status__c = 'Draft',Deal_Description__c='Test');
        
        insert quote;
        quote.SBQQ__Status__c = 'Quote Validated';
        quote.Quote_Effective_Date__c  = date.today();
        quote.Sales_Attestation_Agreement__c = true;
        quote.SoldTo_BPID__c = '0';
        quote.ShipTo_BPID__c = '0';
        quote.BillTo_BPID__c = '0';
        quote.TechnicalContact_ID__c = '0';
        quote.ShippingContact_ID__c ='0';
        quote.BillingContact_ID__c ='0';
        quote.TechnicalContact_Email__c='abc@xyz.com';
        update quote;
        
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
                                     ProductCode = 'ACEEUE990',
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
         List<SBQQ__QuoteLine__c> listquoteline=new List<SBQQ__QuoteLine__c>();
         
         
        SBQQ__QuoteLine__c qli1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'Renewal',Instance_Id__c='55786');  
          insert qli1;
          
        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id, SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,Hosting_Type__c='On Premise',CA_License_Type__c='Perpetual',
                                                        Business_Type__c = 'Renewal',Instance_Id__c='55786',Maintenance_Product__c='Yes',SBQQ__RequiredBy__c=qli1.id);  
                       SBQQ.TriggerControl.disable();
     
         insert qli;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SFDCtoSAPMockResponse_Test());
        
       
          SFDCtoSAPIntegration.doBasicAuthenticationCalloutWithNameCreaditial(quote.Id);
        Test.stopTest();
        
        
        
    }
    
    
    

}