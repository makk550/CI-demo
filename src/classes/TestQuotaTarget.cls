@istest
private class TestQuotaTarget
{
    public static testMethod void TestQuotaTargetTrigger()
    {
    
       
       Quota_Target__c ht = new Quota_Target__c();
       insert ht;
        
        ht.Region__c = 'NA';
        update ht; 
    
    
    }

}