/*************************************************************
Class covered: oppLineItemDeleteOverride
Coverage: 92%
************************************************************/

@isTest
public class oppLineItemDeleteOverrideTest {

    public static testMethod void createTestLineItemData(){
        
        testCreateQuoteAndQuoteLine.createTestData();
        
        OpportunityLineItem opplineitem = [select id from OpportunityLineItem limit 1];
        system.assertNotEquals(null, opplineitem.id, 'OpportunityLineItem not found.');
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opplineitem);
        
        PageReference tpageRef = Page.oppLineItemDeleteOverridePage;
        Test.setCurrentPage(tpageRef);
        
        oppLineItemDeleteOverride lineItemContrl = new oppLineItemDeleteOverride(stdCtrl);
        
        PageReference pf = lineItemContrl.backtoOpp();
        pf = lineItemContrl.doDelete();
        
	}
    
    public static testMethod void createDeleteableLineItem(){
        
        testOppLineItemTriggerClass.testCreateNewOppLineItem();
        
         OpportunityLineItem opplineitem = [select id from OpportunityLineItem limit 1];
        system.assertNotEquals(null, opplineitem.id, 'OpportunityLineItem not found.');

        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(opplineitem);
        
        PageReference tpageRef = Page.oppLineItemDeleteOverridePage;
        Test.setCurrentPage(tpageRef);
        
        oppLineItemDeleteOverride lineItemContrl = new oppLineItemDeleteOverride(stdCtrl);
        
        PageReference pf = lineItemContrl.backtoOpp();
        pf = lineItemContrl.doDelete();

        
    }
}