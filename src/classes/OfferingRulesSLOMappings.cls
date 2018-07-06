public class OfferingRulesSLOMappings {
    
    static DateTime targTime=System.now();
    
    public static Datetime calculateSLO(String businessHoursId,String OfferingFeaturesId,boolean isMileStone,boolean isSloStartDate,Map<id,integer> taskBusinessdayMap,Map<Id,Offering_Feature__c> offeringBusinessRulesMap){
        Datetime finalBusinessDateTimeValue=null;
        Map<String,String> sevRelatedMap= getSeverityDetails(OfferingFeaturesId,offeringBusinessRulesMap);
        if(sevRelatedMap.size()>0){
            if(businessHoursId<>null && sevRelatedMap.get('SEV_SLO_TYPE')=='Business'){                
                if(isSloStartDate){
                    finalBusinessDateTimeValue=addBusinessTypeSLOStartDate(businessHoursId);
                }else{
                    finalBusinessDateTimeValue=addBusinessType(businessHoursId,sevRelatedMap.get('SEV_SLO_VALUE'),sevRelatedMap.get('SEV_SLO_UOM'),isMileStone,taskBusinessdayMap);   
                }
            }else{
                if(isSloStartDate){
                    finalBusinessDateTimeValue=addStandardTypeSLOStartDate();  
                }else{
                    finalBusinessDateTimeValue=addStandardType(sevRelatedMap.get('SEV_SLO_VALUE'),sevRelatedMap.get('SEV_SLO_UOM'));
                }                        
            }   
        }
        return finalBusinessDateTimeValue;  
    }    
    
    public static Datetime addBusinessType(String businessHoursId,String slaValue,String uomType,boolean isMileStone,Map<id,integer> taskBusinessdayMap){
        Datetime businessDateTimeValue=null;
        if(isMileStone){
            businessDateTimeValue =BusinessHours.addGmt(businessHoursId,targTime,(long.Valueof(slaValue)*long.Valueof(addMinutes())));
        }else{
            if(uomType=='Minutes'){
                businessDateTimeValue=BusinessHours.addGmt(businessHoursId,targTime,(long.Valueof(slaValue)*long.Valueof(addMinutes())));
            }else if(uomType=='Days'){               
                businessDateTimeValue=addBusinessDays(businessHoursId,taskBusinessdayMap,slaValue);                
            }            
        }       
        return businessDateTimeValue;
    }
    
    public static Datetime addBusinessTypeSLOStartDate(String businessHoursId){
        Datetime businessDateTimeValue=BusinessHours.addGmt(businessHoursId,targTime,1);
        return businessDateTimeValue;
    }
    
    public static Datetime addStandardType(String slaValue,String uomType){
        Datetime standardDateTimeValue=null;
        if(uomType=='Minutes'){
            standardDateTimeValue=targTime.addMinutes(Integer.Valueof(slaValue));   
        }else if(uomType=='Days'){
            standardDateTimeValue=targTime.addDays(Integer.Valueof(slaValue));    
        } 
        return standardDateTimeValue;  
    }
    
    public static Datetime addStandardTypeSLOStartDate(){
        Datetime standardDateTimeValue=targTime;
        return standardDateTimeValue;  
    }
    
    public static Map<String,String> getSeverityDetails(String offerringBusinessfeaturesId,Map<Id,Offering_Feature__c> offeringBusinessRulesMap){
        Map<String,String> sevRelatedMap=new Map<String,String>();       
        sevRelatedMap.put('SEV_SLO_VALUE', offeringBusinessRulesMap.get(offerringBusinessfeaturesId).SLO_Value__c); 
        sevRelatedMap.put('SEV_SLO_TYPE', offeringBusinessRulesMap.get(offerringBusinessfeaturesId).SLO_Type__c);
        sevRelatedMap.put('SEV_SLO_UOM',offeringBusinessRulesMap.get(offerringBusinessfeaturesId).Unit__c);
        return sevRelatedMap;
    }
    
    public static String addMinutes(){
        String conMilli='60000';//60*1000-->For adding Minutes
        return conMilli;
    }
    
    public static String addHours(){
        String conSecond='3600000';//60*60*1000-->For Adding Hours
        return conSecond;
    }
    
    public static Datetime addBusinessDays(String businessHoursId,Map<id,integer> taskBusinessdayMap,String slaValue){
        long businessHoursGap=(long)taskBusinessdayMap.get(businessHoursId); 
        long noofDaysEntered=long.Valueof(slaValue);
        long finalDayswithBusinessHours= businessHoursGap*noofDaysEntered;
        return BusinessHours.addGmt(businessHoursId,targTime,(finalDayswithBusinessHours*long.Valueof(addHours())));        
    }
    
}