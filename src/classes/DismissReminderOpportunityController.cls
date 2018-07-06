public class DismissReminderOpportunityController {
    private Opportunity myopportunity;
    private ApexPages.StandardController controller {get; set;}
  
    public DismissReminderOpportunityController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
         myopportunity = [SELECT Id, Opportunity_Number__c, Create_Alert__c FROM Opportunity 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
       

    }
	public PageReference clickdismissreminder(){
        System.debug('myopportunity value'+ myopportunity);
        myopportunity.Create_Alert__c = False;
  		update myopportunity;
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
		pageRef.setRedirect(true);
		return pageRef;
    }
}