@isTest
public class DismissReminderOpportunityControllerTest {
      
    @isTest static void testclickdismissreminder(){
        
        testOpportunityTriggersClass.createNewOpportunity();

        Opportunity opp = [select id,Name,Transaction_Type__c,Contract_Type__c,CloseDate,CurrencyIsoCode,Inside_Outside__c,stageName,
                           AccountId, Deal_Review__c from Opportunity limit 1];

        
        PageReference ref = new PageReference('/apex/OpportunityViewOverride?id= :opp.Id');
		Test.setCurrentPage(ref);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp);
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        DismissReminderOpportunityController disremider = new DismissReminderOpportunityController(sc);
        PageReference temppageref=disremider.clickdismissreminder();
        
        
    }
}