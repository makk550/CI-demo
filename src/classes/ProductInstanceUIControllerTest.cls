@isTest
public class ProductInstanceUIControllerTest {
/*
    
    public static testmethod void loadhierarchytreetest(){
        user u1=new user(id='00530000003rQuJ');
        String returnvalue;
        Boolean pageresult;
        PageReference result;
        system.runas(u1){
            
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
            
            Account acc = new Account();
            acc.Name = 'Generic Support Account'; 
            acc.Enterprise_ID__c = '7777777777';
            acc.BillingStreet='Street';
            acc.BillingCountry='US';
            acc.BillingCity='Islandia'; 
            acc.GU_DUNS_NUMBER__c='791312069';
            acc.GU_NAME__c='test tree';
            insert acc;
            
           
            
            Site_Association__c siteAssociationObj = new Site_Association__c();
            siteAssociationObj.Name = 'IBM';
            siteAssociationObj.SAP_Site_ID__c = '123456789';
            siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
            siteAssociationObj.Enterprise_ID__c = acc.Id;
            siteAssociationObj.SC_TOPS_ID__c = '1299636';
            siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
            siteAssociationObj.State__c='New York';
            siteAssociationObj.ProviSite__c = 1;
            insert siteAssociationObj;
            
            Site_ISP_Junction__c siteisp = new Site_ISP_Junction__c();
            siteisp.Site_Association__c = siteAssociationObj.id;
            siteisp.ISP__c = 5;
            insert siteisp;
            
            test.starttest();
            PageReference testpageRef = Page.ProdInstanceUIOppAcc;
            Test.setCurrentPage(testpageRef);
            ApexPages.currentPage().getParameters().put('accId', acc.Id);
            
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('DunsTreeResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            mock.setHeader('consumerUsername',Label.ProdInstMDMUsernameQA);
            mock.setHeader('Authorization',Label.ProdInstMDMAuthQA);       
            Test.setMock(HttpCalloutMock.class, mock);

            ProductInstanceUIController prodinstcontroller = new ProductInstanceUIController();
            result = prodinstcontroller.redirectHelper();
            returnvalue = String.valueOf(result);
            pageresult = returnvalue.contains(acc.id);
            system.assertEquals(true, pageresult);
            
            prodinstcontroller.fetchdunsdetailsonSearch();
            prodinstcontroller.fetchrecords();
            system.assertEquals(true, ApexPages.hasMessages());
            prodinstcontroller.dunsnofrompage = '027544786';
            prodinstcontroller.type = 'duns';
            prodinstcontroller.fetchDetails();
            system.assertEquals(false, prodinstcontroller.solutionexists);
            prodinstcontroller.type = 'gu';
            prodinstcontroller.fetchDetails();
            system.assertEquals(false, prodinstcontroller.solutionexists);
            prodinstcontroller.type = 'gp';
            prodinstcontroller.fetchDetails();
            system.assertEquals(true, prodinstcontroller.NoRecordUnderAcc);
            prodinstcontroller.dunsnofrompage = '189699317';
            prodinstcontroller.type = 'duns';
            prodinstcontroller.fetchDetails();
            system.assertEquals(true, prodinstcontroller.solutionexists);
            prodinstcontroller.dunsnofrompage = '060321254';
            prodinstcontroller.fetchDetails();
            system.assertEquals(true, prodinstcontroller.solutionexists);
            prodinstcontroller.dunsnofrompage = '065372500';
            prodinstcontroller.type = 'gu';
            prodinstcontroller.fetchDetails();
            system.assertEquals(true, prodinstcontroller.solutionexists);
            prodinstcontroller.valToSearch = '';
            prodinstcontroller.fetchdunsdetailsonSearch();
            system.assertEquals(true, ApexPages.hasMessages());
            prodinstcontroller.valToSearch = 'Agile';
            prodinstcontroller.fetchdunsdetailsonSearch();
            
            prodinstcontroller.ispnumber = '12345679';
            result = prodinstcontroller.updateisp();
            string s = String.valueof(URL.getSalesforceBaseUrl());
            s = s.substringBetween('=',']');
            PageReference pf = new PageReference(s+'/apex/NoSiteISPRecord');
            pf.setRedirect(true);
            
            system.assertEquals(pf.getUrl(), result.getUrl());
            prodinstcontroller.ispnumber = '123456789';
            result = prodinstcontroller.updateisp();
            system.assertNotEquals(pf, result);
            test.stopTest();
            
        }
    }
    */

}