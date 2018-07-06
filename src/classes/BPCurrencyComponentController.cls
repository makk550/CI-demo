public class BPCurrencyComponentController {
    public Decimal value {get; set;}
    public String currencyIsoCode {get; set;}
    public Business_Plan_New__c hacked {
        get {
            Business_Plan_New__c hack = new Business_Plan_New__c();
            if (currencyIsoCode != null) {
                hack.CurrencyIsoCode = currencyIsoCode;
            }
            hack.GTM_SP_Q2__c = value;
            return hack;
        }
    }
}