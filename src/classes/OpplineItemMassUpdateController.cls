/*
* This class has been created as part of ARR requirements for 
* FY18 by BAJPI01 for US311600. It is used to mass update the line items
* with the values input at the page for opp start and end date.
* It then updates the opportunity header start and end date, with the minimum
* start date, and maximum end date of the line items.
* This class is used at two places, from the related list at the OppLineItem level of
* Opportunity, and from the Edit Renewals Page on Opportunity.
* 
* Test Class = oppLineItemMassUpdateControllerTest
* Coverage = 87%
***********************************************************************************************
* Modified By 		Modified Date		User Story				Description
* SAMAP01			12/20/2017			US423678				xxxl Renewals- Apex cpu limit error and pagination 
************************************************************************************************/

public class OpplineItemMassUpdateController {
    
    //US326192 - BAJPI01 - for uniform update of start/end date on opp header
    @TestVisible
    private Set<String> Businesstype = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'};
        @TestVisible
        private List<OpportunityLineItem> renewalmainframelineitems = new List<OpportunityLineItem>();  
    
    @TestVisible
    private boolean renewalexists;  //to check if renewal line item exists or not.
    
    @TestVisible
    private String returnurl;		//the return url- will go to opp page if triggered from opp, otherwise to renewal edit page.
    
 
    public Opportunity opp{set;get;}
    public Id oppId;
    public boolean allchecked{get;set;}
    public boolean renderdetails{get;set;}    //renderdetails is used to render the page form. It's only rendered when the opp has 1 or more products.
    public List<OpportunityLineItem> opplineItem{set;get;}
    
    public boolean renderRenewalDetails{get;set;}
    
    //samap01 -- pagination
    public boolean hasprimarycontact =true;
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
    public List<opplintemWrapper> OpplineitemList =new List<opplintemWrapper>();
    public OpplineItemMassUpdateController(){
        
        //samap01
        
        pages = 5;
        acpage=1;
        npages =1;
        //samap01
        allchecked = false;
        renewalexists = false;
        
        
        //if there is no product, there will be no opp id, and user will be asked to enter a product first to use the 
        //mass update feature.
        if(ApexPages.currentPage().getParameters().get('id')!=null)
            oppId=ApexPages.currentPage().getParameters().get('id');
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.'));
        
        // retURL is used to redirect to the EditRenewals Page, when user saves or cancels on the mass update page.
        // if retURL is null, it means the page is called from the mass update button on the opplineitem related list.
        // if retURL is not null, it means its called from the mass update button on the editrenewals page.
        if(ApexPages.currentPage().getParameters().get('retURL')!=null)
            returnurl = ApexPages.currentPage().getParameters().get('retURL');
        
        
        //queries for line items belonging to the business type - 'Capacity','Renewal','Upgrade','New','MF Capacity'
        if(oppId!=null){
           /* opp=[select id,name,closeDate,Start_Date__c,Status_at_end_of_term__c,New_Deal_Term_Months__c,
                 Reason_duration_is_1_year__c,End_Date__c,Renewal_BatchId__c,Probability from Opportunity where id=:oppId];*/
              opp = Renewal_OpportunityUtilityClass.getOpportunitydetails(oppId);
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.')); 
        
        if(opp!=null){
            opplineItem= [select id,name,Start_Date__c,End_Date__c,unitprice,PriceBookEntry.Product2.Name,
                          Corporate_ARR__c,term_month__c,Business_Type__c,New_Deal_Term_Months__c,Stretch_Corporate_ARR__c,
                          License__c ,Material_Text__c,License_Classification__c,
                          Commissionable_BU__c from OpportunityLineItem
                          where Business_Type__c in:Businesstype and opportunityId=:oppId ] ;
            
        }
        
        //renderRenewalDetails is used to render the renewals reason section when term is less than 12 months.
        renderRenewalDetails = false;
        
        
        //if there are line items, it creates a wrapper, where it adds a boolean checkbox next to the line item, helping
        //to know which lineitem(s) was(were) selected.
        if(opplineItem!=null && opplineItem.size()>0){
            renderdetails = true;
            for(OpportunityLineItem oppli:opplineItem){                                
                if(oppli.Business_Type__c=='Renewal'){
                    renewalexists = true;
                }
                OpplineitemList.add(new opplintemWrapper(oppli));                
                
                
                if((oppli.Business_Type__c=='Renewal'||oppli.Business_Type__c=='MF Capacity') && ((opp.New_Deal_Term_Months__c!=null && opp.New_Deal_Term_Months__c<12))){
                    renderRenewalDetails = true;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
                    ApexPages.addMessage(msg);
                } 
            } 
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please add a product first to the opportunity.')); 
            renderdetails = false;
        }  
         hasprimarycontact = Renewal_OpportunityUtilityClass.Primarycontactexists(opp);
        if( !hasprimarycontact)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
                    ApexPages.addMessage(msg);   
                    System.debug('samap01 msg'+msg);
           
        }
        
        hasNext = getHasNext();
        hasPrevious = getHasPrevious();  
    }
    
    //this returns a custom created picklist to make the user select the type of date they want to update - start or end date.
    //calls getDates method.
    public List < SelectOption > listop {
        get {
            listop = getDates();
            return listop;
        }
        set; 
    }
    
    public string selectedDate{set;get;}
    
    public List < SelectOption > getDates() {
        List < SelectOption > selectval = new List < SelectOption > ();
        selectval.add(new SelectOption('-None-', '-None-'));
        selectval.add(new SelectOption('start Date', 'Start Date'));
        selectval.add(new SelectOption('End date', 'End Date'));    
        return selectval;
    }
    
    //saves the line items and then the opp, provided the start or end date at opp header level were changed.
    //if no change was made, then DML is not performed at the opportunity level. Makes use of oppstartdate and oppenddate for this purpose.
    public pageReference Save(){
        List<OpportunityLineItem> updateLintem=new List<OpportunityLineItem>();
        List<OpportunityLineItem> alllineitems = new List<OpportunityLineItem>();
        Date minstartdate;
        Date maxenddate;
        //samap01 -- added primary check
        if( !hasprimarycontact)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
                    ApexPages.addMessage(msg);   
                    System.debug('samap01 msg'+msg);
           return null;
        }
        //samap01 -- added primary check
        if(selectedDate=='-None-'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select the date type you wish to mass update.'));
            return null;
        }
        else if(opp.Start_Date__c==null||opp.End_Date__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start and End Date cannot be null.'));
            return null;
        }
        else if(opp.Start_Date__c!=null&&opp.End_Date__c!=null&&opp.Start_Date__c>=opp.End_Date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start Date cannot be greater than or equal to End Date.'));
            return null;
        }
        else if(renderRenewalDetails==true && (opp.Reason_duration_is_1_year__c==null||opp.Status_at_end_of_term__c==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
            return null;
        }
        else{
            for(opplintemWrapper valuewrap:OpplineitemList){
                if(selectedDate=='Start Date' && valuewrap.selectedItem==true && opp.Start_Date__c!=null){
                    valuewrap.opplin.Start_Date__c=opp.Start_Date__c;
                    updateLintem.add(valuewrap.opplin);
                }else if(selectedDate=='End Date'&&valuewrap.selectedItem==true && opp.End_Date__c!=null){
                    valuewrap.opplin.End_Date__c=opp.End_Date__c;
                    updateLintem.add(valuewrap.opplin);
                    
                }
                if(valuewrap.selectedItem==false){
                    alllineitems.add(valuewrap.opplin);
                }
            }
            if(updateLintem.size()>0){
                for(OpportunityLineItem oli:updateLintem){
                    
                    oli.term_month__c = ARRandDurationCalculation.monthsbetweendates(oli.Start_Date__c,oli.End_Date__c);
                    //for Renewal and MF Capacity business type, new deal term months is also populated.
                    if(oli.Business_Type__c=='Renewal' || oli.Business_Type__c=='MF Capacity')
                        oli.New_Deal_Term_Months__c = oli.term_month__c;
                    if(oli.Start_Date__c!=null && oli.End_Date__c!=null)
                        oli.duration_days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c) + 1;
                    
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a line item to update.'));
                return null;
            }
            alllineitems.addAll(updateLintem);          
            
            
            //the following part updates opp with min start date and max end date of line items.
            //if(opp.Start_Date__c!=oppstartdate||opp.End_Date__c!=oppenddate){
            if(alllineitems.size()>0){
                minstartdate = alllineitems[0].Start_Date__c;
                maxenddate =  alllineitems[0].End_Date__c;
                for(OpportunityLineItem oli:alllineitems){
                    if(oli.Start_Date__c!=null){
                        if(minStartDate!=null){
                            if(oli.Start_Date__c<minStartDate)
                                minStartDate = oli.Start_Date__c;
                        }
                        else{
                            minStartDate = oli.Start_Date__c;
                        }
                    }
                    if(oli.End_Date__c!=null){
                        if(maxEndDate!=null){
                            if(oli.End_Date__c>maxEndDate)
                                maxEndDate = oli.End_Date__c;
                        }
                        else{
                            maxEndDate = oli.End_Date__c;
                        }
                    }
                    
                    if(renewalexists==true){
                        if(oli.Business_Type__c=='Renewal'){
                            renewalmainframelineitems.add(oli);
                        }
                    }
                    else{
                        if(oli.Business_Type__c=='MF Capacity'){
                            renewalmainframelineitems.add(oli);
                        }
                    }  
                }
                opp.Start_Date__c = minstartdate;
                opp.End_Date__c = maxenddate;
                if(renewalmainframelineitems.size()>0){
                    minstartdate = renewalmainframelineitems[0].Start_Date__c;
                    maxenddate =  renewalmainframelineitems[0].End_Date__c;
                    for(OpportunityLineItem oli:renewalmainframelineitems){
                        if(oli.Start_Date__c!=null){
                            if(minStartDate!=null){
                                if(oli.Start_Date__c<minStartDate)
                                    minStartDate = oli.Start_Date__c;
                            }
                            else{
                                minStartDate = oli.Start_Date__c;
                            }
                        }
                        if(oli.End_Date__c!=null){
                            if(maxEndDate!=null){
                                if(oli.End_Date__c>maxEndDate)
                                    maxEndDate = oli.End_Date__c;
                            }
                            else{
                                maxEndDate = oli.End_Date__c;
                            }
                        }
                    }
                    opp.New_Deal_Term_Months__c = ARRandDurationCalculation.monthsbetweendates(minstartdate, maxenddate);
                }
                
                if(renderRenewalDetails == false && opp.New_Deal_Term_Months__c!=null && opp.New_Deal_Term_Months__c<12){
                    renderRenewalDetails = true;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else{
                    renderRenewalDetails = false;
                    try{
                        OpportunityHandler.RenewalsMassConversion =true; //samap01 -avoid apex cpu limit
                        //modified to handle the bulk data from opp line item - samap01 US423678 XXXL
                        // Process the String's one by one each with its own governor context
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
                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A batch job is in progress please try after some time'));
           						 return null;
                             }
                         }
							
                        	else
                       		 upsert updateLintem; 
                         	 system.debug('samap01 opp line items inserted' );
                       
                        update opp;
                    }
                    catch(exception e){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,e.getmessage());
                        ApexPages.addMessage(msg);
                        return null;
                    }
                }
                
            }
            //}
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
        
        public opplintemWrapper(OpportunityLineItem opplin){
            
            this.opplin=opplin;
            
        }  
    }
    
    //this method checks all the line items.
    public void checkalllineitems(){
        if(allchecked==true){
            for(opplintemWrapper oliwrap:OpplineitemList){
                oliwrap.selectedItem = true;
            }
        }
        else if(allchecked==false){
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