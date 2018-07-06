trigger ddr_Rules on DDR_Rules__c (before insert)
{
    System.assertEquals(Trigger.size, 1, 'attempting to insert more than one DDR Rule record');
    
    List<DDR_Rules__c> ruleList = [SELECT Id FROM DDR_Rules__c LIMIT 1];
    System.assertEquals(ruleList.isEmpty(), true);
}