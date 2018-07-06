@IsTest(SeeAllData=true)
public with sharing class TestPartnerRegistrationController {

    private static testmethod void testsaveForm()
     {
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        insert acc;
        
        TAQ_Account__c newacc5=new TAQ_Account__c();
        newacc5.name='Partner test TAQ';    
        newacc5.Region__c='';
        newacc5.Area__c='';
        newacc5.Territory__c='testt';
        newacc5.Country__c='testc';
        newacc5.Country_Picklist__c ='US - United States';
        newacc5.Account_Type__c='test type';
        newacc5.Reseller_ID__c = 'TESTID';
        newacc5.View_Acc_Record__c = acc.Id;
      
        User usr = [SELECT PMFKey__c,IsActive FROM User where PMFKey__c <> null and IsActive = true limit 1];
        newacc5.Solution_Provider_CAM_PMFKey__c = usr.PMFKey__c;
        
        Partner_Registration__c partnerReg = new Partner_Registration__c();
        partnerReg.First_Name__c='TFName';
        partnerReg.Last_Name__c='TLName';
        partnerReg.Email_Address__c='test--9@ca.com';
        partnerReg.Job_Title__c='APDev';
        partnerReg.Country__c='IN - India';
        partnerReg.Address_1__c='Address1';
        partnerReg.City__c='TestCity1';
        partnerReg.State_Province__c='State1';
        partnerReg.Postal_Code__c='1234';
        partnerReg.Phone__c='987654';
        partnerReg.Functional_Role__c= 'Administration';
        
        partnerReg.Company_business_model__c = 'System Integrator';
        partnerReg.CA_Solutions_and_Products__c = 'Application Performance Management';
        partnerReg.Terms_and_Conditions__c = true;
        
        //insert partnerReg; 
        
      
        ApexPages.StandardController stdController = new ApexPages.StandardController(partnerReg);
        PartnerRegistrationController partregObj = new PartnerRegistrationController(stdController);
        
        partregObj.partnerReg = partnerReg;     
        partregObj.taqAcc = newacc5;  
        partregObj.theSelectedTab='contTab';
        Pagereference pg = partregObj.saveform();
        
        //Anitha 30-Oct-2012
        upsert newacc5;
        TAQ_Account__c taqAcc = [Select Id,Approval_process_Status__C,View_Acc_Record__c from TAQ_Account__c where name='Partner test TAQ' limit 1];   
        taqAcc.Approval_process_Status__C = 'Pending Review';
        Update taqAcc;
        
        TAQ_Account__c accnt = [select View_Acc_Record__c from TAQ_Account__c where name='Partner test TAQ' limit 1];
        
        Account account =  [Select Id,CPMS_ID__c  from Account where id =: accnt.View_Acc_Record__c];
        account.CPMS_ID__c ='1235';
        
        update account;
        
        System.debug('____New TAQ Update Ant'+newacc5);
        System.debug('________________accNew'+accnt.View_Acc_Record__c );
        
        Test.StartTest();
        Pagereference pg11 = partregObj.fetchAccDtls();
        
        Pagereference pg12 = partregObj.createAcc();
        Pagereference pg13 = partregObj.createUsr();
        Pagereference pg14 = partregObj.copyAccntDtls();
        Pagereference pg15 = partregObj.tabChange();
        Pagereference pg16 = partregObj.editAccDtls();
        Pagereference pg17 = partregObj.editContDtls();
        Pagereference pg18 = partregObj.editMktDtls();
        Pagereference pg19 = partregObj.editsolnDtls();
        
        //Pagereference pg0 = partregObj.saveform();
        
        Pagereference pg1 = partregObj.next();
        Boolean bNext = partregObj.getNext();
        Boolean bPrev = partregObj.getPrev();
        Pagereference pg4 = partregObj.nextResultPage();
        Pagereference pg5 = partregObj.next();
        
        Pagereference pg6 = partregObj.prev();
        Pagereference pg7 = partregObj.prevResultPage();
        Boolean bLast = partregObj.getisLast();
        Pagereference pg9 = partregObj.firstResultPage();
        Pagereference pg10 = partregObj.lastResultPage();     
        
        List<PartnerProfileSearch.PartnerProfileAccounts> testRes = new List<PartnerProfileSearch.PartnerProfileAccounts>();
        testRes.add(new PartnerProfileSearch.PartnerProfileAccounts('tname','tstreet','tcity','tstate','tcountry','twebsite','tpostalcode','taccountid','taccounttype','tdunsNumber',200,'tstrategy','tglobalUltimateParent',1));
        
        Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>> searchList = partregObj.createSearchResultSet(testRes);      
        
        partregObj.res  = testRes ;
        
        partregObj.resAccount = testRes[0];
        Pagereference onbRedirect = partregObj.redirectOnboardingorCommon();
           PageReference ref = new PageReference('/apex/PartnerRegistration');
          Test.setCurrentPage(ref);
         Partner_Registration__c partnerReg4 = new Partner_Registration__c();
          partnerReg4.First_Name__c='TFName';
        partnerReg4.Last_Name__c='TLName';
        partnerReg4.Email_Address__c='test--9@ca.com';
        partnerReg4.Job_Title__c='APDev';
        partnerReg4.Country__c='IN - India';
        partnerReg4.Address_1__c='Address1';
        partnerReg4.City__c='TestCity1';
        partnerReg4.State_Province__c='State1';
        partnerReg4.Postal_Code__c='1234';
        partnerReg4.Phone__c='987654';
        partnerReg4.Functional_Role__c= 'Administration';
        
        partnerReg4.Company_business_model__c = System.Label.POB_partner_referral;
        partnerReg4.CA_Solutions_and_Products__c = 'Application Performance Management';
        partnerReg4.Terms_and_Conditions__c = true;
         ApexPages.StandardController stdController4 = new ApexPages.StandardController(partnerReg4);
         ApexPages.currentPage().getParameters().put('referral','v2');
        PartnerRegistrationController partregObj4 = new PartnerRegistrationController (stdController4);
         partregObj4.partnerReg = partnerReg4;  
         partregObj4.theSelectedTab='caSolutionsTab';
         Pagereference referrpg1=partregObj4.next();
         partregObj4.selectedProducts = new List<SelectOption>();
        partregObj4.selectedProducts.add(new SelectOption(System.Label.POB_Referral_Product,System.Label.POB_Referral_Product));
         
         partregObj4.theSelectedTab='marketOverviewTab';
         Pagereference referrpg2=partregObj4.next();
         partregObj4.theSelectedTab='caSolutionsTab';
         Pagereference referrpg3=partregObj4.next();
         Pagereference referralpg5 = partregObj4.saveform();
         System.debug('Referral Registration->'+referralpg5);
        Test.StopTest();
         
        
     }
     
     
     //Method to test errors
     private static testmethod void testsaveFormErrors()
     {
        Partner_Registration__c partnerReg = new Partner_Registration__c();
        partnerReg.First_Name__c='';
        partnerReg.Last_Name__c='TLName';
        partnerReg.Email_Address__c='';

        
      
        ApexPages.StandardController stdController = new ApexPages.StandardController(partnerReg);
        PartnerRegistrationController partregObj = new PartnerRegistrationController(stdController);
        Pagereference pg = partregObj.saveform();
        
        
        Partner_Registration__c partnerReg1 = new Partner_Registration__c();
        partnerReg1.First_Name__c='TFName';
        partnerReg1.Last_Name__c='TLName';
        partnerReg1.Email_Address__c='test--9@ca.com';
        partnerReg1.Job_Title__c='APDev';
        partnerReg1.Country__c='IN - India';
        partnerReg1.Address_1__c='Address1';
        partnerReg1.City__c='TestCity1';
        partnerReg1.State_Province__c='State1';
        partnerReg1.Postal_Code__c='1234';
        partnerReg1.Phone__c='987654';
        partnerReg1.Functional_Role__c= 'Administration';
        
        partnerReg1.Company_business_model__c = '';

        ApexPages.StandardController stdController1 = new ApexPages.StandardController(partnerReg1);
        PartnerRegistrationController partregObj1 = new PartnerRegistrationController (stdController1);
        
        partregObj1.partnerReg = partnerReg1;           
        Pagereference pg1 = partregObj1.saveform();
        
        Partner_Registration__c partnerReg2 = new Partner_Registration__c();
        partnerReg2.First_Name__c='TFName';
        partnerReg2.Last_Name__c='TLName';
        partnerReg2.Email_Address__c='test--9@ca.com';
        partnerReg2.Job_Title__c='APDev';
        partnerReg2.Country__c='IN - India';
        partnerReg2.Address_1__c='Address1';
        partnerReg2.City__c='TestCity1';
        partnerReg2.State_Province__c='State1';
        partnerReg2.Postal_Code__c='1234';
        partnerReg2.Phone__c='987654';
        partnerReg2.Functional_Role__c= 'Administration';
        
        partnerReg2.Company_business_model__c = 'System Integrator';
        partnerReg2.CA_Solutions_and_Products__c = '';
        partnerReg2.Terms_and_Conditions__c = true;
        

        ApexPages.StandardController stdController2 = new ApexPages.StandardController(partnerReg2);
        PartnerRegistrationController partregObj2 = new PartnerRegistrationController (stdController2);
        
        partregObj2.partnerReg = partnerReg2;    
        Pagereference pg2 = partregObj2.saveform();  
        
        Partner_Registration__c partnerReg3 = new Partner_Registration__c();
        partnerReg3.First_Name__c='TFName';
        partnerReg3.Last_Name__c='TLName';
        partnerReg3.Email_Address__c='test--9@ca.com';
        partnerReg3.Job_Title__c='APDev';
        partnerReg3.Country__c='IN - India';
        partnerReg3.Address_1__c='Address1';
        partnerReg3.City__c='TestCity1';
        partnerReg3.State_Province__c='State1';
        partnerReg3.Postal_Code__c='1234';
        partnerReg3.Phone__c='987654';
        partnerReg3.Functional_Role__c= 'Administration';
        
        partnerReg3.Company_business_model__c = 'System Integrator';
        partnerReg3.CA_Solutions_and_Products__c = 'Application Performance Management';
        partnerReg3.Terms_and_Conditions__c = false;

        ApexPages.StandardController stdController3 = new ApexPages.StandardController(partnerReg3);
        PartnerRegistrationController partregObj3 = new PartnerRegistrationController (stdController3);
        
        partregObj3.partnerReg = partnerReg3;             
        Pagereference pg3 = partregObj3.saveform();
        Pagereference pg4 = partregObj3.validateAccountSearch();
       
     }  
    private static testmethod void testReferralsaveForm()
    {
        
    }
}