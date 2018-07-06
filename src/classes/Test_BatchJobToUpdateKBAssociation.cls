@isTest
public class Test_BatchJobToUpdateKBAssociation {
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        Integer limitValue=20; 
        createTestData(listOfRecord);
        String recordtypeid=listOfRecord[0].id;
        BatchJobToUpdateProductAssociationInKB obj = new BatchJobToUpdateProductAssociationInKB(recordtypeid,limitValue);
        database.executeBatch(obj);
        Test.stopTest();
    }

    private static void createTestData(List<RecordType> listOfRecord){       
        
        
        List<XMD_Product__c> ECM_Prod_ID = new List<XMD_Product__c>();
        XMD_Product__c xmdObj1 = new XMD_Product__c();
        xmdObj1.Name='CA PPM';
        ECM_Prod_ID.add(xmdObj1);
        
        XMD_Product__c xmdObj2 = new XMD_Product__c();
        xmdObj2.Name='CA 2E';
        ECM_Prod_ID.add(xmdObj2);
        
        XMD_Product__c xmdObj3 = new XMD_Product__c();
        xmdObj3.Name='CA VISION:Results for z/OS';
        ECM_Prod_ID.add(xmdObj3);
        
        insert ECM_Prod_ID;
        System.debug('ECM_Prod_ID[0] : '+ ECM_Prod_ID[0].id + ' : '+ECM_Prod_ID[1].id+' : '+ECM_Prod_ID[2].id);
        
        List<CA_Product_Controller__c> listOfCA = new List<CA_Product_Controller__c>();
        
        CA_Product_Controller__c caProductObj = new CA_Product_Controller__c();
        caProductObj.name='CLARITY ON PREMISE';
        listOfCA.add(caProductObj);
        
        CA_Product_Controller__c caProductObj1 = new CA_Product_Controller__c();
        caProductObj1.name='CLARITY ON DEMAND';
        listOfCA.add(caProductObj1);
        
        CA_Product_Controller__c caProductObj2 = new CA_Product_Controller__c();
        caProductObj2.name='2E';
        listOfCA.add(caProductObj2);
        
        /*CA_Product_Controller__c caProductObj3 = new CA_Product_Controller__c();
        caProductObj3.name='VISION:RESULTS';
        listOfCA.add(caProductObj3);*/
        
        CA_Product_Controller__c caProductObj3 = new CA_Product_Controller__c();
        caProductObj3.name='VISION:SIXTY';
        listOfCA.add(caProductObj3);
        
        insert listOfCA;
        
        list<Product_Material__c> listOfMaterial = new list<Product_Material__c>();
        Product_Material__c mObj1 = new Product_Material__c();
        mObj1.Active_for_Support__c=true;
        mObj1.CA_Product__c='CLARITY ON DEMAND';
        mObj1.CA_Product_Controller__c=listOfCA[1].id;
        mObj1.Material_Status_Code__c='ZA';   
        listOfMaterial.add(mObj1);
        
        Product_Material__c mObj2 = new Product_Material__c();
        mObj2.Active_for_Support__c=true;
        mObj2.CA_Product__c='2E';
        mObj2.CA_Product_Controller__c=listOfCA[2].id;
        mObj2.Material_Status_Code__c='ZQ';   
        listOfMaterial.add(mObj2);

        Product_Material__c mObj3 = new Product_Material__c();
        mObj3.Active_for_Support__c=true;
        mObj3.CA_Product__c='VISION:SIXTY';
        mObj3.CA_Product_Controller__c=listOfCA[3].id;
        mObj3.Material_Status_Code__c='ZP';   
        listOfMaterial.add(mObj3);
        
        insert listOfMaterial;
        
        List<CA_Product_Component__c> listOfComp = new List<CA_Product_Component__c>();
        
        CA_Product_Component__c prodcomp = new CA_Product_Component__c();
        prodcomp.Name='CLARITY ON PREMISE PPMINV';
        prodcomp.CA_Product_Component_Ext_ID__c='Test';
        prodcomp.Default_Component_for_CA_Product__c=True;
        prodcomp.CA_Product_Controller__c=listOfCA[0].id;
        prodcomp.CA_Product_Text__c='Test';
        prodcomp.Component_Code__c='PPMINV';
        prodcomp.Component_Text__c='Test';
        prodcomp.Default_Component_for_this_CA_Product__c=True;
        prodcomp.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp);
        
        CA_Product_Component__c prodcomp1 = new CA_Product_Component__c();
        prodcomp1.Name='CLARITY ON DEMAND PRVASV';
        prodcomp1.CA_Product_Component_Ext_ID__c='Test';
        prodcomp1.Default_Component_for_CA_Product__c=True;
        prodcomp1.CA_Product_Controller__c=listOfCA[1].id;
        prodcomp1.CA_Product_Text__c='Test';
        prodcomp1.Component_Code__c='PRVASV';
        prodcomp1.Component_Text__c='Test';
        prodcomp1.Default_Component_for_this_CA_Product__c=True;
        prodcomp1.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp1);
        
        CA_Product_Component__c prodcomp2 = new CA_Product_Component__c();
        prodcomp2.Name='2E MFDOC';
        prodcomp2.CA_Product_Component_Ext_ID__c='Test';
        prodcomp2.Default_Component_for_CA_Product__c=True;
        prodcomp2.CA_Product_Controller__c=listOfCA[2].id;
        prodcomp2.CA_Product_Text__c='Test';
        prodcomp2.Component_Code__c='MFDOC';
        prodcomp2.Component_Text__c='MFDOC';
        prodcomp2.Default_Component_for_this_CA_Product__c=false;
        prodcomp2.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp2);
        
        CA_Product_Component__c prodcomp3 = new CA_Product_Component__c();
        prodcomp3.Name='VISION:SIXTY CAIRIM';
        prodcomp3.CA_Product_Component_Ext_ID__c='Test';
        prodcomp3.Default_Component_for_CA_Product__c=True;
        prodcomp3.CA_Product_Controller__c=listOfCA[3].id;
        prodcomp3.CA_Product_Text__c='Test';
        prodcomp3.Component_Code__c='CAIRIM';
        prodcomp3.Component_Text__c='CAIRIM';
        prodcomp3.Default_Component_for_this_CA_Product__c=true;
        prodcomp3.SFDC_Support_System__c=True;
        listOfComp.add(prodcomp3);
        
        insert listOfComp;
        System.debug(' listOfCA[1].id : '+ listOfCA[1].id);
       
        List<Product_Release__c> listOfCARelease = new List<Product_Release__c>();
       /* Product_Release__c rObj1 = new Product_Release__c();
        rObj1.Full_Product_Name__c='Clarity on Demand - code Bundle';
        rObj1.Product__c='CLARITY ON DEMAND';
        rObj1.Product_Release__c='1';
        rObj1.Product_Material__r.CA_Product_Controller__c=listOfCA[1].id;
        listOfCARelease.add(rObj1);*/
        
        Product_Release__c rObj2 = new Product_Release__c();
        rObj2.Full_Product_Name__c='Clarity on Demand - code Bundle';
        rObj2.Product__c='CLARITY ON DEMAND';
        rObj2.Product_Release__c='1.1';
        rObj2.Product_Material__c=listOfMaterial[0].id;
        listOfCARelease.add(rObj2);
        
        Product_Release__c rObj3 = new Product_Release__c();
        rObj3.Full_Product_Name__c='2E - code Bundle';
        rObj3.Product__c='2E';
        rObj3.Product_Release__c='8.1';
        rObj3.Product_Material__c=listOfMaterial[1].id;
        listOfCARelease.add(rObj3);
        
        Product_Release__c rObj5 = new Product_Release__c();
        rObj5.Full_Product_Name__c='2E - code Bundle';
        rObj5.Product__c='2E';
        rObj5.Product_Release__c='8.5';
        rObj5.Product_Material__c=listOfMaterial[0].id;
        listOfCARelease.add(rObj5);
        
        Product_Release__c rObj4 = new Product_Release__c();
        rObj4.Full_Product_Name__c='VISION:SIXTY - code Bundle';
        rObj4.Product__c='VISION:SIXTY';
        rObj4.Product_Release__c='10';
        rObj4.Product_Material__c=listOfMaterial[0].id;
        listOfCARelease.add(rObj4);
        
        insert listOfCARelease;
        
        List<CA_XMD_Product_Mapping__c> caProductIdsList = new List<CA_XMD_Product_Mapping__c>();
        CA_XMD_Product_Mapping__c caxmdMapObj1 = new CA_XMD_Product_Mapping__c();
        caxmdMapObj1.CA_Product__c=listOfCA[0].id;
        caxmdMapObj1.XMD_Product__c=ECM_Prod_ID[0].id;
        caProductIdsList.add(caxmdMapObj1);
        
        CA_XMD_Product_Mapping__c caxmdMapObj2 = new CA_XMD_Product_Mapping__c();
        caxmdMapObj2.CA_Product__c=listOfCA[1].id;
        caxmdMapObj2.XMD_Product__c=ECM_Prod_ID[0].id;
        caProductIdsList.add(caxmdMapObj2);
        
        CA_XMD_Product_Mapping__c caxmdMapObj3 = new CA_XMD_Product_Mapping__c();
        caxmdMapObj3.CA_Product__c=listOfCA[2].id;
        caxmdMapObj3.XMD_Product__c=ECM_Prod_ID[1].id;
        caProductIdsList.add(caxmdMapObj3);
        
        CA_XMD_Product_Mapping__c caxmdMapObj4 = new CA_XMD_Product_Mapping__c();
        caxmdMapObj4.CA_Product__c=listOfCA[3].id;
        caxmdMapObj4.XMD_Product__c=ECM_Prod_ID[2].id;
        caProductIdsList.add(caxmdMapObj4);
        
        insert caProductIdsList;
        
        //List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test batch1';
        knowledgeObj1.UrlName = 'test-batch1';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.ValidationStatus='Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = '';
        knowledgeObj1.Component_Codes__c ='CA 2E:MFDOC';
        knowledgeObj1.Releases__c = 'CA 2E:8.1;8.5';
        knowledgeObj1.Product_Names__c = 'CA 2E';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Published';
        knowledgeObj1.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj1);
        
        
        //List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj2 = new Knowledge__kav();
        knowledgeObj2.Title = 'test batch2';
        knowledgeObj2.UrlName = 'test-batch2';
        knowledgeObj2.Summary = 'testingning11112';
        knowledgeObj2.ValidationStatus='Not Validated';
        knowledgeObj2.IsVisibleInPkb=true;
        knowledgeObj2.RecordTypeId = listOfRecord[0].id;
        knowledgeObj2.Component_Names__c = '';
        knowledgeObj2.Component_Codes__c = 'CA 2E:MFDOC\nCA PPM:PPMINV;PRVASV';
        knowledgeObj2.Releases__c = 'CA 2E:8 \n CA PPM:1.1';
        knowledgeObj2.Product_Names__c = 'CA PPM\n CA 2E';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.migrated_status__c='Published';
        knowledgeObj2.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj2);
        
        Knowledge__kav knowledgeObj3 = new Knowledge__kav();
        knowledgeObj3.Title = 'test batch3';
        knowledgeObj3.UrlName = 'test-batch3';
        knowledgeObj3.Summary = 'testingning11113';
        knowledgeObj3.ValidationStatus='Not Validated';
        knowledgeObj3.IsVisibleInPkb=true;
        knowledgeObj3.RecordTypeId = listOfRecord[0].id;
        knowledgeObj3.Component_Names__c = '';
        knowledgeObj3.Component_Codes__c = 'CA VISION:Results for z/OS:CAIRIM \n CA PPM:PPMINV';
        knowledgeObj3.Releases__c = 'CA VISION:Results for z/OS:10 \n CA PPM:1.1';
        knowledgeObj3.Product_Names__c = 'CA VISION:Results for z/OS \n CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.Legacy_Source__c='ECM';
        knowledgeObj3.migrated_status__c='Published';
        knowledgeObj3.Product_Association_update__c=1;
        listKnowledgeObj.add(knowledgeObj3);
        
        
/*        Knowledge__kav knowledgeObj4 = new Knowledge__kav();
        knowledgeObj4.Title = 'test batch4';
        knowledgeObj4.UrlName = 'test-batch4';
        knowledgeObj4.Summary = 'testingning11114';
        knowledgeObj4.ValidationStatus='Not Validated';
        knowledgeObj4.IsVisibleInPkb=true;
        knowledgeObj4.RecordTypeId = listOfRecord[0].id;
        knowledgeObj4.Component_Names__c = '';
        knowledgeObj4.Component_Codes__c = 'ODINCL;PPMINV;V';
        knowledgeObj4.Releases__c = 'CA VISION:Results for z/OS:Release:6.0;';
        knowledgeObj4.Product_Names__c = 'CA VISION:Results for VSE;CA VISION:Results for z/OS;CA PPM';
        knowledgeObj4.Content1__c='Issue';
        knowledgeObj4.Content2__c ='Resolution';
        knowledgeObj4.Legacy_Source__c='ECM';
        knowledgeObj4.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj4);
        
        
        
        Knowledge__kav knowledgeObj5 = new Knowledge__kav();
        knowledgeObj5.Title = 'test batch5';
        knowledgeObj5.UrlName = 'test-batch5';
        knowledgeObj5.Summary = 'testingning11115';
        knowledgeObj5.ValidationStatus='Validated';
        knowledgeObj5.IsVisibleInPkb=true;
        knowledgeObj5.RecordTypeId = listOfRecord[0].id;
        knowledgeObj5.Component_Names__c = '';
        knowledgeObj5.Component_Codes__c = 'name1:PPMINV;name2:CAIRIM';
        knowledgeObj5.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj5.Product_Names__c = 'CA VISION:Results for z/OS;';
        knowledgeObj5.Content1__c='Issue';
        knowledgeObj5.Content2__c = 'Resolution';
        knowledgeObj5.Legacy_Source__c='ECM';
        knowledgeObj5.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj5);
        
        Knowledge__kav knowledgeObj6 = new Knowledge__kav();
        knowledgeObj6.Title = 'test batch6';
        knowledgeObj6.UrlName = 'test-batch6';
        knowledgeObj6.Summary = 'testingning11116';
        knowledgeObj6.ValidationStatus='Validated';
        knowledgeObj6.IsVisibleInPkb=true;
        knowledgeObj6.RecordTypeId = listOfRecord[0].id;
        knowledgeObj6.Component_Names__c = '';
        knowledgeObj6.Component_Codes__c = 'name1:PPMINV';
        knowledgeObj6.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj6.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj6.Content1__c='Issue';
        knowledgeObj6.Content2__c = 'Resolution';
        knowledgeObj6.Legacy_Source__c='ECM';
        knowledgeObj6.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj6);
        
        Knowledge__kav knowledgeObj7 = new Knowledge__kav();
        knowledgeObj7.Title = 'test batch7';
        knowledgeObj7.UrlName = 'test-batch7';
        knowledgeObj7.Summary = 'testingning11117';
        knowledgeObj7.ValidationStatus='Validated';
        knowledgeObj7.IsVisibleInPkb=true;
        knowledgeObj7.RecordTypeId = listOfRecord[0].id;
        knowledgeObj7.Component_Names__c = '';
        knowledgeObj7.Component_Codes__c = 'ODINCL;PPMINV;V';
        knowledgeObj7.Releases__c = 'CA VISION:Results for z/OS:Release:6.0;CA PPM:Release:8.1;CA PPM:Release:8.0.01;';
        knowledgeObj7.Product_Names__c = 'CA VISION:Results for VSE;CA VISION:Results for z/OS;CA PPM';
        knowledgeObj7.Content1__c='Issue';
        knowledgeObj7.Content2__c ='Resolution';
        knowledgeObj7.Legacy_Source__c='ECM';
        knowledgeObj7.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj7);
        
        Knowledge__kav knowledgeObj8 = new Knowledge__kav();
        knowledgeObj8.Title = 'test batch8';
        knowledgeObj8.UrlName = 'test-batch8';
        knowledgeObj8.Summary = 'testingning11111';
        knowledgeObj8.ValidationStatus='Validated';
        knowledgeObj8.IsVisibleInPkb=true;
        knowledgeObj8.RecordTypeId = listOfRecord[0].id;
        knowledgeObj8.Component_Names__c = '';
        knowledgeObj8.Component_Codes__c = 'PPMENV;PPMINV';
        knowledgeObj8.Releases__c = 'CA PPM:Release:1;CA PPM:Release:1.0;PPM:Release:13.0;';
        knowledgeObj8.Product_Names__c = 'CA PPM';     
        knowledgeObj8.Content1__c='Issue';
        knowledgeObj8.Content2__c = 'Resolution';
        knowledgeObj8.Legacy_Source__c='ECM';
        knowledgeObj8.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj8);
        
        Knowledge__kav knowledgeObj9 = new Knowledge__kav();
        knowledgeObj9.Title = 'test batch9';
        knowledgeObj9.UrlName = 'test-batch9';
        knowledgeObj9.Summary = 'testingning11119';
        knowledgeObj9.ValidationStatus='Validated';
        knowledgeObj9.IsVisibleInPkb=true;
        knowledgeObj9.RecordTypeId = listOfRecord[0].id;
        knowledgeObj9.Component_Names__c = '';
        knowledgeObj9.Component_Codes__c = 'name2:CAIRIM';
        knowledgeObj9.Releases__c = 'CA VISION:Results for z/OS:Release:6.0';
        knowledgeObj9.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj9.Content1__c='Issue';
        knowledgeObj9.Content2__c = 'Resolution';
        knowledgeObj9.Legacy_Source__c='ECM';
        knowledgeObj9.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj9);*/
        
        insert listKnowledgeObj;
              
         
    }
                                             }