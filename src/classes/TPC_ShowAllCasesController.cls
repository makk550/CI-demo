public class TPC_ShowAllCasesController{
    public User communityUser;
    public String filterType{get;set;}{filterType = 'Open';}
    public String query1{get;set;}
    public String fields = 'Id,caseNumber,Site_Association__r.Name,Internal_Priority__c,Site_Association__r.SC_TOPS_ID__c,contact.Name,Troubleshooting_Stage__c,status,subject,Priority,Severity__c,Owner.Alias,Owner.Name,CA_product_Controller__r.Name,CA_Product_Component__r.Name,createdDate,ClosedDate,Age_Of_a_Case__c';
    public String queryString{get;set;}
    public List<SelectOption> siteIds{get;set;}{siteIds = new List<SelectOption>();}
    public List<SelectOption> views{get;set;}{views= new List<SelectOption>();}
    public List<SelectOption> assignedTo{get;set;}{assignedTo = new List<SelectOption>();}
    public String sortFieldSave = 'case.Internal_Priority__c';
    public String selectedSite{get;set;}
    public String assignedValue{get;set;}{assignedValue = 'Me';}
    public Boolean showNoTeamMessage{get;set;}
    
    public String test{get;set;}
    public TPC_ShowAllCasesController(){
        communityUser = [select id,contact.TPC_Team__c,contact.TPC_Team__r.Tops_Site_Id__c,firstName,LastName from user where id=: UserInfo.getUserId()];
        if(communityUser.contact.TPC_Team__C != null){
            //String queryString = 'Select '+fields+' from case where TPC_Team__c =\''+ communityUser.contact.TPC_Team__C +'\'';
            //cases = Database.query(queryString);
            queryString = 'Select '+fields+' from case where TPC_Team__c =\''+ communityUser.contact.TPC_Team__C +'\'' ;
        
            if(assignedValue == 'Me'){
                queryString += ' and Owner.Id =\''+ communityUser.Id+'\'';  
            }
            
            if(filterType == 'Open'){
                queryString += ' and (status =\'open\' OR status =\'verify\')';
            }                
    
            
            String querySort = ' ORDER BY ' + String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDirection) + ' LIMIT 10000';
            queryString += querySort;
        }
        else
            showNoTeamMessage = true;
        siteIds.add(new selectOption('All','All'));
        if(communityUser.contact.TPC_Team__r.Tops_Site_Id__c != NULL && communityUser.contact.TPC_Team__r.Tops_Site_Id__c != ''){    
            Set<String> sitedId = new Set<String>();
            for(String site : communityUser.contact.TPC_Team__r.Tops_Site_Id__c.split(';')){     
                System.debug('**********site***'+site);
                sitedId.add(site);
            }
            for( Site_Association__c siteObj : [SELECT Id,SC_TOPS_ID__c  , Name FROM Site_Association__c where SC_TOPS_ID__c   in : sitedId ] ){
                siteIds.add(new selectOption(siteObj.SC_TOPS_ID__c  ,siteObj.SC_TOPS_ID__c  +','+siteObj.Name));
            }
           
        }
        Map<String,String> viewsMap = new Map<String,String>{'Open/verify' => 'Open','Closed' =>'Closed'};
        views.add(new selectOption('All','All'));
        for(String filter: viewsMap.keySet()){
                views.add(new selectOption(viewsMap.get(filter) ,filter));
        }
        Map<String,String> assignedToMap = new Map<String,String>{'Me' => 'Me','My Team' =>'MyTeam'};
        for(String key: assignedToMap.keySet()){
                assignedTo.add(new selectOption(assignedToMap.get(key) ,key));
        }
    }
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null && queryString != NULL && queryString != ''){
                size = 10;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    
    Public List<Case> getCases(){
        List<Case> CaseList = new List<Case>();
        if(setCon != NULL){
            for(Case caseRecord : (List<Case>)setCon.getRecords())
                CaseList.add(caseRecord);
        }
        return CaseList;
    }
    
    public pageReference refresh() {
        setCon = null;
        getCases();
        setCon.setPageNumber(1);
        return null;
    }
    
    public Boolean hasNext {
        get {
            if(setCon != NULL)
            	return setCon.getHasNext();
            else
                return false;
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            if(setCon != NULL)
            	return setCon.getHasPrevious();
            else
                return false;
        }
        set;
    }
    
    public Integer pageNumber {
        get {
            if(setCon != NULL)
            	return setCon.getPageNumber();
            else
                return 0;
        }
        set;
    }
    
    public void first() {
        if(setCon != NULL)
       		setCon.first();
    }
    
    public void last() {
        if(setCon != NULL)
        	setCon.last();
    }
    
    public void previous() {
        if(setCon != NULL)
        	setCon.previous();
    }
    
    public void next() {
        if(setCon != NULL)
        	setCon.next();
    }
        
     public void FilterCase(){  
        String query;
        if(communityUser != null){
            query = 'Select '+fields+' from case where TPC_Team__c =\''+ communityUser.contact.TPC_Team__C +'\'';
            if(selectedSite != 'All'){
                query += 'and Site_Association__r.SC_TOPS_ID__c =\''+ selectedSite+'\'';
            }else{
                 query = 'Select '+fields+' from case where TPC_Team__c =\''+ communityUser.contact.TPC_Team__C +'\'';
            }
            if(assignedValue == 'Me'){
                query +=' and Owner.Id =\''+ communityUser.Id+'\'';  
            }
            String filter ;
            if(filterType == 'Open'){
                filter = ' and (status =\'open\' OR status =\'verify\')';
            }else if(filterType == 'Closed'){      
                 filter = ' and status =\'closed\''; 
            }else{      
                filter =  null;  
            }
            if(filter!=null){
                query +=filter;
            }
            query1 = query;
        }
        System.debug('query****'+query);
        if(query!=null){
            setCon = null;
            queryString = query;
             String querySort = ' ORDER BY ' + String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDirection) + ' LIMIT 10000';
             queryString +=querySort;
            //setCon =  new ApexPages.StandardSetController(Database.getQueryLocator(query));
            getCases();
        }        
    } 
    
    public void BuildQuery(){
        setCon =null;
        String query  = queryString.split('ORDER BY')[0];
        String querySort = ' ORDER BY ' + String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDirection) + ' LIMIT 10000';
        
        query +=querySort;
        test = query;
        queryString = query;
        System.debug('query--->'+query);
        getCases();
        
    }
    
    /***
    * Sort Direction - return sort direction. Default ascending (asc)
    ***/
    public String sortDirection {
        get { if (SortDirection == null) {  sortDirection = 'asc'; } return sortDirection;  }
        set;
    }
    
    /***
    * SortField - return sort by field. Default to Name
    ***/
    public String sortField {
        get { if (SortField == null) {SortField = 'case.Internal_Priority__c'; } return SortField;  }
        set; 
    }
      /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    public void sortToggle() {
        sortDirection = sortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (sortFieldSave != sortField) {
             sortDirection = 'asc';
            
            sortFieldSave = sortField;
        }
        // run the query again
        BuildQuery();
    }
    
}