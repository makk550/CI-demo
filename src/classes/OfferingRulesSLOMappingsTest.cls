@IsTest
public class OfferingRulesSLOMappingsTest {
    
    static testmethod void testingOfferingRules(){
        
        
        Map<id,integer> taskBusinessdayMap=new Map<id,integer>();                                                                                                   
        String businessHoursId=null;
        String OfferingRuleId=null;
        String caseSeverity='1';
        boolean isMileStone=false;
        boolean isSloStartDate=false;
        
        Test.startTest();
        Offering_Business_Rules__C offeringBusinessRulesIn=new Offering_Business_Rules__C();
        offeringBusinessRulesIn.Offering_Code__c='ESS GOLD TEST';
        insert offeringBusinessRulesIn;
        System.assert(offeringBusinessRulesIn.Id<>null);
        
        Offering_Feature__c offeringFeaturesIn=new Offering_Feature__c();
        offeringFeaturesIn.Case_Severity__c='2';
        offeringFeaturesIn.Offering_Business_Rules__c=offeringBusinessRulesIn.ID;
        offeringFeaturesIn.Type__c='Initial Callback';
        offeringFeaturesIn.SLO_Type__c='Standard';
        offeringFeaturesIn.Unit__c='Minutes';
        offeringFeaturesIn.SLO_Value__c='10';
        insert offeringFeaturesIn;
        
        Offering_Feature__c offeringFeaturesIn2=new Offering_Feature__c();
        offeringFeaturesIn2.Case_Severity__c='1';
        offeringFeaturesIn2.Offering_Business_Rules__c=offeringBusinessRulesIn.ID;
        offeringFeaturesIn2.Type__c='Initial Callback';
        offeringFeaturesIn2.SLO_Type__c='Standard';
        offeringFeaturesIn2.Unit__c='Minutes';
        offeringFeaturesIn2.SLO_Value__c='10';
        insert offeringFeaturesIn2;
        
        
        OfferingRuleId=offeringBusinessRulesIn.id;
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
        System.assert(bhs.size()>0,true);
        businessHoursId=(String)bhs.get(0).Id;
        System.assert(businessHoursId<>null);
        Integer hoursGap=10;
        taskBusinessdayMap.put(bhs.get(0).Id, hoursGap);
        
        Map<id,Offering_Feature__c> offeringFeaturesMap=new Map<id,Offering_Feature__c>([SELECT ID,Type__c,Case_Severity__c,SLO_Value__c,SLO_Type__c,Unit__c FROM Offering_Feature__c WHERE Offering_Business_Rules__c =:offeringFeaturesIn.Offering_Business_Rules__c and Case_Severity__c =:offeringFeaturesIn.Case_Severity__c]);    
        
        
        List<Offering_Feature__c> offeringBusinessFeaturesCombKeyList=[SELECT Type__c,ID FROM Offering_Feature__c WHERE Offering_Business_Rules__c =:offeringFeaturesIn.Offering_Business_Rules__c and Case_Severity__c =:offeringFeaturesIn.Case_Severity__c];
        Map<String, Offering_Feature__c> offeringBusinessFeaturesCombKeyMap = new Map<String, Offering_Feature__c>();
        for(Offering_Feature__c obj : offeringBusinessFeaturesCombKeyList) {
            offeringBusinessFeaturesCombKeyMap.put(obj.Type__c, obj);
        }      
        
        if(offeringBusinessFeaturesCombKeyMap.containsKey('Initial Callback')){
            OfferingRuleId=offeringBusinessFeaturesCombKeyMap.get('Initial Callback').ID;
        }
        
        Datetime businessSLoTime=OfferingRulesSLOMappings.calculateSLO(businessHoursId,OfferingRuleId,false,false,taskBusinessdayMap,offeringFeaturesMap);
        
        Map<String,String> getSevDetails=OfferingRulesSLOMappings.getSeverityDetails(OfferingRuleId,offeringFeaturesMap);
        System.assert(getSevDetails.size()>0, true);
        System.assertEquals(OfferingRulesSLOMappings.addMinutes(), '60000');
        System.assertEquals(OfferingRulesSLOMappings.addHours(), '3600000');
        System.assertEquals(OfferingRulesSLOMappings.addStandardTypeSLOStartDate(), Datetime.now());
        DateTime targTime=System.now();
        String slaValue='60';
        integer slaValue1=60;
        String minValue='Minutes';
        System.assertEquals(OfferingRulesSLOMappings.addBusinessType(businessHoursId, slaValue, minValue,true,taskBusinessdayMap), BusinessHours.addGmt(businessHoursId,targTime,(long.Valueof(slaValue)*long.Valueof(OfferingRulesSLOMappings.addMinutes()))));
        minValue='Days';                       
        System.assertNotEquals(OfferingRulesSLOMappings.addBusinessType(businessHoursId, slaValue, minValue,true,taskBusinessdayMap), OfferingRulesSLOMappings.addBusinessDays(businessHoursId,taskBusinessdayMap,slaValue));
        minValue='Minutes';
        System.assertEquals(OfferingRulesSLOMappings.addStandardType(slaValue,minValue), targTime.addMinutes(slaValue1));
        minValue='Days';
        System.assertEquals(OfferingRulesSLOMappings.addStandardType(slaValue,minValue), targTime.addDays(slaValue1));
        System.assertEquals(OfferingRulesSLOMappings.addBusinessTypeSLOStartDate(businessHoursId), BusinessHours.addGmt(businessHoursId,targTime,1));
        Test.stopTest();
    }
}