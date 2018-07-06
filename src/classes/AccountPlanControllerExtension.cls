public class AccountPlanControllerExtension {

    public String New_Event_URL {get; set; }

    private final Account_Plan3__c ap;
    private Apexpages.StandardController controller; 
    //public map<Task, Boolean> tasks {get; set;}
    public List<ActivityWrapper> Activities { get; set; }
    
    public integer pageNumber {get; set;}
    public String activityType {get; set;}
    public Id apapprover {get;set;}
    public Id aplanapprover {get;set;}
    public String activityLookupNumber
    {
        get{
            return ApexPages.CurrentPage().getParameters().get('lookupNum');
        }
    }
    public List<List<ActivityWrapper>> paginatedEvents
    {
        get
        {
            if(paginatedEvents != null)
                return paginatedEvents;
                
            paginatedEvents = new List<List<ActivityWrapper>>();
            
            Set<Id> selectedActivityIds = new Set<Id>();
            
            
            if(activityLookupNumber=='1' && ap.selected_tasks__c != null)
            {
                for(String s : ap.selected_tasks__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
            else if(activityLookupNumber=='2' && ap.Recent_CA_Executive_Interactions__c != null)
            {
                for(String s : ap.Recent_CA_Executive_Interactions__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
            else if(activityLookupNumber=='3' && ap.Upcoming_Events__c != null)
            {
                for(String s : ap.Upcoming_Events__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
   
           for(List<Event> eList : [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, OwnerId, Owner.Name 
                                     FROM Event 
                                     WHERE ( (AccountId = :ap.Account__c) AND (ActivityDate=THIS_FISCAL_YEAR OR ActivityDate=LAST_FISCAL_YEAR) )
                                         OR (Id IN :selectedActivityIds)
                                     ORDER BY ActivityDate DESC] )
          {
              List<ActivityWrapper> awList = new List<ActivityWrapper>();
              for(Event anEvent : eList)
              {
                  ActivityWrapper aw = new ActivityWrapper();
                  aw.isTask = false;
                  aw.anEvent = anEvent;
              
                  if(selectedActivityIds.contains(anEvent.Id))
                    aw.selected = true;
                  else
                    aw.selected = false;
              
                  awList.add(aw);
              }
              paginatedEvents.add(awList);
          }
          return paginatedEvents;
        }
        set;
    }
    
    public List<List<ActivityWrapper>> paginatedTasks
    {
        get
        {
            if(paginatedTasks != null)
                return paginatedTasks;
                
            paginatedTasks = new List<List<ActivityWrapper>>();
            
            Set<Id> selectedActivityIds = new Set<Id>();
           if(activityLookupNumber=='1' && ap.selected_tasks__c != null)
            {
                for(String s : ap.selected_tasks__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
            else if(activityLookupNumber=='2' && ap.Recent_CA_Executive_Interactions__c != null)
            {
                for(String s : ap.Recent_CA_Executive_Interactions__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
            else if(activityLookupNumber=='3' && ap.Upcoming_Events__c != null)
            {
                for(String s : ap.Upcoming_Events__c.split(','))
                    selectedActivityIds.add(Id.valueOf(s));
            }
   
           for(List<Task> tList : [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, Status, Priority, OwnerId, Owner.Name 
                                    FROM Task 
                                    WHERE ( (AccountId = :ap.Account__c) AND (ActivityDate=THIS_FISCAL_YEAR OR ActivityDate=LAST_FISCAL_YEAR OR ActivityDate=NULL) ) 
                                        OR Id IN :selectedActivityIds
                                    ORDER BY ActivityDate DESC])
          {
              List<ActivityWrapper> awList = new List<ActivityWrapper>();
              for(Task aTask : tList)
              {
                  ActivityWrapper aw = new ActivityWrapper();
                  aw.isTask = true;
                  aw.aTask = aTask;
              
                  if(selectedActivityIds.contains(aTask.Id))
                    aw.selected = true;
                  else
                    aw.selected = false;
              
                  awList.add(aw);
              }
              paginatedTasks.add(awList);
          }
          return paginatedTasks;
        }
        set;
    }
    
    Private List<Opportunity> currentOpps;
    private List<Account_Plan3__c> eUsers = new List<Account_Plan3__c>();
    public Integer eSize { get; set; }
    public String contIdChosen { get; set; }
    
    public Ext_Cill ec {get; set;}
    
    public boolean displayPopup {get; set;}     
    private Account_Plan3__c dummy;
    public Account_Plan3__c getDummy()
    {
        if(dummy == null)
            dummy = new Account_Plan3__c(Name='dummy');
        
        return dummy;
    }
    
    public void closePopup() {        
        displayPopup = false;    
    }
    
    public void closeAndSavePopup() {        
        displayPopup = false;
        
        if(dummy.CA_Executive_Sponsor_2__c != null)
        {
            eUsers.add(new Account_Plan3__c(Name = 'new row', CA_Executive_Sponsor_1__c = dummy.CA_Executive_Sponsor_2__c));
            eSize++;
        }
    }
         
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public class ActivityWrapper
    {
        public Boolean isTask { get; set; }
        public Task aTask { get; set; }
        Public Event anEvent { get; set; }
        public Boolean selected { get; set; }
        public Boolean selected2 { get; set; }
        public Boolean selected3 { get; set; }
        
        public String getFormattedDate()
        {
            if(isTask==true && aTask.ActivityDate!=null)
                return aTask.ActivityDate.format();
            if(isTask==false && anEvent.ActivityDate!=null)
                return anEvent.ActivityDate.format();
                
            return null;
        }
    }
    
    public AccountPlanControllerExtension(ApexPages.StandardController stdController) {
        system.debug('checking');
        activityType = 'Events';
        pageNumber = 1;
        this.controller = stdController;
        this.ap = (Account_Plan3__c)stdController.getRecord();
        Set<String> oppStageNames = new Set<String>{Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,
                                                    Label.Opp_Stage_80_Percent};
        
        String parentId = ApexPages.CurrentPage().getParameters().get('pid');
        if(parentId != null)
            ap.Account__c = Id.valueOf(parentId);
        
        Account acc = ap.Account__r;
        if(acc == null)
        {
            acc = [SELECT Id, Name, Account_Fiscal_Year__c  FROM Account WHERE Id = :ap.Account__c][0];
            ap.Account__r = acc;
            System.debug('@@@In if:'+acc);
        }
        System.debug('***acc:'+acc);
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        ApexPages.currentPage().getParameters().put('id', ap.Account__c);
        ec = new Ext_Cill(sc);
        
        populateHvns();
        
        
        
        if(ap.CA_Executive_Sponsors__c != null)
        {
            Set<Id> eUserIds = new Set<Id>();
            for(String u : ap.CA_Executive_Sponsors__c.split(','))
            {
              eUsers.add(new Account_Plan3__c(CA_Executive_Sponsor_1__c = Id.valueOf(u)));
              eUserIds.add(Id.valueOf(u));
            }
            
            Map<Id, User> idToEx = new Map<Id, User>([SELECT id, Title FROM User WHERE Id in :eUserIds]);
            for(Account_Plan3__c ap3 : eUsers)
            {                
                ap3.External_Business_Climate_Trends_1__c = idToEx.get(ap3.CA_Executive_Sponsor_1__c).Title;
            }
            
        }
        
        Integer numBlankFields = 5 - eUsers.size();
        if(numBlankFields > 0)
            for(Integer i=0; i < numBlankFields; i++)
                eUsers.add(new Account_Plan3__c());
                
        eSize = eUsers.size();
        
        Integer fYear = Date.Today().Month() < 4 ? Date.today().year() : Date.today().year() + 1;
       
        
        AggregateResult[] groupedResults = [SELECT SUM(PNCV__c)aver
                                            FROM Opportunity 
                                            WHERE AccountId = :ap.Account__c
                                              AND FiscalYear = :fYear
                                              AND StageName IN: oppStageNames 
                                              AND Opportunity_Type__c IN ('PNCV', 'PNCV w/Education', 'PNCV w/Education & Support','PNCV w/Services', 'PNCV w/Services, Education & Support', 
                                                                          'PNCV w/Services & Education', 'PNCV w/Services & Support', 'PNCV w/Support', 'Support', 'Services w/Education & Support', 'Services w/Support')];
        
        ap.Total_PNCV_Pipeline__c = (Decimal)groupedResults[0].get('aver'); 
    }

    
    
    public list<Opportunity> getTopOpps() 
    {
        Integer fYear = Date.Today().Month() < 4 ? Date.today().year() : Date.today().year() + 1;

        Set<String> oppStageNames = new Set<String>{Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent, Label.Opp_Stage_60_Percent,
                                                Label.Opp_Stage_80_Percent};
        
         return [SELECT Name, OwnerId, CurrencyIsoCode, Opportunity_Number__c, Sales_Milestone_Search__c, PNCV__c, RoadmapToPlan__c, Total_Upfront_Lic_Fee__c, Inside_Outside__c, CloseDate
                FROM Opportunity
                WHERE AccountId = :ap.Account__c
                    //AND FiscalYear = :fYear
                    //AND (NOT Opportunity_Type__c like '%enewal%')
                    AND (CloseDate=THIS_QUARTER OR CloseDate=NEXT_N_QUARTERS:3)
                    AND PNCV__c!=0
                    AND Opportunity_Type__c IN ('PNCV', 'PNCV w/Education', 'PNCV w/Education & Support', 'PNCV w/Services', 'PNCV w/Services, Education & Support', 'PNCV w/Services & Education', 'PNCV w/Services & Support', 'PNCV w/Support', 'Support', 'Services w/Education & Support', 'Services w/Support')
                    AND StageName IN: oppStageNames 
                ORDER BY PNCV__c DESC, CloseDate ASC 
                LIMIT 5];
    }
    
    public list<Opportunity> getCustomerRenewals() 
    {
        Integer fYear = Date.Today().Month() < 4 ? Date.today().year() : Date.today().year() + 1;
        Set<String> oppStageNames = new Set<String>{Label.Opp_Stage_10_Percent, Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent, 
                                                    Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent};
    
        List<Opportunity> renewalOpps = [SELECT Name, OwnerId, Opportunity_Number__c, Sales_Milestone_Search__c, Renewal_and_TMFC_Amount__c, CurrencyIsoCode, RoadmapToPlan__c, Inside_Outside__c, CloseDate
                                         FROM Opportunity
                                         WHERE AccountId = :ap.Account__c 
                                             AND FiscalYear = :fYear
                                             AND Opportunity_Type__c like '%enewal%'
                                             AND isClosed = False
                                             AND Amount!=0
                                             AND StageName IN: oppStageNames
                                         ORDER BY Renewal_and_TMFC_Amount__c DESC, CloseDate ASC];
           
        return renewalOpps;
    }
    
    public PageReference saveActivities()
    {
        
        
        List<Id> activitiesToBeSaved = new List<Id>();
        
        for(List<ActivityWrapper> aList : paginatedTasks)
            for(ActivityWrapper a : aList)
                if(a.selected)
                    activitiesToBeSaved.add(a.aTask.id);
        
  
        for(List<ActivityWrapper> aList : paginatedEvents)
            for(ActivityWrapper a : aList)
                if(a.selected)
                    activitiesToBeSaved.add(a.anEvent.id);
        
        //ap.selected_tasks__c = String.join(activitiesToBeSaved, ',');
        Account_Plan3__c ap3 = [SELECT Id, selected_tasks__c, Recent_CA_Executive_Interactions__c, Upcoming_Events__c FROM Account_Plan3__c WHERE Id = :ap.Id LIMIT 1];
        if(activityLookupNumber=='1')
        {
            ap3.selected_tasks__c = String.join(activitiesToBeSaved, ',');
        }
        else if(activityLookupNumber=='2')
        {
            ap3.Recent_CA_Executive_Interactions__c = String.join(activitiesToBeSaved, ',');
        }
        else
        {
            ap3.Upcoming_Events__c = String.join(activitiesToBeSaved, ',');
        }
        //ap3.selected_tasks__c = String.join(activitiesToBeSaved, ',');
        update ap3;
        
        
        PageReference pr = Page.AccountPlanEdit;
        pr.getParameters().put('id', ap.id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference cancelActivityLookup()
    {
        PageReference pr = Page.AccountPlanEdit;
        pr.getParameters().put('id', ap.id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference Save()
    {
        ec.saveInfo();
        if(ec.validationErrorFound)
        {
            ap.addError('CILL:  GBU, GBU Driver, Competitor, Competitor Product fields are required');
            return null;
        }
    
        if(currentOpps != null)
            update currentOpps;
                
        saveUsers();
        
        //if(ap.Fiscal_Year__c != null)
        //    ap.Name = ap.Fiscal_Year__c + ' Account Plan Summary';
        String accName = [SELECT Id, Name FROM Account WHERE Id = :ap.Account__c][0].Name;
        //ap.Name = accName + ' - Account Plan';
        ap.Name = accName;
        return controller.save();
    }
    
    public list<Account_Plan3__c> getUserList()
    {
        for(Integer i=0; i<eUsers.size(); i++)
        {
            eUsers[i].Capex_Budget__c = i;
        }
    
        return eUsers;
    }
    
    public void addUserRow()
    {
        eUsers.add(new Account_Plan3__c(Name = 'new row'));
        eSize++;
    }
    
    private void saveUsers()
    {
        List<Id> usersToBeSaved = new List<Id>();
        for(Account_Plan3__c apUser : eUsers)
            if(apUser.CA_Executive_Sponsor_1__c != null)
                usersToBeSaved.add(apUser.CA_Executive_Sponsor_1__c);
            
        ap.CA_Executive_Sponsors__c = String.join(usersToBeSaved, ',');
    }
    
    public void deleteExecUser()
    {
        System.debug('abc ' + contIdChosen);
        
        
        eUsers.remove(Integer.valueOf(contIdChosen));
        eSize--;
    }
    
    public PageReference checkForRedirect()
    {
        String parentId = ApexPages.CurrentPage().getParameters().get('pid'); 
        if(ap.Id != null || parentId == null)
            return null;
            
        Id pid = Id.valueOf(parentId);    
        Id newId = [SELECT Id FROM Account_Plan3__c WHERE Account__c=:pid LIMIT 1][0].Id;
        
        PageReference pr = Page.AccountPlan;
        pr.getParameters().put('id', newId);
        pr.setRedirect(true);
        return pr;    
    }
    
   public static list<SelectOption> getPicklistValues(SObject obj, String fld)
   {
      list<SelectOption> options = new list<SelectOption>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = obj.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =
         fieldMap.get(fld).getDescribe().getPickListValues();
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a : values)
      { 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      return options;
   }
   
   public void populateHvns()
   {
       Map<Id,Id> contactToHvn = new Map<Id,Id>();
   
       if(ap.Key_Account_Relationship_1__r.HVN_ID__c != null && ap.Key_Account_Relationship_1__r.HVN__c == true)
           contactToHvn.put(ap.Key_Account_Relationship_1__c, Id.valueOf(ap.Key_Account_Relationship_1__r.HVN_ID__c));
       if(ap.Key_Account_Relationship_2__r.HVN_ID__c != null && ap.Key_Account_Relationship_2__r.HVN__c == true)
           contactToHvn.put(ap.Key_Account_Relationship_2__c, Id.valueOf(ap.Key_Account_Relationship_2__r.HVN_ID__c));
       if(ap.Key_Account_Relationship_3__r.HVN_ID__c != null && ap.Key_Account_Relationship_3__r.HVN__c == true)
           contactToHvn.put(ap.Key_Account_Relationship_3__c, ap.Key_Account_Relationship_3__r.HVN_ID__c);
       if(ap.Key_Account_Relationship_4__r.HVN_ID__c != null && ap.Key_Account_Relationship_4__r.HVN__c == true)
           contactToHvn.put(ap.Key_Account_Relationship_4__c, ap.Key_Account_Relationship_4__r.HVN_ID__c);  
       if(ap.Key_Account_Relationship_5__r.HVN_ID__c != null && ap.Key_Account_Relationship_5__r.HVN__c == true)
           contactToHvn.put(ap.Key_Account_Relationship_5__c, ap.Key_Account_Relationship_5__r.HVN_ID__c);
           
       Map<Id, HVN__c> idToHvnMap = new Map<Id, HVN__c>([SELECT Id, Relationship_Status_Graphic__c FROM HVN__c WHERE Id in :contactToHvn.values()]);
       
       ap.hvn_1__r = idToHvnMap.get(contactToHvn.get(ap.Key_Account_Relationship_1__c));
       ap.hvn_2__r = idToHvnMap.get(contactToHvn.get(ap.Key_Account_Relationship_2__c));
       ap.hvn_3__r = idToHvnMap.get(contactToHvn.get(ap.Key_Account_Relationship_3__c));
       ap.hvn_4__r = idToHvnMap.get(contactToHvn.get(ap.Key_Account_Relationship_4__c));
       ap.hvn_5__r = idToHvnMap.get(contactToHvn.get(ap.Key_Account_Relationship_5__c));
   }
   
   public List<String> getExternalBusinessClimateTrends()  {
       if(ap.External_Business_Climate_Trends__c == null)
           return null;
           
       return ap.External_Business_Climate_Trends__c.split('\n');
   }
   
   public List<String> getStatedBusinessPriorities()   {
       if(ap.Stated_Business_Priorities__c == null)
           return null;
   
       return ap.Stated_Business_Priorities__c.split('\n');
   }
   
   public List<String> getKeyPastProjects()   {
       if(ap.Key_Past_Projects__c == null)
           return null;
   
       return ap.Key_Past_Projects__c.split('\n');
   }
   
   public List<String> getCurrentProjects()   {
       if(ap.Current_Projects__c == null)
           return null;
   
       return ap.Current_Projects__c.split('\n');
   }
   
   Public List<ActivityWrapper> getSelectedActivities()
   {
       Set<Id> selectedActivityIds = new Set<Id>();
   
       if(ap.selected_tasks__c != null)
       {
           for(String s : ap.selected_tasks__c.split(','))
               selectedActivityIds.add(Id.valueOf(s));
       }
       
       List<ActivityWrapper> selActivities = new List<ActivityWrapper>();
       
       List<Task> selectedTasks = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, Status, Priority, OwnerId, Owner.Name 
                                   FROM Task
                                   WHERE Id IN :selectedActivityIds];
        for(Task aTask : selectedTasks)
        {
            ActivityWrapper aw = new ActivityWrapper();
            aw.isTask = true;
            aw.aTask = aTask;
            selActivities.add(aw);
        }            
                                   
        List<Event> allEvents = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, OwnerId, Owner.Name 
                                 FROM Event 
                                 WHERE Id IN :selectedActivityIds];
        
        for(Event anEvent : allEvents)
        {
            ActivityWrapper aw = new ActivityWrapper();
            aw.isTask = false;
            aw.anEvent = anEvent;
            selActivities.add(aw);
        }
  
          
       return selActivities;
   }
   
   Public List<ActivityWrapper> getSelectedActivities2()
   {
       Set<Id> selectedActivityIds = new Set<Id>();
   
       if(ap.Recent_CA_Executive_Interactions__c != null)
       {
           for(String s : ap.Recent_CA_Executive_Interactions__c.split(','))
               selectedActivityIds.add(Id.valueOf(s));
       }
   
       List<ActivityWrapper> selActivities = new List<ActivityWrapper>();
       
       List<Task> selectedTasks = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, Status, Priority, OwnerId, Owner.Name 
                                   FROM Task
                                   WHERE Id IN :selectedActivityIds];
       for(Task aTask : selectedTasks)
       {
           ActivityWrapper aw = new ActivityWrapper();
           aw.isTask = true;
           aw.aTask = aTask;
           selActivities.add(aw);
       }            
                                   
        List<Event> allEvents = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, OwnerId, Owner.Name 
                                 FROM Event 
                                 WHERE Id IN :selectedActivityIds];
        
        for(Event anEvent : allEvents)
        {
            ActivityWrapper aw = new ActivityWrapper();
            aw.isTask = false;
            aw.anEvent = anEvent;
            selActivities.add(aw);
        }
       
       
       
       return selActivities;
   }
   
   Public List<ActivityWrapper> getSelectedActivities3()
   {
       Set<Id> selectedActivityIds = new Set<Id>();
       
       if(ap.Upcoming_Events__c != null)
       {
           for(String s : ap.Upcoming_Events__c.split(','))
               selectedActivityIds.add(Id.valueOf(s));
       }
   
       List<ActivityWrapper> selActivities = new List<ActivityWrapper>();
       
       List<Task> selectedTasks = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, Status, Priority, OwnerId, Owner.Name 
                                   FROM Task
                                   WHERE Id IN :selectedActivityIds];
       for(Task aTask : selectedTasks)
       {
           ActivityWrapper aw = new ActivityWrapper();
           aw.isTask = true;
           aw.aTask = aTask;
           selActivities.add(aw);
       }            
                                   
        List<Event> allEvents = [SELECT subject, WhoID, Who.Name, WhatId, What.Name, ActivityDate, OwnerId, Owner.Name 
                                 FROM Event 
                                 WHERE Id IN :selectedActivityIds];
        
        for(Event anEvent : allEvents)
        {
            ActivityWrapper aw = new ActivityWrapper();
            aw.isTask = false;
            aw.anEvent = anEvent;
            selActivities.add(aw);
        }
   
       
             
       return selActivities;   
   }
   
   Public List<ActivityWrapper> getEventView()
   {
  
       
      If (activityType=='Events')
          return paginatedEvents[pageNumber - 1];
          
      return null;                        
   }
   
   Public List<ActivityWrapper> getTaskView()
   {
       if(activityType=='Tasks')
           return paginatedTasks[pageNumber - 1];
       
       return null;
   }
   
   public PageReference doPrevious()
   {
       pageNumber--;
       return null;
   }
   
   public boolean getHasPrevious()
   {
       if(pageNumber > 1)
           return true;
           
       return false;
   }
   
   public integer getTotalPages()
   {
       if(activityType == 'Events')
           return paginatedEvents.size();
           
       return paginatedTasks.size();
   }
   
   public pageReference doNext()
   {
       pageNumber++;
       return null;
   }
   
   public boolean getHasNext()
   {
       if(activityType == 'Events' && paginatedEvents.size() > pageNumber)
           return true;
           
       if(activityType == 'Tasks' && paginatedTasks.size() > pageNumber)
           return true;
           
       return false;
   }
   
   public pageReference switchView()
   {
       pageNumber = 1;
       return null;
   }
   
   public pageReference submitForApproval()
   {
       
       boolean errorFound = false;
       
      
       
       if(ap.Timing_1__c > ap.Timing_End_Date_1__c)
       {
           errorFound = true;
           ap.Timing_End_Date_1__c.addError('Begin Date can not be later than the End Date (CA Accountability Matrix)');
       }
       if(ap.Timing_2__c > ap.Timing_End_Date_2__c)
       {
           errorFound = true;
           ap.Timing_End_Date_2__c.addError('Begin Date can not be later than the End Date (CA Accountability Matrix)');
       }
       if(ap.Timing_3__c > ap.Timing_End_Date_3__c)
       {
           errorFound = true;
           ap.Timing_End_Date_3__c.addError('Begin Date can not be later than the End Date (CA Accountability Matrix)');
       }
       if(ap.Timing_4__c > ap.Timing_End_Date_4__c)
       {
           errorFound = true;
           ap.Timing_End_Date_4__c.addError('Begin Date can not be later than the End Date (CA Accountability Matrix)');
       }
       if(ap.Timing_5__c > ap.Timing_End_Date_5__c)
       {
           errorFound = true;
           ap.Timing_End_Date_5__c.addError('Begin Date can not be later than the End Date (CA Accountability Matrix)');
       }
       if(ap.Corresponding_IT_Initiatives_1__c == NULL || ap.Corresponding_IT_Initiatives_1__c == '')
       {
           errorFound = true;
           ap.Corresponding_IT_Initiatives_1__c.addError('This is a required field. Please enter at least one Corresponding IT Initiative.');
       }
       if(ap.Corresponding_IT_Initiatives_Type_1__c == NULL)
       {
           errorFound = true;
           ap.Corresponding_IT_Initiatives_Type_1__c.addError('The Corresponding IT Initiative type needs to be populated');
       }
       if(ap.External_Business_Climate_Trends__c == NULL || ap.External_Business_Climate_Trends__c == '')
       {
           errorFound = true;
           ap.External_Business_Climate_Trends__c.addError('External Business Climate & Trends needs to be populated');
       }
       if(ap.Key_Account_Objectives__c == NULL || ap.Key_Account_Objectives__c == '')
       {
           errorFound = true;
           ap.Key_Account_Objectives__c.addError('Key Account Objectives needs to be populated');
       }
       
       
       
       if(ap.Overall_Account_Strategy__c == NULL || ap.Overall_Account_Strategy__c == '')
       {
           errorFound = true;
           ap.Overall_Account_Strategy__c.addError('This is a required field.  Please enter Overall Account Strategy.');
       }
       
      
       
       if(ap.Stated_Business_Priorities__c == NULL || ap.Stated_Business_Priorities__c == '')
       {
           errorFound = true;
           ap.Stated_Business_Priorities__c.addError('This is a required field.  Please enter Stated Business Priorities.');
       }
       if(ap.Underlying_Business_Initiatives_1__c == NULL || ap.Underlying_Business_Initiatives_1__c == '')
       {
           errorFound = true;
           ap.Underlying_Business_Initiatives_1__c.addError('This is a required field.  Please enter at least one Underlying Business Initiative.');
       }
       if(ap.Underlying_Business_Initiatives_type_1__c == NULL)
       {
           errorFound = true;
           ap.Underlying_Business_Initiatives_type_1__c.addError('The Underlying Business Initiative type needs to be populated');
       }
       
       if(errorFound)
           return Page.AccountPlanEdit;
   
       Id uid = UserInfo.getUserId();
       if(uid == ap.Account__r.OwnerId)
       {
           return submitApprovalRequest();
       }
       
       Set<Id> accTeam = new Set<Id>();    
       for(AccountTeamMember atm : [SELECT UserId FROM AccountTeamMember WHERE AccountId=:ap.Account__c])
           accTeam.add(atm.UserId);
           
       if(accTeam.contains(uid))
       {
           return submitApprovalRequest();
       }
       
       ap.addError('You are not eligible to submit this item for Approval.');
       return null;
       
   }
   
         private pageReference submitApprovalRequest()
   {
      User accOwner = [SELECT ManagerId, Manager.IsActive FROM User WHERE Id=:ap.Account__r.OwnerId][0];
      
       system.debug('Acc Owner Manager'+accOwner.managerId);
          system.debug('segment'+ap.Account__r.Segment__c);

          system.debug('Coverage Model'+ap.Account__r.Coverage_Model__c);
      
      //sunji03 - FY19 Account Segment change
      //if(accOwner.managerId!=null && accOwner.Manager.IsActive==True && ap.Account__r.Segment__c==Label.SegmentVal1 && ap.Account__r.OwnerId != '00530000006ca0q' && ap.Account__r.Owner.IsActive==true)     
      if(accOwner.managerId!=null && accOwner.Manager.IsActive==True && (ap.Account__r.Segment__c==Label.SegmentVal1 || ap.Account__r.Segment__c==Label.SegmentVal4) && ap.Account__r.OwnerId != '00530000006ca0q' && ap.Account__r.Owner.IsActive==true)
      {    
          system.debug('Acc Owner Manager'+accOwner.managerId);
          system.debug('segment'+ap.Account__r.Segment__c);
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          //req1.setComments('Submitting request for approval.');
          req1.setObjectId(ap.id);
          req1.setNextApproverIds(new Id[] {accOwner.ManagerId});
        
          // Submit the approval request for the account
          Approval.ProcessResult result = Approval.process(req1);
      
          // update the approval status
          ap.Account_Plan_Status__c = [SELECT Account_Plan_Status__c FROM Account_Plan3__c WHERE Id=:ap.Id][0].Account_Plan_Status__c;
      
          return new pageReference('/' + ap.Id);
      }
      else if((ap.Account__r.Segment__c==Label.SegmentVal3||ap.Account__r.Segment__c==Label.SegmentVal2) && ap.Account__r.OwnerId != '00530000006ca0q' && ap.Account__r.Owner.IsActive==true)
      {
          
          system.debug('Acc Owner Manager'+accOwner.managerId);
          system.debug('segment'+ap.Account__r.Segment__c);
           return selectApproverManually();
           
          
        
        
      }
      else if(ap.Account__r.Owner.IsActive==false || ap.Account__r.OwnerId == '00530000006ca0q')
      {
          return selectApproverManually();
        
      }
      
      
      return new pageReference('/' + ap.Id);
   }
   
   
        private pageReference selectApproverManually()
            {
            pageReference p= new pageReference('/apex/AccountPlanManualApprover?id='+ap.Id);
            return p;
            }
   
   public pageReference saveAndCreateNewEvent()
   {
       controller.save();
       return new pageReference(New_Event_URL);
   }
   
  
  
}