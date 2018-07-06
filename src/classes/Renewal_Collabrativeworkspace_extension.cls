public with sharing class Renewal_Collabrativeworkspace_extension 
{
    private Account account;
    public List<Opportunity> opp {get;set;} 
    private List<Active_Contract__c> contracts;
    private List<Renewal__c> renewals;
    
    public integer npages;    
    public integer remainder;
    public integer acpage = 1;
    public Integer PageSize = 10;
    String strrlatedlist='';
    private String sortDirection = 'ASC';
    private String sortExp = 'name';    

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

     public String getSortDirection()
     {
        //if no column is selected return Ascending order
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
        
    public Renewal_Collabrativeworkspace_extension(ApexPages.StandardController controller) {
        this.account =(Account)controller.getRecord();
        if(opp == null)
            setoppValues();
          
    }
    
    //get the list of opportunities for the Specified Account.
    public list<Opportunity> getOpplist()
    {
        if(opp.size()> pageSize)
        {
             List<Opportunity> my_opplist = new List<Opportunity>();
             //total number of pages
             npages = getoppResultSize()/pagesize;
             remainder = getoppResultSize()- (pageSize*npages);   
             for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getoppResultSize())
                 my_opplist.add(opp[(acpage-1)* pageSize + i]); 
               }
               System.Debug('my_opplist'+my_opplist.size());
            return my_opplist;
         }   
        return opp;
    }
    
    public list<Opportunity> setoppValues()
    {
        
        opp =[Select id,Name,StageName,RPD_Status_Formula__c
        ,amount,CloseDate,OwnerId,RecordTypeId,Type,
                ExpectedRevenue,AccountId from Opportunity where AccountId =:account.Id AND RecordType.Name ='New Opportunity'];
        //set the paging if the record count is greater than 10
        if(getoppResultSize() > pageSize)
        {
             List<Opportunity> my_opplist = new List<Opportunity>();
             //total number of pages
             npages = getoppResultSize()/pagesize;
             remainder = getoppResultSize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getoppResultSize())
                 my_opplist.add(opp[(acpage-1)* pageSize + i]); 
               }
            return my_opplist;
        }   
        return opp;
    }
    
    //Sorting the Oppotunities
    public PageReference sort()
    {
        PageReference pageRef = ApexPages.currentPage();
        string sortFullExp = sortExpression  + ' ' + sortDirection;     
        String Soql='Select id,RPD_Status_Formula__c,Name,StageName,CloseDate,OwnerId,RecordTypeId,Type,ExpectedRevenue,AccountId from Opportunity where AccountId =' + '\'' + account.Id + '\'';
        soql += ' AND RecordType.Name =\'New Opportunity\' ';
       //       system.Debug(Soql+' order by '+ sortFullExp);       
        opp =Database.Query(Soql+' order by '+ sortFullExp);
        system.Debug(opp); 
        
        return null;
        
    }
    
    //List of all Active Contacts related to the specified account
    Public list<Active_Contract__c> getcontracts()
    {
        
        contracts =[Select Id,Name,Contract_End_Date__c,Contract_Start_Date__c,Raw_Maint_Calc_LC__c,
                    Status_Formula__c, ATTRF_CRV__c,AOCV__c,OCV__c,Area__c,Region__c,Territory_Country__c   
                    from Active_Contract__c where Account__c =:account.Id OR Sold_to_party__c=:account.Id];
         //set paging if the record count greater than 10
        if(getcontractResultSize() > pageSize)
        {
             List<Active_Contract__c> my_contractlist = new List<Active_Contract__c>();
             npages = getcontractResultSize()/pagesize;
             remainder = getcontractResultSize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getcontractResultSize())
                 my_contractlist.add(contracts[(acpage-1)* pageSize + i]); 
               }
            return my_contractlist;
        }       
        return contracts;
    }
    
    //get list of all active contracts based on the Sold to party account id.
    Public list<Active_Contract__c> getcontractsbysoldoparty()
    {
        contracts  =[Select Id,Name,Contract_End_Date__c,Contract_Start_Date__c,Raw_Maint_Calc_LC__c,Valuation_Tier__c,
                    Status_Formula__c, ATTRF_CRV__c,AOCV__c,OCV__c,Area__c,Region__c,Territory_Country__c, Territory__c   
                    from Active_Contract__c where Sold_To_Party__c =:account.Id];

        //set paging if the record count greater than 10
        if(getcontractResultSize() > pageSize)
        {
             List<Active_Contract__c> my_contractlist = new List<Active_Contract__c>();
             npages = getcontractResultSize()/pagesize;
             remainder = getcontractResultSize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getcontractResultSize())
                 my_contractlist.add(contracts[(acpage-1)* pageSize + i]); 
               }
            return my_contractlist;
        }       
        return contracts;
    }
    
    //get list of all renewals
    Public list<Renewal__c> getrenewals()
    {
        
        renewals=[Select Id,Name,Account__c,Segmentation__c,Local_Currency__c,OCV__c,Projected_Renewal__c,Expected_Close_Date__c,
                    Territory_Country__c,Area__c,Region__c from Renewal__c where Account__c =:account.Id];
        //set paging if the record count greater than 10
        if(getResultSize() > pageSize)
        {
             List<Renewal__c> my_renewallist = new List<Renewal__c>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getResultsize())
                 my_renewallist.add(renewals[(acpage-1)* pageSize + i]); 
               }
            return my_renewallist;
        }       
        return renewals;
    }   
        
    
    public boolean getHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize())
            return false;
        else    
            return true;
    }
    public boolean getoppHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getoppResultSize() == 0 || getoppResultSize() < pageSize || (acpage*pageSize) >=getoppResultSize())
            return false;
        else    
            return true;
    }
    public boolean getcontractHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getcontractResultSize() == 0 || getcontractResultSize() < pageSize || (acpage*pageSize) >=getcontractResultSize())
            return false;
        else    
            return true;
    }

    public Boolean getHasPrevious() {
        if(getResultSize() == 0 || acpage == 1 ){
                return false;
        }else
            return true;
    }
    public boolean getoppHasPrevious()
    {
         if(getoppResultSize() == 0 || acpage == 1 )
                return false;
           else
              return true;
    }
    public boolean getcontractHasPrevious()
    {
        if(getcontractResultSize() == 0 || acpage == 1 )
            return false;
        else
            return true;
    }
    
    public Integer getPageSize() {  
           return pageSize;   
    }  

    public void setPageSize(Integer ps) {
           if(ps != pageSize)
            {       
                acpage =1;
                pageSize = ps;
            }
   }
    public void next() {
           acpage +=1;
    }
  
    public void previous() {
           acpage-=1;
    }
    
    public Integer getResultSize() {
        if(renewals== null)
            return 0;
        else
            return renewals.size();
   }
   public Integer getoppResultSize() {
        if(opp== null)
            return 0;
        else
            return opp.size();
   }   
   public Integer getcontractResultSize() {
        if(contracts== null)
            return 0;
        else
            return contracts.size();
   }      
       

}