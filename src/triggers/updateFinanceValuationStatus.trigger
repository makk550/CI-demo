trigger updateFinanceValuationStatus on Opportunity (before update) {
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
            return;
    
    Map<Id, List<OpportunityLineItem>> mapopli = new Map<Id, List<OpportunityLineItem>>();
    Set<Id> setOpp = new Set<Id>();
    List<Opportunity> listOpp = trigger.new;
    List<Opportunity> listOpps = new List<Opportunity>();
    Map<Id,Date> opplist = new Map<Id,Date>();
   

    for(Opportunity opp: listOpp)
    {
        setOpp.add(opp.id);
    }
    List<OpportunityLineItem> listOppLI = [Select Id, Active_Contract_Product__r.Active_Contract__r.Status_Formula__c, Active_Contract_Product__c,Active_Contract_Product__r.Dismantle_Date__c, OpportunityId from OpportunityLineItem where OpportunityId in: setOpp and (Business_Type__c = 'Renewal' or Active_Contract_Product__c!=null) ORDER BY Active_Contract_Product__r.Dismantle_Date__c DESC];
    System.debug('***listOppLI ---'+listOppLI );
    //ADDED BY SAMTU01 - US302066
    for(OpportunityLineItem opplst : listOppLI)
    {
        if(opplst.Active_Contract_Product__c!=null)
        opplist.put(opplst.OpportunityId,opplst.Active_Contract_Product__r.Dismantle_Date__c);
    }
    System.debug('***opplist---'+opplist);
    for(Opportunity opps:listopp){
            if(opps.Opportunity_Type__c!=null && opps.Opportunity_Type__c.contains('Renewal'))
                listOpps.add(opps);
    
    }
    for(Opportunity oppty:listopps){
         
         if(opplist.size()>0){
                   DateTime createddate = Datetime.newInstance(2017, 6, 16); //Modified by SAMTU01 - US386137
                  if(oppty.CreatedDate > createddate && oppty.CloseDate + 1 > opplist.get(oppty.id) && oppty.Expiration_Reason__c==null && OpportunityHandler.renewalToOppConversion != true){ //Modified by SAMTU01 - US386137
                   oppty.addError('Please select Expiration reason field in Renewals Information section');    
             
             }
      }       
    
    } //ADDED BY SAMTU01 - US302066 --ends here
    
    for(OpportunityLineItem oppli : listOppLI)
    {
        List<OpportunityLineItem> newlistOppLI = mapopli.get(oppli.OpportunityId);
        if(newlistOppLI==null)
        {
            newlistOppLI = new List<OpportunityLineItem>();
            mapopli.put(oppli.OpportunityId, newlistOppLI);      
        }
        newlistOppLI.add(oppli);
    }
    
    if(trigger.isupdate && trigger.isbefore)
    {
        for(Opportunity opp: trigger.new)
        {
            Set<String> status_value = new Set<String>();
            Boolean isValidated = true;
            List<OpportunityLineItem> oppli_list = mapopli.get(opp.id);
            if(oppli_list != null && oppli_list.size() > 0){
                for(OpportunityLineItem ol: oppli_list){
                    status_value.add(ol.Active_Contract_Product__r.Active_Contract__r.Status_Formula__c);
                }
            }
            if(status_value != null && status_value.size() > 0){
                System.debug('status_value - '+status_value);     
                if(status_value.contains('In Progress') || status_value.contains('Assigned') || status_value.contains('In Scope')){
                    isValidated =  false;   
                }
                opp.Finance_Valuation_Status__c = (isValidated?'Validated':'Not Validated');
                system.debug(opp.Finance_Valuation_Status__c);
            }else if(opp.Finance_Valuation_Status__c != null && opp.Finance_Valuation_Status__c != ''){
                opp.Finance_Valuation_Status__c = '';
            }           
        }
    }
}