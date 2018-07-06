public class OppLineItemcontroller_PRM
{
    private String strProductType = '';
    
    public string pfamly{get;set;}
    private String strOppId = '';
    private Date oppstartdate;
    public List<OpportunityLineItem> lstoppoli {get;set;}
    private Map<Id,Product2> prdmap;
    private String strpricebookid = '';
    private String strcurrencyisocode = '';
    private Opportunity opp = new Opportunity();
    public OpportunityLineItem lineitemrecord {get;set;}
    public Integer lineCounter {get;set;}
    public Boolean isRenewal {get;set;}
    public Boolean isProduct {get;set;}
    public Boolean mfcap{get;set;}
    public List<productclass> lst_prd {get;set;}
    public List<SelectOption> selbu {get;set;}
    public List<renewalclass> lst_ren {get;set;}
    public List<SelectOption> selfamily {get;set;}
    public List<SelectOption> selbustype {get;set;}
    public List<SelectOption> selprdcloudplatformuse {get;set;}
    public String bustypeval {get;set;}
    public string productname{set;get;}
    public id productid{set;get;}
    Set<string> set_ondemand; 
    Set<string> set_ondemandIds  = new Set<String>(); 
    public boolean showOnDemandHeader {get;set;}
    public List<pickval> entries = new List<pickval>();
    public List<pickval> cldplatformuse_entries = new List<pickval>();
    public Id oppId {get;set;}        // fy13
    public String oppName {get;set;}  // fy13
    public Id dealProgramId{get;set;}
    public boolean mainSelect{set;get;}
    public Boolean IsBehalfOfPartner { get; set; } // Prm5-DR
    public Id PartnerAccId {get; set; }
    public Id PartnerContactId { get; set; }
    public list<productwrapper> searchResults{set;get;}    
    public list<productwrapper> selectedProducts{set;get;}  
    public string BackButtonHelpText{set;get;}
    public string dealRegRecordTypeId{set;get;}
    public string newOppRecordTypeID{set;get;}
    transient public Blob body;
    public string selectedBU{set;get;}
    public string selectedPG{set;get;}
    public boolean isPerOpp{set;get;}
    public boolean approvalStatus{set;get;}
    public boolean pendingStatus{set;get;}
    public boolean ShowSubmitForApprovalButton{set;get;}
    public boolean EnableReSubmit{set;get;}
    public boolean DealApprovedOnce{set;get;}
    public list<product2> oppstore{set;get;}
    public List<SelectOption> BUs{set;get;} 
    public List<SelectOption> PGs{set;get;} 
    
    public list<productwrapper> selectedFromSearchList{get;set;} 
    public Boolean disableTypeAhead{get;set;}
    public Boolean disableBU {get;set;}
    public boolean unSavedData {get;set;}
    
    public string dealprogramName{set;get;}
    public OpportunityLineItem oliSelectedForChangeYesNo{set;get;}
    public string theUserType{get;set;}
    public Date startdate {get;set;}  
    public Date enddate {get;set;}
    private Integer oldTermMonth;
    
    
    map<id,set<string>> productgroupvalue=new map<id,set<string>>();
    Map<String,Decimal> isoCodeToConversionRate=new Map<String,Decimal>();
    list<Deal_Registration_Program__c> dealPrograms =new list<Deal_Registration_Program__c>();
    public Boolean minMaxError=false;
    //private Set<String> StatusList = new Set<String>();
    private String headerProg;
    private Integer maxRank=0;
    private decimal salesprice;
    private map<String,Deal_Registration_Program__c> progRankMap=new map<String,Deal_Registration_Program__c>();
    private string maxPrgNumber;
    
    //US480649  - Deal Registration portion should not run any approval when source is Lead
    public boolean SourceLead {get;set;}
    //US480649
    
    //yedra01
    public boolean isPartner;
    public User currentUser;
    public boolean rejectedbyca{set;get;}
    
    //samtu01- revrec  US417414
    
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
    //samtu01- revrec  US417414-end
    public OppLineItemcontroller_PRM(ApexPages.Standardcontroller stdcontroller)
    {
        
        disableSearch = true;
        disableTypeAhead = false;
        disableBU = false;
        clearFlag = false;
        deleteFlag = false;
        unSavedData = false;
        SearchBUFlag = false;
        SearchPGFlag = false;
        mfcap= false;
        SearchTypeAheadFlag = false;
        lstoppoli = new List<OpportunityLineItem>();
        theUserType = UserInfo.getUserType();
        system.debug('theUserType============'+theUserType);
        
        //US480649  - Deal Registration portion should not run any approval when source is Lead
        
        String strSourceLead = Apexpages.currentPage().getParameters().get('source');
        if(strSourceLead != null && strSourceLead == 'Lead'){
            SourceLead = true;
        }
        else{
            SourceLead = false;
        }
        //US480649
        
        //ApexPages.currentPage().getParameters().put('UnsavedData','No');    
        //opp= new Opportunity();
        Schema.DescribeFieldResult bustypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
        Schema.PicklistEntry[] entries_temp = bustypevalues.getPicklistValues();
        for(Schema.PicklistEntry entry : entries_temp)
            entries.add(new pickval(entry.getLabel(),entry.getValue()));
        searchResults=new list<productwrapper>();
        selectedProducts=new list<productwrapper>();
        selectedFromSearchList = new list<productwrapper>();
        PGs=new list<SelectOption>();
        isPartner=false;
        productid=null;
        notsaved=false;
        oppstore=new list<product2>();
        List<Products_for_On_Demand__c> lst_Ondemand = Products_for_On_Demand__c.getall().values();
        set_ondemand = new Set<string>{};
            currentUser = [Select UserType, IsPortalEnabled, AccountId From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        if(currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled)
            isPartner = true;
        
        for(Products_for_On_Demand__c   pod:lst_Ondemand)
            set_ondemand.add(pod.product__c.toLowerCase());
        
        notsaved = false;    
        
        string urlSaveNew = Apexpages.currentPage().getParameters().get('save_new');     
        if (urlSaveNew != null && urlSaveNew == '1')        
        {       
            BackButtonHelpText = Label.DealRegBackToPreviousPageHelpText;       
        }       
        else        
        {       
            BackButtonHelpText = Label.DealRegBacktoOpportunityHelpText;        
        }
        
        //get the type , whether Product or Renewal
        strProductType = ApexPages.currentPage().getParameters().get('producttype');
        //get the opportunity id
        strOppId = ApexPages.currentPage().getParameters().get('oppid');
        integer prdCount = 0;
        //fetch other line item details for the opportunity
        for(OpportunityLineItem oli:[select Id,Added_Before_Approval__c,Total_Maintenance__c,Business_Unit__c, License__c, OpportunityId,Business_Type__c,Stretch__c , Original_Expiration_Date__c, 
                                     Original_Expiration_Quarter__c,Deal_Program_ID__c,Deal_Program_Eligibility_Status__c, Original_Expiration_Year__c, Term_Month__c,X1st_Year_Maintenance__c,
                                     Corporate_ARR__c,Stretch_Corporate_ARR__c,UF_License_Fee__c,Quote_Number__c, Business_Partner_ID__c, Contract_Number__c,Renewal_Quota_CV__c,
                                     Original_CV__c,Original_Contract_IDs__c,Original_Deal_Term_Months__c,Start_Date__c,End_Date__c,Duration_Days__c,Stretch_Duration__c,Stretch_License_Fee__c,Stretch_Total_Maintenance__c, //SAMTU01 US406520 
                                     UnitPrice,PricebookEntry.Product2Id,PricebookEntry.Product2.Product_Group__c,PricebookEntry.Product2.Name,PricebookEntry.Product2.Upfront_Revenue_Eligible__c, On_Demand__c ,Partner_Sales_Price__c,
                                     Partner_Term__c,Deal_Registration__c,Deal_Program_Name__c,RejectedByCA__c ,Partner_Added__c,override_fees__c, License_Classification__c,License_Classification_Override__c, //SAMTU01 - US417414
                                     Commissionable_BU__c
                                     from OpportunityLineItem 
                                     where OpportunityId=:strOppId
                                     and Business_Type__c != 'Renewal' 
                                     order by createddate asc])
        {
            if(oli.RejectedByCA__c==true){
                rejectedbyca=true;
            }
            productwrapper pw=new productwrapper();
            pw.greyout=true;
            pw.businessUnit = oli.Business_Unit__c;
            pw.businessType = oli.Business_Type__c;
            pw.position = prdCount;
            pw.productName=oli.PricebookEntry.Product2.Name;   
            pw.productid= oli.PricebookEntry.Product2id; 
            pw.strlicenseclassification =oli.License_Classification__C; //samtu01 -revrec US417414
            pw.oppline=oli;
            selectedProducts.add(pw);
            system.debug('selectedProducts size-->' +selectedProducts.size());
            lstoppoli.add(oli);
            system.debug('lstoppoli size-->' +lstoppoli.size());
            prdCount += 1;
            
        }
        
        system.debug('selectedProducts>'+selectedProducts);
        this.lineitemrecord = (OpportunityLineItem)stdController.getRecord(); 
        //fetch Opportunity details for appending to the line item.
        if(strOppId!=null){
            opp = [select Name,Rpt_Country__c,type,isPEROpp__c,End_User_Contact__c,Deal_Registration_Status__c,Resubmission__c,ResubmissionProducts__c,Deal_Approval_status__c,Distributor_6__c,Deal_Program__c,Deal_Registration_Program__r.Expiry_Days__c,Deal_Registration_Program__r.Finance_Approver_Email__c,Deal_Registration_Submitted_Date__c, RecordTypeId, Recordtype.name, Pricebook2Id,CurrencyISOCode,Registering_on_behalf_of_Partner__c, Reseller_Contact__c ,AccountId,CloseDate,StageName,Probability,ForecastCategory,Reseller__c,Partner_Sales_Price__c, Deal_Registration_Program__c,Deal_Registration_Program__r.Ranking__c,Deal_Registration_Program__r.Name,Deal_Registration_Program__r.Min_Deal_Value__c,Deal_Registration_Program__r.Max_Deal_Value__c,reseller__r.geo__c,isClosedDateFireDealReg__c,Account.Enterprise_ID__c,Start_Date__c,End_Date__c,Deal_Reg_Initially_Approved__c,DR_Added_Eligible_Products__c from Opportunity where Id =: strOppId];
        }
        System.debug('========opp======='+opp);
        if(opp.isPEROpp__c) isPerOpp = true;
        else isPerOpp = false;
        
        approvalStatus = (opp.Deal_Registration_Status__c == 'Sale Approved');
        
        pendingStatus = (opp.Deal_Registration_Status__c == 'Deal Submitted to CA' || opp.Deal_Registration_Status__c == 'Deal Awaiting Approval' || opp.Deal_Registration_Status__c == 'Deal Awaiting Finance Approval' || opp.Deal_Registration_Status__c == 'Finance Approved');
        
        DealApprovedOnce = opp.Deal_Reg_Initially_Approved__c;
        
        boolean InitialRejectionStatus = (opp.Deal_Registration_Status__c == 'Deal Rejected' && opp.deal_approval_status__c == 'Deal Rejected' && !DealApprovedOnce);
        
        //US480649  - Deal Registration portion should not run any approval when source is Lead
        ShowSubmitForApprovalButton = !(pendingStatus || InitialRejectionStatus || SourceLead);
        //US480649
        
        if (DealApprovedOnce)
        {
            dealRegRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId();
            newOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        }
        
        oppstartdate = opp.CloseDate;
        
        strcurrencyisocode = opp.CurrencyIsoCode;
        oppId = opp.Id;     // fy13
        oppName = opp.Name; // fy13
        dealProgramId = opp.Deal_Registration_Program__c; // PRM release 4
        dealprogramName = opp.Deal_Registration_Program__r.Name;//Deal Simplification
        IsBehalfOfPartner = opp.Registering_on_behalf_of_Partner__c; // Prm5-DR
        if(opp.Type == 'xSP'){
            PartnerAccId = opp.AccountId;
            PartnerContactId = opp.End_User_Contact__c;
        }else{
            PartnerAccId = opp.Reseller__c;
            PartnerContactId = opp.Reseller_Contact__c;
        }
        
        //sunji03 - this is not needed, get record type by calling method in remote controller real time. 
        //ApexPages.currentPage().getParameters().put('recType',opp.Recordtype.name); //***
        //System.debug('*** recType :' + ApexPages.currentPage().getParameters().get('recType'));
        
        fetchbusinesstype();
        lst_prd = new List<productclass>();
        lst_ren = new List<renewalclass>();
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
                prdmap = new Map<Id,Product2>([select Id,Family,Upfront_Revenue_Eligible__c,Market_Focus_Area__c, name from Product2 where Id in:prdids and Salesforce_CPQ_Product__c=false and Family in ('Product','Time','Mainframe Capacity','Renewal') and  Market_Focus_Area__c != null order by name ]);
                if(prdmap != null)
                {
                    Integer renitemcount = 0;
                    Integer prditemcount = 0;
                    for(Integer k=0;k<lstoppoli.size();k++)
                    {
                        if(prdmap.containsKey(lstoppoli[k].PricebookEntry.Product2Id))
                        {
                            if(strProductType == 'Product')
                            {
                                Product2 p = prdmap.get(lstoppoli[k].PricebookEntry.Product2Id);
                                if(p.Family == 'Product' || p.Family == 'Mainframe Capacity')
                                {
                                    productclass prd = new productclass();
                                    prd.oppli = lstoppoli[k];
                                    prd.position = prditemcount;
                                    
                                    prd.strbu = p.Market_Focus_Area__c; 
                                    
                                    prd.strproduct = lstoppoli[k].PricebookEntry.Product2Id;
                                    prd.strbustype = lstoppoli[k].Business_Type__c;
                                    prd.on_demand = lstoppoli[k].On_Demand__c;
                                    prd.isBUDisabled = true;
                                    prd.isPrdDisabled = true;
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
                        }
                    }  
                }   
            }
        }
        
        system.debug('-----prdfamily---------------'+prdfamily);
        if(strProductType == 'Product')
        {
            getPrdctGrpPrgrmRelation();
            isProduct = true;
            isRenewal = false;
            selbu = new List<SelectOption>();
            selbu.add(new SelectOption('--Select--','--Select--'));
            selbu = fetchBU(strProductType);
            BUs=fetchBUproduct();
            if(lst_prd.size()<3)
            {
                Integer cnt = lst_prd.size();
                Integer linespadding = 3 - cnt;
                for(Integer i=0;i<linespadding;i++)
                {
                    productclass prd = new productclass();
                    OpportunityLineItem tempolineitem = new OpportunityLineItem();
                    
                    prd.oppli = tempolineitem;
                    prd.position = cnt+i;
                    prd.isBUDisabled = false;
                    prd.isPrdDisabled = false;
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
                
                prd.oppli = tempolineitem;
                prd.position = lst_prd.size();
                prd.isBUDisabled = false;
                prd.isPrdDisabled = false;
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
    }
    
    public PageReference calculateUFLicenseFeeN()
    {                      system.debug('pos>'+pos);
     productwrapper prdclass = selectedProducts[pos];
     system.debug('prdclass>'+prdclass);
     OpportunityLineItem oli = prdclass.oppline;
     decimal totMaint;   
     Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
     Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0);     
     Decimal termInMonths =   (oli.Term_Month__c <> null? oli.Term_Month__c  : 0);
     Decimal UFLicenseFee = 0;
     if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){ //Added for AR 3798 : SINjy02 :License Fee and Total Maintenance fee Ability to edit/overwrite Korea calculated @ 12% maintenance
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
     //SAMTU01 US406520 
     
     IF( oli.Stretch_Duration__c == NULL ||  oli.Stretch_Duration__c == 0 || oli.Stretch_Duration__c < oli.Term_Month__c )
     {
         oli.Stretch_Duration__c = oli.Term_Month__c;
         //commented by samap01 nov 9-no message to be shown if partner
         if(!isPartner)
         {
             ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch Duration must be greater than or equal to Term Month.  Stretch Duration adjusted.');
             ApexPages.addMessage(msg); 
         }
         
     }
     
     
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
         
         oli.Stretch_License_Fee__c=0; // US461584 -- merha02
         oli.Stretch_Total_Maintenance__c= 0;            
     }
     else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
     {
         oli.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
         oli.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
     }
     //SAMTU01 US406520 END
     oli.override_fees__c = false;
     system.debug('oli changes '+oli.UF_License_Fee__c+' Total Fee'+oli.Total_Maintenance__c);
     prdclass.oppline = oli;
     system.debug('Prod After>'+prdclass.oppline);
     selectedProducts[pos] = prdclass;
     
     system.debug('selectedProducts[pos] '+selectedProducts[pos] );
     system.debug('selectedProducts'+selectedProducts);
     try{
         upsert oli;
     }
     catch(exception e){
         system.debug('Exception occured '+e);
     }
     
     return null;
    }
    
    public OpportunityLineItem calculateUFLicenseFee(OpportunityLineItem oli)
    {
        decimal totMaint;  
        mainSelect=false; 
        Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
        Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0);     
        Decimal termInMonths =   (oli.Term_Month__c <> null? oli.Term_Month__c  : 0);
        Decimal UFLicenseFee = 0;
        if(opp.Rpt_Country__c !=null&&opp.Rpt_Country__c==Label.Korea_Country_Name){ //Added for AR 3798 : SINjy02 :License Fee and Total Maintenance fee Ability to edit/overwrite Korea calculated @ 12% maintenance
            if(termInMonths <> 0){
                UFLicenseFee =  (totSalesPrice/((0.1364/12*termInMonths)+1));
                
            }
            totMaint  =  0.1364 * UFLicenseFee/12 * termInMonths ; 
        }
        else {
            if(termInYears <> 0)
                UFLicenseFee  = (10 *  totSalesPrice ) /  (10 + 2 * termInYears);      
            
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
        //SAMTU01 US406520 
        
        IF( oli.Stretch_Duration__c == NULL ||  oli.Stretch_Duration__c == 0)
        {
            oli.Stretch_Duration__c = oli.Term_Month__c;
        }
        if(oli.Stretch_Duration__c< oli.Term_Month__c){
            oli.Stretch_Duration__c = oli.Term_Month__c;
            //commented by samap01 nov 9-no message to be shown if partner
            if(!isPartner)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch Duration must be greater than or equal to Term Month.  Stretch Duration adjusted.');
                ApexPages.addMessage(msg); 
            }
            
        }
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
            
            oli.Stretch_License_Fee__c=0; // US461584 -- merha02
            oli.Stretch_Total_Maintenance__c= 0;            
        }
        else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
        {
            oli.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
            oli.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
        }
        
        return oli;
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
        public String strlicenseclassification {get;set;} //samtu01 -revrec US417414
        
        
        public Boolean isUFLisenceDisabled {get;set;}
        public Boolean is1YearMaintDisabled {get;set;}
        
        public List<SelectOption> selprdbustype {get;set;}
        
    }
    //wrapper class to store renewal data
    public class renewalclass
    {
        public OpportunityLineItem oppli {get;set;}
        public String strfamily {get;set;}
        public List<SelectOption> selrenbu {get;set;}
        public String strbu {get;set;}
        public String strproduct {get;set;}
        public List<SelectOption> selproduct {get;set;}
        public Integer position {get;set;}
        
        //public String strbustype {get;set;}
        public Boolean isFamilyDisabled {get;set;}
        public Boolean isBUDisabled {get;set;}
        public Boolean isPrdDisabled {get;set;}
    }
    
    
    public String renfamily {get;set;}
    public Integer renpos {get;set;}
    public void fetchrenewalbu()
    {
        
        
        renewalclass renclass = lst_ren[renpos];
        renclass.selrenbu = new List<SelectOption>();
        
        renclass.selrenbu = fetchBU(renfamily);
        
    }
    
    public List<SelectOption> fetchBU(String family)
    {
        List<Product2> lstprd = new List<Product2>();
        // Boolean isPartner = false;
        
        Set<string> buSet = new Set<string>();
        Set<string> buSetTemp = new Set<string>();
        // Prod Alighnment
        /*  User currentUser = [Select UserType, IsPortalEnabled, AccountId From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
if(currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled)
isPartner = true;*/
        
        Id tempaccId;
        if(isPartner) {
            //PRM5 - DR
            if(IsBehalfOfPartner && PartnerAccId <> null)
                tempaccId = PartnerAccId;
            else
                tempaccId = currentUser.AccountId;
            
            List<Product_Alignment__c> prodAlignList = [Select Business_Unit__c from Product_Alignment__c where Related_Account__c = :tempaccId and Authorized_Agreement__c = true];
            for(Product_Alignment__c tempProdAlign : prodAlignList) {
                buSetTemp.add(tempProdAlign.Business_Unit__c);
            }
            
            System.debug('csu tmep->'+buSetTemp);
            //Deal Program if the rec type = Deal reg   
            if(opp.RecordType.Name == 'Deal Registration') {
                List<Deal_Program_Product_Group__c> dealPrgPrdGrpList = [Select BU__c from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :dealProgramId];
                System.debug('dealPrgPrdGrpList->'+dealPrgPrdGrpList);
                if(dealPrgPrdGrpList.size() > 0) {
                    for(Deal_Program_Product_Group__c tempDealPPG : dealPrgPrdGrpList) {
                        if(buSetTemp.contains(tempDealPPG.BU__c))
                            buSet.add(tempDealPPG.BU__c);
                    }
                } else {
                    buSet = buSetTemp;
                }
            } else {
                buSet = buSetTemp;
            }
        }   
        System.debug('bu ->'+buSet);
        lstprd = [select Market_Focus_Area__c from Product2 where Salesforce_CPQ_Product__c=false and Family=: family and isActive = true and Market_Focus_Area__c in: buSet and Market_Focus_Area__c != null order by Market_Focus_Area__c];
        
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
        lstprd = [select Family from Product2 where Family in ('Renewal','Time','Mainframe Capacity') and Salesforce_CPQ_Product__c=false and isDeleted = false and isActive = true order by family];
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
        pfamly=apexpages.currentpage().getparameters().get('familyvalue');
        system.debug('-----pfamly-----------------'+pfamly);
        system.debug('-----bustypeval-----------------'+bustypeval);
        
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
                if(lst_prd!=null&&lst_prd.size()>0&&pos!=null)
                {  
                    productclass prdclass = lst_prd[pos];
                    prdclass.selprdbustype = new List<SelectOption>();
                    prdclass.selprdbustype = selbustype;
                }
            }
        }
        return selbustype;
    }
    
    public String bu_value {get;set;}
    public Integer pos {get;set;}
    public String prdfamily {get;set;}
    public id tempreaccId ;
    
    Integer counter=0;  
    
    
    public void fetchproducts()
    {
        
        
        
        //fetch products based on family and Business Unit
        List<SelectOption> selproducts = new List<SelectOption>();
        List<Product2> lstprd = new List<Product2>();
        /*
opportunity opp = [select id,type ,RecordType.Name,AccountId from opportunity where id =: strOppId];
if(opp.type == '2tier' && opp.RecordType.Name == 'Deal Registration' && IsBehalfOfPartner && PartnerAccId <> null){
tempreaccId = PartnerAccId;
user usr = new user();
Usr = [SELECT  Id,Is_Partner_User__c,accountid FROM User WHERE user.accountid  = : tempreaccId ];         
if(usr.Is_Partner_User__c == true)
Set<String> productGroupSet = new Set<String>();                      
set<id> productGroupSetT = new set<id>();
List<Product_Alignment__c> prodAlignList = [Select Product_Group__c from Product_Alignment__c where Related_Account__c =: tempreaccId and Authorized_Agreement__c = true];
for(Product_Alignment__c tempProdAlign : prodAlignList) {
productGroupSetT.add(tempProdAlign.Product_Group__c);
}           
lstprd = [select Id,Name,Upfront_Revenue_Eligible__c from Product2 where Family=:prdfamily and  Market_Focus_Area__c=:bu_value and Product_Group__c IN :productGroupSetT and isDeleted = false  and Market_Focus_Area__c != null and isActive = true  and Product_Visibility__c = false order by name];            
}
else{ */
        //Addition by Sourabh
        List<Product_Role_Relationship__c> lstProdRole= new List<Product_Role_Relationship__c>();
        List<ID> ProdId = new List<ID>();
        String rolName = '';
        String UsrRoleName = '';
        
        //PRM5 - DR
        Id temuserid;
        if(IsBehalfOfPartner && PartnerContactId <> null)
        {
            try
            {
                User userid = [select UserRoleId from User where ContactId = : PartnerContactId and IsActive = true];
                temuserid = userid.UserRoleId;
            }
            catch(Exception ex){
                System.debug(ex.getMessage());
            }
        }              
        else
        {
            temuserid = userinfo.getuserRoleid( );
        }
        List<UserRole> lstUserRole = [Select Name from UserRole where id =: temuserid];
        If(lstUserRole.size()>0){
            For(userRole usrdata : lstUserRole){
                rolName = usrdata.Name;
            }
        }
        
        lstProdRole =[Select Product_ID__c,Role_Name__c from Product_Role_Relationship__c where Role_Name__c =:rolName and Business_Unit__c =:bu_value]; 
        
        System.debug('Role_Name__c -->' + rolName);
        System.debug('bu_value --> ' + bu_value);
        
        If(lstProdRole.size()>0){
            For(Product_Role_Relationship__c usrRoleId : lstProdRole){
                UsrRoleName=usrRoleId.Role_Name__c.toUpperCase();
                If(UsrRoleName == rolName.toUpperCase()) 
                    ProdID.add(usrRoleId.Product_ID__c);
            }
            
            // To check if the Role and Product Combination exists in Product Role Object 
            lstprd=[select Id,Name,Upfront_Revenue_Eligible__c  from Product2 where Salesforce_CPQ_Product__c=false and Family=:prdfamily and Market_Focus_Area__c=:bu_value  and Market_Focus_Area__c != null and Id IN:ProdID and isDeleted = false and isActive = true order by name]; 
        }
        else {
            Set<String> productGroupSet = new Set<String>();
            Set<String> productGroupSetTemp = new Set<String>();
            
            // User currentUser = [Select UserType, IsPortalEnabled, AccountId From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            
            //PRM5 - DR
            Id tempaccId;
            if(IsBehalfOfPartner && PartnerAccId <> null)
                tempaccId = PartnerAccId;
            else
                tempaccId = currentUser.AccountId;
            
            List<Product_Alignment__c> prodAlignList = [Select Product_Group__c from Product_Alignment__c where Related_Account__c =: tempaccId and Authorized_Agreement__c = true];
            for(Product_Alignment__c tempProdAlign : prodAlignList) {
                productGroupSetTemp.add(tempProdAlign.Product_Group__c);
            }
            
            if(opp.RecordType.Name == 'Deal Registration') {
                List<Deal_Program_Product_Group__c> dealPPGList = [Select Product_Group__c from Deal_Program_Product_Group__c where Deal_Registration_Program__c = :dealProgramId];
                if(dealPPGList.size() > 0) {
                    for(Deal_Program_Product_Group__c temp : dealPPGList) {
                        if(productGroupSetTemp.contains(temp.Product_Group__c))
                            productGroupSet.add(temp.Product_Group__c);
                    }
                } else {
                    productGroupSet = productGroupSetTemp;
                }
            } else {
                productGroupSet = productGroupSetTemp;
            }
            lstprd = [select Id,Name,Upfront_Revenue_Eligible__c,Mainframe_or_Distributed__c from Product2  where Salesforce_CPQ_Product__c=false and Family=:prdfamily and Market_Focus_Area__c=:bu_value and Product_Group__c IN :productGroupSet and isDeleted = false  and Market_Focus_Area__c != null and isActive = true  and Product_Visibility__c = false order by name];            
        }
        
        //} 
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
        else if(strProductType == 'Renewal')//incase request type is renewal addition
        {
            renewalclass renclass = lst_ren[pos];
            renclass.selproduct = new List<SelectOption>();
            renclass.selproduct = selproducts;
        }
        fetchbusinesstype();
        
    }
    
    //adds a blank row to product lineitem addition table
    public PageReference addmore_prds()
    {
        productclass prd = new productclass();
        OpportunityLineItem tempoli = new OpportunityLineItem(); 
        prd.oppli = tempoli;
        prd.position = lst_prd.size();
        prd.selprdcloudplatformuse = new List<SelectOption>();
        prd.selprdcloudplatformuse.add(new SelectOption('--Select--','--Select--'));
        for(pickval entry : cldplatformuse_entries)
            prd.selprdcloudplatformuse.add(new SelectOption(entry.getvalue(), entry.getlabel()));
        lst_prd.add(prd);
        return null; 
    }
    
    //adds a blank row to renewal lineitem addition table
    public PageReference addmore_ren()
    {
        renewalclass ren = new renewalclass();
        OpportunityLineItem tempoli = new OpportunityLineItem();
        ren.oppli = tempoli;
        ren.position = lst_ren.size();
        lst_ren.add(ren);
        return null; 
    }
    public PageReference saveproducts()
    {
        List<OpportunityLineItem> ins_lineitem = new list<OpportunityLineItem>();
        Set<String> prdid = new Set<String>();
        //for products
        decimal salesprice;
        salesprice = 0;
        for(Integer j=0;j<lst_prd.size();j++)
        {
            if(lst_prd[j].strproduct!='--Select--' && lst_prd[j].strproduct!=null)
            {
                prdid.add(lst_prd[j].strproduct);
                if(lst_prd[j].oppli.Partner_Sales_Price__c != null)   ///by Vasantha CR:300-200001
                    salesprice = salesprice + lst_prd[j].oppli.Partner_Sales_Price__c;                
            }
        }
        
        //for renewals
        for(Integer k=0;k<lst_ren.size();k++)
        {            
            if(lst_ren[k].strproduct!='--Select--' && lst_ren[k].strproduct!=null)
            {
                prdid.add(lst_ren[k].strproduct);                
            }
        }
        //get the pricebookentry ids
        List<PricebookEntry> pbe = new List<PricebookEntry>(); 
        Opportunity opp = [select Rpt_Country__c,Partner_Sales_Price__c,StageName,AccountId,isPEROpp__c,isClosedDateFireDealReg__c,start_date__c,end_date__c,closedate from Opportunity where Id =: strOppId];
        
        pbe = [Select Id,Product2Id from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and Product2Id in: prdid and CurrencyISOCode =:strcurrencyisocode];        
        
        for(Integer i=0;i<lst_prd.size();i++)
        {            
            //proceed to save only if the BU is selected
            if(lst_prd[i].strbu!='--Select--' && lst_prd[i].strbu!=null)
            {
                //If BU is selected, then all other line item details need to be completed.
                if(lst_prd[i].strproduct!='--Select--' && lst_prd[i].strbustype!='--Select--' && lst_prd[i].oppli.Partner_Sales_Price__c != null && lst_prd[i].oppli.Partner_Term__c != null && lst_prd[i].strcloudplatformuse != '--Select--')
                {
                    System.debug('adfdasfdasfadsf*********** -->');
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli = lst_prd[i].oppli;
                    
                    if(lst_prd[i].strbustype != '--Select--')
                        oli.Business_Type__c = lst_prd[i].strbustype;
                    
                    System.debug('stageName-->' + opp.StageName);
                    //SAMTU01 US417414
                    oli=  LicenseClassificationMapper.LicenseClassifcationset(oli,lst_prd[i].strbu,lst_prd[i].strlicenseclassification);
                    lst_prd[i].strlicenseclassification = LicenseClassificationMapper.licclassification;
                    //SAMTU01 US417414 end 
                    
                    if(opp.StageName == Label.Opp_Stage_10_Percent ||  opp.StageName == 'Deal Reg - New')
                    {
                        oli.UnitPrice =  oli.Partner_Sales_Price__c;   //defaulting the Unitprice with Partner Sales Price for the first time not whenever the lineitems are added....
                        oli.Term_Month__c = oli.Partner_Term__c;
                        oli.Stretch__c = oli.Partner_Sales_Price__c;
                        OpportunityLineItem oppli = new OpportunityLineItem();
                        oppli = calculateUFLicenseFee(oli);
                        oli.UF_License_Fee__c = oppli.UF_License_Fee__c;
                        oli.X1st_Year_Maintenance__c = oli.X1st_Year_Maintenance__c;
                        oli.Total_Maintenance__c = oppli.Total_Maintenance__c;
                        oli.Stretch_License_Fee__c = oppli.Stretch_License_Fee__c; //SAMTU01 - US406520 
                        oli.Stretch_Total_Maintenance__c = oppli.Stretch_Total_Maintenance__c; //SAMTU01 - US406520 
                        oli.Stretch_Duration__c = oppli.Stretch_Duration__c; //SAMTU01 - US406520 
                        //added by BAJPI01 as part of US311085/US311565
                        oli.Start_Date__c = oppstartdate;
                        oli.End_Date__c = oppstartdate.addMonths(Integer.valueOf(oli.Term_Month__c));
                        oli.End_Date__c = oli.End_Date__c.addDays(-1);
                        oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
                        
                        //added by BAJPI01 as part of US311085/US311565
                    }
                    oli.Partner_Added__c = true;
                    
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
                    ins_lineitem.add(oli);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Product Details.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        
        for(Integer j=0;j<lst_ren.size();j++)
        {
            //proceed to save only if the Family is selected
            if(lst_ren[j].strfamily!='--Select--' && lst_ren[j].strfamily!=null)
            {
                //If Family is selected, then all other line item details need to be completed.
                //BY AFZAL, Making Original Expiration Date non mandatory per CR:189363892 
                if(lst_ren[j].strbu !='--Select--' && lst_ren[j].strproduct !='--Select--' && lst_ren[j].oppli.Partner_Sales_Price__c != null)
                {
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli = lst_ren[j].oppli;
                    //save the overview details
                    oli.Term_Month__c  = lineitemrecord.Term_Month__c ;
                    
                    
                    oli.Original_Contract_IDs__c = lineitemrecord.Original_Contract_IDs__c;
                    oli.Original_CV__c = lineitemrecord.Original_CV__c;
                    oli.Renewal_Quota_CV__c = lineitemrecord.Renewal_Quota_CV__c;
                    oli.Original_Deal_Term_Months__c = lineitemrecord.Original_Deal_Term_Months__c;
                    oli.Quote_Number__c = lineitemrecord.Quote_Number__c;
                    oli.Business_Partner_ID__c = lineitemrecord.Business_Partner_ID__c;
                    oli.Contract_Number__c = lineitemrecord.Contract_Number__c;
                    //added by BAJPI01 as part of US311085/US311565
                    oli.Start_Date__c = oppstartdate;
                    oli.End_Date__c = oppstartdate.addMonths(Integer.valueOf(oli.Term_Month__c));
                    oli.End_Date__c = oli.End_Date__c.addDays(-1);
                    oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
                    
                    //added by BAJPI01 as part of US311085/US311565
                    
                    String fiscalperiod = '';
                    
                    if(bustypeval != '--Select--')
                        oli.Business_Type__c = bustypeval;
                    else
                    {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select the Business Type.');
                        ApexPages.addMessage(msg);
                        return null;
                    }   
                    //below data to be added only for new lineitems
                    if(lst_ren[j].oppli.Id==null)
                    { 
                        oli.OpportunityId = strOppId;
                        for(Integer prdcnt=0;prdcnt<pbe.size();prdcnt++)
                        {
                            if(lst_ren[j].strproduct == pbe[prdcnt].Product2ID)
                            {
                                oli.PricebookEntryId = pbe[prdcnt].Id;
                                break;
                            }
                        }
                    }
                    
                    ins_lineitem.add(oli);
                }
                else
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the Renewal Details.');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        }
        System.debug('asdfdas -->' + ins_lineitem.size());
        if(ins_lineitem.size()>0)
        {
            // do an upsert
            try{
                upsert ins_lineitem;                
                Opportunity oppr = [select Rpt_Country__c,isPEROpp__c,Partner_Sales_Price__c,AccountId,isClosedDateFireDealReg__c,start_date__c,end_date__c,closedate from Opportunity where Id =: strOppId];
                oppr.Partner_Sales_Price__c = salesprice;
                //added by BAJPI01 as part of US311085/US311565
                oppr.Start_Date__c = oppr.CloseDate;
                oppr.End_Date__c = ARRandDurationCalculation.populateEndDate(ins_lineitem,opp.CloseDate);
                //added by BAJPI01 as part of US311085/US311565
                system.debug('error' + oppr.Partner_Sales_Price__c);                                
                SystemIdUtility.skipOpportunityTriggers = true;
                update oppr;
                
            }catch(DMLException ex){
                if(ex.getMessage().contains('field integrity exception'))
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Opportunity currency is not matching with Product Currency.'));              
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,ex.getMessage()));                                
                }
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
                            lstoppoli[k].Term_Month__c  = lineitemrecord.Term_Month__c ;
                            lstoppoli[k].Original_Contract_IDs__c = lineitemrecord.Original_Contract_IDs__c;
                            lstoppoli[k].Original_CV__c = lineitemrecord.Original_CV__c;
                            lstoppoli[k].Renewal_Quota_CV__c = lineitemrecord.Renewal_Quota_CV__c;
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
    
    
    public pagereference recalculate()
    {
        Integer i = 0;
        for(productclass pc: lst_prd)
        {                      
            if(pc.strproduct != null)
            {
                Set<Id> smp= new Set<Id>();
                smp.add(pc.strproduct);               
                List<Product2> lstmap = new List<Product2>([select Id,Mainframe_or_Distributed__c, Family,Upfront_Revenue_Eligible__c,Market_Focus_Area__c, name from Product2 where Salesforce_CPQ_Product__c=false and Id =: smp and Family in ('Product','Time','Mainframe Capacity','Renewal')  and Market_Focus_Area__c != null order by name ]); 
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
    
    public String searchString {get; set;}
    public String selectedProduct1;
    public String selectedProduct {get; set;}
    public String selectedProduct (){return 'Enter Value';}
    
    public void setselectedProduct (String selectedProduct )
    {
        system.debug('##### selectedProduct -'+selectedProduct );
        this.selectedProduct1 = selectedProduct ;
    }   
    
    public String selectedproductName{get; set;}
    public String selectedItem{get; set;}
    public String testval{get; set;}
    public static Map<id,PRODUCT2> prodSearchMap = new Map<id,PRODUCT2>();
    public List<PRODUCT2> selectedList ;
    public static string test;
    
    //public List<PRODUCT2> selectedList{get; set;}
    
    
    //New Product Search changes
    
    
    public class productwrapper
    {
        public boolean Selected{set;get;}
        public String productName{set;get;}
        public Id productid{set;get;}
        public String businessUnit{set;get;}
        public String businessType{set;get;}
        public String salesPrice{set;get;}
        public String Term{set;get;}
        public boolean greyout{set;get;}
        public opportunitylineitem oppline{set;get;}
        public Product2 productObj {set;get;}
        public integer position {set;get;}
        public Boolean dateErrorExists {get;set;}
        public String strbu {get;set;}
        public String strlicenseclassification {get;set;} //samtu01 -revrec US417414
        public productwrapper()
        {
            Selected=false;
            oppline=new opportunitylineitem(); 
            productObj = new Product2 ();
        }
        
    }
    
    @RemoteAction
    public static List<PRODUCT2> findSearchResult( string ProductStr,string strOppId ) {
        
        String obj = 'Product';
        string obj2='Mainframe Capacity';
        User currentUser = [Select UserType, IsPortalEnabled, AccountId From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Opportunity opp = [select Name,Type, RecordTypeId,deal_registration_Status__c, Recordtype.name, Pricebook2Id,CurrencyISOCode,Registering_on_behalf_of_Partner__c, Reseller_Contact__c ,Deal_Registration_Program__r.Name,
                           CloseDate,StageName,Probability,ForecastCategory,Reseller__c,AccountId,isPEROpp__c, Deal_Registration_Program__c,Rpt_Country__c,isClosedDateFireDealReg__c from Opportunity where Id =: strOppId];        
        String soql = ''; 
        String ProRelatedAccount;
        if(opp.Type == 'xSP'){
            ProRelatedAccount = opp.AccountId;
        }else{
            ProRelatedAccount = opp.Reseller__c;
        }
        List<Product_Alignment__c> prodAlignList = [Select Product_Group__c, Business_Unit__c from Product_Alignment__c where Related_Account__c = :ProRelatedAccount and Authorized_Agreement__c = true];
        Set<string> buSetTemp = new Set<string>();
        Set<string> PGSetTemp = new Set<string>();
        
        for(Product_Alignment__c tempProdAlign : prodAlignList) {
            buSetTemp.add(tempProdAlign.Business_Unit__c);
            PGSetTemp.add(tempProdAlign.Product_Group__c);
        }
        soql = 'SELECT id, Name, Product_Group__c,Upfront_Revenue_Eligible__c,Mainframe_or_Distributed__c, Business_Group__c,Market_Focus_Area__c FROM PRODUCT2 WHERE Salesforce_CPQ_Product__c=false and Product_Visibility__c = false and isDeleted = false and (Family =: obj or Family =: obj2) AND Market_Focus_Area__c in: buSetTemp and Product_Group__c in :PGSetTemp and Market_Focus_Area__c != null and isActive = true AND';
        
        soql += '(Name' + ' LIKE \'%' + ProductStr + '%\'' + 'OR Market_Focus_Area__c ' + ' LIKE \'%' + ProductStr + '%\'' + 'OR Product_Group__c' + ' LIKE \'%' + ProductStr + '%\'' +')ORDER BY NAME';
        
        system.debug('##### QUERY :- '+ soql);
        
        List<PRODUCT2 >  searchList = new List<PRODUCT2 >();
        try {
            searchList = Database.query(soql);
            system.debug('##### searchList :- '+ searchList.size());
            for(PRODUCT2  p: searchList ){
                prodSearchMap.put(p.Id, p);
            }
            
            system.debug('####-'+prodSearchMap.size()) ;
            
        }
        catch (QueryException e) {
            system.debug('##### QueryException :- '+ e);
            return null;
        }
        
        return searchList;      
        
    }
    
    
    public List<SelectOption> fetchBUproduct()
    {
        List<Product2> lstprd = new List<Product2>();
        Set<string> buSet = new Set<string>();
        Set<string> buSetTemp = new Set<string>();
        List<SelectOption> selbu_temp = new List<SelectOption>();
        selbu_temp.add(new SelectOption('--Select--','--Select--'));
        Set<string> PGSetTemp = new Set<string>();
        
        List<Product_Alignment__c> prodAlignList = [Select Business_Unit__c,Product_Group__c from Product_Alignment__c where Related_Account__c = :PartnerAccId and Authorized_Agreement__c = true order by Name];
        
        for(Product_Alignment__c tempProdAlign : prodAlignList) {
            buSetTemp.add(tempProdAlign.Business_Unit__c);
            PGSetTemp.add(tempProdAlign.Product_Group__c);
        }
        
        Set<String> setcheckbu = new Set<String>();
        lstprd = [select Name,Market_Focus_Area__c,Mainframe_or_Distributed__c,Upfront_Revenue_Eligible__c from Product2 where Salesforce_CPQ_Product__c=false and Product_Visibility__c = false and isDeleted = false and isActive = true and (Family=:'Product' OR Family=:'Mainframe Capacity') and Market_Focus_Area__c in :buSetTemp and Product_Group__c in :PGSetTemp and Market_Focus_Area__c != null order by Market_Focus_Area__c];
        
        for(Product2 prd :lstprd ){
            if(opp.RecordType.Name == 'New Opportunity')
            { 
                if(prd.Market_Focus_Area__c != 'ISBU' && prd.Market_Focus_Area__c != 'RMDM')
                {
                    if(!setcheckbu.contains(prd.Market_Focus_Area__c ))
                    {
                        selbu_temp.add(new SelectOption(prd.Market_Focus_Area__c ,prd.Market_Focus_Area__c ));
                        setcheckbu.add(prd.Market_Focus_Area__c );
                        
                    }
                }
                
            }
            else
            {
                if(!setcheckbu.contains(prd.Market_Focus_Area__c ))
                {
                    selbu_temp.add(new SelectOption(prd.Market_Focus_Area__c ,prd.Market_Focus_Area__c ));
                    setcheckbu.add(prd.Market_Focus_Area__c );
                }
            }             
        }
        
        return selbu_temp;
    }
    
    
    public List<SelectOption> fetchPG()
    {
        list<product2> lstprd =new list<product2>();
        Set<string> buSetTemp = new Set<string>();
        Set<string> PGSetTemp = new Set<string>();
        
        List<Product_Alignment__c> prodAlignList = [Select Product_Group__c,Business_Unit__c from Product_Alignment__c where Related_Account__c = :PartnerAccId and Authorized_Agreement__c = true];
        
        for(Product_Alignment__c tempProdAlign : prodAlignList) {
            buSetTemp.add(tempProdAlign.Business_Unit__c);
            PGSetTemp.add(tempProdAlign.Product_Group__c);
        }
        lstprd = [select Name,Mainframe_or_Distributed__c,Upfront_Revenue_Eligible__c from Product2 where Salesforce_CPQ_Product__c=false and Product_Visibility__c = false and isDeleted = false and isActive = true and (Family=:'Product' OR Family=:'Mainframe Capacity')  and Market_Focus_Area__c =:selectedBU and Product_Group__c in :PGSetTemp and Market_Focus_Area__c != null and Market_Focus_Area__c in:buSetTemp order by Name];
        
        List<SelectOption> selbu_temp = new List<SelectOption>();
        selbu_temp.add(new SelectOption('--Select--','--Select--'));
        Set<String> setcheckbu = new Set<String>();
        for(Product2 prd : lstprd){
            
            
            if(!setcheckbu.contains(prd.Name))
            {
                selbu_temp.add(new SelectOption(prd.Id,prd.Name));
                setcheckbu.add(prd.Name);
            }
            
        }
        system.debug(selbu_temp);
        return selbu_temp;
    }
    
    public void Searchproducts()
    {
        String Query;
        Set<string> buSetTemp = new Set<string>();
        Set<string> PGSetTemp = new Set<string>();
        List<SelectOption> selproducts = new List<SelectOption>();
        List<Product_Alignment__c> prodAlignList = [Select Product_Group__c,Business_Unit__c from Product_Alignment__c where Related_Account__c = :PartnerAccId and Authorized_Agreement__c = true];
        
        for(Product_Alignment__c tempProdAlign : prodAlignList) {
            buSetTemp.add(tempProdAlign.Business_Unit__c);
            PGSetTemp.add(tempProdAlign.Product_Group__c);
        }
        List<Product2> lstprd = new List<Product2>();
        if(selectedBU != 'Mainframe Capacity'){
            Query = 'SELECT id, Name, Product_Group__c,Mainframe_or_Distributed__c,Upfront_Revenue_Eligible__c, Business_Group__c,Market_Focus_Area__c FROM PRODUCT2 WHERE Salesforce_CPQ_Product__c=false and Product_Visibility__c = false and isDeleted = false and Family =\'Product\' and Product_Group__c in :PGSetTemp and Market_Focus_Area__c in:buSetTemp and isActive = true';
        }else {
            Query = 'SELECT id, Name, Product_Group__c,Mainframe_or_Distributed__c,Upfront_Revenue_Eligible__c, Business_Group__c,Market_Focus_Area__c FROM PRODUCT2 WHERE Salesforce_CPQ_Product__c=false and Product_Visibility__c = false and isDeleted = false and Family =\'Mainframe Capacity\' and Product_Group__c in :PGSetTemp and Market_Focus_Area__c in:buSetTemp and isActive = true';   
        }
        system.debug(selectedBU);          
        if(selectedBU!=null && selectedBU != '--Select--'){             
            Query +=' and Market_Focus_Area__c=:selectedBU ';
        }
        if(selectedPG!=null && selectedPG!='--Select--')
            Query+=' and id=:selectedPG';
        
        Query+=' order by name';
        system.debug('Query'+Query);
        
        lstprd=Database.query(Query);
        
        if(SearchBUFlag == true){
            searchResults.clear(); //Amasa03
        }
        
        for(Product2 prd : lstprd){
            
            productwrapper pw=new productwrapper();
            pw.greyout=false;
            pw.productName=prd.Name;                       
            pw.businessUnit = prd.Market_Focus_Area__c;   
            if(prd.Market_Focus_Area__c=='Mainframe Capacity') {
                pw.businessType='MF Capacity';
                
            }                       
            pw.productid= prd.id;                       
            pw.oppline=new opportunitylineitem();
            //logic to decide License 
            if(prd.Upfront_Revenue_Eligible__c == 'Yes')
                pw.oppline.License__c = 'Upfront';
            if(prd.Mainframe_or_Distributed__c == 'SAAS')
                pw.oppline.License__c = 'SAAS';
            if(prd.Mainframe_or_Distributed__c == 'Mainframe')
                pw.oppline.License__c = 'Subscription';
            if(prd.Mainframe_or_Distributed__c == 'Distributed')
                pw.oppline.License__c = 'Ratable';
            searchResults.add(pw);   
            system.debug('searchResults-----------------');
            
        }
        
        notsaved=false;
        SearchBUFlag = false;               
    }
    
    
    public pagereference saveDeal()
    {
        notsaved=false;
        list<opportunitylineitem> updateOpplineItemlist=new list<opportunitylineitem>();
        set<id> prodset=new set<id>();
        
        //This list is for resubmission logic later in the method.
        list<string> updatedItemList = new LIst<string>();
        
        system.debug('selectedProducts in savedeal'+selectedProducts);
        for(productwrapper pw:selectedProducts)
        {
            
            if(pw.BusinessType == '--Select--'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select Business Type');
                ApexPages.addMessage(msg);
            }
            if(pw.oppline.Term_Month__c  == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Term (Month)');
                ApexPages.addMessage(msg);
            }
            if(pw.oppline.UnitPrice == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Sales Price');
                ApexPages.addMessage(msg);
            }       
            
            if(ApexPages.hasMessages())   
                return null;       
            system.debug('pw.oppline>>'+pw.oppline);
            
            if (DealApprovedOnce)
            {
                //if (pw.oppline.Deal_Program_Eligibility_Status__c=='Opt Out' || pw.oppline.Deal_Program_Eligibility_Status__c=='Separate Program')
                //    //updatedItemList.Add(pw.oppline.Id+'|0');
                //    updatedItemList.Add(pw.oppline.Id+'|0');
                //else
                //    updatedItemList.Add(pw.oppline.Id+'|1');
                if (pw.oppline.Deal_Program_Eligibility_Status__c == 'Eligible')
                    //updatedItemList.Add(pw.oppline.Id+'|0');
                    updatedItemList.Add(pw.oppline.Id+'|YES');
                else
                    updatedItemList.Add(pw.oppline.Id+'|NO');
            }
            
            opportunitylineitem oli=pw.oppline;  
            system.debug('=====oli=======' +oli);
            
            //US480649  - Deal Registration portion should not run any approval when source is Lead
            if(SourceLead != null && SourceLead){
                oli.Deal_Registration__c = 'Not Applicable';
                oli.Deal_Program_Eligibility_Status__c = 'Not Applicable';
            }
            //US480649
            oli.Business_Type__c = pw.businessType;
            if(theUserType=='PowerPartner'){
                oli.Stretch__c = pw.oppline.UnitPrice;
                oli.Partner_Added__c = true;
                oli.End_Date__c = oppstartdate.addMonths(Integer.valueOf(oli.Term_Month__c));
                oli.End_Date__c = oli.End_Date__c.addDays(-1);
            }else{
                oli.Stretch__c = oli.Stretch__c;
                oli.Partner_Added__c = false;
                oli.End_Date__c = oli.End_Date__c;
                oli.Term_Month__c=ARRandDurationCalculation.monthsbetweendates(oli.Start_Date__c, oli.End_Date__c);
                
            }
            //added by BAJPI01 as part of US311085/US311565
            oli.Start_Date__c = oppstartdate;
            
            
            oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
            
            //added by BAJPI01 as part of US311085/US311565
            
            system.debug('coming here---Override_Fees__c'+oli.Override_Fees__c); 
            OpportunityLineItem oppli = new OpportunityLineItem();
            if(oli.Override_Fees__c == false ){
                oppli = calculateUFLicenseFee(oli);
                system.debug('oppli_________inside Override_Fees__c'+oppli);
                oli.UF_License_Fee__c = oppli.UF_License_Fee__c;
                oli.X1st_Year_Maintenance__c = oli.X1st_Year_Maintenance__c;
                oli.Total_Maintenance__c = oppli.Total_Maintenance__c;
                oli.Stretch_License_Fee__c = oppli.Stretch_License_Fee__c; //SAMTU01 - US406520 
                oli.Stretch_Total_Maintenance__c = oppli.Stretch_Total_Maintenance__c; //SAMTU01 - US406520 
                oli.Stretch_Duration__c = oppli.Stretch_Duration__c; //SAMTU01 - US406520 
                //samtu01 -revrec -US417414
                oli =  LicenseClassificationMapper.LicenseClassifcationset(oli,pw.strbu,pw.strlicenseclassification);
                pw.strlicenseclassification = LicenseClassificationMapper.licclassification;
            }
            
            oli =  LicenseClassificationMapper.LicenseClassifcationset(oli,pw.strbu,pw.strlicenseclassification);
            pw.strlicenseclassification = LicenseClassificationMapper.licclassification;
            system.debug('After Calculation pw.oli>>'+oli);
            productPGmap.put(oli.pricebookentryid,oli.pricebookentry.product2.product_group__c);
            system.debug(oli.Deal_Program_Eligibility_Status__c+'$$$'+oli.Deal_Registration__c);
            updateOpplineItemlist.add(oli);
            
        }
        
        try {
            decimal tempsalesprice;
            //addProgForEachProd(updateOpplineItemlist,true);
            for(OpportunityLineitem oli:updateOpplineItemlist)
                if(oli.Deal_Program_Eligibility_Status__c=='Eligible')
                if(tempsalesprice!=null)
                tempsalesprice+=oli.Unitprice;
            else
                tempsalesprice=oli.Unitprice;
            if(tempsalesprice!=null&&(tempsalesprice>opp.Deal_Registration_Program__r.Max_Deal_Value__c)||(tempsalesprice<opp.Deal_Registration_Program__r.Min_Deal_Value__c))
            {
                //minMaxError=true;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Opportunity Sales price should be between Min and Max Value of Deal Program. Please Adjust Price'));
            }
            //system.debug(oli.Deal_Program_Eligibility_Status__c+'$$$'+oli.Deal_Registration__c);
            if(updateOpplineItemlist.size()>0&&minmaxerror==false){
                system.debug('updateOpplineItemlist>'+updateOpplineItemlist);
                update updateOpplineItemlist;
            }   
            
        }
        catch(exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
            return null;
        }
        
        //Resubmission logic
        //internal view, can't change eligible from Yes to No.
        if (updatedItemList.Size() > 0 && isPartner)
        {
            CalculateUpdatedProductForResubmission(updatedItemList);
        }
        
        //If after approved, and it's deal reg, partner delete all eligible products, or changed eligible from Yes to No, need to enable "Save & Submit for approval" button, so it can be submitted as first "no program new opportunity".
        if (DealApprovedOnce && noPgmExists(opp.id))
        {
            EnableReSubmit = true;
        }
        
        return null;  
    }
    
    
    public pagereference saveAndReturn (){
        
        saveDeal();
        
        if(!ApexPages.hasMessages()){
            pagereference p = new pagereference(apexpages.currentpage().getparameters().get('retURL'));
            
            return p;
        }
        else
            return null;
        
    }
    map<id,string> productPGmap=new map<id,string>();
    public pagereference addProduct(){
        
        system.debug('in add products');
        notsaved=false;
        list<opportunitylineitem> insertOpplineItemlist=new list<opportunitylineitem>();
        list<productwrapper> Templist = new list<productwrapper>();    
        set<id> prodset=new set<id>();
        system.debug('searchResults in add products '+searchResults);
        for(productwrapper pw:searchResults)
        {
            if(pw.Selected)
            {
                Templist.add(pw);
                if(pw.productid!=null)
                    prodset.add(pw.productid);
            }
        }
        
        
        
        Map<id,PricebookEntry> pbemap=new Map<id,PricebookEntry>();
        
        
        if(prodset.size()>0)
            for(PricebookEntry  pbe:[Select Id,Product2Id,product2.product_group__c,product2.Commissionable_BU__c from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and Product2Id in: prodset and CurrencyISOCode =:strcurrencyisocode])
        {
            pbemap.put(pbe.product2id,pbe);
            productPGmap.put(pbe.id,pbe.product2.product_group__c);
        }
        set<id> productset=new set<id>();
        for(productwrapper pw:selectedProducts) 
            productset.add(pw.productid);
        system.debug('Templist  '+Templist);
        for(productwrapper pw:Templist)
        {
            
            if(pw.BusinessType == '--Select--'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select Business Type');
                ApexPages.addMessage(msg);
                
            }
            
            if(pw.oppline.Term_Month__c  == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Term (Month)');
                ApexPages.addMessage(msg);
            }
            
            if(pw.oppline.UnitPrice == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Sales Price');
                ApexPages.addMessage(msg);
                
            }
            
            if(productset.contains(pw.productId)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Product : '+pw.productName+' is already added');
                ApexPages.addMessage(msg);
                
            }         
            
            if(ApexPages.hasMessages())   
                return null;
            
            
            opportunitylineitem oli=pw.oppline;  
            oli.Business_Type__c = pw.businessType; 
            oli.PricebookEntryid=pbemap.get(pw.productid).id;
            oli.opportunityid=strOppId;
            oli.Stretch__c = pw.oppline.UnitPrice;
            if(pw.productObj.Upfront_Revenue_Eligible__c == 'Yes')
                oli.License__c = 'Upfront';
            if(pw.productObj.Mainframe_or_Distributed__c == 'SAAS')
                oli.License__c = 'SAAS';
            if(pw.productObj.Mainframe_or_Distributed__c == 'Mainframe')
                oli.License__c = 'Subscription';
            if(pw.productObj.Mainframe_or_Distributed__c == 'Distributed')
                oli.License__c = 'Ratable';
            
            //US480649  - Deal Registration portion should not run any approval when source is Lead
            if(SourceLead != null && SourceLead){
                oli.Deal_Registration__c = 'Not Applicable';
                oli.Deal_Program_Eligibility_Status__c = 'Not Applicable';
            }
            //US480649
            OpportunityLineItem oppli = new OpportunityLineItem();
            oppli = calculateUFLicenseFee(oli);
            system.debug('oppli_________'+oppli);
            oli.UF_License_Fee__c = oppli.UF_License_Fee__c;
            oli.X1st_Year_Maintenance__c = oli.X1st_Year_Maintenance__c;
            oli.Total_Maintenance__c = oppli.Total_Maintenance__c;
            oli.Stretch_License_Fee__c = oppli.Stretch_License_Fee__c; //SAMTU01 - US406520 
            oli.Stretch_Total_Maintenance__c = oppli.Stretch_Total_Maintenance__c; //SAMTU01 - US406520 
            oli.Stretch_Duration__c = oppli.Stretch_Duration__c; //SAMTU01 - US406520 
            oli.License_Classification_Override__c=oppli.License_Classification_Override__c; //SAMTU01 - US417414
            //ponse01===start=====
            if(theUserType=='PowerPartner'){
                oli.Partner_Added__c = true;
            }
            //ponse01 =====end===
            //added by BAJPI01 as part of US311085/US311565
            oli.Start_Date__c = oppstartdate;
            oli.End_Date__c = oppstartdate.addMonths(Integer.valueOf(oli.Term_Month__c));
            oli.End_Date__c = oli.End_Date__c.addDays(-1);
            oli.Duration_Days__c = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
            
            //added by BAJPI01 as part of US311085/US311565
            
            insertOpplineItemlist.add(oli);        
            
            
        }
        try {
            
            if(insertOpplineItemlist.size()>0){
                List<OpportunityLineItem> oppli = new List<OpportunityLineItem>();   
                
                for(productwrapper pw:selectedProducts){
                    if(pw.oppline.Deal_Program_Eligibility_Status__c!='Opt Out')                   
                        oppli.add(pw.oppline);
                    
                    
                    productPGmap.put(pw.oppline.pricebookentryid,pw.oppline.pricebookentry.product2.product_group__c);
                }
                oppli.addAll(insertOpplineItemlist);
                
                //sunji03, after deal is approved, the record type is changed to "New Opportuinty", calculating eligibility logic needs record type is "deal registration", 
                //and deal_registration_status__c is not "sale approved", so need to update this before proceeding. 
                if (DealApprovedOnce)
                {
                    
                    
                    //sunji03 - Even before adding products, need to change the record type from "New Opportuinty" to "Deal Registration" and status to "Modifying" from "Approved", because program eligibility is only calculated when it's non-approved deal registration.
                    
                    //ponse01 ======start==== capturing body of certificate before new product is added
                    if(opp.Deal_Registration_Status__c =='Sale Approved'){
                        body=AttachDealRegCertificate.getCertifiacteBody(opp);
                    }
                    //ponse01 ======end======== 
                    //sunji03 - Only when it's not "submitted approval(pending)", update the record type to deal reg and status to "Modifying", 
                    //IF it's already pending, no need to re-sbumit for approval.
                    //Partner can't edit once it's submitted for approval, only internal people can add/edit/delete products after it's submitted. This is for internal view logic.
                    if (!pendingStatus)
                    {
                        UpdateRecordTypeAndDealRegStatus(opp);
                        //sunji03 - after update, refresh, for add program, addProgForEachProd method needs to use the new value
                        opp = [select Name,Rpt_Country__c,type,isPEROpp__c,End_User_Contact__c,Deal_Registration_Status__c,Deal_Approval_status__c,Distributor_6__c,Deal_Program__c,Deal_Registration_Program__r.Expiry_Days__c,Deal_Registration_Program__r.Finance_Approver_Email__c,Deal_Registration_Submitted_Date__c, RecordTypeId, Recordtype.name, Pricebook2Id,CurrencyISOCode,Registering_on_behalf_of_Partner__c, Reseller_Contact__c ,AccountId,CloseDate,StageName,Probability,ForecastCategory,Reseller__c,Partner_Sales_Price__c, Deal_Registration_Program__c,Deal_Registration_Program__r.Ranking__c,Deal_Registration_Program__r.Name,Deal_Registration_Program__r.Min_Deal_Value__c,Deal_Registration_Program__r.Max_Deal_Value__c,reseller__r.geo__c,isClosedDateFireDealReg__c,Account.Enterprise_ID__c,Start_Date__c,End_Date__c,Deal_Reg_Initially_Approved__c from Opportunity where Id =: strOppId];
                    }
                }
                //sunji03 - after update, refresh, for add program, addProgForEachProd method needs to use the new value
                //opp = [select Name,Rpt_Country__c,type,isPEROpp__c,End_User_Contact__c,Deal_Registration_Status__c,Deal_Approval_status__c,Distributor_6__c,Deal_Program__c,Deal_Registration_Program__r.Expiry_Days__c,Deal_Registration_Program__r.Finance_Approver_Email__c,Deal_Registration_Submitted_Date__c, RecordTypeId, Recordtype.name, Pricebook2Id,CurrencyISOCode,Registering_on_behalf_of_Partner__c, Reseller_Contact__c ,AccountId,CloseDate,StageName,Probability,ForecastCategory,Reseller__c,Partner_Sales_Price__c, Deal_Registration_Program__c,Deal_Registration_Program__r.Ranking__c,Deal_Registration_Program__r.Name,Deal_Registration_Program__r.Min_Deal_Value__c,Deal_Registration_Program__r.Max_Deal_Value__c,reseller__r.geo__c,isClosedDateFireDealReg__c,Account.Enterprise_ID__c,Start_Date__c,End_Date__c,Deal_Reg_Initially_Approved__c from Opportunity where Id =: strOppId];
                
                //US480649  - Deal Registration portion should not run any approval when source is Lead
                
                if(!SourceLead || SourceLead == null){
                	addProgForEachProd(oppli,false);    
                }
                //US480649
                refreshopp();
                if(minMaxError==false){
                    // ponse01=============start=====
                    for(OpportunityLineItem opl:insertOpplineItemlist){                     
                        if(opl.Deal_Registration__c=='yes'){
                            if(body!= null){
                                AttachDealRegCertificate.attachPDFtodeaHistory(opp,body);
                                break;
                            }
                        }
                        
                    }
                    //ponse01 ===========end==========
                    insert insertOpplineItemlist;
                    mainSelect = false;
                }
            }
        }
        catch(exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
            return null;
        }
        
        //If deal reg is initially approved, need to check if new eligible products are added, so that it will need resubmission.
        SaveAddedEligibleProductsForResubmission(opp,insertOpplineItemlist);
        
        system.debug('in add products'); 
        
        return null;
    }
    
    public pagereference addProduct2(){
        
        system.debug('in add products');
        notsaved=false;
        list<opportunitylineitem> insertOpplineItemlist=new list<opportunitylineitem>();
        list<productwrapper> Templist = new list<productwrapper>();    
        set<id> prodset=new set<id>();
        system.debug('searchResults in add products '+searchResults);
        for(productwrapper pw:searchResults)
        {
            if(pw.Selected)
            {
                Templist.add(pw);
                if(pw.productid!=null)
                    prodset.add(pw.productid);
            }
        }
        
        
        
        Map<id,PricebookEntry> pbemap=new Map<id,PricebookEntry>();
        
        if(prodset.size()>0)
            for(PricebookEntry  pbe:[Select Id,Product2Id,product2.product_group__c from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and Product2Id in: prodset and CurrencyISOCode =:strcurrencyisocode])
        {
            pbemap.put(pbe.product2id,pbe);
            productPGmap.put(pbe.id,pbe.product2.product_group__c);
        }
        set<id> productset=new set<id>();
        for(productwrapper pw:selectedProducts) 
            productset.add(pw.productid);
        system.debug('Templist  '+Templist);
        for(productwrapper pw:Templist)
        {
            
            if(pw.BusinessType == '--Select--'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select Business Type');
                ApexPages.addMessage(msg);
                
            }
            
            if(pw.oppline.Term_Month__c  == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Term (Month)');
                ApexPages.addMessage(msg);
            }
            
            if(pw.oppline.UnitPrice == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter Sales Price');
                ApexPages.addMessage(msg);
                
            }
            
            if(productset.contains(pw.productId)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Product : '+pw.productName+' is already added');
                ApexPages.addMessage(msg);
                
            }         
            
            if(ApexPages.hasMessages())   
                return null;
            
            opportunitylineitem oli=pw.oppline;
            //US480649  - Deal Registration portion should not run any approval when source is Lead
            if(SourceLead!= null && SourceLead){
                oli.Deal_Registration__c = 'Not Applicable';
                oli.Deal_Program_Eligibility_Status__c = 'Not Applicable';
            }
            //US480649
            oli.Business_Type__c = pw.businessType; 
            oli.PricebookEntryid=pbemap.get(pw.productid).id;
            oli.opportunityid=strOppId;
            oli.Stretch__c = pw.oppline.UnitPrice;
            if(pw.productObj.Upfront_Revenue_Eligible__c == 'Yes')
                oli.License__c = 'Upfront';
            if(pw.productObj.Mainframe_or_Distributed__c == 'SAAS')
                oli.License__c = 'SAAS';
            if(pw.productObj.Mainframe_or_Distributed__c == 'Mainframe')
                oli.License__c = 'Subscription';
            if(pw.productObj.Mainframe_or_Distributed__c == 'Distributed')
                oli.License__c = 'Ratable';
            OpportunityLineItem oppli = new OpportunityLineItem();
            oppli = calculateUFLicenseFee(oli);
            system.debug('oppli_________'+oppli);
            oli.UF_License_Fee__c = oppli.UF_License_Fee__c;
            oli.X1st_Year_Maintenance__c = oli.X1st_Year_Maintenance__c;
            oli.Total_Maintenance__c = oppli.Total_Maintenance__c;
            oli.Partner_Added__c = true;  
            oli.Stretch_License_Fee__c = oppli.Stretch_License_Fee__c; //SAMTU01 - US406520 
            oli.Stretch_Total_Maintenance__c = oppli.Stretch_Total_Maintenance__c; //SAMTU01 - US406520 
            oli.Stretch_Duration__c = oppli.Stretch_Duration__c; //SAMTU01 - US406520 
            oli.License_Classification_Override__c=oppli.License_Classification_Override__c; //SAMTU01 - US417414
            insertOpplineItemlist.add(oli);        
            
            
        }
        try {
            
            if(insertOpplineItemlist.size()>0){
                insert insertOpplineItemlist;
                
                searchResults.clear();
                refreshSelectProducts();
            }
            
            
        }
        catch(exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
            return null;
        }
        system.debug('in add products'); 
        return null;
    }
    
    
    public pagereference addAndReturn(){
        
        addProduct();
        
        if(!ApexPages.hasMessages()){
            
            pagereference p = new pagereference(apexpages.currentpage().getparameters().get('retURL'));
            return p;
        }
        else
            return null;
        
    }
    
    public pagereference addAndStay(){
        
        system.debug('add n stay ');
        addProduct();
        system.debug('after add n stay ');
        
        if(!ApexPages.hasMessages()&&minMaxError==false){
            refreshSelectProducts();
            searchResults = new list<productwrapper>();
        }
        return null;
    }
    
    
    
    
    public void refreshSelectProducts(){
        
        
        selectedProducts= new list<productwrapper>();
        integer prdCount = 0;
        for(OpportunityLineItem oli:[select Id,Added_Before_Approval__c,Stretch__c,Deal_Program_Name__c,PricebookEntry.Product2.Product_Group__c,Partner_Sales_Price__c,RejectedByCA__c,Partner_Added__c,License__c,Business_Unit__c, Deal_Program_Eligibility_Status__c,Deal_Registration__c, Deal_Program_ID__c, Business_Type__c,Term_Month__c ,UnitPrice,PricebookEntry.Product2Id,PricebookEntry.Product2.Name,override_fees__c,Total_Maintenance__c,UF_License_Fee__c,Corporate_ARR__c,Stretch_Corporate_ARR__c,Start_Date__c,End_Date__c,Duration_Days__c,Commissionable_BU__c,Stretch_Duration__c,Stretch_License_Fee__c,Stretch_Total_Maintenance__c,License_Classification_Override__c,License_Classification__c//SAMTU01 US406520 
                                     from OpportunityLineItem 
                                     where OpportunityId=:strOppId
                                     and Business_Type__c != 'Renewal' 
                                     order by createddate asc])
        {
            productwrapper pw=new productwrapper();
            pw.greyout=true;
            pw.businessUnit = oli.Business_Unit__c;
            pw.businessType = oli.Business_Type__c;
            pw.productName=oli.PricebookEntry.Product2.Name;   
            pw.productid= oli.PricebookEntry.Product2id; 
            pw.strlicenseclassification =oli.License_Classification__C; //samtu01 -revrec US417414O
            pw.oppline=oli;
            pw.position = prdCount;
            prdCount +=1;
            selectedProducts.add(pw);
            
        }  
        system.debug('selectedProducts>>'+selectedProducts);
    }
    public String deletedProduct {get;set;}
    public boolean deleteFlag {get;set;}  
    
    public void checkBeforeDelete(){
        
        deletedProduct = Apexpages.CurrentPage().getParameters().get('deletedProduct');
        deleteFlag=true;
        
    }
    
    private void SaveAddedEligibleProductsForResubmission(Opportunity opp, List<opportunitylineitem> insertOpplineItemlist)
    {
        //if (DealApprovedOnce && opp.deal_registration_status__c == 'Modifying') 
        //sunji03 - internal people can add/edit/delete products when it's submitted and pending status, which includes Deal Submitted to CA,Deal Awaiting Approval,Deal Awaiting Finance Approval,Finance Approved
        //Partner side, it's locked when it's submitted for approval
        if (DealApprovedOnce && (opp.deal_registration_status__c == 'Modifying' || pendingStatus))
        {
            if (opp.DR_Added_Eligible_Products__c == null) opp.DR_Added_Eligible_Products__c = '';
            if (opp.ResubmissionProducts__c == null) opp.ResubmissionProducts__c = '';
            
            set<ID> insertedIds = new set<ID>();
            for(opportunitylineitem i : insertOpplineItemlist)
            {
                insertedIds.add(i.Id);
            }
            string products='';
            //DR_Added_Eligible_Products__c is in the format of "ID|YES,ID|YES,ID|NO",  "YES" and "NO" indicate deal program dropdown selection, user can change from "Yes" to "No", and from "No" back "Yes", but non-eligible can't be changed to Yes.
            //The value for Deal_Program_Eligibility_Status__c can be "Eligible, Separate program" and "optout", Deal_Registration__c can be "Yes" or "No". If there are products in separate program,
            //although Deal_Program_Eligibility_Status__c is "separate program", Deal_Registration__c is "No", partner can't change from "No" to "Yes". Partner can choose to opt out when submit for approval, but that does not affect Deal_Registration__c = "No"
            for(OpportunityLineItem oli:[select Id,Deal_Registration__c,Product2.name from OpportunityLineItem where id in:insertedIds and Business_Type__c != 'Renewal' and Deal_Registration__c = 'Yes'])
            {
                
                opp.DR_Added_Eligible_Products__c += oli.id + '|YES,'; 
                if(oli.Product2.name != null){
                    opp.ResubmissionProducts__c += oli.Product2.name+',';
                    products +=oli.Product2.name+',';
                    
                }
            }  
            opp.ProductsList__c=products.removeend(',');
            //If eligible products is changed by user to "No", it will be ID|NO, but we can't remove them from field DR_Added_Eligible_Products__c, as user might change it back to "Yes", which then needs to rusbmit.
            if (opp.DR_Added_Eligible_Products__c == '' || !opp.DR_Added_Eligible_Products__c.contains('|YES')) //If eligible products is changed by user to "No", it will be ID|NO, but we can't remove them from the field 
            {
                // RevertBacktoApprovedRecordTypeAndDealRegStatus(opp); //DR_Added_Eligible_Products__c is saved inside the method together with other fields.
                //sunji03 - Only when it's not "submitted approval(pending)", update the record type to deal reg and status to "Modifying", 
                //IF it's already pending, no need to re-sbumit for approval.
                //Partner can't edit once it's submitted for approval, only internal people can add/edit/delete products after it's submitted. This is for internal view logic.
                if (pendingStatus)
                {
                    EnableReSubmit = false;     
                    approvalStatus = false;  
                    //still need to save updated DR_Added_Eligible_Products__c, and ResubmissionProducts__c
                    try{
                        System.debug('Update start for DR_Eligible products');
                        update opp;
                        System.debug('Update finished for DR_Eligible products');
                    }
                    catch(exception e){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                        ApexPages.addMessage(msg);
                    }
                }
                else
                {
                    RevertBacktoApprovedRecordTypeAndDealRegStatus(opp); //DR_Added_Eligible_Products__c is saved inside the method together with other fields.
                }
            }
            else
            {
                //still need to save updated DR_Added_Eligible_Products__c, and ResubmissionProducts__c
                try{
                    update opp;
                }
                catch(exception e)
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                    ApexPages.addMessage(msg);
                }
            }
        }
    }
    
    @TestVisible
    private void UpdateRecordTypeAndDealRegStatus(Opportunity opp)
    {
        EnableReSubmit = true;
        approvalStatus = false; //status is changed to "Modifying"deal
        
        opp.Products_Changed_After_Approval__c = true;
        opp.deal_registration_status__c = 'Modifying';
        opp.Resubmission__c=true;
        
        //After deal reg is approved, it's converted to "New Opportunity" already. Now, something is changed, need to change the type back to 
        if (opp.RecordTypeId != dealRegRecordTypeId)
        {
            opp.RecordTypeId = dealRegRecordTypeId; 
        }
        
        try{
            update opp;
        }
        catch(exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
        }
    }
    
    private string RemoveTrailingComma(string text)     
    {       
        if (text.endsWith(','))     
        {       
            text = text.SubString(0,text.length()-1);       
        }       
        return text;        
    }
    
    @TestVisible
    private list<string> RemoveItemFromList(List<string> ids, string idToCompare)
    {
        boolean isFound = false;
        integer itemIndex = -1;
        for(string s:ids)
        {
            itemIndex ++; 
            if (s.split('\\|')[0] == idToCompare) //format is ID|YES,ID|1,ID|NO
            {
                isFound = true;
                break;
            }
        }
        
        if (itemIndex >=0)
            ids.remove(itemIndex);
        
        return ids;
    }
    
    @TestVisible
    private list<string> ChangeItemInList(list<string> ids, string idToCompare)
    {
        boolean isFound = false;
        integer itemIndex = -1;
        for(string s:ids)
        {
            itemIndex ++; 
            if (s.split('\\|')[0] == idToCompare.split('\\|')[0]) //format is ID|YES,ID|1,ID|NO
            {
                isFound = true;
                break;
            }
        }
        if (itemIndex >=0)
            ids[itemIndex] = idToCompare;
        
        return ids;
    }
    
    private void CalculateUpdatedProductForResubmission(list<string> updatedItemList)
    {
        Opportunity opp = [select id,DR_Added_Eligible_Products__c,Deal_Approval_status__c, Deal_Registration_Status__c, RecordTypeId from Opportunity where id = :oppId];
        
        if (opp.DR_Added_Eligible_Products__c == null)
            opp.DR_Added_Eligible_Products__c = '';
        
        if (DealApprovedOnce && opp.DR_Added_Eligible_Products__c != '')
        {
            boolean isContained = false;
            for(string i:updatedItemList)
            {
                if (opp.DR_Added_Eligible_Products__c.contains(i.split('\\|')[0]))
                {
                    isContained = true;
                    break;
                }
            }
            
            if (isContained)
            {
                opp.DR_Added_Eligible_Products__c = RemoveTrailingComma(opp.DR_Added_Eligible_Products__c);    
                List<string> ids = opp.DR_Added_Eligible_Products__c.split(',');
                
                for(string i:updatedItemList)
                {
                    ids = ChangeItemInList(ids,i);
                }
                
                opp.DR_Added_Eligible_Products__c = '';
                for(string s:ids)
                {
                    opp.DR_Added_Eligible_Products__c += s + ',';
                }
                
                opp.ResubmissionProducts__c = GetResubmissionProductNameByID(ids);
                
                If (opp.DR_Added_Eligible_Products__c == '' || !opp.DR_Added_Eligible_Products__c.contains('|YES'))
                {
                    //sunji03 - Only when it's not "submitted approval(pending)", update the record type to deal reg and status to "Modifying", 
                    //IF it's already pending, no need to re-sbumit for approval.
                    //Partner can't edit once it's submitted for approval, only internal people can add/edit/delete products after it's submitted. This is for internal view logic.
                    if (pendingStatus)
                    {
                        EnableReSubmit = false;     
                        approvalStatus = false;  
                        //still need to save updated DR_Added_Eligible_Products__c and ResubmissionProducts__c
                        try{
                            update opp;
                        }
                        catch(exception e){
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                            ApexPages.addMessage(msg);
                        }
                    }
                    else
                    {
                        RevertBacktoApprovedRecordTypeAndDealRegStatus(opp);
                    }
                }
                else
                {
                    //sunji03 - Only when it's not "submitted approval(pending)", update the record type to deal reg and status to "Modifying", 
                    //IF it's already pending, no need to re-sbumit for approval.
                    //Partner can't edit once it's submitted for approval, only internal people can add/edit/delete products after it's submitted. This is for internal view logic.
                    if (pendingStatus)
                    {
                        EnableReSubmit = false;     
                        approvalStatus = false;  
                        //still need to save updated DR_Added_Eligible_Products__c and ResubmissionProducts__c
                        try{
                            update opp;
                        }
                        catch(exception e){
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                            ApexPages.addMessage(msg);
                        }
                    }
                    else
                    {
                        UpdateRecordTypeAndDealRegStatus(opp);
                    }
                }
            }
        }
    }
    
    private string GetResubmissionProductNameByID(list<string> ids)
    {
        string resubmissionProducts = '';
        List<string> prodIDs = new List<string>();
        for(string s:ids)
        {
            if (s.split('\\|')[1] == 'YES' )
            {
                prodIDs.add(s.split('\\|')[0]);
            }
        }
        
        for(OpportunityLineItem oli:[select Id,Deal_Registration__c,Product2.name from OpportunityLineItem where id in:prodIDs])
        {
            if(oli.Product2.name != null)
            {
                resubmissionProducts += oli.Product2.name+',';
            }
        }  
        
        return resubmissionProducts;
    }
    
    private void CalculateDeletedProductForResubmission(string deletedItemLineId)
    {
        Opportunity opp = [select id,DR_Added_Eligible_Products__c,Deal_Approval_status__c,Deal_Registration_Status__c, RecordTypeId from Opportunity where id = :oppId];
        
        if (opp.DR_Added_Eligible_Products__c == null)
            opp.DR_Added_Eligible_Products__c = '';
        
        if (DealApprovedOnce && opp.DR_Added_Eligible_Products__c != '')
        {
            if (opp.DR_Added_Eligible_Products__c.contains(deletedItemLineId))
            {
                opp.DR_Added_Eligible_Products__c = RemoveTrailingComma(opp.DR_Added_Eligible_Products__c);    
                
                List<string> ids = opp.DR_Added_Eligible_Products__c.split(',');
                
                ids = RemoveItemFromList(ids,deletedItemLineId);
                
                opp.DR_Added_Eligible_Products__c = '';
                for(string s:ids)
                {
                    opp.DR_Added_Eligible_Products__c += s + ',';
                }
                
                opp.ResubmissionProducts__c = GetResubmissionProductNameByID(ids);
                
                If (opp.DR_Added_Eligible_Products__c == '' || !opp.DR_Added_Eligible_Products__c.contains('|YES'))
                {
                    //RevertBacktoApprovedRecordTypeAndDealRegStatus(opp);
                    //sunji03 - Only when it's not "submitted approval(pending)", update the record type to deal reg and status to "Modifying", 
                    //IF it's already pending, no need to re-sbumit for approval.
                    //Partner can't edit once it's submitted for approval, only internal people can add/edit/delete products after it's submitted. This is for internal view logic.
                    if (pendingStatus)
                    {
                        EnableReSubmit = false;     
                        approvalStatus = false;  
                        //still need to save updated DR_Added_Eligible_Products__c and ResubmissionProducts__c
                        try{
                            update opp;
                        }
                        catch(exception e){
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                            ApexPages.addMessage(msg);
                        }
                    }
                    else
                    {
                        RevertBacktoApprovedRecordTypeAndDealRegStatus(opp);
                    }
                }
                else
                {
                    //still need to save updated DR_Added_Eligible_Products__c and ResubmissionProducts__c
                    try{
                        update opp;
                    }
                    catch(exception e)
                    {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                        ApexPages.addMessage(msg);
                    }
                }
            }
        }
    }
    
    @TestVisible
    private void RevertBacktoApprovedRecordTypeAndDealRegStatus(opportunity opp)
    {       
        EnableReSubmit = false;     
        approvalStatus = true;  
        
        //If it's 'Modifying', "Recall" or "Reject" (Although in Reject, deal_registration_status__c is set to 'Sale Approved', Deal_Approval_status__c == 'Deal Rejected' is reliable
        if (opp.Deal_Registration_Status__c != 'Sale Approved' || (opp.Deal_Registration_Status__c == 'Sale Approved' && opp.Deal_Approval_status__c == 'Deal Rejected') || (opp.Deal_Registration_Status__c == 'Modifying'))      
        { 
            opp.Products_Changed_After_Approval__c = false;     
            
            //After deal reg is approved, it's converted to "New Opportunity" already. if further edit makes it warrant re-submission and then edit back to the values which does not warrant re-submission, revert back to the approved state.      
            if (opp.RecordTypeId != newOppRecordTypeID)     
            {       
                opp.RecordTypeId = newOppRecordTypeID;       
            }       
            opp.Deal_Registration_Status__c = 'Sale Approved';    
            opp.Deal_Approval_status__c =  'Deal Approved'; 
            opp.Deal_Resubmit_Auto_Approve_From_Reject__c = false;
            opp.Resubmission__c=false;
            try{        
                update opp;     
            }       
            catch(exception e)      
            {       
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());     
                ApexPages.addMessage(msg);      
            }    
        }  
        else //sale approved, real approval, not including rejected auto tag to approved.
        {
            try{        
                update opp;     
            }       
            catch(exception e)      
            {       
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());     
                ApexPages.addMessage(msg);      
            }     
            
        } 
    }
    
    public void deleteProducts(){
        
        deleteFlag=false;  
        List<OpportunityLineItem> oppList =new List<opportunityLineItem>();  
        Set<String> statusList = new Set<String>();
        Integer index = 0, deletedProductIndex = 0;  
        list<opportunitylineitem> delline=new list<opportunitylineitem>();
        
        string deletedItemLineId = '';
        
        for(productwrapper pw:selectedProducts){ 
            if(deletedProduct != null && pw.ProductName == deletedProduct && pw.oppline.id!=null){
                delline.add(pw.oppline);
                deletedItemLineId = pw.oppline.id;
                deletedProductIndex = Index;
                System.debug(selectedProducts[Index]);
                //break; commented on 2 sep 2015 
            }else{
                oppList.add(pw.oppline);
            }
            Index++;
        }
        if(deletedProductIndex != selectedProducts.size())
            selectedProducts.remove(deletedProductIndex);    
        try{ 
            if(delline.size()>0)
                delete delline;
            
            
        }
        catch(Exception e){
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
            ApexPages.addMessage(msg);
            
        }
        
        //Resubmission logic: If user delete the exact same products added before re-submission, need to remove the products from field DR_Added_Eligible_Products__c, and if DR_Added_Eligible_Products__c is empty as a result, revert deal reg back to previous approved version.
        CalculateDeletedProductForResubmission(deletedItemLineId);
        
        list<opportunitylineitem> tempoppline=new list<opportunitylineitem>();
        system.debug('oppList++'+oppList);
        for(OpportunityLineItem oppLineItem1 : oppList){
            if(oppLineItem1.Deal_Program_Eligibility_Status__c!='Opt Out')
                tempoppline.add(oppLineItem1 );
            statusList.add(oppLineItem1.Deal_Program_Eligibility_Status__c);
            productPGmap.put(oppLineItem1.pricebookentryid,oppLineItem1.pricebookentry.product2.product_group__c);
        }
        system.debug('statusList   >>>'+statusList);
        if( !statusList.isEmpty() && !statusList.contains('Eligible') ){
            opp.Deal_Registration_Program__c = null;
            opp.Deal_Program__c = '';
            addProgForEachProd(tempoppline,false);
            refreshopp();
            if(minMaxError==false)
                refreshSelectProducts();
        }else if(statusList.isEmpty()){
            opp.Deal_Registration_Program__c = null;
            opp.Deal_Program__c = '';
            try{
                update opp;
            }
            catch(exception e){
                
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                ApexPages.addMessage(msg);
                
            }
            refreshopp();
        }//Added for refresh Rank: Jyoti on 2 september.
        else {
            //if(minMaxError==false)
            refreshopp();
            refreshSelectProducts();
        }
        
        //If after approved, and it's deal reg, partner delete all eligible products, or changed eligible from Yes to No, need to enable "Save & Submit for approval" button, so it can be submitted as first "no program new opportunity".
        if (DealApprovedOnce && noPgmExists(opp.id))
        {
            EnableReSubmit = true;
        }
    }
    
    private boolean noPgmExists(String opportunityId){
        boolean noPgm = true;
        for(OpportunityLineItem oli : [select id,OpportunityId,Deal_Registration__c from OpportunityLineItem where OpportunityId =:opportunityId]){
            if(oli.Deal_Registration__c == 'Yes'){
                noPgm = false;
                break;
            }
        }
        return noPgm;
    }
    
    public boolean SearchTypeAheadFlag {get;set;} 
    public void checkBeforeRefreshProductTable(){
        
        //checkbefore();//Amasa03
        if(notsaved==false){
            refreshProductTable();
        }
        else
            refreshProductTable(); //Amasa03
        
    } 
    
    public PageReference refreshProductTable(){
        System.debug('===========Enter========');
        
        //searchResults.clear(); //Amasa03
        if(selectedproduct!=null){
            System.debug('=========selectedproduct======='+selectedproduct);
            selectedList = [SELECT id, Name,Mainframe_or_Distributed__c,Upfront_Revenue_Eligible__c, Product_Group__c, Business_Group__c, Market_Focus_Area__c FROM PRODUCT2 WHERE Salesforce_CPQ_Product__c=false and ID=:selectedproduct LIMIT 1];
            System.debug('========selectedList======'+selectedList);
            
            for(PRODUCT2 pd: selectedList )
            {
                productwrapper pw=new productwrapper();
                pw.greyout = false;
                pw.selected = true;
                pw.productName = pd.Name;
                pw.businessUnit = pd.Market_Focus_Area__c;
                if(pd.Market_Focus_Area__c=='Mainframe Capacity') {     
                    pw.businessType='MF Capacity';       
                    
                }
                pw.productObj = pd;
                pw.productid = pd.id;
                
                pw.oppLine = new opportunitylineitem();
                system.debug('#####-'+pw);
                searchResults.add(pw);
            }   
        }
        
        notsaved=false; 
        SearchTypeAheadFlag = false;
        
        return null;
    }
    
    public boolean disableSearch{get;set;}
    
    public boolean SearchPGFlag {get;set;} 
    public void checkBeforeSearchByProductGroup(){
        
        //checkbefore();//Amasa03
        if(notsaved==false){
            searchByProductGroup();
        }
        else
            searchByProductGroup(); //Amasa03
        
    }
    
    public void searchByProductGroup(){
        
        //searchResults.clear();//Amasa03
        
        if(selectedPG == '--Select--')
            disableSearch = false;
        
        else{
            disableSearch = true;
            Searchproducts();
            
            if(searchResults.size() == 0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Selected Product is already added');
                ApexPages.addMessage(msg);
                
            }
            else{
                selectedBU = '--Select--';
                selectedPG = '--Select--';
                disableTypeAhead = false;
                disableBU = false;
                disableSearch = true;
                PGs=new list<selectoption>();
                notsaved=false;
                
                for(productwrapper pw:searchresults)
                    pw.Selected=true;
                
            }
            
        }
        SearchPGFlag = false; 
    }
    
    public void getproductgroup()
    {
        PGs=new list<selectoption>();
        
        PGs=fetchPG();
        
        if(selectedBU == '--Select--'){
            selectedPG = '--Select--';
            disableTypeAhead= false;
            disableSearch = true;
        }
        
        else {
            disableTypeAhead= true;
            disableSearch = false;
        }
        
    }
    
    public void SetBU()
    {
        
        if(searchString.equals('Enter Product detail') || searchString.length() <= 0){
            selectedBU = '--Select--';
            disableBU = false;
        }
        
        else{
            disableSearch = true;
            disableBU = true;
        }
        
        
    }
    
    
    public boolean notsaved {get;set;}
    public void checkbefore()
    {
        notsaved=false;
        for(productwrapper pw:searchresults)
        {
            if(pw.Selected==true)
                notsaved=true;
        }
        system.debug('222'+notsaved);
    }
    
    
    public pageReference checkBeforeReturn(){
        checkbefore();
        if(notsaved){
            unSavedData = true;
        }
        else {
            for(OpportunityLineitem dbOppLineItem : [Select Id,Added_Before_Approval__c,Deal_Registration__c,RejectedByCA__c,Partner_Added__c ,License__c,Stretch__c,Start_Date__c,End_Date__c, Business_Type__c, UnitPrice, Term_Month__c,override_fees__c,Total_Maintenance__c,UF_License_Fee__c,Stretch_Duration__c,Stretch_License_Fee__c,Stretch_Total_Maintenance__c from OpportunityLineItem where OpportunityId =:strOppId] ){ //strOppId //SAMTU01 US406520 
                for(ProductWrapper pw : selectedProducts){
                    if(pw.oppline.Id == dbOppLineItem.Id && (pw.oppline.Deal_Registration__c != dbOppLineItem.Deal_Registration__c || pw.oppline.UnitPrice != dbOppLineItem.UnitPrice || pw.BusinessType != dbOppLineItem.Business_Type__c || pw.oppline.Term_Month__c  != dbOppLineItem.Term_Month__c )){
                        unSavedData = true;
                        System.debug('SalesPrice'+unSavedData+ pw.oppline.Id+dbOppLineItem.Id+pw.oppline.UnitPrice+pw.BusinessType+dbOppLineItem.UnitPrice+dbOppLineItem.Business_Type__c);
                    }   
                }
            }
        }
        return null;
    }
    
    public boolean SearchBUFlag {get;set;}  
    public void checkBeforeSearch(){
        
        checkbefore();
        if(notsaved==false){
            searchResults.clear();//Amasa03
            Searchproducts();
        }
        else
            SearchBUFlag = true;
        
    }
    
    public boolean clearFlag {get;set;}  
    public void checkBeforeClear(){
        
        checkbefore();   
        if(notsaved==false)
            continueClear();
        else
            clearFlag = true;
        
    }
    
    public void continueClear()
    {
        selectedBU = '--Select--';
        disableTypeAhead = false;
        disableBU = false;
        disableSearch = true;
        PGs=new list<selectoption>();
        searchResults.clear();
        clearFlag = false;
        notsaved=false;
        mainSelect = false;
        ApexPages.getMessages().clear();
        System.debug('mainSelect'+mainSelect+'selectedBU'+selectedBU);
    }
    
    public void closePopup()
    {
        notsaved=false;
        deleteFlag =false;
        clearFlag = false;
        deleteFlag = false;
        unSavedData = false;
        SearchBUFlag = false;
        SearchPGFlag = false;
        SearchTypeAheadFlag = false;
        
    }
    
    public pagereference cancel()
    {
        //sunji03 - change cancel to go to previous page, not default opportunity page
        pagereference p;
        string urlSaveNew = Apexpages.currentPage().getParameters().get('save_new');
        if (urlSaveNew != null && urlSaveNew == '1')
        {
            string urlRecordType = Apexpages.currentPage().getParameters().get('RecordType');
            string urlEnt = Apexpages.currentPage().getParameters().get('ent');
            
            p = new Pagereference('/apex/DealRegistrationEdit_New?oppid='+ strOppId + '&RecordType=' + urlRecordType +'&ent=' + urlEnt + '&save_new=1&sfdc.override=1');
        }
        else
        {
            p = new pagereference('/'+strOppId);
        }
        return p;
    }
    
    //Added for 3186 :Jyoti Singh 
    public void getDealEligibleProgramList(){
        
        try{
            DealProgramEligibility dealPrmEligible = new DealProgramEligibility();
            //AR 3257 - For Tier 2 transaction, populate Deal reg program based on Distributor  
            system.debug('##### Tier--'+ Opp);                
            system.debug('##### Tier--'+ Opp.Type+ '--Disti 6--' + Opp.Distributor_6__c);                 
            if(Opp.Type == '2 Tier' && Opp.Distributor_6__c != null ){
                dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(Opp.Distributor_6__c,opp.AccountId,opp.id);
                system.debug('dealPrograms=========--'+ dealPrograms);
            }
            else if(Opp.Type.equalsIgnoreCase('XSP') ||Opp.Type == 'OEM'){
                dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(Opp.AccountId,opp.AccountId,opp.id);
            }      
            else
                dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(opp.Reseller__c,opp.AccountId,opp.id);
            
            
            list<Deal_Registration_Program__c> FiltereddealPrograms =new list<Deal_Registration_Program__c>();
            if(dealPrograms.size()>0 && dealPrograms!=Null){
                // if(dealPrograms[i].Accounts_Support__c != null && !isxspDealaccount(dealPrograms[i].Accounts_Support__c,opp.Account.Enterprise_ID__c)){
                //dealPrograms.remove(i);
                //break;
                // }else{
                FiltereddealPrograms.addall(dealPrograms);//US470447 -ponse01
                //}
            }
            dealPrograms =new list<Deal_Registration_Program__c>();
            dealPrograms =FiltereddealPrograms;
            system.debug('FiltereddealPrograms=========--'+ dealPrograms);
            
        }
        
        catch(Exception e){
            system.debug('#####-'+e);
        }
        
    }
    
    public Boolean isxspDealaccount(String SupportAccount,String oppAccountID){
        Boolean returnVal = false;
        List<String> AccountIDList = SupportAccount.split(';');
        for(String tAccount : AccountIDList){
            if(oppAccountID == tAccount){
                returnVal = true;
                break;
            }
        }
        return returnVal;
        
    }
    
    //Added for 3186 :Jyoti Singh
    public void populateIsoCodeConversionMap(){
        
        for(CurrencyType ct : [SELECT IsoCode, ConversionRate FROM CurrencyType])
            isoCodeToConversionRate.put(ct.IsoCode, ct.ConversionRate);
    }
    
    //Added for 3186 :Jyoti Singh      
    public void getPrdctGrpPrgrmRelation()
    {
        getDealEligibleProgramList();
        populateIsoCodeConversionMap();
        for(Deal_Program_Product_Group__c dppg:[select id,Deal_Registration_Program__c,Product_Group__c from Deal_Program_Product_Group__c where Deal_Registration_Program__c in:dealPrograms limit 50000])
        {    
            if(productgroupvalue.get(dppg.Deal_Registration_Program__c)!=null){
                set<string> prodGrpList=new set<string>();
                prodGrpList=productgroupvalue.get(dppg.Deal_Registration_Program__c);
                prodGrpList.add(dppg.Product_Group__c);
                productgroupvalue.put(dppg.Deal_Registration_Program__c,prodGrpList);
            }
            else
            {
                set<string> prodGrpList=new set<string>();
                prodGrpList.add(dppg.Product_Group__c);
                productgroupvalue.put(dppg.Deal_Registration_Program__c,prodGrpList);
            }
        }
        system.debug('productgroupvalue----'+productgroupvalue);
        
    }
    
    
    //Added for 3186 :Jyoti Singh   
    public List<OpportunityLineItem> getProgRanks(List<OpportunityLineItem> opplinelist)
    {
        for(PricebookEntry  pbe:[Select Id,Product2Id,product2.product_group__c from PricebookEntry Where IsActive=true and Pricebook2Id=: strpricebookid and CurrencyISOCode =:strcurrencyisocode])
        {
            //pbemap.put(pbe.product2id,pbe);
            productPGmap.put(pbe.id,pbe.product2.product_group__c);
        }
        
        for(OpportunityLineItem oli : opplinelist){
            
            oli.Deal_Program_ID__c = null;
            system.debug('dealPrograms in getProgRanks' +dealPrograms);
            for(Deal_Registration_Program__c dealRegPrmRef : dealPrograms ) {
                
                //removed this piece from if condition and putting it outside
                progRankMap.put(dealRegPrmRef.Deal_Program_Number__c,dealRegPrmRef);
                system.debug('progRankMap in getProgRanks' +progRankMap);
                system.debug('productgroupvalue in getProgRanks-1-productgroupvalue.get(dealRegPrmRef.id)--' +productgroupvalue.get(dealRegPrmRef.id));
                system.debug('oli.pricebookentryid-----------in getprogRanks'+oli.pricebookentryid);
                system.debug('productPGmap-----------in getprogRanks'+productPGmap);
                system.debug('productPGmap in getProgRanks--2-1--' +productPGmap.get(oli.pricebookentryid));
                
                system.debug('productgroupvalue in getProgRanks--2--' +productgroupvalue.get(dealRegPrmRef.id).contains(productPGmap.get(oli.pricebookentryid)));
                system.debug('productgroupvalue in getProgRanks--3--' +opp.isPEROpp__c);
                
                if(productgroupvalue.get(dealRegPrmRef.id)!=null && productgroupvalue.get(dealRegPrmRef.id).contains(productPGmap.get(oli.pricebookentryid)) && !opp.isPEROpp__c){
                    system.debug('in first if getProgRanks');
                    system.debug('oli.Added_Before_Approval__c---in first getProgRanks'+oli.Added_Before_Approval__c);
                    system.debug('opp.Deal_Registration_status__c---in first getProgRanks'+opp.Deal_Registration_status__c);
                    
                    if(opp.Deal_Registration_status__c !='Sale Approved' || (opp.Deal_Registration_status__c =='Sale Approved' && oli.Added_Before_Approval__c=='Yes')){
                        system.debug('in second if getProgRanks');
                        String newDealID = dealRegPrmRef.Deal_Program_Number__c+'-'+dealRegPrmRef.Ranking__c;
                        system.debug('in second if getProgRanks'+newDealID);
                        if(oli.Deal_Program_ID__c ==null)
                            
                            oli.Deal_Program_ID__c = newDealID;
                        
                        
                        else if(oli.Deal_Program_ID__c !=null && !String.ValueOf(oli.Deal_Program_ID__c).contains(newDealID))
                            oli.Deal_Program_ID__c = oli.Deal_Program_ID__c+';'+ newDealID;
                        
                        oli.Added_Before_Approval__c = 'Yes';
                    }
                }
                else if(opp.Deal_Registration_status__c == 'Sale Approved'  && oli.Added_Before_Approval__c != null && oli.Added_Before_Approval__c != 'Yes'){
                    
                    oli.Deal_Program_ID__c = null;
                } 
            }
            
            
            if(opp.isPEROpp__c ) oli.Deal_Program_ID__c = null;     
        }
        
        return opplinelist;
    }
    
    //Added for 3186 :Jyoti Singh
    public List<OpportunityLineItem> getMaxRankAndHeader(List<OpportunityLineItem> opplinelist)
    {
        
        maxRank=0;
        
        //This Methos calculates Best Rank out of all the eligible programs ans decides header program name for opp.
        for(OpportunityLineItem oli : opplinelist){
            
            
            //This block is for No Program Products
            if(oli.Deal_Program_ID__c == null){
                oli.Deal_Program_Eligibility_Status__c = 'No Program';
                oli.Deal_Registration__c = 'No';
            }
            
            
            else if(oli.Deal_Program_ID__c.contains(';')){ //This block is for Multiple Program Products
                Integer MultimaxRank =0;
                string MultiheaderProg='';
                List<string> prgIDListStr = String.valueOf(oli.Deal_Program_ID__c).split(';');
                system.debug('prgIDListStr'+prgIDListStr);
                for(string strId: prgIDListStr){
                    Integer RankInt = integer.valueof(strId.substring(9));
                    string PrgNum = strId.substring(0,8);
                    system.debug('RankInt for multi'+RankInt);
                    if(RankInt < MultimaxRank || MultimaxRank == 0) {
                        if(progRankMap != null && progRankMap.get(PrgNum) != null){
                            MultimaxRank = RankInt;
                            MultiheaderProg = progRankMap.get(PrgNum).name;
                            //maxPrgNumber = PrgNum; commented on 2 sep 2015
                        }
                    }
                    
                    
                    
                }
                //this decides the best in these progs for this oli--
                oli.Deal_Program_Name__c = MultiheaderProg;
                
                if(MultimaxRank < maxRank || (maxRank == 0)) {
                    maxRank = MultimaxRank;
                    headerProg = MultiheaderProg;
                    maxPrgNumber = getPrgNumberfromNameMap(MultiheaderProg);
                    
                }
                
            }
            
            else { //This block is for Single Program Products
                string dealStrID = oli.Deal_Program_ID__c;
                
                string rankStr = dealStrID.substring(9);
                string PrgNum = dealStrID.substring(0,8);
                Integer RankInt = integer.valueof(rankStr);
                
                oli.Deal_Program_Name__c = progRankMap.get(PrgNum).name;
                
                if(RankInt < maxRank || maxRank == 0) {
                    
                    if(progRankMap != null && progRankMap.get(PrgNum) != null){
                        
                        maxRank = RankInt;
                        headerProg = progRankMap.get(PrgNum).name;
                        maxPrgNumber = PrgNum;
                    }
                }
                
            }
        }
        
        
        return opplinelist;
        
    }
    
    //Added for 3186 :Jyoti Singh    
    public List<OpportunityLineItem> setEligibleOrSeparateStatus(List<OpportunityLineItem> opplinelist)
    {
        for(OpportunityLineItem oli : opplinelist){ 
            if(oli.Deal_Program_Name__c!=null && oli.Deal_Program_Name__c == headerProg){
                oli.Deal_Registration__c = 'Yes';
                oli.Deal_Program_Eligibility_Status__c='Eligible';
                system.debug('eligible price'+oli.Partner_Sales_Price__c);
                if(oli.UnitPrice!= null&&salesprice!=null)   
                    salesprice = salesprice + oli.UnitPrice;
                else
                    salesprice=oli.UnitPrice;
            }
            
            if(oli.Deal_Program_Name__c!=null && oli.Deal_Program_Name__c != headerProg){
                oli.Deal_Program_Eligibility_Status__c='Separate Program';
                oli.Deal_Registration__c = 'No';
            }
            
            //StatusList.add(oli.Deal_Program_Eligibility_Status__c);
        }
        
        return opplinelist;
    }
    
    //public PageReference progForEachProdCall(){
    public PageReference progForEachProdCall(){ 
        
        System.debug('@@@@Entered progForEachProdCall');
        system.debug('selectedProducts : '+selectedProducts);
        
        List<OpportunityLineItem> oppli = new List<OpportunityLineItem>();
        for(productwrapper pw:selectedProducts){
            if(pw.oppline.Deal_Program_Eligibility_Status__c!='Opt Out')                   
                oppli.add(pw.oppline);
            productPGmap.put(pw.oppline.pricebookentryid,pw.oppline.pricebookentry.product2.product_group__c);
        }
        addProgForEachProd(oppli,false); 
        System.debug('@@@@End of progForEachProdCall');
        return null; 
    }
    
    //AR 3186 : Method : sets eligibility status on opplineItems and sets best Ranking to Opportunity as header prog 
    public void addProgForEachProd(List<OpportunityLineItem> opplinelist,Boolean updateonlysalesprice)
    {   
        getPrdctGrpPrgrmRelation();
        opplinelist = getProgRanks(opplinelist);
        system.debug('opplinelist-getProgRanks---'+opplinelist);
        //block to set Prog status
        opplinelist = getMaxRankAndHeader(opplinelist);
        system.debug('opplinelist-getMaxRankAndHeader---'+opplinelist);
        opplinelist = setEligibleOrSeparateStatus(opplinelist);
        system.debug('opplinelist-setEligibleOrSeparateStatus---'+opplinelist);
        //get max ranked prog
        
        if(!progRankMap.isEmpty() && progRankMap.get(maxPrgNumber) != null && opp.Deal_Registration_Program__c == null){
            
            opp.Deal_Registration_Program__c =  progRankMap.get(maxPrgNumber).id;
            opp.Deal_Program__c = progRankMap.get(maxPrgNumber).Partner_Friendly_Name__c;
        }
        //removed header program ranking comparison as we are considering all progs now.
        if(!progRankMap.isEmpty() && progRankMap.get(maxPrgNumber) != null && opp.Deal_Registration_Program__c != null && (opp.Deal_Registration_Program__c != progRankMap.get(maxPrgNumber).id) ) 
        {
            opp.Deal_Registration_Program__c =  progRankMap.get(maxPrgNumber).id;
            opp.Deal_Program__c = progRankMap.get(maxPrgNumber).Partner_Friendly_Name__c; 
        } 
        
        opp.Partner_Sales_Price__c = salesprice;
        Decimal oppsalesprice;
        if(progRankMap.get(maxPrgNumber)!=null && opp.Partner_Sales_Price__c!=null)
        {
            if(opp.CurrencyIsoCode!=progRankMap.get(maxPrgNumber).CurrencyIsoCode)
            {
                oppsalesprice =opp.Partner_Sales_Price__c*isoCodeToConversionRate.get(progRankMap.get(maxPrgNumber).CurrencyIsoCode);
            }
            else
                oppsalesprice=opp.Partner_Sales_Price__c;                    
            
            if(oppsalesprice!=null){
                if(oppsalesprice>=progRankMap.get(maxPrgNumber).Min_Deal_Value__c&&oppsalesprice<=progRankMap.get(maxPrgNumber).Max_Deal_Value__c){
                    minMaxError=false;
                }
                
            }
        }
        
        try{
            if(minMaxError==false){
                list<opportunitylineitem> existinglineitem=new list<opportunitylineitem>();
                for(opportunitylineitem oppl:opplinelist){
                    if(oppl.id!=null&&!updateonlysalesprice)
                        existinglineitem.add(oppl);
                    
                }
                if(existinglineitem.size()>0)
                {
                    
                    update existinglineitem;
                }
                
                SystemIdUtility.skipOpportunityTriggers = true;
                
                if(opp.Deal_Registration_Program__c!=null)
                {
                    
                    //Added for SuperCare AR 4013 :Sinjy02
                    Deal_Registration_Program__c dProg = [select End_Date__c,Finance_Approver_Email__c,Expiry_Days__c from Deal_Registration_Program__c where id= :opp.Deal_Registration_Program__c];
                    if(opp.Deal_Registration_Program__c != null && oppSalesPrice >=opp.Deal_Registration_Program__r.Min_Deal_Value__c && oppSalesPrice <=opp.Deal_Registration_Program__r.Max_Deal_Value__c)
                    { 
                        opp.MinMaxError__c = false; 
                        system.debug('first if loop '+opp.MinMaxError__c);
                    }
                    
                    else 
                    { 
                        
                        
                        opp.MinMaxError__c = true;
                        
                        system.debug('else loop '+opp.MinMaxError__c);
                    }
                    
                    //sunji03 - if deal reg is approved already, and edit again, remove the close date > end date logic
                    if(opp.CloseDate <= system.today() || ( !opp.Deal_Reg_Initially_Approved__c && opp.CloseDate > (dProg.End_Date__c.addDays(Integer.valueOf(dProg.Expiry_Days__c)))))
                    {
                        opp.isClosedDateFireDealReg__c = true;
                        system.debug('Added flag to true');
                    }
                    else{
                        opp.isClosedDateFireDealReg__c = false;
                        system.debug('Added flag to false');
                    }                  
                    // AR4013
                    
                    if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId()){
                        
                        List<Deal_Reg_Approvers__c> DRAs = [Select Id, Approver__c,Region__c from Deal_Reg_Approvers__c where Deal_Registration_Program__c = : opp.Deal_Registration_Program__c];
                        
                        opportunity oppN = [select Deal_Registration_Submitted_Date__c,Deal_Expiration_Date__c,Deal_Registration_status__c,isPEROpp__c,Finance_Email__c,Rpt_Country__c,isClosedDateFireDealReg__c, Deal_Reg_Initially_Approved__c from opportunity where id=:opp.id];
                        Id geoCheckAccId;
                        if(opp.Type.equalsIgnoreCase('XSP')){
                            geoCheckAccId = Opp.AccountId;
                        }else{
                            geoCheckAccId = Opp.Reseller__c;
                        }
                        account reseller = [select geo__c from account where id =: geoCheckAccId];
                        
                        for(Deal_Reg_Approvers__c DA : DRAs){
                            if(DA.Region__c == reseller.Geo__c){ //XSP chng done add a condition here for them
                                
                                opp.First_Approver__c =  DA.Approver__c;
                                break;
                            }
                        }
                        //sunji03 - don't understand why this piece of logic is repeated!! 
                        //Added for SuperCare
                        if(opp.CloseDate <= system.today() || ( !opp.Deal_Reg_Initially_Approved__c && opp.CloseDate > (dProg.End_Date__c.addDays(Integer.valueOf(dProg.Expiry_Days__c)))))
                        {
                            opp.isClosedDateFireDealReg__c = true;
                            system.debug('Added flag to true');
                        }
                        else{
                            opp.isClosedDateFireDealReg__c = false;
                            system.debug('Added flag to false');
                        }//
                        opp.Finance_Email__c = dProg.Finance_Approver_Email__c;
                        
                        if(dProg.Expiry_Days__c <> null){
                            if(oppN.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dProg.Expiry_Days__c)) < dProg.End_Date__c) {
                                opp.Deal_Expiration_Date__c = oppN.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dProg.Expiry_Days__c));
                            }
                            else {
                                opp.Deal_Expiration_Date__c = dProg.End_Date__c;
                            }
                        } 
                        
                    }else{
                        opp.Finance_Email__c = null;
                        opp.Deal_Expiration_Date__c = null;
                        opp.First_Approver__c = null;
                    }
                }
                if(!approvalStatus && !isPerOpp)
                    update opp;
            }
        }catch(DMLException ex){
            if(ex.getMessage().contains('field integrity exception'))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Opportunity currency is not matching with Product Currency.'));              
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,ex.getMessage()));                                
            }
            else
                ApexPages.addMessages(ex);    
            
            //return null;
        }       
        
    }  
    
    
    public void refreshopp(){
        opp = [select Name,type,isPEROpp__c,Distributor_6__c,recordtype.developername ,Deal_Program__c,Deal_Registration_status__c, Deal_Approval_status__c, RecordTypeId, Recordtype.name, Pricebook2Id,CurrencyISOCode,Registering_on_behalf_of_Partner__c, Reseller_Contact__c ,AccountId,CloseDate,StageName,Probability,ForecastCategory,Reseller__c,Partner_Sales_Price__c, Deal_Registration_Program__c,Deal_Registration_Program__r.Ranking__c,Deal_Registration_Program__r.Name,Deal_Registration_Program__r.Min_Deal_Value__c,Deal_Registration_Program__r.Max_Deal_Value__c,Rpt_Country__c,isClosedDateFireDealReg__c,MinMaxError__c,Account.Enterprise_ID__c, DR_Added_Eligible_Products__c, ResubmissionProducts__c, Deal_Reg_Initially_Approved__c from Opportunity where Id =: strOppId];
        dealprogramName = opp.Deal_Registration_Program__r.Name;
        approvalStatus = (opp.Deal_Registration_Status__c == 'Sale Approved');
    }
    
    //sinjy02
    public string getPrgNumberfromNameMap(string prgName){
        string maxPrgNumbr;
        for(string prgNumbr:progRankMap.keyset()){
            if(progRankMap.get(prgnumbr).name == prgName){
                maxPrgNumbr = prgNumbr;
                system.debug('in for loop getPrgNumberfromNameMap() '+maxPrgNumbr);  
            }
            
        }
        system.debug('in getPrgNumberfromNameMap() '+maxPrgNumbr);
        return maxPrgNumbr;
    }
    //YEDRA01
    public void dealEligibleStatusChange()
    {
        for(productwrapper pw:selectedProducts)
        {
            if(pw.oppline.Deal_Program_Eligibility_Status__c=='Eligible'&&pw.oppline.Deal_Registration__c=='No')
                pw.oppline.Deal_Program_Eligibility_Status__c='Opt Out';
            if(pw.oppline.Deal_Program_Eligibility_Status__c=='Opt Out'&&pw.oppline.Deal_Registration__c=='Yes')
                pw.oppline.Deal_Program_Eligibility_Status__c='Eligible';
        }
    }
    
    //MANAR08
    public PageReference redirectToDetailPage(){
        
        PageReference pref  = new pagereference(apexpages.currentpage().getparameters().get('retURL'));
        return pref;
    }
    public pageReference resetIsOverrideChecked(){
        productwrapper prdclass = selectedProducts[pos];
        prdclass.greyout = true;
        selectedProducts[pos] = prdclass;
        return null;
    }
    
    public void getMonthsBetween() 
    {
        
        productwrapper prdclass = selectedProducts[pos];
        OpportunityLineItem oli = prdclass.oppline;
        productclass prd = new productclass();
        startdate = oli.start_Date__c;
        enddate = oli.End_Date__c;
        oldTermMonth = Integer.valueOf(oli.Term_Month__c);
        system.debug('prdclass.oppli>>'+oli);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            prdclass.dateErrorExists = true;
            selectedProducts[pos] = prdclass;
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
            
            //SAMTU01 US406520
            
            IF( oli.Stretch_Duration__c == NULL ||  oli.Stretch_Duration__c == 0)
            {
                
                oli.Stretch_Duration__c = oli.Term_Month__c;
            }
            if(oli.Stretch_Duration__c< oli.Term_Month__c){
                oli.Stretch_Duration__c = oli.Term_Month__c;
                //commented by samap01 nov 9-no message to be shown if partner
                if(!isPartner)
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info,'Stretch Duration must be greater than or equal to Term Month.  Stretch Duration adjusted.');
                    ApexPages.addMessage(msg); 
                }
                
                
            }
            decimal totalMaint;   
            Decimal totStretch = (oli.Stretch__c<> null? oli.Stretch__c: 0);
            Decimal StretchDurationInYears =   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c/12 : 0); 
            Decimal StretchDurationInMonths1=   (oli.Stretch_Duration__c<> null? oli.Stretch_Duration__c: 0);
            
            Decimal StretchLicenseFee = 0;
            if(opp.Rpt_Country__c !=null && opp.Rpt_Country__c==Label.Korea_Country_Name){
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
                
                oli.Stretch_License_Fee__c=0; // US461584 -- merha02
                oli.Stretch_Total_Maintenance__c= 0;            
            }
            else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
            {
                
                oli.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
                oli.Stretch_Total_Maintenance__c= totalMaint.setScale(2); 
                
            }
            
            //SAMTU01 US406520  end   
            //samtu01 -revrec -US417414
            System.debug('line 3316');
            oli =  LicenseClassificationMapper.LicenseClassifcationset(oli,prdclass.strbu,prdclass.strlicenseclassification);
            prdclass.strlicenseclassification =LicenseClassificationMapper.licclassification;
            //prd.oppli=oli;
            
            //samtu01 -revrec -US417414 - end
            prdclass.oppline = oli;
            selectedProducts[pos] = prdclass;
        }
        
    }
    
    public void refreshonc(){
    }
    //SAMTU01 US406520 
    public void calculateStretch(){ 
        productwrapper prdclass = selectedProducts[pos];
        OpportunityLineItem oli = prdclass.oppline;
        system.debug('prdclass.oppli>>'+oli);
        decimal totStretch; 
        Decimal StretchLicenseFee = (oli.Stretch_License_Fee__c<> null? oli.Stretch_License_Fee__c: 0);
        Decimal StretchMaintFee =  (oli.Stretch_Total_Maintenance__c<> null? oli.Stretch_Total_Maintenance__c: 0); 
        totStretch = StretchLicenseFee + StretchMaintFee ;
        oli.Stretch__c= totStretch;
        prdclass.oppline = oli;
        selectedProducts[pos] = prdclass;
    }
    //SAMTU01 US406520 END  
}