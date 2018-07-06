public class preSalesDirectorRedirectionController {
    @TestVisible
    Id presalesId;
    @TestVisible
    Presales_request__c presalerecord;
    public preSalesDirectorRedirectionController(){
            
    }
    public pagereference redirectpage(){
        presalesId = ApexPages.currentPage().getParameters().get('id');
        presalerecord = new Presales_request__c();
        if(presalesId!=null)
	        presalerecord = [select id,action__c from presales_request__c where id=:presalesId];
        PageReference pg;
        if(presalerecord.Action__c=='Cancel')
            pg = new PageReference('/apex/RemoveByPresalesDirectorPage?id='+presalesId+'&'+'cancelApprove'+'='+'true');
        else if(presalerecord.Action__c=='Remove')
            pg = new PageReference('/apex/RemoveByPresalesDirectorPage?id='+presalesId);
        else if(presalerecord.Action__c=='Add'||presalerecord.Action__c=='New')
            pg = new PageReference('/apex/PreSalesEditpage?id='+presalesId);
        else
            pg = new PageReference('/'+presalesId);
        
        system.debug('-------page---------'+pg+presalerecord.Action__c);

        pg.setRedirect(true);
        Return pg;
    }
        
}