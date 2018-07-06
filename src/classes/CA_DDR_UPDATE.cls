public class CA_DDR_UPDATE {

    public Id ddrId {get; set;}

    public CA_DDR_UPDATE() {
        ddrId = ApexPages.currentPage().getParameters().get('id');
        system.debug('DDR Id:::'+ddrId);       
    }
    
    public pageReference updateDDR() {
        system.debug('DDR Id:::'+ddrId);
        Deal_Desk_Review__c agr = [Select Id,Agreement__c, Deal_Desk_Review__c.Create_Agreement__c from Deal_Desk_Review__c where Id =: ddrId];
        agr.Create_Agreement__c = true;
        update agr;
        Deal_Desk_Review__c agrr = [Select Id,Agreement__c, Deal_Desk_Review__c.Create_Agreement__c from Deal_Desk_Review__c where Id =: ddrId];
        PageReference pg;
        System.debug('agreement__c is:'+agrr.Agreement__c);
        if(agrr.Agreement__c!=null)
        {
          pg = new PageReference('/'+agrr.Agreement__c);  
            pg.setRedirect(true);
        }
        else{
          pg = new PageReference('/'+ddrId);
          pg.setRedirect(true);
        
        }
        return pg;
   
   
    }
        
}