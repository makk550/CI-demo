public with sharing class CZQIQuoteCalculator {     
    
    public void calculate(QuoteModel quote, String callbackClass) {
        QuoteCalculatorContext ctx = new QuoteCalculatorContext(quote, callbackClass);
        SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(ctx));    
    }    
    
    private class QuoteCalculatorContext {        
        private QuoteModel quote;
        private String callbackClass;        
        
        private QuoteCalculatorContext(QuoteModel quote, String callbackClass) {
            this.quote = quote;            
            this.callbackClass = callbackClass;        
        }
    } 
}