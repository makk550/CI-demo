/*
* This class has been created as part of RevRec requirements for 
* FY18 by SAMAP01 for US370554/US370595,US370554 . It is used to mass update the line items
* with the values input at the page for opp start and end date.
* It then updates the opportunity product and active contract line items , with the license type* 
* Test Class = TBD
* Coverage = 78%
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       28/9/2017       US370595        RevRec: SFDC Opportunity License Classification for renewal products
* ********************************************************************************************/

public class Renewal_LicenseMassEdit {
    
    public Set<String> Businesstype = new Set<String>{'Renewal'};
        //private List<OpportunityLineItem> renewalmainframelineitems = new List<OpportunityLineItem>();	
        private String returnurl;
    public Opportunity opp{set;get;}
    public Id oppId;
    public boolean allchecked{get;set;}
    public boolean renderdetails{get;set;}		//renderdetails is used to render the page form. It's only rendered when the opp has 1 or more products.
    public List<OpportunityLineItem> opplineItem{set;get;}
    //public List<opplintemWrapper> listWrapp{set;get;}
    public boolean renderRenewalDetails{get;set;}
    
    public String selectedLicense {get;set;} 
    
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    
    public String SortFieldSave;
    public string MainQuery;
    public Map <String,OpportunityLineItem> olimap =   new Map<String,OpportunityLineItem>();
    public List<opplintemWrapper> OpplineitemList = new List<opplintemWrapper>();
    public list<SelectOption> LicenseType {
        get{
            list<SelectOption> st= new list<SelectOption>();         
            
            Schema.DescribeFieldResult lctypevalues = OpportunityLineItem.License__c.getDescribe();
            Schema.PicklistEntry[] entries_temp = lctypevalues.getPicklistValues();
            st.add(new SelectOption('--Select--','--Select--'));
            st.add(new SelectOption('Perpetual','Perpetual'));
            st.add(new SelectOption('UMF','UMF'));
            st.add(new SelectOption('Subscription','Subscription'));
            
            return st;
        }
        set; }
    
    
    //samap01 -- pagination
    public integer npages{get;set;}
    private integer reminder;
    private integer remainder;
    public integer acpage{get;set;}  
    public boolean hasPrevious {get;set;}
    public boolean hasNext {get;set;}
    public Integer pages ;
    public  Integer respg;
    private String sortDirection = 'ASC'; 
    private String sortExp = 'name';    
    public Integer getPages() {
        return pages;    
    }
    
    public void setPages(Integer pages) {
        this.pages = pages;            
    } 
    
    public Integer pageSize = pages; 
    //samap01
    public Renewal_LicenseMassEdit(){
        //samap01
        
        pages = 5;
        acpage=1;
        npages =1;
        //samap01
        
        allchecked = false;
        // listWrapp=new List<opplintemWrapper>();
        
        if(ApexPages.currentPage().getParameters().get('id')!=null)
            oppId=ApexPages.currentPage().getParameters().get('id');
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.'));
        if(ApexPages.currentPage().getParameters().get('retURL')!=null)
            returnurl = ApexPages.currentPage().getParameters().get('retURL');
        
        //queries for line items belonging to the business type - 'Capacity','Renewal','Upgrade','New','MF Capacity'
        if(oppId!=null){
            /*opp=[select id,name,closeDate,Start_Date__c,Status_at_end_of_term__c,New_Deal_Term_Months__c,
Reason_duration_is_1_year__c,End_Date__c,Renewal_BatchId__c from Opportunity where id=:oppId ];*/
            opp = Renewal_OpportunityUtilityClass.getOpportunitydetails(oppId);
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.')); 
        
        
        //renderRenewalDetails is used to render the renewals reason section when term is less than 12 months.
        renderRenewalDetails = false;
        
        
        if(opp!=null){
            opplineItem= [select id,name,Start_Date__c,End_Date__c,unitprice,PriceBookEntry.Product2.Name,
                          Corporate_ARR__c,term_month__c,Business_Type__c,New_Deal_Term_Months__c,Stretch_Corporate_ARR__c,
                          License__c ,Material_Text__c,License_Classification__c,Platform_Category__c ,
                          Commissionable_BU__c from OpportunityLineItem
                          where Business_Type__c in:Businesstype and opportunityId=:oppId ] ;
            
        }
        
        //if there are line items, it creates a wrapper, where it adds a boolean checkbox next to the line item, helping
        //to know which lineitem(s) was(were) selected.
        if(opplineItem!=null && opplineItem.size()>0){
            renderdetails = true;           
            // listWrapp = getOpplineitemList();
            for(OpportunityLineItem oppli:opplineItem){
                // listWrapp.add(new opplintemWrapper(oppli,false));
                OpplineitemList.add(new opplintemWrapper(oppli,false));   
            } 
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.')); 
            renderdetails = false;
        } 
        
        hasNext = getHasNext();
        hasPrevious = getHasPrevious();  
    }
    
    
    //saves the line items and then the opp, provided the start or end date at opp header level were changed.
    //if no change was made, then DML is not performed at the opportunity level. Makes use of oppstartdate and oppenddate for this purpose.
    public pageReference Save(){
        List<OpportunityLineItem> updateLintem=new List<OpportunityLineItem>();
        
        if(selectedLicense =='--Select--')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select the License type you wish to mass update.'));
            return null;
        }
        else                       
            
        {
            for(opplintemWrapper valuewrap:OpplineitemList){
                if(valuewrap.selectedItem ==true)
                {
                    valuewrap.opplin.License__c = selectedLicense ;
                    updateLintem.add(valuewrap.opplin);
                }
                
                
            }
            if(updateLintem.size()>0){
                
                try{
                    if(updateLintem.size()  > Integer.Valueof(System.Label.Opportunity_BatchSize))
                    {
                        if( opp.Renewal_BatchId__c ==null ||  opp.Renewal_BatchId__c  =='') 
                        {
                            returnurl = '/apex/showACLIbatchProgress?rtype=licensetype&id='+opp.Id;
                            Id jobId = Database.executeBatch(new Batch_GenericIterable(null,updateLintem,null,opp.Id), 200);
                            system.debug('samap01 batch job called for inserts jobId'+ jobId );  
                            OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
                            opp.Renewal_BatchId__c = jobId;                        
                            update opp;
                        }
                        else
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A batch job is in progress please try after some time'));
                            return null;
                        }
                        
                    }
                    else
                    {
                        update updateLintem; //samap01 25/10
                    }
                    
                    //update opp;
                }
                catch(exception e){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,e.getmessage());
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a line item to update.'));
                return null;
            }
            
            PageReference pg;
            if(String.isBlank(returnurl))
                pg = new PageReference('/'+opp.Id);
            else
                pg = new PageReference('/'+returnurl);
            pg.setRedirect(true);
            Return pg;
        }
        
    }
    
    //wrapper class to append boolean next to the line item.
    public class opplintemWrapper{
        public boolean selectedItem{set;get;}
        public OpportunityLineItem opplin{set;get;}
        
        public opplintemWrapper(OpportunityLineItem opplin,boolean boolVal){
            
            this.opplin=opplin;
            this.selectedItem =boolVal;
        }  
    }
    
    //this method checks all the line items.
    public void checkalllineitems(){
        if(allchecked==true){
            for(opplintemWrapper oliwrap:OpplineitemList){
                oliwrap.selectedItem = true;
                system.debug('samap01'+ allchecked);
            }
        }
        else
        {
            for(opplintemWrapper oliwrap:OpplineitemList){
                oliwrap.selectedItem = false;
            }  
        }
    }
    
    public pagereference cancel(){
        pagereference pg;
        if(String.isBlank(returnurl))
            pg = new PageReference('/'+opp.Id);
        else
            pg = new PageReference('/'+returnurl);
        pg.setRedirect(true);
        return pg;
    }
    
    
    //samap01 -- pagination
    public String sortExpression  
    {     get 
    { 
        return sortExp;    
    }  
     set   
     {
         if (value == sortExp)   
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
         else         sortDirection = 'ASC';       sortExp = value;     
     }
    }
    
    public String getSortDirection() 
    {  
        if (sortExpression == null || sortExpression == '')      
            return 'ASC';  
        else   
            return sortDirection; 
    } 
    
    public void setSortDirection(String value) 
    {  
        sortDirection = value;
    }
    public List<SelectOption> getPageno() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        options.add(new SelectOption('200','200'));
        
        return options;
    }
    public PageReference check(){
        pageSize = pages;
        if((acpage > npages) || (acpage <=0))
        {
            acpage = 1;
        }
        hasNext = getHasNext();
        hasPrevious = getHasPrevious(); 
        return null;
    }
    public boolean getHasNext() {
        pageSize = pages;
        if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize())
            return false;
        else    
            return true;
    }
    
    public Boolean getHasPrevious() {
        pageSize = pages;
        if( getResultSize() == 0 || acpage == 1 )
            return false;
        else
            return true;    
    }
    
    public Integer getPageSize() {  
        return pageSize;   
    }  
    
    public void setPageSize(Integer pages) {
        if(pages != pageSize)
        {       
            acpage =1;
            pageSize = pages;
        }
    }
    public void next() {           
        acpage +=1;        
        hasNext=getHasNext();
        hasPrevious = getHasPrevious();
        
    }
    
    public void previous() {
        acpage-=1;        
        hasNext=getHasNext();
        hasPrevious = getHasPrevious();
    }
    
    public Integer getResultSize() {
        if(OpplineitemList== null)
            return 0;
        else
            return OpplineitemList.size();
    }
    
    
    public List<opplintemWrapper> getOpplineitemList(){
        pageSize = pages;
        
        if(getResultSize() > pageSize)
        {
            System.debug('samap01 getOpplineitemList called');
            List<opplintemWrapper> my_plist = new List<opplintemWrapper>();
            respg = (getResultsize()/pagesize);          
            reminder = math.mod(getResultsize(),pagesize);         
            
            if(reminder != 0)
            {
                npages = respg + 1;
            }
            else
            {
                npages = respg;
            }
            
            remainder = getResultsize() - (pageSize*npages);   
            
            for (integer i=0; i<pagesize; i++)
            {
                if(((acpage-1)*pagesize +i) < getResultsize())
                    my_plist.add(OpplineitemList[(acpage-1)* pageSize + i]); 
            }
            return my_plist;
        }else{
            acpage = 1;
            npages = 1; 
        }
        
        if(npages == 1)
        {
            hasNext = false;
            hasPrevious = false;
            
        }
        else
        {
            hasNext = getHasNext();
            hasPrevious = getHasPrevious();   
        }
        
        return OpplineitemList;
        
    }  
    //samap01 --end pagination
    
    
}