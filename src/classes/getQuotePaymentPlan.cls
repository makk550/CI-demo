public class getQuotePaymentPlan{
    public Payment_Plan__c[] options {get; private set;}
    public SBQQ__Quote__c quote {get; private set;}
    public String QuoteID;
    public String getQuoteID()
    {
        return quoteID;
    }
    public void setQuoteID(String q)
    {
        QuoteID = q;
        getPaymentPlanForQuote();
    }

    public void getPaymentPlanForQuote() {
        try
        {
           options = [SELECT Date__c, License_Amount__c, License_Amount_Formatted__c, Maintenance_Amount__c, Maintenance_Amount_Formatted__c, Subscription_Amount__c, Subscription_Amount_Formatted__c, Amount__c, Amount_Formatted__c, CurrencyIsoCode FROM Payment_Plan__c Where Quote__c = :quoteID];
        quote = [SELECT SBQQ__NetAmount__c, CurrencyIsoCode, Payment_Schedule_Total__c FROM SBQQ__Quote__c Where Id = :quoteID];
    
        for(Payment_Plan__c plan : options){
            
            plan.Amount_Formatted__c = formatCurrency(plan.Amount__c, plan.CurrencyIsoCode);
            plan.License_Amount_Formatted__c = formatCurrency(plan.License_Amount__c, plan.CurrencyIsoCode);
            plan.Maintenance_Amount_Formatted__c= formatCurrency(plan.Maintenance_Amount__c, plan.CurrencyIsoCode);
            plan.Subscription_Amount_Formatted__c= formatCurrency(plan.Subscription_Amount__c, plan.CurrencyIsoCode);                                    
        }
      
        quote.SBQQ_NetAmount_Formatted__c = formatCurrency(quote.SBQQ__NetAmount__c, quote.CurrencyIsoCode);      
           
            
        }
        catch (Exception e) { }
    }
     public static String formatCurrency(Decimal amount, String currencyType){
        
        String formattedAmount = '';
        
        if(amount!=null){
            amount = amount.setScale(2);
            
            formattedAmount = amount.format();
            
            if(!formattedAmount.contains('.')){
                
                formattedAmount = formattedAmount + '.00';
            }
            
            List<String> splitMoney = formattedAmount.split('\\.');
            
            if(splitMoney.size() == 2){
                
                String cents = splitMoney[1];
                
                if(cents.length() == 1){
                    
                    formattedAmount = formattedAmount+'0';
                    
                }
                
            }   
            
            if(currencyType.equalsIgnoreCase('EUR')){
                
                formattedAmount = formattedAmount.replace(',', ' ');
                
                formattedAmount = formattedAmount.replace('.', ',');
                
            }
            
            if(currencyType.equalsIgnoreCase('GBP')){
                
                formattedAmount = formattedAmount.replace(',', ' ');
                
                formattedAmount = formattedAmount.replace('.', ',');
                
            }
            
            
            
            if(currencyType.equalsIgnoreCase('JPY') || currencyType.equalsIgnoreCase('KRW') ){
                
                List<String> split = formattedAmount.split('\\.');
                
                formattedAmount = split[0];
                
            }
        }
        
        
        return currencyType+' '+formattedAmount;
        
    }
}