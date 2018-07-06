public class ConvertedCurrencyClass {
    public Map<Id,Opportunity> getConvertedCurrency(List<Opportunity> Oppty) {
        
        String LoggedInUserCurrencyType;
        Decimal conversionRate;
        Opportunity temp = new Opportunity();
        Map<Id,Opportunity> UpdatedCoversionCurrencyOpp = new Map<Id,Opportunity>();
        
        /*User LoggedInUserRec = [SELECT DefaultCurrencyIsoCode FROM User where id =: UserInfo.getUserId()];
        LoggedInUserCurrencyType = LoggedInUserRec.DefaultCurrencyIsoCode;*/
        Map<String,Decimal> mapOpptyCurrency = new Map<String,Decimal>();
        
        System.debug('Limits.getQueries()'+Limits.getQueries());
        for(CurrencyType currec: [SELECT ConversionRate, IsoCode FROM CurrencyType])
                mapOpptyCurrency.put(currec.IsoCode, currec.ConversionRate);
        System.debug('Limits.getQueries()'+mapOpptyCurrency);
        
        for(Opportunity Opp: Oppty) {
            if(Opp.Id == null) Opp.amount = 0;
            System.debug(mapOpptyCurrency.get(Opp.CurrencyIsoCode)+'______________Test Feb Release '+Opp);
            /*CurrencyType LoggedInUserCurrencyTypeRec = [SELECT ConversionRate FROM CurrencyType where IsoCode =: Opp.CurrencyIsoCode];
            conversionRate = LoggedInUserCurrencyTypeRec.ConversionRate;*/
            conversionRate = mapOpptyCurrency.get(Opp.CurrencyIsoCode);
            //Opp.TestCurrencyConvertedMRM__c = conversionRate*Opp.amount;
            //Opp.TestCurrencyConvertedMRM_Inverted__c = Opp.amount/conversionRate;
            Opp.USD_Currency_Conversion__c = Opp.amount/conversionRate;
            
           //UpdatedCoversionCurrencyOpp.put(Opp.Id,convertedCurrencyAmount);
           UpdatedCoversionCurrencyOpp.put(Opp.Id,Opp);
               
        }
        
        System.debug('UserInfo.getUserId() >> ' + UserInfo.getUserId() + 'LoggedInUserCurrencyType >> ' + LoggedInUserCurrencyType + 'conversionRate >> ' + conversionRate + 'convertedCurrencyAmount >> ' + Oppty);
        
        return UpdatedCoversionCurrencyOpp;        
        
    }
}