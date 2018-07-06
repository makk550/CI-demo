/*
* Edited By      : Sourabh Jain 
* Description    : Fetch the products based on the Role [Arcot Development]
* 
* Test Class = OppLineItemControllerTest
* Coverage - 78%
* Updated by BAJPI01
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMTU01       29/9/2017       US387241        RevRec: SFDC Real ARR Stretch Requires New Fee Calculations
* SAMAP01       02/10/2017       US377325       RevRec: SFDC Opportunity Prices Likely to Close 
* SAMAP01       17/10/2017       US370554        RevRec: SFDC Opportunity License Classification for non renewal products
* SAMAP01		07/12/2017		US424523		RevRec: SFDC Forecasting TARR on Opportunities
* ********************************************************************************************/

public class OppLineItemcontroller
{
    private String strProductType = '';
    private String strOppId = '';
    private List<OpportunityLineItem> lstoppoli = new List<OpportunityLineItem>();
    private Map<Id,Product2> prdmap;
    private String strpricebookid = '';
    private String strcurrencyisocode = '';
    private Integer monthsoppheader;
    private Integer oldTermMonth;
    private boolean haserror;
    private Opportunity opp = new Opportunity();
    private Date oppstartdate;          //US266282 - BAJPI01 -  for New Products.
    private Date oppenddate;          //US266282 - BAJPI01 -  for New Products.
    
    public OpportunityLineItem lineitemrecord {get;set;}
    public Integer lineCounter {get;set;}
    public boolean didOverrideHappen  {get;set;} //Added for AR 3798 : SINjy02 :the Owner of the Opportunity s/b listed on the Opp team with Team Role = Owner
    public Boolean isProduct {get;set;}
    public List<productclass> lst_prd {get;set;}
    public List<SelectOption> selbu {get;set;}
    public List<SelectOption> selfamily {get;set;}
    public List<SelectOption> selbustype {get;set;}
    public List<SelectOption> selprdcloudplatformuse {get;set;}
    public String bustypeval {get;set;}
    Set<string> set_ondemand; 
    Set<string> set_ondemandIds  = new Set<String>(); 
    public boolean showOnDemandHeader {get;set;}
    public List<pickval> entries = new List<pickval>();
    public List<pickval> cldplatformuse_entries = new List<pickval>();
    public Id oppId {get;set;}        // fy13
    public String oppName {get;set;}  // fy13
    public boolean alrt {get; set;}    //allha02 AR3576
    public Date startdate {get;set;}  //US266282 - BAJPI01 -  for New Products.
    public Date enddate {get;set;}    //US266282 - BAJPI01 -  for New Products.
    public Opportunity opp_temp {get;set;} //US377325 -SAMAP01-REVREC
    public boolean hasprimarycontact;
    
    //samap01- revrec  US370554
    public string UserRoleName {get;set;}  //samap01 US492574
      public list<SelectOption> LicenseClassification {
        get{
            
            return  LicenseClassificationmapper.LicenseClassification() ;
        }
        set; }    
    
    public list<SelectOption> LicenseClassificationOverride {
        get{
           return LicenseClassificationmapper.LicenseClassificationOverride();
        }
        set; } 
      //samap01- revrec  US370554-end
    
    public pageReference resetIsOverrideChecked(){
        productclass prdclass = lst_prd[pos];
        prdclass.isOverrideClicked = true;
        lst_prd[pos] = prdclass;
        return null;
    }
    public void CalcSalesPrice(){ //Added for AR 3798 : SINjy02 :the Owner of the Opportunity s/b listed on the Opp team with Team Role = Owner
        productclass prdclass = lst_prd[pos];
        OpportunityLineItem oli = prdclass.oppli;
        system.debug('prdclass.oppli>>'+oli);
        decimal totUnitPrice; 
        Decimal totalUfFee = (oli.UF_License_Fee__c <> null? oli.UF_License_Fee__c : 0);
        Decimal totalLicenseFee =   (oli.Total_Maintenance__c <> null? oli.Total_Maintenance__c : 0); 
        totUnitPrice = totalUfFee + totalLicenseFee ;
        oli.unitPrice  = totUnitPrice;
        
        prdclass.oppli = oli;
        prdclass.isOverrideFees = true;
        lst_prd[pos] = prdclass;
        //return null;
    }
    //SAMTU01 US387241
    public void calculateStretch(){ 
        productclass prdclass = lst_prd[pos];
        OpportunityLineItem oli = prdclass.oppli;
        system.debug('prdclass.oppli>>'+oli);
        decimal totStretch; 
        Decimal StretchLicenseFee = (oli.Stretch_License_Fee__c<> null? oli.Stretch_License_Fee__c: 0);
        Decimal StretchMaintFee =  (oli.Stretch_Total_Maintenance__c<> null? oli.Stretch_Total_Maintenance__c: 0); 
        totStretch = StretchLicenseFee + StretchMaintFee ;
        oli.Stretch__c= totStretch;
        
        prdclass.oppli = oli;
        prdclass.isOverrideFees = true;
        lst_prd[pos] = prdclass;
        //return null;
    }
    //SAMTU01 US387241-END
    public void calculateUFLicenseFee()
    {
        
        productclass prdclass = lst_prd[pos];
        OpportunityLineItem oli = prdclass.oppli;
        decimal totMaint;   
        Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
        Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0); 
        Decimal termInMonths =   (oli.Term_Month__c <> null? oli.Term_Month__c  : 0);
        
        Decimal UFLicenseFee = 0;
        if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){
            if(termInMonths <> 0){
                UFLicenseFee =  (totSalesPrice/((0.1364/12*termInMonths)+1));
                
            }
            totMaint  =  0.1364 * UFLicenseFee/12 * termInMonths ; 
        }
        else {
            if(termInYears <> 0){
                UFLicenseFee  = (10 *  totSalesPrice ) /  (10 + 2 * termInYears);      
            }
            totMaint  =  0.2 * UFLicenseFee * termInYears ;
            
        }           
        
        Decimal FirstYearMaint = 0;
        if(termInYears <> 0)
            FirstYearMaint = totMaint / termInYears;
        
        if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription')
        {
           
            oli.UF_License_Fee__c =0; // US461384 -- merha02
            oli.Total_Maintenance__c = 0;            
        }
        else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
        {
            oli.UF_License_Fee__c = UFLicenseFee.setScale(2);
            oli.Total_Maintenance__c = totMaint.setScale(2);            
        }
        
        //SAMTU01 US387241
        
        decimal totalMaint;   
        Decimal totStretch = (oli.Stretch__c<> null? oli.Stretch__c: 0);
        Decimal StretchDurationInYears =   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c/12 : 0); 
        Decimal StretchDurationInMonths1=   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c: 0);
        
        Decimal StretchLicenseFee = 0;
        if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){
            if(StretchDurationInMonths1 <> 0){
                StretchLicenseFee =  (totStretch/((0.1364/12*StretchDurationInMonths1)+1));
                
            }
            totalMaint  =  0.1364 * StretchLicenseFee/12 * StretchDurationInMonths1 ; 
        }
        else {
            if(StretchDurationInYears <> 0){
                StretchLicenseFee  = (10 *  totStretch) /  (10 + 2 * StretchDurationInYears);      
            }
            totalMaint  =  0.2 * StretchLicenseFee * StretchDurationInYears ;
            
        }           
        
        Decimal FirstYearMaint1 = 0;
        if(StretchDurationInYears <> 0)
            FirstYearMaint1 = totalMaint/ StretchDurationInYears;
        
        if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription')
        {
            
            oli.Stretch_License_Fee__c=0; //US461584 -- merha02
            oli.Stretch_Total_Maintenance__c= 0;            
        }
        else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
        {
            oli.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
            oli.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
        }
           //SAMTU01 US387241 end
      	//samap01 -revrec -US370554
       	oli =  LicenseClassificationMapper.LicenseClassifcationset(oli,prdclass.strbu,prdclass.strlicenseclassification); //samap01 -revrec-US370554
        prdclass.strlicenseclassification =LicenseClassificationMapper.licclassification;
      	//samap01 -revrec -US370554
        prdclass.oppli = oli;
        lst_prd[pos] = prdclass;
        //return null;
    }
    
    
    public OppLineItemcontroller(ApexPages.Standardcontroller stdcontroller)
    {
      
        Schema.DescribeFieldResult bustypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
        Schema.PicklistEntry[] entries_temp = bustypevalues.getPicklistValues();
        for(Schema.PicklistEntry entry : entries_temp)
            entries.add(new pickval(entry.getLabel(),entry.getValue()));
        haserror = false;
        
        //samap01 -- fixing the soql 101 error -US492574
         List<UserRole> lstUserRole = [Select Name from UserRole where id =: userinfo.getuserRoleid( )];
        If(lstUserRole.size()>0){
            For(userRole usrdata : lstUserRole){
                UserRoleName = usrdata.Name;
            }
        }
        //samap01 -5/2/2018 -US492574
        
        List<Products_for_On_Demand__c> lst_Ondemand = Products_for_On_Demand__c.getall().values();
        set_ondemand = new Set<string>{};
            
            
            for(Products_for_On_Demand__c   pod:lst_Ondemand)
            set_ondemand.add(pod.product__c.toLowerCase());
        
        
        
        //get the type , whether Product or Renewal
        strProductType = ApexPages.currentPage().getParameters().get('producttype');
        //get the opportunity id
        strOppId = ApexPages.currentPage().getParameters().get('oppid');
        //fetch other line item details for the opportunity
        lstoppoli = [select Id,Total_Maintenance__c, License__c, OpportunityId,Business_Type__c,Stretch__c , Original_Expiration_Date__c, 
                     Original_Expiration_Quarter__c, Original_Expiration_Year__c, Term_Month__c,X1st_Year_Maintenance__c,
                     Stretch_Corporate_ARR__c,Corporate_ARR__c,UF_License_Fee__c,Quote_Number__c, Business_Partner_ID__c, Contract_Number__c,Renewal_Quota_CV__c,Offerings_Family__c,
                     Original_CV__c,Original_Contract_IDs__c,New_Deal_Term_Months__c,Original_Deal_Term_Months__c,
                     UnitPrice,PricebookEntry.Product2Id,PricebookEntry.Product2.Upfront_Revenue_Eligible__c, On_Demand__c ,Partner_Sales_Price__c,
                     Partner_Term__c,Partner_Added__c,Override_Fees__c,Start_Date__c,End_Date__c,  Duration_Days__c,Stretch_Duration__c, //samap01-revrec US377325
                     License_Classification__c,Platform_Category__c,Business_Unit__c,License_Classification_Override__c, //samap01 -US370554
                     Commissionable_BU__c,Stretch_Total_Maintenance__c,Stretch_License_Fee__c //SAMTU01
                     from OpportunityLineItem 
                     where OpportunityId=:strOppId
                     and Business_Type__c != 'Renewal' 
                     order by createddate asc];
        
        this.lineitemrecord = (OpportunityLineItem)stdController.getRecord(); 
        //fetch Opportunity details for appending to the line item.
        opp = [select Name, RecordTypeId, Recordtype.name, Pricebook2Id,CurrencyISOCode,Rpt_Country__c,
               CloseDate,StageName,Probability,ForecastCategory,Start_Date__c,End_Date__c,Product_Sales_Price_Stretch_Gap_Reason__c  from Opportunity where Id =: strOppId];
        strcurrencyisocode = opp.CurrencyIsoCode;
        opp_temp = opp; //samap01 revrec
        //strpricebookid = opp.Pricebook2Id;
        oppId = opp.Id;     // fy13
        oppName = opp.Name; // fy13
        
        //US266282 - BAJPI01 -  for New Products.
        monthsoppheader = Integer.valueof(ARRandDurationCalculation.monthsbetweendates(opp.start_date__c, opp.end_date__c));
        
        //US266282 - BAJPI01 -  for New Products.
        if(opp!=null){
            oppstartdate = opp.Start_Date__c;
            oppenddate = opp.End_Date__c;
        }
        
        
        fetchbusinesstype();
        lst_prd = new List<productclass>();
        //incase there are already any products/renewals added to the opportunity, show them on the page
        if(lstoppoli.size()>0)
        {
            Set<ID> prdids = new Set<ID>();
            for(Integer i=0;i<lstoppoli.size();i++)
            {
                prdids.add(lstoppoli[i].PricebookEntry.Product2Id);
            }
            if(prdids.size()>0)
            {
                // do not fetch if 'Offerings'
                prdmap = new Map<Id,Product2>([select Id,Family,Upfront_Revenue_Eligible__c,Market_Focus_Area__c, name from Product2 where Salesforce_CPQ_Product__c=false and Id in:prdids and Family in ('Product','Time','Mainframe Capacity','Renewal')  and Market_Focus_Area__c != null   order by name ]);
                if(prdmap != null)
                {
                    Integer renitemcount = 0;
                    Integer prditemcount = 0;
                    for(Integer k=0;k<lstoppoli.size();k++)
                    {
                        //samap01 -- RevRec - US377325 -start
                        System.debug(' samap01 lstoppoli[k].Stretch_Duration__c' +lstoppoli[k].Stretch_Duration__c);
                        IF( lstoppoli[k].Stretch_Duration__c == NULL ||  lstoppoli[k].Stretch_Duration__c == 0 )
                            lstoppoli[k].Stretch_Duration__c =  lstoppoli[k].Term_Month__c;      
                        //SAMAP01 -End
                        
                        //US266282 - BAJPI01 -  for New Products. - if start & end date on line item is null, copy the opp header start/end dates.
                        if(lstoppoli[k].Start_Date__c==null && lstoppoli[k].End_Date__c==null){
                            if(opp.Start_Date__c!=null && opp.End_Date__c!=null){
                                lstoppoli[k].Duration_Days__c = opp.Start_Date__c.daysBetween(opp.End_Date__c)+1;
                               
                                lstoppoli[k].Term_Month__c = ARRandDurationCalculation.monthsbetweendates(opp.Start_Date__c, opp.End_Date__c);
                                if(lstoppoli[k].Business_Type__c=='Renewal'||lstoppoli[k].Business_Type__c=='MF Capacity'){
                                    lstoppoli[k].New_Deal_Term_Months__c = lstoppoli[k].Term_Month__c;
                                }
                            }
                        }
                        //US266282 - BAJPI01 -  for New Products. - if start & end date on line item is null, copy the opp header start/end dates.
                        
                        if(prdmap.containsKey(lstoppoli[k].PricebookEntry.Product2Id))
                        {
                            if(strProductType == 'Product')
                            {
                                Product2 p = prdmap.get(lstoppoli[k].PricebookEntry.Product2Id);
                                if(p.Family == 'Product')
                                {
                                    productclass prd = new productclass();
                                    //OpportunityLineItem tempolineitem = new OpportunityLineItem();
                                    prd.oppli = lstoppoli[k];
                                    prd.position = prditemcount;
                                    
                                    prd.strbu = p.Market_Focus_Area__c; 
                                    prd.isOverrideFees = false;
                                    prd.strproduct = lstoppoli[k].PricebookEntry.Product2Id;
                                    prd.strbustype = lstoppoli[k].Business_Type__c;
                                    //samap01 -revrec
                                    prd.strlictype = lstoppoli[k].License__C;
                                    prd.strlicenseclassification =lstoppoli[k].License_Classification__C; //samap01 -revrec
                                                                    
                                    prd.on_demand = lstoppoli[k].On_Demand__c;
                                    prd.isBUDisabled = true;
                                    prd.isPrdDisabled = true;
                                    prd.isOverrideClicked = false;
                                    prd.dateErrorExists = false;
                                    
                                    //added by danva01 for FY13                                     
                                    if(p.Upfront_Revenue_Eligible__c == 'No')
                                    {
                                        prd.isUFLisenceDisabled=true;
                                        prd.is1YearMaintDisabled=true;
                                    }
                                    prd.show_ondemand =  set_ondemand.contains(p.name.toLowerCase());
                                    //For Cloud Platform
                                    prd.selprdcloudplatformuse = new List<SelectOption>();
                                    prd.selprdcloudplatformuse.add(new SelectOption('--Select--','--Select--'));
                                    for(pickval entry : cldplatformuse_entries)
                                        prd.selprdcloudplatformuse.add(new SelectOption(entry.getvalue(), entry.getlabel()));
                                    //prd.strcloudplatformuse  = lstoppoli[k].Cloud_Platform_Use__c;
                                    //End Cloud Platform
                                    if(prd.show_ondemand)
                                        showOnDemandHeader = true;
                                    lst_prd.add(prd);
                                    bu_value =  p.Market_Focus_Area__c;
                                    pos = prditemcount;
                                    prdfamily = p.Family;
                                    fetchproducts();
                                    prditemcount += 1;
                                }
                                
                            }                            
                            //break;
                        }
                    }  
                }   
            }
        }
        
        if(strProductType == 'Product')
        {
            isProduct = true;
            selbu = new List<SelectOption>();
            selbu.add(new SelectOption('--Select--','--Select--'));
            selbu = fetchBU(strProductType);
            
            //fetchproducts();
            if(lst_prd.size()<3)
            {
                Integer cnt = lst_prd.size();
                Integer linespadding = 3 - cnt;
                for(Integer i=0;i<linespadding;i++)
                {
                    productclass prd = new productclass();
                    OpportunityLineItem tempolineitem = new OpportunityLineItem();
                    
                    
                    //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
                    if(opp.start_Date__c!=null)
                        tempolineitem.start_date__c = opp.start_date__c;
                    if(opp.end_date__c!=null)
                        tempolineitem.end_date__c = opp.end_date__c;
                    tempolineitem.Term_Month__c = monthsoppheader;
                    //SAMAP01 -US377325 Stretch_Duration__c
                    IF( tempolineitem.Stretch_Duration__c == NULL ||  tempolineitem.Stretch_Duration__c == 0)
                        tempolineitem.Stretch_Duration__c = tempolineitem.Term_Month__c; 
                    if(tempolineitem.start_date__c!=null && tempolineitem.end_date__c!=null)
                        tempolineitem.Duration_Days__c = tempolineitem.start_date__c.daysBetween(tempolineitem.end_date__c)+1;
                    
                    //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
                    
                    
                    prd.oppli = tempolineitem;
                    prd.position = cnt+i;
                    prd.isBUDisabled = false;
                    prd.isPrdDisabled = false;
                    prd.dateErrorExists = false;
                    
                    //prd.isUFLisenceDisabled=false;
                    //prd.is1YearMaintDisabled=false;  //to find...
                    prd.selprdbustype = new List<SelectOption>();
                    prd.selprdbustype = selbustype;
                    prd.selprdcloudplatformuse = new List<SelectOption>();
                    prd.selprdcloudplatformuse.add(new SelectOption('--Select--','--Select--'));
                    for(pickval entry : cldplatformuse_entries)
                        prd.selprdcloudplatformuse.add(new SelectOption(entry.getvalue(), entry.getlabel()));
                    
                    lst_prd.add(prd);
                    
                }
            }
            else
            {
                productclass prd = new productclass();
                OpportunityLineItem tempolineitem = new OpportunityLineItem();
                //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
                if(opp.start_Date__c!=null)
                    tempolineitem.start_date__c = opp.start_date__c;
                if(opp.end_date__c!=null)
                    tempolineitem.end_date__c = opp.end_date__c;
                tempolineitem.Term_Month__c = monthsoppheader;
                //SAMAP01 -US377325 Stretch_Duration__c
                IF( tempolineitem.Stretch_Duration__c == NULL ||  tempolineitem.Stretch_Duration__c == 0)
                    tempolineitem.Stretch_Duration__c = tempolineitem.Term_Month__c; 
                if(tempolineitem.start_date__c!=null && tempolineitem.end_date__c!=null)
                    tempolineitem.Duration_Days__c = tempolineitem.start_date__c.daysBetween(tempolineitem.end_date__c)+1;
                
                //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
                prd.oppli = tempolineitem;
                prd.position = lst_prd.size();
                prd.isBUDisabled = false;
                prd.isPrdDisabled = false;
                prd.dateErrorExists = false;
                
                
                //prd.isUFLisenceDisabled=false;
                //prd.is1YearMaintDisabled=false;
                prd.position = lst_prd.size();
                prd.selprdcloudplatformuse = new List<SelectOption>();
                prd.selprdcloudplatformuse.add(new SelectOption('--Select--','--Select--'));
                for(pickval entry : cldplatformuse_entries)
                    prd.selprdcloudplatformuse.add(new SelectOption(entry.getvalue(), entry.getlabel()));
                prd.selprdbustype = new List<SelectOption>();
                prd.selprdbustype = selbustype;
                
                lst_prd.add(prd);
            }
        }
        
        try{
            //get pricebook details, required while saving the line item
            Pricebook2 pbe = new Pricebook2();
            pbe = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
            if(pbe!=null)
                strpricebookid = pbe.Id;
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        
        //samap01 - putting primary contact red validation
        hasprimarycontact = Renewal_OpportunityUtilityClass.Primarycontactexists(opp);
        if( !hasprimarycontact)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'No Primary Contact Exists. Please go to the Contact Role and select a primary contact');    
                    ApexPages.addMessage(myMsg);   
                    System.debug('samap01 myMsg'+myMsg);
           
        }
        //samap01
    }
    //wrapper class to store product data    
    public class productclass
    {
        public OpportunityLineItem oppli {get;set;}
        public String strbu {get;set;}
        public String strproduct {get;set;}
        public List<SelectOption> selproduct {get;set;}
        public List<SelectOption> selprdcloudplatformuse {get;set;}
        public Integer position {get;set;}
        public String strbustype {get;set;}
        public String strcloudplatformuse {get;set;}
        public boolean on_demand {get; set;}
        public boolean show_ondemand {get;set;}
        public Boolean isBUDisabled {get;set;}
        public Boolean isPrdDisabled {get;set;}
        public Boolean isOverrideFees {get;set;} 
        public Boolean isOverrideClicked {get;set;}          
        public Boolean isUFLisenceDisabled {get;set;}
        public Boolean is1YearMaintDisabled {get;set;}
        public List<SelectOption> selprdbustype {get;set;}
        public Boolean dateErrorExists {get;set;}
        
        public string lineItemCbuValue{get;set;}
        public String strlicenseclassification {get;set;} //samap01 -revrec 370554
        public String strlictype {get;set;} //samap01 -revrec-370554
    }
    
    
    public List<SelectOption> fetchBU(String family)
    {
        List<Product2> lstprd = new List<Product2>();
        //lstprd = [select Id,Name from Product2 where Family='Education' and isDeleted = false and isActive = true order by name];
        lstprd = [select Market_Focus_Area__c from Product2 where Salesforce_CPQ_Product__c=false and Family=: family and isActive = true  and Market_Focus_Area__c != null   order by Market_Focus_Area__c];
        
        List<SelectOption> selbu_temp = new List<SelectOption>();
        selbu_temp.add(new SelectOption('--Select--','--Select--'));
        Set<String> setcheckbu = new Set<String>();
        for(Product2 prd : lstprd){
            if(opp.RecordType.Name == 'New Opportunity')
            { 
                if(prd.Market_Focus_Area__c != 'ISBU' && prd.Market_Focus_Area__c != 'RMDM')
                {
                    if(!setcheckbu.contains(prd.Market_Focus_Area__c))
                    {
                        selbu_temp.add(new SelectOption(prd.Market_Focus_Area__c,prd.Market_Focus_Area__c));
                        setcheckbu.add(prd.Market_Focus_Area__c);
                    }
                }
                
            }
            else
            {
                if(!setcheckbu.contains(prd.Market_Focus_Area__c))
                {
                    selbu_temp.add(new SelectOption(prd.Market_Focus_Area__c,prd.Market_Focus_Area__c));
                    setcheckbu.add(prd.Market_Focus_Area__c);
                }
            }             
        }
        return selbu_temp;
    }
    //get family from product table related to Product and Renewals
    public void fetchfamily()
    {
        selfamily = new List<SelectOption>();
        selfamily.add(new SelectOption('--Select--','--Select--'));
        List<Product2> lstprd = new List<Product2>();
        //fetch product families...
        lstprd = [select Family from Product2 where Salesforce_CPQ_Product__c=false and Family in ('Renewal','Time','Mainframe Capacity') and isDeleted = false and isActive = true  and Market_Focus_Area__c != null   order by family];
        Set<String> setcheck = new Set<String>();
        for(Product2 prd : lstprd){
            if(!setcheck.contains(prd.Family)){
                selfamily.add(new SelectOption(prd.Family,prd.Family));
                setcheck.add(prd.Family);
            }
            
        }
        
    }
    
    public List<SelectOption> fetchbusinesstype()
    {
        selbustype = new List<SelectOption>();
        selbustype.add(new SelectOption('--Select--','--Select--'));
        
        
        for(pickval entry : entries)
        {
            //restrict Business Type to particular values for Renewals and Products
            if(strProductType == 'Renewal')
            {
                if(entry.getValue() == 'Renewal' || entry.getValue() == 'Medium Touch' || entry.getValue() == 'Indirect Medium Touch')
                    selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
            }
            else if(strProductType == 'Product')
            {
                if(entry.getValue() == 'New' || entry.getValue() == 'Time' || entry.getValue() == 'Maintenance')
                    selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                
                if(entry.getValue() == 'Capacity'  || entry.getValue() == 'Upgrade')
                {
                    if(!(bu_value!=null && bu_value.toLowerCase() == 'mainframe'))
                        selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }  
                if(lst_prd!=null)
                {  
                    productclass prdclass = lst_prd[pos];
                    prdclass.selprdbustype = new List<SelectOption>();
                    prdclass.selprdbustype = selbustype;
                }
            }
        }
        return selbustype;
    }
    
    public void getOnDemand()
    {
        
    }
    
    public String bu_value {get;set;}
    public Integer pos {get;set;}
    public String prdfamily {get;set;}
    public void fetchproducts()
    {
        
        
        
        //fetch products based on family and Business Unit
        List<SelectOption> selproducts = new List<SelectOption>();
        List<Product2> lstprd = new List<Product2>();
        
        //Addition by Sourabh
        List<Product_Role_Relationship__c> lstProdRole= new List<Product_Role_Relationship__c>();
        List<ID> ProdId = new List<ID>();
        String rolName = '';
        String UsrRoleName = '';
       /* samap01 -US492574
        List<UserRole> lstUserRole = [Select Name from UserRole where id =: userinfo.getuserRoleid( )];
        If(lstUserRole.size()>0){
            For(userRole usrdata : lstUserRole){
                rolName = usrdata.Name;
            }
        }
       
        lstProdRole =[Select Product_ID__c,Role_Name__c from Product_Role_Relationship__c where Role_Name__c =:rolName and Business_Unit__c =:bu_value]; US492574 */ 
          lstProdRole =[Select Product_ID__c,Role_Name__c from Product_Role_Relationship__c where Role_Name__c =:UserRoleName and Business_Unit__c =:bu_value]; 
        
        If(lstProdRole.size()>0){
            For(Product_Role_Relationship__c usrRoleId : lstProdRole){
                UsrRoleName=usrRoleId.Role_Name__c.toUpperCase();
                If(UsrRoleName == rolName.toUpperCase()) 
                    ProdID.add(usrRoleId.Product_ID__c);
            }
            
            // To check if the Role and Product Combination exists in Product Role Object 
            lstprd=[select Id,Name,Upfront_Revenue_Eligible__c  from Product2 where  Salesforce_CPQ_Product__c=false and Family=:prdfamily and Market_Focus_Area__c=:bu_value and Id IN:ProdID  and Market_Focus_Area__c != null   and isDeleted = false and isActive = true order by name]; 
        }
        else
            lstprd = [select Id,Name,Upfront_Revenue_Eligible__c from Product2 where Salesforce_CPQ_Product__c=false and Family=:prdfamily and Market_Focus_Area__c=:bu_value and isDeleted = false and isActive = true and Product_Visibility__c = false  and Market_Focus_Area__c != null   order by name];
        
        
        selproducts.add(new SelectOption('--Select--','--Select--'));
        Set<String> setcheck = new Set<String>();
        
        
        
        for(Product2 prd : lstprd){
            if(!setcheck.contains(prd.Id))
            {
                selproducts.add(new SelectOption(prd.Id,prd.Name));                                
                setcheck.add(prd.Id); 
                if(set_ondemand.contains(prd.Name.toLowerCase()))
                    set_ondemandIds.add(prd.Id);
            }
            
        }
        //incase request type is Product addition
        if(strProductType == 'Product')
        {
            productclass prdclass = lst_prd[pos];
            
            prdclass.selproduct = new List<SelectOption>();
            prdclass.selproduct = selproducts;                        
        }
        fetchbusinesstype();
        
    }
    //adds a blank row to product lineitem addition table
    public PageReference addmore_prds()
    {
        productclass prd = new productclass();
        OpportunityLineItem tempoli = new OpportunityLineItem();
        //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
        tempoli.start_date__c = opp.start_date__c;
        tempoli.end_date__c = opp.end_date__c;
        tempoli.Term_Month__c = monthsoppheader;
        IF( tempoli.Stretch_Duration__c == NULL ||  tempoli.Stretch_Duration__c == 0)
            tempoli.Stretch_Duration__c = tempoli.Term_Month__c;  //SAMAP01 -US377325 Stretch_Duration__c
        if(tempoli.start_date__c!=null && tempoli.end_date__c!=null)
            tempoli.Duration_Days__c = tempoli.start_date__c.daysBetween(tempoli.end_date__c)+1;
        
        //US266282 - BAJPI01 -  for New Products. - Default start/end date on line item to opp header start/end date
        
        prd.oppli = tempoli;
        prd.position = lst_prd.size();
        prd.selprdcloudplatformuse = new List<SelectOption>();
        prd.selprdcloudplatformuse.add(new SelectOption('--Select--','--Select--'));
        tempoli =  LicenseClassificationMapper.LicenseClassifcationset(tempoli,prd.strbu,prd.strlicenseclassification); //samap01 -revrec-US370554
        for(pickval entry : cldplatformuse_entries)
            prd.selprdcloudplatformuse.add(new SelectOption(entry.getvalue(), entry.getlabel()));
        lst_prd.add(prd);
        return null; 
    }
    
    public PageReference saveproducts()
    { 
        Date minstartdate;
        Date maxenddate;
        List<GroupMember> userInOppAdminGroup = [select Id from GroupMember 
                                                 where groupid = :label.Opportunity_Admin_Edit_For_Closed_Opps_Id AND UserOrGroupId = :UserInfo.getUserId()];
        system.debug('opp close date, days between ' +opp.CloseDate + System.Date.Today().daysbetween(opp.CloseDate));
        alrt= false ; //allha02
        boolean alertstretchduration = false; //samap01
        haserror = false;
        
        for(productclass prd:lst_prd){
            if(prd.dateErrorExists == true){
                haserror = true;
                break;
            }  
        }
        if(haserror){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            return null;
        }
        else if(userInOppAdminGroup.size() == 0 && opp.CloseDate.daysbetween(System.Date.Today())>=14){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
            return null;
        }else if(userInOppAdminGroup.size() != 0 && opp.CloseDate.daysbetween(System.Date.Today())>=14 && opp.StageName == label.Opp_Stage_Closed_Lost){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
            return null;
        }
        else{
            system.debug('entered else of save product');
            List<OpportunityLineItem> ins_lineitem = new list<OpportunityLineItem>();
            Set<String> prdid = new Set<String>();
            //for products
            for(Integer j=0;j<lst_prd.size();j++)
            {
                if(lst_prd[j].strproduct!='--Select--' && lst_prd[j].strproduct!=null)
                    prdid.add(lst_prd[j].strproduct);           
                
            }
            
            //get the pricebookentry ids
            List<PricebookEntry> pbe = new List<PricebookEntry>(); 
            pbe = [Select Id,Product2Id from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and Product2Id in: prdid and CurrencyISOCode =:strcurrencyisocode];
            
            for(Integer i=0;i<lst_prd.size();i++)
            {  
                
                //proceed to save only if the BU is selected
                if(lst_prd[i].strbu!='--Select--' && lst_prd[i].strbu!=null)
                {
                    system.debug('----term----'+lst_prd[i].oppli.Term_Month__c);
                    //If BU is selected, then all other line item details need to be completed.
                    if(lst_prd[i].strproduct!='--Select--' && lst_prd[i].strbustype!='--Select--' && lst_prd[i].oppli.License__c != null && lst_prd[i].oppli.UnitPrice != null && lst_prd[i].oppli.Term_Month__c != null && lst_prd[i].oppli.Term_Month__c!=0 && lst_prd[i].strcloudplatformuse != '--Select--')
                    {
                        OpportunityLineItem oli = new OpportunityLineItem();
                        oli = lst_prd[i].oppli;
                        //oli.on_demand__c = lst_prd[i].on_demand;
                        
                        //allha02 AR3576
                        if(lst_prd[i].oppli.Stretch__c== null || lst_prd[i].oppli.Stretch__c < lst_prd[i].oppli.UnitPrice ){  
                            
                            lst_prd[i].oppli.Stretch__c=lst_prd[i].oppli.UnitPrice;
                            alrt = true ;
                        }
                        
                        if(lst_prd[i].oppli.Stretch_Duration__c == null || lst_prd[i].oppli.Stretch_Duration__c < lst_prd[i].oppli.Term_Month__c ) 
                        {
                            lst_prd[i].oppli.Stretch_Duration__c = lst_prd[i].oppli.Term_Month__c; 
                            alertstretchduration = true ;
                        } 
                        
                        //oli.Probability__c = lineitemrecord.Probability__c; 
                        
                        //oli.Forecast_Category__c = lineitemrecord.Forecast_Category__c;
                        
                        
                        if(lst_prd[i].strbustype != '--Select--')
                            oli.Business_Type__c = lst_prd[i].strbustype;
                        if(lst_prd[i].oppli.Id!=null){
                            if(lst_prd[i].isOverrideClicked)
                                oli.override_fees__c = lst_prd[i].isOverrideFees; //Added for AR 3798 : SINjy02 :the Owner of the Opportunity s/b listed on the Opp team with Team Role = Owner
                            system.debug('assigned override fees'+lst_prd[i].isOverrideFees);
                        }
                        
                        //if(lst_prd[i].strbustype != '--Select--')
                        // oli.Cloud_Platform_Use__c = lst_prd[i].strcloudplatformuse;
                        
                        
                        
                        //below data to be added only for new lineitems
                        if(lst_prd[i].oppli.Id==null)
                        {
                            oli.OpportunityId = strOppId;
                            for(Integer prdcnt=0;prdcnt<pbe.size();prdcnt++)
                            {
                                if(lst_prd[i].strproduct == pbe[prdcnt].Product2ID)
                                {
                                    oli.PricebookEntryId = pbe[prdcnt].Id;
                                    break;
                                }
                            }
                        }
                        
                        //samap01- revrec -US370554
                        
                        system.debug('samap01   lst_prd[i].strbu'+  lst_prd[i].strbu);
                        system.debug('samap01  lst_prd[i].strlicenseclassification'+  lst_prd[i].strlicenseclassification);
                                                 
                        oli=  LicenseClassificationMapper.LicenseClassifcationset(oli,lst_prd[i].strbu,lst_prd[i].strlicenseclassification); //samap01 -revrec-US370554
                        
                          system.debug('samap01  override'+  oli.License_Classification_Override__c);
                        lst_prd[i].strlicenseclassification = LicenseClassificationMapper.licclassification;
                            //samap01-revrec end 
                     
                        
                        system.debug('----opp line item---'+oli);
                        ins_lineitem.add(oli);
                    }
                    else
                    {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Product Details.');
                        ApexPages.addMessage(msg);
                         calculateUFLicenseFee();//SAMTU01 US387241
                        return null;
                    }
                }
            }
            //allha02 AR3576
            if(alrt)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch is required and must be greater than or equal to Sales Price.  Stretch value adjusted.');
                ApexPages.addMessage(msg);
                calculateUFLicenseFee();//SAMTU01 US387241
                return null;
            }
            //samap01 -RevREC-US377325
            if(alertstretchduration)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch Duration is required and must be greater than or equal to Term Month.  Stretch Duration adjusted.');
                ApexPages.addMessage(msg);
                calculateUFLicenseFee();//SAMTU01 US387241
                return null;
            }
            //samap01 -US377325 -Revrec	                   		
	     		update opp_temp;		
            //samap01 -US377325 -Revrec
            if(ins_lineitem.size()>0)
            {
                // do an upsert
                try{
                    upsert ins_lineitem;
                    
                }catch(DMLException ex){
                    if(ex.getMessage().contains('field integrity exception'))
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Opportunity currency is not matching with Product Currency.'));              
                    else
                        ApexPages.addMessages(ex);      
                    
                    return null;
                }
                
                
                
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please add Product Details.');
                ApexPages.addMessage(msg);
                return null;
            }
            // the overview details for renewals should be updated to all existing renewal lineitems of that opportunity
            if(lstoppoli.size()>0)
            {
                Set<ID> prdids = new Set<ID>();
                List<OpportunityLineItem> lstoppoliupd = new List<OpportunityLineItem>();
                
                if(prdmap != null)
                {
                    for(Integer k=0;k<lstoppoli.size();k++)
                    {
                        if(prdmap.containsKey(lstoppoli[k].PricebookEntry.Product2Id))
                        {
                            Product2 p = prdmap.get(lstoppoli[k].PricebookEntry.Product2Id);
                            if(p.Family == 'Renewal' || p.Family == 'Time' || p.Family == 'Mainframe Capacity')
                            {
                                lstoppoli[k].New_Deal_Term_Months__c = lineitemrecord.New_Deal_Term_Months__c;
                                lstoppoli[k].Original_Contract_IDs__c = lineitemrecord.Original_Contract_IDs__c;
                                lstoppoli[k].Original_CV__c = lineitemrecord.Original_CV__c;
                                lstoppoli[k].Renewal_Quota_CV__c = lineitemrecord.Renewal_Quota_CV__c;
                                
                                // fy13                                lstoppoli[k].Comfort_Term__c = lineitemrecord.Comfort_Term__c;
                                // fy13                                lstoppoli[k].Renewal_Gap_Reason_Codes__c = lineitemrecord.Renewal_Gap_Reason_Codes__c;
                                
                                lstoppoli[k].Original_Deal_Term_Months__c = lineitemrecord.Original_Deal_Term_Months__c;
                                if(bustypeval != '--Select--')
                                    lstoppoli[k].Business_Type__c = bustypeval;
                                else
                                    lstoppoli[k].Business_Type__c = null;
                                
                                lstoppoliupd.add(lstoppoli[k]);
                            }
                            
                        }
                    }
                }
            }
            
            PageReference pref = new PageReference('/'+strOppId);
            pref.setRedirect(true);
            return pref;
        }
    }
    
    
    public pagereference recalculate()
    {
        Integer i = 0;
        for(productclass pc: lst_prd)
        {                      
            if(pc.strproduct != null)
            {
                Set<Id> smp= new Set<Id>();
                smp.add(pc.strproduct);               
                List<Product2> lstmap = new List<Product2>([select Id,Mainframe_or_Distributed__c, Family,Upfront_Revenue_Eligible__c,Market_Focus_Area__c,
                                                            Commissionable_BU__c, name from Product2 where Salesforce_CPQ_Product__c=false and Id =: smp and Family in ('Product','Time','Mainframe Capacity','Renewal') and Market_Focus_Area__c != null
                                                            order by name ]); 
                if(i == lineCounter)
                {
                    if(lstmap[0].Upfront_Revenue_Eligible__c == 'Yes')
                    {
                        OpportunityLineItem oli = pc.oppli;
                        //if(!(oli.License__c != null && oli.License__c != ''))  
                        oli.License__c = 'Upfront';
                    }
                    else if(lstmap[0].Mainframe_or_Distributed__c == 'SAAS')
                    {
                        OpportunityLineItem oli = pc.oppli;
                        //if(!(oli.License__c != null && oli.License__c != ''))                     
                        oli.License__c = 'SAAS';
                    }
                    else if(lstmap[0].Mainframe_or_Distributed__c == 'Mainframe')
                    {
                        OpportunityLineItem oli = pc.oppli;
                        //if(!(oli.License__c != null && oli.License__c != ''))                     
                        oli.License__c = 'Subscription';
                    }
                    else if(lstmap[0].Mainframe_or_Distributed__c == 'Distributed')
                    {
                        OpportunityLineItem oli = pc.oppli;
                        //if(!(oli.License__c != null && oli.License__c != ''))                     
                        oli.License__c = 'Ratable';
                    } 
                }              
                //SAMAP01-REVREC -US370554
                pc.oppli =  LicenseClassificationMapper.LicenseClassifcationset(pc.oppli,pc.strbu,pc.strlicenseclassification); //samap01 -revrec-US370554 
                  pc.strlicenseclassification = LicenseClassificationMapper.licclassification;
                System.debug('samap01 + pc.strlicenseclassification  ' + pc.strlicenseclassification );
                System.debug('samap01 + pc.oppli.Business_Type__c  ' + pc.oppli.Business_Type__c + '--' +pc.oppli.Business_Unit__c );
                
               
                //SAMAP01-REVREC -US370554 end
                
                if(lstmap[0].Upfront_Revenue_Eligible__c == 'No')
                {
                    pc.isUFLisenceDisabled = true;
                    pc.is1YearMaintDisabled= true;
                }
                else               
                {
                    pc.isUFLisenceDisabled = false;
                    pc.is1YearMaintDisabled= false;
                }
                                
            }                     
            if(pc.isPrdDisabled != true)
            {
                pc.show_ondemand = set_ondemandIds.contains(pc.strproduct);
                if(pc.show_ondemand != true)
                    pc.on_demand =false;
                if(pc.show_ondemand)
                    showOnDemandHeader = true;    
            }
            
            i++;   
        }
        return null;
    }
    
    public class pickval
    {
        string label;
        string name;
        
        public pickval(string lbl, string val)
        {
            label = lbl;
            name = val;
        }
        public string getLabel()
        {
            return label;
        }
        public string getValue()
        {
            return name;
        }
    }
    
    //US266282 - BAJPI01 -  for New Products - takes the position of the line item being updated/inserted
    //when start/end date is changed. Calculates term month,duration days for line item
    //if startdate>=end date, then throws an error and stores it in the wrapper.
    //also calculates uf license fee and Total_Maintenance, that is based on term month and unit price.
    public void getMonthsBetween() 
    {
        productclass prdclass = lst_prd[pos];
        OpportunityLineItem oli = prdclass.oppli;
        startdate = oli.start_Date__c;
        enddate = oli.End_Date__c;
        oldTermMonth = Integer.valueOf(oli.Term_Month__c);
        system.debug('prdclass.oppli>>'+oli);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            prdclass.dateErrorExists = true;
            lst_prd[pos] = prdclass;
        }
        else{
            prdclass.dateErrorExists = false;
            if(startdate!=null && enddate!=null){
                oli.Duration_Days__c = startdate.daysBetween(enddate)+1;
                oli.Term_Month__c = ARRandDurationCalculation.monthsbetweendates(startdate,enddate);
            }
            else{
                oli.Term_Month__c = 0;
                oli.Duration_Days__c = 0;
            }
            //SAMAP01 -US377325 Stretch_Duration__c
            IF( oli.Stretch_Duration__c == NULL ||  oli.Stretch_Duration__c == 0)
                oli.Stretch_Duration__c = oli.Term_Month__c;
            Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
            decimal n = 0.0;
            
            
            
            
            
            if(oli.Term_Month__c!=null && (oli.Term_Month__c!=oldTermMonth)){
                decimal totMaint;   
                
                Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0); 
                Decimal termInMonths =   (oli.Term_Month__c <> null? oli.Term_Month__c  : 0);
                
                Decimal UFLicenseFee = 0;
                if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){
                    if(termInMonths <> 0){
                        UFLicenseFee =  (totSalesPrice/((0.1364/12*termInMonths)+1));
                        
                    }
                    totMaint  =  0.1364 * UFLicenseFee/12 * termInMonths ; 
                }
                else {
                    if(termInYears <> 0){
                        UFLicenseFee  = (10 *  totSalesPrice ) /  (10 + 2 * termInYears);      
                    }
                    totMaint  =  0.2 * UFLicenseFee * termInYears ;
                    
                }           
                
                Decimal FirstYearMaint = 0;
                if(termInYears <> 0)
                    FirstYearMaint = totMaint / termInYears;
                
                if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription')
                {
                   
                    oli.UF_License_Fee__c =0; // US461384 -- merha02
                    oli.Total_Maintenance__c = 0;            
                }
                else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
                {
                    oli.UF_License_Fee__c = UFLicenseFee.setScale(2);
                    oli.Total_Maintenance__c = totMaint.setScale(2);            
                }
            }
            
            //SAMTU01 US387241 
            
            decimal totalMaint;   
            Decimal totStretch = (oli.Stretch__c<> null? oli.Stretch__c: 0);
            Decimal StretchDurationInYears =   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c/12 : 0); 
            Decimal StretchDurationInMonths1=   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c: 0);
            
            Decimal StretchLicenseFee = 0;
            if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){
                if(StretchDurationInMonths1 <> 0){
                    StretchLicenseFee =  (totStretch/((0.1364/12*StretchDurationInMonths1)+1));
                    
                }
                totalMaint  =  0.1364 * StretchLicenseFee/12 * StretchDurationInMonths1 ; 
            }
            else {
                if(StretchDurationInYears <> 0){
                    StretchLicenseFee  = (10 *  totStretch) /  (10 + 2 * StretchDurationInYears);      
                }
                totalMaint  =  0.2 * StretchLicenseFee * StretchDurationInYears ;
                
            }           
            
            Decimal FirstYearMaint1 = 0;
            if(StretchDurationInYears <> 0)
                FirstYearMaint1 = totalMaint/ StretchDurationInYears;
            
            if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription')
            {
               
                oli.Stretch_License_Fee__c=0; //US461584 -- merha02
                oli.Stretch_Total_Maintenance__c= 0;            
            }
            else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
            {
                oli.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
                oli.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
            }
            
            //SAMTU01 US387241 end   
            prdclass.oppli = oli;
            lst_prd[pos] = prdclass;
        }
    }
    
}