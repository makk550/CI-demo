/*
 * Test class for triggers - accountPushToMDM
 * and trigger - accountDeleteToMDM. Coverage>75%.
 * Created by BAJPI01.
*/
@isTest
public class accountPushandDeletetoMDMTestClass {
    
     static testmethod void AccountChangesPushToMDM_Test() {
        
        TestSLOMilestonesDataSetup.createTestDataforMilestones();
        List<RecordTypes_Setting__c> listOfRecordType = new List<RecordTypes_Setting__c>();
        RecordTypes_Setting__c recordTypeObj = new RecordTypes_Setting__c();
        recordTypeObj.Name = 'SMB';
        recordTypeObj.SObject_Name__c = 'Account';
        recordTypeObj.RecordType_Id__c = '01230000001L55j';
        listOfRecordType.add(recordTypeObj);
        
        RecordTypes_Setting__c recordTypeObj1 = new RecordTypes_Setting__c();
        recordTypeObj1.Name = 'Territory Covered Account';
        recordTypeObj1.SObject_Name__c = 'Account';
        recordTypeObj1.RecordType_Id__c = '01230000001L55o';
        listOfRecordType.add(recordTypeObj1);
        
        RecordTypes_Setting__c recordTypeObj2 = new RecordTypes_Setting__c();
        recordTypeObj2.Name = 'Account Team Covered Account';
        recordTypeObj2.SObject_Name__c = 'Account';
        recordTypeObj2.RecordType_Id__c = '01230000001L55e';
        listOfRecordType.add(recordTypeObj2);
        
        RecordTypes_Setting__c recordTypeObj3 = new RecordTypes_Setting__c();
        recordTypeObj3.Name = 'Commercial Account';
        recordTypeObj3.SObject_Name__c = 'Account';
        recordTypeObj3.RecordType_Id__c = '01230000000GaFY';
        listOfRecordType.add(recordTypeObj3);
        
        RecordTypes_Setting__c recordTypeObj4 = new RecordTypes_Setting__c();
        recordTypeObj4.Name = 'CA Enterprise Account';
        recordTypeObj4.SObject_Name__c = 'Account';
        recordTypeObj4.RecordType_Id__c = '01230000000DNfM';
        listOfRecordType.add(recordTypeObj4);
        
        RecordTypes_Setting__c recordTypeObj5 = new RecordTypes_Setting__c();
        recordTypeObj5.Name = 'Support Account';
        recordTypeObj5.SObject_Name__c = 'Account';
        recordTypeObj5.RecordType_Id__c = '012a00000018GH7';
        listOfRecordType.add(recordTypeObj5);
        
        RecordTypes_Setting__c recordTypeObj6 = new RecordTypes_Setting__c();
        recordTypeObj6.Name = 'Acquisition';
        recordTypeObj6.SObject_Name__c = 'Account';
        recordTypeObj6.RecordType_Id__c = '012300000013vtw';
        listOfRecordType.add(recordTypeObj6);
        
        RecordTypes_Setting__c recordTypeObj7 = new RecordTypes_Setting__c();
        recordTypeObj7.Name = 'Approved Quote';
        recordTypeObj7.SObject_Name__c = 'Account';
        recordTypeObj7.RecordType_Id__c = '012a0000001VvqT';
        listOfRecordType.add(recordTypeObj7);
        
        RecordTypes_Setting__c recordTypeObj8 = new RecordTypes_Setting__c();
        recordTypeObj8.Name = 'CA Global Lead';
        recordTypeObj8.SObject_Name__c = 'Account';
        recordTypeObj8.RecordType_Id__c = '01230000000DUOh';
        listOfRecordType.add(recordTypeObj8);
        
        RecordTypes_Setting__c recordTypeObj9 = new RecordTypes_Setting__c();
        recordTypeObj9.Name = 'CA Indirect Lead';
        recordTypeObj9.SObject_Name__c = 'Account';
        recordTypeObj9.RecordType_Id__c = '01230000000Dhu2';
        listOfRecordType.add(recordTypeObj9);
        
        RecordTypes_Setting__c recordTypeObj10 = new RecordTypes_Setting__c();
        recordTypeObj10.Name = 'Deal Registration';
        recordTypeObj10.SObject_Name__c = 'Account';
        recordTypeObj10.RecordType_Id__c = '01230000000yspg';
        listOfRecordType.add(recordTypeObj10);
        
        RecordTypes_Setting__c recordTypeObj11 = new RecordTypes_Setting__c();
        recordTypeObj11.Name = 'Reseller/Distributor Account';
        recordTypeObj11.SObject_Name__c = 'Account';
        recordTypeObj11.RecordType_Id__c = '01230000000GaFd';
        listOfRecordType.add(recordTypeObj11);
       
        insert listOfRecordType;
        
        
        
        RecordType[] recacc = [select Id from Recordtype where IsActive = true and SObjectType = 'Account'
                               and Name in ('Account Team Covered Account')
                              ];
        Account oldAcct = new Account(Name = 'TestAcc1', RecordTypeId = recacc[0].Id, Enterprise_Id__c = 'ZZ00005', Enterprise_Account_Name__c = 'Test Acct Name',
                                      GU_DUNS_NUMBER__c = '12345678', GU_NAME__c = 'Test GU Name', GEO__c = 'EMEA',Alliance_Type__c='OEM',Alliance_Designation__c='Federal Systems Integrator',
                                      Sales_Area__c = 'E-EMEA', Sales_Region__c = 'CA SA', Country_ISO_code__c = 'AO', Account_Type1__c = 'Enterprise Account',
                                      Account_Type__c = 'SLED', Sales_Volume__c = 12.0, NumberOfEmployees = 200, Sic = 'Test Sic', SicDesc = 'Test Sic Desc',
                                      SLED_Area__c = 'Test Sled', Billingstate = 'state local', BillingStreet = 'street local', BillingPostalCode = '1213123',
                                      Billingcountry = 'country local', Account_Status__c = 'Approved');
        
        //Account oldAcct = [Select Id,RecordTypeId,Enterprise_Id__c,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate, Segment__c = 'Large Existing',, Coverage_Model__c = 'Account Team' from Account where Id = :acc.Id];
        Account updateAcct = new Account(Name = 'TestAcc12');
        updateAcct.Enterprise_Account_Name__c = 'Test Acct Name Updated';
        updateAcct.GU_DUNS_NUMBER__c = '98765432';
        updateAcct.RecordTypeId = recacc[0].Id;
        updateAcct.GU_NAME__c = 'Test Updated';
        // updateAcct.Segment__c = 'Large New';
        updateAcct.GEO__c = 'NA';
        updateAcct.Sales_Area__c = 'SOUTH';
        updateAcct.Sales_Region__c = 'SO_ATLANTA';
        updateAcct.Country_ISO_code__c = 'US';
        updateAcct.Account_Type1__c = 'Reseller Account';
        updateAcct.Account_Type__c = 'Federal';
        updateAcct.Coverage_Model__c = Label.CovModelVal2;
        updateAcct.Sales_Volume__c = 14.0;
        updateAcct.NumberOfEmployees = 1000;
        updateAcct.Sic = 'Sic Updated';
        updateAcct.SicDesc = 'Sic Desc Updated';
        updateAcct.SLED_Area__c = 'SLED Updates';
        updateAcct.Billingstate = 'local state';
        updateAcct.BillingStreet = 'local street';
        updateAcct.BillingPostalCode = '676786';
        updateAcct.Billingcountry = 'local country';
        
        Set < Id > userIds = new Set < Id > ();
        userIds.add(Userinfo.getUserId());
        List < User > usersList = [Select PMFKey__c from User where Id IN: userIds];
        Map < Id, String > userId_pmfKey_map = new Map < Id, String > ();
        for (User userObj: usersList) {
            userId_pmfKey_map.put(userObj.Id, userObj.PMFKey__c);
        }
        AccountChangesPushToMDM testObj = new AccountChangesPushToMDM();
        Map < String, String > insertMap = testObj.createMapFromObject(oldAcct);
        AccountChangesPushToMDM.getSearchSOAPXML('NA00001', updateAcct.Id);
        AccountChangesPushToMDM.accountExists('NA00001', updateAcct.Id);
        AccountChangesPushToMDM.getInsertSOAPXML(insertMap, userId_pmfKey_map);
        //Map<String,String> updateMap = testObj.isAnyValidFieldUpdated(oldAcct,updateAcct);
        AccountChangesPushToMDM.getUpdateSOAPXML(insertMap, userId_pmfKey_map, null, null);
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"' +
            ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>' +
            '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        AccountChangesPushToMDM.parseResponseXML(respXML);
        try {
            AccountChangesPushToMDM.callWebService('test', 'test', 'test');
        } catch (Exception e) {
            
        }
        insert oldAcct;
        Test.starttest();
        oldAcct.GU_DUNS_NUMBER__c  ='1234';
        SystemIdUtility.skipAccount = true;
        update oldAcct;
        PartnerProfileUtil.scheduleDirectAccountSync=0;
        PartnerProfileUtil.accScheduleCount=0;
        SystemIdUtility.skipAccount = false;
        oldAcct.GU_DUNS_NUMBER__c  ='1234';
        update oldAcct;
        Test.stoptest();
        Map < Id, Account > oldMap = new Map < Id, Account > ();
        Map < Id, Account > newMap = new Map < Id, Account > ();
        oldMap.put(oldAcct.Id, oldAcct);
        newMap.put(oldAcct.Id, oldAcct);
        testObj.pushAccountUpdatesToMDM(oldMap, newMap);
        delete oldAcct;
    }
    
}