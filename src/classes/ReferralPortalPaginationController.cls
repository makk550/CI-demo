public class ReferralPortalPaginationController {
    //public String ObjectDatatype{get; set;}
    public String SearchName {get; set;}
    private String SaveSearchName;
    private String MainQuery;
    public list<Lead> LeadList {get; set;}
    public ID loggedinUserid{get; set;} 
    public ID ReferralProfileID;
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;}  
    public String topDateFiltervalue {get; set;}
    private String savedtopDateFiltervalue;
    public list<SelectOption> topDateFilter {get; set;}
    public String topdaysFiltervalue {get; set;}
    private String savedtopdaysFiltervalue;
    public list<SelectOption> topdaysFilter {get; set;}
    public String SortFieldSave;
    Public User CurrentUserRec{get; set;}
    
    public ReferralPortalPaginationController(){
         SortFieldSave = SortField;
         CurrentUserRec = [select id,Contact.Country_Picklist__c,Related_Partner_Account__c,ContactID,Country from User where id = :UserInfo.getUserId() limit 1];
         LeadList = new list<Lead>();
        
        //data items per page
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10','10'));
        RecPerPageOption.add(new SelectOption('25','25'));
        RecPerPageOption.add(new SelectOption('50','50'));
        RecPerPageOption.add(new SelectOption('100','100'));
        RecPerPageOption.add(new SelectOption('200','200'));
        RecPerPage = '10'; 
        
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
    
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
        }
        BuildQuery();
    }
    public void BuildQuery() {
        StdSetControllerObject = null;
        String QueryWhere='';
        DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        /*if( CurrentUserRec.Related_Partner_Account__c != null){
            QueryWhere = ' Where Referral_Partner_Account__c = \''+ CurrentUserRec.Related_Partner_Account__c +'\' AND Status != \'converted\'';
        }else{
            QueryWhere = ' Where Referral_Partner_Account__c !=' +null  +' AND  Referral_Partner_Account__c = '+ CurrentUserRec.Related_Partner_Account__c ;
        }*/
        QueryWhere = ' Where Referral_Expiration_Date__c >=  TODAY AND Referral_Partner__c = \''+ CurrentUserRec.id +'\' AND Status != \'converted\'';
        
        String WhereDatefilter = '';
        MainQuery = 'SELECT Id, Name, Company,Status, Comments_Field__c,No_Interest_Reason__c, Referral_Partner__c,Referral_Expiration_Date__c,lastmodifieddate,Referral_Date__c  ' +
            ' FROM Lead'; 
       if (SaveSearchName != null) {
            QueryWhere = BuildWhere(QueryWhere, ' (Name LIKE \'%' + String.escapeSingleQuotes(SaveSearchName) + '%\')');
        }
       if (savedtopDateFiltervalue != null && savedtopdaysFiltervalue != null) {
           WhereDatefilter = savedtopDateFiltervalue + ' = ' + savedtopdaysFiltervalue;
           System.debug('WhereDatefilter' + WhereDatefilter);
           if(WhereDatefilter != null){
               QueryWhere = BuildWhere(QueryWhere, WhereDatefilter);
           }
            
        }
        MainQuery += QueryWhere;
        MainQuery += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
    }
    
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
       
    public list<Lead> getCurrentLeadList() {
        LeadList = new list<Lead>();
        for (Lead a : (list<Lead>)StdSetControllerObject.getRecords()) {
            LeadList.add(a);
        }
       
        return LeadList;
    }
    public list<Lead> getExportCurrentLeadList(){
        ApexPages.StandardSetController exportStdSetControllerObject = new ApexPages.StandardSetController(Database.getQueryLocator(MainQuery));
       
        return (list<Lead>)exportStdSetControllerObject.getRecords();
    } 
    public PageReference SearchLeadName() {
        SaveSearchName = SearchName;
        
        BuildQuery();
        
        return null;
    }

    public PageReference SearchLastModifiedAndCreated() {
        savedtopDateFiltervalue = topDateFiltervalue;
        savedtopdaysFiltervalue = topdaysFiltervalue;
        BuildQuery();
        
        return null;
    }
    public PageReference exportData() {
        pageReference pageref = new pageReference('/apex/referralexport');
        pageRef.setRedirect(true);
        return pageRef;
    }


}