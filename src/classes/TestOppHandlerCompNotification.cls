@isTest //(SeeAllData=true)
public class TestOppHandlerCompNotification {
    
    static testMethod void testCompEmailNotifications(){
        //SystemIdUtility.skipOpportunityTriggers = true;
       testOppLineItemTriggerClass.testCreateNewOppLineItem();
       Opportunity opp = [select id,StageName,Competitor__c,ReasonField__c,Other_Win_Loss_Reason__c,Opportunity_Type__c from Opportunity limit 1];
       Account acc = [select id,segment__c,coverage_model__c from Account limit 1];

       SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        String currencyIsoCode = 'USD';

       acc.segment__c = Label.SegmentVal2;
       acc.coverage_model__c = Label.CovModelVal1;
       update acc;
        
        Contact testContact = new Contact();
        testContact.FirstName ='test';
        testContact.LastName ='contact';
        testContact.Email = 'me@ca.com';
        insert testContact ;
        
        system.debug('---contact id----'+testContact);
		
        List<OpportunityContactRole> contactRoleList = new List<OpportunityContactRole>();

        OpportunityContactRole orol1 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Executive Sponsor', IsPrimary=TRUE);
        OpportunityContactRole orol2 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Economic Buyer',IsPrimary=false);
        OpportunityContactRole orol3 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Champion',IsPrimary=false);
		contactRoleList.add(orol1);
        contactRoleList.add(orol2);
        contactRoleList.add(orol3);
        insert contactRoleList;

        
        Test.startTest();
        opp.StageName =Label.Opp_Stage_Closed_Won;
        opp.ReasonField__c='Other';
        opp.Other_Win_Loss_Reason__c='Other';
        opp.Opportunity_Type__c = 'PNCV';
        opp.Competitor__c = 'Automic';
        opp.Decision_Criteria__c = 'test';
        opp.Decision_Process__c = 'test';
        opp.Metrics__c = 'test';
        opp.Identified_Pain__c = 'test';
        opp.Paper_Process__c = 'test';
        Update opp;
        
        
        opp.Competitor__c = 'Apigee';
        Update opp;
        Test.stopTest();
    }
    
	static testMethod void testCompEmailNotificationsCommercial(){
        //SystemIdUtility.skipOpportunityTriggers = true;
        
        
        testOppLineItemTriggerClass.testCreateNewOppLineItem();
        Opportunity opp = [select id,StageName,Competitor__c,ReasonField__c,Other_Win_Loss_Reason__c,Opportunity_Type__c from Opportunity limit 1];
        Account acc = [select id,segment__c,coverage_model__c from Account limit 1];
        
        
        
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        String currencyIsoCode = 'USD';
        
        acc.segment__c = Label.SegmentVal3;
        acc.coverage_model__c = Label.CovModelVal1;
        update acc;
        
        
        Contact testContact = new Contact();
        testContact.FirstName ='test';
        testContact.LastName ='contact';
        testContact.Email = 'me@ca.com';
        insert testContact ;
        
        
        
        List<OpportunityContactRole> contactRoleList = new List<OpportunityContactRole>();
        
        OpportunityContactRole orol1 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Executive Sponsor', IsPrimary=TRUE);
        OpportunityContactRole orol2 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Economic Buyer',IsPrimary=false);
        OpportunityContactRole orol3 = new OpportunityContactRole(ContactId=testContact.Id, opportunityId = opp.id, Role='Champion',IsPrimary=false);
        contactRoleList.add(orol1);
        contactRoleList.add(orol2);
        contactRoleList.add(orol3);
        insert contactRoleList;
        
        Test.startTest();
        opp.StageName =Label.Opp_Stage_Closed_Won;
        opp.ReasonField__c='Other';
        opp.Other_Win_Loss_Reason__c='Other';
        opp.Opportunity_Type__c = 'PNCV';
        opp.Competitor__c = 'Automic';
        opp.Decision_Criteria__c = 'test';
        opp.Decision_Process__c = 'test';
        opp.Metrics__c = 'test';
        opp.Identified_Pain__c = 'test';
        opp.Paper_Process__c = 'test';
        Update opp;
        
        
        opp.Competitor__c = 'Apigee';
        Update opp;
        Test.stopTest();
    } 


    static testMethod void testSendEmailNotificationMethod(){
        //SystemIdUtility.skipOpportunityTriggers = true;
        

        testOppLineItemTriggerClass.testCreateNewOppLineItem();
       Opportunity opp = [select id,StageName,Competitor__c,ReasonField__c,Other_Win_Loss_Reason__c,Opportunity_Type__c,Name,
                        Account.Name,Segment__c,closedate,CurrencyIsoCode,Amount,Owner.Name,
                        Rpt_Country__c from Opportunity limit 1];
       CompetitorNotificationLogic.sendEmail(opp,New List<Opportunity>{opp});
    }    

    
       
           
}