public with sharing class QuotePaymentPlans {
    public Payment_Plan__c[] options {get; private set;}
    public SBQQ__Quote__c quote {get; private set;}
    public Boolean showLicenseAmount {get;private set;}
    public Boolean showMaintenanceAmount {get;private set;}
    public Boolean showSubscriptionAmount {get;private set;}
    
    public QuotePaymentPlans() {
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        options = [SELECT Date__c, Amount__c, License_Amount__c, Maintenance_Amount__c, Subscription_Amount__c, CurrencyIsoCode FROM Payment_Plan__c Where Quote__c = :quoteId];
        quote = [SELECT SBQQ__NetAmount__c, CurrencyIsoCode, Payment_Schedule_Total__c FROM SBQQ__Quote__c Where Id = :quoteId];
        
        for(Payment_Plan__c plan : options){
            if (plan.License_Amount__c == 0) {
                showLicenseAmount = false;
            } else {
                showLicenseAmount = true;
            }
            
            if (plan.Maintenance_Amount__c == 0) {
                showMaintenanceAmount = false;
            } else {
                showMaintenanceAmount = true;
            }
            
            if (plan.Subscription_Amount__c == 0) {
                showSubscriptionAmount = false;
            } else {
                showSubscriptionAmount = true;
            }
            
            plan.Amount_Formatted__c = formatCurrency(plan.Amount__c, plan.CurrencyIsoCode);
            plan.Subscription_Amount_Formatted__c = formatCurrency(plan.Subscription_Amount__c, plan.CurrencyIsoCode);
            plan.Maintenance_Amount_Formatted__c = formatCurrency(plan.Maintenance_Amount__c, plan.CurrencyIsoCode);
            plan.License_Amount_Formatted__c = formatCurrency(plan.License_Amount__c, plan.CurrencyIsoCode);
            
        }
        
        quote.SBQQ_NetAmount_Formatted__c = formatCurrency(quote.SBQQ__NetAmount__c, quote.CurrencyIsoCode);
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