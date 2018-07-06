global class BatchUserSkillCaseCorrection implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
    
        String query = 'Select user__c,Reset_Period__c, Time_to_Reset_US_Daily__c, Severity_1_cases_assigned__c, Cases_Assigned__c, Cases_assigned_perday__c from User_Skills__c where user__c != \'\' OR user__c != null';    
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<User_Skills__c> listUS) 
    {
        if(listUS != null && listUS.size() > 0)
        {
            Map<ID, List<User_Skills__c>> mapUS = new Map<ID, List<User_Skills__c>>();
            Map<ID, DateTime> mapUSResetUS = new Map<ID, DateTime>();
            
            for(User_Skills__c myUS : listUS)
            {
                if(mapUS.containsKey(myUS.user__c))
                {
                    List<User_Skills__c> myUSList = mapUS.get(myUS.user__c);
                    myUSList.add(myUS);
                    mapUS.put(myUS.user__c, myUSList); 
                }
                else
                {
                    List<User_Skills__c> myUSList = new List<User_Skills__c>();
                    myUSList.add(myUS);
                    mapUS.put(myUS.user__c, myUSList);
                    if(myUS.Time_to_Reset_US_Daily__c != null)
                        mapUSResetUS.put(myUS.user__c, myUS.Time_to_Reset_US_Daily__c);
                }
            }
            
            Set<Id> myUserSet = new Set<Id>();
            for(User_Skills__c myUS : listUS)
            {
                myUserSet.add(myUS.user__c);
            }
            
            List<Case> listCases = [Select id, Severity__c, LAST_ASSIGNED_DATE__C, ownerId from Case where status != 'Closed' AND OwnerId IN: myUserSet];
            List<User_Skills__c> commitUS = new List<User_Skills__c>();
            Date myDate = Date.today();
            Date lastDay = myDate.addDays(-2);
            Date weekStart = myDate.toStartofWeek();
            System.debug('weekstart *** ' + weekStart);
            Date tmpDate = weekStart.addDays(-1);
            System.debug('tmpDate *** ' + tmpDate);            
            List<Case> listWeekCases = [Select id, Severity__c, LAST_ASSIGNED_DATE__C, Last_Assigned_DateTime__c, ownerId from Case where LAST_ASSIGNED_DATE__C >= :tmpDate AND OwnerId IN: myUserSet];
            List<Case> dailyCasesAssignedList = [select id, Severity__c, LAST_ASSIGNED_DATE__C, Last_Assigned_DateTime__c, ownerId 
                                                 from Case where LAST_ASSIGNED_DATE__C >= :lastDay
                                                 AND OwnerId IN: myUserSet];
            for(Id myUserId : mapUS.keySet())
            {
                List<Case> myUserCases = new List<Case>();
                List<Case> myUserCasesWeek = new List<Case>();
                List<Case> myUserSev1Cases = new List<Case>();
                List<Case> myUserDailyCases = new List<Case>();
                for(Case myCase : listCases)
                {
                    if(myUserID.equals(myCase.ownerID))
                    {
                        myUserCases.add(myCase);
                        if(myCase.Severity__c=='1')
                        {
                            myUserSev1Cases.add(myCase);
                        }
                    }
                }
                
                for(Case myCase : listWeekCases)
                {
                    if(myUserID.equals(myCase.ownerID))
                    {
                        if(myCase.last_assigned_date__c != null)
                        {
                            if(myCase.last_assigned_date__c >= weekStart)
                            {
                                myUserCasesWeek.add(myCase);
                            }
                        }                    
                    }
                }
                
                Datetime lastResetTime = mapUSResetUS.get(myUserID);
                if(lastResetTime == null)
                {
                    lastResetTime = Date.today();
                    System.debug('BatchUserSkillCaseCorrection : Did not find last reset time for user : ' + myUserID + ' :: Hence used Date.today()');
                }
                else
                {
                    lastResetTime = lastResetTime.addDays(-1);
                }
                
                for(Case myCase : dailyCasesAssignedList)
                {
                    if(myUserID.equals(myCase.ownerID))
                    {
                        if(myCase.Last_Assigned_DateTime__c != null)
                        {
                            if(myCase.Last_Assigned_DateTime__c >= lastResetTime)
                            {
                                myUserDailyCases.add(myCase);
                            }
                        }                    
                    }
                }               
                
                integer myTotalCases = myUserCases.size();
                integer myWeekCases = myUserCasesWeek.size();
                integer mySev1Cases = myUserSev1Cases.size();
                integer myDailyCases = myUserDailyCases.size();
                List<User_Skills__c> myUpdateUS = mapUS.get(myUserId);
                
                for(User_Skills__C tmpUS : myUpdateUS)
                {   
                    if(tmpUs.Reset_Period__c == 'Weekly'){
                        if((tmpUS.Cases_Assigned__c != myTotalCases) || (tmpUS.Cases_assigned_perday__c != myWeekCases) || (tmpUS.Severity_1_cases_assigned__c != mySev1Cases))
                        {
                            tmpUS.Cases_Assigned__c = myTotalCases;
                            tmpUS.Cases_assigned_perday__c = myWeekCases;
                            tmpUS.Severity_1_cases_assigned__c = mySev1Cases;
                            commitUS.add(tmpUS);
                        }
                    }
                    if(tmpUs.Reset_Period__c == 'Daily'){
                         if((tmpUS.Cases_Assigned__c != myTotalCases) || (tmpUS.Cases_assigned_perday__c != myDailyCases) || (tmpUS.Severity_1_cases_assigned__c != mySev1Cases))
                        {
                            tmpUS.Cases_Assigned__c = myTotalCases;
                            tmpUS.Cases_assigned_perday__c = myDailyCases;
                            tmpUS.Severity_1_cases_assigned__c = mySev1Cases;
                            commitUS.add(tmpUS);
                        }
                    }
                }
                system.debug('************ MY total cases'+myTotalCases);
            system.debug('************ MY Sev1 cases'+mySev1Cases);
            system.debug('************ MY Week cases'+myWeekCases);
            system.debug('************ MY Daily cases'+myDailyCases);
            }
            try{
            update commitUS;
            }catch(Exception e){}
        }
    }   
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}