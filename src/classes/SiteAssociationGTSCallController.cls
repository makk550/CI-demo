public class SiteAssociationGTSCallController {
 
    // Constructor - this only really matters if the autoRun function doesn't work right
    private final Site_Association__c o;
    public SiteAssociationGTSCallController(ApexPages.StandardController stdController) {
        this.o = (Site_Association__c)stdController.getRecord();
    }
    public string theId{get;set;}
     public boolean AlertPage=false;
    // Code we will invoke on page load.
    public PageReference autoRun() {
 
        theId = ApexPages.currentPage().getParameters().get('id');
        
        for(Site_Association__c site : [select SC_SITE_Sanctioned_Party__c,id from Site_Association__c where id=:theId ])
        {
        if(site.SC_SITE_Sanctioned_Party__c=='YES' || site.SC_SITE_Sanctioned_Party__c=='NO')
        {
        ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.info,'Site has already been validated. Please contact Legal.');
        ApexPages.addMessage(myMsg);
        }
        else
        {
        SiteAssociationHandler.doSanctionedPartyCheck(theId);
        ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.info,'Sanctioned Party check has been submitted.  This may take a few minutes to complete.  Please refresh the Site later.');
        ApexPages.addMessage(myMsg);
        
        }
        }
        
        return null;
      }
 
    
    public PageReference GoBack(){
    PageReference pageRef = new PageReference('/' + theId);
    pageRef.setRedirect(true);
    return pageRef;

    }
 
}