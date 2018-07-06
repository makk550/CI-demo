@isTest
public class SupportThresholdCalculatorTest {
    
    static Map<String,id> busHrsIdMap = new Map<String,id>();    
    
    static testmethod void testThresholdCalc(){
        system.runAs(TestCaseHandler.createDataUser()){
            TestCaseHandler.createTestData();
        }
        
        system.runAs(TestCaseHandler.supportUser){            
            Test.StartTest();             
            Case case1 = TestCaseHandler.prepareCase('3'); 
            insert case1;   
            case1.Severity__c = '1';
            case1.Sev_1_Impact_c__c = 'Test';
            case1.Production_Down_Status__c = 'Test';
            update case1;
            
            Map<id, String> siteCountryMap = CaseGateway.siteCntryMap;
            List<BusinessHours> busHrsList = new List<BusinessHours>();
            
            if(siteCountryMap.size()>0)
                busHrsList = [select id,Name from Businesshours where name in: siteCountryMap.values()];

            for(BusinessHours bhRec:busHrsList)
                busHrsIdMap.put(bhRec.Name,bhRec.id);
            
            SupportThresholdCalculator sptCalcObj = new SupportThresholdCalculator();
            SupportThresholdCalculator.performThresholdCalculations(case1, null, busHrsIdMap);
            SupportThresholdCalculator.performThresholdCalculationsonSevChange(case1, null, busHrsIdMap);
            SupportThresholdCalculator.addBusinessTartgetTime(System.now(), 1, 10, false);
            SupportThresholdCalculator.addBusinessTartgetTime(null, 2, 10, true);
            SupportThresholdCalculator.addStandardTargetTime(System.now(), 2, 10, true);
            SupportThresholdCalculator.addStandardTargetTime(null, 2, 10, false);
            SupportThresholdCalculator.resetManagerActionFields(case1);
            SupportThresholdCalculator.clearThresholdValues(case1);
            SupportThresholdCalculator.performThresholdCalculations(case1, null, busHrsIdMap);
            SupportThresholdCalculator.performThresholdCalculationsonSevChange(case1, null, busHrsIdMap);
            
            Test.stopTest();
        }
    }

}