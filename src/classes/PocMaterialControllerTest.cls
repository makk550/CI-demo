@isTest
private class PocMaterialControllerTest {
    
    // CTOR Tests
    // scenario 1 - POC Request on Opportunity with 0 line items and 0 poc materials
    @isTest
    static void init_with_0_opp_line_items(){
        // Given
        Trial_Request__c trial = createTrialRequest();
        PocMaterialController controller = new PocMaterialController();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        // When
        controller.init();
        
        // Then
        System.assertEquals(false, controller.ifNoError);
        assertContainsMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Products added to the opportunity'));
    }
    
    // scenario 2 - POC Request on Opportunity with 1 line items and with 0 POC Materials
    //  2.a OLI product has product material that is poc eligible
    @isTest
    static void init_when_there_are_poc_eligible_product_materials(){
        // Given
        Trial_Request__c trial = createTrialRequest();
        Product2 product = createProduct();
        Product_Material__c productMaterial = createSapProductMaterial(product, true);
        PriceBookEntry pbe = createPricebookEntry(product.Id);
        insert buildOppLineItem(trial.Opp_Name__c, pbe.Id);
        PocMaterialController controller = new PocMaterialController();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        // When
        controller.init();
        
        // Then
        System.assertEquals(true, controller.ifNoError);
        
        // assert ckProductList
        System.assertEquals(product.Id, controller.ckProductList[0].product.Id);
        System.assertEquals(product.Name, controller.ckProductList[0].product.Name);
        System.assertEquals(productMaterial.Id, controller.ckProductList[0].pms[0].materialId);
        System.assertEquals(productMaterial.Material_Text__c, controller.ckProductList[0].pms[0].materialName);
        System.assertEquals(productMaterial.SAP_Product_Mapping__c, controller.ckProductList[0].pms[0].saptopsid);
        System.assertEquals(false, controller.ckProductList[0].pms[0].selected);
        // System.assertEquals(1, controller.ckProductList[0].pms[0].qty);
        
    }
    /*
//  2.b OLI product has product material that is not poc eligible
@isTest
static void init_when_there_are_no_poc_eligible_product_materials(){
// Given
Trial_Request__c trial = createTrialRequest();

Product2 product = createProduct();
createSapProductMaterial(product, false);
PriceBookEntry pbe = createPricebookEntry(product.Id);
insert buildOppLineItem(trial.Opp_Name__c, pbe.Id);
PocMaterialController controller = new PocMaterialController();
controller.poc = trial;
controller.poc.Request_Status__c = 'New';
controller.showallscbu =false;
controller.showallrt =false;

// When
controller.init();

// Then
System.assertEquals(false, controller.ifNoError);
assertContainsMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Product not marked POC eligible in SFDC, please contact GlobalPOCTeam@ca.com'));
}

//  2.c OLI product has no product material
@isTest
static void init_when_there_are_no_product_materials(){
// Given
Trial_Request__c trial = createTrialRequest();
Product2 product = createProduct();
PriceBookEntry pbe = createPricebookEntry(product.Id);
insert buildOppLineItem(trial.Opp_Name__c, pbe.Id);
PocMaterialController controller = new PocMaterialController();
controller.poc = trial;
controller.poc.Request_Status__c = 'New';
controller.showallscbu =false;
controller.showallrt =false;
// When
controller.init();

// Then
System.assertEquals(false, controller.ifNoError);
assertContainsMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Product not marked POC eligible in SFDC, please contact GlobalPOCTeam@ca.com'));
System.assertEquals(false , controller.isViewMode);

}

// scenario 3 - POC Request on Opportunity with 1 line items and with 1 POC Material
@isTest
static void init_when_there_is_one_poc_material() {
// Given
Trial_Request__c trial = createTrialRequest();
Product2 product = createProduct();
Product_Material__c productMaterial = createSapProductMaterial(product, true);
PriceBookEntry pbe = createPricebookEntry(product.Id);
insert buildOppLineItem(trial.Opp_Name__c, pbe.Id);
createPocMaterial(trial, productMaterial);
PocMaterialController controller = new PocMaterialController();
controller.poc = trial;
controller.showallscbu =true;
controller.showallrt =true;
// When
controller.init();

// Then
System.assertEquals(true , controller.isViewMode);

// assert ckProductList
System.assertEquals(product.Id, controller.ckProductList[0].product.Id);
System.assertEquals(productMaterial.Id, controller.ckProductList[0].pms[0].materialId);
System.assertEquals(true, controller.ckProductList[0].pms[0].selected);
// System.assertEquals(2, controller.ckProductList[0].pms[0].qty);

// assert currentPocProductMaterials
System.assertEquals(1, controller.currentPocProductMaterials.size());
System.assertEquals(product.Id, controller.currentPocProductMaterials[0].product.Id);
System.assertEquals(productMaterial.Id, controller.currentPocProductMaterials[0].pms[0].materialId);
}
*/
    // scenario 4 - POC Request on Opportunity with 50 line items - should not throw exception
    @isTest
    static void init_with_200_opp_line_items(){
        // Given
        Trial_Request__c trial = createTrialRequest();
        PocMaterialController controller = new PocMaterialController();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        Product2 product = createProduct();
        Product_Material__c productMaterial = createSapProductMaterial(product, true);
        PriceBookEntry pbe = createPricebookEntry(product.Id);
        OpportunityLineItem[] olis = new OpportunityLineItem[]{};
            for (Integer idx = 0; idx < 200; idx++) {
                olis.add(buildOppLineItem(trial.Opp_Name__c, pbe.Id));
            }
        insert olis;
        
        // When
        Exception caught;
        try {
            controller.init();
        } catch (Exception ex) {
            caught = ex;
        }
        
        // Then - no exception thrown
        System.assertEquals(null, caught);
    }
    
    // saveMaterialSelection tests
    @isTest
    static void saveMaterialSelection_should_save_selected_product_materials(){
        // Given
        PocMaterialController controller = new PocMaterialController();
        Trial_Request__c trial = createTrialRequest();
        
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        Product2 product = createProduct();
        Product_Material__c productMaterial = createSapProductMaterial(product, true);
        pocMaterial__c existingPocMaterial = createPocMaterial(trial, productMaterial);
        
        PocMaterialController.ckProduct ckProductToSave = new PocMaterialController.ckProduct();
        ckProductToSave.product = product;
        PocMaterialController.ckProductMaterial pm = new PocMaterialController.ckProductMaterial();
        pm.selected = true;
        //  pm.qty = 10;
        pm.materialId = productMaterial.Id;
        ckProductToSave.pms.add(pm);
        controller.ckProductList.add(ckProductToSave);
        
        // When
        controller.saveMaterialSelection();
        
        // Then
        
        
        
        trial.Request_Status__c = 'Extension for Approval';
        //trial.OwnerId=;
        // trial.Contact__c=c.id;
        update trial;
        System.assertEquals(true, controller.isViewMode);
        pocMaterial__c[] pocMaterialResults = [SELECT Product__c, quantity__c, Product_Material__c, POC_Request__c FROM pocMaterial__c WHERE POC_Request__c = :trial.id];
        System.assertEquals(1, pocMaterialResults.size());
        System.assertEquals(product.Id, pocMaterialResults[0].Product__c);
        System.assertEquals(10, pocMaterialResults[0].quantity__c);
        System.assertEquals(productMaterial.Id, pocMaterialResults[0].Product_Material__c);
        System.assertEquals(trial.Id, pocMaterialResults[0].POC_Request__c);
        
        Trial_Request__c trResult = [SELECT Request_Status__c,MaterialCount__c,OwnerId,Products_Added__c FROM Trial_Request__c WHERE ID = :trial.Id];
        trResult.Request_Status__c = 'On Hold';
        
        update trResult;
        System.assertEquals(1, trResult.Products_Added__c);
        
    }
    
    @isTest
    static void saveMaterialSelection_should_remove_current_materials_if_no_materials_are_selected(){
        Trial_Request__c trial = createTrialRequest();
        PocMaterialController controller = new PocMaterialController();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        // When
        controller.saveMaterialSelection();
        
        // Then
        System.assertEquals(true, controller.ifNoError);
        assertContainsMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Materials selected to save.'));
        
    }
    
    // editMaterialSelection tests
    @isTest
    static void editMaterialSelection_should_set_isViewMode_to_false(){
        PocMaterialController controller = new PocMaterialController();
        // Given
        Trial_Request__c trial = createTrialRequest();
        Product2 product = createProduct();
        PriceBookEntry pbe = createPricebookEntry(product.Id);
        insert buildOppLineItem(trial.Opp_Name__c, pbe.Id);
        controller.poc = trial;
        controller.poc.Request_Status__c = 'Request for Approval';
        controller.isViewMode = true;
        controller.showallscbu =true;
        controller.showallrt =true;
        // When
        controller.editMaterialSelection();
        
        // Then
        System.assertEquals(false , controller.isViewMode);
    }
    
    // cancel tests
    @isTest
    static void cancel_should_set_isViewMode_to_true(){
        PocMaterialController controller = new PocMaterialController();
        controller.isViewMode = false;
        controller.showallscbu =true;
        controller.showallrt =true;
        // When
        controller.cancel();
        
        // Then
        System.assertEquals(true , controller.isViewMode);
    }
    
    @isTest
    static void buildProductMap_should_return_a_map_of_product2(){
        PocMaterialController controller = new PocMaterialController();
        Trial_Request__c trial = createTrialRequest();
        controller.poc = trial;
        Product2 product = createProduct();
        Set<Id> productIdSet = new Set<Id>();
        productIdSet.add(product.Id);
        
        // When
        Map<Id, Product2> productMap = controller.buildProductMap(productIdSet);
        
        // Then
        System.assertEquals(1 , productMap.size());
    }
    
    @isTest
    static void buildMaterialMap_should_return_a_map_of_material(){
        PocMaterialController controller = new PocMaterialController();
        Trial_Request__c trial = createTrialRequest();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        Product2 product = createProduct();
        Set<Id> productIdSet = new Set<Id>();
        productIdSet.add(product.Id);
        Product_material__c product1 = createSapProductMaterial(product, true);
        Product_material__c product2 = createSapProductMaterial(product, true);
        Product_material__c product3 = createSapProductMaterial(product, false);
        
        // When
        Map<Id, List<Product_Material__c>> materialMap = controller.buildMaterialMap(productIdSet);
        List<Product_Material__c> materialList = materialMap.get(product.Id);
        
        // Then
        System.assertEquals(2, materialMap.get(product.Id).size());
        for(Product_Material__c material : materialList){
            System.assertNotEquals(product3.Id , material.Product__r.Id);
        }
    }
    
    @isTest
    static void buildMaterialMap_should_return_an_empty_list_if_no_materials_found(){
        PocMaterialController controller = new PocMaterialController();
        Trial_Request__c trial = createTrialRequest();
        controller.poc = trial;
        controller.showallscbu =true;
        controller.showallrt =true;
        Product2 product = createProduct();
        Set<Id> productIdSet = new Set<Id>();
        productIdSet.add(product.Id);
        
        // When
        Map<Id, List<Product_Material__c>> materialMap = controller.buildMaterialMap(productIdSet);
        List<Product_Material__c> materialList = materialMap.get(product.Id);
        
        // Then
        System.assertEquals(0, materialMap.get(product.Id).size());
    }
    
    
    // test helpers
    static Trial_Request__c createTrialRequest(){
        Account createacc = CC_TestUtils.buildAccount('This test account');
        insert createacc;
        
        SystemIdUtility.skipOpportunityTriggers = true;
        Opportunity opp = new Opportunity(
            Name = 'test opp', 
            StageName = '10% - Discovery & Assessment', 
            AccountId = createacc.Id, 
            CloseDate = date.today()
        );
        insert opp;
        
        Trial_Request__c trial =  new Trial_Request__c(
            Request_Status__c = 'New',
            Account_Name__c = createacc.Id,
            Opp_Name__c = opp.Id,
            OwnerId=UserInfo.getUserId()
        );
        insert trial;
        return trial;
    }
    
    static pocMaterial__c createPocMaterial(Trial_Request__c trial, Product_Material__c productMaterial) {
        pocMaterial__c pocMaterial = new pocMaterial__c(
            quantity__c = 2,
            POC_Request__c = trial.Id,
            Product__c = productMaterial.Product__c,
            Product_Material__c = productMaterial.Id
        );
        insert pocMaterial;
        return pocMaterial;
    }
    
    static Product2 createProduct(){
        Product2 product= new Product2(Name='Prd1',SKU__c = 'CAAAVM1600W00C6', Family='Product',Market_Focus_Area__c='Test1',IsActive=true);
        insert product;
        return product;
    }
    
    static PricebookEntry createPricebookEntry(Id productId) {
        PriceBookEntry pbe = new PriceBookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = 222,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
    
    static OpportunityLineItem buildOppLineItem(Id oppId, Id pbeId) {
        OpportunityLineItem lineItem = new OpportunityLineItem(
            OpportunityId = oppId,
            PriceBookEntryId = pbeId
            //Quantity = 1
        );
        return lineItem;
    }
    
    static Product_Material__c createSapProductMaterial(Product2 product, Boolean pocEligible){
        Product_Material__c productMaterial = new Product_Material__c(
            Name='p123', 
            Product__c=product.Id, 
            Material_Text__c='test material text',
            SAP_Product_Mapping__c = 'product mapping',
            Source_System__c = 'SAP',
            POC_Eligible__c = pocEligible
        );
        insert productMaterial;
        return productMaterial;
    }
    
    static void assertContainsMessage(ApexPages.Message message) {
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getSeverity() == message.getSeverity() && msg.getDetail() == message.getDetail()) {
                b = true;
            }
        }
        system.assert(b, msgs);
    }
    
}