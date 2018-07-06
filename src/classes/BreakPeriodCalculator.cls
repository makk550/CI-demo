public class BreakPeriodCalculator {
    Public static Time CreateTime(String Tim){
        Integer HH,MM;
        	
        		if(Tim.contains('PM'))
					{
    					String str  =Tim.substring(0,Tim.length()-6);
                        if(str != '12'){HH = Integer.valueOf(str) + 12;}
                        else {HH = Integer.valueOf(str);}
   					    str  =Tim.substring(Tim.length()-5, Tim.length()-3);
    					MM = Integer.valueOf(str);
					}
                else{
    					String str  =Tim.substring(0, Tim.length()-6); 
                    	if(str != '12'){HH = Integer.valueOf(str);}
                    	else{HH = Integer.valueOf(str) - 12;}
                        str  =Tim.substring(Tim.length()-5, Tim.length()-3);
    					MM = Integer.valueOf(str);
                    }
				Time myTime = Time.newInstance(HH, MM, 0, 0);
        return myTime;
    }
    Public static boolean validateBreakPeriod(String stTime, String EnTime)
    	{
    		
        String timeRegEx = '([0][1-9]|[1][0-2]|[0-9]):[0-5][0-9]( )(AM|PM)';
			Pattern timePattern = Pattern.compile(timeRegEx);
			Matcher stTimeMatcher = timePattern.matcher(stTime);
    		Boolean stResult = stTimeMatcher.matches();
            Matcher enTimeMatcher = timePattern.matcher(EnTime);
    		Boolean enResult = enTimeMatcher.matches();
        		boolean flag = false;
        if(stResult && enResult){
        Time myTime = CreateTime(stTime);
		Time myTime1 = CreateTime(EnTime);
			if(myTime> myTime1){
    						    flag = true;
								}
        }
        return flag;
    }
    
    Public static boolean validateWithBusinessHours(String stTime, String EnTime, Time busStTime, Time busEnTime)
    {
        
        		String timeRegEx = '([0][1-9]|[1][0-2]|[0-9]):[0-5][0-9]( )(AM|PM)';
			Pattern timePattern = Pattern.compile(timeRegEx);
			Matcher stTimeMatcher = timePattern.matcher(stTime);
    		Boolean stResult = stTimeMatcher.matches();
            Matcher enTimeMatcher = timePattern.matcher(EnTime);
    		Boolean enResult = enTimeMatcher.matches();
        	boolean flag = false;
            if(stResult && enResult){
                Time myTime = CreateTime(stTime);
				Time myTime1 = CreateTime(EnTime);
        
        if(myTime < busStTime || myTime1> busEnTime){
            flag = true;
        }
            }
        return flag;
    }
    
    Public static boolean validateAutoassign(String stTime, String EnTime, String Timezone){
        
        	boolean flag = false;
        
        Time myTime = CreateTime(stTime);
		Time myTime1 = CreateTime(EnTime);
        string sysT = (System.now().format('yyyy-MM-dd HH:mm:ss', Timezone));
		String str  =sysT.substring(sysT.length()-8, sysT.length()-6); 
  		Integer HHS = Integer.valueOf(str);
        str  =sysT.substring(sysT.length()-5, sysT.length()-3);
  		Integer MMS = Integer.valueOf(str);
        Time sTime = Time.newInstance(HHS, MMS, 0, 0);
        if(myTime < sTime && myTime1 > sTime){ flag = true;}
        return flag;
    }
}