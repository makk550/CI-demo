public class SupportThresholdCalculator {
    
    public static Map<ID,Support_Thresholds__c> supportThresholdMap=new Map<ID,Support_Thresholds__c>([SELECT ID,Calculation_Method__c,Case_Severity__c,SE_Actions__c,Threshold_Notification__c,Threshold_Notification_Hours__c,Threshold_Notification_Minutes__c,
                                                                                                       Threshold_Time__c,Threshold_Time_Hours__c,Threshold_Time_Minutes__c,Troubleshooting_Stage__c,Type__c,UniqueIdentifier__c FROM Support_Thresholds__c
                                                                                                      ]);
    
    public static List<Support_Thresholds__c> supportThresholdList = supportThresholdMap.values();
    public static Map<String,Id> stageKeyMap = new Map<String,Id> ();
    public static Support_Thresholds__c sptRef=null;
    public static String sptKey=null;
    public static String busHrsId=null;
    static DateTime currentTime=System.now();
    
    public static void initialize(Case caseRec,Set<id> seactionsRef,Map<String,id> busHrsIdMapRef){
        for(Support_Thresholds__c spt : supportThresholdList){
            stageKeyMap.put(spt.Troubleshooting_Stage__c+'-'+spt.Case_Severity__c+'-'+spt.SE_Actions__c,spt.ID);
        }
        //US203673 - Implement Case Time Zones for Callback SLOs
        busHrsId= CaseGateway.fetchBusinessHoursId(caseRec, busHrsIdMapRef);
        //busHrsId= busHrsIdMapRef.get(CaseGateway.siteCntryMap.get(caseRec.Site_Association__c));   
           
        if(caseRec.Id!= null ){         
            sptKey = caseRec.Troubleshooting_Stage__c+'-'+caseRec.Severity__c;
            if(seactionsRef!=null && seactionsRef.size()>0){
                sptKey = sptKey+'-'+seactionsRef.contains(caseRec.Id);
            }else{
                sptKey = sptKey+'-false';
            }
        }
        else{
            sptKey =  caseRec.Troubleshooting_Stage__c+'-'+caseRec.Severity__c+'-false';
        }
        if(supportThresholdMap<>null && supportThresholdMap.size()>0){
            sptRef = supportThresholdMap.get(stageKeyMap.get(sptKey));
        }
    }
    
    public static Case clearThresholdValues(Case caseRec){
        UtilityFalgs.clearManagerActionValues = true;
        caseRec.Threshold_Duration__c = null;
        caseRec.Notification_Duration__c = null;        
        caseRec.Threshold_Start_Date_Time__c = null;
        caseRec.Threshold_Target_Date_Time__c = null;
        caseRec.Notification_Start_Date_Time__c = null;
        caseRec.Notification_Target_Date_Time__c = null;
        caseRec.Manager_Action__c=null;
        caseRec.Manager_Action_Comment_Update_Date_Time__c=null;
        caseRec.Manager_Action_Update_By__c=null;
        caseRec.Manager_Action_Update_Date_Time__c=null;
        caseRec.Manager_Action_Comment__c=null;
        caseRec.Manager_Action_Comment_By__c=null;
        return caseRec;
    }
    
    public static Case resetManagerActionFields(Case caseRec){
        UtilityFalgs.clearManagerActionValues = true;
        caseRec.Manager_Action__c=null;
        caseRec.Manager_Action_Comment_Update_Date_Time__c=null;
        caseRec.Manager_Action_Update_By__c=null;
        caseRec.Manager_Action_Update_Date_Time__c=null;
        caseRec.Manager_Action_Comment__c=null;
        caseRec.Manager_Action_Comment_By__c=null;        
        return caseRec;
    }
    
    public static Case performThresholdCalculationsonSevChange(Case caseRec,Set<Id> seactions,Map<String,id> busHrsIdMap){
        initialize(caseRec,seactions,busHrsIdMap);      
        if(sptRef<> null){
            caseRec.Threshold_Duration__c = sptRef.Threshold_Time__c;
            caseRec.Notification_Duration__c = sptRef.Threshold_Notification__c;
            if(caseRec.Threshold_Start_Date_Time__c==null){
                if(sptRef.Threshold_Time_Hours__c !=null || sptRef.Threshold_Time_Minutes__c != null){
                    caseRec.Threshold_Start_Date_Time__c = currentTime;
                }            
            }
            if(caseRec.Notification_Start_Date_Time__c==null){
                if(sptRef.Threshold_Notification_Hours__c !=null || sptRef.Threshold_Notification_Minutes__c != null){
                    caseRec.Notification_Start_Date_Time__c = currentTime; 
                }                    
            }
            if(sptRef.Calculation_Method__c.equalsIgnoreCase('Standard')){
                caseRec=calculateStandard(caseRec,false);     
            }
            else if(sptRef.Calculation_Method__c.equalsIgnoreCase ('Business')){
                caseRec=calucalteBusinessHours(caseRec,false);
            }
            caseRec = resetManagerActionFields(caseRec);
        }
        else{
            caseRec = clearThresholdValues(caseRec);
        }                
        return caseRec;
    }
    
    public static Case performThresholdCalculations(Case caseRec,Set<Id> seactions,Map<String,id> busHrsIdMap){
        
        initialize(caseRec,seactions,busHrsIdMap); 
        if(sptRef<> null){
            caseRec.Threshold_Duration__c = sptRef.Threshold_Time__c;
            caseRec.Notification_Duration__c = sptRef.Threshold_Notification__c;  
            if(sptRef.Threshold_Time_Hours__c !=null || sptRef.Threshold_Time_Minutes__c != null){
                caseRec.Threshold_Start_Date_Time__c = currentTime;                 
            }else{
                caseRec.Threshold_Start_Date_Time__c = null;                
            }
            
            if(sptRef.Threshold_Notification_Hours__c !=null || sptRef.Threshold_Notification_Minutes__c != null){
                caseRec.Notification_Start_Date_Time__c = currentTime;   
            }else{
                caseRec.Notification_Start_Date_Time__c = null;
            }
            
            if(sptRef.Calculation_Method__c.equalsIgnoreCase('Standard')){
                caseRec=calculateStandard(caseRec,true);     
            }
            else if(sptRef.Calculation_Method__c.equalsIgnoreCase ('Business')){
                caseRec=calucalteBusinessHours(caseRec,true);
            }
            caseRec = resetManagerActionFields(caseRec);
        }
        else{
            caseRec = clearThresholdValues(caseRec);
        }               
        return caseRec;
    }
    
    public static Case calculateStandard(Case caseRec,boolean reset){
        caseRec.Threshold_Target_Date_Time__c = addStandardTargetTime(caseRec.Threshold_Start_Date_Time__c,sptRef.Threshold_Time_Hours__c,sptRef.Threshold_Time_Minutes__c,reset);
        caseRec.Notification_Target_Date_Time__c = addStandardTargetTime(caseRec.Notification_Start_Date_Time__c,sptRef.Threshold_Notification_Hours__c,sptRef.Threshold_Notification_Minutes__c,reset);
        
        return caseRec;
    }
    
    public static Case calucalteBusinessHours(Case caseRec,boolean reset){
        caseRec.Threshold_Target_Date_Time__c = addBusinessTartgetTime(caseRec.Threshold_Start_Date_Time__c,sptRef.Threshold_Time_Hours__c,sptRef.Threshold_Time_Minutes__c,reset);
        caseRec.Notification_Target_Date_Time__c = addBusinessTartgetTime(caseRec.Notification_Start_Date_Time__c,sptRef.Threshold_Notification_Hours__c,sptRef.Threshold_Notification_Minutes__c,reset);
        
        return caseRec;
    }
    
    public static DateTime addStandardTargetTime(DateTime StartTime,Decimal timeToAddHours,Decimal timeToAddMinutes,boolean reset){
        DateTime calculatedThresholdTargetDT = null;
        if(StartTime==null){
            StartTime= currentTime;  
        }
        if(timeToAddHours <> null){
            if(reset){
                calculatedThresholdTargetDT = currentTime.addHours(Integer.valueOf(timeToAddHours));
            }               
            else{
                calculatedThresholdTargetDT = StartTime.addHours(Integer.valueOf(timeToAddHours));
            }
        }
        if(timeToAddMinutes <> null){
            if(calculatedThresholdTargetDT <> null){
                calculatedThresholdTargetDT = calculatedThresholdTargetDT.addMinutes(Integer.valueOf(timeToAddMinutes)); 
            }
            
            else{
                if(reset)
                    calculatedThresholdTargetDT = currentTime.addMinutes(Integer.valueOf(timeToAddMinutes));
                else
                    calculatedThresholdTargetDT = StartTime.addMinutes(Integer.valueOf(timeToAddMinutes));
            }
            
        }
        return calculatedThresholdTargetDT;
    }
    
    public static DateTime addBusinessTartgetTime(DateTime StartTime,Decimal timeToAddHours,Decimal timeToAddMinutes,boolean reset){
        DateTime calculatedThresholdTargetDT = null;
        if(StartTime==null){
            StartTime=currentTime;
        }
        if(timeToAddHours <> null){
            if(reset)
                calculatedThresholdTargetDT = BusinessHours.addGmt(busHrsId,currentTime,hoursToMilliseconds(Integer.valueOf(timeToAddHours)));
            else
                calculatedThresholdTargetDT = BusinessHours.addGmt(busHrsId,StartTime,hoursToMilliseconds(Integer.valueOf(timeToAddHours)));
        }
        if(timeToAddMinutes <> null){
            if(calculatedThresholdTargetDT <> null)
                calculatedThresholdTargetDT = BusinessHours.addGmt(busHrsId,calculatedThresholdTargetDT,minutesToMilliseconds(Integer.valueOf(timeToAddMinutes)));
            else{
                if(reset)
                    calculatedThresholdTargetDT = BusinessHours.addGmt(busHrsId,currentTime,minutesToMilliseconds(Integer.valueOf(timeToAddMinutes)));
                else
                    calculatedThresholdTargetDT = BusinessHours.addGmt(busHrsId,StartTime,minutesToMilliseconds(Integer.valueOf(timeToAddMinutes)));
            }                   
        }
        return calculatedThresholdTargetDT;
    }
    
    public static long hoursToMilliseconds(Integer timeToConvert){
        return Long.valueOf(String.valueOf(timeToConvert))*3600000;
    }
    public static long minutesToMilliseconds(Integer timeToConvert){
        return Long.valueOf(String.valueOf(timeToConvert))*60000;
    }
    
}