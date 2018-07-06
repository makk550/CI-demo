public class SecQuoteExtController {
    public String QuoteId{get;set;}
    public SecQuoteExtController (ApexPages.StandardController standardPageController){
        
		QuoteId = ApexPages.currentPage().getParameters().get('Id');
        
    }
    
    public PageReference returnToQuote(){
        PageReference pr = new PageReference('/' + QuoteId);
  
   		return pr;
    }

}