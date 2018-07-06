public class getQuoteLinesForQuote {

    // 8 - 14 -2017 Chad Borer Code Zero
    // Used with QuoteLinesForQuote Component and CPQ Advanced Approvals VisualForce email templates
    // Displays all applicable Quote Lines 

    public String Quote;
    
    public Map<Id, String> discountMap {get; set;}
    public Map<Id, String> vDiscountMap {get; set;}
    public Map<Id, String> mUnitMap {get; set;}
    public Map<Id, String> nTotalMap {get; set;}
    
    public String getQuote()
    {
        return quote;
    }
    public void setQuote(String q)
    {
        Quote = q;
        getQuoteLinesForQuote();
    }
    
    public List <SBQQ__QuoteLine__c> QuoteLines;

    public void getQuoteLinesForQuote() {
        try
        {
            discountMap = new Map<Id, String>();
            vDiscountMap = new Map<Id, String>();
            mUnitMap = new Map<Id, String>();
            nTotalMap = new Map<Id, String>();
            
            QuoteLines = [select Quantity_Output_Document__c, Partner_Discount_Percentage__c, Change_Quantity_Output_Document__c, Approval_Threshold_Percentages__c, Monthly_Unit_Price__c, End_Date__c, 
            Start_Date__c, Volume_Discount_Price_form__c, SBQQ__ProductName__c, SBQQ__Quantity__c, Disc_Vol_Adj_form_final__c, Discount_Template_Form__c, SBQQ__TotalDiscountAmount__c, 
            SBQQ__NetTotal__c, Reason_for_Disc__c, Competitor_name__c, Product_Discount_Reason__c, SBQQ__Quote__r.CurrencyIsoCode from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quote AND SBQQ__ProductCode__c != null ];

            for (SBQQ__QuoteLine__c ql : QuoteLines){
                discountMap.put(ql.id, QuotePaymentPlans.formatCurrency(ql.SBQQ__TotalDiscountAmount__c, ql.SBQQ__Quote__r.CurrencyIsoCode));
                vDiscountMap.put(ql.id, QuotePaymentPlans.formatCurrency(ql.Volume_Discount_Price_form__c, ql.SBQQ__Quote__r.CurrencyIsoCode));
                mUnitMap.put(ql.id, QuotePaymentPlans.formatCurrency(ql.Monthly_Unit_Price__c, ql.SBQQ__Quote__r.CurrencyIsoCode));
                nTotalMap.put(ql.id, QuotePaymentPlans.formatCurrency(ql.SBQQ__NetTotal__c, ql.SBQQ__Quote__r.CurrencyIsoCode));
                
            }
            
            
        }
        catch (Exception e) { }
    }
    
    public List <SBQQ__QuoteLine__c> getQuoteLines() {
        return quotelines;
    }

}