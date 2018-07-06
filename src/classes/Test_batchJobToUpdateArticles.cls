@isTest
public class Test_batchJobToUpdateArticles{
    
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        createTestData();
        batchJobToUpdateArticles obj = new batchJobToUpdateArticles();
        database.executeBatch(obj);
        Test.stopTest();
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
        
        CA_Product_Component__c prodcomp1 = new CA_Product_Component__c();
        prodcomp1.Name='SERVICE DESK MANAGER SMDOC';
        prodcomp1.CA_Product_Component_Ext_ID__c='Test';
        prodcomp1.Default_Component_for_CA_Product__c=True;
        prodcomp1.CA_Product_Controller__c=listOfCA[2].id;
        prodcomp1.CA_Product_Text__c='Test';
        prodcomp1.Component_Code__c='Test';
        prodcomp1.Component_Text__c='SMDOC';
        prodcomp1.Default_Component_for_this_CA_Product__c=True;
        prodcomp1.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp1);
        insert listOfComp;
        
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CLARITY ON DEMAND: CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        listKnowledgeObj.add(knowledgeObj1);
        insert listKnowledgeObj;
        
        List<Product_Component_Name_History__c> listOfHistory = new List<Product_Component_Name_History__c>();
        Product_Component_Name_History__c historyObj = new Product_Component_Name_History__c();
        historyObj.Type__c = 'Product';
        historyObj.Record_ID__c = listOfCA[0].id;
        historyObj.Old_Value__c = '';
        historyObj.New_Value__c= 'Testing';
        historyObj.Job_Date_Time__c = null;
        listOfHistory.add(historyObj);
        
        Product_Component_Name_History__c historyObj2 = new Product_Component_Name_History__c();
        historyObj2.Type__c = 'Product';
        historyObj2.Record_ID__c = listOfCA[0].id;
        historyObj2.Old_Value__c = '';
        historyObj2.New_Value__c= 'Testing 123';
        historyObj2.Job_Date_Time__c = null;
        listOfHistory.add(historyObj2);
        
        Product_Component_Name_History__c historyObj1 = new Product_Component_Name_History__c();
        historyObj1.Type__c = 'Component';
        historyObj1.Record_ID__c = listOfComp[0].Id;
        historyObj1.Old_Value__c = 'CLARITY ON DEMAND ODMNTR';
        historyObj1.New_Value__c= 'CLARITY ON DEMAND ODMNTR TEST';
        historyObj.Job_Date_Time__c = null;
        listOfHistory.add(historyObj1);
        insert listOfHistory;    
    }
}