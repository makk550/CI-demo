/*
 * Test class for sox objects insert and delete operations.
 * sfcpq_sox_PriceAction,sfcpq_sox_PriceCondition,
 * sfcpq_sox_PriceRule,sfcpq_sox_product2,sfcpq_sox_vdp,
 * sfcpq_sox_priceRuleHandler,schedulePriceBookBatchJobs
 * sfcpq_sox_pricebookentry_batch,sfcpq_sox_deleted_pbentry_batch,
 * Updated by - BAJPI01
*/
@isTest
public class TestSoxTriggersAndClasses {

     @isTest
    static void createData(){
        
        testInsertRecordTypeSettingsClass.insertRecordTypeSettingsRecord();
        
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
                                     CA_License_Type__c = 'Subscription',
                                     Pricing_Group__c = 'Saas',
                                     Commissionable_BU__c ='AC',
                                     ProductCode = 'AGELA1990',
                                    SBQQ__Component__c = true);
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product not inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry not inserted');
        
        Volume_Discount_Pricing__c vdp = new Volume_Discount_Pricing__c();
        vdp.Name = 'test vdp record';
        vdp.License_Count_High_Bound__c = 500;
        vdp.License_Count_Low_Bound__c = 1;
        vdp.Term_High_Bound__c = 24;
        vdp.Term_Low_Bound__c = 1;
        vdp.Product__c = prod.id;
        vdp.Volume_Discount_Percent__c = 5;
        vdp.CurrencyISOCode = 'USD';
        insert vdp;
        
        SBQQ__PriceRule__c priceRule = new SBQQ__PriceRule__c();
        priceRule.SBQQ__Product__c = prod.id;
        priceRule.Name = 'test price rule';
        priceRule.SBQQ__ConditionsMet__c = 'All';
        priceRule.SBQQ__TargetObject__c = 'Configurator';
        priceRule.SBQQ__Active__c = true;
        priceRule.SBQQ__EvaluationEvent__c = 'On Calculate';
        insert priceRule;
        
        SBQQ__PriceCondition__c cond = new SBQQ__PriceCondition__c();
        cond.SBQQ__Rule__c = priceRule.Id;
        cond.SBQQ__Field__c = 'SBQQ__Quantity__c';
        cond.SBQQ__FilterType__c = 'Value';
        cond.SBQQ__Operator__c = 'equals';
        cond.SBQQ__Object__c = 'Quote';
        cond.SBQQ__Value__c = '1';
        insert cond;
        
        SBQQ__PriceAction__c action = new SBQQ__PriceAction__c();
        action.SBQQ__TargetObject__c = 'SBQQ__Quote__c';
        action.SBQQ__Field__c = 'Unit Price';
        action.SBQQ__Value__c = '1';
        action.SBQQ__Rule__c = priceRule.Id;
        insert action;
        
    }
    
    static testmethod void PriceRuleHandlerTest(){
        createData();
        
        List<SBQQ__PriceRule__c> rule = [select id from SBQQ__PriceRule__c limit 1];
        if(rule!=null && rule.size()>0)
            delete rule;
    }
    
    static testmethod void DeleteRecordsTest(){
        createData();
        
        List<SBQQ__PriceRule__c> rule = [select id from SBQQ__PriceRule__c limit 1];
        List<SBQQ__PriceAction__c> action = [select id from SBQQ__PriceAction__c limit 1];
        List<SBQQ__PriceCondition__c> cond = [select id from SBQQ__PriceCondition__c limit 1];
        List<Volume_Discount_Pricing__c> vdp = [select id from Volume_Discount_Pricing__c limit 1];
        List<Product2> prod = [select id from Product2 limit 1];
        
        if(action!=null && action.size()>0)
            delete action;
        if(cond!=null && cond.size()>0)
            delete cond;
        if(rule!=null && rule.size()>0)
            delete rule;
        if(vdp!=null && vdp.size()>0)
            delete vdp;
        if(prod!=null && prod.size()>0)
            delete prod;
        
        
    }
    
    static TestMethod void priceBookBatchTest(){
        createData();
        schedulePriceBookBatchJobs pbeScheduler = new schedulePriceBookBatchJobs();
        pbeScheduler.execute(null);
        List<Product2> prod = [select id from Product2 limit 1];
        system.assertNotEquals(0, prod.size(), 'Product found');
        List<PriceBookEntry> pbe = [select Id,isActive,UnitPrice from PriceBookEntry where product2Id=:prod[0].id Limit 1];
        test.startTest();
        if(pbe!=null && pbe.size()>0){
            pbe[0].UnitPrice = 25;
            update pbe;
            sfcpq_sox_pricebookentry_batch pbeScheduler2 = new sfcpq_sox_pricebookentry_batch();
            Database.executeBatch(pbeScheduler2, 1000);
        }
        test.stopTest();
    }
    
    static TestMethod void priceBookBatchTest2(){
        createData();
        List<Product2> prod = [select id from Product2 limit 1];
        system.assertNotEquals(0, prod.size(), 'Product found');
        List<PriceBookEntry> pbe = [select Id,isActive,UnitPrice,createdDate,createdbyId,
                                    lastmodifieddate,lastmodifiedbyId,product2id,
                                    product2.Name from PriceBookEntry where product2Id=:prod[0].id Limit 1];
        if(pbe!=null && pbe.size()>0){
            SOX_PriceBookEntry__c sox = new SOX_PriceBookEntry__c();
            sox.Product_ID__c = pbe[0].product2id;
            sox.PBE_Created_Date__c = system.today();
            sox.PBE_CreatedBy__c = UserInfo.getUserId();
            sox.PBE_Modified_Date__c = system.today();
            sox.PBE_ModifiedBy__c = UserInfo.getUserId();
            sox.PriceBookEntry_ID__c = pbe[0].id;
            sox.Active__c = true;
            sox.List_Price__c = 10;
            sox.Product_Name__c = 'test';
            insert sox;
            
            
            pbe[0].UnitPrice = 25;
            update pbe;
            sfcpq_sox_pricebookentry_batch pbeScheduler2 = new sfcpq_sox_pricebookentry_batch();
            Database.executeBatch(pbeScheduler2, 1000);
        }
    }
    
    
    
    static TestMethod void priceBookBatchTest3(){
        createData();
        List<PriceBookEntry> pbe = [select Id,isActive,UnitPrice,createdDate,createdbyId,
                                    lastmodifieddate,lastmodifiedbyId,product2id,
                                    product2.Name from PriceBookEntry Limit 1];
        List<Product2> prod = [select id from Product2 limit 1];
        if(pbe!=null && pbe.size()>0){
            SOX_PriceBookEntry__c sox = new SOX_PriceBookEntry__c();
            sox.Product_ID__c = pbe[0].product2id;
            sox.PBE_Created_Date__c = pbe[0].createdDate;
            sox.PBE_CreatedBy__c = pbe[0].createdbyId;
            sox.PBE_Modified_Date__c = pbe[0].lastmodifieddate;
            sox.PBE_ModifiedBy__c = pbe[0].lastmodifiedbyId;
            sox.PriceBookEntry_ID__c = pbe[0].id;
            sox.Active__c = true;
            sox.List_Price__c = 10;
            sox.Product_Name__c = 'test';
            insert sox;
            
            delete pbe;
            
            Id pricebookId = Test.getStandardPricebookId();
        
       		PricebookEntry pbeRec = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[0].Id, UnitPrice = 100, IsActive = true);
       		insert pbeRec;
            SOX_PriceBookEntry__c sox2 = new SOX_PriceBookEntry__c();
            sox2.Product_ID__c = pbeRec.product2id;
            sox2.PBE_Created_Date__c = system.today();
            sox2.PBE_CreatedBy__c = UserInfo.getUserId();
            sox2.PBE_Modified_Date__c = system.today();
            sox2.PBE_ModifiedBy__c = UserInfo.getUserId();
            sox2.PriceBookEntry_ID__c = pbeRec.id;
            sox2.Active__c = true;
            sox2.List_Price__c = 10;
            sox2.Product_Name__c = 'test';
            insert sox2;
            
            sfcpq_sox_deleted_pbentry_batch pbeScheduler5 = new sfcpq_sox_deleted_pbentry_batch();
            Database.executeBatch(pbeScheduler5, 1000);
        }
    }

    static TestMethod void priceBookBatchTest4(){
        createData();
        List<PriceBookEntry> pbe = [select Id,isActive,UnitPrice,createdDate,createdbyId,
                                    lastmodifieddate,lastmodifiedbyId,product2id,
                                    product2.Name from PriceBookEntry Limit 1];
        List<Product2> prod = [select id from Product2 limit 1];
        if(pbe!=null && pbe.size()>0){
            SOX_PriceBookEntry__c sox = new SOX_PriceBookEntry__c();
            sox.Product_ID__c = pbe[0].product2id;
            sox.PBE_Created_Date__c = pbe[0].createdDate;
            sox.PBE_CreatedBy__c = pbe[0].createdbyId;
            sox.PBE_Modified_Date__c = pbe[0].lastmodifieddate;
            sox.PBE_ModifiedBy__c = pbe[0].lastmodifiedbyId;
            sox.PriceBookEntry_ID__c = pbe[0].id;
            sox.Active__c = true;
            sox.List_Price__c = 10;
            sox.Product_Name__c = 'test';
            insert sox;
            
            delete pbe;
            
            sfcpq_sox_deleted_pbentry_batch pbeScheduler5 = new sfcpq_sox_deleted_pbentry_batch();
            Database.executeBatch(pbeScheduler5, 1000);
        }
    }

}