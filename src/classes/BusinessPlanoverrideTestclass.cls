@isTest
public class BusinessPlanoverrideTestclass {
    @isTest
    public static void testclass(){
        Business_Plan_New__c bp = new Business_Plan_New__c();
        ApexPages.StandardController sc = new ApexPages.standardController(bp);
        BusinessPlanEditoverrideController e = new BusinessPlanEditoverrideController(sc);
    }
}