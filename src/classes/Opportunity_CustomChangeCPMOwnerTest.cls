@isTest
private class Opportunity_CustomChangeCPMOwnerTest {
   
		 @isTest static void InsertOpportunity() {
        
            
            testOpportunityTriggersClass.createNewOpportunity();
            
            SystemIdUtility.skipAccount = true;
            SystemIdUtility.skipAccountOnMIPSUpdate = true;    
            FutureMethod_Assign_support_Generic.isFutureRunning = false;
            SystemIdUtility.skipProductTriggers = true;
            
            Account acc = [select id,Alliance__c from Account limit 1];
            acc.Alliance__c = true;
            update acc;
            
            Opportunity opp = [select id,Name,AccountId,CloseDate,stageName,Type,Inside_Outside__c,Contract_Type__c,CurrencyIsoCode,
                                Partner_Engagement_Phase_2__c,Alliance_Partner_2__c from Opportunity limit 1];

            
            opp.Partner_Engagement_Phase_2__c='Implementation';
            opp.Alliance_Partner_2__c=acc.Id;

            update opp;
           
       
       
            ApexPages.currentPage().getParameters().put('view', '00B30000007guQf');
            ApexPages.currentPage().getParameters().put('records', opp.Id);
		
       
        ApexPages.StandardController testPage = new ApexPages.StandardController(opp);
        Opportunity_CustomChangeCPMOwner ctrl = new Opportunity_CustomChangeCPMOwner(testPage);        
        PageReference pageRef = new PageReference('Opportunity_CustomChangeCPMOwner');
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        
        ctrl.save();
        ctrl.cancel();
        Test.stopTest();
 
    }
}