/*
 * Test class for the trigger - UpdateDDR_status 
 * Coverage - 74%
 * Updated by - BAJPI01
*/ 

@istest
public class OppUpdateDealDeskTestClass {
    
    @isTest      
    static void insertDealDeskTest() { 
        
        testCreateAccOppandLineItemClass.insertSterlingQuote();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp, 'Opportunity is not null');
        
        scpq__SciQuote__c  sterlingQuote = [select id from scpq__SciQuote__c limit 1];
        system.assertNotEquals(null, sterlingQuote, 'Sterling quote is not null');
        
        Account acc = [select id from account limit 1];
        system.assertNotEquals(null, acc.id, 'Account id should not be null');

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c( Opportunity_Name__c = opp.Id,Sterling_Quote__c=sterlingQuote.id,
                                                         Deal_Desk_Status__c='On Hold',Account__c=acc.id);
        insert dd;
		system.assertNotEquals(null, dd, 'Deal Desk inserted.');
                                
    }
    
     @isTest      
    static void oppUpdateDealDeskTest() { 
    	testCreateAccOppandLineItemClass.insertSterlingQuote();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp, 'Opportunity is not null');
        
        scpq__SciQuote__c  sterlingQuote = [select id from scpq__SciQuote__c limit 1];
        system.assertNotEquals(null, sterlingQuote, 'Sterling quote is not null');

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c( Opportunity_Name__c = opp.Id,Sterling_Quote__c=sterlingQuote.id,
                                                         Deal_Desk_Status__c='On Hold',
                                                        Deal_Desk_Request_Type__c='NDA',NDA_Type__c='Non-Standard NDA');
        insert dd;
		system.assertNotEquals(null, dd, 'Deal Desk should get inserted.');
        
        update opp;
        
                                
    }
    
    //below test method is to create a DDR and create a NDA agreement.
     @isTest      
    static void UpdateDealDeskTest() { 
        
        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Deal_Desk_Request_Type__c='NDA');
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should get inserted.');
        Deal_Desk_Review__c ddr = [select id,Create_Agreement__c,Agreement_Record_Type__c,OwnerId from Deal_Desk_Review__c where id=:dd.id];
		system.debug('----rec type---'+ddr.Agreement_Record_Type__c);
        ddr.Create_Agreement__c=true;
        update ddr;
        system.assertEquals(false, dd.Create_Agreement__c, 'NDA Agreement should get created.');
        
    }
    
    //below test method is to create a DDR and create a master agreement.
    //This requies a site association.
    @isTest      
    static void createMasterAgreementDealDeskTest() { 
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp, 'Opportunity ID should not be null');
        
        Account acc = [select id from account limit 1];
        system.assertNotEquals(null, acc.id, 'Account id should not be null');
        system.debug('----account id------'+acc.id);
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        Site_Association__c siteAssociationObj = new Site_Association__c();
        siteAssociationObj.Name = 'IBM';
        siteAssociationObj.SAP_Site_ID__c = '280125';
        siteAssociationObj.SC_SITE_Sanctioned_Party__c = 'NO';
        siteAssociationObj.Enterprise_ID__c = acc.Id;
        siteAssociationObj.SC_TOPS_ID__c = '1299636';
        siteAssociationObj.Country_picklist__c= 'US - UNITED STATES';
        siteAssociationObj.State__c='New York';
        siteAssociationObj.ProviSite__c = 1;
        insert siteAssociationObj;
        system.assertNotEquals(null, siteAssociationObj.id, 'Site Association should be inserted');
        

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Deal_Desk_Request_Type__c='Master - Standalone',
                                                        Agreement_Sub_Type__c='Education',Site_Association__c=siteAssociationObj.id);
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should be inserted.');
        Deal_Desk_Review__c ddr = [select id,Create_Agreement__c,Agreement_Record_Type__c,OwnerId from Deal_Desk_Review__c where id=:dd.id];
		system.debug('----rec type---'+ddr.Agreement_Record_Type__c);
        system.debug('----owner id---'+ddr.OwnerId);
        ddr.Create_Agreement__c=true;
        update ddr;
        system.assertEquals(false, dd.Create_Agreement__c, 'Master Agreement should get created.');
        
    }
    
    //below test method is to create a DDR and create a transaction agreement.
    //This requies a sterling quote.
    @isTest      
    static void createTransactionAgreementDealDeskTest() { 
        testCreateAccOppandLineItemClass.insertSterlingQuote();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp, 'Opportunity ID should not be null');
        
        scpq__SciQuote__c  sterlingQuote = [select id from scpq__SciQuote__c limit 1];
        system.assertNotEquals(null, sterlingQuote, 'Sterling quote is not null');
        

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Deal_Desk_Request_Type__c='Product-Other',
                                                        Agreement_Sub_Type__c='Education',Opportunity_Name__c = opp.Id,
                                                         Sterling_Quote__c=sterlingQuote.id);
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should be inserted.');
        Deal_Desk_Review__c ddr = [select id,Create_Agreement__c,Agreement_Record_Type__c,OwnerId from Deal_Desk_Review__c where id=:dd.id];
		system.debug('----rec type---'+ddr.Agreement_Record_Type__c);
        system.debug('----owner id---'+ddr.OwnerId);
        ddr.Create_Agreement__c=true;
        ddr.OwnerId=UserInfo.getUserId();
        update ddr;
        system.assertEquals(false, dd.Create_Agreement__c, 'Transaction Agreement should get created.');
        
    }
    
    //below test method is to create a DDR and create a transaction trial agreement.
    @isTest      
    static void createTrialAgreementDealDeskTest() { 
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp, 'Opportunity ID should not be null');
        

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Deal_Desk_Request_Type__c='Product-Other',
                                                        Agreement_Sub_Type__c='Education');
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should be inserted.');
        Deal_Desk_Review__c ddr = [select id,Create_Agreement__c,Agreement_Record_Type__c,OwnerId from Deal_Desk_Review__c where id=:dd.id];
		system.debug('----rec type---'+ddr.Agreement_Record_Type__c);
        system.debug('----owner id---'+ddr.OwnerId);
        ddr.Create_Agreement__c=true;
        update ddr;
        system.assertEquals(false, dd.Create_Agreement__c, 'Transaction Trial Agreement should get created.');
        
    }
    
    //below test method is to create a DDR and change it's status to Approved DD, and then from
	//Approved DD to any other status.
	//this also changes the owner of the deal desk.
    @isTest      
    static void updateDealDesktoApprovedandNotApprovedTest() { 
        

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Deal_Desk_Request_Type__c='Master - Standalone',
                                                        Agreement_Sub_Type__c='Education');
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should be inserted.');
        Deal_Desk_Review__c ddr = [select id,Deal_Desk_Status__c,Approval_Start_Time__c from Deal_Desk_Review__c where id=:dd.id];
        ddr.Deal_Desk_Status__c='Approved – DD';
        update ddr;
        system.debug('------start time------'+ddr.Approval_Start_Time__c);
        ddr.Deal_Desk_Status__c='Closed';
        update ddr;
        system.assertNotEquals(null, ddr.Approval_Start_Time__c, 'Approval Start time should not be null.');
        
        ddr = [select id,OwnerId,NDA_Type__c,Deal_Desk_Request_Type__c from Deal_Desk_Review__c where id=:ddr.id];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardDDRuser@gmail.com');
        insert u;
        ddr.OwnerId = u.id;
        ddr.Deal_Desk_Request_Type__c='NDA';
        ddr.NDA_Type__c = 'Non-Standard NDA';
        update ddr;
        
    }
    
    //below test method is to create a DDR and change it's status to Approved DD, and then from
	//Approved DD to any other status.
    @isTest      
    static void DDRinsertTest() { 
        
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        
        Opportunity opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity ID should not be null');

        Deal_Desk_Review__c dd = new Deal_Desk_Review__c(Deal_Desk_Status__c='Pending Sales Update - DD',Deal_Desk_Request_Type__c='Master - Standalone',
                                                        Agreement_Sub_Type__c='Education',Sales_Milestone__c=Label.Opp_Stage_Closed_Lost);
        insert dd;
		system.assertNotEquals(null, dd.id, 'Deal Desk should be inserted.');
        dd =[select Deal_Desk_Status__c from Deal_Desk_Review__c where id=:dd.id];
        system.assertEquals('Closed', dd.Deal_Desk_Status__c, 'Deal Desk status should be Closed.');
        
         Deal_Desk_Review__c ddr = new Deal_Desk_Review__c(Deal_Desk_Status__c='Closed',Deal_Desk_Request_Type__c='Master - Standalone',
                                                        Agreement_Sub_Type__c='Education',Sales_Milestone__c=Label.Opp_Stage_10_Percent,
                                                          Opportunity_Name__c = opp.Id);
        insert ddr;
        ddr =[select Deal_Desk_Status__c from Deal_Desk_Review__c where id=:ddr.id];
        system.assertEquals('Updated – DD', ddr.Deal_Desk_Status__c, 'Deal Desk status should be Updated – DD.');
        
        
        Account acc = [select id from Account limit 1];
        system.assertNotEquals(null, acc.id, 'Opportunity ID should not be null');
        
        Deal_Desk_Review__c ddr2 = new Deal_Desk_Review__c(Deal_Desk_Status__c='New',Account__c=acc.id);
        insert ddr2;
        ddr2 =[select id,Deal_Desk_Status__c,OwnerId,Sales_Milestone__c from Deal_Desk_Review__c where id=:ddr2.id];
        ddr2.Sales_Milestone__c = Label.Opp_Stage_Closed_Lost;
        update ddr2;
        ddr2 =[select Deal_Desk_Status__c,Sales_Milestone__c from Deal_Desk_Review__c where id=:ddr2.id];
        system.assertEquals('Closed', ddr2.Deal_Desk_Status__c, 'Deal Desk status should be Closed.');
        ddr2.Sales_Milestone__c = Label.Opp_Stage_10_Percent;
        update ddr2;
        ddr2 =[select Deal_Desk_Status__c,Sales_Milestone__c,Sales_Comments__c from Deal_Desk_Review__c where id=:ddr2.id];
        system.assertEquals('Updated – DD', ddr2.Deal_Desk_Status__c, 'Deal Desk status should be Update - DD.');
        ddr2.Deal_Desk_Status__c = 'Pending Sales Update - DD';
        update ddr2;
        ddr2.Sales_Comments__c = 'test';
        update ddr2;
        ddr2 =[select Deal_Desk_Status__c,Sales_Milestone__c,Sales_Comments__c from Deal_Desk_Review__c where id=:ddr2.id];
        system.assertEquals('Updated – DD', ddr2.Deal_Desk_Status__c, 'Deal Desk status should be Update - DD..');
    }
}