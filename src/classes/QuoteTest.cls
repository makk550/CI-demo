@istest
public with sharing class QuoteTest {
    
    @isTest(SeeAllData=true)
    public static void QuoteApprovalProcessTest() {
        
    PricebookEntry p1 = [Select p.UseStandardPrice, p.UnitPrice, p.ProductCode,
    p.Product2Id, p.Pricebook2Id, p.Id, p.CurrencyIsoCode From PricebookEntry p where p.CurrencyIsoCode = 'USD' and p.isActive = true LIMIT 1];
        //Product2 cProduct = [select SKU__c,Dist_Price__c,Description,Market_Focus_Area__c from Product2 where SKU__c !=null and Id = :p1.Product2Id LIMIT 1];
       
    Contact contact = new Contact(lastName='vinay kurudi');
    insert contact;
         
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
   
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();

        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
       
       Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
       Opportunity opp = new Opportunity(AccountId=smbAcct.Id,CurrencyIsoCode= 'USD',Reseller__c=resellerAcct.Id,Name='Opp1',Type='DM',RecordTypeId=oppRecId,CloseDate=System.today()+3,StageName=Label.Opp_Stage_Closed_Won,Initial_Billing__c=2,Order_Number__c = 'onum');       
       insert opp; 
       
       Test.startTest();
        Quote q = new Quote(OpportunityId = opp.Id,Name = 'test quote',Pricebook2Id = p1.Pricebook2Id,Attestation__c = true);
        /*
        q.OpportunityId = opp.Id;
        q.Name = 'test quote';
        q.Pricebook2Id = p1.Pricebook2Id;
        //q.CurrencyIsoCode = p1.CurrencyIsoCode;
        q.Attestation__c = true;
        */
        insert q;
        
        QuoteLineItem qlt = new QuoteLineItem(Quantity = 2.0,UnitPrice = 10000.0,Discount = 15.0,QuoteId = q.Id,SKU__c = 'srerwerwer',Disti__c = 11.0,
        Disti_Unit_Cost__c = 10.0,Product_Description__c =  'asdasd',Business_Unit__c = 'Security',PricebookEntryId = p1.id);
        insert qlt;
        
        QuoteLineItem qlt_2 = new QuoteLineItem(Quantity = 2.0,UnitPrice = 10000.0,Discount = 15.0,QuoteId = q.Id,SKU__c = 'srerwerwer',Disti__c = 11.0,
        Disti_Unit_Cost__c = 10.0,Product_Description__c =  'asdasd',Business_Unit__c = 'Security',PricebookEntryId = p1.id,Additional_Discount__c=5.0,Discount_1__c=5.0);
        insert qlt_2;
        /*
        qlt.Quantity = 2.0;
        qlt.UnitPrice = 10000.0;
        qlt.Discount = 15.0;
        qlt.QuoteId = q.Id;
        qlt.SKU__c = 'srerwerwer';
        qlt.Disti__c = 11.0;
        qlt.Disti_Unit_Cost__c = 10.0;
        qlt.Product_Description__c =  'asdasd';
        qlt.Business_Unit__c = 'Security';
       
         if(p1!= null){
            qlt.PricebookEntryId = p1.id;
         }
         
         System.debug('Insertion ended'+ qlt.PricebookEntryId);
         */
      
        
        q.Approval_Status__c = 'Approved';
        update q;
        delete qlt;
        
        // Testing for the class QuoteApprovalRulesUtility
        QuoteApprovalRulesUtility.isRegionValid(opp, 'NA');
        QuoteApprovalRulesUtility.isAreaValid(opp, 'NA');
        QuoteApprovalRulesUtility.isTerritoryValid(opp, 'NA');
        QuoteApprovalRulesUtility.isCountryValid(opp, 'NA');
        QuoteApprovalRulesUtility.isRTMValid(opp, 'Alliance');
        Test.stopTest();
        
    }
}