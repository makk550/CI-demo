public class DueDateandMilestoneCalculator {
    
    static DateTime targTime=System.now();
    public static String conMilli='60000';
    public static DateTime calculateSLOMileStone(String caseSeverity,String BusinessHoursId,Map<id,integer> taskBusinessdayMap,String milestoneValue,Boolean isSLOStartDate,String offeringCode,Datetime offeringDueDate){
        DateTime targetDateTime=null;
        String caseSevName='Severity'+caseSeverity;
        System.debug('caseSevName-->'+caseSevName);
        if(offeringCode<>null){
            targetDateTime= getMileStoneValue(offeringDueDate,milestoneValue);
        }else{
             if(!isSLOStartDate){
                targetDateTime=calculateDueDateandMilestone(milestoneValue,caseSevName,caseSeverity,BusinessHoursId,taskBusinessdayMap);        
            }else{
                targetDateTime=sloStartDateValue(caseSeverity,BusinessHoursId,taskBusinessdayMap);
            }      
        }
        return targetDateTime;
    }
    
    public static DateTime sloStartDateValue(String caseSeverity,String BusinessHoursId,Map<id,integer> taskBusinessdayMap){
        Datetime tempSLODate=null;
        if(caseSeverity=='1'){
            tempSLODate= targTime; 
        }else{
            tempSLODate=BusinessHours.addGmt(BusinessHoursId,targTime,1); 
        }
        return tempSLODate; 
    }
    
    public static String getCustomSettingValue(String customSettingName){
        System.debug('customSettingName-->Second-->'+customSettingName);
        System.debug('SLO_Milestones__c.getValues(customSettingName):'+SLO_Milestones__c.getValues(customSettingName));
        System.debug('SLO_Milestones__c.getValues(customSettingName).Due_Date_SLO__c:'+SLO_Milestones__c.getValues(customSettingName).Due_Date_SLO__c);
        return SLO_Milestones__c.getValues(customSettingName).Due_Date_SLO__c;
    }
    
    public static DateTime addBusinessTime(String BusinessHoursId,String customSettingName,String caseSeverity,Map<id,integer> taskBusinessdayMap){
        Datetime tempDate=null;
        if(caseSeverity=='4'){
            tempDate=BusinessHours.addGmt(BusinessHoursId,targTime,((long)(taskBusinessdayMap.get(BusinessHoursId)))*long.Valueof(addHours()));
        }else if(caseSeverity==system.label.sealNumberOfDays){//Made changes as part of SEAL User Story #US389744 for initial call back to be 5 days
             tempDate=BusinessHours.addGmt(BusinessHoursId,targTime,((long)(taskBusinessdayMap.get(BusinessHoursId)*Integer.valueOf(system.label.proactiveCaseSLODays))*long.Valueof(addHours())));
        }
        else{
            tempDate=BusinessHours.addGmt(BusinessHoursId,targTime,(long.Valueof(getCustomSettingValue(customSettingName))*long.Valueof(addHours())));
        }
        return tempDate;
    }
    
    public static DateTime addStandardTime(String customSettingName){
        System.debug('customSettingName-->'+customSettingName);
        
        return targTime.addMinutes(Integer.Valueof(getCustomSettingValue(customSettingName)));
    }
    
    public static Datetime getMileStoneValue(Datetime targetDueDateSLO,String milestoneValue){
        if(milestoneValue.equals('2')){
            targetDueDateSLO=targetDueDateSLO.addMinutes(-45);
        }else if(milestoneValue.equals('3')){
            targetDueDateSLO=targetDueDateSLO.addMinutes(-30);
        }else if(milestoneValue.equals('4')){
            targetDueDateSLO=targetDueDateSLO.addMinutes(-15);
        }
        return targetDueDateSLO;
    }
    
    public static Datetime getMileStoneValue(String BusinessHoursId,String customSettingName,String caseSeverity,Map<id,integer> taskBusinessdayMap,String milestoneValue,Datetime targetDueDateSLO){
        if(milestoneValue.equals('3'))
        {
            targetDueDateSLO = BusinessHours.addGmt(BusinessHoursId,targetDueDateSLO, (long.valueOf('-30'))*long.Valueof(conMilli));
        }
        else if(milestoneValue.equals('2'))
        {
            targetDueDateSLO = BusinessHours.addGmt(BusinessHoursId,targetDueDateSLO, (long.Valueof('-45')*long.Valueof(conMilli)));
        }
        return targetDueDateSLO;
    }
    
    public static DateTime calculateDueDateandMilestone(String milestoneValue,String caseSevName,String caseSeverity,String businessHoursId,Map<id,integer> taskBusinessdayMap){
       DateTime temptargetDateTime=null;
        System.debug('caseSeverity-->'+caseSeverity);
        if(caseSeverity=='1'){              
            temptargetDateTime=addStandardTime(caseSevName);
        }else{
            temptargetDateTime=addBusinessTime(businessHoursId,caseSevName,caseSeverity,taskBusinessdayMap);           
        }
        if(milestoneValue<>null){
             if(caseSeverity=='1'){              
            temptargetDateTime= getMileStoneValue(temptargetDateTime,milestoneValue);  
        }
            else if(milestoneValue.equals('4')){
            temptargetDateTime= getMileStoneValue(temptargetDateTime,milestoneValue);  
        }
            else if(milestoneValue.equals('3') || milestoneValue.equals('2'))
            {
                temptargetDateTime = getMileStoneValue(businessHoursId,caseSevName,caseSeverity,taskBusinessdayMap,milestoneValue,temptargetDateTime);
            }
        }
        return temptargetDateTime;
    }
    
    public static String addHours(){
        String conSecond='3600000';//60*60*1000-->For Adding Hours
        return conSecond;
    }
}