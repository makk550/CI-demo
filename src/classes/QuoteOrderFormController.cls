public class QuoteOrderFormController

{ 

    Public scpq__SciQuote__c QuoteRec=new scpq__SciQuote__c();   
    Public List<Quote_Product_Report__c> quotePdctReportList{set;get;}
    Public List<Quote_Product_Report__c> consultingSrvcEduList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> distributedOnDemandList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> distributedList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> mainframeList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> mainframePdctList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> CASWInfoTableList=new List<Quote_Product_Report__c>();
    public boolean saaSRender{set;get;}
    public boolean saaSRenderRenewal{set;get;}  //bajpi01 - for US300013
    // Added by: Vinu - KRIVI06 on 01/12/2014.
    Public List<Quote_Product_Report__c> QPInfoTableList=new List<Quote_Product_Report__c>();
    Public List<Quote_Product_Report__c> ServicesPdcnList=new List<Quote_Product_Report__c>();
    

    //CA Product Reno Template Changes in APAC & Education QQ
    public List<Quote_Product_Report__c> nonSubscriptionProductsList = new List<Quote_Product_Report__c>();
    public List<Quote_Product_Report__c> subscriptionProductsList = new List<Quote_Product_Report__c>();
    public List<Quote_Product_Report__c> ListQPR = new List<Quote_Product_Report__c>();
    public Boolean nonSubscriptionProductsGrid{get;set;}
    public Boolean subscriptionProductsGrid{get;set;}
    
    // Boolean Variable added to display the new paras for countries following German templates
        
     public Boolean Germanset{get;set;}
    
    // Boolean Variable added to display the new paras for countries following English2 templates
        
     public Boolean English2set{get;set;}
     
     // Boolean Variable added to display the new paras for countries following French templates
        
     public Boolean Frenchset{get;set;}
     
    // Boolean Variable added to display the new paras for countries following Italian templates
        
     public Boolean Italianset{get;set;}
     
   //ISTP - SKU based template - Author:Ram
     public Boolean MaintenanceQuote {get;set;}
     public Boolean PerpetualQuote {get;set;}
     public Boolean SubscriptionQuote {get;set;}
     public Boolean ShiptoReseller {get;set;}
     public Boolean ShiptoEndUser {get;set;}
     public Set<String> Territories {get;set;}
     public Boolean shipAddressDiffer {get;set;}
     public Map<String,Integer> Schedule {get;set;}
   //Ends 
    
    //PR04433 Education QQ
    public List<Quote_Product_Report__c> caEducationInformationList = new List<Quote_Product_Report__c>();
    public List<Quote_Product_Report__c> caEducationBucketPricingInformationList = new List<Quote_Product_Report__c>();
    public boolean caEducationPaymentProfileTbl{get;set;}  
    public boolean caEducationInformationTbl{get;set;}    
    public boolean caEducationBucketInformationTbl{get;set;}
    public boolean isCAEducationTemplate{get;set;}  
    //samtu01
    public boolean isIndia{get;set;}
    
    
    //MANAR08 - AR:1724 and 2187 - starts
    public boolean isCAEducationTemplateforLA{get;set;}
    public boolean caEducationPaymentProfileTblforLA{get;set;}
    /*Public List<PaymentPlan__c> paymentProfileforLA=new List<PaymentPlan__c>();
    Public List<Quote_Product_Report__c> educationListforLA=new List<Quote_Product_Report__c>();
    MANAR08 - AR:1724 and 2187 - ends */
    
    Public Map<Id,Decimal> ServicesPdcnToMpffst = new Map<Id,Decimal>();
    
    Public Map<Id,Decimal> MonthlyProductionFeePerUnit = new Map<Id,Decimal>();
    
    Public List<PaymentPlan__c> paymentProfile=new List<PaymentPlan__c>();
   
    public Boolean CstmrOnPremSubscription{get;set;}
    public Boolean CstmrOnPremPerpetual{get;set;}
    public Boolean CstmrOnDemandSbcrn{get;set;}
    public Boolean MSPOnPremSubscription{get;set;}
    public Boolean MSPOnPremPerpetual{get;set;}
    public Boolean MSPOnDemandSbcrn{get;set;}
    public Boolean CAProductRenewal{get;set;}
    public Boolean MRenewOnNimsoftPerpetual{get;set;}
    public Boolean MRenewOnNimsoftSubscription{get;set;}

    /* Boolean variables for displaying APJ Specific labels and change in templates */
    public Boolean isAPJ{get;set;}
    public Boolean showCompanyNumber{get;set;} 
    public Boolean isAPJLocalizedTemplate{get;set;}
    public Boolean isSuppressDecimal{get;set;}
    public String  blankSpace{get;set;}
    public Decimal MonthlyProductionFeePerUser{get;set;} 
    //public Decimal MonthlyProductionFeePerUnit{get;set;}
    
    
    public Boolean isHTFTTemplate{get;set;}

    /* Boolean Variables for displaying customer & service provider labels New Product type quote templates */ 
    public Boolean customerLabel{get;set;} 
    public Boolean serviceProviderLabel{get;set;}   
    /*End Bool*/
    /* Boolean Variables for displaying SOW in New Product type quote templates */
    /*Author:ketma02*/    
     public Boolean Langcustom{get;set;}
     public Boolean Langcustombrazil{get;set;}
     public Boolean QuoteSOW_Productmaterialflag1{get;set;}
     public Boolean QuoteSOW_Productmaterialflag2{get;set;}
     String QuoteSOW_ProdM1=label.QuoteSOW_Productmaterial1;
     String QuoteSOW_ProdM2=label.QuoteSOW_Productmaterial2;     
    /*End Bol*/
    /* Boolean Variables for displaying tables in New Product type quote templates */    
        public Boolean ServicesProduction{get;set;}
       // public Boolean ServicesProductionOnDemand{get;set;}
        public Boolean CASoftwareInfoPerpetualTbl{get;set;}
        public Boolean CASoftwareInfoSubsnTbl{get;set;} 
        public Boolean PaymentProfileTblPerpetual{get;set;} 
        public Boolean PaymentProfileTblSubscription{get;set;} 
        public Boolean showCSrvcEdu{get;set;} 
    /*End Bool*/
    /* Boolean Variables for displaying para1 of T&C in New Product type quote templates */
        public Boolean Subscription_on_prem_MSP_Para1{get;set;}
        public Boolean Subscription_On_Prem_Cstmr_para1{get;set;}
        public Boolean Perpetual_On_Premise_Para_1{get;set;}
        public Boolean Perpetual_On_Premise_MSP_Para1{get;set;}
        public Boolean Subscription_On_Demand_Para1{get;set;} 
        public Boolean Subscription_On_Demand_MSP_Para1{get;set;} 
     /*End Bool*/
     
     /* Boolean Variables for displaying tables in Renewal type quote templates */    
        public Boolean OnDemandAdminLabel{get;set;}
        public Boolean distributedOnDemandTbl{get;set;}
        public Boolean ProductConvertedLine{get;set;} 
        public Boolean GoverningContracts{get;set;} 
        public Boolean distrinutedTbl{get;set;} 
        public Boolean RenewalDatePanelSub{get;set;} 
        public Boolean RenewalDatePanelMain{get;set;} 
        public Boolean RenewalDatePanelStd{get;set;} 
        public Boolean checkBoxPanel{get;set;} 
        public Boolean mainframeTbl{get;set;} 
        public Boolean mainframeCPUTbl{get;set;}
        public Double UsageMaintanaceFee{get;set;}  
    /*End Bool*/
    
    /* Variables for CML CA entities*/
    Public List<CML_CA_Entities__c>  CMLCAEntitiesValues=CML_CA_Entities__c.getall().values();
    Public String CAEntity;
    Public String RemittanceInfo;
    Public String countryStr;
    Public String territory; 
    Public String DateFormat;
    Public String CAEntityName{get;set;}
    Public String CAEntityAddress{get;set;}
    Public List<String> RemittanceInfoList=new List<String>();  
    Public List<String> SoldToAddressInfoList=new List<String>();
    /*End CML CA Entities*/


    /*Local Field values for Chinese and Korean In APAC project*/
     public List<String> SoldToAddressInfoListLcl = new List<String>();
     public String customerAddressLcl{get;set;}
     public String billingAddressLcl{get;set;}
     public String shipmentAddressLcl{get;set;}
    /**/
    
    Public String licenseType;
    Public String langCode; 
    Public String VersionNum_Str;      
    Public String FooterString;
    Public String cpqQuoteNum_str;
    Public String customerAddress{get;set;}
    Public String billingAddress{get;set;}
    Public String ShipmentAddress{get;set;}
    Public String shippingReq='';
    Public String variables=''; 
    Public String OrderFormNum{get;set;}  
    Public String TerritoryCountry{get;set;}  
    Public List<String> ShippingRequiredList=new List<String>();  
    Public List<String> VariablesList=new List<String>(); 
     
    public Boolean EMEA_CA_Perpetual_On_Premise_Governing_contract{get;set;}
    public Boolean EMEA_CA_Perpetual_on_premise_MSP_governing_contract{get;set;}
    public Boolean EMEA_CA_subscription_on_demand_governing_contract{get;set;}
    public Boolean EMEA_CA_Subscription_On_Demand_MSP_governing_contract{get;set;}
    public Boolean EMEA_CA_Subscription_On_Premise_Governing_contract{get;set;}
    public Boolean EMEA_CA_Subscription_On_Premise_MSP_governing_contract{get;set;}
    public Boolean NON_EMEA_Governing_contract{get;set;}
    
    public Boolean EMEA_RENO_Standard{get;set;}
    public Boolean EMEA_RENO_Support{get;set;}
    public Boolean EMEA_RENO_Subscription{get;set;}
    
    public Boolean NON_EMEA_RENO_Standard{get;set;}
    public Boolean NON_EMEA_RENO_Support{get;set;}
    public Boolean NON_EMEA_RENO_Subscription{get;set;}
     public Boolean EMEARenoItalianPara7{get;set;} 
     public Boolean EMEA_RENO_SupportTxtBox{get;set;}
     
     
     public boolean showQuoteExpirydateForEnglish{set;get;}
     public boolean showEmptyTableForFrench{set;get;}
     
     public boolean showDistributorOrOnDemand{set;get;}
     public boolean showDistributorCASoftware{set;get;}
     public boolean showSAASOnDemand{set;get;}
     public boolean showAvailableFunctionality{set;get;}
     public boolean showProductName{set;get;}
     public boolean showEmptyTable{set;get;}
     public boolean showRenewalOnDemandPara{set;get;}

    public boolean showEffectiveOnSigDateNotice{set;get;}
     
    public List<QuoteOrderFormWrapper> Qwrapper {get;set;}
    
    //Added by (Mari-->ISTP,R1,2014)
    public String resellerAgreementNumber{get;set;}
    public String agreementEndDate {get;set;}   
    public String shipMethod{get;set;}   
    public Boolean isAPIQLtm {get;set;}
    public Boolean isCSMQLtm {get;set;}
    public Boolean isRAQLtm {get;set;}
    public Boolean SelectedCountry {get;set;}
    public Boolean isCsmSKU2 {get;set;}
    public Boolean isOneYearTransaction {get;set;}
    public Map<String,Quote_Product_Report__c> prodMattoQPRMap= new Map<String,Quote_Product_Report__c>();
    public Quote_Product_Report__c csmQPR{get;set;}
    public decimal tempSum{get;set;}
    public string payentData{set;get;}
    public Decimal Monthly_Production_Fee_Per_User{get;set;}
    public String NoUserscsmQPR{get;set;}
    //Added by (Mari-->ISTP,R1,2014)
    
    //Mari : APAC
    public Boolean isDirectQuote{get;set;}
    public Boolean isIndirectQuote{get;set;}
    public Boolean tier1OppQuote{get;set;}
    public Set<String> apacCountriesAllowedForSignRenewal{get;set;}
    public Boolean displaySignAPAC {get;set;} 
   
   /* 
    //MANAR08 AR:1724 and 2187 
    public Boolean isLA{get;set;}
    Public String TaxPercent{get;set;} */

    //Added by ALLHA02 SAP ROW Project
    Public Boolean showContactSection{get;set;}
    Public String billingDept{get;set;}
    Public String shippingDept{get;set;}
    Public String technicalDept{get;set;}
    Public Boolean isJapanLocalizedTemplate{get;set;}
    Public Boolean isPremise{get;set;}
    Public Boolean showNewLogo {get;set;}
    //Saas renewal field
     public Date EndDt{set;get;}
     public Date EffDt{set;get;}
     public Decimal PropSubFee{set;get;}
     public Decimal monthlyFee{set;get;}
     public Decimal totalQu{set;get;}
    public  string prodInstancId{set;get;}
    public Decimal proMaintFee{set;get;}
    public string licenType{set;get;}
    public string prodName{set;get;}
    public boolean onparmession{set;get;}
    public List<PaymentPlan__c> paymentProfileList{set;get;}
    public List<Quote_Product_Report__c> saasQuoteProducts{set;get;}
    public List<Quote_Product_Report__c> SaasQuoteProductsRenewal{set;get;} //bajpi01 - for US300013
    public List<Quote_Product_Report__c> cAOnPrimise{set;get;}
    public String cagreylogoimgurl{get;set;}                            
    
    public class QuoteOrderFormWrapper implements Comparable{
        
        public Date PaymentDateforSort {set;get;}
        public String PaymentDate {set;get;}
        public Decimal ProposedLicSubFee {set;get;}
        public Decimal MaintenanceFee {set;get;}
        public String QPRcurrency{get;set;}
        
        public Integer compareTo(Object compareTo) 
        {
        QuoteOrderFormWrapper QW = (QuoteOrderFormWrapper) compareTo;
        if (PaymentDateforSort == QW.PaymentDateforSort) return 0;
        if (PaymentDateforSort > QW.PaymentDateforSort) return 1;
        return -1;        
        }
        
        public QuoteOrderFormWrapper(String PD,Date PDforSort, Decimal PLF, Decimal MF, String cur){
            
            PaymentDate = PD;
            ProposedLicSubFee = PLF;
            MaintenanceFee = MF;
            QPRcurrency = cur;
            PaymentDateforSort = PDforSort;
        }
        
    }
    public QuoteOrderFormController() {
        quotePdctReportList=new List<Quote_Product_Report__c>();
        SaasQuoteProducts=new List<Quote_Product_Report__c>();
        SaasQuoteProductsRenewal=new List<Quote_Product_Report__c>(); //bajpi01 - for US300013
        cAOnPrimise=new List<Quote_Product_Report__c>();
        paymentProfileList=new List<PaymentPlan__c>();
        
        
    /* Setting Boolean Variables for displaying SOW in New Product type quote templates */
    
    //allha02 SAP ROW
        showContactSection = false; 
        showNewLogo = false;
        isJapanLocalizedTemplate = false;
        isPremise = false;

        QuoteSOW_Productmaterialflag1 = false;
        QuoteSOW_Productmaterialflag2 = false;
        Langcustom = false;
        Langcustombrazil = true;
        //Education QQ
        blankSpace = ' ';
        //showCompanyNumber = false;
        //isAPJLocalizedTemplate = false;
        //isSuppressDecimal = false;
        
     /*Ends*/
     
         //ISTP - Author:Ram        
        Qwrapper = new List<QuoteOrderFormWrapper>();
        Territories = new Set<String>{'PS_FED','PS_FSI','PS_SLED'};
        isCAEducationTemplateforLA=false;
        
        isCSMQLtm = false;
        isRAQLtm = false;
        isAPIQLtm = false;
        ShiptoReseller = false;
        ShiptoEndUser = false; 
        SelectedCountry = false;
        isCsmSKU2=false;
        shipAddressDiffer = false;
     //Ends
        
        // Mari : APAC 
        apacCountriesAllowedForSignRenewal = new Set<String>{'HK','SG','KR','CN','IN','JP','TH','MY','PH','TW'};
        isDirectQuote = false;
        isIndirectQuote = false;
        displaySignAPAC = false;
        tier1OppQuote= false; 
        isAPJ =false;
        
        showQuoteExpirydateForEnglish = false;
        showEmptyTableForFrench = false;
        licenseType=ApexPages.currentPage().getParameters().get('lic');
        langCode=ApexPages.currentPage().getParameters().get('lang');
        VersionNum_Str=ApexPages.currentPage().getParameters().get('vernum');
        shippingReq=ApexPages.currentPage().getParameters().get('ship');
        variables=ApexPages.currentPage().getParameters().get('variables');
        OrderFormNum=ApexPages.currentPage().getParameters().get('orderFormNo');
        //TerritoryCountry=ApexPages.currentPage().getParameters().get('territoryConuntry');//Fixed in APAC Issue
        TerritoryCountry=ApexPages.currentPage().getParameters().get('territory');//ALLHA02 AR3355
        System.debug(' territoryConuntry : '+ApexPages.currentPage().getParameters().get('territoryConuntry'));
        System.debug(' territory : '+ApexPages.currentPage().getParameters().get('territory'));
       


     /*   //MANAR08 - AR:1724 and 2187
        TaxPercent = ApexPages.currentPage().getParameters().get('tax');
        System.debug('tax***'+TaxPercent);
        System.debug('TerritoryCountry***'+ApexPages.currentPage().getParameters().get('territory'));
      */
        
        //(Mari-->ISTP,R1,2014)
        resellerAgreementNumber =ApexPages.currentPage().getParameters().get('rgNum');
        agreementEndDate =ApexPages.currentPage().getParameters().get('aeDate');
        shipMethod = ApexPages.currentPage().getParameters().get('shipMet');
         System.debug('shipMethod'+shipMethod);
         if(shipMethod!=NULL){
        if(shipMethod.equals('Ship to Reseller')) 
            ShiptoReseller = true;
        if(shipMethod.equals('Ship to End User')) 
            ShiptoEndUser = true;
         }   
        if(ApexPages.currentPage().getParameters().get('APILtm') != null &&  ApexPages.currentPage().getParameters().get('APILtm').equals('true'))
            isAPIQLtm = true;
        if(ApexPages.currentPage().getParameters().get('CSMLtm') != null &&  ApexPages.currentPage().getParameters().get('CSMLtm').equals('true'))
            isCSMQLtm = true;
        if(ApexPages.currentPage().getParameters().get('RALtm') != null &&  ApexPages.currentPage().getParameters().get('RALtm').equals('true'))
            isRAQLtm = true;
        
        Schedule = new Map<String,Integer>{'Yearly'=>1,'Half-Yearly'=>2,'Quarterly'=>3,'Monthly'=>12};
        //Added by (Mari-->ISTP,R1,2014) 
        
        if(langCode=='en'){
            showQuoteExpirydateForEnglish = true;
        }
        
        
       
        
        UsageMaintanaceFee=0;        
        Integer versionNum=0;
        Map<String,String> quotePdctIdShipMap=new Map<String,String>();
        Map<String,String> quotePdctIdVariablesMap=new Map<String,String>();
        
        //Map to store month names

        Map<Integer,String> MonthFormatMap=new Map<Integer,String>();
        MonthFormatMap.put(1,'01');
        MonthFormatMap.put(2,'02');
        MonthFormatMap.put(3,'03');
        MonthFormatMap.put(4,'04');
        MonthFormatMap.put(5,'05');
        MonthFormatMap.put(6,'06');
        MonthFormatMap.put(7,'07');
        MonthFormatMap.put(8,'08');
        MonthFormatMap.put(9,'09');
        MonthFormatMap.put(10,'10');
        MonthFormatMap.put(11,'11');
        MonthFormatMap.put(12,'12');


     //Map to store month names - APAC PR04243

       Map<Integer,String> monthNameFormatMap = new Map<Integer,String>();
        monthNameFormatMap.put(1,'January');
        monthNameFormatMap.put(2,'February');
        monthNameFormatMap.put(3,'March');
        monthNameFormatMap.put(4,'April');
        monthNameFormatMap.put(5,'May');
        monthNameFormatMap.put(6,'June');
        monthNameFormatMap.put(7,'July');
        monthNameFormatMap.put(8,'August');
        monthNameFormatMap.put(9,'September');
        monthNameFormatMap.put(10,'October');
        monthNameFormatMap.put(11,'November');
        monthNameFormatMap.put(12,'December');


        String entityRegion='';
        
        String currentURL=String.ValueOf(ApexPages.currentPage().getURL());
        try{
            QuoteRec= [SELECT Id, Name,CA_CPQ_Quote_Total__c,CA_Partner_Address__c,CA_End_User_Address__c,CA_CPQ_Quote_Number__c,
            CA_Distributor_Name__c,CA_Distributor_ID__c,Education_Contract__c,Subscription_Payment__c,      
            CA_Sold_To_ID__c,CA_Customer_Name_Sold_To__c,CA_Technical_Contact_Name__c,
            CA_Bill_To_ID__c,CA_Bill_To_Name__c,CA_Billing_Contact_Name__c,CA_Ship_To_ID__c,CA_Ship_To_Name__c,CA_Shipping_Contact_Name__c,
            CA_Service_Provider_ID__c,CA_Service_Provider_Name__c,
            CA_End_User_Contact_Name__c,CA_End_User_ID__c,CA_End_User_Name__c,
            CA_Direct_Indirect__c,CA_Sales_Area__c,
            CA_Services_Included__c,
            CA_Annual_Srvs_Edu_In_Transaction__c,
            CA_Total_Old_TRR__c,CA_Revenue_Per_Day_Percentage__c,CA_Revenue_Per_day_Old__c,CA_Proposed_Annual_Time__c,CA_Total_ATTRF__c,
            CA_Commissionable_Area__c,CA_Contracted_Renewal__c,
            CA_Purchase_Order_Number__c,
            scpq__OpportunityId__c,CA_Effective_Date__c,CA_Contract_End_Date__c,CA_CPQ_Quote_Status__c,CPQ_Quote_Number__c,Net_Payment_Terms__c,
            CA_Quote_Type__c,Ship_To_Address__c,Sold_To_Address__c,Bill_To_Address__c,Services_Payment__c,Technical_Contact_Email_Address__c,
            Technical_Contact_Phone__c,Bill_To_Phone__c,Bill_To_Email_Address__c,scpq__OpportunityId__r.Opportunity_Number__c,
            Order_Form__c,Contract_End_Date_Text__c,Effective_Date_Text__c,scpq__OpportunityId__r.Rpt_Region__c,scpq__OpportunityId__r.Rpt_Area__c,scpq__OpportunityId__r.Rpt_Territory_Country__c,scpq__OpportunityId__r.Rpt_Country__c,
            scpq__OpportunityId__r.Type,
            Company_Number__c,//- APAC PR04243
            CA_Customer_Name_Sold_To_Lcl__c,
            Sold_To_Address_Lcl__c,
            CA_Technical_Contact_Name_Lcl__c,CurrencyIsoCode,
            CA_Bill_To_Name_Lcl__c,
            CA_Billing_Contact_Name_Lcl__c,
            Bill_To_Address_Lcl__c,
            CA_Ship_To_Name_Lcl__c,
            CA_Shipping_Contact_Name_Lcl__c,
            Ship_To_Address_Lcl__c,
            CA_Distributor_Name_Lcl__c,
            CA_Reseller_Name_Lcl__c,
            CA_Reseller_Name__c,
            CA_End_User_Name_Lcl__c,
            CA_End_User_Contact_Name_Lcl__c,
            CA_Support_Delivered_By_Name_Lcl__c       
            FROM scpq__SciQuote__c WHERE Id =:ApexPages.currentPage().getParameters().get('id')];
               
            QuoteRec.Order_Form__c=ApexPages.currentPage().getParameters().get('orderFormNo');
    
          if(QuoteRec.Net_Payment_Terms__c!=null&&QuoteRec.Net_Payment_Terms__c!=''){
                        String  netPaymentTerms=QuoteRec.Net_Payment_Terms__c;
                           QuoteRec.Net_Payment_Terms__c=netPaymentTerms.Substring(3,netPaymentTerms.Length());
             }
             
           String UserAddress = QuoteRec.CA_End_User_Address__c;
           String ShipAddress = QuoteRec.Ship_To_Address__c;
             
          if(UserAddress==null && shipAddress==null)
             shipAddressDiffer = false;
         else if((UserAddress==null || shipAddress==null ) || !((UserAddress.trim()).equalsIgnoreCase(shipAddress.trim()))){
            system.debug('Addr Differ');
            shipAddressDiffer = true;
           }
            
            //ALLHA02 SAP ROW
           if(QuoteRec.CurrencyIsoCode=='JPY'&&LangCode =='ja')
            QuoteRec.CurrencyIsoCode='å';
            
            //  Mari : APAC
            // Finding the Direct and Indirect Quote
            if(QuoteRec.scpq__OpportunityId__r.Type =='Direct')
            isDirectQuote = true;
            else if (QuoteRec.scpq__OpportunityId__r.Type =='1 Tier' || QuoteRec.scpq__OpportunityId__r.Type =='2 Tier')
            isIndirectQuote= true;
            
            if(QuoteRec.scpq__OpportunityId__r.Type =='1 Tier')
            tier1OppQuote = true;
            if(QuoteRec.scpq__OpportunityId__r.Rpt_Region__c =='APJ')
            isAPJ =true;
            
           //  Mari : APAC
        
            //(Mari-->ISTP,R1,2014)  
            System.debug('Public Sector Territories '+Territories);
            System.debug('Quote Region '+QuoteRec.scpq__OpportunityId__r.Rpt_Territory_Country__c);
            if(Territories.contains(QuoteRec.scpq__OpportunityId__r.Rpt_Territory_Country__c) )
                SelectedCountry = true;
            //(Mari-->ISTP,R1,2014)  
            
            //CUSTOMER ADDRESS    
            if(QuoteRec.Sold_To_Address__c!=null&&QuoteRec.Sold_To_Address__c!=''){
                String soldToAddress=QuoteRec.Sold_To_Address__c;
                if(soldToAddress.contains(',')){
                    SoldToAddressInfoList=soldToAddress.Split(',');
                    customerAddress='';
                    if(SoldToAddressInfoList.size()>0){
                        for(integer i=0;i<SoldToAddressInfoList.size();i++){
                            String soldToAddressStr=SoldToAddressInfoList[i];
                            soldToAddressStr=soldToAddressStr.trim();
                            if(soldToAddressStr!=null&soldToAddressStr!=''){
                                customerAddress=customerAddress+soldToAddressStr+', ';  
                            }                          
                        }                        
                        customerAddress=customerAddress.substringBeforeLast(',');    
                        Integer listSize=SoldToAddressInfoList.size();
                        countryStr=SoldToAddressInfoList[listSize-1];
                        System.debug('countrystr'+countryStr);

                        
                        //ALLHA02 SAP ROW  
                        if(countryStr.toLowerCase().trim()=='jp') {         
                         showNewLogo = true ;
                         showContactSection=true;
                         isAPJ=true;
                         billingDept = ApexPages.currentPage().getParameters().get('billingDept');
                         shippingDept = ApexPages.currentPage().getParameters().get('shippingDept');
                         technicalDept = ApexPages.currentPage().getParameters().get('technicalDept');
                         customerAddress=customerAddress.remove('JP');
                         customerAddress=customerAddress.substringBeforeLast(',');
                         System.debug('Customer address after removing jp '+customerAddress);
                        }

                        if(countryStr.toLowerCase().trim()=='th' || countryStr.toLowerCase().trim()=='my' || countryStr.toLowerCase().trim()=='tw' || countryStr.toLowerCase().trim()=='ph' )
                        {
                             showNewLogo = true ;
                             System.debug(' ROW Countries showNewLogo flag ' + showNewLogo);
                         }
                        
                    }                
                } else{
                    customerAddress=soldToAddress;
                }           
            }
            
            //Localised CUSTOMER ADDRESS for simplified chinese and korean - APAC PR04243
            if(QuoteRec.Sold_To_Address_Lcl__c != null && QuoteRec.Sold_To_Address_Lcl__c != '' && QuoteRec.Sold_To_Address_Lcl__c != ', , , ,'){
                String soldToAddressLcl = QuoteRec.Sold_To_Address_Lcl__c;
                System.debug('+++soldToAddressLcl+++'+soldToAddressLcl);
                if(soldToAddressLcl.contains(',')){
                    System.debug('+++inside+++');
                    SoldToAddressInfoListLcl = soldToAddressLcl.Split(',');
                    System.debug('+++SoldToAddressInfoListLcl Size+++'+SoldToAddressInfoListLcl.size());
                    customerAddressLcl = ''; 
                    if(SoldToAddressInfoListLcl.size()>0){
                        for(integer i=0;i<SoldToAddressInfoListLcl.size();i++){
                            System.debug('+++inside loop+++');
                            String soldToAddressStrLcl = SoldToAddressInfoListLcl[i];
                            soldToAddressStrLcl = soldToAddressStrLcl.trim();
                            if(soldToAddressStrLcl != null && soldToAddressStrLcl != '' && soldToAddressStrLcl != 'null'){
                                customerAddressLcl = customerAddressLcl + soldToAddressStrLcl +', ';  
                            }                          
                        }                        
                        customerAddressLcl = customerAddressLcl.substringBeforeLast(',');    
                        Integer listSize = SoldToAddressInfoListLcl.size();
                        
                        for (String astring : SoldToAddressInfoListLcl) {
                            System.debug('+++list object+++'+astring);
                        }
                        
                        //allha02 to capture reverse order address for japan
                        if(SoldToAddressInfoListLcl[0]=='jp' || SoldToAddressInfoListLcl[0]=='JP'){
                           countryStr = SoldToAddressInfoListLcl[0]; 
                        } else
                        countryStr = SoldToAddressInfoListLcl[listSize-1];
                        
                        System.debug('+++countryStr+++'+countryStr);
                        
                    }                
                } else{
                    System.debug('+++customerAddressLcl = soldToAddressLcl+++'+customerAddressLcl);
                    customerAddressLcl = soldToAddressLcl;
                }           
            
                   System.debug('showContactSection  lcl '+showContactSection);//ALLHA02 SAP ROW
                   if(showContactSection){
                         customerAddressLcl =customerAddressLcl.remove('JP');
                         customerAddressLcl = customerAddressLcl.removeStart(',');
                         System.debug('Customer Address lcl '+customerAddressLcl);

                   }

            }
                        // Mari : APAC
                        if(apacCountriesAllowedForSignRenewal.contains(countryStr.trim()))
                        displaySignAPAC = true;
                        System.debug('Setting displaySignAPAC '+ apacCountriesAllowedForSignRenewal.contains(countryStr.trim()) +' ' +apacCountriesAllowedForSignRenewal +' '+countryStr);
                        // Mari : APAC
            //BILLING ADDRESS
            if(QuoteRec.Bill_To_Address__c!=null&&QuoteRec.Bill_To_Address__c!=''){
                String billToAddress=QuoteRec.Bill_To_Address__c;
                List<String> billingAddressList=new List<String>();
                 if(billToAddress.contains(',')){
                    billingAddressList=billToAddress.Split(',');
                    billingAddress='';
                    if(billingAddressList.size()>0){
                        for(integer i=0;i<billingAddressList.size();i++){
                            String billingAddressStr=billingAddressList[i];                            
                            billingAddressStr=billingAddressStr.trim();
                            if(billingAddressStr!=null&&billingAddressStr!=''){
                                billingAddress=billingAddress+billingAddressStr+', ';  
                            }                          
                        } 
                        billingAddress=billingAddress.substringBeforeLast(',');
                        // ALLHA02 SAP ROW remove JP  
                        if(showContactSection)  
                           {
                        billingAddress=billingAddress.remove('JP');
                        billingAddress=billingAddress.substringBeforeLast(',');
                            }

                    }
                     
                }else{
                    billingAddress=billToAddress;
                   if(showContactSection)
                           {
                        billingAddress=billingAddress.remove('JP');
                        }
                          }
            }
            
             //Localised BILLING ADDRESS for simplified chinese and korean - APAC PR04243
             
            if(QuoteRec.Bill_To_Address_Lcl__c !=null && QuoteRec.Bill_To_Address_Lcl__c != ''){
                String billToAddressLcl = QuoteRec.Bill_To_Address_Lcl__c;
                List<String> billingAddressListLcl = new List<String>();
                 if(billToAddressLcl.contains(',')){
                    billingAddressListLcl = billToAddressLcl.Split(',');
                    billingAddressLcl = '';
                    if(billingAddressListLcl.size()>0){
                        for(integer i=0;i<billingAddressListLcl.size();i++){
                            String billingAddressStrLcl = billingAddressListLcl[i];                            
                            billingAddressStrLcl = billingAddressStrLcl.trim();
                            if(billingAddressStrLcl != null && billingAddressStrLcl != '' && billingAddressStrLcl != 'null'){
                                billingAddressLcl = billingAddressLcl + billingAddressStrLcl +', ';  
                            }                          
                        } 
                        billingAddressLcl = billingAddressLcl.substringBeforeLast(',');
                        // ALLHA02 SAP ROW remove JP  
                          if(showContactSection){
                             billingAddressLcl=billingAddressLcl.remove('JP');
                             billingAddressLcl = billingAddressLcl.removeStart(',');

                          } 

                    }
                     
                }else{
                    billingAddressLcl = billToAddressLcl;
                    if(showContactSection)
                     billingAddressLcl=billingAddressLcl.remove('JP');   
                }
            }
            
            
            
            //SHIPMENT ADDRESS
            if(QuoteRec.Ship_To_Address__c!=null&&QuoteRec.Ship_To_Address__c!=''){
                String shipToAddress=QuoteRec.Ship_To_Address__c;
                List<String> shipingAddressList=new List<String>();
                 if(shipToAddress.contains(',')){
                    shipingAddressList=shipToAddress.Split(',');
                    ShipmentAddress='';
                    if(shipingAddressList.size()>0){
                        for(integer i=0;i<shipingAddressList.size();i++){
                            String shipingAddressStr=shipingAddressList[i];
                            shipingAddressStr=shipingAddressStr.trim();
                            if(shipingAddressStr!=null&&shipingAddressStr!=''){
                                ShipmentAddress=ShipmentAddress+shipingAddressStr+', ';  
                            }                          
                        }
                        ShipmentAddress=ShipmentAddress.substringBeforeLast(',');
                        // ALLHA02 SAP ROW remove JP  
                        if(showContactSection)
                        {
                            ShipmentAddress=ShipmentAddress.remove('JP');
                            ShipmentAddress=ShipmentAddress.substringBeforeLast(',');
                        }
                    }
                     
                }else{
                    ShipmentAddress=shipToAddress;
                     if(showContactSection)
                     ShipmentAddress=ShipmentAddress.remove('JP');   


                }
            }
            
            
             //Localised SHIPMENT ADDRESS for simplified chinese and korean - APAC PR04243
            if(QuoteRec.Ship_To_Address_Lcl__c != null && QuoteRec.Ship_To_Address_Lcl__c != ''){
                String shipToAddressLcl = QuoteRec.Ship_To_Address_Lcl__c;
                List<String> shipingAddressListLcl = new List<String>();
                 if(shipToAddressLcl.contains(',')){
                    shipingAddressListLcl = shipToAddressLcl.Split(',');
                    shipmentAddressLcl = '';
                    if(shipingAddressListLcl.size()>0){
                        for(integer i=0;i<shipingAddressListLcl.size();i++){
                            String shipingAddressStrLcl = shipingAddressListLcl[i];
                            shipingAddressStrLcl = shipingAddressStrLcl.trim();
                            if(shipingAddressStrLcl != null && shipingAddressStrLcl != '' && shipingAddressStrLcl != 'null'){
                                shipmentAddressLcl = shipmentAddressLcl + shipingAddressStrLcl +', ';  
                            }                          
                        }
                        shipmentAddressLcl = ShipmentAddressLcl.substringBeforeLast(','); 
                        // ALLHA02 SAP ROW remove JP  
                        if(showContactSection){
                        shipmentAddressLcl = ShipmentAddressLcl.remove('JP');
                        shipmentAddressLcl = ShipmentAddressLcl.removeStart(','); 

                                }
                    }
                     
                }else{
                    shipmentAddressLcl = shipToAddressLcl;
                    if(showContactSection)
                        shipmentAddressLcl = ShipmentAddressLcl.remove('JP');
                }
            }
            
        }Catch(Exception e){
        }
        
        //Start of Entity Processing for APAC        
       
        try{           
            for(CML_CA_Entities__c entity:CMLCAEntitiesValues){     
                         
                String countryCS = entity.Country__c;
                System.debug('---in try---'+countryCS);
                countryCS = countryCS.toLowerCase();    
                            
                if(countryStr != null && countryStr != ''){
                    
                    countryStr = countryStr.toLowerCase();
                    countryStr = countryStr.trim(); 
                       System.debug('countryCS'+countryCS);        
                    if(countryCS == countryStr){
                        System.debug('Harish --  In cml loop'+countryCS);
                        //Override the entity with local language entity - APAC PR04243
                        if(countryCS == 'CN' && LangCode == 'zh_CN'){
                            entity = CML_CA_Entities__c.getInstance('China Local');
                            isAPJLocalizedTemplate  = true;                         
                        }else if(countryCS == 'CN'){
                            entity = CML_CA_Entities__c.getInstance('China');
                            isAPJLocalizedTemplate  = false;
                        }
                        if(countryCS == 'KR' && LangCode == 'ko'){
                            entity = CML_CA_Entities__c.getInstance('Korea Local');
                            isAPJLocalizedTemplate  = true;
                        }else if(countryCS == 'KR'){
                            entity = CML_CA_Entities__c.getInstance('Korea');
                            isAPJLocalizedTemplate  = false;
                        }
                         //ALLHA02 SAP ROW Japan
                        if(countryCS == 'JP' && LangCode == 'ja'){
                            entity = CML_CA_Entities__c.getInstance('Japan Local');
                            isJapanLocalizedTemplate  = true;
                            isAPJLocalizedTemplate = true ;
                            isSuppressDecimal = true;

                        }else if(countryCS == 'JP'){
                            entity = CML_CA_Entities__c.getInstance('Japan');
                            isJapanLocalizedTemplate  = false;
                            isAPJLocalizedTemplate = false ;
                            isSuppressDecimal = true;
                        }
                        
                        //Required to Supress decimal pricing figures in Order Form for KOREA only
                        if(countryCS == 'KR')
                            isSuppressDecimal = true;
                            
                       //Added to display ABN/ACN/ACRA number for Australia & Singapore  - APAC PR04243
                        if(countryCS == 'AU' || countryCS == 'SG'){
                            showCompanyNumber = true;
                            System.debug('+++countryCS+++'+countryCS+' '+showCompanyNumber);                        
                        }    
                            
                        territory = entity.Sales_Area__c;
                        //Added by SAMTU01 - US287240
                        System.debug('---territory---'+territory);
                        if(countryCS =='IN'){
                            isIndia=false;
                            System.debug('---territory if loop---'+isIndia);
                        }
                        else
                            {
                                isIndia=true;
                                System.debug('---territory else loop---'+isIndia);
                             }
                       //Added by SAMTU01 - US287240 --ends here
                        DateFormat = entity.Date_Format__c;
                                                   
                           if(currentURL != null && currentURL != ''){
                                if(currentURL.contains('RenewalQuoteType')){
                                    CAEntity=entity.Contracting_Entity_Name__c+', '+entity.Contracting_Entity_Address__c+'  '+System.Label.CALabelWithDBlQuotes;                           
                                    if(CAEntity.contains('"CA"')){                                        
                                        CAEntity=CAEntity.replaceAll('"','\"');
                                    }                                    
                                }  
                                if(currentURL.contains('NewProductQuoteType')){
                                    CAEntity=entity.Contracting_Entity_Name__c+', '+entity.Contracting_Entity_Address__c+'  '+System.Label.CALabelWithDBlQuotes;
                                   if(CAEntity.contains('"CA"')){ 
                                        CAEntity=CAEntity.replaceAll('"','\"'); 
                                    }                                   
                                }
                            }

                            entityRegion = QuoteRec.scpq__OpportunityId__r.Rpt_Region__c;
                            System.debug(' -- EntityRegion :'+entityRegion+' countrystr :'+countrystr+' countryCS: '+countryCS);
                            RemittanceInfo=entity.Electronic_Funds_Transfer_Information__c; 
                            CAEntityName=entity.Contracting_Entity_Name__c;
                            CAEntityName=CAEntityName.replaceAll('"','\"');
                            CAEntityAddress=entity.Contracting_Entity_Address__c;//+'  '+System.Label.CALabelWithDBlQuotes; 
                            CAEntityAddress=CAEntityAddress.replaceAll('"','\"');
                            
                            //entityRegion=entity.GEO__c;
                            
                                        

                          //For Canada when language selected is French
                            if(LangCode=='fr'&&entity.Country__c=='CA'){
                               CAEntityName='La Compagnie CA du Canada';
                                CAEntityAddress='555, Boul. Dr. Frederik-Philips, Bureau 240, St-Laurent, QC, H4M 2X4, T?l. : +1 514-747-8100'+'  '+System.Label.CALabelWithDBlQuotes;  
                                   CAEntityAddress=CAEntityAddress.replaceAll('"','\"');    
                            }
                       
                    }
                     
                }                   
            }         
        }Catch(Exception e){
        }        
        
        //End of Entity Processing for APAC
        
        // Mari, ISTP R1
        Datetime quoteEffectiveDate=QuoteRec.CA_Effective_Date__c;
        Datetime quoteEndDate=QuoteRec.CA_Contract_End_Date__c;
        // Calculating Transaction Duration
        Date qEffDate =QuoteRec.CA_Effective_Date__c;
        Date qEndDate=QuoteRec.CA_Contract_End_Date__c;
        if (qEffDate != null && qEndDate!= null)
        {
            isOneYearTransaction = ( math.abs(qEffDate.daysBetween(qEndDate))< 365?true:false);
        }
         
        
        if(DateFormat=='MDY'){
             QuoteRec.Effective_Date_Text__c=QuoteRec.CA_Effective_Date__c.month()+'/'+QuoteRec.CA_Effective_Date__c.day()+'/'+QuoteRec.CA_Effective_Date__c.year();
             QuoteRec.Contract_End_Date_Text__c=QuoteRec.CA_Contract_End_Date__c.month()+'/'+QuoteRec.CA_Contract_End_Date__c.day()+'/'+QuoteRec.CA_Contract_End_Date__c.year();
        }
        if(DateFormat=='DMY'){
            QuoteRec.Effective_Date_Text__c=QuoteRec.CA_Effective_Date__c.day()+'/'+QuoteRec.CA_Effective_Date__c.month()+'/'+QuoteRec.CA_Effective_Date__c.year();
            QuoteRec.Contract_End_Date_Text__c=QuoteRec.CA_Contract_End_Date__c.day()+'/'+QuoteRec.CA_Contract_End_Date__c.month()+'/'+QuoteRec.CA_Contract_End_Date__c.year();
        }   
        if(DateFormat=='YMD'){
            QuoteRec.Effective_Date_Text__c= QuoteRec.CA_Effective_Date__c.year()+'/'+ QuoteRec.CA_Effective_Date__c.month()+'/'+ QuoteRec.CA_Effective_Date__c.day();
            QuoteRec.Contract_End_Date_Text__c=QuoteRec.CA_Contract_End_Date__c.year()+'/'+QuoteRec.CA_Contract_End_Date__c.month()+'/'+ QuoteRec.CA_Contract_End_Date__c.day();
        }
        if(LangCode=='de'){
    
                QuoteRec.Effective_Date_Text__c=QuoteRec.CA_Effective_Date__c.day()+'.'+MonthFormatMap.get(QuoteRec.CA_Effective_Date__c.month())+'.'+QuoteRec.CA_Effective_Date__c.year();
                QuoteRec.Contract_End_Date_Text__c=QuoteRec.CA_Contract_End_Date__c.day()+'.'+MonthFormatMap.get(QuoteRec.CA_Contract_End_Date__c.month())+'.'+QuoteRec.CA_Contract_End_Date__c.year();
            }
        //Added for APAC PR04243 - Date format        
            if(entityRegion == 'APJ' && !showContactSection){          
                QuoteRec.Effective_Date_Text__c = QuoteRec.CA_Effective_Date__c.day()+' '+monthNameFormatMap.get(QuoteRec.CA_Effective_Date__c.month())+' '+QuoteRec.CA_Effective_Date__c.year();
                QuoteRec.Contract_End_Date_Text__c = QuoteRec.CA_Contract_End_Date__c.day()+' '+monthNameFormatMap.get(QuoteRec.CA_Contract_End_Date__c.month())+' '+QuoteRec.CA_Contract_End_Date__c.year();
            }
        
        // ALLHA02 SAP ROW -- Date Format for Japan
            if(showContactSection){     

                QuoteRec.Effective_Date_Text__c=monthNameFormatMap.get(QuoteRec.CA_Effective_Date__c.month())+' '+QuoteRec.CA_Effective_Date__c.day()+', '+QuoteRec.CA_Effective_Date__c.year();
                QuoteRec.Contract_End_Date_Text__c=monthNameFormatMap.get(QuoteRec.CA_Contract_End_Date__c.month())+' '+QuoteRec.CA_Contract_End_Date__c.day()+', '+QuoteRec.CA_Contract_End_Date__c.year();
            }
            if(showContactSection && isJapanLocalizedTemplate){     
                   
                QuoteRec.Effective_Date_Text__c=QuoteRec.CA_Effective_Date__c.year()+'å¹´'+QuoteRec.CA_Effective_Date__c.month()+'æ'+QuoteRec.CA_Effective_Date__c.day()+'æ¥';
                QuoteRec.Contract_End_Date_Text__c=QuoteRec.CA_Contract_End_Date__c.year()+'å¹´'+QuoteRec.CA_Contract_End_Date__c.month()+'æ'+QuoteRec.CA_Contract_End_Date__c.day()+'æ¥';
            }




       
        try{
            system.debug('TestQuoteID:'+QuoteRec.Id);
            
             paymentProfileList=[Select id,name,Committed_Payment__c,Payment_Date__c,License_Payment__c,Maintenance_Payment__c,Payment_Total__c,
            Services_Payment__c,Sterling_Quote__c,Subscription_Payment__c,CurrencyIsoCode,Date_Text__c from PaymentPlan__c where Sterling_Quote__c=:QuoteRec.Id order by Payment_Date__c ASC];
            //Services_Payment__c,Sterling_Quote__c,Subscription_Payment__c,CurrencyIsoCode,Date_Text__c from PaymentPlan__c order by Payment_Date__c ASC Limit 5];
            system.debug('PaymentProfileTest:'+paymentProfileList);
            tempSum = 0.00;
            
            for(PaymentPlan__c pp:paymentProfileList){
                Datetime myDate=pp.Payment_Date__c;
                if(DateFormat=='MDY'){
                     pp.Date_Text__c=pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.day()+'/'+pp.Payment_Date__c.year();
                     payentData=pp.Date_Text__c;
                }
                if(DateFormat=='DMY'){
                    pp.Date_Text__c=pp.Payment_Date__c.day()+'/'+pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.year();
                    payentData=pp.Date_Text__c;
                }
                if(DateFormat=='YMD'){
                    pp.Date_Text__c=pp.Payment_Date__c.year()+'/'+pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.day();
                    payentData=pp.Date_Text__c;
                }
                if(LangCode=='de'){
                    pp.Date_Text__c=pp.Payment_Date__c.day()+'.'+MonthFormatMap.get(pp.Payment_Date__c.month())+'.'+pp.Payment_Date__c.year();
                    payentData=pp.Date_Text__c;
                }
                //Added for APAC PR04243 - Date format        
                if(entityRegion == 'APJ' && !showContactSection){          
                     pp.Date_Text__c = pp.Payment_Date__c.day()+' '+monthNameFormatMap.get(pp.Payment_Date__c.month())+' '+pp.Payment_Date__c.year();
                }
              
                // ALLHA02 SAP ROW -- Date Format Japan
                if(showContactSection){  

                      pp.Date_Text__c=monthNameFormatMap.get(pp.Payment_Date__c.month())+' '+pp.Payment_Date__c.day()+', '+pp.Payment_Date__c.year(); 
                     
                }
                if(showContactSection && isJapanLocalizedTemplate){  

                      pp.Date_Text__c=pp.Payment_Date__c.year()+'å¹´'+pp.Payment_Date__c.month()+'æ'+pp.Payment_Date__c.day()+'æ¥'; 
                     
                }




                tempSum += pp.Payment_Total__c;
                System.debug('TotalValues_tempSum:'+tempSum);

                paymentProfile.add(pp); 
                system.debug('paymentProfileListAfter:'+paymentProfile.size());
            }
        }catch(Exception e){
            system.debug('ExceptionMessage:'+e.getmessage());
        }
        
        
 /*       
        //MANAR08 -  AR:1724 and 2187
        try{
            system.debug('Quote ID***:'+QuoteRec.Id);
            //TODO: Modify the below soql query
            List<PaymentPlan__c> paymentProfileListforLA = [SELECT id,Payment_Total__c,Sterling_Quote__c FROM PaymentPlan__c WHERE Sterling_Quote__c = QuoteRec.Id order by Payment_Date__c ASC LIMIT 2] ;
            for(PaymentPlan__c pp:paymentProfileList){
                Datetime myDate=pp.Payment_Date__c;
                if(DateFormat=='MDY'){
                     pp.Date_Text__c=pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.day()+'/'+pp.Payment_Date__c.year();
                }
                if(DateFormat=='DMY'){
                    pp.Date_Text__c=pp.Payment_Date__c.day()+'/'+pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.year();
                }
                if(DateFormat=='YMD'){
                    pp.Date_Text__c=pp.Payment_Date__c.year()+'/'+pp.Payment_Date__c.month()+'/'+pp.Payment_Date__c.day();
                }
                if(LangCode=='de'){
                    pp.Date_Text__c=pp.Payment_Date__c.day()+'.'+MonthFormatMap.get(pp.Payment_Date__c.month())+'.'+pp.Payment_Date__c.year();
                }
                //Added for APAC PR04243 - Date format        
                if(entityRegion == 'APJ'){          
                     pp.Date_Text__c = pp.Payment_Date__c.day()+' '+monthNameFormatMap.get(pp.Payment_Date__c.month())+' '+pp.Payment_Date__c.year();
                }

                tempSum += pp.Payment_Total__c;
                System.debug('TotalValues_tempSum:'+tempSum);

                paymentProfile.add(pp); 
                system.debug('paymentProfileListAfter:'+paymentProfile.size());
            }
            paymentProfileforLA.add(paymentProfileListforLA[0]);
            //check if the above code snippet can be used
            
        } */
        
        try{
            quotePdctReportList=[Select id,name,Sterling_Quote__c,Product_Name__c,Operating_System__c,License_Metric__c,ESD__c,GA__c,Royalty_Product__c,
            Upfront_capable__c,GSA__c,No_Charge_Product__c,Reason_for_no_charge__c,Effective_Date__c,End_Date__c,Old_Auth_Use_Model__c,Auth_Use_Model__c,
            License_Type__c,Bus_Transaction_Type__c,Business_Unit__c,Mainframe_Distributed__c,Existing_Quantity__c,New_Additional_Quantity__c,
            Total_Quantity__c,Old_SAP_Contract_Number__c,Old_SAP_Contract_Line_Number__c,Per_Unit_List_Price__c,List_License_Subs_Fee__c,Product_Instance_ID__c,
            Contracted_Maintenance_Price__c,Stated_Renewal_Fee__c,AutoCalc_Stated_Renewal__c,Shipping_Required__c,Proposed_Lic_Sub_Fee__c,Proposed_Maint_Fee__c,
            Monthly_Product_Fee_for_Subscriptionterm__c,Variables__c,CurrencyIsoCode,Effective_Date_Text__c,End_Date_Text__c,Product_Material__c,Product_Material__r.name 
           ,CA_Pricing_Group__c,Delivery_Method__c, Total_Proposed_Price__c, Total_Disc_off_List__c,Sterling_Quote__r.CA_Effective_Date__c ,Special_Metric_Usage_Qty_Existing__c,Sterling_Quote__r.Effective_Date_Text__c, Sterling_Quote__r.Maintenance_Payment__c from Quote_Product_Report__c where Sterling_Quote__c=:QuoteRec.Id order by Effective_Date__c ASC]; //Education QQ changes
           //,CA_Pricing_Group__c,Delivery_Method__c, Total_Proposed_Price__c, Total_Disc_off_List__c,Sterling_Quote__r.CA_Effective_Date__c,Sterling_Quote__r.Effective_Date_Text__c ,Sterling_Quote__r.Maintenance_Payment__c from Quote_Product_Report__c where End_Date__c!= null order by Effective_Date__c ASC limit 5];    
             
            
            system.debug('FieldEmptyCheck:'+quotePdctReportList[0].Sterling_Quote__r.Effective_Date_Text__c);
            for(Quote_Product_Report__c qpr:quotePdctReportList){
                  if(qpr.Proposed_Maint_Fee__c!=null)
                      proMaintFee=qpr.Proposed_Maint_Fee__c;
                    if(qpr.Product_Instance_ID__c!=null)
                        prodInstancId=qpr.Product_Instance_ID__c;
                    if(qpr.License_Type__c!=null)
                        licenType=qpr.License_Type__c;
                    if(qpr.License_Type__c!=null)
                        prodName=qpr.License_Type__c;
                // Constructing prodMattoQPRMap  here
                if(qpr.CA_Pricing_Group__c=='SaaS'){
                    //saaSRender=true;
                    SaasQuoteProducts.add(qpr);
                    
                }
                
                if(qpr.CA_Pricing_Group__c=='Distributed'){
                    
                    onparmession=true;
                    cAOnPrimise.add(qpr);
                    
                }
                
                if(qpr.Product_Material__r.Name == Label.CSM_SKU_1 || qpr.Product_Material__r.Name == Label.CSM_SKU_2)
                prodMattoQPRMap.put('CSMSKU',qpr);
                else if (qpr.Product_Material__r.Name == Label.Release_Automation_SKU)
                prodMattoQPRMap.put('ReleaseAutomationSKU',qpr);
                else if(qpr.Product_Material__r.Name == Label.API_Gateway_SKU)
                prodMattoQPRMap.put('APIGatewaySKU',qpr);
                // Constructing prodMattoQPRMap  here
                
                csmQPR = prodMattoQPRMap.get('CSMSKU');
                String qprId=qpr.Id;  
                
                //Added by: Vinu - KRIVI06 on 02/12/2014.
                 EndDt = qpr.End_Date__c;
                 EffDt = qpr.Effective_Date__c;
                 PropSubFee = qpr.Proposed_Lic_Sub_Fee__c;
                 //monthlyFee=totalFee/EndDt.-EffDt;
                 totalQu=qpr.Total_Quantity__c;
                
                system.debug('TestStDate'+Enddt);
                system.debug('TestEndDate'+EffDt);
                system.debug('Fee'+PropSubFee);
                
                if(EffDt != null && PropSubFee != null && Enddt !=null)
              {
                 
                Integer numberDaysDue = EffDt.daysBetween(EndDt);
                  numberDaysDue +=1;
                Decimal MonProdFeePerUser = 0;
                MonProdFeePerUser = ((PropSubFee) / (numberDaysDue));
                  system.debug('------MonProdFeePerUser--------'+MonProdFeePerUser);
                  system.debug('------total quantity--------'+totalQu);
                  if(totalQu != 0){
                      MonProdFeePerUser = ((MonProdFeePerUser/totalQu)/12)*365;
                      system.debug('------MonProdFeePerUser--------'+MonProdFeePerUser);
                      //MonProdFeePerUser = MonProdFeePerUser*365;
                      //system.debug('------MonProdFeePerUser--------'+MonProdFeePerUser);
                  }
                  else{
                      MonProdFeePerUser = 0;
                  }
                  
                  System.debug('monthly fee'+MonProdFeePerUser);
                
                
                System.debug('TestFinalDt'+numberDaysDue);     
                  
                  MonthlyProductionFeePerUser = MonProdFeePerUser.SetScale(2);
                System.debug('TestintFV'+MonthlyProductionFeePerUser);                
                
                //commented by BAJPI01 as part of CR#300-597887 -  Agile BU Ticket
                
                /* Added by: DUTRO02 on 09/29/2016 - Agile BU Integration
                Long numberMonthsDue = (EffDt.daysBetween(EndDt) / 30.0).round();
                Decimal MonProdFeePerUnit = 0;
                if (numberMonthsDue != 0 && totalQu != 0) 
                {
                    MonProdFeePerUnit = ((PropSubFee) / numberMonthsDue ) / totalQu;
                    MonProdFeePerUnit = MonProdFeePerUnit.setScale(2, roundingMode.HALF_UP);
                }
        */
                    
                    MonthlyProductionFeePerUnit.put(qpr.Id, MonthlyProductionFeePerUser);

                
                
                System.debug('totalQu = '+totalQu);
                System.debug('PropSubFee = '+PropSubFee);
 
                
              }
              
                // The End //
                // Mari ISTP R1
                if (qpr.Product_Material__r.Name == Label.CSM_SKU_2) isCsmSKU2= true;
                if(quotePdctIdVariablesMap.size()>0){
                    //qpr.Variables__c=quotePdctIdVariablesMap.get(qprId);
                }               
                if(quotePdctIdShipMap.size()>0){
                    //qpr.Shipping_Required__c=quotePdctIdShipMap.get(qprId);
                } 
                System.debug('Check2');
                /*Author:ketma02 Starts*/
                //Product material for SOW display
                string prodmaterial=qpr.Product_Material__r.name;                
                if(prodmaterial!=null&&prodmaterial!=''){
                    if(langCode=='en'&&(countrystr=='CA'||countrystr=='US')){
                       if(prodmaterial==QuoteSOW_ProdM1){
                            QuoteSOW_Productmaterialflag1=true;
                            
                        }
                    }
                     if(langCode=='en'&&(countrystr=='CA'||countrystr=='US')){
                        if(prodmaterial==QuoteSOW_ProdM2){
                            QuoteSOW_Productmaterialflag2=true;
                             
                        }
                    }
                }
                /*Ends*/
                String busTransactionType=qpr.Bus_Transaction_Type__c;
                if(busTransactionType!=null&&busTransactionType!=''){
                     busTransactionType=busTransactionType.toLowerCase();
                }               
                Datetime effectiveDate=qpr.Effective_Date__c;
                Datetime endDate=qpr.End_Date__c;
                if(DateFormat=='MDY'){
                     qpr.Effective_Date_Text__c=qpr.Effective_Date__c.month()+'/'+qpr.Effective_Date__c.day()+'/'+qpr.Effective_Date__c.year();
                     qpr.End_Date_Text__c=qpr.End_Date__c.month()+'/'+qpr.End_Date__c.day()+'/'+qpr.End_Date__c.year();
                }
                if(DateFormat=='DMY'){
                    qpr.Effective_Date_Text__c=qpr.Effective_Date__c.day()+'/'+qpr.Effective_Date__c.month()+'/'+qpr.Effective_Date__c.year();
                    qpr.End_Date_Text__c=qpr.End_Date__c.day()+'/'+qpr.End_Date__c.month()+'/'+qpr.End_Date__c.year();
                }
                if(DateFormat=='YMD'){
                    qpr.Effective_Date_Text__c=qpr.Effective_Date__c.year()+'/'+ qpr.Effective_Date__c.month()+'/'+ qpr.Effective_Date__c.day();
                    qpr.End_Date_Text__c=qpr.End_Date__c.year()+'/'+qpr.End_Date__c.month()+'/'+ qpr.End_Date__c.day();
                }  
               if(LangCode=='de'){
                    qpr.Effective_Date_Text__c=qpr.Effective_Date__c.day()+'.'+MonthFormatMap.get(qpr.Effective_Date__c.month())+'.'+qpr.Effective_Date__c.year();
                    qpr.End_Date_Text__c=qpr.End_Date__c.day()+'.'+MonthFormatMap.get(qpr.End_Date__c.month())+'.'+qpr.End_Date__c.year();
                }
                
                //Added for APAC PR04243 - Date format        
                if(entityRegion == 'APJ' && !showContactSection){          
                    qpr.Effective_Date_Text__c = qpr.Effective_Date__c.day()+' '+monthNameFormatMap.get(qpr.Effective_Date__c.month())+' '+qpr.Effective_Date__c.year();
                     qpr.End_Date_Text__c = qpr.End_Date__c.day()+' '+monthNameFormatMap.get(qpr.End_Date__c.month())+' '+qpr.End_Date__c.year();
                }   
                //ALLHA02 SAP ROW    
                if(showContactSection){

                     qpr.Effective_Date_Text__c=monthNameFormatMap.get(qpr.Effective_Date__c.month())+' '+qpr.Effective_Date__c.day()+', '+qpr.Effective_Date__c.year();
                     qpr.End_Date_Text__c=monthNameFormatMap.get(qpr.End_Date__c.month())+' '+qpr.End_Date__c.day()+', '+qpr.End_Date__c.year();
                  }  
                  if(showContactSection && isJapanLocalizedTemplate){

                     qpr.Effective_Date_Text__c=qpr.Effective_Date__c.year()+'å¹´'+qpr.Effective_Date__c.month()+'æ'+qpr.Effective_Date__c.day()+'æ¥';
                     qpr.End_Date_Text__c=qpr.End_Date__c.year()+'å¹´'+qpr.End_Date__c.month()+'æ'+qpr.End_Date__c.day()+'æ¥';
                  }


          
                if(busTransactionType!=null&&(busTransactionType.contains('services')||busTransactionType.contains('education'))){
                    consultingSrvcEduList.add(qpr);                    
                } 
                if(busTransactionType!=null&&busTransactionType.contains('services')==false&&busTransactionType.contains('education')==false){
                    CASWInfoTableList.add(qpr);
                    ServicesPdcnList.add(qpr);
                    
                    Decimal plsf = qpr.Proposed_Lic_Sub_Fee__c;
                    long duration = (qpr.Effective_Date__c.daysBetween(qpr.End_Date__c) / 30.0).round();
                    
                    //MANAR08 - To fix divide by 0 exception (AR#1230)
                    System.debug('duration:'+duration );
                    Decimal mpffst = 0.0;
                    if(duration != 0)
                        mpffst = (plsf / duration).setScale(2, roundingMode.HALF_UP);
                        
                    //Decimal mpffst = (plsf / duration).setScale(2, roundingMode.HALF_UP);
                    
                    System.debug('D+++ plsf: ' + plsf + '    duration:' + duration);
                    ServicesPdcnToMpffst.put(qpr.Id, mpffst);
                }
                System.debug('qpr.Reason_for_no_charge__c----'+qpr.Reason_for_no_charge__c+'---'+qpr.Product_Name__c);
                
                /*                
                //MANAR08 - AR:1724 and 2187
                System.debug('***busTransactionType:'+busTransactionType +'\n qpr.CA_Pricing_Group__c:'+qpr.CA_Pricing_Group__c);
                if(entityRegion == 'LA' && busTransactionType != null && busTransactionType.equalsIgnoreCase('Education') && busTransactionType != null && qpr.CA_Pricing_Group__c == 'Education'){
                    educationListforLA.add(qpr);
                    System.debug('***In educationListforLA:'+ qpr.Product_Name__c);                     
                } */
                
                if(Test.isRunningTest()==true)
                {
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y'){
                        distributedOnDemandList.add(qpr);
                    }
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y'&&qpr.Mainframe_Distributed__c=='Mainframe'){
                        mainframeList.add(qpr);
                        UsageMaintanaceFee=UsageMaintanaceFee+qpr.Proposed_Maint_Fee__c;
                    }                
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&qpr.Mainframe_Distributed__c=='Distributed'&&qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y'){
                        distributedList.add(qpr);
                    }    
                     
                }
                else{
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&((qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y')||((qpr.No_Charge_Product__c=='Yes'||qpr.No_Charge_Product__c=='Y')&&(qpr.Reason_for_no_charge__c=='FOC'||qpr.Reason_for_no_charge__c=='Discontinued'||qpr.Reason_for_no_charge__c=='Stabilized')))){
                        distributedOnDemandList.add(qpr);
                        System.debug('1--'+qpr);
                    }
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&qpr.Mainframe_Distributed__c=='Mainframe'&&((qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y')||((qpr.No_Charge_Product__c=='Yes'||qpr.No_Charge_Product__c=='Y')&&(qpr.Reason_for_no_charge__c=='FOC'||qpr.Reason_for_no_charge__c=='Discontinued'||qpr.Reason_for_no_charge__c=='Stabilized')))){
                        mainframeList.add(qpr);
                        System.debug('2--'+qpr);
                        UsageMaintanaceFee=UsageMaintanaceFee+qpr.Proposed_Maint_Fee__c;
                    }                 
                    if(busTransactionType!=null&&busTransactionType.contains('time')&&qpr.Mainframe_Distributed__c=='Distributed'&&((qpr.No_Charge_Product__c!='Yes'&&qpr.No_Charge_Product__c!='Y')||((qpr.No_Charge_Product__c=='Yes'||qpr.No_Charge_Product__c=='Y')&&(qpr.Reason_for_no_charge__c=='FOC'||qpr.Reason_for_no_charge__c=='Discontinued'||qpr.Reason_for_no_charge__c=='Stabilized')))){
                        distributedList.add(qpr);
                        System.debug('3--'+qpr);
                    } 
            
                    //Added as part of APAC & Education QQ Project Common Reqirement Change in CA Product Reno 
                    if(busTransactionType != null && busTransactionType.contains('time')
                        && (qpr.Mainframe_Distributed__c == 'Distributed' && qpr.License_Type__c == 'Subscription') 
                        &&((qpr.No_Charge_Product__c != 'Yes' && qpr.No_Charge_Product__c != 'Y')||
                           ((qpr.No_Charge_Product__c == 'Yes'|| qpr.No_Charge_Product__c == 'Y')&&(qpr.Reason_for_no_charge__c == 'FOC'|| qpr.Reason_for_no_charge__c == 'Discontinued' || qpr.Reason_for_no_charge__c == 'Stabilized')))){
                        subscriptionProductsList.add(qpr);
                        System.debug('4--'+qpr);                    
                    }
                    
                    if(busTransactionType != null && busTransactionType.contains('time')
                        && (qpr.Mainframe_Distributed__c == 'Distributed' && qpr.License_Type__c != 'Subscription') 
                        &&((qpr.No_Charge_Product__c != 'Yes' && qpr.No_Charge_Product__c != 'Y')||
                           ((qpr.No_Charge_Product__c == 'Yes'|| qpr.No_Charge_Product__c == 'Y')&&(qpr.Reason_for_no_charge__c == 'FOC'|| qpr.Reason_for_no_charge__c == 'Discontinued' || qpr.Reason_for_no_charge__c == 'Stabilized')))){
                        nonSubscriptionProductsList.add(qpr);
                        System.debug('5--'+qpr);                    
                    }
                    
                  
                    
                    System.debug('KKKKLLLLL'+qpr.Delivery_Method__c);
                    // AR:1724 and 2187
                    System.debug('***busTransactionType:'+busTransactionType +'\n qpr.CA_Pricing_Group__c:'+qpr.CA_Pricing_Group__c);
                    if(entityRegion == 'LA' && busTransactionType != null && busTransactionType.equalsIgnoreCase('Education') && busTransactionType != null && qpr.CA_Pricing_Group__c == 'Education'){
                    System.debug('KKKK'+qpr.Delivery_Method__c);
                       if(qpr.Delivery_Method__c != null && qpr.Delivery_Method__c == 'WBT' || qpr.Delivery_Method__c == 'ILT Private' || qpr.Delivery_Method__c == 'ILT Public'){
                        caEducationInformationList.add(qpr);
                        }
                        if(qpr.Delivery_Method__c != null && qpr.Delivery_Method__c == 'TBD'){
                        System.debug('KKKK@@'+qpr.Delivery_Method__c);                                      
                       caEducationBucketPricingInformationList.add(qpr);
                        System.debug('k%%k'+caEducationBucketPricingInformationList);
                        }

                    isCAEducationTemplateforLA=true;
                        //System.debug('***In educationListforLA:'+ qpr.Product_Name__c);                     
                    } 
                    else
                    {
                    
                          //Added for Education QQ PR04433                    
                    if(qpr.Delivery_Method__c != null && qpr.Delivery_Method__c == 'WBT' || qpr.Delivery_Method__c == 'ILT Private' || qpr.Delivery_Method__c == 'ILT Public'){
                        caEducationInformationList.add(qpr);
                    }
                    if(qpr.Delivery_Method__c != null && qpr.Delivery_Method__c == 'TBD'){
                        caEducationBucketPricingInformationList.add(qpr);
                    }
                    }

                    
                }
                    if(qpr != null)
                    QPInfoTableList.add(qpr);
                    
                    if(qpr.License_Type__c=='Perpetual'){
                        PerpetualQuote=true;    
                    }
                    if(qpr.License_Type__c=='Subscription'){
                        SubscriptionQuote=true;    
                    }
                    if(qpr.Sterling_Quote__r.Maintenance_Payment__c > 0){
                        MaintenanceQuote=true;    
                    }
        
                    
                    
                    system.debug('LineItem:'+ListQPR.size());
                    ListQPR.add(qpr);
                    system.debug('LineItemAfter:'+ListQPR.size());  
            }
            if(SaasQuoteProducts.size()>0){
                saaSRender=true;
            //bajpi01 - for US300013 - starts here    
                for(Quote_Product_Report__c q:SaasQuoteProducts){
                    if(q.No_Charge_Product__c!='Y'){
                        SaasQuoteProductsRenewal.add(q);
                    }
                }
            }
           
            if(SaasQuoteProductsRenewal.size()>0){
            
                saaSRenderRenewal = true;
            }
            //bajpi01 - for US300013 - ends here
            
            if(cAOnPrimise.size()>0){
              onparmession=true;  
            }
            
            System.debug('paymentProfile'+paymentProfile);
            
           // if(isCSMQLtm || isAPIQLtm || isRAQLtm){
                for(PaymentPlan__c pp:paymentProfile){
                    
                    System.debug('PP'+pp);
                    Qwrapper.add(new QuoteOrderFormWrapper(pp.Date_Text__c,pp.Payment_Date__c, ListQPR[0].Proposed_Lic_Sub_Fee__c,ListQPR[0].Sterling_Quote__r.Maintenance_Payment__c,ListQPR[0].CurrencyIsoCode));
                    
                }
           // }
            System.debug('QWrapperBeforeSort'+QWrapper);
            QWrapper.sort();
            System.debug('QWrapperAfterSort'+QWrapper);
            
            // Mari ISTP R1, Calculating Monthly Production fee for CSM product
            if(csmQPR != null){
            
            Date qlEffDate =csmQPR.Effective_Date__c;
            Date qlEndDate=csmQPR.End_Date__c;
             if (qlEffDate != null && qlEndDate!= null && csmQPR.Proposed_Lic_Sub_Fee__c!= null)
            {
                Decimal Monthly_Production_Fee_Per_User_temp = csmQPR.Proposed_Lic_Sub_Fee__c / math.abs((qlEffDate.monthsBetween(qlEndDate)));
                Monthly_Production_Fee_Per_User = Monthly_Production_Fee_Per_User_temp.setScale(2);
                System.debug('Proposed Lic '+csmQPR.Proposed_Lic_Sub_Fee__c +'Months '+(qlEndDate.monthsBetween(qlEffDate)) +'Final Val '+Monthly_Production_Fee_Per_User);
            }
            // Mari ISTP R1, Calculating Monthly Production fee for CSM product
            // Covert the Users count in word
            if(csmQPR.Total_Quantity__c != null) NoUserscsmQPR = NumberToWord.convertWord((long)csmQPR.Total_Quantity__c);
         }   
            if(consultingSrvcEduList.size()==0){
                showCSrvcEdu=false;
            }
            if(consultingSrvcEduList.size()>0){
                showCSrvcEdu=true;
            }
            String cpqQuoteNum = QuoteRec.CPQ_Quote_Number__c;
            if(cpqQuoteNum != null){
                List<String> strList=cpqQuoteNum.Split('>');
                if(strList.size()>0){
                    for(String str:strList){
                        if(str.contains('</a')){
                            Integer strLen=str.length();
                            cpqQuoteNum=str.Substring(0,strLen-3);                    
                        }
                    }
                }
            }
            cpqQuoteNum_str=cpqQuoteNum;
            List<attachment> attachmentList=[Select name,lastmodifieddate from attachment where ParentId=:QuoteRec.Id order by lastmodifieddate];
            List<attachment> templateAttachments=new List<attachment>(); 
            if(attachmentList.size()>0){            
                for(attachment att:attachmentList){
                    if(att.name.contains(cpqQuoteNum)){
                        templateAttachments.add(att);
                    }
                }
            }
            versionNum = templateAttachments.size();
            system.debug('TestversionNum'+versionNum);
            FooterString = 'SFDC#'+QuoteRec.scpq__OpportunityId__r.Opportunity_Number__c+': Quote#'+cpqQuoteNum+' Version#'+VersionNum_Str+'  '; 
                       
        }catch(Exception e){
        system.debug('EMessage'+e.getMessage());
        }        
 
        if(licenseType=='Customer On-Premises Subscription License'){
            this.CstmrOnPremSubscription=true;
            this.customerLabel=true;
            if(CASWInfoTableList.size()>0){
                this.CASoftwareInfoSubsnTbl=true; 
            }
            this.PaymentProfileTblSubscription=true;
            this.Subscription_On_Prem_Cstmr_para1=true; 
            if(entityRegion=='EMEA'){
                this.EMEA_CA_Subscription_On_Premise_Governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
                this.isPremise = true; // ALLHA02 for setting governing contract for premise type
                //this.customerLabel=true;

                System.debug('IsPremise '+isPremise);
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
            if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }           
        }
        if(licenseType=='Customer On-Premises Perpetual License'){
            this.CstmrOnPremPerpetual=true; 
            this.customerLabel=true;
            if(CASWInfoTableList.size()>0){
                this.CASoftwareInfoPerpetualTbl=true;
            }
            this.PaymentProfileTblPerpetual=true;
            this.Perpetual_On_Premise_Para_1=true;            
            if(entityRegion=='EMEA'){
                this.EMEA_CA_Perpetual_On_Premise_Governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
                this.isPremise = true; 
                System.debug('IsPremise '+isPremise);// ALLHA02 for setting governing contract for premise type
                //this.customerLabel=true;
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
            if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }
        }
        if(licenseType=='Customer On-Demand Subscription License'){
            this.CstmrOnDemandSbcrn=true;
            this.customerLabel=true;
            if(ServicesPdcnList.size()>0){
                this.ServicesProduction=true; 
            }             
            this.PaymentProfileTblSubscription=true;
            this.Subscription_On_Demand_Para1=true;  
            if(entityRegion=='EMEA'){
                this.EMEA_CA_subscription_on_demand_governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
                //this.customerLabel=true;
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
            if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }
        }
        if(licenseType=='MSP On-Premises Subscription License'){
            this.MSPOnPremSubscription=true; 
            this.serviceProviderLabel=true;
            if(CASWInfoTableList.size()>0){
                this.CASoftwareInfoSubsnTbl=true;
            }
            this.PaymentProfileTblSubscription=true; 
            this.Subscription_on_prem_MSP_Para1=true;   
            
            if(entityRegion=='EMEA'){
                this.EMEA_CA_Subscription_On_Premise_MSP_governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
                this.isPremise = true; 
                System.debug('IsPremise '+isPremise);// ALLHA02 for setting governing contract for premise type
               // this.serviceProviderLabel=true;
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
            if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }  
        }
        if(licenseType=='MSP On-Premises Perpetual License'){
            this.MSPOnPremPerpetual=true; 
             this.serviceProviderLabel=true;
            if(CASWInfoTableList.size()>0){
                this.CASoftwareInfoPerpetualTbl=true;
            }
            this.PaymentProfileTblPerpetual=true;
            this.Perpetual_On_Premise_MSP_Para1=true;
            //this.serviceProviderLabel=true;
            if(entityRegion=='EMEA'){
                this.EMEA_CA_Perpetual_on_premise_MSP_governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
                this.isPremise = true;
                System.debug('IsPremise '+isPremise); // ALLHA02 for setting governing contract for premise type
                //this.serviceProviderLabel=true;
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
             if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }  
        }
        if(licenseType=='MSP On-Demand Subscription License'){
            this.MSPOnDemandSbcrn=true;
            this.serviceProviderLabel=true; 
            if(ServicesPdcnList.size()>0){
                this.ServicesProduction=true; 
            }
            this.PaymentProfileTblSubscription=true;   
            this.Subscription_On_Demand_MSP_Para1=true;
            if(entityRegion=='EMEA'){
                this.EMEA_CA_Subscription_On_Demand_MSP_governing_contract=true;
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_Governing_contract=true;
               // this.serviceProviderLabel=true;
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
             if(langCode=='pt_BR'){
            this.Langcustom=true;
            this.Langcustombrazil=false;
            }   
        }
        
        System.debug('licenseType:'+licenseType +'\nentityRegion:'+entityRegion +' Ispremise '+isPremise);
        


        //PR04433- CA Education quote template
        if(licenseType == 'CA Education'){            
                        
          this.showCSrvcEdu = false;
            this.QuoteSOW_Productmaterialflag2 = false;
            this.QuoteSOW_Productmaterialflag1 = false;
            
            this.English2set = false;
            this.Frenchset=false;
            this.Italianset=false;
            this.Germanset=false;
            if(entityRegion == 'LA'&&isCAEducationTemplateforLA==true) {
                
                //caEducationBucketInformationTbl=true;              
                caEducationPaymentProfileTbl=false;
                isCAEducationTemplateforLA=true;
                caEducationPaymentProfileTblforLA=true;
                //caEducationInformationTbl=true;
                try{
               Decimal taxPercent=0;
               if(apexpages.currentpage().getparameters().get('tax')!=null)
                taxPercent=Decimal.valueof(apexpages.currentpage().getparameters().get('tax'));
                System.debug('@@@@'+caEducationBucketInformationTbl);
            
                if(paymentProfile.size()>0)
                {   
                    for(PaymentPlan__c pay:paymentProfile)
                    if(pay.Payment_Total__c!=null)
                    pay.Payment_Total__c=pay.Payment_Total__c+(pay.Payment_Total__c*taxPercent);
                }
                if(caEducationInformationList.size()>0)
                {
                    for(Quote_Product_Report__c Qpr :caEducationInformationList)
                    {
                        if(Qpr.Total_Proposed_Price__c!=null)
                        Qpr.Total_Proposed_Price__c=Qpr.Total_Proposed_Price__c+(Qpr.Total_Proposed_Price__c*taxPercent);
                    }
                    caEducationInformationTbl = true;
                }
                if(caEducationBucketPricingInformationList.size()>0)
                {
                    for(Quote_Product_Report__c Qpr :caEducationBucketPricingInformationList)
                    {
                        if(Qpr.Total_Proposed_Price__c!=null)
                        Qpr.Total_Proposed_Price__c=Qpr.Total_Proposed_Price__c+(Qpr.Total_Proposed_Price__c*taxPercent);
                    }
                    caEducationBucketInformationTbl = true;
                }
                
                
                    //Condition included for Countries having English2 templates
            if((countryStr=='be'||countryStr=='lu'||countryStr=='dk'||countryStr=='gl'||countryStr=='is'||countryStr=='ee'||countryStr=='fi'||countryStr=='lt'||countryStr=='lv'||countryStr=='nl'||countryStr=='no'||countryStr == 'se')&&langCode == 'en')
                this.English2set = true; 
            
            //Condition included for French Translation in CA Education quote template
            if(langCode == 'fr')
                this.Frenchset = true;
                
            //Condition included for Italian Translation in CA Education quote template
            if(langCode == 'it')
                this.Italianset= true;
                
             //Condition included for German Translation in CA Education quote template
            if(langCode == 'de' )
                this.Germanset= true;  
    
            
            if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }    
                
                  
                }
               catch(exception e){}
            }
            
        
            else
            {
            this.isCAEducationTemplate = true;
            this.caEducationPaymentProfileTbl = true;           
            this.customerLabel = true;
            
            
            
            //Condition included for Countries having English2 templates
            if((countryStr=='be'||countryStr=='lu'||countryStr=='dk'||countryStr=='gl'||countryStr=='is'||countryStr=='ee'||countryStr=='fi'||countryStr=='lt'||countryStr=='lv'||countryStr=='nl'||countryStr=='no'||countryStr == 'se')&&langCode == 'en')
                this.English2set = true; 
            
            //Condition included for French Translation in CA Education quote template
            if(langCode == 'fr')
                this.Frenchset = true;
                
            //Condition included for Italian Translation in CA Education quote template
            if(langCode == 'it')
                this.Italianset= true;
                
             //Condition included for German Translation in CA Education quote template
            if(langCode == 'de' )
                this.Germanset= true;  
    
            if(caEducationInformationList.size() > 0){
                this.caEducationInformationTbl = true;
            }
    
            if(caEducationBucketPricingInformationList.size() > 0){
                this.caEducationBucketInformationTbl = true;
            }
            if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }            
          }
        }
        
        if(licenseType=='CA Product Renewal'){
        system.debug('licenseType:'+licenseType+' entityRegion '+entityRegion);
            this.CAProductRenewal = true;
            
            if(mainframeList.size()>0){
                this.mainframeTbl = true;                   
                this.mainframeCPUTbl = true;
            }
            //Education QQ - HTFT
            if(QuoteRec.CA_Commissionable_Area__c == 'High Touch Fast Track')
                isHTFTTemplate = true;
                
            //Modified for APAC & Education QQ requirement 
            if(nonSubscriptionProductsList.size() > 0){
                this.nonSubscriptionProductsGrid  = true;               
            }
            if(subscriptionProductsList.size()>0){ 
                this.subscriptionProductsGrid = true;
            }          
              
            this.checkBoxPanel = true;
            this.RenewalDatePanelStd = true;
            
            if(entityRegion=='EMEA'){
                this.EMEA_RENO_Standard=true;
                System.debug('EMEA_RENO_Standard: '+EMEA_RENO_Standard);
            }
            if(entityRegion!='EMEA'){
                this.NON_EMEA_RENO_Standard=true;               
            } 
            if(entityRegion == 'APJ'){// APAC PR04243
                this.isAPJ = true;
            }  
        }
        if(licenseType=='Maintenance Renewal on Nimsoft Perpetual License'){
            this.MRenewOnNimsoftPerpetual=true;               
            //this.distributedOnDemandTbl=true;           
            this.RenewalDatePanelMain=true;
            this.GoverningContracts=true;  
            //EMEA
            
            if(entityRegion=='EMEA'){
                this.showEffectiveOnSigDateNotice=true;
                  if(LangCode=='de'||LangCode=='fr'||LangCode=='es'||LangCode=='it'||LangCode=='en'||LangCode==null){
                              this.EMEA_RENO_Support=true;
                  }
                if(LangCode!='de'&&LangCode!='fr'&&LangCode!='es'&&LangCode!='it'&&LangCode!='en'&&LangCode!=null){
                              this.EMEA_RENO_SupportTxtBox=true;
                  }
               
              if(LangCode=='it'){
                        this.EMEARenoItalianPara7=true;
                   }
                
            }
            if(entityRegion!='EMEA'&&(langCode=='es_MX'||langCode=='pt_BR'||langCode=='en'||langCode=='zh_CN'||langCode=='zh_TW'||langCode=='ko'||langCode=='ja')&&countryStr!='gb'){
                this.NON_EMEA_RENO_Support=true;               
            } 
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
             
        }
        if(licenseType=='Renewal of Nimsoft Subscription License'){
            this.showProductName = true;
            this.MRenewOnNimsoftSubscription=true; 
            this.OnDemandAdminLabel=true;
            this.distributedOnDemandTbl=true;
            this.ProductConvertedLine=true; 
            this.RenewalDatePanelSub=true;
            this.GoverningContracts=true;
            showDistributorOrOnDemand = true;
            //EMEA            
            if(entityRegion=='EMEA'){
                this.EMEA_RENO_Subscription=true;
                this.showEffectiveOnSigDateNotice=true;
            }            
            if(entityRegion!='EMEA'&&(langCode=='es_MX'||langCode=='pt_BR'||langCode=='en'||langCode=='zh_CN'||langCode=='zh_TW'||langCode=='ko'||langCode=='ja')&&countryStr!='gb'){
                this.NON_EMEA_RENO_Subscription=true;               
            } 
            if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
            
        }
        if(licenseType=='Renewal of Nimsoft Subscription License (On-Premises)'){
            this.distributedOnDemandTbl = true;
            this.showDistributorOrOnDemand = false;
            this.showDistributorCASoftware = true;
            this.showSAASOnDemand = false;
            this.showProductName = true;
            this.showEmptyTable = false;
            this.RenewalDatePanelSub = true;
            if(entityRegion=='EMEA'){
                  this.EMEA_RENO_Support=true;
                  this.showEffectiveOnSigDateNotice=true;                  
            }else if(entityRegion!='EMEA'){
                this.NON_EMEA_RENO_Subscription=true;
            }
            if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
        }
        if(licenseType=='Renewal of Nimsoft Subscription License (On-Demand)'){
            this.distributedOnDemandTbl = true;
            this.showDistributorOrOnDemand = false;
            this.showDistributorCASoftware = false;
            this.showSAASOnDemand = true;
            this.showAvailableFunctionality = true;
            this.showProductName = false;
            this.showEmptyTable = true;
            this.RenewalDatePanelSub = true;
            this.showRenewalOnDemandPara = true;
            
            if(entityRegion=='EMEA'){
                this.showEffectiveOnSigDateNotice=true;                  
            }
        if(entityRegion == 'APJ'){//- APAC PR04243
                this.isAPJ = true;
            }
        }       
        if(RemittanceInfo!=null && RemittanceInfo!=''){
            if(RemittanceInfo.contains(',')){
                RemittanceInfoList=RemittanceInfo.Split(',');
            }
            if(!RemittanceInfo.contains(',')){
                RemittanceInfoList.add(RemittanceInfo);
            }
        }
        
        if(LangCode=='fr'){
            showEmptyTableForFrench = true;
            EMEA_RENO_Standard = false;
            EMEA_RENO_Subscription = false;
            EMEA_RENO_SupportTxtBox = false;
        }
        
        
        // Printing APAC Values
        System.debug('IsDirectQuote :'+isDirectQuote);
        System.debug('isIndirectQuote :'+isIndirectQuote);
        System.debug('apacCountriesAllowedForSignRenewal :'+apacCountriesAllowedForSignRenewal);
        System.debug('displaySignAPAC :'+displaySignAPAC);
        System.debug('isAPJ :'+isAPJ);
         
        Id cagreylogoId = [Select Id,Name from Document Where Name = 'CA_Logo_Grey' and Folder.Name = 'Quick Quote Images'].Id;
        cagreylogoimgurl = System.URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+cagreylogoId+'&oid='+UserInfo.getOrganizationId();
    }
    public scpq__SciQuote__c getQuoteRec(){
        return QuoteRec;
    }
    public List<PaymentPlan__c> getPaymentProfile(){
        return paymentProfile;
    }
    public List<Quote_Product_Report__c> getQuoteProductRpt(){
        return quotePdctReportList;
    }
    public List<Quote_Product_Report__c> getCSrvcEduQPR(){
        return consultingSrvcEduList;
    } 
    public List<Quote_Product_Report__c> getDistributedList(){
        return distributedList;
    }
    public List<Quote_Product_Report__c> getMainframeList(){
        return mainframeList;
    } 
    public List<Quote_Product_Report__c> getDistributedOnDemandList(){
        return distributedOnDemandList;
    } 
    public List<Quote_Product_Report__c> getCASWInfoTableList(){
        return CASWInfoTableList;
    }
    public List<Quote_Product_Report__c> getQPInfoTableList(){
        return QPInfoTableList;
    }
     public List<Quote_Product_Report__c> getServicesPdcnList(){
        return ServicesPdcnList;
    }
    
    /*
    //MANAR08 - AR:1724 and 2187
     public List<Quote_Product_Report__c> getEducationListforLA(){
        return distributedList;
    }*/

    //Added for APAC code and Education QQ code
    public List<Quote_Product_Report__c> getNonSubscriptionProductsList(){
        return nonSubscriptionProductsList;
    }
     public List<Quote_Product_Report__c> getSubscriptionProductsList(){
        return subscriptionProductsList;
    }
     public List<Quote_Product_Report__c> getListQPR(){
        return ListQPR;
    }    
    
    //PR04433
    public List<Quote_Product_Report__c> getCAEducationInformationList(){
        return caEducationInformationList;
    }
    //PR04433
    public List<Quote_Product_Report__c> getCAEducationBucketPricingInformationList(){
        return caEducationBucketPricingInformationList;
    }
    
    public Map<Id,Decimal> getServicesPdcnToMpffst()
    {
        return ServicesPdcnToMpffst;
    }
    
    
    public Map<Id,Decimal> getMonthlyProductionFeePerUnit()
    {        
        return MonthlyProductionFeePerUnit;
    }
    
    
    
    
    public String getLangCode(){
        return langCode;
    } 
    public String getCAEntity(){
      
        return CAEntity;
    }
    public String getRemittanceInfo(){
        return RemittanceInfo;
    } 
    public String getTerritory(){
        return territory;
    }
     public String getFooterString(){
        return FooterString;
    }
    public List<String> getRemittanceInfoList(){
        return RemittanceInfoList;
    }
    public String getBaseURL(){
        String baseURL=URL.getSalesforceBaseUrl().toExternalForm();
        baseURL=baseURL+System.Label.CALogoDocumentLink;        
        return baseURL; 
    }    
    public String getCPQQuoteNum(){             
        return cpqQuoteNum_str; 
    }
     public Boolean getIsRemittenceNeeded() {
        /*  
        if(licenseType == 'CA Product Renewal')
            return false;
            else
            return true;
        */
         if(isAPJ)
         return true;
         else
         return false;
    }
     public Boolean getIsLineNeed() {
     
     if (langCode =='en' && licenseType == 'CA Product Renewal')   
        return false;
        else 
        return true;
    }
    public boolean getIsLanguageEng(){
        if(langCode =='en')
            return true;
        else
            return false;
    }





}