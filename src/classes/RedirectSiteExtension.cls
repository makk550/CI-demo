public class RedirectSiteExtension {
	public Site_Association__c site;
    public boolean showDetail{get;set;}
    public RedirectSiteExtension(ApexPages.StandardController controller) {
        site = (Site_Association__c)controller.getRecord();
    }

    public pageReference redirectSite(){
        String param = ApexPages.currentPage().getParameters().get('nooverride');
        if (Label.TPC_Profile_Id != NULL && UserInfo.getProfileId() == String.valueOf(Label.TPC_Profile_Id)) {
            User communityUser = [select id,contact.TPC_Team__c,contact.TPC_Team__r.Tops_Site_Id__c from user where id=: UserInfo.getUserId()];
            Site_Association__c validSite=[SELECT id,SC_TOPS_ID__c FROM SITE_ASSOCIATION__C WHERE id=:site.Id];
            if(communityUser.contact.TPC_Team__c !=null && communityUser.contact.TPC_Team__r.Tops_Site_id__c.contains(validSite.SC_TOPS_ID__c) ){
                showDetail = true;
              	return NULL; 
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Sorry You dont have permission to see this.');
                ApexPages.addMessage(myMsg);
                showDetail = false;
                return null;
            }
        }
        else{
            pageReference ref = new PageReference('/'+site.Id+'?nooverride=1');
            ref.setRedirect(false);
            return ref;
        }
    }
}