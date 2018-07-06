/*
* Test Class = Renewal_editOppProduct_test
* Coverage = 77%
* Updated by - BAJPI01
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       19/10/2017       US370595        RevRec: SFDC Opportunity License Classification for renewal products
* SAMAP01 		26/12/2017		us423678		 RevRec - Modified to handle apex cpu limit
* ********************************************************************************************/
public with sharing class Renewal_editOppProduct {
    
    @TestVisible
    private Boolean haserror;      //US311530 BAJPI01 - if start date>=end date, an error is thrown.
    @TestVisible
    private Map<Id,Boolean> hasDateErrorMap = new Map<Id,Boolean>();
    
    //BAJPI01 - for uniform update of start/end date on opp header
    @TestVisible
    private List<OpportunityLineItem> allLineItems = new List<OpportunityLineItem>();  
    
    //BAJPI01 - for uniform update of start/end date on opp header
    @TestVisible
    private List<OpportunityLineItem> nonRenewalLineItems = New List<OpportunityLineItem>(); 
    
    //BAJPI01 - for uniform update of start/end date on opp header
    @TestVisible
    private Set<String> Businesstype = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'};  
    
    String strOppId;   
    String WhereCond;   
    //added these variable to get the filter values.
    public String Product_Name_Filter {get;set;}
    public String Orig_Exp_Date_Filter {get;set;}
    public String Raw_Maint_Calc_Filter {get;set;}
    public String Sales_Price_Filter{get;set;}
    public String Stretch_Filter {get;set;}
    public String Quote_Filter {get;set;}
    public String Contract_Filter {get;set;}
    public String BusinessType_Filter {get;set;}
    public String quote {get;set;}
    public Decimal ContractNo {get;set;}
    public integer npages;    
    public integer remainder;
    public integer acpage = 1;
    public Integer PageSize = 10 ;
    public List<OpportunityLineItem> oppItmList;
    public Opportunity opp_temp {get;set;}
    public Decimal TotalSP {get;set;}
    public Boolean showMsg {get;set;}
    private String sortDirection = 'ASC'; 
    private String sortExp = 'CA_Contract_Product_Name__c';   
    public  Map<ID,CA_Product_Renewal__c> mapACPidToRCPrecord = new Map<id,CA_Product_Renewal__c>();
    public  List<CA_Product_Renewal__c> lstUpdateRCP = new List<CA_Product_Renewal__c>();
    public  Map<ID,Active_Contract_Product__c> mapACPidToACPrecord = new Map<id,Active_Contract_Product__c>();
    public  List<Active_Contract_Product__c> lstUpdateACP = new List<Active_Contract_Product__c>();
    public decimal totalStretch;
    public decimal TimeRenewal{get;set;}
    public decimal PageStretch{get;set;}
    public Date startdate {get;set;}  //US311530 BAJPI01
    public Date enddate {get;set;}    //US311530 BAJPI01
    private Integer pos;        //US311530 BAJPI01
    public String position{get;set;}  //US311530 BAJPI01
   
    
    public void PopulateRenewalProducts()
    {
        for(CA_Product_Renewal__c ca :[select Id, Quote__C, Contract_No__c, 
                                       Projected_Renewal__c, 
                                       Active_Contract_Product__c 
                                       from CA_Product_Renewal__c 
                                       where Renewal_Opportunity__c =:strOppId ])
        {
            mapACPidToRCPrecord.put(ca.Active_Contract_Product__c, ca);  
        }
        // Code for Updating Active Contract Products - 7 Oct 2011         
        for(Active_Contract_Product__c acp :[select Id, Sales_Price__c, 
                                             Opportunity_Product__c, 
                                             Renewal_Contract_Product__c 
                                             from Active_Contract_Product__c 
                                             where Opportunity__c =:strOppId ])
        {
            mapACPidToACPrecord.put(acp.Id, acp);  
        }         
        
    }
    
    
    Set<Id> rwlpdt = new Set<Id>();
    
    public Renewal_editOppProduct(ApexPages.StandardController controller) 
    {
        strOppId=system.currentPageReference().getParameters().get('Id');
        
        
        if(strOppId <> null)
            opp_temp = [Select id, Quote_Number__c,Reason_duration_is_1_year__c,Status_at_end_of_term__c, New_Deal_Term_months__c, Contract_Number_EU4cast__c,  name,  
                        Total_Raw_Maintenance_Cacl__c, Stretch_Deal_Term_Months__c, Baseline_ATTRF_LC__c,
                        Stretch_Sales_Price_Gap_Reason__c, Business_Type__c , Projected_Renewal__c, 
                        Time_Renewal_Roll_Up__c,Start_Date__c,End_Date__c,Renewal_BatchId__c //samap01
                        From Opportunity 
                        where id = : strOppId];
        else
            opp_temp = new Opportunity();
        
        TotalSP = opp_temp.Projected_Renewal__c;
        
        TimeRenewal = opp_temp.Time_Renewal_Roll_Up__c; //danva01
        TimeRenewal = TimeRenewal.setScale(2,System.RoundingMode.HALF_UP); 
        System.debug('TimeRenewal-----------------'+TimeRenewal);
        
        //TimeRenewal = opp_temp.Time_Renewal_Roll_Up__c.Scale();
        haserror =false;
        oppItmList = new List<OpportunityLineItem>();
        mainMethod();
        
    }
    
    public void mainMethod()
    {
        oppItmList = new List<OpportunityLineItem>();
        PopulateRenewalProducts();
        
        PageStretch = 0;
        
        allLineItems = [select o.Contract_Number__c, o.CA_Contract_Product_Name__c,
                        o.Opportunity.New_Deal_Term_months__c, o.Opportunity.Stretch_Deal_Term_Months__c,
                        o.Opportunity.Stretch_Sales_Price_Gap_Reason__c,o.Corporate_ARR__c,o.Stretch_Corporate_ARR__c,
                        o.Opportunity.Business_Type__c, o.Opportunity.id, o.Opportunity.Projected_Renewal__c,
                        o.Opportunity.name, o.Opportunity.Total_Raw_Maintenance_Cacl__c, o.Original_Expiration_Date__c,
                        o.Active_Contract_Number__c, o.Quote_Number__c, o.UnitPrice, o.Stretch__c,o.Start_Date__c,o.End_Date__c,
                        o.Segmentation__c,o.Raw_Maintenance__c,o.Business_Type__c,o.Duration_Days__c,o.New_Deal_Term_months__c,
                        o.Active_Contract_Product__r.Active_Contract_Number__c ,o.Term_Month__c,o.Commissionable_BU__c,
                        o.License__c, o.License_Classification__c, o.Platform_Category__c, Material_Text__c,o.CA_Contract_Product__c   //samap01 revrec US370555 
                        from opportunitylineitem o where o.opportunity.id=:strOppId
                        and Business_Type__c in:Businesstype];
        
        // modifed based on req. 1.06 by subsa03
        if(allLineItems!=null && allLineItems.size()>0){
            for(OpportunityLineItem Opplineitm:allLineItems){
                if(Opplineitm.Business_Type__c=='Renewal'){
                    Opplineitm.UnitPrice = Opplineitm.UnitPrice.setScale(2,System.RoundingMode.HALF_UP);
                    //US311530 BAJPI01 - start
                    if(opplineitm.Start_Date__c==null)
                        opplineitm.Start_Date__c = opp_temp.Start_Date__c;
                    if(opplineitm.End_Date__c==null)
                        opplineitm.End_Date__c = opp_temp.End_Date__c;
                   
                        if(opplineitm.Start_Date__c!=null && opplineitm.End_Date__c!=null){
                            opplineitm.Duration_Days__c = opplineitm.Start_Date__c.DaysBetween(opplineitm.End_Date__c)+1;
                            
                        }
                    
                    oppItmList.add(Opplineitm);
                    hasDateErrorMap.put(Opplineitm.id,false);
                    rwlpdt.add(Opplineitm.Active_Contract_Product__c);
                    System.debug('************');
                    if(Opplineitm.Stretch__c <> null)  {       //fy13 - lfc              
                        System.debug('************ Opplineitm.stretch'+Opplineitm.Stretch__c);
                        PageStretch += Opplineitm.Stretch__c; //fy13 - lfc
                        System.debug('************ PageStretch'+PageStretch);   
                    }
                }
                else{
                    nonRenewalLineItems.add(OppLineitm);
                }
            }
        }
        
        if(PageStretch!=0)
            PageStretch = PageStretch.setScale(2,System.RoundingMode.HALF_UP); // fy13 - lfc
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
    
    
    public pagereference clearFilter()
    {
        Product_Name_Filter = '';
        Orig_Exp_Date_Filter = '';
        Raw_Maint_Calc_Filter= '';
        Sales_Price_Filter= '';
        Stretch_Filter= '';
        Quote_Filter= '';
        Contract_Filter = '';
        BusinessType_Filter ='';
        
        oppItmList.clear(); 
        mainMethod();
        
        return null;
    }
    public pagereference ViewData()
    {
        oppItmList = new List<OpportunityLineItem>();
       
        try{
            WhereCond = '';
            if(Product_Name_Filter != '')
                WhereCond = '  and l.CA_Contract_Product__c = \'' + Product_Name_Filter + '\'';  //samap01 -revrec
            if(Orig_Exp_Date_Filter != '')
                WhereCond = WhereCond +  '  and l.Original_Expiration_Date__c = ' + date.parse(Orig_Exp_Date_Filter);
            WhereCond = WhereCond.replace(' 00:00:00','');
            WhereCond = '\'' + strOppId + '\'' + WhereCond ;
            
            string sortFullExp = sortExpression  + ' ' + sortDirection;        
            String qry  = 'Select l.Contract_Number__c, l.CA_Contract_Product_Name__c,l.Opportunity.New_Deal_Term_months__c,' ; 
            qry  = qry + ' l.Opportunity.Stretch_Deal_Term_Months__c, ' ;
            qry  = qry + 'l.Opportunity.Stretch_Sales_Price_Gap_Reason__c,';
            qry  = qry + 'l.Opportunity.Business_Type__c,l.Opportunity.id,';
            qry  = qry + 'l.Opportunity.Projected_Renewal__c,l.Opportunity.name,';
            qry  = qry + 'l.Opportunity.Total_Raw_Maintenance_Cacl__c,';
            qry  = qry + ' l.Opportunity.Start_Date__c,l.Opportunity.End_Date__c,l.Opportunity.Baseline_ATTRF_LC__c, ' ;
            qry  = qry + 'l.Original_Expiration_Date__c,l.Active_Contract_Number__c,l.Active_Contract_Product__r.Active_Contract_Number__c,';
            qry  = qry + 'l.Quote_Number__c,l.UnitPrice,l.Stretch__c,l.Segmentation__c,';
            qry  = qry + 'l.Start_Date__c,l.End_Date__c,l.Corporate_ARR__c,l.Duration_Days__c,';
            qry  = qry + 'l.Stretch_Corporate_ARR__c,l.Commissionable_BU__c,  l.License__c, l.License_Classification__c, l.Platform_Category__c, l.Material_Text__c,l.CA_Contract_Product__c,  ';
            qry  = qry + 'l.Raw_Maintenance__c,l.Business_Type__c From opportunitylineitem l ' ; 
            qry  = qry + 'where  l.OpportunityId = '+ WhereCond + ' AND Business_Type__c =\'Renewal\' order by ' +  sortFullExp + ' limit 1000';                   
            oppItmList = Database.query(qry);
            
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
        }
        return null;
        
    }
    
    public pagereference applyFilter()
    {                     
        
        ViewData();
        return null;
    }
    // here need to add oppline item
    public pagereference updateOpportunity(){
        haserror = false;
        
        Map<ID,Decimal> mapACPSalesprice = new Map<id,Decimal>(); //samap01 11/7
               //samap01- revrec
        Map<Id, LIST<OpportunityLineItem>> olimap = new Map<id, LIST<OpportunityLineItem >>(); //Samap01
        Set<Id> Activecontractproduct  = new Set <Id> ();
        //decimal acpsalesprice=0;
        //samap0q-reverec
        for(Id key:hasDateErrorMap.keyset()){  
            if(hasDateErrorMap.get(key)==true)
                haserror = true;
        }
        
        //US311530 BAJPI01
        if(haserror){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            return null;  
        }
        else{
            
            try {
                lstUpdateRCP = new List<CA_Product_Renewal__c>(); //Code for Updating Renewal Contract Products
                lstUpdateACP = new List<Active_Contract_Product__c>(); //Code for Updating Active Contract Products - 7 Oct 2011
                if(TimeRenewal==null)
                    TimeRenewal = 0;
                // FY13 - If specified Total Stretch is less than Total Sales Price, default to Total Sales Price
                if(PageStretch < TimeRenewal){
                    PageStretch = TimeRenewal;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Total Stretch may not be less than Sales Price. Value adjusted.'));
                }
                
                
                
                // handle Opp Line Item list where there are multiple lines
                Double acpsalesprice = 0.0; //samap01 30/10
                for(OpportunityLineItem Oli:oppItmList){
                   
                    // Default values if line item raw maint is not > 0 or if total raw maint is not > 0
                    if((Oli.raw_maintenance__c == null || Oli.raw_maintenance__c == 0) ||
                       (opp_temp.Total_Raw_Maintenance_Cacl__c  == null || opp_temp.Total_Raw_Maintenance_Cacl__c == 0)){
                           Oli.UnitPrice = 0;
                           Oli.Stretch__c = 0;
                           //                        PageStretch = 0;
                       }
                    
                    // Header and line item raw maint is > 0, so we can pro-rate sales price and stretch
                    else{
                        
                        // Pro-rate the sales price based on raw maint
                        System.debug('--------opp_temp.Total_Raw_Maintenance_Cacl__c'+opp_temp.Total_Raw_Maintenance_Cacl__c);
                        Oli.UnitPrice = (Oli.raw_maintenance__c / opp_temp.Total_Raw_Maintenance_Cacl__c) * TimeRenewal;
                        Oli.UnitPrice = Oli.UnitPrice.setScale(2,System.RoundingMode.HALF_UP);             
                        
                        
                        // Pro-rate the total stretch based on total slaes price
                        if(Oli.UnitPrice > 0){
                            Oli.Stretch__c = (Oli.UnitPrice / TimeRenewal) * PageStretch;
                            Oli.Stretch__c = Oli.Stretch__c.setScale(2,System.RoundingMode.HALF_UP);
                        }
                        else
                        {
                            Oli.Stretch__c = 0.0;                     
                        }
                    }
                    //samap01 -Revrec - Update ACP with total sales value for each oli 30/10 - get the sales price for each oli 
                    if(!mapACPSalesprice.containsKey(oli.Active_Contract_Product__c))
                        mapACPSalesprice.put(oli.Active_Contract_Product__c,Oli.UnitPrice) ; 
                    else
                        mapACPSalesprice.put(oli.Active_Contract_Product__c,mapACPSalesprice.get(oli.Active_Contract_Product__c) + oli.UnitPrice);
                    
                    //samap01 30/10 -revrec end                 
                    // Update Quote Number on line item, if one is specified on the header
                    if(Oli.Quote_Number__c == '' || Oli.Quote_Number__c == Null)
                        Oli.Quote_Number__c = opp_temp.quote_number__c;
                    
                    // Update Contract Number on line items, if one is specified on the header
                    if(Oli.Contract_Number__c == null || Oli.Contract_Number__c == '0' || Oli.Contract_Number__c == '0.0'){
                        if(ContractNo != 0)
                            Oli.Contract_Number__c = String.valueOf(opp_temp.Contract_Number_EU4cast__c);
                        else
                            Oli.Contract_Number__c = '';
                    } 
                    /* samap01
                    //Code for Updating Renewal Contract Products - Start
                    CA_Product_Renewal__c capr = mapACPidToRCPrecord.get(oli.Active_Contract_Product__c);
                    if(capr <> null){
                        capr.Projected_Renewal__c = oli.UnitPrice;
                        // capr.Stretch__c = oli.Stretch__c;
                        capr.Quote__c = oli.Quote_Number__c;
                        capr.Contract_no__c = oli.Contract_Number__c;
                        //lstUpdateRCP.add(capr);
                        //   // samap01 -revrec - multiple oli with acp add 25/10 -addonly one
                        if (!listContains(lstUpdateRCP, capr))
                        {
                            lstUpdateRCP.add(capr);
                        }
                    }   
                    //Code for Updating Renewal Contract Products - End
                    
                    //Code for Updating Active Contract Products  - 7 Oct 2011 - Start
                    Active_Contract_Product__c acp = mapACPidToACPrecord.get(oli.Active_Contract_Product__c);
                    if(acp <> null){
                        //acp.Sales_Price__c = oli.UnitPrice;
                        acp.sales_Price__C = mapACPSalesprice.get(oli.Active_Contract_Product__c) ; //samap01 -acp sales price is sum of oli salesprice
                        acp.Opportunity_Product__c = oli.Id;
                        if(capr<>null)
                            acp.Renewal_Contract_Product__c = capr.Id;
                        // if(lstUpdateACP.)
                        // samap01 -revrec - multiple oli with acp add 25/10
                        if (!listContains(lstUpdateACP, acp))
                        {
                            lstUpdateACP.add(acp);
                        }
                        
                        
                    }   
                    //Code for Updating Active Contract Products - 7 Oct 2011 - End
                    */ //samap01
                }
               
                
                 for(OpportunityLineItem oli:oppItmList){
                        //samap01 -revrec                       
                        if (olimap.containsKey(oli.Active_Contract_Product__c)) {
                            olimap.get(oli.Active_Contract_Product__c).add(oli);
                        }
                        else {
                            olimap.put(oli.Active_Contract_Product__c, new List<OpportunityLineItem>{ oli });
                        }
                        
                        System.debug('samap01 oli.Quote_Number__c' + oli.Quote_Number__c);
                        System.debug('samap01 oli.Contract_Number__c' + oli.Contract_Number__c);
                        System.debug('samap01 oli.UnitPrice' + oli.UnitPrice);
                        System.debug('samap01 oli.Active_Contract_Product__c' + oli.Active_Contract_Product__c);
                        //samap01 -revrec -end
                        
                        
                    }
                    //samap01 -revrec start - Update ACP with sum of the SalesPrice for each contract so that it reflects that of Contract as oli is for every ACL now
                    if(olimap.size() > 0)
                    {
                        for( Id acpid :olimap.keySet() )
                        {
                            List<OpportunityLineItem> olimaplist = olimap.get(acpid)  ;       
                            if( olimaplist.size() >0)
                            {
                                acpsalesprice = 0;
                                string Quote ='';
                                string Contract_Number ='';
                                for(opportunitylineitem  olineitem :olimaplist )
                                {
                                    acpsalesprice += olineitem.UnitPrice ;
                                    Quote = olineitem.Quote_Number__c;
                                    Contract_Number = olineitem.Contract_Number__c;
                                    
                                }
                                
                                // Update Renewal Contract Product
                                CA_Product_Renewal__c capr = mapACPidToRCPrecord.get(acpid);
                                if(capr <> null){
                                    capr.Quote__C = Quote;
                                    capr.Contract_No__c = Contract_Number;
                                    capr.Projected_Renewal__c = acpsalesprice;
                                    lstUpdateRCP.add(capr);
                                    
                                    System.debug('samap01 capr.id' + capr.id);
                                } 
                                
                                // Update Active Contract Product - 7 Oct 2011
                                Active_Contract_Product__c acp = mapACPidToACPrecord.get(acpid);
                                if(acp <> null){
                                    acp.Sales_Price__c = acpsalesprice;
                                    if(capr <> null)
                                        acp.Renewal_Contract_Product__c = capr.Id; //FY13
                                    lstUpdateACP.add(acp);
                                } 
                            }
                        }
                    }
                    //samap01 -revrec -end
                TotalSP = opp_temp.Time_Renewal_Roll_Up__c; //opp_temp.Projected_Renewal__c;
                Renewals_Util.Renewal_updateProjectedRenewalOnOpp = true;         
                //          opp_temp.Time_Renewal_Roll_Up__c = TimeRenewal;
                //          //samap01- US423678-Apex cpu limit
                if(oppItmList.size()  > Integer.Valueof(System.Label.Opportunity_BatchSize))
                    //    if(oppItmList.size()  > 200)
                {
                    if( opp_temp.Renewal_BatchId__c ==null ||  opp_temp.Renewal_BatchId__c  =='') 
                    {
                        string returnurl = '/apex/showACLIbatchProgress?rtype=licensetype&id='+opp_temp.Id;
                        System.debug('samap01 -oppItmList' +oppItmList);
                        System.debug('samap01 -lstUpdateACP' +lstUpdateACP);
                        System.debug('samap01 -opp_temp' +opp_temp);
                        System.debug('samap01 -lstUpdateRCP' +lstUpdateRCP);
                        Id jobId = Database.executeBatch(new Batch_GenericIterable(lstUpdateACP,oppItmList,lstUpdateRCP,opp_temp.Id), 200);
                        system.debug('samap01 batch job called for inserts jobId'+ jobId );  
                        OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
                        opp_temp.Renewal_BatchId__c = jobId;       
                        update opp_temp;
                        PageReference pageRef = new PageReference(returnurl);
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A batch job is in progress please try after some time'));
                        return null;
                    }
                    
                }
                else
                {
                    update opp_temp;
                    
                    if(oppItmList.size()>0)    
                        update oppItmList;
                    
                    //Code for Updating Active Contract Products  - 7 Oct 2011 
                    if(lstUpdateACP.size()> 0)
                        update lstUpdateACP;   
                    
                    if(lstUpdateRCP.size()> 0)
                        update lstUpdateRCP;   
                }
                
                
                
            } catch(Exception e)
            {
                if(!e.getmessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                {
                    // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
                    //ApexPages.addMessage(msg); 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.GetMessage()+'---->'+e.getCause()+'---->'+e.getLineNumber()+'---->'+e.getStackTraceString());
                    ApexPages.addMessage(myMsg);
                }
                else if(e.getmessage().contains('Reason duration is ')){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
                    ApexPages.addMessage(msg); 
                }
            }
        }
        return null;
    } 
    
    //samap01 
    public Boolean listContains(Object[] source, Object target) {
        return (new Set<Object>(source)).contains(target);
    }
    //samap01 -end
    // Opportunity product is updated based on the 1.06 req by subsa03
    public pagereference updateProducts(){
        
        decimal newSP = 0;
        haserror = false;
        //samap01- revrec
        Map<Id, LIST<OpportunityLineItem>> olimap = new Map<id, LIST<OpportunityLineItem >>(); //Samap01
        Set<Id> Activecontractproduct  = new Set <Id> ();
        decimal acpsalesprice=0;
        //samap0q-reverec
        for(Id key:hasDateErrorMap.keyset()){  
            if(hasDateErrorMap.get(key)==true)
                haserror = true;
        }
        
        //US311530 BAJPI01
        if(haserror){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            return null;  
        }
        else if(opp_temp.New_Deal_Term_months__c!=null && opp_temp.New_Deal_Term_months__c<12 && (opp_temp.Reason_duration_is_1_year__c==null||opp_temp.Status_at_end_of_term__c==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
        }
        else{
            
            try{
                if(TimeRenewal==null)
                    TimeRenewal = 0;
                // Prep lists for RCP and ACP updates
                lstUpdateRCP = new List<CA_Product_Renewal__c>();
                lstUpdateACP = new List<Active_Contract_Product__c>();
                
                if(oppItmList.size() > 0){
                    newSP = 0;
                    
                    for(OpportunityLineItem oli:oppItmList){
                        newSP += oli.UnitPrice;
                        /*
// Update Renewal Contract Product
CA_Product_Renewal__c capr = mapACPidToRCPrecord.get(oli.Active_Contract_Product__c);
if(capr <> null){
capr.Quote__C = oli.Quote_Number__c;
capr.Contract_No__c = oli.Contract_Number__c;
capr.Projected_Renewal__c = oli.UnitPrice;
lstUpdateRCP.add(capr);


} 

// Update Active Contract Product - 7 Oct 2011
Active_Contract_Product__c acp = mapACPidToACPrecord.get(oli.Active_Contract_Product__c);
if(acp <> null){
acp.Sales_Price__c = oli.UnitPrice;
acp.Opportunity_Product__c = oli.Id; //FY13
if(capr <> null)
acp.Renewal_Contract_Product__c = capr.Id; //FY13
lstUpdateACP.add(acp);
} 
}*/
                        
                        //samap01 -revrec                       
                        if (olimap.containsKey(oli.Active_Contract_Product__c)) {
                            olimap.get(oli.Active_Contract_Product__c).add(oli);
                        }
                        else {
                            olimap.put(oli.Active_Contract_Product__c, new List<OpportunityLineItem>{ oli });
                        }
                        
                        System.debug('samap01 oli.Quote_Number__c' + oli.Quote_Number__c);
                        System.debug('samap01 oli.Contract_Number__c' + oli.Contract_Number__c);
                        System.debug('samap01 oli.UnitPrice' + oli.UnitPrice);
                        System.debug('samap01 oli.Active_Contract_Product__c' + oli.Active_Contract_Product__c);
                        //samap01 -revrec -end
                        
                        
                    }
                    //samap01 -revrec start - Update ACP with sum of the SalesPrice for each contract so that it reflects that of Contract as oli is for every ACL now
                    if(olimap.size() > 0)
                    {
                        for( Id acpid :olimap.keySet() )
                        {
                            List<OpportunityLineItem> olimaplist = olimap.get(acpid)  ;       
                            if( olimaplist.size() >0)
                            {
                                acpsalesprice = 0;
                                string Quote ='';
                                string Contract_Number ='';
                                for(opportunitylineitem  olineitem :olimaplist )
                                {
                                    acpsalesprice += olineitem.UnitPrice ;
                                    Quote = olineitem.Quote_Number__c;
                                    Contract_Number = olineitem.Contract_Number__c;
                                    
                                }
                                
                                // Update Renewal Contract Product
                                CA_Product_Renewal__c capr = mapACPidToRCPrecord.get(acpid);
                                if(capr <> null){
                                    capr.Quote__C = Quote;
                                    capr.Contract_No__c = Contract_Number;
                                    capr.Projected_Renewal__c = acpsalesprice;
                                    lstUpdateRCP.add(capr);
                                    
                                    System.debug('samap01 capr.id' + capr.id);
                                } 
                                
                                // Update Active Contract Product - 7 Oct 2011
                                Active_Contract_Product__c acp = mapACPidToACPrecord.get(acpid);
                                if(acp <> null){
                                    acp.Sales_Price__c = acpsalesprice;
                                    if(capr <> null)
                                        acp.Renewal_Contract_Product__c = capr.Id; //FY13
                                    lstUpdateACP.add(acp);
                                } 
                            }
                        }
                    }
                    //samap01 -revrec -end
                    System.debug('samap01 newsp'+ newSP);
                    
                    // Adjust Total Stretch if Total Sales Price goes above it
                    if(PageStretch < newSP) {
                        PageStretch = newSP;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Total of Sales Price values may not exceed Stretch. Stretch value adjusted.'));
                    }
                    
                    
                    // Prorate Total Stretch based on new total sales price
                    for(OpportunityLineItem oli:oppItmList){
                        if(oli.UnitPrice > 0){
                            System.debug('samap01 Prorate Total Stretch '+ newSP);
                            oli.Stretch__c = (oli.UnitPrice / newSP) * PageStretch;
                            oli.Stretch__c = oli.Stretch__c.setScale(2,System.RoundingMode.HALF_UP);
                        }
                        else
                            oli.Stretch__c = 0.0;
                        
                    }
                }       
                
                
                if(TotalSP  <> newSP){
                    TotalSP = newSP;
                    TimeRenewal = newSP;
                    System.debug('samap01 Prorate Total TotalSP '+ TotalSP);
                }
                
                
                //samap01 dec 22 - US423678 -APEX CPU LIMIT fix
                if(oppItmList.size()  > Integer.Valueof(System.Label.Opportunity_BatchSize))
                    // if(oppItmList.size()  > 200)
                {
                    if( opp_temp.Renewal_BatchId__c ==null ||  opp_temp.Renewal_BatchId__c  =='') 
                    {
                        string  returnurl = '/apex/showACLIbatchProgress?rtype=licensetype&id='+opp_temp.Id;
                        System.debug('samap01 -oppItmList' +oppItmList);
                        System.debug('samap01 -lstUpdateACP' +lstUpdateACP);
                        System.debug('samap01 -opp_temp' +opp_temp);
                        System.debug('samap01 -lstUpdateRCP' +lstUpdateRCP);
                        Id jobId = Database.executeBatch(new Batch_GenericIterable(lstUpdateACP,oppItmList,lstUpdateRCP,opp_temp.Id), 200);
                        system.debug('samap01 batch job called for inserts jobId'+ jobId );  
                        OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
                        opp_temp.Renewal_BatchId__c = jobId;                        
                        update opp_temp;
                        PageReference pageRef = new PageReference(returnurl);
                        pageRef.setRedirect(true);
                        return pageRef;
                        
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'A batch job is in progress please try after some time'));
                        return null;
                    }
                }
                else
                {
                    update opp_temp;
                    
                    if(oppItmList.size()>0)    
                        update oppItmList;
                    
                    //Code for Updating Active Contract Products  - 7 Oct 2011 
                    if(lstUpdateACP.size() >0)
                        update lstUpdateACP;
                    
                    if(lstUpdateRCP.size() >0)
                        update lstUpdateRCP;
                }
                return null;
                
            }catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
                ApexPages.addMessage(msg); 
            }
        }
        return null;
        
    }  
    
    public void setOppItmList(List<OpportunityLineItem> oppItmList){
        this.oppItmList = oppItmList;
    }
    
    
    public List<OpportunityLineItem> getOppItmList(){
        
        if(getResultSize() > pageSize)
        {
            List<OpportunityLineItem> my_plist = new List<OpportunityLineItem>();
            npages = getResultsize()/pagesize;
            remainder = getResultsize() - (pageSize*npages);   
            
            for (integer i=0; i<pagesize; i++)
            {
                if(((acpage-1)*pagesize +i) < getResultsize())
                    my_plist.add(oppItmList[(acpage-1)* pageSize + i]); 
            }
            return my_plist;
        }        
        return oppItmList;
        
        
    } 
    
    
    
    public boolean getHasNext() {
        if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize())
            return false;
        else    
            return true;
    }
    
    public Boolean getHasPrevious() {
        if( getResultSize() == 0 || acpage == 1 )
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
        if(oppItmList== null)
            return 0;
        else
            return oppItmList.size();
    }
    
    //US311530 BAJPI01 - start - method called everytime unitprice/start/end date on line item is changed.
    //then calls a method to recalculate opp header start and end dates.
    public void getDaysBetweenLineItem(){
        pos = Integer.valueOf(position);
        pos = ((acpage-1)*pageSize)+pos;
        system.debug('---position index----'+pos);
        OpportunityLineItem oli = oppItmList[pos];
        startdate = oli.start_Date__c;
        enddate = oli.End_Date__c;
        system.debug('opp line item>>'+oli);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        Decimal n = 0.00;
        
        if(startdate!=null && enddate!=null){
            if(startdate>=enddate){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
                hasDateErrorMap.put(oli.id,true);
            }
            else{
                hasDateErrorMap.put(oli.id,false);
               
                if(startdate!=null && enddate!=null){
                    oli.Duration_Days__c = startdate.daysBetween(enddate)+1;
                    oli.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(startdate,enddate);
                    oli.Term_Month__c = oli.New_Deal_Term_months__c;
                   
                    oppItmList[pos] = oli;
                    updateOppHeaderDates();
                }
            }
        }
    }
    //method updates opp header with min start date of line item and max end date of line item.
    public void updateOppHeaderDates(){
        List<OpportunityLineItem> updatedlineitems = new List<OpportunityLineItem>();
        updatedlineitems.addAll(oppItmList);
        if(nonRenewalLineItems!=null && nonRenewalLineItems.size()>0)
            updatedlineitems.addAll(nonRenewalLineItems);
        Date oppstartdate=updatedlineitems[0].start_Date__c;
        Date oppenddate=updatedlineitems[0].End_Date__c;
        for(OpportunityLineItem oli:updatedlineitems){
            if(oli.start_Date__c!=null){
                if(oppstartdate!=null){
                    if(oli.Start_Date__c<oppstartdate)
                        oppstartdate = oli.Start_Date__c;
                }
                else{
                    oppstartdate = oli.Start_Date__c;
                }
            }
            if(oli.end_date__c!=null){
                if(oppenddate!=null){
                    if(oli.End_Date__c>oppenddate)
                        oppenddate = oli.End_Date__c;
                }
                else{
                    oppenddate = oli.End_Date__c;
                }
            }
        }
        if(oppstartdate!=null && oppenddate!=null){
            opp_temp.start_Date__c = oppstartdate;
            opp_temp.end_date__c = oppenddate;
        }
        
        
        
        //New Deal Term Months on Opp will be populated for Renewal Products.
        oppstartdate=oppItmList[0].start_Date__c;
        oppenddate=oppItmList[0].End_Date__c;
        for(OpportunityLineItem oli:oppItmList){
            if(oli.start_Date__c!=null){
                if(oppstartdate!=null){
                    if(oli.Start_Date__c<oppstartdate)
                        oppstartdate = oli.Start_Date__c;
                }
                else{
                    oppstartdate = oli.Start_Date__c;
                }
            }
            if(oli.end_date__c!=null){
                if(oppenddate!=null){
                    if(oli.End_Date__c>oppenddate)
                        oppenddate = oli.End_Date__c;
                }
                else{
                    oppenddate = oli.End_Date__c;
                }
            }
        }
        opp_temp.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(oppstartdate,oppenddate);
        if(opp_temp.New_Deal_Term_months__c!=null && opp_temp.New_Deal_Term_months__c<12){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
        }
        
        
    }
    //method called when mass update is called from the renewals page. - sets the return url as well. this redirects to
    //mass update date page.
    public PageReference massupdatedates(){
        String retURL = '/apex/Renewal_editOppProduct?id='+strOppId;
        PageReference pg;
        pg = new PageReference('/apex/OppLineItemMassUpdateDateVF?id='+strOppId);
        pg.getParameters().put('retURL', retURL);
        pg.setRedirect(true);
        return pg;
    }
    //US311530 BAJPI01 - end
    //samap01- Revrec
    //method called when mass edit products  is called from the renewals page. - sets the return url as well. this redirects to
    //mass update date page.
    public PageReference masseditproducts(){
        String retURL = '/apex/Renewal_editOppProduct?id='+strOppId;
        PageReference pg;
        pg = new PageReference('/apex/Renewal_LicenseMassEdit?id='+strOppId);
        pg.getParameters().put('retURL', retURL);
        pg.setRedirect(true);
        return pg;
    }
    //samap01- Revrec -end
   
    
}