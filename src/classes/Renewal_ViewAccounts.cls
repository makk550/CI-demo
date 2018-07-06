public class Renewal_ViewAccounts{
    public Integer currentPage = 1;
    public integer firstValue=0; // Used for PageBlockTable Pagination
    public Integer reqListSize;  // Used for PageBlockTable Pagination  
    public Integer totalPageNumber; // Used for PageBlockTable Pagination
    boolean ifNext=false;// Used for PageBlockTable Pagination
    boolean ifPrevious=false;// Used for PageBlockTable Pagination
    integer displayNum =10; // Number of records to be displayed per page
    ApexPages.StandardSetController sProducts;
    public List<SearchData> sDataLst {get; set;} 
    public String accountName {get; set;}
    public String region{get; set;}
    public String area{get; set;}
    public String territory{get; set;}
    public Decimal OCV_Greater_than{get; set;}
    public Decimal AOCV_Greater_than{get; set;}
    public String sortDirection;
    public String sortName{get;set;}
    public String sortOCV{get;set;}
    public String sortAOCV{get;set;}
    public String sortExpression {get;set;}
    public Boolean SuccessMsg {get;set;} 
 
   public String getSortDirection()
   {
      //if not column is selected 
        if (sortExpression == null || sortExpression == '')
           return 'ASC';
        else
           return sortDirection;
   }

   public void setSortDirection(String value)
   {  
     sortDirection = value;
   }
    public Renewal_ViewAccounts(){
      sortExpression = 'ocv__c';
      sortDirection = 'ASC';
      sortOCV = 'ASC';
      searchAccount();
    }        
    public void searchAccount(){
      currentPage = 0;
      totalPageNumber = 0;
      SuccessMsg = false;
      String msg = ApexPages.currentPage().getParameters().get('success');
      if(msg!=null)
          SuccessMsg = true;    
      String sortExp;
      string sortFullExp = '';
      //System.debug('sortName## '+sortName);
      if(sortExpression == 'name'){
          if(sortName == 'DESC'){
              sortDirection = 'ASC';
              sortName = 'ASC';
              }
          else{
              sortName = 'DESC';
              sortDirection = 'DESC';    
              }
      }
      if(sortExpression == 'ocv__c'){
          if(sortOCV == 'DESC'){
              sortDirection = 'ASC';
              sortOCV= 'ASC';
              }
          else{
              sortOCV = 'DESC';
              sortDirection = 'DESC';    
              }
      }
      if(sortExpression == 'aocv__c'){
          if(sortAOCV == 'DESC'){
              sortDirection = 'ASC';
              sortAOCV= 'ASC';
              }
          else{
              sortAOCV = 'DESC';
              sortDirection = 'DESC';    
              }
      }
        System.debug('changed sortName## '+sortName);
        if(sortExpression != '' && sortExpression!=null && sortDirection != '' && sortDirection!= null)
        {
        sortExp = ' ORDER BY ' + sortExpression  + ' ' + sortDirection;
        }
        else{
        sortExp = ' ORDER BY Name DESC';
        }
        
      /*System.debug('sortExpression##'+sortExpression);
       System.debug('sortDirection ##'+sortDirection );
       System.debug('AOCV_Greater_than@@'+AOCV_Greater_than);*/
       
    String queryProd = 'SELECT Name,Valuation_tier__c,OCV__c,AOCV__c,GEO__c,Sales_Area__c,Sales_Region__c,Finance_Owner__c FROM Account where OCV__c!= null and AOCV__c!= null';
    String searchParam = ''; 
    
    //Check if the search parameters have value and append it to the query
     //Check if the search parameters have value and append it to the query
     if (accountName  != '' && accountName != NULL)
     {
        searchParam += ' AND Name like \'%' + accountName + '%\'' ;
     } 
     if (region != '' && region != NULL)
     {
        searchParam += ' AND GEO__c like \'%' + region + '%\'' ;
     }
     if (area != '' && area != NULL)
     {
        searchParam += ' AND Sales_Area__c like \'%' + area + '%\'' ;
     }
     if (territory != '' && territory != NULL)
     {
        searchParam += ' AND Sales_Region__c like \'%' + territory + '%\'' ;
     }
     if (OCV_Greater_than != NULL && OCV_Greater_than > 0){
   
          searchParam += ' AND OCV__c > ' + OCV_Greater_than + '' ;
     }
     if (AOCV_Greater_than != NULL && AOCV_Greater_than > 0){
   
          searchParam += ' AND AOCV__c > ' + AOCV_Greater_than + '' ;
     }
     if(searchParam != null)
         queryProd += searchParam;
     if(sortExp!= '' && sortExp!= null)
     {
       queryProd += sortExp;
     }
      queryProd += ' LIMIT 9999'; // The standardsetcontroller cannot hold more than 10000 records, It will hit the governor limits
      sDataLst= new List <SearchData>();
      System.debug('queryProd '+queryProd);
      sProducts = new ApexPages.StandardSetController(Database.getQueryLocator(queryProd));
      //Pagination code
      if(this.sProducts.getResultSize() > 0){
      sProducts.setPageSize(10); // Number of records to be displayed per page.
      currentPage = 1;
      }
      else {
      currentPage = 0;
      totalPageNumber = 0;
      }
      for (Account ps: (List<Account>)sProducts.getRecords())
      {
        sDataLst.add(new SearchData(ps));
      }
      //System.debug('sDataLs##t '+sDataLst);
      reqListSize = sProducts.getResultSize();
      if(reqListSize >displayNum ){
         ifNext = true; 
      }
      else{
      ifNext = false;            
      firstValue = 0;
      ifPrevious = false; 
      }    
    }
    
     /* Next Button method for Pagination */
    public void OnClickNext()
    {
        currentPage++;
        sProducts.next();
        sDataLst= new List <SearchData>(); 
        for (Account ps: (List<Account>)sProducts.getRecords())
        {
          sDataLst.add(new SearchData(ps));
        } 
        firstValue = firstValue + displayNum ;
        if(firstValue + displayNum > reqListSize )
           ifNext = false; 
        if(firstValue>= displayNum )           
            ifPrevious= true;
    }   
    
    /* Previous Button method for Pagination */
    public void OnClickPrevious(){
        currentPage--; 
        sProducts.previous();
        sDataLst= new List <SearchData>();
        for (Account ps: (List<Account>)sProducts.getRecords())
        {
          sDataLst.add(new SearchData(ps));
        } 
        firstValue = firstValue- displayNum ;
        if(firstValue + displayNum  < reqListSize)
           ifNext = true;            
        if(firstValue >= displayNum)           
            ifPrevious = true;
        else   
            ifPrevious = false;          
    }     
    
    public List<SearchData> getdisplaySearchResult()
    {
      return sDataLst;
    }
    public pagereference changeFinanceOwner(){
        String records='';
        for(SearchData s:sDataLst)
        {
            if(s.isActive){
                records += s.pd.Id +',';
            }
        }
        if(records == ''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please select account to change Finance Owner');
            ApexPages.addMessage(msg); 
            return null;
        }else{    
        return (new PageReference('/apex/Renewals_ActiveCon_ChangeFinanceOwner?records=' + records));
        }
        //return null;
    }

    public Integer getCurrentPage(){
         return currentPage;
    }
    
    public void setfirstValue(integer firstValue){
        this.firstValue = firstValue;
    }
    
    public integer getfirstValue(){
        return firstValue;
    }
    
    public boolean getifNext(){
        return ifNext;
    }
    
    public boolean getifPrevious(){
        return ifPrevious;
    }    
    
    public integer getdisplayNum(){
        return displayNum;
    }
    
    public Integer getTotalPageNumber()    
    {    
      if (totalPageNumber == 0 && reqListSize > 0)
        {
            totalPageNumber = reqListSize / displayNum ;
            Integer mod = reqListSize  - (totalPageNumber * displayNum );
            if (mod > 0)
            {
              totalPageNumber = totalPageNumber + 1;
            }
        }
        return totalPageNumber ;
    }
    public class SearchData{
        public Account pd {get; set;}
        public Boolean isActive {get; set;}
        
        public SearchData(Account pProd)
        {
            pd = pProd;
            isActive = false;
        }        
    }

    


}