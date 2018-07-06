/**

Class Name: Renewals_UpdateExchangeRatesController
Author: Accenture
Description: Controller class of Renewals_UpdateExchangeRates that can be used to update exchange rate 
             of renewal currency table based on the selected fiscal year and date.  
*/

public class Renewals_UpdateExchangeRatesController {

    public Renewal_Currency__c  renCurrFiscalYear{set;get;}
    //We can used the Expected Close Date to display a Date input field on the page with datepicker
    public Renewal__c renDateField {set;get;}
    public  Map<String,Id> renCurr = new Map<String,Id>();
    public Renewals_UpdateExchangeRatesController(){
      renCurrFiscalYear = new Renewal_Currency__c();
      renDateField = new Renewal__c();
    }
    
    public void updateExchange(){
    
     Map<String,Double> currencyWithConversionRate = new Map<String,Double>();  
       
     //find all the currency conversion rate for selected date
     if(renDateField.Expected_Close_Date__c !=NULL){ 
       List<DatedConversionRate> lstDCR = [Select NextStartDate 
                                       From DatedConversionRate  
                                       where NextStartDate <=:renDateField.Expected_Close_Date__c 
                                       order by NextStartDate desc limit 1];

       if(lstDCR.isEmpty()) return;
       
       //create a map of isocode with conversion rate for selected date                                 
       for(DatedConversionRate dc:[SELECT StartDate, 
                                          NextStartDate,
                                          IsoCode, Id, 
                                          ConversionRate 
                                     FROM DatedConversionRate 
                                     WHERE StartDate =:lstDCR[0].NextStartDate]){
        currencyWithConversionRate.put(dc.IsoCode,dc.ConversionRate); 
      }
     }
     

     //find all the currency type for the selected fiscal year
     if(!currencyWithConversionRate.isEmpty()){ 
       List<Renewal_Currency__c> lstToUpsert = new List<Renewal_Currency__c>();
      
       
       for(Renewal_Currency__c renC:[SELECT CurrencyIsoCode,Fiscal_Year__c,Conversion_Rate__c 
                                     FROM Renewal_Currency__c
                                     WHERE Fiscal_Year__c =: renCurrFiscalYear.Fiscal_Year__c]){
             renCurr.put(renC.CurrencyIsoCode,renC.Id);   
       }
       for(String stdCurrency:currencyWithConversionRate.KeySet()){
          Renewal_Currency__c ren = new Renewal_Currency__c();
          
          //if currency code alreay exist for that fiscal year get the record id
          if(renCurr.containsKey(stdCurrency)){
              ren = ren = new Renewal_Currency__c(Id=renCurr.get(stdCurrency));
          }else{
               ren.Name = stdCurrency + ' - '+ renCurrFiscalYear.Fiscal_Year__c;
          }
          
          //assign new values
          ren.Conversion_Rate__c = currencyWithConversionRate.get(stdCurrency);
          lstToUpsert.add(ren);
       }
       if(!lstToUpsert.isEmpty()) Database.upsert(lstToUpsert);
     }
    }
    
    public static testMethod void Renewals_UpdateExchangeRatesControllerTest(){
      Renewals_UpdateExchangeRatesController ctrl = new Renewals_UpdateExchangeRatesController();
      ctrl.renCurrFiscalYear.Fiscal_Year__c = '2013';
      ctrl.renDateField.Expected_Close_Date__c = System.today();
      
     /*Renewal_Currency__c rc = [SELECT CurrencyIsoCode,Fiscal_Year__c,Conversion_Rate__c
     FROM Renewal_Currency__c    WHERE Fiscal_Year__c =: ctrl.renCurrFiscalYear.Fiscal_Year__c limit 1];*/
      
      Renewal_Currency__c rc = new Renewal_Currency__c(CurrencyIsoCode='AED',Conversion_Rate__c=3.22,Fiscal_Year__c=ctrl.renCurrFiscalYear.Fiscal_Year__c);
      Insert rc;
      
      
      ctrl.renCurr.put(rc.CurrencyIsoCode,rc.id);   
      ctrl.updateExchange();
    }

}