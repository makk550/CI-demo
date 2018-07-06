/*
 This class has been created as part of ARR requirements for 
FY18 by BAJPI01 for US311600,US266282,US312941,US311530,US311565,US311085.
Its called by various other classes to Calculate ARR, the months between start and end
date, Populate End Date on Opportunity, update line items, as the case maybe.

Test Class =ARRandDurationCalculationTest
Coverage = 91%
*/
public class ARRandDurationCalculation {
    
    public static List<OpportunityLineItem> opplineitemstoupdate;
    
    public static List<OpportunityLineItem> getopplineitemlist(Map<Opportunity,List<OpportunityLineItem>> oppandlineitemmap){
        List<OpportunityLineItem> opplineitemslist = new List<OpportunityLineItem>();
        if(oppandlineitemmap.size()>0){
            for(Opportunity opp:oppandlineitemmap.keySet()){
                List<OpportunityLineItem> lineitemlist = new List<OpportunityLineItem>();
                lineitemlist = oppandlineitemmap.get(opp);
                if(lineitemlist.size()>0){
                    for(OpportunityLineItem oli:lineitemlist){
                        oli.Start_Date__c = opp.Start_Date__c;
                        oli.End_Date__c = opp.Start_Date__c.addMonths(Integer.valueOf(oli.Term_Month__c));
                        oli.End_Date__c = oli.End_Date__c.addDays(-1);
                        oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
                         
                    }
                    opplineitemslist.addAll(lineitemlist);
                }
            }
        }
        return opplineitemslist;
    }
    
    //calculates the month b/w two given dates. This is the same formula used to calculate term for Sterling Quotes.
    public static Decimal monthsbetweendates(Date startdate, Date enddate){
        decimal n = 0.00;
        
        if(startdate!=null && enddate!=null){
            
            if( StartDate.month()== EndDate.month() && StartDate.year()== EndDate.year() )
            {
                n =  decimal.valueOf((StartDate.daysBetween(EndDate) + 1 )) / decimal.valueOf(date.daysInMonth(StartDate.year(),StartDate.month()));
                System.debug('---N----'+n);
            }
            else
            {
                Integer monthsBetween = StartDate.monthsBetween(EndDate)-1;
                System.debug('---monthsBetween----'+monthsBetween);
                
                decimal firstMonth = decimal.valueOf(date.daysInMonth(StartDate.year() , StartDate.month())-StartDate.day()+1) 
                    / decimal.valueOf(date.daysInMonth(StartDate.year(), StartDate.month()));
                System.debug('---firstMonth----'+firstMonth);
                
                decimal lastMonth =  decimal.valueOf(EndDate.toStartOfMonth().daysBetween(EndDate)+1)  
                    / decimal.valueOf(date.daysInMonth(EndDate.year(), EndDate.month()));
                System.debug('---lastMonth----'+lastMonth);
                
                
                n =  firstMonth + monthsBetween + lastMonth; 
                System.debug('---N----'+n);
                
                
            }
            if(n<0.5 && n!=0)
                n=1;
            n = n.round(System.RoundingMode.HALF_UP);
        }
        
        
        return n;
    }
	
    //populates end date on opp header. Takes the start date of opp, and uses the max term of line item, to get max end date.
	public static Date populateEndDate(List<OpportunityLineItem> olilist, Date oppStartDate){
		Date maxEndDate;
		Integer maxterm=0;
        
        if(olilist.size()>0){
            for(OpportunityLineItem oli:olilist){
                if(oli.term_month__c>maxterm)
                    maxterm = Integer.valueOf(oli.term_month__c);
            }
            maxEndDate = oppStartDate.addMonths(maxterm);
            maxEndDate = maxEndDate.addDays(-1);
            return maxEndDate;
        }
        else{
            return null;
        }
		
		
	}
    
    //takes start date of opp, and uses it to populate start and end date on opplineitems, when a deal reg or partner opp is converted to internal opp.
    public static List<OpportunityLineItem> updateopplineitempartner(List<OpportunityLineItem> olilist, Date startdate){
        if(olilist.size()>0){
            for(OpportunityLineItem oli:olilist){
                oli.Start_Date__c = startdate;
                oli.End_Date__c = startdate.addMonths(Integer.valueOf(oli.Term_Month__c));
                oli.End_Date__c = oli.End_Date__c.addDays(-1);
                
                oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
                
            }
        }
        
        return olilist;
    }
	
}