@isTest(seeAllData=false)
private class ValidatingOfferingFeaturesTest {
    
    static testmethod void testingOfferingFeatures(){
        Test.startTest();
        Offering_Business_Rules__C offeringBusinessRulesIn=new Offering_Business_Rules__C();
        offeringBusinessRulesIn.Offering_Code__c='ESS GOLD';
        insert offeringBusinessRulesIn;
        
        Offering_Feature__c offeringFeaturesIn=new Offering_Feature__c();
        offeringFeaturesIn.Case_Severity__c='2';
        offeringFeaturesIn.Offering_Business_Rules__c=offeringBusinessRulesIn.ID;
        offeringFeaturesIn.Type__c='Initial Callback';
        offeringFeaturesIn.SLO_Type__c='Standard';
        offeringFeaturesIn.Unit__c='Minutes';
        offeringFeaturesIn.SLO_Value__c='10';
        insert offeringFeaturesIn;    
        
        Offering_Feature__c offeringFeaturesIn2=new Offering_Feature__c();
        offeringFeaturesIn2.Case_Severity__c='2';
        offeringFeaturesIn2.Offering_Business_Rules__c=offeringBusinessRulesIn.ID;
        offeringFeaturesIn2.Type__c='Initial Callback';
        offeringFeaturesIn2.SLO_Type__c='Standard';
        offeringFeaturesIn2.Unit__c='Minutes';
        offeringFeaturesIn2.SLO_Value__c='10';
        Database.SaveResult result = Database.insert(offeringFeaturesIn2, false);
        System.assertEquals(System.Label.Offering_Feature_Validation,result.getErrors()[0].getMessage());
       
        Offering_Feature__c offeringFeaturesIn3=new Offering_Feature__c();
        offeringFeaturesIn3.Case_Severity__c='3';
        offeringFeaturesIn3.Offering_Business_Rules__c=offeringBusinessRulesIn.ID;
        offeringFeaturesIn3.Type__c='Initial Callback';
        offeringFeaturesIn3.SLO_Type__c='Standard';
        offeringFeaturesIn3.Unit__c='Minutes';
        offeringFeaturesIn3.SLO_Value__c='10';
        insert offeringFeaturesIn3;
        
        offeringFeaturesIn.Case_Severity__c='3';
        Database.SaveResult result1 = Database.update(offeringFeaturesIn, false);
        System.assertEquals(System.Label.Offering_Feature_Validation,result1.getErrors()[0].getMessage());
       }
}