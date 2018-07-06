public class ReferralPortalOppPaginationController {
    //public String ObjectDatatype{get;set;}
    public String SearchName {get; set;}
    @TestVisible private String SaveSearchName;
    private String MainQuery;
    public list<Opportunity> LeadList {get; set;}
    public ID loggedinUserid{get; set;} 
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;}  
    public String topDateFiltervalue {get; set;}
    @TestVisible private String savedtopDateFiltervalue;
    public list<SelectOption> topDateFilter {get; set;}
    public String topdaysFiltervalue {get; set;}
    @TestVisible private String savedtopdaysFiltervalue;
    public list<SelectOption> topdaysFilter {get; set;}
    public String SortFieldSave;
    Public User CurrentUserRec{get; set;}
    public ReferralPortalOppPaginationController(){
         SortFieldSave = SortField;
        CurrentUserRec = [select id,Contact.Country_Picklist__c,Related_Partner_Account__c,ContactID,Country from User where id = :UserInfo.getUserId() limit 1];
         LeadList = new list<Opportunity>();
        
         //records for page initialization
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10','10'));
        RecPerPageOption.add(new SelectOption('25','25'));
        RecPerPageOption.add(new SelectOption('50','50'));
        RecPerPageOption.add(new SelectOption('100','100'));
        RecPerPageOption.add(new SelectOption('200','200'));
        RecPerPage = '10'; //default records per page
        
        //Date filter options initialization
        topDateFilter = new list<SelectOption>();
        //topDateFilter.add(new SelectOption('LastModifiedDate','Last Updated'));
        topDateFilter.add(new SelectOption('CreatedDate','Date Created'));
        topDateFiltervalue = 'CreatedDate'; //default Date filter options
        
        //Day filter options initialization
        topdaysFilter = new list<SelectOption>();
        topdaysFilter.add(new SelectOption('YESTERDAY','Yesterday'));
        topdaysFilter.add(new SelectOption('TODAY','Today'));
        topdaysFilter.add(new SelectOption('LAST_WEEK','Last week'));
        topdaysFilter.add(new SelectOption('THIS_WEEK','This week'));
        topdaysFilter.add(new SelectOption('LAST_MONTH','Last Month'));
        topdaysFilter.add(new SelectOption('THIS_MONTH','This Month'));
        topdaysFilter.add(new SelectOption('LAST_90_DAYS','Last 90 Days'));
        topdaysFilter.add(new SelectOption('THIS_QUARTER','This Quarter'));
        topdaysFilter.add(new SelectOption('LAST_QUARTER','Last Quarter'));
        topdaysFilter.add(new SelectOption('THIS_YEAR','This Year'));
        topdaysFilter.add(new SelectOption('LAST_YEAR','Last Year'));
        topdaysFiltervalue = 'LAST_90_DAYS'; //default Date filter options
        BuildQuery();
    }
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set; 
    }
    /***
    * SortDirection - return sort direction. Default ascending(asc)
    ***/
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
    /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }
    public void BuildQuery() {
        StdSetControllerObject = null;
         String QueryWhere='';
        /*if( CurrentUserRec.Related_Partner_Account__c != null){
            QueryWhere = ' Where Referral_Partner_Account__c = \''+ CurrentUserRec.Related_Partner_Account__c +'\'';
        }else{
            QueryWhere = ' Where Referral_Partner_Account__c !=' +null  +' AND  Referral_Partner_Account__c = '+ CurrentUserRec.Related_Partner_Account__c ;
        }*/
        QueryWhere = ' Where Referral_Partner__c = \''+ CurrentUserRec.id +'\'';
        String WhereDatefilter = '';
        MainQuery = 'SELECT Id, Name, Account.Name,Referral_Approval_Status__c,Referral_Expiration_Date__c,Referral_Partner_Account__c,AccountId,StageName, Referral_Partner__c,Has_Primary_Quote__c,ARRTotal__c ,lastmodifieddate,Referral_Date__c    ' +
            ' FROM Opportunity'; 
        
        if (SaveSearchName != null) {
            QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SaveSearchName) + '%\')');
        }
       if (savedtopDateFiltervalue != null && savedtopdaysFiltervalue != null) {
            WhereDatefilter = savedtopDateFiltervalue + ' = ' + savedtopdaysFiltervalue;
           if(WhereDatefilter != null){
               QueryWhere = BuildWhere(QueryWhere, WhereDatefilter);
           }
            
        }
        
        MainQuery += QueryWhere;
        MainQuery += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
        
        system.debug('MainQuery:' + MainQuery);
    }
    
    /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;
        }
    }
    
    public ApexPages.StandardSetController StdSetControllerObject {
        get {
            if(StdSetControllerObject == null) {
                System.debug('MainQuery StdSetControllerObject'+MainQuery);
                StdSetControllerObject = new ApexPages.StandardSetController(Database.getQueryLocator(MainQuery));
                // sets the number of records in each page set
                StdSetControllerObject.setPageSize(Integer.valueOf(RecPerPage));
                System.debug('StdSetControllerObject');
            }
            return StdSetControllerObject;
        }
        set;
    }
 
    public list<Opportunity> getCurrentOppList() {
      
        LeadList = new list<Opportunity>();
        for (Opportunity a : (list<Opportunity>)StdSetControllerObject.getRecords()) {
            LeadList.add(a);
        }
       
        return LeadList;
    }
      public list<Opportunity> getExportCurrentOppList(){
        ApexPages.StandardSetController exportStdSetControllerObject = new ApexPages.StandardSetController(Database.getQueryLocator(MainQuery));
       
        return (list<Opportunity>)exportStdSetControllerObject.getRecords();
    } 
    
    public PageReference SearchLeadName() {
        SaveSearchName = SearchName;
        
        BuildQuery();
        
        return null;
    }
   
    public PageReference SearchLastModifiedAndCreated() {
        savedtopDateFiltervalue = topDateFiltervalue;
        savedtopdaysFiltervalue = topdaysFiltervalue;
        System.debug('SearchLastModifiedAndCreated' + topDateFiltervalue + '  '+ topdaysFiltervalue);
        
        BuildQuery();
        
        return null;
    }
    public PageReference exportData() {
        pageReference pageref = new pageReference('/apex/referralOppexport');
        pageRef.setRedirect(true);
        return pageRef;
    }


}