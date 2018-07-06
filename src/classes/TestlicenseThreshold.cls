@isTest(SeeAllData=true)
public class TestlicenseThreshold { 
    public static testMethod void testMethodlicenseThreshold (){
        test.startTest();
        licenseThreshold l= new licenseThreshold();
        l.thresholdCheck();
        l.send();
        test.stopTest();
    }
    
}