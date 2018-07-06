/**
Class Name: DealReg_DealCertificateClassTest
Date: 12/29/2010
Project/Requirement: CA PRM R2/Deal Registration
Author: Accenture
Description: This class is test class for DealReg_DealCertificateClass
*/

@isTest
private class DealReg_DealCertificateClassTest {
        
    static testMethod void testDealReg(){    
        PageReference pageRef = Page.DealReg_DealCertificate; 
        Test.setCurrentPage(pageRef);       
        
        RecordType dealRegRecordTypeID = [SELECT Id FROM RecordType where Name = 'Deal Registration' 
                                                            AND IsActive = true AND SObjectType='Opportunity' LIMIT 1];
                                                            
            RecordType accRecordTypes = [SELECT Id,Name FROM RecordType WHERE Name = 'SMB' AND 
                                           IsActive=true AND SObjectType='Account'];

            List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];                                           
                                           
                                           
            Account smbAccount = new Account();
            smbAccount.Name = 'TestSMBAccount';
            smbAccount.RecordTypeId = accRecordTypes.Id;
            smbAccount.OwnerId = approvers[0].Id;
            smbAccount.BillingStreet = 'Arlington';
            smbAccount.BillingCountry = 'US';
            smbAccount.BillingCity = 'VA';
            insert smbAccount;
            
            Contact smbContact = new Contact();
            smbContact.LastName = 'TestSMBContact';
            insert smbContact;                                                            
                                                            
            
            //Create a Deal Registration Program
            Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
            delPgrm.name = 'TestDRP';
            delPgrm.Partner_Friendly_Name__c = 'TestDRP';
            delPgrm.Description__c = 'TestDRP';
            delPgrm.Program_Manager__c = approvers[0].Id;
            delPgrm.Program_Queries__c = approvers[1].Id;
            delPgrm.First_Approver__c = approvers[2].Id;
            delPgrm.Second_Approver__c = approvers[3].Id;
            delPgrm.Third_Approver__c = approvers[4].Id; 
            delPgrm.Max_Deal_Value__c = 1000;
            delPgrm.Min_Deal_Value__c = 100;
            delPgrm.Start_Date__c = Date.today();
            delPgrm.End_Date__c = Date.today() + 3;
            delPgrm.Expiry_Days__c = 10;        
            delPgrm.CurrencyIsoCode = 'USD';    
            delPgrm.Finance_Approver_Email__c = 'approver@ca.com';
            delPgrm.Geography__c = 'NA';
            delPgrm.Country2__c = 'IN-INDIA';
            delPgrm.Country1__c = 'US-USA';
            delPgrm.Partner_Program_Level__c = 'Platinum';
            delPgrm.Primary_Business_Functions__c = 'Technology Alliance';
            delPgrm.Secondary_Business_Functions__c = 'OEM';
            delPgrm.Deal_Program_Type__c = 'Alliance';
            insert delPgrm;
            
            //Create a Deal Registration Opportunity
            Opportunity objOpp = new Opportunity();
            objOpp.Name = 'TestDealRegistration';
            objOpp.RecordTypeId = dealRegRecordTypeID.Id;
            objOpp.Deal_Registration_Status__c = 'New';
            objOpp.StageName = 'DealReg - New';
            objOpp.CloseDate = Date.today() + 1;
            objOpp.Deal_Registration_Program__c = delPgrm.Id;
            objOpp.Deal_Registration_Submitted_Date__c = Date.today(); 
            objOpp.Deal_Expiration_Date__c = Date.today() + 10;
            insert objOpp;
            
            ApexPages.currentPage().getParameters().put('id',objOpp.Id);
        
        DealReg_DealCertificateClass objDealCert = new DealReg_DealCertificateClass();
        
    }
}