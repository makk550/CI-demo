public with sharing class CSP_AddOpportunities{

    private Account account;
    public string AccountId {set; get;}
    public string msg {set; get;}
    
    public List<Opportunity> opps {set; get;}
    Public List<WrapOpps> lstOpps {get;set;}
    Public Map<id,WrapOpps> lstOppselected {get;set;}
    public Customer_Success_Program__c  csp{get;set;}
    public Map<Id,Id> MapOldOppIds = new Map<id,id>();
    public string newurl{get; set;}
    public Integer CountTotalRecords{get;set;}
    
    public Integer OffsetSize = 0;
    private Integer QueryLimit = 500;
    
    public class WrapOpps
    {
        public Opportunity opp{get;set;}
        public Boolean isSelected{get;set;} 
        public WrapOpps(Opportunity o, boolean sel)
        {
            opp= o;
            isSelected = sel;
        }
        
    }   
    
    public pagereference ApplySelection()
    {
        storeSelection();
        string ids ='';
        for(WrapOpps wo: lstOppselected.values())
                    {    
                            if(wo.isSelected)
                                {  
                                   ids += ( ids == ''?'': ';' )  + wo.opp.id;
                                }
                             
                    } 
       if(ids == '')
           {msg = 'Please select at least one Opportunity to Apply Selection, else use Skip Selection, to proceed with no Opportunities slected';
           return null;
           }             
        //SAMAP01 -US345989 - Allow Recordtype selection for CSP
       // return new Pagereference('/' + System.Label.CSP_prefix + '/e?' + System.Label.CSP_CSP_Account + '=' + ApexPages.currentPage().getParameters().get('accname') + '&' + System.Label.CSP_CSP_Account + '_lkid=' + account.id + '&' + System.Label.CSP_Opp_Ids + '=' + ids +  '&retURL='  + '/apex/services?accid='+ ApexPages.currentPage().getParameters().get('id'));
         return new Pagereference('/' + System.Label.CSP_UrlPrefixRecordtype + '&' + System.Label.CSP_CSP_Account + '=' + ApexPages.currentPage().getParameters().get('accname') + '&' + System.Label.CSP_CSP_Account + '_lkid=' + account.id + '&' + System.Label.CSP_Opp_Ids + '=' + ids +  '&retURL='  + '/apex/services?accid='+ ApexPages.currentPage().getParameters().get('id'));

    }
    
    
    public pagereference SkipSelection()
    {
          //SAMAP01 -US345989 - Allow Recordtype selection for CSP
        //return new Pagereference('/' + System.Label.CSP_prefix + '/e?' + System.Label.CSP_CSP_Account + '=' + ApexPages.currentPage().getParameters().get('accname') + '&' + System.Label.CSP_CSP_Account + '_lkid=' + account.id + '&retURL='  + '/apex/services?accid='+ ApexPages.currentPage().getParameters().get('id'));
         return new Pagereference('/' + System.Label.CSP_UrlPrefixRecordtype + '&' + System.Label.CSP_CSP_Account + '=' + ApexPages.currentPage().getParameters().get('accname') + '&' + System.Label.CSP_CSP_Account + '_lkid=' + account.id + '&retURL='  + '/apex/services?accid='+ ApexPages.currentPage().getParameters().get('id'));
    }
    
    public pagereference saveOpps()
    {
        storeSelection();
        If(ApexPages.currentPage().getParameters().get('csp')  <> null)
            {
                Set<id> delId = new Set<id>();
                List<CSP_Opportunity__c> lst_insert =  new List<CSP_Opportunity__c>();
                List<CSP_Opportunity__c> lst_delete =  new List<CSP_Opportunity__c>();
                for(WrapOpps wo: lstOppselected.values())
                    {    
                            if(wo.isSelected)
                                {  
                                    if(! MapOldOppIds.keyset().contains(wo.opp.id))  
                                        {
                                              lst_insert.add( new CSP_Opportunity__c (Customer_Success_Program__c=csp.id,Opportunity__c=wo.opp.id));
                                        }
                                }
                                else
                                {
                                    if(MapOldOppIds.keyset().contains(wo.opp.id))
                                    {
                                              lst_Delete.add( new CSP_Opportunity__c (id=MapOldOppIds.get(wo.opp.id)));
                                    }  
                                }
                    } 
              
            database.insert(lst_insert,false);
            database.delete(lst_delete,false);
            
            return new Pagereference('/' + ApexPages.currentPage().getParameters().get('csp'));
            } 
        else
            return null;        
    }
        
    public CSP_AddOpportunities(ApexPages.StandardController stdController) 
    {
       this.account= (Account)stdController.getRecord();
         if(ApexPages.currentPage().getParameters().get('csp')  <> null)
          {        csp = [Select id, CSP_Related_Opportunity_s__c from Customer_Success_Program__c where id =: ApexPages.currentPage().getParameters().get('csp')];
                     
                     for(CSP_Opportunity__c  csp_opp: [Select id, Opportunity__c from CSP_Opportunity__c where Customer_Success_Program__c = : csp.id ])
                     {
                       MapOldOppIds.put(csp_opp.Opportunity__c, csp_opp.id );  
                     } 
                      
          }
          lstOppselected=new Map<id,WrapOpps>();
      avoidQuery=new Set<Integer>();
        if(account!=null)
        {
            CountTotalRecords= [select count() from opportunity where accountid=:account.Id];
            
             PaginationQuery();       
        }
        
    }
    Map<Integer,WrapOpps> reopps=new Map<Integer,WrapOpps>();
    public void storeSelection()
    {
        for(WrapOpps wo:lstOpps)        
        lstOppselected.put(wo.opp.id,wo);
        
    }
    public void PaginationQuery()
    {
            AccountId = account.Id;
            lstOpps = new List<WrapOpps>();         
            opps = new List<Opportunity>();
            for(Opportunity opp:  [select Id, IsClosed, Opportunity_Number__c, name, StageName, closedate, amount from opportunity where 
                    accountid=:AccountId 
               
                    order by name limit :QueryLimit offset :OffsetSize
                    ])
            {
                if(lstOppselected.get(opp.id)!=null)
                lstOpps.add(lstOppselected.get(opp.id));
                else
                lstOpps.add(new WrapOpps(opp, MapOldOppIds.keyset().contains(opp.id))); 
                
                opps.add(opp);
            
            }    
        avoidQuery.add(OffsetSize);     
    }
     public Boolean getDisablePrevious()
    {
        if(OffsetSize>0){
            return false;
        }
        else return true;
    }
 
    public Boolean getDisableNext() {
        if (OffsetSize + QueryLimit < countTotalRecords){
            return false;
        }
        else return true;
    }
    set<Integer> avoidQuery=new set<Integer>();
    public PageReference Next() {
        storeSelection();   
        OffsetSize += QueryLimit;
                    
        PaginationQuery();
        
        
        return null;
    }
 
    public PageReference Previous() 
    {
        storeSelection();
        OffsetSize -= QueryLimit;                   
        PaginationQuery();
        
        return null;
    }
    public PageReference Start() {
        storeSelection();   
        OffsetSize =0;
                    
        PaginationQuery();
        
        
        return null;
    }
    
    public PageReference End() {
        storeSelection(); 
                if(math.mod(countTotalRecords, QueryLimit)<=0)
                 OffsetSize = countTotalRecords - QueryLimit;
                else
                OffsetSize = countTotalRecords - math.mod(countTotalRecords, QueryLimit); 
                system.debug('####'+OffsetSize+'   '+countTotalRecords+'   '+math.mod(countTotalRecords, QueryLimit));
        PaginationQuery();
        
        
        return null;
    }
    public Integer getTotalPages() 
    {
      if (math.mod(countTotalRecords,QueryLimit)<= 0) 
        
        
         return countTotalRecords/QueryLimit;
      else 
      
         return (countTotalRecords/QueryLimit)+1;
      
      }
    public Integer getTotal_size() {
      return countTotalRecords;
    }

    public Integer getPageNumber() {
   
      return OffsetSize/QueryLimit+1;
    
    }


}