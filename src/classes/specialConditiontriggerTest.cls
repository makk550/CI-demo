@isTest(seeAllData=true)
private class specialConditiontriggerTest {

    
    public static testMethod void  testspecialCondition(){
        
        Account testAccount = new Account();
        testAccount.Name = 'TestAutoAssignOffering'; 
        testAccount.Enterprise_ID__c = '7777777777';
        testAccount.BillingStreet='Street';
        testAccount.BillingCountry='US';
        testAccount.BillingCity='Islandia'; 
        insert testAccount ; 
        
        Site_Association__c testSiteAssociation = new Site_Association__c();
        testSiteAssociation.Name = 'Test Site';
        testSiteAssociation.SAP_Site_ID__c = '280125';
        testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
        testSiteAssociation.Enterprise_ID__c = testAccount.Id;
        testSiteAssociation.SC_TOPS_ID__c = '1299636';
        testSiteAssociation.Country_picklist__c= 'US - UNITED STATES';
        testSiteAssociation.State__c='New York';
        testSiteAssociation.ProviSite__c = 1;
        insert testSiteAssociation ;
        
        Special_Conditions__c sc = new Special_Conditions__c();
        sc.Site_Association__c =  testSiteAssociation.Id;
        sc.Start_Date__c = Date.today();
        sc.End_Date__c = Date.today()+2;
        sc.Active__c =true;
        sc.Special_Condition__c = 'Condition: Escalation in Progress ( Max 3 Mos.)';
        
        insert sc;
        
        sc.Active__c  =false;
        update sc;
        
        delete sc;
        
    }
}