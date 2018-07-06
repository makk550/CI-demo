/*
* Test Class - OppLineItem_View_Edit_Controller_Test
* Updated by BAJPI01
* Coverage - 78%
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       09/10/2017       US377325        RevRec: SFDC Opportunity Prices Likely to Close 
* SAMAP01       16/10/2017       US370554        RevRec: SFDC Opportunity License Classification for non renewal products
* ********************************************************************************************/

public class OppLineitem_View_Edit_controller
{
    public string salesPrice_usd {get;set;}
    // fy13    public string comfort_usd {get;set;} 
    public string actiontitle {get;set;}
    public string actionsubtitle {get;set;}
    
    private String strOppLineID = '';
    private String ProdId = '';
    private OpportunityLineItem lineitemrecord;
    private Map<Id,Product2> prdmap;
    private String stroppid = '';
    private Integer oldTermMonth;
    private boolean haserror;
    public boolean show_ondemand {get;set;}
    public OpportunityLineItem lineitemrec {get;set;}
    public Opportunity headerrec {get;set;}
    public Boolean isRenewal {get;set;}
    public Boolean isProduct {get;set;}
    
    public String prdfamily {get;set;}
    
    public Boolean isUF {get;set;}
    
    
    public String prdbu {get;set;}
    public String prdname {get;set;}
    public String replace_expirydate_label {get;set;}
    public Boolean isView {get;set;}
    public Boolean isEdit {get;set;}
    public Boolean isclosedlost {get;set;}
    public Boolean showreason {get;set;}
    public Boolean otherreason {get;set;}
    
    public Boolean isViewOfferings {get;set;}
    public Boolean isEditOfferings {get;set;}
    public Boolean isOffering {get;set;}
    public Boolean isServices {get;set;}
    public Boolean isEducation {get;set;}
    public Boolean isSupport {get;set;}
    
    public Boolean isCompetitorRequired {get;set;}
    public Boolean isWinLoss {get;set;}
    public Boolean isDeallostTo {get;set;}
    public List<SelectOption> selbustype {get;set;}
    public List<SelectOption> selcloudplatformuse {get;set;}
    public String bustype {get;set;}
    public String mfcapbustype {get;set;}//samtu01 US398729
    public String lictype {get;set;}  
    public List<SelectOption> selLicType {get;set;}      
    public String cloudplatformuse {get;set;}
    public Boolean showmilestone {get;set;}
    public Boolean isMainFrame {get;set;}
    
    public List<Active_Contract_Product__c>  ACPLineItems = new List<Active_Contract_Product__c>();      
    
    public List<SelectOption> cldplatformuse_entries = new List<SelectOption>();
    
    public Id oppId {get;set;}        // fy13
    public String oppName {get;set;}  // fy13
    
    public Date startdate {get;set;}    //BAJPI01 - US326192
    public Date enddate {get;set;}      //BAJPI01 - US326192
    
    
    private List<OpportunityLineItem> allLineItems = new List<OpportunityLineItem>();        //BAJPI01 - US326192
    Set<String> Businesstype = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'}; //BAJPI01 - US326192
        private List<OpportunityLineItem> renewalmainframelineitems = new List<OpportunityLineItem>();  //BAJPI01 - US326192 - for uniform update of start/end date on opp header
    

    public Decimal stretchduration {get;set;}//SAMTU01
    public String license {get;set;} //SAMTU01 - US392086
    
    //SAMTU01 - US392086
    //samap01- revrec  US370554
    public String licclassification {get;set;}   
    public String strbu {get;set;} 
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
   
    //samap01 end
    
    
    public list<SelectOption> LicenseType {
        get{
            list<SelectOption> st= new list<SelectOption>();         
            
            Schema.DescribeFieldResult lctypevalues = OpportunityLineItem.License__c.getDescribe();
            Schema.PicklistEntry[] entries_temp = lctypevalues.getPicklistValues();
            
            st.add(new SelectOption('Ratable','Ratable'));
            st.add(new SelectOption('Subscription','Subscription'));
            
            
            return st;
        }
        set; }
    //SAMTU01 US392086 -end
    ////SAMTU01 - US398729
    public list<SelectOption> BusinessTypeList {
        get{
            list<SelectOption> st= new list<SelectOption>();         
            
            Schema.DescribeFieldResult lctypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
            Schema.PicklistEntry[] entries_temp = lctypevalues.getPicklistValues();  
            st.add(new SelectOption(lineitemrec.Business_Type__c,lineitemrec.Business_Type__c));
            if(lineitemrec.Business_Type__c !='MF Capacity')
            st.add(new SelectOption('MF Capacity','MF Capacity'));
            if(lineitemrec.Business_Type__c !='MF Capacity Overage')
            st.add(new SelectOption('MF Capacity Overage','MF Capacity Overage'));
                      
            return st;
        }
        set; }
    //SAMTU01 US398729 -end
    
    public OppLineitem_View_Edit_controller(ApexPages.Standardcontroller stdcontroller)
    {
        stroppid = ApexPages.currentPage().getParameters().get('retURL');
        
        System.debug(stroppid);
        //incase returnurl is present, means its an edit
        haserror=false;
        if(stroppid !=null)
        {
            isEdit = true;
            isView = false;
            
        }   
        else
        {
            isEdit = false;
            isView = true;
        }   
        //get lineitem id    
        strOppLineID = ApexPages.currentPage().getParameters().get('id');
        System.debug('samap01- strOppLineID'+ strOppLineID);
        lineitemrecord = new OpportunityLineItem();
        //fetch the lineitem details
        lineitemrecord = [SELECT OpportunityId,License__c,Stretch__c,UF_License_Fee__c,X1st_Year_Maintenance__c,Business_Type__c,
                          Quote_Number__c,Contract_Number__c,Quantity, ListPrice,Override_Fees__c,
                          PriceBookEntry.UnitPrice,Sales_Price_USD__c, PricebookEntry.Name,PricebookEntry.product2Id,
                          License_Classification__c,License_Classification_Override__c,Business_Unit__C, //samap01 -Revrec -370554
                          CurrencyISOCode,Corporate_ARR__c,Start_Date__c,End_Date__c,Duration_Days__c,Stretch_Corporate_ARR__c,Commissionable_BU__c,Stretch_Total_Maintenance__c,Stretch_License_Fee__c,Opportunity.Rpt_Country__c,Stretch_Duration__c,Opportunity.Stretch_Deal_Term_Months__c //SAMTU01 
                          FROM OpportunityLineItem 
                          where ID=:strOppLineID
                          and Business_Type__c != 'Renewal' ];
        String prdid = lineitemrecord.PricebookEntry.product2Id;
        
        system.debug('----duration----'+lineitemrecord.Duration_Days__c);
        
        headerrec = [select Id, Name, New_Deal_Term_months__c, Stretch_Deal_Term_Months__c, StageName,Start_Date__c,End_Date__c, 
                     Stretch_Sales_Price_Gap_Reason__c,Rpt_Country__c,CloseDate,RecordTypeId, Recordtype.name,
                     Reason_duration_is_1_year__c,Status_at_end_of_term__c,
                     (select id, Business_Type__c, OpportunityId, UnitPrice,Corporate_ARR__c,Duration_Days__c,Stretch_Corporate_ARR__c,Commissionable_BU__c,
                      Stretch__c, Sales_Price_USD__c, Term_Month__c, New_Deal_Term_Months__c,Start_Date__c,End_Date__c,
                      License_Classification__c,Stretch_Duration__c,License_Classification_Override__c,Business_Unit__C  //samap01
                      from OpportunityLineItems where Business_Type__c in:Businesstype)
                     from Opportunity where Id =: lineitemrecord.OpportunityId]; // fy13
        
        //US326192 - BAJPI01
        allLineItems = headerrec.OpportunityLineItems;
        //US326192 - BAJPI01
        
        if(allLineItems!=null && allLineItems.size()>0){
            for(OpportunityLineItem oli:allLineItems){
                if(oli.Business_Type__c=='Renewal')
                    renewalmainframelineitems.add(oli);
            }
        }
        
        
        salesPrice_usd = String.ValueOf(lineitemrecord.Sales_Price_USD__c);
        //comfort_usd = String.ValueOf(lineitemrecord.comfort_USD__c);
        //get product details
        Product2 oppprd = [select Name,Family,Market_Focus_Area__c,Upfront_Revenue_Eligible__c from Product2 where Salesforce_CPQ_Product__c=false and Id =: prdid];
        prdfamily = oppprd.Family; 
        system.debug('oppprd --> ' + oppprd );
        
        prdbu = oppprd.Market_Focus_Area__c;
        system.debug('prdbu --> ' + prdbu );
        
        prdname = oppprd.Name;
        
        
        if(stroppid!=null && stroppid.contains('/apex/'))
            stroppid = '/'+lineitemrecord.OpportunityId;
        //set all flags
        if(prdfamily.toLowerCase() == 'product')
        {
            actiontitle = 'Add/Edit Products';
            actionsubtitle = 'Product Details';
            replace_expirydate_label = 'Replace';
            isProduct = true;
            isRenewal = false;
            isOffering = false;
            showmilestone = false;
            isMainFrame = false;
            
            if(oppprd.Upfront_Revenue_Eligible__c == 'Yes') 
            {
                isUF = true;               
            }            
        }
        else if(prdfamily.toLowerCase() == 'renewal' || prdfamily.tolowercase() == 'time' || prdfamily.tolowercase() == 'mainframe capacity')
        {
            actiontitle = 'Edit Renewing Products';
            actionsubtitle = 'Renewal Details';
            replace_expirydate_label = 'Original Expiration Date';
            isProduct = false;
            isRenewal = true;
            isOffering = false;
            showmilestone = false;
            isMainFrame = false;
        }
        else if(prdfamily.toLowerCase() == 'services' || prdfamily.toLowerCase() == 'education' || prdfamily.toLowerCase() == 'support')
        {
            actiontitle = 'Add/Edit Offerings';
            if(prdfamily.toLowerCase() == 'services')
            {
                isServices = true;
                isEducation = false;
                isSupport = false;
                showmilestone = true;
                actionsubtitle = 'Services Details';
            }
            else if(prdfamily.toLowerCase() == 'education')
            {
                isServices = false;
                isEducation = true;
                isSupport = false;
                showmilestone = true;
                actionsubtitle = 'Education Details';
            }
            else if(prdfamily.toLowerCase() == 'support')
            {
                isServices = false;
                isEducation = false;
                isSupport = true;
                showmilestone = false;
                actionsubtitle = 'Support Details';
            }
            isProduct = false;
            isRenewal = false;
            isOffering = true;
            isEdit = false;
            isView = false;
            isMainFrame = false;
            if(stroppid !=null)
            {
                isEditOfferings = true;
                isViewOfferings = false;
            }
            else
            {
                isEditOfferings = false;
                isViewOfferings = true;
            }   
        }
        
       
        this.lineitemrec = (OpportunityLineItem)stdController.getRecord();
        if(lineitemrec.Start_Date__c==null && lineitemrec.End_Date__c==null){
            if(headerrec.Start_Date__c!=null && headerrec.End_Date__c!=null){
                lineitemrec.Duration_Days__c = headerrec.Start_Date__c.daysBetween(headerrec.End_Date__c)+1;
                
                lineitemrec.Term_Month__c = ARRandDurationCalculation.monthsbetweendates(headerrec.Start_Date__c, headerrec.End_Date__c);
                //SAMTU01
                System.debug(' samap01 lstoppoli[k].StretchDuration__c' +lineitemrec.Stretch_Duration__c);
                IF( lineitemrec.Stretch_Duration__c == NULL ||  lineitemrec.Stretch_Duration__c == 0 )
                    lineitemrec.Stretch_Duration__c =  lineitemrec.Term_Month__c;                        
                //samap01 --END
                if(lineitemrec.Business_Type__c=='Renewal'||lineitemrec.Business_Type__c=='MF Capacity'){
                    lineitemrec.New_Deal_Term_Months__c = lineitemrec.Term_Month__c;
                }   
            }
        }
        
       
        if(lineitemrec.Start_Date__c==null)
            lineitemrec.Start_Date__c = headerrec.Start_Date__c;
        if(lineitemrec.End_Date__c==null)
            lineitemrec.End_Date__c = headerrec.End_Date__c;
        fetchbusinesstype();
        fetchLicenseType();
        if(ismainframe)
        mfcapbustype = lineitemrecord.Business_Type__c; //samtu01 US398729   
        else
        bustype = lineitemrecord.Business_Type__c;
        lictype = lineitemrecord.License__c;
        licclassification = lineitemrecord.License_Classification__c;   //SAMAP01-REVREC -US370554
        strbu = lineitemrecord.Business_Unit__C; //samap01
        //SAMTU01
        if(lineitemrecord.Stretch_Duration__c == null || lineitemrecord.Stretch_Duration__c == 0)
            lineitemrec.Stretch_Duration__c = lineitemrec.Term_Month__c;
        //SAMAP01 -Revrec-US377325
        System.debug(' samap01 Stretch_Duration__c' +lineitemrec.Stretch_Duration__c);
        if(lineitemrec.Business_Type__c !='Renewal' && lineitemrec.Business_Type__c !='MF Capacity')
        {
            IF( lineitemrec.Stretch_Duration__c == NULL ||  lineitemrec.Stretch_Duration__c == 0 )
                lineitemrec.Stretch_Duration__c =  lineitemrec.Term_Month__c;        
            
        }
        else
        {
            lineitemrec.Stretch_Duration__c= 0;
        }
        //SAMAP01 -Revrec-US377325 -end
        //SAMTU01 - US392086
        if(isMainFrame)
        {
            IF( lineitemrecord.License__c == NULL ||  lineitemrecord.License__c == '' ) 
            {
                lineitemrecord.License__c = 'Ratable';
                
            } 
            license = lineitemrecord.License__c; 
                   }
        //SAMTU01 - US392086 -end 
      
        
        if(isproduct)
        {
            List<Products_for_On_Demand__c> lst_Ondemand = Products_for_On_Demand__c.getall().values();
            Set<string> set_ondemand = new Set<string>{};
                
                for(Products_for_On_Demand__c   pod:lst_Ondemand)
                set_ondemand.add(pod.product__c.toLowerCase());
            show_ondemand =   set_ondemand.contains(prdname.toLowerCase());
            
        }
        
        if(prdfamily.tolowercase() == 'mainframe capacity' && prdname.tolowercase()== 'mainframe capacity') 
        {                          
            actiontitle = 'Add/Edit Mainframe Capacity';
            actionsubtitle = 'Mainframe Capacity Details';
            isProduct = false;                          
            isRenewal = false;                          
            isOffering = false;                          
            showmilestone = false;                
            isMainFrame = true;                
            
        }
    }
    
    public pageReference resetIsOverrideChecked(){ //Added for 3798 :Sinjy02
        
        return null;
    }
    
    public void CalcSalesPrice(){ //Added for 3798 :Sinjy02
        
        OpportunityLineItem oli = lineitemrec;
        decimal totUnitPrice; 
        Decimal totalUfFee = (oli.UF_License_Fee__c <> null? oli.UF_License_Fee__c : 0);
        Decimal totalLicenseFee =   (oli.Total_Maintenance__c <> null? oli.Total_Maintenance__c : 0); 
        totUnitPrice = totalUfFee + totalLicenseFee ;
        
        oli.unitPrice  = totUnitPrice;
       
        //SAMAP01-REVREC -US370554 -start
        lictype = oli.License__c;
        oli = LicenseClassificationMapper.LicenseClassifcationset(oli,strbu,licclassification); //samap01 -revrec-US370554
         licclassification = LicenseClassificationMapper.licclassification;
    
        //samap01 --end
        lineitemrec = oli;
        //return null;
    }
    //SAMTU01 US387241
    public void calculateStretch(){ 
        
        OpportunityLineItem oli = lineitemrec;
        system.debug('prdclass.oppli>>'+oli);
        decimal totStretch; 
        Decimal StretchLicenseFee = (oli.Stretch_License_Fee__c<> null? oli.Stretch_License_Fee__c: 0);
        Decimal StretchMaintFee =  (oli.Stretch_Total_Maintenance__c<> null? oli.Stretch_Total_Maintenance__c: 0); 
        totStretch = StretchLicenseFee + StretchMaintFee ;
        oli.Stretch__c= totStretch;
        
        lineitemrec = oli;
        //return null;
    }
    
    public void StretchFeeCalc(){
        System.debug('in stretchfee calc');
        
        // OpportunityLineItem oli = lineitemrec;
        Opportunity oli = headerrec;
        decimal totStretchMaint; 
        
        Decimal totStretch = (lineitemrec.Stretch__c <> null? lineitemrec.Stretch__c : 0);
        Decimal StretchtermInYears =   (oli.Stretch_Deal_Term_Months__c<> null? oli.Stretch_Deal_Term_Months__c/12 : 0); 
        Decimal StretchtermInMonths =   (oli.Stretch_Deal_Term_Months__c<> null? oli.Stretch_Deal_Term_Months__c: 0);
        
        Decimal StretchLicenseFee = 0;
        //System.debug('---------opp.Rpt_Country__c--------'+opp.Rpt_Country__c);
        if(oli.Rpt_Country__c == Label.Korea_Country_Name){
            if(StretchtermInMonths <> 0){
                StretchLicenseFee =  (totStretch/((0.1364/12*StretchtermInMonths)+1));
                System.debug('----StretchLicenseFee-----'+StretchLicenseFee);
                
            }
            totStretchMaint=  0.1364 * StretchLicenseFee/12 * StretchtermInMonths ; 
        }
        else {
            if(StretchtermInYears<> 0){
                StretchLicenseFee  = (10 *  totStretch ) /  (10 + 2 * StretchtermInYears);      
            }
            totStretchMaint  =  0.2 * StretchLicenseFee * StretchtermInYears ;
            
        }           
        
        Decimal FirstYearMaint1 = 0;
        if(StretchtermInYears<> 0)
            FirstYearMaint1 = totStretchMaint / StretchtermInYears;
        
        if(lineitemrec.License__c == 'Subscription')
        {
            //lineitemrec.Stretch_License_Fee__c = lineitemrec.Stretch__c;
            lineitemrec.Stretch_License_Fee__c = 0; // US461584 -- merha02
            lineitemrec.Stretch_Total_Maintenance__c = 0;  
            
        }
        else if(lineitemrec.License__c == 'Ratable')
        {
            lineitemrec.Stretch_License_Fee__c = StretchLicenseFee.setScale(2);
            //System.debug('------- oli.UF_License_Fee__c-----'+ oli.UF_License_Fee__c);
            lineitemrec.Stretch_Total_Maintenance__c = totStretchMaint.setScale(2); 
            
        }
        //
        startdate = lineitemrec.start_Date__c;
        enddate = lineitemrec.End_Date__c;
        // system.debug('opplineitem>>'+oppLineItem);
        // system.debug('start date---'+startdate);
        //system.debug('end date---'+enddate);
        Decimal n = 0.00;
        Decimal totprice;
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            haserror =true;
        }
        else{
            haserror=false;
            totprice = lineitemrec.UnitPrice;
            if(startdate!=null && enddate!=null){
                lineitemrec.Duration_Days__c = startdate.daysBetween(enddate) + 1;
                n = ARRandDurationCalculation.monthsbetweendates(startdate,enddate);
                lineitemrec.Term_Month__c = n;
            }  
            else{
                lineitemrec.Term_Month__c = 0;
                lineitemrec.Duration_Days__c = 0;
            }
        }
        Decimal totMaint;   
        Decimal totSalesPrice = (lineitemrec.UnitPrice <> null? lineitemrec.UnitPrice : 0);
        System.debug('lineitemrec.Term_Month__c'+lineitemrec.Term_Month__c);
        Decimal termInYears =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c /12 : 0);     
        Decimal termInMonths =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c  : 0);
        Decimal UFLicenseFee = 0;
        startdate = lineitemrec.start_Date__c;
        enddate = lineitemrec.End_Date__c;
        lineitemrec.Duration_Days__c = startdate.daysBetween(enddate)+1;
        if(headerrec.Rpt_Country__c !=null&&headerrec.Rpt_Country__c==Label.Korea_Country_Name){
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
        
        if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription')
        {
            
            lineitemrec.UF_License_Fee__c =0; // US461384 -- merha02
            lineitemrec.Total_Maintenance__c = 0;            
        }
        else if(lineitemrec.License__c == 'Upfront' || lineitemrec.License__c == 'Ratable')
        {
            lineitemrec.UF_License_Fee__c = UFLicenseFee.setScale(2);
            lineitemrec.Total_Maintenance__c = totMaint.setScale(2);            
        }
        
        System.debug('samap01 lineitemrec.License__c' + lineitemrec.License__c);     
        System.debug('samap01 lineitemrec.License_Classification_Override__c' + lineitemrec.License_Classification_Override__c);      
        System.debug('samap01 lineitemrec.Business_Type__c' + lineitemrec.Business_Type__c);     
        System.debug('samap01 lineitemrec.Business_Unit__c' + lineitemrec.Business_Unit__c);    
        // lineitemrec.License_Classification_Override__c =licclassification;
        lineitemrec = LicenseClassificationMapper.LicenseClassifcationset(lineitemrec,strbu,licclassification); //samap01 -revrec-US370554
         licclassification = LicenseClassificationMapper.licclassification;
        System.debug('samap01-licclassification'+licclassification);
       
        
    } //addedby samtu01 - US392086 end
    public void fetchLicenseType()
    {
        selLicType = new List<SelectOption>();
        
        Schema.DescribeFieldResult licTypeValues = OpportunityLineItem.License__c.getDescribe();
        for(Schema.PicklistEntry entry : licTypeValues.getPicklistValues())
        {
            selLicType.add(new SelectOption(entry.getLabel(),entry.getValue()));
        }
    }    
    
    public void fetchbusinesstype()
    {
        selbustype = new List<SelectOption>();
        selbustype.add(new SelectOption('--Select--','--Select--'));
        
        Schema.DescribeFieldResult bustypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
        for(Schema.PicklistEntry entry : bustypevalues.getPicklistValues())
        {
            //business type to be restricted to particular values for products and renewals
            if(prdfamily.toLowerCase() == 'renewal' || prdfamily.tolowercase() == 'time' || prdfamily.tolowercase() == 'mainframe capacity')
            {
                if(entry.getValue() == 'Renewal' || entry.getValue() == 'Medium Touch' || entry.getValue() == 'Indirect Medium Touch')
                    selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
            }
            else if(prdfamily.toLowerCase() == 'product' || prdfamily.toLowerCase() == 'support')
            {
                if(entry.getValue() == 'New' || entry.getValue() == 'Time' || entry.getValue() == 'Maintenance')
                    selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                
                if(entry.getValue() == 'Capacity' || entry.getValue() == 'Upgrade' )
                {
                    if(prdfamily.toLowerCase() == 'product')
                    {
                        if(prdbu.toLowerCase() != 'mainframe')
                            selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                    else
                        selbustype.add(new SelectOption(entry.getLabel(),entry.getValue()));
                }       
                
            }
        }
        
    }
    public PageReference updateproduct()
    {          
        
        //if all fields are not populated, display error message
        List<GroupMember> userInOppAdminGroup = [select Id from GroupMember 
                                                 where groupid = :label.Opportunity_Admin_Edit_For_Closed_Opps_Id AND UserOrGroupId = :UserInfo.getUserId()];
        if(haserror){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Start Date cannot be greater than or equal to End Date.');
            ApexPages.addMessage(msg);
            return null;
        }  
        else if(isMainframe && headerrec.New_Deal_Term_Months__c!=null && headerrec.New_Deal_Term_Months__c<12 && (headerrec.Reason_duration_is_1_year__c == null || headerrec.Status_at_end_of_term__c == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
            return null;
        }
        else if(userInOppAdminGroup.size() == 0 && headerrec.CloseDate.daysbetween(System.Date.Today())>=14){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
            return null;
        }else if(userInOppAdminGroup.size() != 0 && headerrec.CloseDate.daysbetween(System.Date.Today())>=14 && headerrec.StageName == label.Opp_Stage_Closed_Lost){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
            return null;
        }
        else{
            if(lineitemrec.UnitPrice!=null)
            {
                if(bustype != '--Select--' && isMainframe!=true)
                    lineitemrec.Business_Type__c = bustype;
                else if(isMainframe==true) //SAMTU01 - US398729
                    lineitemrec.business_type__c=mfcapbustype; //SAMTU01 - US398729
                else
                {
                    //lineitemrec.Business_Type__c = null;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please select the Business Type.');
                    ApexPages.addMessage(msg);
                    return null;
                }
                
                //if(isProduct)
                {
                    lineitemrec.License_Type__c = lictype;
                }
                // samap01 -revrec start
               
               lineitemrec =  LicenseClassificationMapper.LicenseClassifcationset(lineitemrec,strbu,licclassification); //samap01 -revrec-US370554
                licclassification = LicenseClassificationMapper.licclassification;
                //samap01 - revrec end 
                System.debug('samap01 lineitemrec.License_Classification_Override__c' + lineitemrec.License_Classification_Override__c); 
                
                if(isMainframe){
                    
                    // fy13 - BR165 - default stretch amount if not specified
                    if(lineitemrec.Stretch__c == null || lineitemrec.Stretch__c < lineitemrec.UnitPrice){
                        lineitemrec.Stretch__c = lineitemrec.UnitPrice;
                        calculateUFLicenseFee();//SAMTU01
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Stretch is required and must be greater than or equal to Sales Price.  Stretch value adjusted.'));
                        return null;
                    }
                    
                    // fy13 - BR165 - default stretch deal term if not specified
                    if(headerrec.Stretch_Deal_Term_Months__c == null || headerrec.Stretch_Deal_Term_Months__c == 0)
                    {
                        headerrec.Stretch_Deal_Term_Months__c = headerrec.New_Deal_Term_months__c;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Stretch Deal Term is required. Stretch Deal Term value adjusted to New Deal Term.'));
                        return null;
                        
                    }
                }
                
                if(!isRenewal && ! isProduct ) //to exclude re-newals and products from this check
                {                
                    //lineitemrec.Win_Loss_Reason__c = null;
                }
                
                
                //allha02  AR3576
                if(lineitemrec.Stretch__c == null || lineitemrec.Stretch__c < lineitemrec.UnitPrice ) {
                    lineitemrec.Stretch__c = lineitemrec.UnitPrice;
                    calculateUFLicenseFee();//samtu01 - US387241
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Stretch is required and must be greater than or equal to Sales Price.  Stretch value adjusted.'));
                    return null;
                }
                //SAMTU01
                //samap01- revrec
                if(lineitemrec.Business_Type__c !='Renewal' && lineitemrec.Business_Type__c !='MF Capacity')
                {
                    if(lineitemrec.Stretch_Duration__c == null || lineitemrec.Stretch_Duration__c < lineitemrec.Term_Month__c ) {
                        lineitemrec.Stretch_Duration__c = lineitemrec.Term_Month__c;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Stretch Duration is required and must be greater than or equal to Term Month.  Stretch Duration adjusted.'));
                        return null;
                    }
                }
                
                mfcapbustype = lineitemrec.business_type__c;
                try{
                    update lineitemrec;
                }catch(Exception ex){
                    ApexPages.addMessages(ex);
                    return null;
                }
                finally{
                    
                    if(ApexPages.hasMessages(ApexPages.Severity.ERROR))
                        return null;
                }
                // fy13 - BR165 - update at opportunity level is required to handle stretch term and reason
                if(isMainframe){
                    try{
                        update headerrec;
                    }catch(Exception ex){
                        ApexPages.addMessages(ex);
                        return null;
                    }
                }
                
                
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please complete the details.');
                ApexPages.addMessage(msg);
                return null;
            }
            PageReference pref = new PageReference(stroppid);
            pref.setRedirect(true);
            return pref;
        }
    }
    public PageReference dodelete()
    {
        String opid = lineitemrecord.OpportunityId;
        delete lineitemrec;
        PageReference pref = new PageReference('/'+opid);
        pref.setRedirect(true);
        return pref;
    }
    
    public PageReference docancel()
    {
        if(stroppid == null || stroppid == '')
            stroppid = '/'+lineitemrecord.OpportunityId;
        PageReference pref = new PageReference(stroppid);
        pref.setRedirect(true);
        return pref;
    }
    
    
    public boolean inIt{get;set;}
    
    public void calculateUFLicenseFee()
    {
        
        Decimal totMaint;   
        Decimal totSalesPrice = (lineitemrec.UnitPrice <> null? lineitemrec.UnitPrice : 0);
        Decimal termInYears =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c /12 : 0);     
        Decimal termInMonths =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c  : 0);
        Decimal UFLicenseFee = 0;
        startdate = lineitemrec.start_Date__c;
        enddate = lineitemrec.End_Date__c;
        if(startdate!=null && enddate!=null){
            lineitemrec.Duration_Days__c = startdate.daysBetween(enddate)+1;
        }
        
        if(headerrec.Rpt_Country__c !=null&&headerrec.Rpt_Country__c==Label.Korea_Country_Name){
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
        
        if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription')
        {
            
            lineitemrec.UF_License_Fee__c =0; // US461384 -- merha02
            lineitemrec.Total_Maintenance__c = 0;            
        }
        else if(lineitemrec.License__c == 'Upfront' || lineitemrec.License__c == 'Ratable')
        {
            lineitemrec.UF_License_Fee__c = UFLicenseFee.setScale(2);
            lineitemrec.Total_Maintenance__c = totMaint.setScale(2);            
        }
        system.debug('---duration----'+lineitemrec.Duration_Days__c);
        

        //SAMTU01 US387241
        
        decimal totalMaint;   
        Decimal totStretch = (lineitemrec.Stretch__c<> null? lineitemrec.Stretch__c: 0);
        Decimal StretchDurationInYears =   (lineitemrec.Stretch_Duration__c<> null? lineitemrec.Stretch_Duration__c/12 : 0); 
        Decimal StretchDurationInMonths1=   (lineitemrec.Stretch_Duration__c<> null? lineitemrec.Stretch_Duration__c: 0);
        
        Decimal StretchLicenseFee = 0;
        if(lineitemrec.Opportunity.Rpt_Country__c !=null && lineitemrec.Opportunity.Rpt_Country__c==Label.Korea_Country_Name){
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
        
        if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription')
        {
            //lineitemrec.Stretch_License_Fee__c= lineitemrec.Stretch__c;
            lineitemrec.Stretch_License_Fee__c = 0; // US461584 -- merha02
            lineitemrec.Stretch_Total_Maintenance__c= 0;            
        }
        else if(lineitemrec.License__c == 'Upfront' || lineitemrec.License__c == 'Ratable')
        {
            lineitemrec.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
            lineitemrec.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
        }
        
        //SAMTU01 US387241 end
        //SAMAP01-REVREC -US370554 -start
        lictype = lineitemrec.License__c; 
        lineitemrec =LicenseClassificationMapper.LicenseClassifcationset(lineitemrec,lineitemrec.Business_Unit__c,lineitemrec.License_Classification_Override__c); //samap01 -revrec-US370554
         licclassification = LicenseClassificationMapper.licclassification;
        //       lineitemrec.License_Classification_Override__c =LicenseClassificationMapper.licclassification;
       
//samap01 --end*/
    }
    
    //to update start/end date and arr value on line item. Called from new product edit button. BAJPI01
    public void getMonthsBetween() 
    {
        decimal n = 0.0;
        startdate = lineitemrec.start_Date__c;
        enddate = lineitemrec.End_Date__c;
        oldTermMonth = Integer.valueOf(lineitemrec.Term_Month__c);
        system.debug('lineitemrec>>'+lineitemrec);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            haserror = true;
        }
        else{
            haserror = false;
            if(Startdate!=null && enddate!=null){
                lineitemrec.Duration_Days__c = startdate.daysBetween(enddate)+1;
                n = ARRandDurationCalculation.monthsbetweendates(startdate, enddate);
                lineitemrec.Term_Month__c = n;
                if(isRenewal||isMainframe)
                    lineitemrec.New_Deal_Term_Months__c = n;
                
            }
            
            Decimal totSalesPrice = (lineitemrec.UnitPrice <> null? lineitemrec.UnitPrice : 0);
            
            if(lineitemrec.Term_Month__c!=oldTermMonth){
                decimal totMaint;   
                
                Decimal termInYears =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c /12 : 0); 
                Decimal termInMonths =   (lineitemrec.Term_Month__c <> null? lineitemrec.Term_Month__c  : 0);
                
                Decimal UFLicenseFee = 0;
                if(headerrec.Rpt_Country__c !=null&&headerrec.Rpt_Country__c==Label.Korea_Country_Name){
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
                
                if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription')
                {
                   
                    lineitemrec.UF_License_Fee__c =0; // US461384 -- merha02
                    lineitemrec.Total_Maintenance__c = 0;            
                }
                else if(lineitemrec.License__c == 'Upfront' || lineitemrec.License__c == 'Ratable')
                {
                    lineitemrec.UF_License_Fee__c = UFLicenseFee.setScale(2);
                    lineitemrec.Total_Maintenance__c = totMaint.setScale(2);            
                }
            }
            
            //SAMTU01 US387241
            
            decimal totalMaint;   
            Decimal totStretch = (lineitemrec.Stretch__c<> null? lineitemrec.Stretch__c: 0);
            Decimal StretchDurationInYears =   (lineitemrec.Stretch_Duration__c<> null? lineitemrec.Stretch_Duration__c/12 : 0); 
            Decimal StretchDurationInMonths1=   (lineitemrec.Stretch_Duration__c<> null? lineitemrec.Stretch_Duration__c: 0);
            
            Decimal StretchLicenseFee = 0;
            if(lineitemrec.Opportunity.Rpt_Country__c !=null && lineitemrec.Opportunity.Rpt_Country__c==Label.Korea_Country_Name){
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
            
            if(lineitemrec.License__c == 'SAAS' || lineitemrec.License__c == 'Subscription')
            {
                //lineitemrec.Stretch_License_Fee__c= lineitemrec.Stretch__c;
                lineitemrec.Stretch_License_Fee__c = 0; // US461584 -- merha02
                lineitemrec.Stretch_Total_Maintenance__c= 0;            
            }
            else if(lineitemrec.License__c == 'Upfront' || lineitemrec.License__c == 'Ratable')
            {
                lineitemrec.Stretch_License_Fee__c= StretchLicenseFee.setScale(2);
                lineitemrec.Stretch_Total_Maintenance__c= totalMaint.setScale(2);            
            }
            
            //SAMTU01 US387241 end
        }
    }
    
    
    //US312941 - BAJPI01 - called when start/end date/unit price is changed at line item level. Recalculates Duration Days.
    //called from mainframe edit page.
    public void getDaysBetweenLineItem(){
        
        startdate = lineitemrec.start_Date__c;
        enddate = lineitemrec.End_Date__c;
        system.debug('opplineitem>>'+lineitemrec);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        Decimal n = 0.00;
        Decimal totprice;
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            haserror =true;
        }
        else{
            haserror=false;
            totprice = lineitemrec.UnitPrice;
            if(startdate!=null && enddate!=null){
                lineitemrec.Duration_Days__c = startdate.daysBetween(enddate) + 1;
                n = ARRandDurationCalculation.monthsbetweendates(startdate,enddate);
                lineitemrec.Term_Month__c = n;
            }  
            else{
                lineitemrec.Term_Month__c = 0;
                lineitemrec.Duration_Days__c = 0;
            }
           
           
            updateoppheaderdatesmfcapacity();
            
        }
    }
    //US312941 - BAJPI01 - ends
    /*
* US326192 - for uniform update of start and end dates on opp header.
* for opp header, uses all line items.
* to update new deal term months on opp, uses mainframe and renewal
* line items.
*/
    public void updateoppheaderdatesmfcapacity(){
        List<OpportunityLineItem> updatedlineitemlist = new List<OpportunityLineItem>();
        Date minstartdate;
        Date maxenddate;
        if(allLineItems.size()>0){
            for(OpportunityLineItem oli:allLineItems){
                if(oli.id==lineitemrec.id){
                    updatedlineitemlist.add(lineitemrec);
                }    
                else
                    updatedlineitemlist.add(oli);
            }
        }
        else{
            updatedlineitemlist.add(lineitemrec);
        }
        
        if(updatedlineitemlist.size()>0){
            minstartdate = updatedlineitemlist[0].Start_Date__c;
            maxenddate = updatedlineitemlist[0].End_Date__c;
            for(OpportunityLineItem oli:updatedlineitemlist){
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
            
        }
        headerrec.Start_Date__c =  minstartdate;
        headerrec.End_Date__c = maxenddate;
        
        //New Deal Term Months on Opp will be populated for Renewal/MF Capacity Products only.
        if(renewalmainframelineitems.size()>0){
            minstartdate = renewalmainframelineitems[0].Start_Date__c;
            maxenddate = renewalmainframelineitems[0].End_Date__c;
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
            headerrec.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(minstartdate,maxenddate);   
        }
        else{
            if(lineitemrec.start_Date__c!=null && lineitemrec.end_date__c!=null)
                headerrec.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(lineitemrec.start_Date__c,lineitemrec.end_date__c);
        }
        
        if((headerrec.New_Deal_Term_Months__c!=null && headerrec.New_Deal_Term_Months__c<12)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
        }
    }
    
 
    
}