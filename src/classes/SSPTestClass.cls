@isTest
private class SSPTestClass {


    // test method for the Account Plan synch trigger (accountOwnerSyncTrigger.trigger)
    static testMethod void testAccOwnerSynch() {
        
        String uid = UserInfo.getUserId();
        
        User[] users = [select id from user where isactive = true and UserType = 'Standard' and id != :uid limit 2];
        // create a test account 1st
        Account acc1 = new Account();
		acc1.Name = 'acc1';
		acc1.Lead_Rating__c = 'B';
		acc1.Customer_Category__c = 'Reseller';
		acc1.Account_Status__c = 'Approved';
		acc1.Reseller_Type__c = 'Value';
		acc1.CPMS_ID__c = '1900';
		acc1.BillingState = 'NY';
		acc1.Reseller_Disti_Regional_ID__c = '12';
		acc1.Reseller_Distributor_Name__c = 'rdName';		
		acc1.Commercial_ID__c = 	'12';
		acc1.Commercial_Account_Name__c = 'caName';
		insert acc1;

        // create a test account plan
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        insert ap;

        
        Test.startTest();
//        System.runAs(users[0]) {
            // update the account id
            acc1.Name = 'testAccNew'; 
            acc1.OwnerId = users[0].Id; 
            upsert acc1;
  //      }
        Test.stopTest();

    }   
    
    // test method for the updateLineItemRefUrl opportunity trigger
    static testMethod void testUpdateLIRefURLScenario1() {

        /*Opportunity opp = new Opportunity();
        opp.Name = 'testNewOpp';
        opp.CloseDate = Date.newInstance(2009,03,03);
        opp.StageName = '10%-Qualified Renewal';
        opp.Amount = 30;
        insert opp;

        Product_Milestone_Reference_Map__c pmrm = new Product_Milestone_Reference_Map__c();
        pmrm.Is_Active__c = true;
        pmrm.Product_Group_Name__c = 'Assessment,ESM';
        pmrm.Reference_Link__c = 'http://google.com';
        pmrm.Milestone__c = opp.StageName;
        insert pmrm;
        
        Product_Milestone_Reference_Map__c pmrm2 = new Product_Milestone_Reference_Map__c();
        pmrm2.Is_Active__c = true;
        pmrm2.Product_Group_Name__c = 'Assessment,ESM';
        pmrm2.Reference_Link__c = 'http://yahoo.com';
        pmrm2.Milestone__c = '100%-Closed';
        insert pmrm2;

        
        Pricebook2 pb2 = [SELECT Id
                            FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        
        Product2 prod2 = new Product2(Name = 'testprod',Solution_Sets__c = 'Assessment,ESM');                    
        insert prod2;
 
        PricebookEntry pbe = new PricebookEntry(
                    Pricebook2Id = pb2.Id
                    , Product2Id = prod2.Id
                    , UnitPrice = 100.00
                    , IsActive = TRUE
                    );                    
        insert pbe;
        
         
        OpportunityLineItem oppli = new OpportunityLineItem(
                    OpportunityId = opp.Id
                    , PricebookEntryId = pbe.Id
                    , Quantity = 1
                    );                    
        insert oppli;

        Test.startTest();
        opp.StageName = '100%-Closed';
        opp.Amount = 300;
        upsert opp;     
        Test.stopTest();   */     
    }

    // test method for the updateLineItemRefUrl opportunity trigger
    static testMethod void testUpdateLIRefURLScenario2() {

        /*Opportunity opp = new Opportunity();
        opp.Name = 'testNewOpp';
        opp.CloseDate = Date.newInstance(2009,03,03);
        opp.StageName = '10%-Qualified Renewal';
        opp.Amount = 30;
        insert opp;

        Product_Milestone_Reference_Map__c pmrm = new Product_Milestone_Reference_Map__c();
        pmrm.Is_Active__c = true;
        pmrm.Product_Group_Name__c = 'Assessment,ESM';
        pmrm.Reference_Link__c = 'http://google.com';
        pmrm.Milestone__c = opp.StageName;
        insert pmrm;
        
        Product_Milestone_Reference_Map__c pmrm2 = new Product_Milestone_Reference_Map__c();
        pmrm2.Is_Active__c = true;
        pmrm2.Product_Group_Name__c = 'Assessment,ESM';
        pmrm2.Reference_Link__c = 'http://yahoo.com';
        pmrm2.Milestone__c = '20%-Qualified Opp.';
        insert pmrm2;

        
        Pricebook2 pb2 = [SELECT Id
                            FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        
        Product2 prod2 = new Product2(Name = 'testprod');                    
        insert prod2;
 
        PricebookEntry pbe = new PricebookEntry(
                    Pricebook2Id = pb2.Id
                    , Product2Id = prod2.Id
                    , UnitPrice = 100.00
                    , IsActive = TRUE
                    );                    
        insert pbe;
        
         
        OpportunityLineItem oppli = new OpportunityLineItem(
                    OpportunityId = opp.Id
                    , PricebookEntryId = pbe.Id
                    , Quantity = 1
                    , Reference__c = 'http://ca.com'
                    );                    
        insert oppli;
        oppli.Reference__c = 'ca1.com';
        upsert oppli;
        
        Test.startTest();
        opp.StageName = '20%-Qualified Opp.';
        opp.Amount = 300;
        upsert opp;     
        Test.stopTest();   */     
    }

    // test method for the updateLineItemRefUrl opportunity trigger
    static testMethod void testUpdateLIRefURLScenario3() {

        /*Opportunity opp = new Opportunity();
        opp.Name = 'testNewOpp';
        opp.CloseDate = Date.newInstance(2009,03,03);
        opp.StageName = '10%-Qualified Renewal';
        opp.Amount = 30;
        insert opp;

        Product_Milestone_Reference_Map__c pmrm = new Product_Milestone_Reference_Map__c();
        pmrm.Is_Active__c = true;
        pmrm.Product_Group_Name__c = 'Assessment,ESM';
        pmrm.Reference_Link__c = 'http://google.com';
        pmrm.Milestone__c = opp.StageName;
        insert pmrm;
        
        Product_Milestone_Reference_Map__c pmrm2 = new Product_Milestone_Reference_Map__c();
        pmrm2.Is_Active__c = true;
        pmrm2.Product_Group_Name__c = 'Assessment,ESM';
        pmrm2.Reference_Link__c = 'http://yahoo.com';
        pmrm2.Milestone__c = '100%-Closed';
        insert pmrm2;

        
        Pricebook2 pb2 = [SELECT Id
                            FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        
        Product2 prod2 = new Product2(Name = 'testprod',Solution_Sets__c = 'Assessment,ESM2');                    
        insert prod2;
 
        PricebookEntry pbe = new PricebookEntry(
                    Pricebook2Id = pb2.Id
                    , Product2Id = prod2.Id
                    , UnitPrice = 100.00
                    , IsActive = TRUE
                    );                    
        insert pbe;
        
         
        OpportunityLineItem oppli = new OpportunityLineItem(
                    OpportunityId = opp.Id
                    , PricebookEntryId = pbe.Id
                    , Quantity = 1
                    );                    
        insert oppli;
        oppli.Reference__c = 'ca1.com';
        upsert oppli;

        Test.startTest();
        opp.StageName = '100%-Closed';
        opp.Amount = 300;
        upsert opp;     
        Test.stopTest();    */            
    }
    
    //test method for NewLineItemRefURL opportunityLineItem trigger
    static testMethod void testNewLIRefURL() {
        
        /*Pricebook2 pb2 = [SELECT Id
                            FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        
        Product2 prod2 = new Product2(Name = 'testprod',Solution_Sets__c = 'Assessment,ESM');                    
        insert prod2;
 
        PricebookEntry pbe = new PricebookEntry(
                    Pricebook2Id = pb2.Id
                    , Product2Id = prod2.Id
                    , UnitPrice = 100.00
                    , IsActive = TRUE
                    );                    
        insert pbe;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'testNewOpp';
        opp.CloseDate = Date.newInstance(2009,03,03);
        opp.StageName = '10%-Qualified Renewal';
        opp.Amount = 30;
        insert opp;

        Product_Milestone_Reference_Map__c pmrm = new Product_Milestone_Reference_Map__c();
        pmrm.Is_Active__c = true;
        pmrm.Product_Group_Name__c = 'Assessment,ESM';
        pmrm.Reference_Link__c = 'http://google.com';
        pmrm.Milestone__c = opp.StageName;
        insert pmrm;
         
        OpportunityLineItem oppli = new OpportunityLineItem(
                    OpportunityId = opp.Id
                    , PricebookEntryId = pbe.Id
                    , Quantity = 1
                    );                    
        insert oppli;
        Test.startTest();
        Test.stopTest();  */      
    }
    
    //test method for CheckIfDefaultPlanIsCheckedByAccountOwner Account Plan trigger
    static testMethod void testCheckIfDefaultPlanIsCheckedByAccountOwner1() {       
        try
        {
            String uid = UserInfo.getUserId();
            
            User[] users = [select id from user where isactive = true and id != :uid limit 2];
    
            System.debug(logginglevel.Debug,'Arun 1 : '+users);
    
            // create a test account 1st
            Account acc1 = new Account();
			acc1.Name = 'acc1';
			acc1.Lead_Rating__c = 'B';
			acc1.Customer_Category__c = 'Reseller';
			acc1.Account_Status__c = 'Approved';
			acc1.Reseller_Type__c = 'Value';
			acc1.CPMS_ID__c = '1900';
			acc1.BillingState = 'NY';
			acc1.Reseller_Disti_Regional_ID__c = '12';
			acc1.Reseller_Distributor_Name__c = 'rdName';		
			acc1.Commercial_ID__c = 	'12';
			acc1.Commercial_Account_Name__c = 'caName';
			insert acc1;
            
            Account acc2 = new Account();
			acc2.Name = 'acc2';
			acc2.Lead_Rating__c = 'B';
			acc2.Customer_Category__c = 'Reseller';
			acc2.Account_Status__c = 'Approved';
			acc2.Reseller_Type__c = 'Value';
			acc2.CPMS_ID__c = '1900';
			acc2.BillingState = 'NY';
			acc2.Reseller_Disti_Regional_ID__c = '12';
			acc2.Reseller_Distributor_Name__c = 'rdName';		
			acc2.Commercial_ID__c = 	'12';
			acc2.Commercial_Account_Name__c = 'caName';
			insert acc2;
    
            // create a test account plan
            Account_Plan__c ap = new Account_Plan__c();
            ap.Name = 'Acc Plan';
            ap.Account__c = acc1.Id; 
            ap.Plan_Status__c = 'Draft';
            ap.Default_Plan__c = true;
            insert ap;
            
            // create another test account plan
            Account_Plan__c ap1 = new Account_Plan__c();
            ap1.Name = 'Acc Plan1';
            ap1.Account__c = acc1.Id; 
            ap1.Plan_Status__c = 'Draft';
            ap1.Default_Plan__c = false;
            insert ap1;
    
            // create another test account plan
            Account_Plan__c ap2 = new Account_Plan__c();
            ap2.Name = 'Acc Plan3';
            ap2.Account__c = acc1.Id; 
            ap2.Plan_Status__c = 'Draft';
            insert ap2;
    
            ap2.Name = 'Acc Plan2';
            upsert ap2;
    
            Test.startTest();
    //        System.runAs(users[1]) {
                // create another test account plan
                
                List<Account_Plan__c> apl = new List<Account_Plan__c>();
                for(integer j=0;j<3;j++)
                {
                    Account_Plan__c ap3 = new Account_Plan__c();
                    ap3.Name = 'Acc Plan1'; 
                    ap3.Plan_Status__c = 'Draft';
                    if(j == 0)
                    {
                        ap3.Default_Plan__c = true;
                        ap3.Account__c = acc1.Id;   
                    }
                    else
                    {
                        ap3.Account__c = acc2.Id;   
                    }
                    apl.add(ap3);
                }
                insert apl;
      //      }
            Test.stopTest();
        }               
        catch(Exception ex)
        {
            // catch any exception here                     
        }
    }
    
    //test method for CheckIfDefaultPlanIsCheckedByAccountOwner Account Plan trigger
    static testMethod void testCheckIfDefaultPlanIsCheckedByAccountOwner2() {
        try
        {       

            String uid = UserInfo.getUserId();
            
            User[] users = [select id from user where isactive = true and id != :uid limit 2];
    
            System.debug(logginglevel.Debug,'Arun 1 : '+users);
    
            // create a test account 1st
            Account acc1 = new Account();
			acc1.Name = 'acc1';
			acc1.Lead_Rating__c = 'B';
			acc1.Customer_Category__c = 'Reseller';
			acc1.Account_Status__c = 'Approved';
			acc1.Reseller_Type__c = 'Value';
			acc1.CPMS_ID__c = '1900';
			acc1.BillingState = 'NY';
			acc1.Reseller_Disti_Regional_ID__c = '12';
			acc1.Reseller_Distributor_Name__c = 'rdName';		
			acc1.Commercial_ID__c = 	'12';
			acc1.Commercial_Account_Name__c = 'caName';
			insert acc1;
    
    
            // create a test account plan
            Account_Plan__c ap = new Account_Plan__c();
            ap.Name = 'Acc Plan';
            ap.Account__c = acc1.Id; 
            ap.Plan_Status__c = 'Draft';
            insert ap;
            
    
            ap.Default_Plan__c = true;
            upsert ap;
        }
        catch(Exception ex)
        {
            //catch any exception here ..   
        }
    }

    //test method for CheckIfDefaultPlanIsCheckedByAccountOwner Account Plan trigger
    static testMethod void testCheckIfDefaultPlanIsCheckedByAccountOwner3() {       

        try
        {
            String uid = UserInfo.getUserId();
            
            User[] users = [select id from user where isactive = true and id != :uid limit 2];
    
            System.debug(logginglevel.Debug,'Arun 1 : '+users);
    
            // create a test account 1st
            Account acc1 = new Account();
			acc1.Name = 'acc1';
			acc1.Lead_Rating__c = 'B';
			acc1.Customer_Category__c = 'Reseller';
			acc1.Account_Status__c = 'Approved';
			acc1.Reseller_Type__c = 'Value';
			acc1.CPMS_ID__c = '1900';
			acc1.BillingState = 'NY';
			acc1.Reseller_Disti_Regional_ID__c = '12';
			acc1.Reseller_Distributor_Name__c = 'rdName';		
			acc1.Commercial_ID__c = 	'12';
			acc1.Commercial_Account_Name__c = 'caName';
			insert acc1;
        
            // create a test account plan
            Account_Plan__c ap = new Account_Plan__c();
            ap.Name = 'Acc Plan';
            ap.Account__c = acc1.Id; 
            ap.Plan_Status__c = 'Draft';
            insert ap;
            
    
            ap.Default_Plan__c = true;
            upsert ap;
        }
        catch(Exception ex)
        {
            // catch any exception here ..  
        }
    }       
}