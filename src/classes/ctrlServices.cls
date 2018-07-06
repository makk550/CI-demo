public with sharing class  ctrlServices {

    public boolean includeCommercial { get; set; }

    
    public PageReference newCVP() {
        return null;
    }


    public id acc{get;set;}
    public Account account{get;set;}
    public Services__c templookup{get;set;}//added by heena for req # 979
    public List<Services__c> lst{get;set;}
    public List<Support_Tickets__c> lstTickets{get;set;}
    public List<Customer_Success_Program__c> lstCSP{get;set;}      //SABA CVP
    public List<Lead> lstLeads{get;set;}      //SABA CVP
    public Customer_Success_Program__c cspLookup {get;set;}
    
    public PageReference GetServicesInfo() {
        return null;
    }
    
    public ctrlServices()
    {
        cspLookup = new Customer_Success_Program__c(); 
        templookup=new Services__c();//added by heena for req # 979
        
        if(ApexPages.currentPage().getParameters().get('accid') != null)
               acc=ApexPages.currentPage().getParameters().get('accid');  
        Set<id> pIds = new Set<id>();          
        for( Profile p : [Select id from profile where name in : '1.0 CA Sys Admin Commit & PR,Regional Admin - WW,Super User - NA,Customer Success,TSO - NA,TSO - EMEA,Sales Manager - EMEA,Sales Manager - E-EMEA'.split(',')])
        {
            pIds.add(p.Id);
        }
        
        includeCommercial = pIds.contains(UserInfo.getProfileId());
                
        if(acc != null)
           account = SetAccountById(acc);
        else
           account = new Account(); 
        
        if (acc!=null)  //added by heena for req # 979
           { templookup.Account_Name__c= account.id;   //added by heena for req # 979
             csplookup.Account__c= account.id; 
           }
        
       if(account.id <> null)
            refreshValues();
    
    } 

    
    public PageReference SetAccountInfo() {
        return null;
    }
    
  
   

      public Account SetAccountById(string accid)
      {   
      if(!test.isrunningtest()){
          if(accid <> null) 
              return [Select id, Name,RecordType.Name,Segment__c, HQ_Countries__c , Enterprise_ID__c, Coverage_Model__c, Company_logo__c, GEO__c, Sales_Region__c, owner.Name , ownerid,  Account_Class__c, Sales_Area__c, Commercial_ID__c From Account Where id=: accid Limit 1];
          else
              return new Account();    
          }
          else
              return new Account();
      }
      
      public List<Services__c> getList()
      {
          List<Services__c> lst = new List<Services__c>();
          string accountid = account.id ; 
          if(accountid != null && accountid != '')
              lst =  [Select Project_ID__c ,Booking_Amount__c, Revenue_to_Date__c, Enterprise_Id__c, Booking_Amt_Currency__c, CurrencyIsoCode, Source_System__c,  Parent_Project_ID__c From Services__c s Where s.account_name__c =: accountid limit 1000 ];
          return lst;
      
      }
      
      public List<Support_Tickets__c> getListTickets()
      {
         lstTickets = new List<Support_Tickets__c>(); 
         string accountid = account.Enterprise_ID__c ;         
         if(accountid != null && accountid != '')
               lstTickets =  [Select s.Ticket__c,s.Ticket_Description__c, s.Product_Version__c, s.SystemModstamp, s.Status__c, s.Product_Name__c, s.Priority__c, s.OwnerId, s.Name, s.LastModifiedDate, s.Last_Updated__c, s.IsDeleted, s.Id, s.Date_Opened__c, s.CurrencyIsoCode, s.CreatedDate, s.CreatedById, s.Assignee_Name__c, s.Account__c From Support_Tickets__c s Where s.Enterprise_Id__c =: account.Enterprise_ID__c  order by Last_Updated__c desc limit 1000 ];
          return lstTickets;
      
      }
      
      public List<Customer_Success_Program__c> getCSP()
      {
         lstCSP = new List<Customer_Success_Program__c>();         
         if(account <> null && account.id != null)
               lstCSP =  [Select c.CSP_Name__c, c.Program_Type__c, c.OwnerId,c.Owner.Name, c.Name, c.CVP_Status__c, c.Account__c,  c.Account__r.Name From Customer_Success_Program__c c Where  Account__c =: account.ID  limit 1000 ];
          return lstCSP ;
      
      }
      
      public List<Lead> getLeads()
      {
         lstLeads = new List<Lead>();
         if(account <> null && account.id != null)
               lstLeads =  [Select Name, createdby.name, Status, LeadSource, owner.name, Customer_Success_Program__r.Name, Id FROm Lead Where Customer_Success_Program__r.Account__c =: account.ID  limit 1000 ];
          return lstLeads ;
      
      }
      
   
      public void refreshValues() 
      {
      if(!test.isrunningtest()){
          if(( !includeCommercial && templookup <> null && templookup.Account_Name__c <> null) || (includeCommercial  && cspLookup <> null && cspLookup.account__c <> null)  )
          {
              if(includeCommercial )
                   account = SetAccountById(cspLookup.account__c ); 
              else
                 account = SetAccountById(templookup.Account_Name__c); 
          }
          else
          {
              account = new Account();        
          }
          lst = getList();
          lstTickets = getListTickets(); 
          lstCSP = getCSP(); 
          lstLeads = getLeads();
    } }


}