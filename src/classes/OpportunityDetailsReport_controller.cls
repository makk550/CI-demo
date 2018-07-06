public with sharing class OpportunityDetailsReport_controller
{

    public List<SelectOption> lstAllRegion { get; set; }

    public List<SelectOption> lstArea { get; set; }
    public string test {get;set;}
    public string contenttype {get;set;}

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
                filter = filter + ' AND Sales_Milestone__c in ( ' + milestones + ' ) ';    
             * */
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
            /*
             if(filter == '')
                filter = ' Inside_Outside__c  in ( ' + inOut + ' )';
            else
                filter = filter + ' AND Inside_Outside__c in ( ' + inOut + ' ) ';    
             */
        }
        
        if(qtr != null && qtr != null && qtr!= '')
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
                    
        }
        
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
         
         
         if(businessUnit != null && businessUnit != '')
        {
            if(filter == '')
                filter = ' PricebookEntry.Product2.Market_Focus_Area__c  in ( \'' + businessUnit + '\' )';
            else
                filter = filter + ' AND PricebookEntry.Product2.Market_Focus_Area__c in ( \'' + businessUnit + '\' ) ';    
        }
        
       // filter = filter + (filter ==''?'': ' AND ') + ' Inside_Outside__c = \''+ Region + '\' ';
         
        if(filter != '')
            filter = ' WHERE ' + filter;
     
        return filter;
    
    }
 
    public pageReference Export()
    {
    
       /* PageReference pref = new PageReference('/apex/OpportunityDetailsReport?ctype=1');
        pref.setRedirect(true); 
        return pref;*/
        contenttype ='application/vnd.ms-excel';
        return null;
    }
    
public string region{get;set;}
public string oregion{get;set;}

    public List<SelectOption> lstMilestone {get;set;}
    public List<SelectOption> lstInsideOut {get;set;}
    public List<SelectOption> lstType {get;set;}
    public List<SelectOption> lstBusinessUnit {get;set;}
    public List<SelectOption> lstAllBusinessUnit {get;set;}
    public List<SelectOption> lstAccountTeamMemberRole {get;set;}
    public List<string> milestone{get;set;}
    
    public List<string> lstSelInsideOutside{get;set;}
    public string qtr{get;set;}
    public string oarea{get;set;}
    
    public List<string> otype{get;set;}
    public string businessUnit{get;set;}
    public string obusinessUnit{get;set;}
    public string accountTeamMemberRole{get;set;}
    
    
    public List<SelectOption> GetMilestones()
     {
            List<SelectOption> options = new List<SelectOption>();
            milestone= new List<string>();
            options.add(new SelectOption('','--None--'));
           /* Schema.DescribeFieldResult F = OpportunityLineItem.Sales_Milestone__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }  
            * */
            return options;
     }
    public List<SelectOption> GetInsideOuts()
     {
            List<SelectOption> options = new List<SelectOption>();
            lstSelInsideOutside= new List<string>();
            options.add(new SelectOption('','--None--'));
            /*Schema.DescribeFieldResult F = OpportunityLineItem.Inside_Outside__c.getDescribe();
            List<Schema.PicklistEntry> entries = F.getPicklistValues();
                 for(Schema.PicklistEntry entry : entries){
                    {
                        options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                }
             */ 
            return options;              
     }
     public List<SelectOption> GetTypes()
      {
            List<SelectOption> options = new List<SelectOption>();
            oType= new List<string>();
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
    public List<SelectOption> GetAreas()
      {
            List<SelectOption> options = new List<SelectOption>();
            obusinessUnit= '';
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
            obusinessUnit= '';
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


//Code by Saba-End


    public List<reportdetails> lst_report {get;set;}
    public List<SelectOption> sel_teamroles {get;set;} 
    public String strteamrole {get;set;}
    public List<SelectOption> sel_teammembers {get;set;} 
    public String strteammember {get;set;}
    
    private List<Opportunity> lst_opp = new List<Opportunity>(); 
    private List<Account> lst_acc = new List<Account>();
    private List<OpportunityLineItem> lst_oppli = new List<OpportunityLineItem>();
    
    //define constructor
    public OpportunityDetailsReport_controller()
    {
   
        //Initialize everything
        contenttype = '';
        ////lstMilestone = GetMilestones();
        ////lstInsideOut = GetInsideOuts();
        lstType = GetTypes();
        lstAllBusinessUnit = GetAllBusinessUnits();
        lstAccountTeamMemberRole = GetAccountTeamMemberRoles();
        lstArea  = GetAreas();
        lstAllRegion = GetAllRegions();
        
      //  lstReport = new List<Report>();
       // Run();
        
    }
     
    public PageReference Run()
    {
    
    
       lst_Report = new List<ReportDetails>();
       //FILTER ACCOUNT TEAM BY ROLES
       Set<string> setAtmRoles = new Set<string>{};
       if(AccountTeamMemberRole != null && AccountTeamMemberRole != '')
           setAtmRoles.add(AccountTeamMemberRole);
       else
           {
               for(SelectOption atmrole:lstAccountTeamMemberRole)
                  if(atmrole.getValue() != '')
                       setAtmRoles.add(atmrole.getValue());
           }     
      
     
      string strArea = '%%';
      string strRegion = '%%';
      
      if(region != null && region != '')
            strRegion  =  region;
            
      if(oArea != null && oArea != '')
              strArea = oArea;
              
      test = strRegion + ':' + strArea;
     // return null;
      
      
            
      Set<Id> accIds = new Set<Id>();
      //CREATE A  MAP B/W ATM ID AND ATM INFO
       List<AccountTeamMember> lst = new List<AccountTeamMember>();
       Map<Id,List<AccountTeamMember>> mapAtm = new Map<Id,List<AccountTeamMember>>();
       for(AccountTeamMember a: [Select a.User.Name, a.User.Alias, a.TeamMemberRole, a.Account.Parent.Enterprise_Account_Name__c, a.Account.Parent_Enterprise_ID__c, a.Account.Name, a.Account.Enterprise_ID__c, a.Account.RecordType.Name, a.Account.Sales_Area__c, a.Account.Sales_Region__c, a.Account.Region_Country__c, a.AccountId From AccountTeamMember a WHERE a.TeamMemberRole In : setAtmRoles AND  a.User.IsActive = true AND 
       Account.Sales_Region__c like : strRegion AND Account.Sales_Area__c like : strArea 
     
               ORDER BY AccountId limit 5000 ])
       {
          lst =  mapATM.get(a.accountId);
          if(!(lst != null))
              lst = new List<AccountTeamMember>();
          lst.add(a);
          mapatm.put(a.accountid,lst);
       }  
       
       //GET THE OPP LINE ITEMS INFO 
       string filter = GetFilters();
       string strquery = '';
     
       //CREATE A MAP BETWEEN ACCOUNTID AND SALES PRICE
      // Map<ID,Double> mSP = new Map<ID,Double>();
      // strquery = 'Select convertCurrency(UnitPrice), Sales_Milestone__c, Original_Expiration_Date__c, Original_Deal_Term_Months__c, New_Deal_Term_Months__c, Inside_Outside__c, Drawdown_from_Prepaid_Funds__c, Close_Date__c, Business_Type__c From OpportunityLineItem ' + filter + ' ORDER BY  Opportunity.AccountId limit 5000 ';
      
       test  = 'length of acc ids is : ' + mapAtm.keySet().size() + ' and filter is :: ' + filter  ;
       
     // return null;
      
       strquery = 'Select convertCurrency(UnitPrice), Original_Expiration_Date__c, Original_Deal_Term_Months__c, New_Deal_Term_Months__c, Drawdown_from_Prepaid_Funds__c,  Business_Type__c,' + 
          '  opportunity.Outsoucer__c, Opportunity.AccountId , opportunity.Opportunity_Type__c, opportunity.Opportunity_Number__c, opportunity.Next_Step_Due_Date__c, opportunity.Lead_ID__c, opportunity.IsWon, opportunity.IsClosed,convertcurrency(opportunity.Amount),opportunity.Partner__r.Name, opportunity.Reseller__r.Name '+
          ' , PricebookEntry.Product2.Solution_Sets__c, PricebookEntry.Product2.Name, PricebookEntry.Product2.Market_Focus_Area__c, PricebookEntry.Product2.Family ' +
          ' From OpportunityLineItem ORDER BY  Opportunity.AccountId limit 1000 ';
          
          for(OpportunityLineItem oli :Database.Query(strquery))
           {
            if(oli.opportunity.accountId != null && mapAtm.keySet().contains(oli.Opportunity.AccountId))
             {
                 for(AccountTeamMember a: mapAtm.get(oli.opportunity.accountId))
                     {
                        reportdetails rpt = new reportdetails();
                        rpt.acc_eaid =a.account.Enterprise_ID__c;
                        rpt.acc_name=a.account.Name;
                        
                        rpt.atm_role=a.TeamMemberRole;
                        rpt.atm_name=a.User.Name;
                        rpt.atm_pmf=a.User.Alias;
                        rpt.acc_area=a.Account.Sales_Area__c;
                        rpt.acc_territory=a.Account.Sales_Region__c;
                        rpt.acc_country=a.Account.Region_Country__c;
                        rpt.oppli_bustype=oli.Business_Type__c;
                        
                        rpt.opp_won=oli.opportunity.IsWon;
                        rpt.opp_closed=oli.opportunity.IsClosed;
                        rpt.opp_number=oli.opportunity.Opportunity_Number__c;
                        rpt.opp_partner=oli.opportunity.Partner__r.Name;
                        rpt.opp_reseller=oli.opportunity.Reseller__r.Name;
                        rpt.opp_totalpriceconv=oli.UnitPrice;
                        rpt.opp_amountconv =oli.opportunity.Amount;
                        rpt.prd_family=oli.PricebookEntry.Product2.Family;
                        rpt.prd_name=oli.PricebookEntry.Product2.Name;
                        rpt.prd_bu=oli.PricebookEntry.Product2.Market_Focus_Area__c;
                        rpt.prd_ncvdriver=oli.PricebookEntry.Product2.Solution_Sets__c;
                        rpt.opp_opptype=oli.opportunity.Opportunity_Type__c;
                        
                        rpt.opp_leadid=oli.opportunity.Lead_ID__c;
                        //rpt.opp_salesnextstep=oli.opportunity.Sales_Next_Step__c;
                        rpt.opp_nextstepduedate= oli.opportunity.Next_Step_Due_Date__c;
                        rpt.oppli_prepaidfunds=oli.Drawdown_from_Prepaid_Funds__c;
                        rpt.oppli_dealterm=oli.New_Deal_Term_Months__c;
                        rpt.oppli_origdealterm=oli.Original_Deal_Term_Months__c;
                        rpt.oppli_origexpdate=oli.Original_Expiration_Date__c;
                        rpt.acc_recordtype=a.Account.RecordType.Name;
                        rpt.acc_parentEntId = a.Account.Parent.Enterprise_Account_Name__c;
                        rpt.acc_parentEntname = a.Account.Parent_Enterprise_ID__c;
                        rpt.opp_outsourcer = oli.opportunity.Outsoucer__c;
                        if(lst_Report.size()< 1000)
                            lst_Report.add(rpt);
                        else
                            break;    
                     }
             }   
           }
       
        
        return null;
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
    
    
    //wrapper class that contains variables to all fields that need to be displayed/binded on the report.
    public class reportdetails
    {
        public String acc_eaid {get;set;}
        public String acc_name {get;set;}
        public String oppli_insout {get;set;}
        public String atm_role {get;set;}
        public String atm_name {get;set;}
        public String atm_pmf {get;set;}
        public String acc_area {get;set;}
        public String acc_territory {get;set;}
        public String acc_country {get;set;}
        public String oppli_bustype {get;set;}
        public String oppli_milestone {get;set;}
        public Boolean opp_won {get;set;}
        public Boolean opp_closed {get;set;}
        public String opp_number {get;set;}
        public Decimal opp_totalpriceconv {get;set;}
        public Decimal opp_amountconv{get;set;}
        public String prd_family {get;set;}
        public String prd_name {get;set;}
        public String prd_bu {get;set;}
        public String prd_ncvdriver {get;set;}
        public String opp_opptype {get;set;}
        public Date oppli_closedate {get;set;}
        public String opp_leadid {get;set;}
        public String opp_salesnextstep {get;set;}
        public Date opp_nextstepduedate {get;set;}
        public Boolean oppli_prepaidfunds {get;set;}
        public Decimal oppli_dealterm {get;set;}
        public Decimal oppli_origdealterm {get;set;}
        public Date oppli_origexpdate {get;set;}
        public String acc_recordtype {get;set;}
        public String opp_partner {get;set;}
        public String opp_reseller{get;set;}
        public string acc_parentEntId{get;set;}
        public string acc_parentEntName{get;set;}
        public string opp_outsourcer{get;set;}
        
        
        
         
    }
   
    static testmethod void runTestCases() 
    { 
        Profile pr = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'sabaTest', email='sabaTest11@ca.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = pr.Id, 
                timezonesidkey='America/Los_Angeles', username='sabaTest11@ca.com');
                System.runAs(u2) {
                    OpportunityDetailsReport_controller  cls = new OpportunityDetailsReport_controller();
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
                    a.Sales_Area__c= 'JAPAN';
                    a.Sales_Region__c= 'JAPAN';
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
                    try{
                    insert lst;
                    } 
                    catch (exception e)
                    {
                        System.debug('error...');
                    }
                      account p = new account(name = 'par', recordtypeid = com);
                        p.customer_Category__c= 'MSP';
                        p.hq__c= true;
                        p.Commercial_Account_Name__c='test 11111111'  ;
                        p.Commercial_ID__c= 'test 11111112';
                        p.Country_Picklist__c= 'CA - CANADA';
                        p.GEO__c= 'NA';
                        p.Sales_Area__c= 'CANADA';
                        p.Sales_Region__c= 'CANADA';
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
                    p1.GEO__c= 'NA';
                    p1.Sales_Area__c= 'CANADA';
                    p1.Sales_Region__c= 'CANADA';
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
              //      insert opp;
                    OpportunityLineItem oli = new OpportunityLineItem();
                     oli.Opportunityid = opp.id;
              //      insert oli;  
                   
                    reportdetails rpt = new reportdetails();
                  cls.qtr = 'q-1';
                  cls.milestone = new List<string>();
                   cls.milestone.add( '10% - test');
                    cls.milestone.add('20% - test');
                   cls.lstSelInsideOutside = new List<String>();
                   cls.lstSelInsideOutside.add('test1');
                   cls.lstSelInsideOutside.add('test2');
                    cls.run(); 
                    cls.qtr = 'q-1,q2';
                    cls.run(); 
                    
                    cls.oType = new List<string>{'test'};          
                    cls.run(); 
                    
                    cls.milestone = new List<string>();
                    cls.milestone.add( '10% - test');
                    cls.milestone.add('20% - test');
                    cls.run(); 
                    
                    cls.lstSelInsideOutside = new List<string>();
                    cls.lstSelInsideOutside.add( 'Inside');
                    cls.lstSelInsideOutside.add('Outside');
                    cls.Run();
                    cls.Export();  
                  
                }    
    }

    
}