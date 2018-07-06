@isTest
public class OppLineitem_View_Edit_PRM_Test {
    
    public static testMethod void createTestData(){
       
        testOppLineItemTriggerClass.testServicesSupportEducation();
        
        Opportunity opp = [select id from opportunity limit 1];
        List<OpportunityLineItem> oli = [select id,OpportunityId,Partner_Sales_Price__c from OpportunityLineItem where OpportunityId =:opp.id];
        
        
        PageReference opplinewpage1 = Page.OppLineitem_View_Edit;
        opplinewpage1.getParameters().put('retURL',opp.Id);
        opplinewpage1.getParameters().put('id',oli[0].Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(oli[0]);
        OppLineitem_View_Edit_controller_PRM opplicontroller1 = new OppLineitem_View_Edit_controller_PRM(stdcon1);
        opplicontroller1.updateproduct();
        opplicontroller1.dodelete();
        opplicontroller1.docancel();
        
        PageReference opplinewpage2 = Page.OppLineitem_View_Edit;
        opplinewpage2.getParameters().put('retURL',opp.Id);
        opplinewpage2.getParameters().put('id',oli[1].Id);
        Test.setCurrentPage(opplinewpage2);
        ApexPages.StandardController stdcon2 = new ApexPages.StandardController(oli[1]);
        OppLineitem_View_Edit_controller_PRM opplicontroller2 = new OppLineitem_View_Edit_controller_PRM(stdcon2);
        opplicontroller2.updateproduct();
        
        PageReference opplinewpage3 = Page.OppLineitem_View_Edit;
        opplinewpage3.getParameters().put('retURL',opp.Id);
        opplinewpage3.getParameters().put('id',oli[3].Id);
        Test.setCurrentPage(opplinewpage3);
        ApexPages.StandardController stdcon3 = new ApexPages.StandardController(oli[3]);
        OppLineitem_View_Edit_controller_PRM opplicontroller3 = new OppLineitem_View_Edit_controller_PRM(stdcon3);
        opplicontroller3.updateproduct();

    }    
    
}