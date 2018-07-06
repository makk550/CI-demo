@isTest(seeAllData=true)
private class ValidatingNonContractOfferingsTest{

    static testmethod void validateNCRTest(){
  
        Test.startTest();
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
        
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='CA Product';
        insert prodCtl;      
        
        Offering_Business_Rules__C offeringBusinessRulesObj=new Offering_Business_Rules__C();
        offeringBusinessRulesObj.Offering_Code__c='ESSGOLD';
        insert offeringBusinessRulesObj;
        
        Non_Contract_Offering_Business_Rules__c nonContractOffering = new Non_Contract_Offering_Business_Rules__c();
        nonContractOffering.Site_Association__c=testSiteAssociation.Id;
        nonContractOffering.CA_Product_Controller__c = prodCtl.Id;
        nonContractOffering.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        nonContractOffering.Start_Date__c = Date.today();
        nonContractOffering.End_Date__c = Date.today().addDays(2);   
        Database.SaveResult result = Database.insert(nonContractOffering, false);
        System.assertEquals(true,result.isSuccess());
        
        Non_Contract_Offering_Business_Rules__c nonContractOffering2 = new Non_Contract_Offering_Business_Rules__c();
        nonContractOffering2.Site_Association__c=testSiteAssociation.Id;
        nonContractOffering2.CA_Product_Controller__c = prodCtl.Id;
        nonContractOffering2.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        nonContractOffering2.Start_Date__c = Date.today();
        nonContractOffering2.End_Date__c = Date.today().addDays(2);       
        Database.SaveResult result1 = Database.insert(nonContractOffering2, false);  
        
        System.assertEquals('There is a Non Contract Offering already with this combination',result1.getErrors()[0].getMessage()); 
            
        Test.stopTest();
    
    }
        
        
}