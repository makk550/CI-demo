/*********************************************************************************************
* This class is used to mass attach active contract products to the opportunity
* It then updates the opportunity product and active contract line items , with the license type and license classification
* This class is used from the related list at the OppLineItem level of
*  Opportunity
* 
* Test Class = TBD
* Coverage = 0%
*  SAMAP01    28/9/2017    US370554/US370595,US370555       RevRec: Attach contract products
* SAMAP01 		29/10/2017	 - Avoid getting the contracts with inactive product IDS
* SAMAP01		29/11/2017	 us423678 - Batch job for xxxl records
* ********************************************************************************************/
public class Renewal_AddOppProduct {
    
    String strOppId;   
    String strAccountId;
    String WhereCond;
    String strAccName;
    boolean hasprimarycontact ; //samap01
    public integer npages{get;set;}    
    private integer remainder;
    private string strpricebookid;
    private integer reminder;
    public integer acpage{get;set;}  
    public boolean hasPrevious {get;set;}
    public boolean hasNext {get;set;}
    private boolean pricebkmsg {get;set;}
    public string Contract_No_Filter{get;set;}
    public string Contract_Name_Filter{get;set;}
    public  string  Dismantle_Date_Filter{get;set;}
    public Integer pages ;
    private String sortDirection = 'ASC'; 
    private String sortExp = 'name';  
    public Date startDate {get;set;}  //US422479 sunji03        
    public Date endDate {get;set;}    //US422479 sunji03        
    public List<OpportunityLineItem> oppProdList{get;set;} //US422479 sunji03
    Integer respg;
    
    //Add as part of US183026
    public String AttachOppvalue{set;get;}
    public string gb2Value{set;get;}
    public string productInstanceId{set;get;}
    
    //Add as part of US183026
    public List<SelectOption> getAttachOpps() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    } 
    //Add as part of US183026
    public List<SelectOption> getGBU2Values() {
        List<SelectOption> options = new List<SelectOption>();
        
        
        options.add(new SelectOption('',''));
        options.add(new SelectOption('Agile Central','Agile Central'));
        options.add(new SelectOption('Agile Operations','Agile Operations'));
        options.add(new SelectOption('Cloud','Cloud'));
        options.add(new SelectOption('Developer Products','Developer Products'));
        options.add(new SelectOption('IT Business Management','IT Business Management'));
        options.add(new SelectOption('MF Application Development','MF Application Development'));
        options.add(new SelectOption('MF Databases and Management','MF Databases and Management'));
        options.add(new SelectOption('MF IT Operations & Automation','MF IT Operations & Automation'));
        options.add(new SelectOption('MF Security and Compliance','MF Security and Compliance'));
        options.add(new SelectOption('MF Value','MF Value'));
        options.add(new SelectOption('N/A','N/A'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Payment Security','Payment Security'));
        options.add(new SelectOption('Security','Security'));
        options.add(new SelectOption('Services','Services'));
        options.add(new SelectOption('Training','Training'));
        
        
        return options;
        
    } 
    
    public Integer getPages() {
        return pages;    
    }
    
    public void setPages(Integer pages) {
        this.pages = pages;            
    } 
    
    public Integer pageSize = pages; 
    
    public List<RenewalProductDetails> RenewalProductList = new List<RenewalProductDetails>();
    public List<Active_Contract_Product__c>  ActProduct = new List<Active_Contract_Product__c>();
    public List<Active_Contract_Product__c>  ActPdtlst = new List<Active_Contract_Product__c>();
    public Map <String,Active_Contract_Product__c> ActProductMap =   new Map<String,Active_Contract_Product__c>();
    //  public List<RenewalLineItemDetails> RenewallineitemtList = new List<RenewalLineItemDetails>(); //samap01
    public Map <String,Active_Contract_Line_Item__c> ActlineMap =   new Map<String,Active_Contract_Line_Item__c>();//samap01 -revrec- changed to use ACL instead of ACP
    public List<Active_Contract_Line_Item__c>  AclProduct = new List<Active_Contract_Line_Item__c>(); //samap01 27/10
    
    Public Set<Id> ActiveContractIds = New set<id>();  //SAMAP01 -REVREC- US370595
    public boolean allchecked{get;set;} //samap01
    Opportunity opp;
    String currencyISOCode;
    public boolean runbatch =false;
    public Renewal_AddOppProduct(ApexPages.StandardSetController controller) {
        //Instance_Id__c,a.Product__r.CSU2__c,
        Pricebook2 pbe = new Pricebook2();
        pbe = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
        if(pbe!=null)
            strpricebookid = pbe.Id;
        
        pricebkmsg = false;
        pages = 5;
        acpage=1;
        npages =1;
        strOppId=System.currentPageReference().getParameters().get('Id'); 
        
       /* opp = [Select o.Name,o.Id,o.Account.Name,o.CurrencyIsoCode, o.AccountId,CloseDate,StageName,o.Start_Date__c,
               o.End_Date__c,o.Attach_Contracts_Batch_Id__c,
               			o.Probability    //samap01 -11/20 
               From Opportunity o where o.Id =: strOppId];*/
        opp = Renewal_OpportunityUtilityClass.getOpportunitydetails(strOppId);
       //US422479 sunji03 - only compare dates with renewal products?       
        oppProdList = [select id, OpportunityId, start_date__c, end_date__c from OpportunityLineItem where OpportunityId =: strOppId and Business_Type__c = 'Renewal'];

        String qry;
        strAccountId = opp.AccountId ;         
        for(Active_Contract_Product__c ac: [Select Instance_Id__c,a.Product__r.CSU2__c,Projected_Renewal_Calc__c, ATTRF_CRV__c,dismantle_date__c,Opportunity__r.Opportunity_Number__c,Opportunity__r.Name,a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name, a.Product_Baseline_ATTRF_LC__c,
                                            a.Renewal_Product__c,a.Active_Contract__r.name,a.Name,a.Product__r.Name, a.Id, a.Converted_To_Opportunity__c, a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,a.Active_Contract_Number__c,a.Sales_Price__c,a.Segmentation__c,a.Pre_Segmentation__c,
                                            a.Active_Contract__r.Account__r.name,a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,a.Renewal_Product__r.Projected_Renewal_LC__c,a.Renewal_Product__r.Projected_Time_Duration_Months__c,a.Active_Contract__r.Contract_Term_Months__c,a.Raw_Maint_Calc_LC__c,a.Product__r.Family 
                                            From Active_Contract_Product__c a where a.Active_Contract__r.Account__c =:opp.AccountId 
                                            and a.Product__c IN (Select Product2id From PricebookEntry  where IsActive =:true and Pricebook2Id=: strpricebookid and currencyIsoCode=:opp.CurrencyIsoCode ) //samap01 - 27/10 - Donot bring inactive records
                                           // not reeg 4/1/2018 and (a.Converted_To_Opportunity__c = true or a.Converted_To_Opportunity__c = false) 
                                            limit 1000]){
                                                if(opp.CurrencyIsoCode == ac.Renewal_Currency_Name__c)
                                                {
                                                    RenewalProductList.add(new RenewalProductDetails(ac)); 
                                                    ActProductMap.put(String.ValueOf(ac.id),ac);
                                                }
                                                
                                                if(ac.Name=='ControlMinder')
                                                    System.debug(ac.Name+'<----________ControlMinder------->'+ac.Opportunity__r.Name+'------------> Number '+ac.Opportunity__r.Opportunity_Number__c);
                                                
                                            }                                
        
        hasNext = getHasNext();
        hasPrevious = getHasPrevious();  
         hasprimarycontact = Renewal_OpportunityUtilityClass.Primarycontactexists(opp); //samap01
        if( !hasprimarycontact)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
                    ApexPages.addMessage(myMsg);   
                    System.debug('samap01 myMsg'+myMsg);
           
        }
                 
        
    }
    
    
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
    
    //this method checks all the line items.
    ////samap01- revrec
    public void checkalllineitems(){
        if(allchecked==true){
            for(RenewalProductDetails oliwrap:RenewalProductList){
                if(oliwrap.activeContractProd.Converted_To_Opportunity__c ==false)  //samap01 
                {
                    oliwrap.selected = true;
                }
                
            }
        }
        else
        {
            for(RenewalProductDetails oliwrap:RenewalProductList){
                oliwrap.selected = false;
            }  
        }
    }
  
    
    public pagereference clearFilter()
    {
        
        Contract_No_Filter = '';
        Contract_Name_Filter='';
        Dismantle_Date_Filter='';
        //Add as part of US183026
        AttachOppvalue='';
        gb2Value='';
        productInstanceId='';
        
        RenewalProductList.clear();
        ActProductMap.clear();
        
        
        for(Active_Contract_Product__c ac: [Select a.Instance_Id__c,a.Product__r.CSU2__c,a.Projected_Renewal_Calc__c, a.ATTRF_CRV__c,a.dismantle_date__c,a.Opportunity__r.Opportunity_Number__c,a.Opportunity__r.Name,a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name,a.Renewal_Product__c,a.Active_Contract__r.name, 
                                            a.Name,a.Product__r.Name, a.Id,a.Converted_To_Opportunity__c,a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,a.Active_Contract_Number__c,a.Sales_Price__c,a.Segmentation__c,a.Pre_Segmentation__c,a.Product_Baseline_ATTRF_LC__c,
                                            a.Active_Contract__r.Account__r.name,a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,a.Renewal_Product__r.Projected_Renewal_LC__c,a.Renewal_Product__r.Projected_Time_Duration_Months__c,a.Active_Contract__r.Contract_Term_Months__c,a.Raw_Maint_Calc_LC__c,a.Product__r.Family //,(Select PricebookEntryId From Opportunity_Product__r)
                                            From Active_Contract_Product__c a where a.Active_Contract__r.Account__c =:opp.AccountId 
                                            and a.Product__c IN (Select Product2id From PricebookEntry  where IsActive =:true and Pricebook2Id=: strpricebookid
                                                                 and currencyIsoCode=:opp.CurrencyIsoCode ) //samap01 - 27/10 - Donot bring inactive records
                                            and (a.Converted_To_Opportunity__c = true or a.Converted_To_Opportunity__c = false) limit 1000]){
                                                
                                                if(opp.CurrencyIsoCode == ac.Renewal_Currency_Name__c){
                                                    RenewalProductList.add(new RenewalProductDetails(ac)); 
                                                    ActProductMap.put(String.ValueOf(ac.id),ac);
                                                }                        
                                            }                                
        
        hasNext = getHasNext();
        hasPrevious = getHasPrevious();        
        
        return null;
    }
    public pagereference ViewData()
    {
        
        Contract_No_Filter = Contract_No_Filter.replaceAll(',','');
        Contract_Name_Filter = Contract_Name_Filter.replaceAll(',','');
        //Add as part of US183026
        
        try{
            WhereCond = '';  
            //Add as part of US183026
            if(gb2Value !=''&&gb2Value!=null){
                if(WhereCond!=''&&WhereCond!=null){
                    WhereCond =WhereCond+ ' and a.Product__r.CSU2__c = \'' + gb2Value + '\''; 
                }else{
                    WhereCond=' and a.Product__r.CSU2__c = \'' + gb2Value + '\'';  
                }
            }
            if(productInstanceId != ''&&productInstanceId!=null){
                if(WhereCond!=''&&WhereCond!=null){
                    WhereCond = WhereCond+ ' and a.Instance_Id__c = \'' + productInstanceId + '\''; 
                }else{
                    WhereCond = ' and a.Instance_Id__c = \'' + productInstanceId + '\''; 
                }
                
            }
            if(AttachOppvalue=='Yes'){
                if(WhereCond!=''){
                    WhereCond = WhereCond+ '  and a.Opportunity__r.Opportunity_Number__c != \'' + '' + '\'';
                }
                if(WhereCond==''){
                    WhereCond ='  and a.Opportunity__r.Opportunity_Number__c != \'' + '' + '\'';
                }
            }
            if(AttachOppvalue=='No'){
                if(WhereCond!=''){
                    WhereCond =WhereCond+ '  and a.Opportunity__r.Opportunity_Number__c = \'' + '' + '\'';
                }
                if(WhereCond==''){
                    WhereCond =' and a.Opportunity__r.Opportunity_Number__c = \'' + '' + '\'';
                }
            }
            // End US183026
            if(Contract_No_Filter!=''){
                if(WhereCond==''){
                    WhereCond = ' and a.Active_Contract__r.name = \'' + Contract_No_Filter  + '\''; 
                }else{
                    WhereCond = WhereCond+' and a.Active_Contract__r.name = \'' + Contract_No_Filter  + '\'';  
                }
            }
            if(Contract_Name_Filter != ''){
                if(WhereCond!=''){
                    WhereCond = WhereCond +' and a.Name = \'' + Contract_Name_Filter + '\''; 
                }else{
                    WhereCond = 'and a.Name = \'' + Contract_Name_Filter + '\'';   
                    
                }
            }
            
            
            if(Dismantle_Date_Filter != ''){
                Dismantle_Date_Filter += ' 01:00 AM';
                if(WhereCond!=''){
                    WhereCond = WhereCond + 'and dismantle_date__c = '+ dateTime.parse(Dismantle_Date_Filter).format('YYYY-MM-dd');
                }else{
                    WhereCond = ' and dismantle_date__c = ' +dateTime.parse(Dismantle_Date_Filter).format('YYYY-MM-dd');
                    
                }
                
            }
            
            // WhereCond = '\'' + strAccountId + '\'' + WhereCond ;
            whereCond='\'' + strAccountId + '\''+ WhereCond;
            Dismantle_Date_Filter=Dismantle_Date_Filter.remove(' 01:00 AM');
            
            string sortFullExp = sortExpression  + ' ' + sortDirection;        
            
            RenewalProductList.clear();
            ActProductMap.clear();
            String strcurrencycode =opp.CurrencyIsoCode ;
            String qry  = 'Select a.Instance_Id__c,a.Product__r.CSU2__c,a.ATTRF_CRV__c,a.dismantle_date__c,a.Opportunity__r.Opportunity_Number__c,a.Opportunity__r.Name,a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name,a.Renewal_Product__c,a.Active_Contract__r.name,a.Product_Baseline_ATTRF_LC__c,';
            qry  = qry + 'a.Name,a.Product__r.Name,a.Id,a.Converted_To_Opportunity__c,a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,a.Active_Contract_Number__c,a.Sales_Price__c,a.Segmentation__c,a.Pre_Segmentation__c,a.Active_Contract__r.Account__r.name,';
            qry  = qry + 'a.Projected_Renewal_Calc__c, a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,a.Renewal_Product__r.Projected_Renewal_LC__c,a.Renewal_Product__r.Projected_Time_Duration_Months__c,a.Active_Contract__r.Contract_Term_Months__c,a.Raw_Maint_Calc_LC__c,a.Product__r.Family';
            qry  = qry + ' From Active_Contract_Product__c a where ';
            qry  = qry + ' (a.Converted_To_Opportunity__c = false or a.Converted_To_Opportunity__c = true) ';
            qry =  qry +  ' and a.Product__c IN (Select Product2id From PricebookEntry  where IsActive =true and Pricebook2Id=: strpricebookid and currencyIsoCode=:strcurrencycode) and a.Active_Contract__r.Account__c = ' + WhereCond;
            qry  = qry + '  order by ' +   sortFullExp + ' limit 1000';
            
            System.debug('qry-------------'+qry);
            RenewalProductList.clear();
            ActProductMap.clear();
            List<Active_Contract_Product__c> act_temp = new List<Active_Contract_Product__c>();
            
            //System.debug('_________________________Anitha Query on Sort'+qry);
            //system.assert(false,qry);
            act_temp = Database.query(qry);
            
            for(Active_Contract_Product__c ac: act_temp){                        
                RenewalProductList.add(new RenewalProductDetails(ac)); 
                ActProductMap.put(String.ValueOf(ac.id),ac);
            }                        
            act_temp = null; 
            hasNext = getHasNext();
            hasPrevious = getHasPrevious();   
            List<RenewalProductDetails> my_plist = new List<RenewalProductDetails>();
            pageSize = pages;
            
            
            if(getResultSize() > pageSize)
            {
                
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
                
                if((acpage > npages) || (acpage <=0))
                {
                    acpage = 1;
                }
                
                pageSize = pages;
                
                
                
                remainder = getResultsize() - (pageSize*npages);   
                
                for (integer i=0; i<pagesize; i++)
                {
                    if(((acpage-1)*pagesize +i) < getResultsize())
                        my_plist.add(RenewalProductList[(acpage-1)* pageSize + i]); 
                }
                
            }        
            else
            {
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
            
            return null; 
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
            ApexPages.addMessage(myMsg);
            return null;                 
        }           
    }
    
    public pagereference applyFilter()
    {                     
        ViewData();
        return null;            
    }
    List<OpportunityLineItem> oppLineItm = new List<OpportunityLineItem>();
    List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
    //samap01 - using common util class -Dec 7 2017
    
    public Pagereference CreatOpportunityProduct()
    {
        Savepoint sp = Database.setSavepoint();
        string returnurl = '/'+opp.Id;
        try
        {
             if( !hasprimarycontact)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot proceed as No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
                    ApexPages.addMessage(myMsg);   
                    System.debug('samap01 myMsg'+myMsg);
            return null;
           
        }
       
            System.debug('samap01 --CreatOpportunityProduct called');
            boolean flag =false;
            Decimal Term_Month= 0.0;
            Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
            Set<id> prodIds = new Set<id>();
            Map<id, Decimal> mapACPSalesprice = new Map<id,Decimal>(); //samap01
            set<Id> prod = new set<Id>();    
            Set<Id> actId = new Set<Id>() ; 
            List <Active_Contract_Product__c> ACP =  new   List <Active_Contract_Product__c>();
            //string cbuValue;
            
            if(opp.Start_Date__c != null &&  opp.End_Date__c != null)
                Term_Month =     ARRandDurationCalculation.monthsbetweendates(opp.Start_Date__c, opp.End_Date__c);
            for(RenewalProductDetails lstVal:RenewalProductList)
            {                   
                if(lstVal.selected)
                {   
                    prodIds.add(lstVal.activeContractProd.Product__c);
                    ActiveContractIds.add(lstVal.activeContractProd.Id); // samap01 -revrec 
                    ACP.add(lstVal.activeContractProd);
                    System.debug('samap01 -selected acp'+lstVal.activeContractProd.id +'--'+ lstVal.activeContractProd.name);
                }
            }
            if(ACP!=null && ACP.size() >0)
            {
                
                Map<id,PricebookEntry> ACPProd = new Map<id,PricebookEntry>();  //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);
                if(prodIds.size()>0){
                    for(PricebookEntry p : [Select Id,Name,Product2Id,product2.Commissionable_BU__c From PricebookEntry where Product2Id in :prodIds and 
                                            Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode  =:opp.CurrencyIsoCode]){
                                                ACPProd.put(p.Product2Id,p);
                                            }       
                }   
                for(Active_Contract_Product__c actvCP : ACP)
                {
                    if(ACPProd.get(actvCP.Product__c)!=null)
                    {
                        actId.add(actvCP.Id); 
                    }
                    else
                    {
                        flag =true;
                    }
                }
                
                if(flag==true){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Pricebook is not active for selected product(s)!');    
                    ApexPages.addMessage(myMsg);   
                    System.debug('samap01 myMsg'+myMsg);
                    return null;    
                }
                else{
                    //get Pricbookentry
                    
                    //Get ACL
                    Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>(); 
                    List <Active_Contract_Line_Item__c> aclineitems = new   List <Active_Contract_Line_Item__c> (); 
                    
                    aclmap = Renewal_OpportunityUtilityClass.getActiveContractLineItems(actId,opp.AccountId);
                    System.debug('samap01 aclmap-Renewal_OpportunityUtilityClass'+aclmap);
                    aclineitems = Renewal_OpportunityUtilityClass.acllist;
                    System.debug('samap01 aclineitems'+aclineitems);
                    //if more records - go for job
                    if(aclineitems!=null && aclineitems.size() > Integer.Valueof(System.Label.Opportunity_BatchSize))
                    {
                        System.debug('samap01 - runbatch is true'+ aclineitems.size());
                        runbatch =true;
                    }
                    
                    if(runbatch == true)
                    {
                        returnurl = '/apex/showACLIbatchProgress?rtype=Attach&id='+opp.Id;
                        System.debug('samap01- calling batch job ActiveContractIds'+ ActiveContractIds);
                        Batch_RenewalAttachContracts bcn = new Batch_RenewalAttachContracts(ActiveContractIds,opp.Id,MapPE) ;
                        ID batchprocessid = Database.executeBatch(bcn,1);
                        opp.Attach_Contracts_Batch_Id__c = batchprocessid;
                        update opp;                        
                        //OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
                        
                        //Database.executeBatch(new Batch_RenewalAttachContracts(ActiveContractIds,opp.Id));
                        System.debug('samap01- end batch job');
                    }
                    else
                    {
                        //Create CA Prod Rnwl for all ACP
                        
                        Map<id,id> mRCPACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Renewal Contract Product           
                        
                        mRCPACP = Renewal_OpportunityUtilityClass.createProdRenewal(ACP, opp);
                        System.debug('samap01- prod renewal created - loop acp and create oli');
                        
                        Map<id,id> mapACLOLI = new Map<id,id>(); //SAMAP01 27/10 Opportunity_Product__c    
                        //mapACLOLI = Renewal_OpportunityUtilityClass.CreateOpportunityproducts( prod,aclineitems,opp);
       				 system.debug(' sun is here aclmap ' + aclmap);
                        mapACLOLI = Renewal_OpportunityUtilityClass.CreateOpportunityproducts(actId, prodIds,aclmap,opp);
                        System.debug('samap01- CreateOpportunityproducts' +mapACLOLI);
                        List<Active_Contract_Line_Item__c>  aclines = new List<Active_Contract_Line_Item__c>(); 
                        if(aclineitems!=null && aclineitems.size()>0){
                            for(Active_Contract_Line_Item__c acl : aclineitems )
                            {
                                acl.Opportunity_Product__c = mapACLOLI.get(acl.id);
                                aclines.add(acl);
                            }
                            
                            if(aclines!=null && aclines.size() > 0)
                            {
                                update aclines;
                                System.debug('samap01- aclines updated' +aclines);
                            }
                        }
                        
                        
                        List<Active_Contract_Product__C> ActProduct = new List<Active_Contract_Product__c>();
                        
                        for(Active_Contract_Product__c actvp : ACP)
                        {       
                            actvp.Converted_To_Opportunity__c = true;
                            actvp.Opportunity__c = opp.id; 
                            actvp.Renewal_Contract_Product__c =mRCPACP.get(actvp.id);//FY13
                            System.debug(' samap01 - Renewal_Contract_Product__c mRCPACP.get(acp.id)'+mRCPACP.get(actvp.id));
                            actvp.Sales_Price__c =Renewal_OpportunityUtilityClass.mapACPSalesprice.get(actvp.id); 
                            ActProduct.add(actvp); 
                            System.debug('samap01 -actvp'+ actvp);
                        }
                        
                        
                        if(ActProduct.size() > 0)
                        {
                            update ActProduct;
                            System.debug('samap01 -ActProduct'+ ActProduct);
                        }
                    }
                    
                }    
            }
            
            PageReference pageRef = new PageReference(returnurl);
            pageRef.setRedirect(true);
            return pageRef;
            
            
        }
        catch(DMLException e)
        {
            if(e.getDmlType(0)==StatusCode.REQUIRED_FIELD_MISSING)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Pricebook is not active for selected product(s)!');    
                ApexPages.addMessage(myMsg);
                Database.rollback(sp);
                return   null;
                
            } 
            else{ 
                system.assert(false,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
                ApexPages.addMessage(myMsg);
                System.debug('samap01- error occured rollback all the inserts');
                Database.rollback(sp);
                return       null;
                // return null;
            }
        } 
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
    
    public List<RenewalProductDetails> getRenewalProductList(){
        pageSize = pages;
        
        if(getResultSize() > pageSize)
        {
            List<RenewalProductDetails> my_plist = new List<RenewalProductDetails>();
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
                    my_plist.add(RenewalProductList[(acpage-1)* pageSize + i]); 
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
        
        return RenewalProductList;
        
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
        if(RenewalProductList== null)
            return 0;
        else
            return RenewalProductList.size();
    }
    
    public class RenewalProductDetails{
        public Active_Contract_Product__c activeContractProd{get; set;}
        public Boolean selected {get; set;}
        
        public RenewalProductDetails(Active_Contract_Product__c a){
            activeContractProd= a;
            selected = false;
        }
    }
    //samap01 -revrec
    
    
}