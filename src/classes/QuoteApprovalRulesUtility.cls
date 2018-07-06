public with sharing class QuoteApprovalRulesUtility {
    
    public static Double getWeightedAverage(List<QuoteLineItem> quoteLineItemList) {
        Double returnValue = 0;        

        for(QuoteLineItem temp : quoteLineItemList) 
        {
            if(temp.Additional_Discount__c > returnValue)
            {
                returnValue = temp.Additional_Discount__c;
            }
        }
        return returnValue;
    }
    
    public static Double getTotalPrice(List<QuoteLineItem> quoteLineItemList) {
        Double totalSalesPrice = 0;
        Double totalDiscountPrice = 0;
        
        
        for(QuoteLineItem temp : quoteLineItemList) {
            totalSalesPrice = totalSalesPrice + (temp.UnitPrice * temp.Quantity);
            Double disc1 = 0;
            Double disc2 = 0;
            Double totalDisc = 0;
            if(temp.Additional_Discount__c == null || temp.Additional_Discount__c == 0)
                disc2 = 0;
            else    
                disc2 = temp.Additional_Discount__c;
            if(temp.Discount_1__c == null || temp.Discount_1__c == 0)
                disc1 = 0;
            else    
                disc1 = temp.Discount_1__c;
            totalDisc = ((decimal.valueOf(disc1)/100)+(decimal.valueOf(disc2)/100)-(decimal.valueOf(disc1)*decimal.valueOf(disc2))/10000)*100;    
            //totalDisc = disc1 + disc2;
            if(totalDisc != 0) {
                totalDiscountPrice = totalDiscountPrice + temp.UnitPrice * temp.Quantity * (totalDisc * 0.01);
            }                        

        }
     
        return totalSalesPrice - totalDiscountPrice;
        
    } 

    //PRM 5 - Added an extra parameter ,isCOTerm at the end
    
    public static Id isEligible(Quote q, List<Quote_Approval_Rule_Matrix__c> ruleList, Map<Id,String> qid_CSU_map, Map<Id,Opportunity> qId_opp_map,Boolean isCOTerm) {

    System.debug('SKG isCOTerm - ' + isCOTerm);    

     if(isCOTerm == true)   // This section is executed when a quote has just coterm line items with 0 additional discount
       for(Quote_Approval_Rule_Matrix__c tempRule : ruleList) {

                    if(isRTMValid(qId_opp_map.get(q.Id),tempRule.RTM__c)) {
                        if(String.isBlank(tempRule.Product_Group__c) || qid_CSU_map.get(q.Id) == tempRule.Product_Group__c) {
                            if(isRegionValid(qId_opp_map.get(q.Id),tempRule.Territory_Region__c)) {
                                if(isAreaValid(qId_opp_map.get(q.Id),tempRule.Area__c)) {
                                    if(isTerritoryValid(qId_opp_map.get(q.Id),tempRule.Territory_Country__c)) {
                                        if(isCountryValid(qId_opp_map.get(q.Id),tempRule.Country__c)) {
                                        return tempRule.Id;
                                        }
                                    }
                                }
                            }
                        }
                    }   
            }       


     if(isCOTerm == false)   //This section is executed when a quote has mixture or coterm line items and quote line items or just quote line items with not 0 additional discount
        for(Quote_Approval_Rule_Matrix__c tempRule : ruleList) {

             if(q.Weighted_Average_Additional_Discount__c >= tempRule.Additional_Discount_From__c &&
               q.Weighted_Average_Additional_Discount__c <= tempRule.Additional_Discount_To__c) {   
                if(q.Total_Price__c >= tempRule.Amount_From__c &&
                   q.Total_Price__c <= tempRule.Amount_To__c) {
                    if(isRTMValid(qId_opp_map.get(q.Id),tempRule.RTM__c)) {
                        if(String.isBlank(tempRule.Product_Group__c) || qid_CSU_map.get(q.Id) == tempRule.Product_Group__c) {
                            if(isRegionValid(qId_opp_map.get(q.Id),tempRule.Territory_Region__c)) {
                                if(isAreaValid(qId_opp_map.get(q.Id),tempRule.Area__c)) {
                                    if(isTerritoryValid(qId_opp_map.get(q.Id),tempRule.Territory_Country__c)) {
                                        if(isCountryValid(qId_opp_map.get(q.Id),tempRule.Country__c)) {
                                        return tempRule.Id;
                                        }
                                    }
                                }
                            }
                        }
                    }   
                 }   
              }  
            }       
        return null;
    }
    
    public static boolean isRegionValid(Opportunity opp, String region) {
        //System.debug('opp.Reseller__r.GEO__c---------'+opp.Reseller__r.GEO__c);
        if(opp.Rpt_Region__c == region)
            return true;
        return false;
    }
    
    public static boolean isAreaValid(Opportunity opp, String area) {
        //System.debug('opp.Reseller__r.Sales_Area__c---------'+opp.Reseller__r.Sales_Area__c);
        if(String.isBlank(area))
            return true;
        if(opp.Rpt_Area__c == area)
            return true;
        return false;
    }
    
    public static boolean isTerritoryValid(Opportunity opp, String territory) {
       // System.debug('opp.Reseller__r.Sales_Region__c---------'+opp.Reseller__r.Sales_Region__c);
        if(String.isBlank(territory))
            return true;
        if(opp.Rpt_Territory_Country__c == territory)
            return true;
        return false;
    }
    
    public static boolean isCountryValid(Opportunity opp, String country) {
        //System.debug('opp.Reseller__r.Region_Country__c---------'+opp.Reseller__r.Region_Country__c);
        if(String.isBlank(country))
            return true;
        if(opp.Rpt_Country__c == country)
            return true;
        return false;
    }
    
    
    public static boolean isRTMValid(Opportunity opp, String rtm) {
        if(rtm == 'Alliance' && opp.Reseller__r.Alliance__c)
            return true;
        if(rtm == 'Solution Provider' && opp.Reseller__r.Solution_Provider__c)
            return true;
        if(rtm == 'Service Provider' && opp.Reseller__r.Service_Provider__c)
            return true;
        return false;   
    }
}