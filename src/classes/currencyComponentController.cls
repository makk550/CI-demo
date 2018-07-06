public class currencyComponentController {
    public Decimal value {get; set;}
    public String currencyIsoCode {get; set;}
    public Account_Plan3__c hacked {
        get {
            Account_Plan3__c hack = new Account_Plan3__c();
            if (currencyIsoCode != null) {
                hack.CurrencyIsoCode = currencyIsoCode;
            }
            hack.Capex_Budget__c = value;
            return hack;
        }
    }
}