trigger UserSkillsLocation on User_Skills__c(before update, before insert)
{
    List<User_Skills__c> listUS = new List<User_Skills__c>();
  List<User_Skills__c> listUSB = new List<User_Skills__c>();
    for(User_Skills__c recUS:Trigger.new)
    {
        if(trigger.isInsert || (trigger.isUpdate && ((trigger.oldMap.get(recUS.Id).NA_Countries__c != recUS.NA_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).WW_Countries__c != recUS.WW_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).LA_Countries__c != recUS.LA_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).EMEA1_Countries__c != recUS.EMEA1_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).EMEA2_Countries__c != recUS.EMEA2_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).APJ_Countries__c != recUS.APJ_Countries__c))))
        {                                    
            String locations = '';
            if(recUS.NA_Countries__c!=null)
            {
                locations = locations + recUS.NA_Countries__c+';';
            }
            if(recUS.LA_Countries__c!=null)
            {
                locations = locations + recUS.LA_Countries__c+';';
            }
            if(recUS.EMEA1_Countries__c!=null)
            {
                locations = locations + recUS.EMEA1_Countries__c+';';
            }
           if(recUS.EMEA2_Countries__c!=null)
            {
                locations = locations + recUS.EMEA2_Countries__c+';';
            }           
            if(recUS.APJ_Countries__c!=null)
            {
                locations = locations + recUS.APJ_Countries__c+';';
            }
            if(recUS.WW_Countries__c!=null)
            {
                locations = locations + recUS.WW_Countries__c+';';
            }        
            
            if(locations.length() > 0)
            {
                locations = locations.substring(0,locations.lastindexof(';'));
                locations = locations.toUpperCase();
                locations = locations.replace(Label.User_Skill_Korea_Target, Label.User_Skill_Korea_Replacement);
                locations = locations.replace('UM - UNITED STATES MINOR OUTLYING ISLAND','UM - UNITED STATES MINOR OUTLYING ISLANDS');
                locations = locations.replace('GS - SOUTH GEORGIA AND THE SOUTH SANDWIC','GS - SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS');
                locations = locations.replace('CD - CONGO, THE DEMOCRATIC REPUBLIC OF T','CD - CONGO, THE DEMOCRATIC REPUBLIC OF THE');
                locations = locations.replace('MK - MACEDONIA, THE FORMER YUGOSLAV REPU','MK - MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF');                        
                recUS.Location__c = locations;                
            }
 
         }       
     if(Trigger.isInsert || Trigger.isUpdate){
            if(recUS.Start_Time1__c != null || recUS.End_Time1__c!= null || recUS.Start_Time10__c != null || recUS.End_Time10__c!= null || 	recUS.Start_Time20__c != null || recUS.Start_Time2__c != null || recUS.End_Time10__c != null || recUS.End_Time2__c != null || recUS.End_Time20__c != null){
                                listUS.add(recUS);
            }
        }
    }
        
        if(!listUS.isEmpty()){
        listUSB = [Select Id, Business_Hours__r.TimeZoneSidKey, Business_Hours__r.FridayEndTime,Business_Hours__r.FridayStartTime,Business_Hours__r.MondayEndTime,Business_Hours__r.MondayStartTime,
           Business_Hours__r.SaturdayEndTime,Business_Hours__r.SaturdayStartTime,Business_Hours__r.SundayEndTime,Business_Hours__r.SundayStartTime,Business_Hours__r.ThursdayEndTime,Business_Hours__r.ThursdayStartTime,
           Business_Hours__r.TuesdayEndTime,Business_Hours__r.TuesdayStartTime,Business_Hours__r.WednesdayEndTime,Business_Hours__r.WednesdayStartTime from User_Skills__c where Id =: listUS];
        for(User_Skills__c US: listUS){
            if(US.Start_Time2__c != null && US.End_Time2__c != null){
                    if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time2__c, US.End_Time2__c )){
                        US.Start_Time2__c.addError('End Time should be greater than Break Start Time');
                    }}
            if(US.Start_Time20__c != null && US.End_Time20__c != null){
                                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time20__c, US.End_Time20__c )){
                        US.Start_Time20__c.addError('End Time should be greater than Break Start Time');
                    }
                }
            if(US.Start_Time10__c != null && US.End_Time10__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time10__c, US.End_Time10__c )){US.Start_Time10__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time1__c != null && US.End_Time1__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time1__c, US.End_Time1__c )){US.Start_Time1__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time30__c != null && US.End_Time30__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time30__c, US.End_Time30__c )){US.Start_Time30__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time3__c != null && US.End_Time3__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time3__c, US.End_Time3__c )){US.Start_Time3__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time40__c != null && US.End_Time40__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time40__c, US.End_Time40__c )){US.Start_Time40__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time4__c != null && US.End_Time4__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time4__c, US.End_Time4__c )){US.Start_Time4__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time50__c != null && US.End_Time50__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time50__c, US.End_Time50__c )){US.Start_Time50__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time5__c != null && US.End_Time5__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time5__c, US.End_Time5__c )){US.Start_Time5__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time60__c != null && US.End_Time60__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time60__c, US.End_Time60__c )){US.Start_Time60__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time6__c != null && US.End_Time6__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time6__c, US.End_Time6__c )){US.Start_Time6__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time70__c != null && US.End_Time70__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time70__c, US.End_Time70__c )){US.Start_Time70__c.addError('End Time should be greater than Break Start Time');}
                    }
            if(US.Start_Time7__c != null && US.End_Time7__c != null){
                   if(BreakPeriodCalculator.validateBreakPeriod(US.Start_Time7__c, US.End_Time7__c )){US.Start_Time7__c.addError('End Time should be greater than Break Start Time');}
                    }
                
            for(User_Skills__c USB: listUSB){
                if(US.Id == USB.Id){
                    

                    if((US.Start_Time1__c != null || US.Start_Time10__c != null) && USB.Business_Hours__r.SundayEndTime == null){ US.Start_Time1__c.addError('Break Period should setup for only for Business Days');}
                   	if((US.Start_Time2__c != null || US.Start_Time20__c != null) && USB.Business_Hours__r.MondayEndTime == null){US.Start_Time2__c.addError('Break Period should setup for only for Business Days');}
                    if((US.Start_Time3__c != null || US.Start_Time30__c != null) && USB.Business_Hours__r.TuesdayEndTime == null){US.Start_Time3__c.addError('Break Period should setup for only for Business Days');}
                    if((US.Start_Time4__c != null || US.Start_Time40__c != null) && USB.Business_Hours__r.WednesdayEndTime == null){US.Start_Time4__c.addError('Break Period should setup for only for Business Days');}
                    if((US.Start_Time5__c != null || US.Start_Time50__c != null) && USB.Business_Hours__r.ThursdayEndTime == null){US.Start_Time5__c.addError('Break Period should setup for only for Business Days');}
                    if((US.Start_Time6__c != null || US.Start_Time60__c != null) && USB.Business_Hours__r.FridayEndTime == null){US.Start_Time6__c.addError('Break Period should setup for only for Business Days');}
                    if((US.Start_Time7__c != null || US.Start_Time70__c != null) && USB.Business_Hours__r.SaturdayEndTime == null){US.Start_Time7__c.addError('Break Period should setup for only for Business Days');}
                    
                    if(US.Start_Time2__c != null  && US.End_Time2__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time2__c, US.End_Time2__c, USB.Business_Hours__r.MondayStartTime, USB.Business_Hours__r.MondayEndTime)){
                        US.Start_Time2__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time20__c != null  && US.End_Time20__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time20__c, US.End_Time20__c, USB.Business_Hours__r.MondayStartTime, USB.Business_Hours__r.MondayEndTime)){
                        US.Start_Time20__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time1__c != null  && US.End_Time1__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time1__c, US.End_Time1__c, USB.Business_Hours__r.SundayStartTime, USB.Business_Hours__r.SundayEndTime)){
                        US.Start_Time1__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time10__c != null  && US.End_Time10__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time10__c, US.End_Time10__c, USB.Business_Hours__r.SundayStartTime, USB.Business_Hours__r.SundayEndTime)){
                        US.Start_Time10__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time3__c != null  && US.End_Time3__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time3__c, US.End_Time3__c, USB.Business_Hours__r.TuesdayStartTime, USB.Business_Hours__r.TuesdayEndTime)){
                        US.Start_Time3__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time30__c != null  && US.End_Time30__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time30__c, US.End_Time30__c, USB.Business_Hours__r.TuesdayStartTime, USB.Business_Hours__r.TuesdayEndTime)){
                        US.Start_Time30__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time4__c != null  && US.End_Time4__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time4__c, US.End_Time4__c, USB.Business_Hours__r.WednesdayStartTime, USB.Business_Hours__r.WednesdayEndTime)){
                        US.Start_Time4__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time40__c != null  && US.End_Time40__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time40__c, US.End_Time40__c, USB.Business_Hours__r.WednesdayStartTime, USB.Business_Hours__r.WednesdayEndTime)){
                        US.Start_Time40__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time5__c != null  && US.End_Time5__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time5__c, US.End_Time5__c, USB.Business_Hours__r.ThursdayStartTime, USB.Business_Hours__r.ThursdayEndTime)){
                        US.Start_Time5__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time50__c != null  && US.End_Time50__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time50__c, US.End_Time50__c, USB.Business_Hours__r.ThursdayStartTime, USB.Business_Hours__r.ThursdayEndTime)){
                        US.Start_Time50__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time6__c != null  && US.End_Time6__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time6__c, US.End_Time6__c, USB.Business_Hours__r.FridayStartTime, USB.Business_Hours__r.FridayEndTime)){
                        US.Start_Time6__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time60__c != null && US.End_Time60__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time60__c, US.End_Time60__c, USB.Business_Hours__r.FridayStartTime, USB.Business_Hours__r.FridayEndTime)){
                        US.Start_Time60__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time7__c != null  && US.End_Time7__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time7__c, US.End_Time7__c, USB.Business_Hours__r.SaturdayStartTime, USB.Business_Hours__r.SaturdayEndTime)){
                        US.Start_Time7__c.addError('Break Time Should belong to BusinessHours');}}
                    if(US.Start_Time70__c != null  && US.End_Time70__c != null){ if(BreakPeriodCalculator.validateWithBusinessHours(US.Start_Time70__c, US.End_Time70__c, USB.Business_Hours__r.SaturdayStartTime, USB.Business_Hours__r.SaturdayEndTime)){
                        US.Start_Time70__c.addError('Break Time Should belong to BusinessHours');}}
                    
                  }
            }
          }
        }
}