trigger HealthScoreTrigger on Opportunity (before insert, before update) 
{

//Block of code for testing MRM Req Account -> Account Converted
if(SystemIDUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration) 
    return;

    List<Opportunity> tempOppty = new List<Opportunity>();
    
    for(Opportunity opp:Trigger.new)
    {
        tempOppty.add(opp);
    }
    
    Map <Id, Opportunity> UpdatedCoversionCurrencyOpp  = new Map<Id, Opportunity>();
    Opportunity tempval = new Opportunity();
    
    System.debug('______________Enetered Here'+tempOppty);
    
    ConvertedCurrencyClass Obj = new ConvertedCurrencyClass();
    UpdatedCoversionCurrencyOpp = obj.getConvertedCurrency(tempOppty);
    
    for(Opportunity opp:Trigger.new)
    {
        if(Opp.Id <> null) {
        //if(Trigger.Isupdate) {
            tempval = UpdatedCoversionCurrencyOpp.get(Opp.Id);
            //opp.TestCurrencyConvertedMRM__c = tempval.TestCurrencyConvertedMRM__c;
            //opp.TestCurrencyConvertedMRM_Inverted__c = tempval.TestCurrencyConvertedMRM_Inverted__c;
            Opp.USD_Currency_Conversion__c = tempval.USD_Currency_Conversion__c;
            System.debug('______________Enetered Here Too'+Opp);
        }
        Date CloseDate = opp.CloseDate;
        
        Integer ClosingQuarter = CloseDate.month();
        Integer ClosingYear = CloseDate.year();
        String fyDetail = '';
        if(ClosingQuarter <= 3)
        {
            fyDetail = 'FY'+ClosingYear+' Q4';
        }
        else if(ClosingQuarter > 3 && ClosingQuarter <= 6)
        {
            fyDetail = 'FY'+(ClosingYear+1)+' Q1';        
        }
        else if(ClosingQuarter > 6 && ClosingQuarter <= 9)
        {
            fyDetail = 'FY'+(ClosingYear+1)+' Q2';        
        }
        else
        {
            fyDetail = 'FY'+(ClosingYear+1)+' Q3';        
        }
        
        String pastFYDetailStr = opp.Unique_Fiscal_Quarters__c;
        String[] detailArr = new List<String>();
        if(pastFYDetailStr!=null)
            detailArr = pastFYDetailStr.split(':');
        boolean newFYDetail = true;
        for(String entry : detailArr)
        {
            if(entry == fyDetail)
            {
                newFYDetail = false;
                break;
            }
        }
        
        if(newFYDetail)
        {
            if(pastFYDetailStr!=null)
                pastFYDetailStr = pastFYDetailStr+':'+fyDetail;
            else
                pastFYDetailStr = fyDetail;
            opp.Number_Of_Unique_Fiscal_Quarters__c = detailArr.size()+1;
            opp.Unique_Fiscal_Quarters__c=pastFYDetailStr;
        }
    }
}