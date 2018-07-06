@isTest
public class Test_BatchJobToUpdateProductInfoInKB {
    private static testMethod void batchJobToUpdateArticlesMethod(){
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        createTestData(listOfRecord);
        String recordtypeid=listOfRecord[0].id;
        BatchJobToUpdateProductInfoInKBLatest obj = new BatchJobToUpdateProductInfoInKBLatest(recordtypeid);
        database.executeBatch(obj);
        Test.stopTest();
    }

    private static void createTestData(List<RecordType> listOfRecord){       
        
        // List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
         
        list<ECM_Multiple_Products_Mapping__c> alternativeProdRel  = new list<ECM_Multiple_Products_Mapping__c>();
        ECM_Multiple_Products_Mapping__c mObj1= new ECM_Multiple_Products_Mapping__c();
        mObj1.ECM_Products__c='CA IT Asset Manager';
        mObj1.ECM_Alternative__c='CA ARGIS';
        alternativeProdRel.add(mObj1);
        
        insert alternativeProdRel;
        
        list<ECM_Product_Default_Code__c> defaultCodeDetails = new List<ECM_Product_Default_Code__c>();
        ECM_Product_Default_Code__c dObj1 = new ECM_Product_Default_Code__c();
        dObj1.ECM_Product_Name__c='CA PPM';
        dObj1.Default_Comp_Code__c='ODEVCL';
        dObj1.Default_Comp_Name__c='CLARITY ON DEMAND INFRASTRUCTURE & MAINTENANCE';
        defaultCodeDetails.add(dObj1);
         
        
        
        ECM_Product_Default_Code__c dObj2 = new ECM_Product_Default_Code__c();
        dObj2.ECM_Product_Name__c='CA ARGIS';
        dObj2.Default_Comp_Code__c='ARGIS';
        dObj2.Default_Comp_Name__c='CA Asset Portfolio Management';
        defaultCodeDetails.add(dObj2);
        
        ECM_Product_Default_Code__c dObj3 = new ECM_Product_Default_Code__c();
        dObj3.ECM_Product_Name__c='CA IT Asset Manager';
        dObj3.Default_Comp_Code__c='ARGIS';
        dObj3.Default_Comp_Name__c='CA Asset Portfolio Management';
        defaultCodeDetails.add(dObj3);
        
        
        ECM_Product_Default_Code__c dObj4 = new ECM_Product_Default_Code__c();
        dObj4.ECM_Product_Name__c='CA VM:Spool';
        dObj4.Default_Comp_Code__c='VML';
        dObj4.Default_Comp_Name__c='CA VM:Spool';
        defaultCodeDetails.add(dObj4);
        
        
        ECM_Product_Default_Code__c dObj5 = new ECM_Product_Default_Code__c();
        dObj5.ECM_Product_Name__c='CA VISION:Results for z/OS';
        dObj5.Default_Comp_Code__c='VRSLT';
        dObj5.Default_Comp_Name__c='CA VISION Results';
        defaultCodeDetails.add(dObj5);
        
        ECM_Product_Default_Code__c dObj6 = new ECM_Product_Default_Code__c();
        dObj6.ECM_Product_Name__c='CA 2E';
        dObj6.Default_Comp_Code__c='C21E';
        dObj6.Default_Comp_Name__c='CA 2E 400 Toolkit';
        defaultCodeDetails.add(dObj6);
        
        insert defaultCodeDetails;
        
        list<CA_KBProductAssociation__c> compDetails= new list<CA_KBProductAssociation__c>();
        CA_KBProductAssociation__c cObj1= new CA_KBProductAssociation__c();
        cObj1.ECM_Product__c='CA PPM';
        cObj1.Component__c='PPMINV';
        cObj1.Component_Name__c='PPM INVESTMENTS, PROJECTS, RESOURCES & NPIO MANAGEMENT';
        compDetails.add(cObj1);
        
        CA_KBProductAssociation__c cObj2= new CA_KBProductAssociation__c();
        cObj2.ECM_Product__c='CA PPM';
        cObj2.Component__c='PRVASV';
        cObj2.Component_Name__c='PERVASIVE FOR CLARITY';
        compDetails.add(cObj2);
        
        CA_KBProductAssociation__c cObj3= new CA_KBProductAssociation__c();
        cObj3.ECM_Product__c='CA 2E';
        cObj3.Component__c='MFDOC';
        cObj3.Component_Name__c='MAINFRAME DOCUMENTATION';
        compDetails.add(cObj3);
        
        CA_KBProductAssociation__c cObj4= new CA_KBProductAssociation__c();
        cObj4.ECM_Product__c='CA 2E';
        cObj4.Component__c='C2PE';
        cObj4.Component_Name__c='CA 2E Performance Expert Option';
        compDetails.add(cObj4);
        
        CA_KBProductAssociation__c cObj5= new CA_KBProductAssociation__c();
        cObj5.ECM_Product__c='CA ARGIS';
        cObj5.Component__c='ARGIS';
        cObj5.Component_Name__c='CA Asset Portfolio Management';
        compDetails.add(cObj5);
        
        CA_KBProductAssociation__c cObj6= new CA_KBProductAssociation__c();
        cObj6.ECM_Product__c='CA ARGIS';
        cObj6.Component__c='BITCM';
        cObj6.Component_Name__c='CA Client Automation';
        compDetails.add(cObj6);
        
        CA_KBProductAssociation__c cObj7= new CA_KBProductAssociation__c();
        cObj7.ECM_Product__c='CA VM:Spool';
        cObj7.Component__c='VMNG';
        cObj7.Component_Name__c='CA VM Product Manager';
        compDetails.add(cObj7);
        
        CA_KBProductAssociation__c cObj8= new CA_KBProductAssociation__c();
        cObj8.ECM_Product__c='CA VM:Spool';
        cObj8.Component__c='MFDOC';
        cObj8.Component_Name__c='MAINFRAME DOCUMENTATION';
        compDetails.add(cObj8);
        
        CA_KBProductAssociation__c cObj9= new CA_KBProductAssociation__c();
        cObj9.ECM_Product__c='CA VISION:Results for z/OS';
        cObj9.Component__c='CAIRIM';
        cObj9.Component_Name__c='CA Resource Initialization Manager(Comm)';
        compDetails.add(cObj9);
        
        CA_KBProductAssociation__c cObj10= new CA_KBProductAssociation__c();
        cObj10.ECM_Product__c='CA VISION:Results for z/OS';
        cObj10.Component__c='CCS390';
        cObj10.Component_Name__c='CCS390 - CA COMMON SERVICES FOR Z/OS';
        compDetails.add(cObj10);
        
        insert compDetails;
        
        list<CA_Release_Mapping__c> releaseDetails= new list<CA_Release_Mapping__c>();
        
        CA_Release_Mapping__c rObj1 = new CA_Release_Mapping__c();
        rObj1.ECM_Product__c='CA PPM';
        rObj1.Release__c='1';
        releaseDetails.add(rObj1);
        
        CA_Release_Mapping__c rObj2 = new CA_Release_Mapping__c();
        rObj2.ECM_Product__c='CA PPM';
        rObj2.Release__c='1.1';
        releaseDetails.add(rObj2);
        
        CA_Release_Mapping__c rObj3 = new CA_Release_Mapping__c();
        rObj3.ECM_Product__c='CA 2E';
        rObj3.Release__c='8.1';
        releaseDetails.add(rObj3);
        
        CA_Release_Mapping__c rObj4 = new CA_Release_Mapping__c();
        rObj4.ECM_Product__c='CA 2E';
        rObj4.Release__c='8.5';
        releaseDetails.add(rObj4);
        
        CA_Release_Mapping__c rObj5 = new CA_Release_Mapping__c();
        rObj5.ECM_Product__c='CA ARGIS';
        rObj5.Release__c='4';
        releaseDetails.add(rObj5);
        
        CA_Release_Mapping__c rObj6 = new CA_Release_Mapping__c();
        rObj6.ECM_Product__c='CA ARGIS';
        rObj6.Release__c='4.1';
        releaseDetails.add(rObj6);
        
        CA_Release_Mapping__c rObj7 = new CA_Release_Mapping__c();
        rObj7.ECM_Product__c='CA VM:Spool';
        rObj7.Release__c='1.6';
        releaseDetails.add(rObj7);
        
        CA_Release_Mapping__c rObj8 = new CA_Release_Mapping__c();
        rObj8.ECM_Product__c='CA VISION:Results for z/OS';
        rObj8.Release__c='10';
        releaseDetails.add(rObj8);
            
        List<Knowledge__kav> listKnowledgeObj = new List<Knowledge__kav>();
        Knowledge__kav knowledgeObj1 = new Knowledge__kav();
        knowledgeObj1.Title = 'test batch1';
        knowledgeObj1.UrlName = 'test-batch1';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.ValidationStatus='Validated';
        knowledgeObj1.IsVisibleInPkb=true;
        knowledgeObj1.RecordTypeId = listOfRecord[0].id;
        knowledgeObj1.Component_Names__c = '';
        knowledgeObj1.Component_Codes__c ='MFDOC;C2EJB;';
        knowledgeObj1.Releases__c = 'CA 2E:Release:8.1;CA 2E:Release:8.5;CA 2E:Release:13.0;';
        knowledgeObj1.Product_Names__c = 'CA 2E';     
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.Legacy_Source__c='ECM';
        knowledgeObj1.migrated_status__c='Published';
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
        knowledgeObj2.Component_Codes__c = 'ARGIS;ARGWEB;CAIRIM';
        knowledgeObj2.Releases__c = 'CA IT Asset Manager:Release:4;';
        knowledgeObj2.Product_Names__c = 'CA IT Asset Manager;CA ARGIS;CA VISION:Results for z/OS;';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.Legacy_Source__c='ECM';
        knowledgeObj2.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj2);
        
        Knowledge__kav knowledgeObj3 = new Knowledge__kav();
        knowledgeObj3.Title = 'test batch3';
        knowledgeObj3.UrlName = 'test-batch3';
        knowledgeObj3.Summary = 'testingning11113';
        knowledgeObj3.ValidationStatus='Not Validated';
        knowledgeObj3.IsVisibleInPkb=true;
        knowledgeObj3.RecordTypeId = listOfRecord[0].id;
        knowledgeObj3.Component_Names__c = '';
        knowledgeObj3.Component_Codes__c = 'CAIRIM';
        knowledgeObj3.Releases__c = 'CA VISION:Results for z/OS:Release:10';
        knowledgeObj3.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.Legacy_Source__c='ECM';
        knowledgeObj3.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj3);
        
        
        Knowledge__kav knowledgeObj4 = new Knowledge__kav();
        knowledgeObj4.Title = 'test batch4';
        knowledgeObj4.UrlName = 'test-batch4';
        knowledgeObj4.Summary = 'testingning11114';
        knowledgeObj4.ValidationStatus='Not Validated';
        knowledgeObj4.IsVisibleInPkb=true;
        knowledgeObj4.RecordTypeId = listOfRecord[0].id;
        knowledgeObj4.Component_Names__c = '';
        knowledgeObj4.Component_Codes__c = 'ODINCL;PPMINV;VML';
        knowledgeObj4.Releases__c = 'CA VISION:Results for z/OS:Release:10;';
        knowledgeObj4.Product_Names__c = 'CA VM:Spool;CA VISION:Results for z/OS;CA PPM';
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
        knowledgeObj5.Releases__c = 'CA VISION:Results for z/OS:Release:10';
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
        knowledgeObj6.Releases__c = 'CA VISION:Results for z/OS:Release:10';
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
        knowledgeObj7.Component_Codes__c = 'ODINCL;PPMINV;PRVASV;CAIRIM';
        knowledgeObj7.Releases__c = 'CA VM:Spool:1.6;CA VISION:Results for z/OS:Release:10;Release:1;CA PPM:Release:1.1;';
        knowledgeObj7.Product_Names__c = 'CA VM:Spool;CA VISION:Results for z/OS;CA PPM';
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
        knowledgeObj9.Releases__c = 'CA VISION:Results for z/OS:Release:10';
        knowledgeObj9.Product_Names__c = 'CA VISION:Results for z/OS';
        knowledgeObj9.Content1__c='Issue';
        knowledgeObj9.Content2__c = 'Resolution';
        knowledgeObj9.Legacy_Source__c='ECM';
        knowledgeObj9.migrated_status__c='Published';
        listKnowledgeObj.add(knowledgeObj9);
        
        insert listKnowledgeObj;
              
         
    }
                                             }