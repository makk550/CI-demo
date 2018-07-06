/*
 * Class - UniqueBusinessUnit
 * Coverage - 98%
 * 
*/

@isTest
public class TestUniqueBusinessUnit {

    public static testMethod void testOppSCBU(){
        
        testOppLineItemTriggerClass.testoppLineItemwithThreeProds();
        
        
        
        List<OpportunityLineItem> oliList = [select id,Business_Unit__c,TotalPrice from
                                            OpportunityLineItem];
        system.assertNotEquals(0, oliList.size(),'No Line Items found');
        
        UniqueBusinessUnit UBU = new UniqueBusinessUnit();
        String scbu = UBU.processOpprLineItems(oliList);
        system.assertEquals('Agile Central', scbu,'Matching SCBU');
    }
    
     public static testMethod void testOppMultipleSCBU(){
        
        testOppLineItemTriggerClass.testMultipleScbuProducts();
        
        
        
        List<OpportunityLineItem> oliList = [select id,Business_Unit__c,TotalPrice from
                                            OpportunityLineItem];
        system.assertNotEquals(0, oliList.size(),'No Line Items found');
        
        UniqueBusinessUnit UBU = new UniqueBusinessUnit();
        String scbu = UBU.processOpprLineItems(oliList);
        system.assertEquals(true, String.isNotBlank(scbu),'Matching SCBU');
    }
}