@istest
public class OppUpdateQuoteRequestTestClass {
    @isTest(SeeAllData=true)
    static void oppUpdateQuoteRequestTest() {
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        // create a test reseller account  
        /*      
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.BillingState = 'NY';   
        testAcct.Customer_Category__c = 'Reseller';
        testAcct.Account_Status__c = 'Approved';
        testAcct.Reseller_Type__c = 'Value';
        testAcct.CPMS_ID__c = '1900'; 
        testAcct.BillingState = 'NY';
        testAcct.Reseller_Disti_Regional_ID__c = '12';
        testAcct.Reseller_Distributor_Name__c = 'rdName';
        testAcct.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();                             
        insert testAcct;
        
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc1';
        acct.RecordTypeId = SystemIdUtility.getCommAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'Yes';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        insert acct;
        */
        
        // create a test reseller account        
        Account enterpriseAccount = new Account();
        enterpriseAccount.Name = 'Test Account';
        enterpriseAccount.BillingState = 'NY';   
        enterpriseAccount.Customer_Category__c = 'Enterprise';
        enterpriseAccount.Account_Status__c = 'Approved';       
        enterpriseAccount.BillingState = 'NY';
        enterpriseAccount.GEO__c='NA';
        enterpriseAccount.Enterprise_ID__c = '1234te';
        enterpriseAccount.Enterprise_Account_Name__c = 'rdName';
        enterpriseAccount.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        enterpriseAccount.Reseller_Disti_Regional_ID__c = 'PA75344';
        enterpriseAccount.Reseller_Distributor_Name__c = 'APJ DM Test';                                     
        insert enterpriseAccount;
        
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    
        
        Contact con = new Contact(LastName ='Test_Contact',AccountId = smbAcct.id,Email = 'test@gmail.com');
        insert con;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        //RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        Opportunity opp = new Opportunity(RecordTypeId=recopp, Name = 'oppInsertTrigger1' , StageName = 'test' , CloseDate = Date.today()
                    , AccountId = smbAcct.Id, Reseller__c= enterpriseAccount.Id );
        insert opp;
        
        OpportunityContactRole conRole = new OpportunityContactRole(ContactId= con.id,IsPrimary = true,OpportunityId = opp.id,Role='Advisor');
		insert conRole;
        
        Quote_Request__c qreq = new Quote_Request__c(Opportunity_Name__c = opp.Id);
        insert qreq;
        
        Pricebook2 pb2 = [SELECT Id  FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];        
        Product2 prod2 = new Product2(Name = 'testprod');                    
        insert prod2;
 
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb2.Id, Product2Id = prod2.Id , UnitPrice = 100.00
                    , IsActive = TRUE);                    
        insert pbe;
         
        OpportunityLineItem oppli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 1);                    
        insert oppli;
                    

        //OpportunityLineItem retOppLI = [SELECT Id, Quantity FROM OpportunityLineItem  WHERE Id = :oppli.Id LIMIT 1];
        oppli.Quantity = 2;
        update oppli;
        
        //Quote_Request__c qrtest = [SELECT Id, Sales_Milestone__c FROM Quote_Request__c WHERE Id = :qreq.Id LIMIT 1];        
        //System.assertEquals('test', qrtest.Sales_Milestone__c);
        
        opp.StageName = '50%-Proposal Created';
        update opp;
                                
    }
}