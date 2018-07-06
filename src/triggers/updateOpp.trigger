trigger updateOpp on Quote_Reporting__c (after insert,after update) {
  
  
  
  /*// ---------- The following code was added for CR: 193720506 ---------- (begin)
  // Trigger.new does not contain the data of fields in related objects so we must query it
  Map<Id, Decimal> quoteToRate = new map<Id, Decimal>();
  for (Quote_Reporting__c quote : [SELECT Id, Opportunity__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c 
                                     FROM Quote_Reporting__c
                                     WHERE Id IN :trigger.new 
                                         AND Opportunity__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c != null 
                                         AND Opportunity__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c != 0
                                         AND Primary_Quote__c = True] )
  {
        System.debug('quote-->'+quote);
        quoteToRate.put(quote.Id, quote.Opportunity__r.Renewal__r.Renewal_Currency__r.Conversion_Rate__c);                                      
  }                                  
  // -------------------------------------------------------------------- (End)*/
  
  
    
  List<Opportunity> opplist = new List<Opportunity>();
  for(Quote_Reporting__c q:Trigger.new ){
    if(q.Primary_Quote__c == True)
    {
      Opportunity opp = new Opportunity(id=q.Opportunity__c);
      opp.New_Annual_Time__c = (q.Total_ATTRF__c * q.Realization_Rate__c )/100; 
      opp.RR_Percentage__c = q.Realization_Rate__c;    
      opp.New_TRR__c = q.New_TRR__c; 
      opp.TRR_Percentage__c = q.TRRPercent__c;
      
      
      /*// ---------- The following code was added for CR: 193720506 ---------- (begin)
      Decimal conversionRate = quoteToRate.get(q.Id);
      if(conversionRate != null)
      {
        if(opp.New_TRR__c != null)
          opp.New_TRR_USD__c = opp.New_TRR__c / conversionRate;
        if(opp.New_Annual_Time__c != null)
          opp.New_Annual_Time_USD__c = opp.New_Annual_Time__c / conversionRate;
      }
      // -------------------------------------------------------------------- (End)*/
      
      opplist.add(opp);
    } 
  }    
  update opplist;
}