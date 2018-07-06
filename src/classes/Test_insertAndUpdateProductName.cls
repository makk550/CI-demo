@isTest
public class Test_insertAndUpdateProductName{
    
    private static testMethod void insertAndUpdateProductNameMethod(){
        test.startTest();
        createTestData();
        test.stopTest();
    }
    
    private static void createTestData(){
        List<CA_Product_Controller__c> listOfCA = new List<CA_Product_Controller__c>();
        CA_Product_Controller__c caProductObj1 = new CA_Product_Controller__c();
        caProductObj1.name='CLARITY ON DEMAND';
        listOfCA.add(caProductObj1);
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='CLARITY ON PREMISE';
        listOfCA.add(caProductObj);
        
        CA_Product_Controller__c caProductObj2 = new CA_Product_Controller__c();
        caProductObj2.name='SERVICE DESK MANAGER';
        listOfCA.add(caProductObj2);
        
        CA_Product_Controller__c caProductObj3 = new CA_Product_Controller__c();
        caProductObj3.name='SINGLE SIGN ON';
        listOfCA.add(caProductObj3);
        insert listOfCA;
        
        listOfCA[3].Name = 'SINGLE SIGN ON Test'; //This is to cover createProductNameOnUpdate trigger
        update listOfCA[3];//This is to cover createProductNameOnUpdate trigger
        
        List<CA_Product_Component__c> listOfComp = new List<CA_Product_Component__c>();
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='CLARITY ON DEMAND ODMNTR';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='ODMNTR';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp);
        insert listOfComp;
        
        listOfComp[0].Name = 'CLARITY ON DEMAND ODMNTR TEST'; //This is to cover storeComponentHistory trigger
        update listOfComp[0]; //This is to cover storeComponentHistory trigger
        
        List<Product_Names__c> listOfProductNames = new List<Product_Names__c>();
        Product_Names__c pnObj = new Product_Names__c();
        pnObj.CA_Product_Controller__c = listOfCA[0].Id;
        pnObj.Product_Synonyms__c = 'Test';
        pnObj.Product_Usage__c = 'Documentation';
        listOfProductNames.add(pnObj);
        
        Product_Names__c pnObj1 = new Product_Names__c();
        pnObj1.CA_Product_Controller__c = listOfCA[0].Id;
        pnObj1.Product_Synonyms__c = 'Testing';
        pnObj1.Product_Usage__c = 'Documentation';
        listOfProductNames.add(pnObj1);
        
        insert listOfProductNames;
    }

}