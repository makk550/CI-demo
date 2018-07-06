/*
 * Test class for ARRandDurationCalculation Class.
 * Created by BAJPI01.
 * Coverage = 91%
 * Uses testCreateAccOppandLineItemClass class to create account, opportunity and line items, without using seealldata = true, but skips triggers.
*/

@isTest
public class ARRandDurationCalculationTest {
    
    static testmethod void testARRMethod(){
        Opportunity opp;
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        Set<Opportunity> OppSet = oppAndLineItemMap.keySet();
        for(Opportunity tempOpp:Oppset){
            Opp = tempOpp;
        }
        List<OpportunityLineItem> OppItmList = oppAndLineItemMap.get(Opp);
		
        Map<id,Boolean> unitPriceChangedMap = new Map<id,Boolean>();
        Integer count=0;
        
        for(OpportunityLineItem oli:OppItmList){
           
            oli.Duration_Days__c = 10;
            
            oli.Term_Month__c = ARRandDurationCalculation.monthsbetweendates(opp.Start_Date__c, opp.End_Date__c);
            if(count==0){
                unitPriceChangedMap.put(oli.id,true);
            	count=1;
            }
            else{
                unitPriceChangedMap.put(oli.id,false);
            	count=0;
            }
                
        }
        opp.End_Date__c = ARRandDurationCalculation.populateEndDate(OppItmList, opp.Start_Date__c);
        
        OppItmList = ARRandDurationCalculation.updateopplineitempartner(OppItmList, opp.Start_Date__c);
       
        oppAndLineItemMap.clear();
        oppAndLineItemMap.put(opp, OppItmList);
        OppItmList = ARRandDurationCalculation.getopplineitemlist(oppAndLineItemMap);
    }

}