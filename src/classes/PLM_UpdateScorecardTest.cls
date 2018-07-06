/** Class Name: PLM_RevenueTableOnScorecardTest
    Date: 7/13/2010
    Project/Requirement: CA PRM Phase 1/PLM
    Author: Accenture
    Description: This class is test class for PLM_UpdateScorecard
**/

@isTest
private class PLM_UpdateScorecardTest{
    
    //new scorecard
    static testMethod void testScorecardNew(){
        PLM_UpdateScorecard ins = new PLM_UpdateScorecard();
        
        String techAccRecTypeId;
        String valAccRecTypeId;
        //getting account record types by using schema
        Map<String, Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String, Schema.RecordTypeInfo>();
        //retrive account object record types
        mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoTech = mapRecTypeInfoAcc.get('Technology Partner');
        Schema.RecordTypeInfo recTypeInfoVal = mapRecTypeInfoAcc.get('Reseller/Distributor Account');
        techAccRecTypeId  = recTypeInfoTech.getRecordTypeId();
        valAccRecTypeId  = recTypeInfoVal.getRecordTypeId();
        
        //insert account
        Account a = new Account();
        a.Name = 'TEST';
        a.Customer_Category__c = 'Reseller';
        a.Country_Picklist__c = 'IN - INDIA';
        a.GEO__c = 'Asia-Pacific';
        a.Secondary_Account_Type__c = 'Technology';
        a.RecordTypeId = techAccRecTypeId;

        insert a;
        
        //insert contact
        Contact c = new Contact();
        c.LastName = 'TEST';
        c.AccountId = a.Id;

        insert c;

        //insert accreditation
        List<Accreditation__c> listACD = new List<Accreditation__c>();
        Accreditation__c acd;
        for(Integer i=0;i<5;i++){
            acd = new Accreditation__c();
            acd.Contact_Name__c = c.Id;
            acd.Partner__c = a.Id;
            acd.Sales_Course_Technical_Exam__c = 'Sales Course';
            listACD.add(acd);
        }

        for(Integer i=0;i<5;i++){
            acd = new Accreditation__c();
            acd.Contact_Name__c = c.Id;
            acd.Partner__c = a.Id;
            acd.Sales_Course_Technical_Exam__c = 'Technical Exam';
            listACD.add(acd);
        }

        insert listACD;
        
        PLM_UpdateScorecard.updateScorecard(a.Id);
    }

    //existing scorecard
    static testMethod void testScorecardEx(){
        PLM_UpdateScorecard ins = new PLM_UpdateScorecard();
        
        String techAccRecTypeId;
        String valAccRecTypeId;
        //getting account record types by using schema
        Map<String, Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String, Schema.RecordTypeInfo>();
        //retrive account object record types
        mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
        //get Ids of record type by passing name of record type.
        Schema.RecordTypeInfo recTypeInfoTech = mapRecTypeInfoAcc.get('Technology Partner');
        Schema.RecordTypeInfo recTypeInfoVal = mapRecTypeInfoAcc.get('Reseller/Distributor Account');
        techAccRecTypeId  = recTypeInfoTech.getRecordTypeId();
        valAccRecTypeId  = recTypeInfoVal.getRecordTypeId();
        
        //insert account
        Account a = new Account();
        a.Name = 'TEST';
        a.Customer_Category__c = 'Reseller';
        a.Country_Picklist__c = 'IN - INDIA';
        a.GEO__c = 'Asia-Pacific';
        a.Secondary_Account_Type__c = 'Technology';
        a.RecordTypeId = techAccRecTypeId;

        insert a;
        
        //insert contact
        Contact c = new Contact();
        c.LastName = 'TEST';
        c.AccountId = a.Id;

        insert c;

        //insert accreditation
        List<Accreditation__c> listACD = new List<Accreditation__c>();
        Accreditation__c acd;
        for(Integer i=0;i<5;i++){
            acd = new Accreditation__c();
            acd.Contact_Name__c = c.Id;
            acd.Partner__c = a.Id;
            acd.Sales_Course_Technical_Exam__c = 'Sales Course';
            listACD.add(acd);
        }

        for(Integer i=0;i<5;i++){
            acd = new Accreditation__c();
            acd.Contact_Name__c = c.Id;
            acd.Partner__c = a.Id;
            acd.Sales_Course_Technical_Exam__c = 'Technical Exam';
            listACD.add(acd);
        }

        insert listACD;

        Scorecard__c sc = new Scorecard__c();
        sc.Partner__c = a.Id;
        insert sc;
        
        PLM_UpdateScorecard.updateScorecard(a.Id);
    }
}