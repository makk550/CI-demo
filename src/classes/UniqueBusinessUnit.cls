/*
 * Test Class - TestUniqueBusinessUnit
 * Coverage - 98%
 * 
*/

public class UniqueBusinessUnit
{
    public UniqueBusinessUnit()
    {
    }
    
    public static boolean hasUpdateOpportunityRun = false;
   
    public String processOpprLineItems(List<OpportunityLineItem> oliList)
    {
        
        String drivingScbu = '';
        Map<String,Double> salesPriceUpdate = new Map<String,Double>();
        Map<Double,List<String>> SummationValue_BU_Map = new Map<Double,List<String>>();
        
        Set<String> DuplicateSummation = new Set<String>();
        
        
        //  MG 3-13-17   updated  "List<String> drivingSalesUnit" per  ProductHierarchy doc  MAR9
        //List<String> drivingSalesUnit = new List<String> {'AGILE OPERATIONS','API MANAGEMENT','AUTOMATION','CONTINUOUS DELIVERY','MAINFRAME','N/A','OTHER','PAYMENT SECURITY','PPM','SECURITY','SERVICE MANAGEMENT','WORKLOAD AUTOMATION','AUTOMIC'};
          
        //updated  drivingSalesUnit for FY19 product heirarchy changes US454353- amili01                                                    
           List<String> drivingSalesUnit = new List<String> {'AGILE CENTRAL','AGILE OPERATIONS','API MANAGEMENT','AUTOMATION',
                                                             'CONTINUOUS DELIVERY','MAINFRAME','MAINFRAME CAPACITY','N/A','OTHER',
                                                                'PAYMENT SECURITY','PPM','SECURITY','SERVICE MANAGEMENT','VERACODE' };
                                                                    
            String val;
        Double i=0.0;
        
        Set<String> uniqueBusinessUnit = new Set<String>();
        
        
        String finalUnit = '';
        String FirstValue = '';
        String highestValueBU = '';
        boolean isHighest = false;
        for(OpportunityLineItem oppLineItem : oliList)
        {
            if(oppLineItem.Business_Unit__c != null && oppLineItem.Business_Unit__c.length()>0)
            {
                System.debug(' --- Business Unit -- ' + oppLineItem.Business_Unit__c);
                uniqueBusinessUnit.add(oppLineItem.Business_Unit__c);
                System.debug(' --- uniqueBusinessUnit --- ' + uniqueBusinessUnit);
            }
            
            //Logic for highest value in Driving Sales Coverage Business Unit
            if(oppLineItem.Business_Unit__c !=null &&  oppLineItem.Business_Unit__c !='')
            {
                if(salesPriceUpdate.containsKey(oppLineItem.Business_Unit__c))
                {
                    salesPriceUpdate.put(oppLineItem.Business_Unit__c,salesPriceUpdate.get(oppLineItem.Business_Unit__c)+oppLineItem.TotalPrice);
                    System.debug(' ----- salesPriceUpdate.values() contains case --- ' + salesPriceUpdate.values());
                    System.debug(' ----- salesPriceUpdate.keyset() contains case --- ' + salesPriceUpdate.keyset());
                }
                else
                {
                    salesPriceUpdate.put(oppLineItem.Business_Unit__c,oppLineItem.TotalPrice);
                    System.debug(' ----- salesPriceUpdate.values()  --- ' + salesPriceUpdate.values());
                    System.debug(' ----- salesPriceUpdate.keyset() --- ' + salesPriceUpdate.keyset());
                }
            }
            
            
        }
        if(uniqueBusinessUnit != null)
        {
            for(String s : uniqueBusinessUnit)
            {
                if(finalUnit=='')
                    finalUnit = s;
                // "else" statement is not included as part of DE354393 - amili01
              //  else                  
              //      finalUnit+=';'+s;
                System.debug(' --- Final Business Unit after String oper ---' + finalUnit);
            }
            if (finalUnit == null)
                drivingScbu = '';
            
        }
        drivingScbu = finalUnit;
        
        for(String s:salesPriceUpdate.keySet())
        {
            
            if(salesPriceUpdate.get(s) > i)
            {
                System.debug('-----Inside the highest logic loop----');
                i = salesPriceUpdate.get(s);
                highestValueBU = s;
                isHighest = true;
            }
            else if(i == salesPriceUpdate.get(s))
            {
                System.debug('-----Inside the tie logic loop----');
                isHighest = false;
            }
            
            if(SummationValue_BU_Map.containsKey(salesPriceUpdate.get(s)))
            {
                SummationValue_BU_Map.get(salesPriceUpdate.get(s)).add(s.toUpperCase());
            }
            else
            {
                SummationValue_BU_Map.put(salesPriceUpdate.get(s),new List<String>());
                SummationValue_BU_Map.get(salesPriceUpdate.get(s)).add(s.toUpperCase());
            }
        }
        System.debug('-----SummationValue_BU_Map----'+SummationValue_BU_Map);
        
        if(isHighest)
        {
            drivingScbu = highestValueBU;
        }
        else
        {
            for(Double d:SummationValue_BU_Map.keySet())
            {
                if(SummationValue_BU_Map.get(d).size()>=2)
                {
                    DuplicateSummation.addAll(SummationValue_BU_Map.get(d));
                }
            }
            System.debug('----DuplicateSummation----'+DuplicateSummation);
            System.debug('----drivingSalesUnit-----'+drivingSalesUnit);
            for(String s:drivingSalesUnit)
            {
                //System.debug('----s----'+s);
                if(DuplicateSummation.contains(s))
                {
                    FirstValue = s;
                    System.debug('----FirstValue----'+FirstValue);
                    break;
                }
            }
            if(FirstValue !='')
                drivingScbu = FirstValue;
        }
        
        
        System.debug('----Before Update ----');
        return drivingScbu;
        
    }
    
}