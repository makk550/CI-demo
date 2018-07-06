@isTest(SeeAllData=true)   
private class TestExt_EditDealRegistrationCls{
    static testMethod void DealRegistrationEdit_Test() {
        try{
         RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
         Id dealRegRecordTypeID = rec.RecordType_Id__c; 
                                                            
         rec = RecordTypes_Setting__c.getValues('SMB');
         Id accRecordTypeId = rec.RecordType_Id__c;
         
        List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];                                           
        User partnerUser = [Select Id, UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                                    From User WHERE IsPortalEnabled = true AND UserType = 'PowerPartner' AND 
                                    Contact.Account.Customer_Category__c ='Reseller' and Profile.Name = 'Partner Champion'  AND IsActive = true LIMIT 1];                                   
                                           
        Account smbAccount = new Account();
        smbAccount.Name = 'TestSMBAccount';
        smbAccount.BillingStreet = 'IT Plaza';
        smbAccount.BillingCity = 'Hyderabad';
        smbAccount.BillingState = 'AP';
        smbAccount.Country_Picklist__c = 'US - UNITED STATES';
        smbAccount.RecordTypeId = accRecordTypeId;
        smbAccount.OwnerId = approvers[0].Id;
        System.debug('partnerUser $$$$$$$$$$$$ before'+ smbAccount);
        insert smbAccount;
            
        System.debug('partnerUser $$$$$$$$$$$$ after'+smbAccount);
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
        
        if(partnerUser <> null){
            System.RunAs(partnerUser){  
                //Create a Deal Registration Opportunity
                Opportunity objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.CloseDate = Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                ApexPages.StandardController stdCtrl = new ApexPages.StandardController(objOpp);
                Ext_EditDealRegistration objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';     
                objOpp.StageName = 'DealReg - New';
                objOpp.CloseDate =  Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner'; 
                objOpp.Deal_Registration_Program__c = delPgrm.Id;                
                insert objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Submitted to CA';
                objOpp.Second_Approver__c = approvers[3].Id;
                objOpp.Third_Approver__c = approvers[4].Id;
                objOpp.Partner_User_Internal__c = partnerUser.Id;
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Sale Approved';
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Rejected';
                objOpp.Deal_Rejection_Reason__c = 'test';
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Rejected';
                objOpp.Deal_Rejection_Reason__c = 'Other';
                objOpp.Deal_Registration_Rejection_Reason_Other__c = 'test';
                update objOpp;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
            }
        }
        
        }
        catch(Exception e){
            
            System.debug('Exception in test class'+e);
        }
    }
}