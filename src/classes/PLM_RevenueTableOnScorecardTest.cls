/**
Class Name: PLM_RevenueTableOnScorecardTest
Date: 7/13/2010
Project/Requirement: CA PRM Phase 1/PLM
Author: Accenture
Description: This class is test class for PLM_RevenueTableOnScorecard
*/

@isTest
private class PLM_RevenueTableOnScorecardTest{
    
    static testMethod void testRevenue(){
        
        Date rDate = Date.newInstance(2010,4,1);
        Double amount = 100;
        String techAccRecTypeId;
        String scRTypeId;
        //getting account record types by using schema
        Map<String, Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String, Schema.RecordTypeInfo>();
        //retrive account object record types 
        mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoTech = mapRecTypeInfoAcc.get('Technology Partner');
        techAccRecTypeId  = recTypeInfoTech.getRecordTypeId();

        //getting account record types by using schema
        Map<String, Schema.RecordTypeInfo> mapRecTypeInfoSC = new Map<String, Schema.RecordTypeInfo>();
        //retrive account object record types
        mapRecTypeInfoSC = Schema.SObjectType.Scorecard__c.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoTechSC = mapRecTypeInfoSC.get('Technology Partner Scorecard');
        scRTypeId  = recTypeInfoTechSC.getRecordTypeId();
        
        //insert account. Will also cover the class PLM_AccountPercentCompleteForPartner
        Account a = new Account();
        a.Name = 'TEST';
        a.Customer_Category__c = 'Reseller';
        a.Country_Picklist__c = 'IN - INDIA';
        a.GEO__c = 'Asia-Pacific';
        a.Secondary_Account_Type__c = 'Technology';
        a.RecordTypeId = techAccRecTypeId;
		a.Completion_of_NDA__c = 'Completed';
		a.Completion_of_Partner_Agreement__c = 'Completed';
		a.Completion_of_DLA__c = 'Completed';
		a.BU_Approval__c = 'Completed';
		a.Completion_of_Product_Integration__c = 'Completed';
		a.Partner_BU_Agree_to_proceed_Develop__c = 'Completed';
		a.Partner_s_Webpage_linked_to_CA_Products__c = 'Completed';
		a.Completion_of_Validation__c = 'Completed';
		a.Completion_of_a_Self_Running_Demo__c = 'Completed';
		a.Completion_of_Collateral_for_Solution__c ='Completed';
		a.Partner_BU_Agree_to_proceed_Validate__c = 'Completed';
		a.Completion_of_Partner_Spotlight__c = 'Completed';
		a.Completion_of_Solution_Catalog_Submissio__c = 'Completed';
		a.Completion_of_a_Press_Release__c = 'Completed';
		a.Completion_of_Customer_Success_Story__c='Completed';
		a.Completion_of_Three_References_of_the_In__c ='Completed';        
        insert a;                

        //insert revenues
        List<Revenue__c> rList = new List<Revenue__c>();
        Revenue__c r;
        for(Integer i=0;i<12;i++){
          r = new Revenue__c();
          r.Distributor__c = a.Id;
          r.Local_Revenue__c = amount;
          r.Functional_Business_Unit__c = 'TEST';
          r.Date__c = rDate.addMonths(i);
          rList.add(r);
        }
        Revenue__c exceptionCase = new Revenue__c();
        exceptionCase.Distributor__c = a.Id;
        exceptionCase.Local_Revenue__c = amount;
        exceptionCase.Functional_Business_Unit__c = null;
        exceptionCase.Date__c = rDate;
        rList.add(exceptionCase);

        insert rList;

        Scorecard__c sc = new Scorecard__c();
        sc.Partner__c = a.Id;
        sc.RecordTypeId = scRTypeId;
        insert sc;

        PageReference p = new PageReference('/' + sc.Id);
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('Id', sc.Id);   
        ApexPages.StandardController controller = new ApexPages.StandardController(sc);
        PLM_RevenueTableOnScorecard ins = new PLM_RevenueTableOnScorecard(controller);
        ins.getRevenues();
    }
}