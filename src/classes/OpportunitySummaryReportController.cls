public with sharing class OpportunitySummaryReportController 
{
    public string test {get;set;}
    public string contenttype {get;set;}

    public List<SelectOption> lstMilestone {get;set;}
    public List<SelectOption> lstInsideOut {get;set;}
    public List<SelectOption> lstType {get;set;}
    public List<SelectOption> lstBusinessUnit {get;set;}
    public List<SelectOption> lstAllBusinessUnit {get;set;}
    public List<SelectOption> lstRegion {get;set;}
    public List<SelectOption> lstArea {get;set;}
    public List<SelectOption> lstAllRegion {get;set;}
    
    public List<SelectOption> lstAccountTeamMemberRole {get;set;}
    
    public List<string> milestone{get;set;}
    public List<string> lstSelInsideOutside{get;set;}
    public string qtr{get;set;}
    public List<string> otype{get;set;}
    public string businessUnit{get;set;}
    public string obusinessUnit{get;set;}
    public string oRegion{get;set;}
    public string Region{get;set;}
    public string oArea{get;set;}
    public string accountTeamMemberRole{get;set;}
    
    public List<Report> lstReport{get;set;}
        
    public OpportunitySummaryReportController()
    {
        contenttype = '';
        //lstMilestone = GetMilestones();
        //lstInsideOut = GetInsideOuts();
        
        lstType = GetTypes();
        lstAllBusinessUnit = GetAllBusinessUnits();
        
        lstArea = GetArea();
        lstAllRegion = GetAllRegions();
        
        lstAccountTeamMemberRole = GetAccountTeamMemberRoles();
        lstReport = new List<Report>();
       // Run();
    }
    
    
    public PageReference Run() {
       lstReport = new List<Report>();
       //1.GET THE OPP LINE ITEMS INFO 
       string filter = GetFilters();
       string strquery = '';
       
       //CREATE A MAP BETWEEN ACCOUNTID AND SALES PRICE
       Map<ID,Double> mSP = new Map<ID,Double>();
       
       strquery = 'Select convertCurrency(UnitPrice), Opportunity.AccountId From OpportunityLineItem ' + filter + ' ORDER BY  Opportunity.AccountId limit 5000 ';
       for(OpportunityLineItem opl :Database.Query(strquery))
       {
           double salesPrice = 0;
           if(mSP.Get(opl.Opportunity.AccountId) != null)
               salesPrice = mSP.Get(opl.Opportunity.AccountId);
           if(opl.UnitPrice != null)     
               salesPrice = salesPrice + opl.UnitPrice;
           mSP.put(opl.Opportunity.AccountId,opl.UnitPrice);
       }     
       
       test  = 'length of acc ids is : ' + mSP.keySet().size() + ' and filter is :: ' + filter  ;
       
       Set<string> setAtmRoles = new Set<string>{};
       if(AccountTeamMemberRole != null && AccountTeamMemberRole != '')
           setAtmRoles.add(AccountTeamMemberRole);
       else
           {
               for(SelectOption atmrole:lstAccountTeamMemberRole)
                  if(atmrole.getValue() != '')
                       setAtmRoles.add(atmrole.getValue());
           }     
       
       //SELECT USERS FROM ACCOUNT TEAM MEMBERS
       Id userId = null;
       Integer records = 0;
       double total = 0;
       AccountTeamMember atm = null;
       string searchArea = '%%';
       string searchRegion = '%%';
       if(Region != null && Region != '')
            searchRegion = Region;
       if(oArea != null && oArea != '')
           searchArea = oArea;
       test = searchArea + ',' + searchRegion;
      
         
       for(AccountTeamMember a: [Select a.User.Name, a.User.Alias, a.TeamMemberRole, a.AccountId, a.Account.Sales_Region__c , a.Account.Sales_Area__c From AccountTeamMember a WHERE a.AccountId in : mSP.keySet() AND a.TeamMemberRole In : setAtmRoles AND  a.User.IsActive = true AND a.Account.Sales_Region__c like : searchRegion  AND a.Account.Sales_Area__c like : searchArea  ORDER BY UserId limit 5000 ])
       {
           total = total + mSP.get(a.AccountId);
           if(userId != null && userId != a.UserId && records < 1000)
               {
                   lstReport.Add(new Report(atm.User.Alias,atm.User.Name,total, atm.Account.Sales_Region__c , atm.Account.Sales_Area__c));
                   records ++;
                   total =0;
               }    
           userId = a.UserId;
           atm =a;
       }
       
       if(userId != null && records < 1000)
             lstReport.Add(new Report(atm.User.Alias, atm.User.Name,total,atm.Account.Sales_Region__c , atm.Account.Sales_Area__c));
       
       return null;
    }
    
    public pageReference Export()
    {
        contenttype ='application/vnd.ms-excel#SummaryRep.xls"';
        return null;
    }
    
    
    
     public List<SelectOption> GetTypes()
      {
            List<SelectOption> options = new List<SelectOption>();
            oType= new List<string>() ;
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Product2.Family.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }

    public List<SelectOption> GetAllBusinessUnits()
      {
            List<SelectOption> options = new List<SelectOption>();
            obusinessUnit= '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
      
      public List<SelectOption> GetArea()
      {
            List<SelectOption> options = new List<SelectOption>();
            oArea= '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Sales_Area__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }

    public List<SelectOption> GetAllRegions()
      {
            List<SelectOption> options = new List<SelectOption>();
            oRegion= '';
            options.add(new SelectOption('','--None--'));
            Schema.DescribeFieldResult F = Account.Sales_Region__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            return options;
      }
      
     public List<SelectOption> GetAccountTeamMemberRoles()
     {
            List<SelectOption> options = new List<SelectOption>();
            accountTeamMemberRole= '';
            options.add(new SelectOption('','--None--'));
            List<TAQ_Account_Team_Roles_Settings__c> TATRSs= TAQ_Account_Team_Roles_Settings__c.getall().values();
            for(TAQ_Account_Team_Roles_Settings__c TATRS: TATRSs)
            {
                options.add(new SelectOption(TATRS.name, TATRS.name));
            }
            Schema.DescribeFieldResult F = AccountTeamMember.TeamMemberRole.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }
           
                  
            return options;
     }

   Public List<SelectOption> GetQuarters()
    {
        List<selectOption> opt = new List<SelectOption>();
        integer oYear = System.today().year();
        if(System.today().month() > 3)
            oYear ++;
        opt.add(new selectOption('','--None--'));    
        for(integer yr = oYear; yr <=oYear +1; yr++)
        {
            for(integer q=1;q<5;q++)
                opt.add(new selectOption('Q'+ q+'-'+yr,'Q'+ q+'-'+yr));
        }
        
        
        return opt;
    
    }
    
    public string GetFilters()
    {
        string filter = '';
        string milestones = '';
        string inout= '';
        
        for(string ms : milestone)
         {    
               if(ms != '' || milestone.size() > 1)
               {  if(milestones == '')
                     milestones = '\'' + ms + '\'';
                 else
                     milestones = milestones + ',\'' + ms + '\'';
               }         
        }
        
        if(milestones  != null && milestones != '')
        {
            /*if(filter == '')
                filter = ' Sales_Milestone__c in ( ' + milestones + ' ) ';
            else
                filter = filter + ' AND Sales_Milestone__c in ( ' + milestones + ' ) ';    */
        }
     
          for(string io : lstSelInsideOutside)
         {    
               if(io != '' || lstSelInsideOutside.size() > 1)
               {  if(inout == '')
                     inout= '\'' + io + '\'';
                  else
                     inout= inout+ ',\'' + io + '\'';
               }         
        }    
        if(inOut != null && inOut != '')
        {
            /*if(filter == '')
                filter = ' Inside_Outside__c  in ( ' + inOut + ' )';
            else
                filter = filter + ' AND Inside_Outside__c in ( ' + inOut + ' ) ';    
             * */
        }
        
        /*if(qtr != null && qtr != null && qtr!= '')
        {
           if(qtr.split(',').size() == 1)
           {        
                if(filter == '')
                    filter = ' Fiscal_Period_lineitem__c Like \'%'+ qtr.replace('*','%') + '%\' ';
                else
                    filter = filter + ' AND Fiscal_Period_lineitem__c Like \'%'+ qtr.replace('*','%') + '%\' ';
            }
            else
            {
                string quarters ='';
                 for(string q : qtr.split(','))
                    {    
                       if(q != '' || qtr.split(',').size()> 1)
                       {  if(quarters == '')
                             quarters = '\'' + q+ '\'';
                          else
                             quarters = quarters + ',\'' + q + '\'';
                       }         
                    } 
                
                 if(quarters != null && quarters != '')
                    {
                        if(filter == '')
                            filter = ' Fiscal_Period_lineitem__c   in ( ' + quarters + ' )';
                        else
                            filter = filter + ' AND Fiscal_Period_lineitem__c  in ( ' + quarters + ' ) ';    
                    }   
                
            }
                    
        }*/
        
        if(oType.size() > 0 &&  !(oType.size() ==1 && oType[0] == ''))
        {
            string vType = '';
            
            for(string tp:oType)
            {
                    
                vType = vType  +  (vType == ''?'':',') + '\'' +  tp + '\'' ;
            }
            if(filter == '')
                filter = ' PricebookEntry.Product2.Family in ( ' + vType + ' )';
            else
                filter = filter + ' AND PricebookEntry.Product2.Family in ( ' + vType + ' )';   
           
         }
       
        if(obusinessUnit != null && obusinessUnit!= '')
            {
                if(filter == '')
                    filter = ' PricebookEntry.Product2.Market_Focus_Area__c = \''+ obusinessUnit+ '\' ';
                else
                    filter = filter + ' AND PricebookEntry.Product2.Market_Focus_Area__c = \''+ obusinessUnit+ '\' ';    
            }
        if(filter != '')
            filter = ' WHERE ' + filter;
     
        return filter;
    
    }
  
     public class Report{
         public string atmpmf{get;set;}
         public string atmname{get;set;}
         public decimal salesprice{get; set;}
         public string Region{get; set;}
         public string territory{get; set;}
         
         public Report()
         {
             atmpmf ='';
             atmname = '';
             salesprice =0;
             Region ='';
             territory ='';
         }
         public Report(string vAtmpmf, string vAtmname, double vSalesprice, string vRegion, string vterritory)
         {
             atmpmf =vAtmpmf;
             atmname = vAtmname;
             salesprice =  vSalesprice;
             Region = vRegion;
             territory = vterritory;
         }
     }  

    @isTest(SeeAllData=true)
    static void runTestCases() 
    { 
        Profile pr = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'sabaTest', email='sabaTest11@ca.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = pr.Id, 
                timezonesidkey='America/Los_Angeles', username='sabaTest11@ca.com');
                System.runAs(u2) {
                    OpportunitySummaryReportController  cls = new OpportunitySummaryReportController();
                      recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
                    id res;
                    id com;
                    for(recordtype rec: recs)
                        if(rec.name == 'SMB')
                                com = rec.id;
                        else
                                res = rec.id;
                    account a = new account(name ='we', recordtypeid =res);
                    a.customer_Category__c= 'Reseller';
                    a.hq__c= true;
                    a.Commercial_Account_Name__c='test 11111114'  ;
                    a.Commercial_ID__c= 'test 11111115';
                    a.Country_Picklist__c= 'JP - JAPAN';
                    a.GEO__c= 'JAPAN';
                    a.Sales_Region__c= 'JAPAN';
                    a.Sales_Area__c= 'JAPAN';
                    a.Billingstate= 'A';
                    a.Billingcity= 'B';
                    a.Billingstreet= 'C';
                    insert a;
                     user[] users = [select id from user where isactive = true limit 10];
                    List<AccountTeamMember> lst = new List<AccountTeamMember>();
                    for(user usr:users)
                    {
                      lst.add(new AccountTeamMember(UserId = usr.Id, TeamMemberRole ='CSA', accountId = a.id));
                    }
                    try
                    {
                        insert lst;
                   }
                   catch (exception e)
                   {
                       System.debug('error');
                   }
                      account p = new account(name = 'par', recordtypeid = com);
                        p.customer_Category__c= 'MSP';
                        p.hq__c= true;
                        p.Commercial_Account_Name__c='test 11111111'  ;
                        p.Commercial_ID__c= 'test 11111112';
                        p.Country_Picklist__c= 'CA - CANADA';
                        p.GEO__c= 'PS/CAN';
                        p.Sales_Region__c= 'CANADA';
                        p.Sales_Area__c= 'PS_CANADA';
                        p.Billingstate= 'A';
                        p.Billingcity= 'B';
                        p.Billingstreet= 'C';
                        
                        
                        
                        insert p;
                    account p1 = new account(name = 'par', recordtypeid = com);
                    p1.Customer_Category__c= 'Commercial';
                    p1.Aggregate_Account__c= 'YES';
                    p1.hq__c= true;
                    p1.Commercial_Account_Name__c='test 11111111'  ;
                    p1.Commercial_ID__c= 'test 11111112';
                    p1.Country_Picklist__c= 'CA - CANADA';
                    p1.GEO__c= 'PS/CAN';
                    p1.Sales_Area__c= 'CANADA';
                    p1.Sales_Region__c= 'PS_CANADA';
                    p1.Billingstate= 'A';
                    p1.Billingcity= 'B';
                    p1.Billingstreet= 'C';
                    insert p1;
                    
                    Volume_Customer__c v = new Volume_Customer__c(name='test',account__c = p1.id);
                    insert v;
                        
                    
                    Opportunity opp = new Opportunity();
                    opp.accountid = a.id;
                    opp.name = 'test';
                    opp.stagename = Label.Opp_Stage_10_Percent;
                    opp.Ent_Comm_Account__c = p.id;
                    opp.CloseDate = date.today();
                    //opp.Volume_Account__c = v.id;
                //    insert opp;
                    
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli.Opportunityid = opp.id;
              //      insert oli;  
                  
                    cls.milestone = new List<string>();
                    cls.milestone.add( '10% - test');
                    cls.milestone.add('20% - test');
                    cls.lstSelInsideOutside = new List<string>();
                    cls.lstSelInsideOutside.add( 'Inside');
                    cls.lstSelInsideOutside.add('Outside');
                    //cls.run(); 
                    
                    cls.qtr = 'q-1';
                    //cls.run(); 
                    cls.qtr = 'q-1,q2';
                    //cls.run(); 
                    
                    cls.oType = new List<string>{'test'};          
                    //cls.run(); 
                    
                    
                    
                    
                    cls.Run();
                    cls.Export();  
                  
                    report rpt = new report();
                    
                }    
    }

}