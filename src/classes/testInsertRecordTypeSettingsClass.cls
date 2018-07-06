/* 
 * NOTE - THIS CLASS IS USED IN A LOT OF OTHER TEST CLASSES. DO NOT COMMENT OUT ANY OPERATIONS WITHOUT
 * LOOKING AT THE DEPENDENCY.
 * 
 */ 
@isTest
public class testInsertRecordTypeSettingsClass {
     public static testMethod void insertRecordTypeSettingsRecord(){

        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName(); 
        system.debug('----'+oppRecType);
        Id sbRecType = oppRecType.get('SB Record Type').getRecordTypeId();
        Id newOpprecType = oppRecType.get('New Opportunity').getRecordTypeId();
        Id preOpprecType = oppRecType.get('Pre Opportunity').getRecordTypeId();
        Id acqRecType = oppRecType.get('Acquisition').getRecordTypeId();
        Id dealRegRecType = oppRecType.get('Deal Registration').getRecordTypeId();
        Id syncRecType = oppRecType.get('Entitlement Sync').getRecordTypeId();
        Id stdPbId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name='CA Product List', isActive=true);
        insert customPB;
        
        List<RecordTypes_Setting__c> listsrecords=new List<RecordTypes_Setting__c>();
       RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Opportunity';
        rec.RecordType_Id__c =String.valueOf(newOpprecType);
        rec.Name = 'New Opportunity';
         listsrecords.add(rec);

        RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c();
        rec2.SObject_Name__c = 'Opportunity';
        rec2.RecordType_Id__c = String.valueOf(sbRecType);
        rec2.Name = 'SB_Record_Type';
         listsrecords.add(rec2);

        RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c();
        rec3.SObject_Name__c = 'Opportunity';
        rec3.RecordType_Id__c = String.valueOf(syncRecType);
        rec3.Name = 'Entitlement_Sync';
         listsrecords.add(rec3);

        
        RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c();
        rec4.SObject_Name__c = 'Opportunity';
        rec4.RecordType_Id__c = String.valueOf(dealRegRecType);
        rec4.Name = 'Deal Registration';
         listsrecords.add(rec4);

        
        RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c();
        rec5.SObject_Name__c = 'Opportunity';
        rec5.RecordType_Id__c = String.valueOf(acqRecType);
        rec5.Name = 'Acquisition';
         listsrecords.add(rec5);

        
        RecordTypes_Setting__c rec6 = new RecordTypes_Setting__c();
        rec6.SObject_Name__c = 'PriceBook';
        rec6.RecordType_Id__c = String.valueOf(stdPbId);
        rec6.Name = 'Standard Price Book';
         listsrecords.add(rec6);

        
        RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c();
        rec7.SObject_Name__c = 'PriceBook';
        rec7.RecordType_Id__c = String.valueOf(customPB.id);
        rec7.Name = 'CA Product List';
        listsrecords.add(rec7);

        RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c();
        rec8.SObject_Name__c = 'Opportunity';
        rec8.RecordType_Id__c = String.valueOf(preOpprecType);
        rec8.Name = 'Pre Opportunity';
        listsrecords.add(rec8);
         
       insert listsrecords;

        
    }

}