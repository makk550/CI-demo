public class QuoteLineItemEdit_Ext {
    
    public pageReference redirectToCPMS()
    {
        id vId = ApexPages.currentPage().getParameters().get('Id');
        string retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        if(vId != null)
        {
            QuoteLineItem qli = [Select QuoteId, Quote.currencyInOpp__c, Quote.RegionInOpp__c,Quote.OpportunityId, Is_Co_Term_LineItem__c FROm QuoteLineItem Where id =:vId  ];
          
            PageReference p;
            User u = [Select id, PMFKey__c, accountid from user where id=:Userinfo.getUserId()];
            String PMFKey = u.PMFKey__c;
            if( PMFKey == null || PMFKey.length()== 0 ){
                PMFKey = 'genus01';
            }
          String cLabelURL = Label.EditCotermURL;
          String SFDCEnvForCPMS = Label.SFDCEnvForCPMS;
            if(qli.Is_Co_Term_LineItem__c )
                 p= new PageReference(cLabelURL+'?step=5&PMFKey='+PMFKey+'&RetUrl='+ SFDCEnvForCPMS +'&SFDC=1&SFDCOpportunityID='+ qli.Quote.OpportunityId + '&SFDCQuoteID=' +qli.QuoteId + '&CoTerm=2&SFDCQuoteLineItem=' + qli.Id+'&RegionID='+qli.Quote.RegionInOpp__c+'&OppCurrencyID='+qli.Quote.currencyInOpp__c);
            else
                 p= new PageReference('/' + qli.id + '/e?nooverride=1&retURL='+retURL);
                     
            p.setRedirect(true);
            return p;
            
        }
        return null;
    }    

    public QuoteLineItemEdit_Ext(ApexPages.StandardController controller) 
    {

    }

}