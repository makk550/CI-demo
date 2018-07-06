@istest
private class TestHeadcountTarget
{
    public static testMethod void TestHeadcountTrigger()
    {
    
        HeadCount_Target__c ht = new HeadCount_Target__c();
        insert ht;
        
        ht.Region__c = 'NA';
        update ht; 
    
    
    }

}