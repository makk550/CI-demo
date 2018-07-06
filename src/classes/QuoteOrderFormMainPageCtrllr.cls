Public Class QuoteOrderFormMainPageCtrllr{
    Public scpq__SciQuote__c QuoteRec{set;get;}
    Public String OrderType;
    Public String LicenseType;
    public Boolean notApproved{get;set;}  
    Public String languageOption{get;set;}
    Public Map<String,String> isoCodeLangMap=new Map<String,String>();
    Public List<Quote_Product_Report__c> quotePdctReportList=new List<Quote_Product_Report__c>();
    Public String langCode;
    Public Boolean isPerpetualQuote=false;
    Public Boolean isSubscriptionQuote=false;
    public Boolean isDurationBasedSubscriptionQuote = false;
    public Boolean isAPIQLtm = false;
    public Boolean isCSMQLtm = false;
    public Boolean Isdecimal{set;get;} 
    public Boolean isRAQLtm = false;
    Public List<CML_CA_Entities__c>  CMLCAEntitiesValues=CML_CA_Entities__c.getall().values();
    Public Boolean CAEntityError=false;
    Public String CAEntity;
    Public String customerCPNJ{set;get;}
    Public Boolean displayOptionsBlock=false;
    Public Boolean LicenseNotSelected{get;set;}
    Public transient Boolean resellerAgreementNumberNotSelected{get;set;}
    Public transient Boolean agreementEndDateNotSelected{get;set;}       
    public Boolean LanguageNotSelected{get;set;}   
    public Boolean taxnotfilled{get;set;} 
    public transient Boolean ShipmentAddressNotSelected{get;set;}  
    Public String attachmentName;
    Public Pagereference quoteTemplateLink;
    Public String VFPageName;
    Public Integer versionNum=0;
    Public String countryStr;
    Public List<String> SoldToAddressInfoList=new List<String>();
    Public Boolean commissionableAreaErr=false; 
    Public Boolean CASWInfoBol=false; 
    Public Boolean SrvcEduBol=false; 
    Public String orderFormNo{get;set;}
    Public Map<Id,Quote_Product_Report__c> CASWInfoMap=new Map<Id,Quote_Product_Report__c>();  
    Public Map<Id,Quote_Product_Report__c> SrvcEduMap=new Map<Id,Quote_Product_Report__c>();  
    Public String territoryConuntry{get;set;}   
    Public Boolean orderFormNoBol=false; 
    Public Boolean territoryConuntryBol=false;
    String region;
    public Boolean agileNewPrdct= false;
    public Boolean agileScreen{set;get;}
    
    //Added by ALLHA02 SAP ROW Project
    Public Boolean showContactSection=false;
    Public String billingDept{get;set;}
    Public String shippingDept{get;set;}
    Public String technicalDept{get;set;}
    Public Boolean depDetailsnotSelected{get;set;}   

    
    Public Boolean isSaasComArea = false; //Set this to true if Commissionable Area = “Medium Touch Clarity SaaS”
    
    //Added by MANAR08 AR:2187 
    /*
    Public Boolean taxPercentBol=false;
    
    Public Boolean isEducationQuotePdctLnItem = false;  */
    
    //Added yedra01 AR:1724,2187
    public boolean showTax=false;
    Public String taxPercent{get;set;}
    //public scpq__SciQuote__c taxPercent{set;get;}
    //Added by (Mari-->ISTP,R1,2014)
    public String resellerAgreementNumber{get;set;}
   
    public String agreementEndDate {get;set;}
    public string Language{get;set;}
    public string ShipmentAddress{get;set;}
    public transient boolean CommonBoolean{get;set;}
    public String shipMethod{get;set;}
    //Added by (Mari-->ISTP,R1,2014)
    
    //Added as part of Education QQ PR04433
    Public Boolean isCAEducationQuote = false;
    Public Boolean allCAEducation =  true;
    
    //Added as part of deal value per annum
    Decimal dealTermDuration = null;
    Decimal dealTermVal_Month = 0;
    Decimal dealTermVal = 0;
    Decimal dealTermVal_Converted = 0;

    public class VariablesQuotePdctLnItem{
        public Quote_Product_Report__c quotePdctLnItem{get;set;}
        public String variables_str{get; set;} 
        public VariablesQuotePdctLnItem(Quote_Product_Report__c qpr,String str) {
            quotePdctLnItem=qpr;
            variables_str=str;
        }
    }
    
    public class ShipQuotePdctLnItem{
        public Quote_Product_Report__c quotePdctLnItem{get;set;}
        public String ship_str{get; set;} 
        public ShipQuotePdctLnItem(Quote_Product_Report__c qpr,String str) {
            quotePdctLnItem=qpr;
            ship_str=str;
        }
    }    
    
    Public List<VariablesQuotePdctLnItem> VariablesQuotePdctLnItemList=new List<VariablesQuotePdctLnItem>();  
    Public List<ShipQuotePdctLnItem> ShipQuotePdctLnItemList=new List<ShipQuotePdctLnItem>();
     public Integer dealValue=75000;
    public QuoteOrderFormMainPageCtrllr(){
        QuoteRec=new scpq__SciQuote__c();
       isDecimal=false;
        try{
            QuoteRec= [SELECT Id,Name,scpq__Status__c,CA_Quote_Type__c,CA_Commissionable_Area__c,Sold_To_Address__c,CA_Partner_Address__c,CA_Booking_Country__c,CA_End_User_Address__c,
            CPQ_Quote_Number__c,CA_CPQ_Quote_Status__c,CA_Effective_Date__c,scpq__OpportunityId__r.Rpt_Region__c,scpq__OpportunityId__r.Rpt_Area__c,CA_Contract_End_Date__c,CA_CPQ_Quote_Total__c, 
            scpq__OpportunityId__r.Rpt_Territory_Country__c,scpq__OpportunityId__r.Rpt_Country__c,CurrencyIsoCode,Is_this_an_Agile_Central_Transaction__c  
            FROM scpq__SciQuote__c WHERE Id =:ApexPages.currentPage().getParameters().get('id')];
            
        
         
            
            quotePdctReportList=[Select id,name,Sterling_Quote__c,Old_Auth_Use_Model__c,Auth_Use_Model__c,License_Type__c,
            Product_Name__c,Operating_System__c,Total_Quantity__c,License_Metric__c,Effective_Date__c,End_Date__c,
            Effective_Date_Text__c,End_Date_Text__c,Shipping_Required__c,Proposed_Lic_Sub_Fee__c,Proposed_Maint_Fee__c,
            Bus_Transaction_Type__c,Variables__c,CA_Pricing_Group__c, CurrencyIsoCode,Product_Material__r.Name from Quote_Product_Report__c where Sterling_Quote__c=:QuoteRec.Id];
            //Education QQ changes
         
            if(QuoteRec.CA_Quote_Type__c=='New Product'){
                orderFormNoBol=true; 
                territoryConuntryBol=true;
            }
            
            
            
            
            
            
        }Catch(Exception e){
        }
      
        for(Quote_Product_Report__c quotePdctElt:quotePdctReportList){
            
            if(quotePdctElt.Product_Material__r.Name == Label.Release_Automation_SKU){
                    isRAQLtm = true;
                   
            }
            if(quotePdctElt.Product_Material__r.Name == Label.API_Gateway_SKU){
                    isAPIQLtm = true;
                   
            }
            if(quotePdctElt.Product_Material__r.Name == Label.CSM_SKU_1 || quotePdctElt.Product_Material__r.Name == Label.CSM_SKU_2){
                    isCSMQLtm = true;
                    
            }
            
            if(quotePdctElt.License_Type__c=='Perpetual'){
                isPerpetualQuote=true;    
            }
            if(quotePdctElt.License_Type__c=='Subscription'){
                isSubscriptionQuote=true;    
            }
            if(quotePdctElt.License_Type__c=='Duration Based Subscription'){
                isDurationBasedSubscriptionQuote=true;    
            }
            
            String busTransactionType=quotePdctElt.Bus_Transaction_Type__c;
            if(busTransactionType!=null&&busTransactionType!=''){
                busTransactionType=busTransactionType.toLowerCase();
            }
            if(busTransactionType!=null&&(busTransactionType.contains('services')||busTransactionType.contains('education'))&&QuoteRec.CA_Quote_Type__c=='New Product'){
                //SrvcEduMap.put(quotePdctElt.Id,quotePdctElt); 
                String variablesQPR=quotePdctElt.Variables__c;
                VariablesQuotePdctLnItemList.add(new VariablesQuotePdctLnItem(quotePdctElt,variablesQPR));                  
            } 
            if(busTransactionType!=null&&busTransactionType.contains('services')==false&&busTransactionType.contains('education')==false&&QuoteRec.CA_Quote_Type__c=='New Product'){
               //CASWInfoMap.put(quotePdctElt.Id,quotePdctElt);
               String shipQPR=quotePdctElt.Shipping_Required__c;
               if(shipQPR==null||shipQPR==''){
                   shipQPR='Shipping Required';
               }
               ShipQuotePdctLnItemList.add(new ShipQuotePdctLnItem(quotePdctElt,shipQPR));   
            }
            
            
             
        }

     //PR04433-Checking whether all the lines are CA Education 
        Integer cou=0;   
        for(Quote_Product_Report__c qpr:quotePdctReportList){
            if(QuoteRec.CA_Quote_Type__c == 'New Product'){         
               //Added by Yedra01 for AR:1724,2187
                if(qpr.CA_Pricing_Group__c == 'Education' && qpr.Bus_Transaction_Type__c == 'Education') {
                    if(QuoteRec.scpq__OpportunityId__r.Rpt_Region__c!=null)
                    {
                        String oppGeo=QuoteRec.scpq__OpportunityId__r.Rpt_Region__c.toLowerCase();
                        if(QuoteRec.scpq__OpportunityId__r.Rpt_Region__c=='la') 
                        {            
                        cou+=1;                        
                        }
                        
                    }
                }
                else { 
                     if((qpr.CA_Pricing_Group__c != 'Education' || qpr.Bus_Transaction_Type__c != 'Education')){
                        System.debug('+++++++++++ CA Education Quote type FALSE +++++++++++');
                        allCAEducation = false;  
                        break;
                    }
                }            
            }           
        }
        
        if(quotePdctReportList.size()==cou&&quotePdctReportList.size()>0)
        showTax=true;
        
        if(allCAEducation){
            isCAEducationQuote = true;
            orderFormNoBol = false;
        }

        try{
            if(QuoteRec.Sold_To_Address__c!=null&&QuoteRec.Sold_To_Address__c!=''){
                String soldToAddress=QuoteRec.Sold_To_Address__c;
                if(soldToAddress.contains(',')){
                    SoldToAddressInfoList=soldToAddress.Split(',');
                    System.debug('### quoteOrderFormMainPageCtrlr line 42 SoldToAddressInfoList'+SoldToAddressInfoList);
                    if(SoldToAddressInfoList.size()>0){
                        Integer listSize=SoldToAddressInfoList.size();
                        countryStr=SoldToAddressInfoList[listSize-1];
                    }        
                }            
            }
               
            //Added by ALLHA02
            if(countryStr.toLowerCase().trim()=='jp' ){
                    showContactSection=true;
              }

         


        }Catch(Exception e){

            System.debug('Exception raised '+e);
        }
            
            

         
       
        
        try{
            for(CML_CA_Entities__c entity:CMLCAEntitiesValues){
                String countryCS=entity.Country__c;
                countryCS=countryCS.toLowerCase();
                if(countryStr!=null&&countryStr!=''){
                    countryStr=countryStr.toLowerCase();
                    countryStr=countryStr.trim();
                
                    if(countryCS==countryStr){                        
                        
                            CAEntity=entity.Contracting_Entity_Name__c; 
                             region=QuoteRec.scpq__OpportunityId__r.Rpt_Region__c;

                    }
                }
            } 
            if(CAEntity==''||CAEntity==null){
                CAEntityError=true;
            }
        }Catch(Exception e){
        }        
        
        if(VariablesQuotePdctLnItemList.size()>0 && !isCAEducationQuote){
            SrvcEduBol=true;
        }
        if(ShipQuotePdctLnItemList.size()>0){
            CASWInfoBol=true;
        }

/*
        //Added by MANAR08 AR:2187 
        if(isEducationQuotePdctLnItem && region=='LA'){
            System.debug('isEducationQuotePdctLnItem: '+ isEducationQuotePdctLnItem + 'region :'+region );
            taxPercentBol = true;       
        }
*/  
        isoCodeLangMap.put('German','de');
        isoCodeLangMap.put('French','fr');
        isoCodeLangMap.put('Italian','it');
        isoCodeLangMap.put('European Spanish','es');
        isoCodeLangMap.put('Latin American Spanish','es_MX');  
        isoCodeLangMap.put('Simplified Chinese','zh_CN');
        isoCodeLangMap.put('Traditional Chinese','zh_TW');
        isoCodeLangMap.put('Korean','ko');
        isoCodeLangMap.put('Japanese','ja');
        isoCodeLangMap.put('English','en');
        isoCodeLangMap.put('Brazilian Portuguese','pt_BR'); 
        isoCodeLangMap.put('European Portuguese','pt_PT'); 
        //Added by Yedra01 AR:2187 and 1724
        isoCodeLangMap.put('Brazilian English','en');
        isoCodeLangMap.put('Latin American English','en');   
        


    }
    
    
    Public Boolean getDisplayOptionsBlock(){
        return displayOptionsBlock;
    }
    Public String getLicenseType(){
        return LicenseType;
    } 
    
    Public void setLicenseType(String licenseStr){
        this.LicenseType=licenseStr;
    }
    
    Public List<VariablesQuotePdctLnItem> getVariablesQuotePdctLnItemList(){
        return VariablesQuotePdctLnItemList;
    } 
    
    Public void setVariablesQuotePdctLnItemList(List<VariablesQuotePdctLnItem> LineItems){
        this.VariablesQuotePdctLnItemList=LineItems;
    }
    
    Public List<ShipQuotePdctLnItem> getShipQuotePdctLnItemList(){
        return ShipQuotePdctLnItemList;
    } 
    
    Public void setShipQuotePdctLnItemList(List<ShipQuotePdctLnItem> LineItems){
        this.ShipQuotePdctLnItemList=LineItems;
    }
    
    
    public List<SelectOption> getLicenseTypes() {
        List<SelectOption> options = new List<SelectOption>();
        Decimal delValue=(Decimal)dealValue;
        //Calucated Deal value Per annum
             Map<String, Decimal> isoCodeToConversionRate = new Map<String, Decimal>();
                for(CurrencyType ct : [SELECT IsoCode, ConversionRate FROM CurrencyType])
                    isoCodeToConversionRate.put(ct.IsoCode, ct.ConversionRate);
            
            if(QuoteRec!= null && QuoteRec.CA_Effective_Date__c != null && QuoteRec.CA_Contract_End_Date__c != null ){         
                  dealTermDuration = TAPRulesUtility.getMonthsBetween(QuoteRec.CA_Effective_Date__c, QuoteRec.CA_Contract_End_Date__c);
                  System.debug('++++++++dealTermDuration++++++++++'+dealTermDuration);
             }
       if( dealTermDuration != null && QuoteRec != null && QuoteRec.CA_CPQ_Quote_Total__c != null && QuoteRec.CA_CPQ_Quote_Total__c != 0){
        
                System.debug('Total Quote Value'+ QuoteRec.CA_CPQ_Quote_Total__c);
               
                dealTermVal_Converted = QuoteRec.CA_CPQ_Quote_Total__c/ isoCodeToConversionRate.get(QuoteRec.CurrencyIsoCode);
                dealTermVal_Month = dealTermVal_Converted/dealTermDuration;
                System.debug('Total Quote Value After Converted'+ dealTermVal_Converted);
               
                // calculating one year deal term value.
                dealTermVal = dealTermVal_Month*12;
                //But CA Education Quote consider Quote TOTAL value
               
                    
                System.debug('++++++++dealTermval++++++++++'+dealTermVal );
       }
        if((QuoteRec.CA_Quote_Type__c=='New Product'&&QuoteRec.Is_this_an_Agile_Central_Transaction__c!='No')&&QuoteRec.Is_this_an_Agile_Central_Transaction__c!=null){
            options.add(new SelectOption('CA Agile Central New Order Form','CA Agile Central New Order Form'));
            agileNewPrdct=true;
            
        }else if(QuoteRec.CA_Quote_Type__c=='New Product'){
            
            
            if (isRAQLtm){
                options.add(new SelectOption('CA Release Automation Partner Advantage Offering','CA Release Automation Partner Advantage Offering'));               
            }
            else if (isCSMQLtm){
                options.add(new SelectOption('CA CSM Partner Advantage Offering','CA CSM Partner Advantage Offering'));             
            }
            else if (isAPIQLtm){
                options.add(new SelectOption('CA API Gateway Partner Advantage Offering','CA API Gateway Partner Advantage Offering'));             
            }
            else if(isCAEducationQuote){
                options.add(new SelectOption('CA Education','CA Education'));
            }else if(isDurationBasedSubscriptionQuote){                
                options.add(new SelectOption('Customer On-Demand Subscription License','Customer On-Demand Subscription License'));
                options.add(new SelectOption('MSP On-Demand Subscription License','MSP On-Demand Subscription License'));
            }else if(isPerpetualQuote==true&&isSubscriptionQuote==false){                
                options.add(new SelectOption('Customer On-Premises Perpetual License','Customer On-Premises Perpetual License'));
                options.add(new SelectOption('MSP On-Premises Perpetual License','MSP On-Premises Perpetual License'));
            }else if(isPerpetualQuote==false&&isSubscriptionQuote==true){                
                options.add(new SelectOption('Customer On-Premises Subscription License','Customer On-Premises Subscription License'));
                options.add(new SelectOption('Customer On-Demand Subscription License','Customer On-Demand Subscription License'));
                options.add(new SelectOption('MSP On-Premises Subscription License','MSP On-Premises Subscription License'));
                options.add(new SelectOption('MSP On-Demand Subscription License','MSP On-Demand Subscription License'));
            }else if(isPerpetualQuote==true&&isSubscriptionQuote==true){                
                options.add(new SelectOption('Customer On-Premises Subscription License','Customer On-Premises Subscription License'));
                options.add(new SelectOption('Customer On-Premises Perpetual License','Customer On-Premises Perpetual License'));
                options.add(new SelectOption('MSP On-Premises Subscription License','MSP On-Premises Subscription License'));
                options.add(new SelectOption('MSP On-Premises Perpetual License','MSP On-Premises Perpetual License'));
            }
            
        
        }
      if(QuoteRec.CA_Quote_Type__c=='Renewal'){
           
           /*YEDRA01 for AR:2994*/
        
             if((QuoteRec.CA_Commissionable_Area__c != null && QuoteRec.CA_Commissionable_Area__c != '') && QuoteRec.CA_Commissionable_Area__c == 'Medium Touch Nimsoft SaaS'){
               options.add(new SelectOption('Renewal of Nimsoft Subscription License (On-Demand)','Renewal of Nimsoft Subscription License (On-Demand)'));            
            }
            //sunji03 - FY19 PS/CAN GEO is added
            if((dealTermVal<=delValue)&&(region=='NA' || region=='PS/CAN') && (QuoteRec.CA_Commissionable_Area__c != null&& QuoteRec.CA_Commissionable_Area__c == 'Medium Touch Agile Central')){
                System.debug('================dealTermVal=========='+dealTermVal);
                System.debug('================delValue=========='+delValue);
                options.add(new SelectOption('CA Agile Central Renewal Order Form (CA Terms)','CA Agile Central Renewal Order Form (CA Terms)'));
                options.add(new SelectOption('CA Agile Central Renewal Order Form (Rally Terms)','CA Agile Central Renewal Order Form (Rally Terms)'));

                isSaasComArea = true;
            }
          
                if((dealTermVal>delValue)&&(region=='NA' || region=='PS/CAN') &&(QuoteRec.CA_Commissionable_Area__c != null&& QuoteRec.CA_Commissionable_Area__c == 'Medium Touch Agile Central')){
                   options.add(new SelectOption('CA Agile Central Renewal Order Form (CA Terms)','CA Agile Central Renewal Order Form (CA Terms)'));

                isSaasComArea = true;
            }
            
             /*YEDRA01 for AR:2994*/
            //Added by MANAR08 AR:1230
            if((region=='NA' || region=='PS/CAN')  && (QuoteRec.CA_Commissionable_Area__c != null && QuoteRec.CA_Commissionable_Area__c != '' && QuoteRec.CA_Commissionable_Area__c == 'Medium Touch Clarity SaaS')){
                options.add(new SelectOption('SaaS Renewal Order Form','SaaS Renewal Order Form'));
                isSaasComArea = true;
            }//Added by MANAR08 AR:1230
            else { 
                  if(QuoteRec.CA_Commissionable_Area__c != null && QuoteRec.CA_Commissionable_Area__c != ''){
                    String commissionableArea = QuoteRec.CA_Commissionable_Area__c;
                    String commissionableAreaLwr = commissionableArea.toLowerCase();              
                    //Education QQ Project added HTFT check /*YEDRA01 for AR:2994*/
                     
               if( (commissionableAreaLwr == 'acquisition' || commissionableArea.Contains('High Touch Fast Track')||commissionableArea=='Medium Touch'||commissionableArea=='Indirect Medium Touch'||
commissionableArea=='Medium Touch Nimsoft')&& commissionableArea != 'Medium Touch Nimsoft SaaS' ){
                        options.add(new SelectOption('CA Product Renewal','CA Product Renewal'));
                        options.add(new SelectOption('Maintenance Renewal on Nimsoft Perpetual License','Maintenance Renewal on Nimsoft Perpetual License'));                
                        options.add(new SelectOption('Renewal of Nimsoft Subscription License (On-Premises)','Renewal of Nimsoft Subscription License (On-Premises)'));
                        options.add(new SelectOption('Renewal of Nimsoft Subscription License (On-Demand)','Renewal of Nimsoft Subscription License (On-Demand)'));            
                        //options.add(new SelectOption('SaaS Renewal Order Form','SaaS Renewal Order Form'));
                         /*YEDRA01 for AR:2994*/
                    }                  
                }  
            } //MANAR08
          
        }
        return options;
    } 
    
    public List<SelectOption> getLanguageOptions() {
        List<SelectOption> options = new List<SelectOption>();
          if(region=='EMEA'){ 
          
              if(isAPIQLtm == true || isCSMQLtm == true || isRAQLtm == true ||agileNewPrdct==true){
                 options.add(new SelectOption('English','English'));
              }
              else {
                options.add(new SelectOption('German','German'));
                options.add(new SelectOption('French','French'));
                options.add(new SelectOption('Italian','Italian'));        
                options.add(new SelectOption('European Spanish','European Spanish'));   
                options.add(new SelectOption('European Portuguese','European Portuguese'));   
                options.add(new SelectOption('English','English'));    
              }                         
           }
    
           if(region=='APJ'){
              
              if(isAPIQLtm == true || isCSMQLtm == true || isRAQLtm == true||agileNewPrdct==true){
                options.add(new SelectOption('English','English'));
              }
              else {
                options.add(new SelectOption('Simplified Chinese','Simplified Chinese'));    
                options.add(new SelectOption('Korean','Korean'));   
                options.add(new SelectOption('English','English')); 
                options.add(new SelectOption('Japanese','Japanese'));
                options.add(new SelectOption('Traditional Chinese','Traditional Chinese'));
              }  
            }
    
            if(region=='LA'){
                                          
                     if(isAPIQLtm == true || isCSMQLtm == true || isRAQLtm == true||agileNewPrdct==true){
                        options.add(new SelectOption('English','English'));
                     }                
                     else {

                      if(showTax){
                        options.add(new SelectOption('Brazilian Portuguese','Brazilian Portuguese'));
                        options.add(new SelectOption('Brazilian English','Brazilian English'));
                        options.add(new SelectOption('Latin American Spanish','Latin American Spanish'));
                        options.add(new SelectOption('Latin American English','Latin American English'));
                      } 
                        else {
                        options.add(new SelectOption('Latin American Spanish','Latin American Spanish'));
                        options.add(new SelectOption('Brazilian Portuguese','Brazilian Portuguese'));
                        options.add(new SelectOption('English','English')); 
                     }   
                  }              
            }
    
            //sunji03 - FY19 PS/CAN GEO is added
            if((region=='NA' || region=='PS/CAN') ){
        
              if(isAPIQLtm == true || isCSMQLtm == true || isRAQLtm == true || isSaasComArea == true||agileNewPrdct==true ) {    //Added isSaasComArea check fro AR:1230, MANAR08
                 options.add(new SelectOption('English','English'));
            }
            else {
                options.add(new SelectOption('French','French'));
                options.add(new SelectOption('English','English'));   
            } 
            }   
          
        return options;
    } 
 
    
    public PageReference PriliminaryCheck(){
        if(QuoteRec.CA_CPQ_Quote_Status__c!='Approved'&&QuoteRec.CA_Quote_Type__c=='New Product'){
              notApproved=true;
              displayOptionsBlock=false;    
              isAPIQLtm = isRAQLtm = isCSMQLtm = false;
        }        
        if((QuoteRec.CA_CPQ_Quote_Status__c=='Approved'&&QuoteRec.CA_Quote_Type__c=='New Product')||(QuoteRec.CA_Quote_Type__c=='Renewal')){
              notApproved=false;  
        }
        if(CAEntityError==true){
            displayOptionsBlock=false;    
        }
        if(QuoteRec.CA_Quote_Type__c=='Renewal'){
            
            If(QuoteRec.CA_Commissionable_Area__c != null && QuoteRec.CA_Commissionable_Area__c != ''){
                String commissionableArea = QuoteRec.CA_Commissionable_Area__c;
                commissionableArea = commissionableArea.toLowerCase();
                if(commissionableArea.Contains('medium touch') == false && commissionableArea.Contains('high touch fast track') == false && commissionableArea != 'acquisition'){
                    displayOptionsBlock = false;
                    commissionableAreaErr = true;
                }
            }
            if(QuoteRec.CA_Commissionable_Area__c == null || QuoteRec.CA_Commissionable_Area__c == ''){
                displayOptionsBlock = false;
                commissionableAreaErr = true;
            }
            
            If(QuoteRec.CA_Commissionable_Area__c=='Medium Touch Agile Central'&&QuoteRec.CA_CPQ_Quote_Status__c!='Approved'&&QuoteRec.CA_Quote_Type__c=='Renewal'){
                 displayOptionsBlock = false;
                   notApproved = true; 
                 isAPIQLtm = isRAQLtm = isCSMQLtm = false;
            }
            
         }         
        if(QuoteRec.CA_Quote_Type__c == 'New Product' && QuoteRec.CA_CPQ_Quote_Status__c == 'Approved' && CAEntityError==false){
            
            displayOptionsBlock=true;
           
        }
      
        if(QuoteRec.CA_Quote_Type__c == 'Renewal' && CAEntityError == false && commissionableAreaErr == false&&notApproved==false){
            
                displayOptionsBlock=true;
            
        }    
        
        if(isAPIQLtm == true || isCSMQLtm == true || isRAQLtm == true)
             displayOptionsBlock = false;    
        
        return null;        
    }
    
    Public  PageReference RedirectToTemplate(){
        

        LicenseNotSelected=false;
        depDetailsnotSelected=false;
        system.debug('ShipmentAddressNotSelected2:'+LicenseNotSelected);
        LanguageNotSelected = false;
        system.debug('ShipmentAddressNotSelected22:'+LanguageNotSelected);
        CommonBoolean = false;
        taxnotfilled=false;        
      String pageRefUrl; 
      String attachURL; 
      String ShippingReqStr='';
      String VariablesStr='';
      PageReference pageRef; 
      List<Quote_Product_Report__c> QPLnItemUpdateShipReqList=new List<Quote_Product_Report__c>();
      List<Quote_Product_Report__c> QPLnItemUpdateVariablesList=new List<Quote_Product_Report__c>(); 
      
      try{
            for(ShipQuotePdctLnItem shipQPR:ShipQuotePdctLnItemList){
                if(shipQPR.ship_str!=null&&shipQPR.ship_str!=''){
                    //ShippingReqStr=ShippingReqStr+'-'+shipQPR.quotePdctLnItem.Id+'_'+shipQPR.ship_str;
                    //if(shipQPR.ship_str!=shipQPR.quotePdctLnItem.Shipping_Required__c){
                        Quote_Product_Report__c QPRShip=new Quote_Product_Report__c(Id=shipQPR.quotePdctLnItem.Id);
                        QPRShip.Shipping_Required__c=shipQPR.ship_str;
                        QPLnItemUpdateShipReqList.add(QPRShip);
                    //}
                }
            }
            
            for(VariablesQuotePdctLnItem varQPR:VariablesQuotePdctLnItemList){
                if(varQPR.variables_str!=null&&varQPR.variables_str!=''){
                    //VariablesStr=VariablesStr+'-'+varQPR.quotePdctLnItem.Id+'_'+varQPR.variables_str;
                    //if(varQPR.variables_str!=varQPR.quotePdctLnItem.Variables__c){
                        Quote_Product_Report__c QPRVariable=new Quote_Product_Report__c(Id=varQPR.quotePdctLnItem.Id);
                        QPRVariable.Variables__c=varQPR.variables_str;
                        QPLnItemUpdateVariablesList.add(QPRVariable);
                    //}
                }
            }
            
            
            if(QPLnItemUpdateShipReqList.size()>0){
                update QPLnItemUpdateShipReqList; 
            }
            
            if(QPLnItemUpdateVariablesList.size()>0){
                update QPLnItemUpdateVariablesList; 
            }
            
            String cpqQuoteNum=QuoteRec.CPQ_Quote_Number__c;            
            if(cpqQuoteNum!=null){
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
            
            List<attachment> attachmentList=[Select name,lastmodifieddate from attachment where ParentId=:QuoteRec.Id];
            List<attachment> templateAttachments=new List<attachment>();
            system.debug('attachmentList:'+attachmentList);
            if(attachmentList.size()>0){            
                for(attachment att:attachmentList){                    
                    if(att.name.contains(cpqQuoteNum)){
                        templateAttachments.add(att);
                    }
                }
            }
            system.debug('templateAttachments:'+templateAttachments);
            versionNum=templateAttachments.size()+1;
            attachmentName=cpqQuoteNum+'_'+System.Today()+'_'+versionNum;
        }Catch(Exception e){}    


        
                system.debug('LicenseType:'+LicenseType);
                     if(LicenseType == ''||LicenseType == null){
                            LicenseNotSelected=true;
                            pageRef=null;
                      }
                system.debug('languageOption:'+languageOption+'Booleannn:'+LanguageNotSelected);      
                      if(languageOption == ''|| languageOption == null && LanguageNotSelected==false)
                      {
                        system.debug('Language:In');
                          LanguageNotSelected = true;
                          pageRef=null;     
                      }
                   if(showTax== true){   
                    if((territoryConuntry=='Brazil'&&taxPercent!='')||(territoryConuntry=='Argentina'&&taxPercent!='')||(territoryConuntry!='Argentina'&&territoryConuntry!='Brazil')) { 
                        
                        }
                        else
                        {
                            taxnotfilled=true;
                            pageRefUrl=null;
                        }
                    }
                  if(isAPIQLtm || isCSMQLtm ||isRAQLtm)
                  {
                    system.debug('GettingIn:');
                      if(resellerAgreementNumber ==''|| resellerAgreementNumber==null)
                      {
                            system.debug('resellerAgreementNumber:CameIn'+resellerAgreementNumber);
                            resellerAgreementNumberNotSelected=true;
                            pageRef=null;
                      }
                      
                      if(agreementEndDate ==''|| agreementEndDate==null) 
                      {
                            system.debug('agreementEndDate:CameIn'+agreementEndDate);
                            agreementEndDateNotSelected=true;
                            pageRef=null;
                      } 
                      
                      if(shipMethod == '' || shipMethod == null)
                      {
                            system.debug('ShipmentAddressNotSelected:'+ShipmentAddressNotSelected);
                            ShipmentAddressNotSelected = true;
                            pageref=null;
                      }
                  }    
            
                   
          //ALLHA02 SAP RoW  Department Details Validation
                   if(showContactSection)
                        {
                        
                             if( billingDept==null|| billingDept==''|| shippingDept==null||shippingDept==''|| technicalDept==null||technicalDept==''){

                                 System.debug('billingDept='+billingDept+'shippingDept='+shippingDept+'technicalDept='+technicalDept+'showContactSection'+showContactSection);
                                 
                                  depDetailsnotSelected = true; 
                                  pageref=null; 
                             }
                        }


   system.debug('agreementEndDateNotSelected..'+agreementEndDateNotSelected+'resellerAgreementNumberNotSelected..'+resellerAgreementNumberNotSelected+'LicenseType..'+LicenseType+'LanguageOptionsNotSelected::'+LanguageNotSelected+'ShipmentAddressNotSelected::'+ShipmentAddressNotSelected+'depDetailsnotSelected..'+depDetailsnotSelected);
                  
                      if(agreementEndDateNotSelected == true || resellerAgreementNumberNotSelected == true || depDetailsnotSelected== true ||LicenseType == '' || LicenseType == null || LanguageNotSelected == true || ShipmentAddressNotSelected == true)
                         {

                            CommonBoolean = true;
                         }
                         else
                         {
                            CommonBoolean = false;
                         }
                         system.debug('CheckBool'+CommonBoolean);






          
      if(QuoteRec.CA_Quote_Type__c == 'New Product' && LicenseType != null && QuoteRec.CA_CPQ_Quote_Status__c == 'Approved'){
          
          LicenseNotSelected = false;
          langCode = isoCodeLangMap.get(languageOption);
          VFPageName = 'NewProductQuoteType';
          //
          
          //ALLHA02 Department Details added to pageRefUrl
          
          if(isAPIQLtm || isCSMQLtm || isRAQLtm){
              pageRefUrl='/apex/NewProductSKUsOrderForm?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&rgNum='+resellerAgreementNumber+'&aeDate='+agreementEndDate+'&shipMet='+shipMethod+'&APILtm='+isAPIQLtm+'&CSMLtm='+isCSMQLtm+'&RALtm='+isRAQLtm+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductSKUsOrderForm?id='+QuoteRec.Id;
              VFPageName = 'NewProductSKUsOrderForm';
          }
          
          if(LicenseType=='CA Agile Central Renewal Order Form'||agileNewPrdct==true){
              pageRefUrl='/apex/SaaS_New_Order_Form?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/SaaS_New_Order_Form?id='+QuoteRec.Id;
          }
                   
          if(LicenseType=='Customer On-Premises Subscription License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='Customer On-Premises Perpetual License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='Customer On-Demand Subscription License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='MSP On-Premises Subscription License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='MSP On-Premises Perpetual License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='MSP On-Demand Subscription License'){
              pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
          }
          //Added as part of Education QQ PR04433
          System.debug('LicenseTYpe:'+LicenseType);
          if(LicenseType == 'CA Education'){
                 //MANAR08 - AR: 1724 and 2187
                if(showTax== true){   
                    if((territoryConuntry=='Brazil'&&taxPercent!='')||(territoryConuntry=='Argentina'&&taxPercent!='')||(territoryConuntry!='Argentina'&&territoryConuntry!='Brazil')) { 
                        try{
                        decimal taxPercent1=decimal.valueof(taxPercent);      
                        taxPercent1+=0.0000;                        
                        pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&tax='+taxPercent1+'&langopt='+languageOption+'&cpnj='+customerCPNJ+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
                        attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;
                        }
                        catch(exception e){
                        isdecimal=true;
                        }
                        }
                        else
                        {
                            taxnotfilled=true;
                            pageRefUrl=null;
                        }
                }  //MANAR08 -- AR:1724 and 2817
                else { 
                  pageRefUrl='/apex/NewProductQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&territory='+territoryConuntry+'&cpnj='+customerCPNJ+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
                  attachURL='/apex/NewProductQuoteType?id='+QuoteRec.Id;        
                 } //MANAR08
            
          }          
      }
      
      if(QuoteRec.CA_Quote_Type__c=='Renewal'&&LicenseType!=null){
          langCode=isoCodeLangMap.get(languageOption);          
          VFPageName='RenewalQuoteType';
          String commissionableArea = QuoteRec.CA_Commissionable_Area__c;
          
          //Added By: Vinu - 11/14/2014
                        
            system.debug('QuoteRecId:'+QuoteRec.Id);
            system.debug('LicenseType:'+LicenseType);
            system.debug('LangCode:'+langCode);
            system.debug('VersionNumber:'+versionNum);
            system.debug('OrderFormNumber:'+orderFormNo);
            
            
          if(LicenseType=='Saas Renewal Order Form' && langCode=='en' && commissionableArea.Contains('Medium Touch Clarity SaaS')){
            
            system.debug('commissionableArea:'+commissionableArea);
            system.debug('QuoteRecId:'+QuoteRec.Id);
            system.debug('LicenseType:'+LicenseType);
            system.debug('LangCode:'+langCode);
            system.debug('VersionNumber:'+versionNum);
            system.debug('OrderFormNumber:'+orderFormNo);
            
            pageRefUrl='/apex/saas_renewal_order_form?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
            attachURL='/apex/saas_renewal_order_form?id='+QuoteRec.Id;
          }
          
          if(LicenseType=='CA Agile Central Renewal Order Form (CA Terms)' && langCode=='en' && commissionableArea.Contains('Medium Touch Agile Central')){
            
            system.debug('commissionableArea:'+commissionableArea);
            system.debug('QuoteRecId:'+QuoteRec.Id);
            system.debug('LicenseType:'+LicenseType);
            system.debug('LangCode:'+langCode);
            system.debug('VersionNumber:'+versionNum);
            system.debug('OrderFormNumber:'+orderFormNo);
            
            pageRefUrl='/apex/Renewal_Order_Form?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
            attachURL='/apex/Renewal_Order_Form?id='+QuoteRec.Id;
          }
          if(LicenseType=='CA Agile Central Renewal Order Form (Rally Terms)'&& langCode=='en'&&commissionableArea.Contains('Medium Touch Agile Central')){
            
            system.debug('commissionableArea:'+commissionableArea);
            system.debug('QuoteRecId:'+QuoteRec.Id);
            system.debug('LicenseType:'+LicenseType);
            system.debug('LangCode:'+langCode);
            system.debug('VersionNumber:'+versionNum);
            system.debug('OrderFormNumber:'+orderFormNo);
            
            pageRefUrl='/apex/CA_Agile_Centra_Renewal_RallyTerm?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
            attachURL='/apex/CA_Agile_Centra_Renewal_RallyTerm?id='+QuoteRec.Id;
          }
          
          
          // Added By:Vinu:
          
          if(LicenseType=='CA Product Renewal'){

            
            pageRefUrl='/apex/RenewalQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
            attachURL='/apex/RenewalQuoteType?id='+QuoteRec.Id;
          }
          if(LicenseType=='Maintenance Renewal on Nimsoft Perpetual License'){
              pageRefUrl='/apex/RenewalQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/RenewalQuoteType?id='+QuoteRec.Id;
          }
          if((LicenseType=='Renewal of Nimsoft Subscription License (On-Premises)' || LicenseType=='Renewal of Nimsoft Subscription License (On-Demand)') && langCode != 'en' && langCode != 'ko'){
              LicenseType='Renewal of Nimsoft Subscription License';
              pageRefUrl='/apex/RenewalQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/RenewalQuoteType?id='+QuoteRec.Id;
          }
          else if(LicenseType=='Renewal of Nimsoft Subscription License (On-Premises)'){
              pageRefUrl='/apex/RenewalQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/RenewalQuoteType?id='+QuoteRec.Id;
          }
          else if(LicenseType=='Renewal of Nimsoft Subscription License (On-Demand)'){
              pageRefUrl='/apex/RenewalQuoteType?id='+QuoteRec.Id+'&lic='+LicenseType+'&lang='+langCode+'&vernum='+versionNum+'&orderFormNo='+orderFormNo+'&billingDept='+billingDept+'&shippingDept='+shippingDept+'&technicalDept='+technicalDept;
              attachURL='/apex/RenewalQuoteType?id='+QuoteRec.Id;
          }
                  
      }
      system.debug('pageRefUrl:'+pageRefUrl);
      system.debug('CommonBoolean:'+CommonBoolean);
      if(pageRefUrl!=null && pageRefUrl!='' && CommonBoolean==false){
           pageRef=new PageReference(pageRefUrl); 
            Attachment attachment = new Attachment(); 
            PageReference Pg = new PageReference(pageRefUrl);
            
            try{
                attachment.Body = Pg.getContent(); 
                system.debug('attachment.Body:'+attachment.Body);
                if(QuoteRec.CA_Quote_Type__c=='New Product'){               
                    attachment.Name =attachmentName+'_'+'QuoteOrderForm.PDF';
                }
                if(QuoteRec.CA_Quote_Type__c=='Renewal'){
                    system.debug('QuoteRec.CA_Quote_Type__c:'+QuoteRec.CA_Quote_Type__c);
                    attachment.Name = attachmentName+'_'+'QuoteOrderForm.doc';
                }                
                attachment.ParentId = QuoteRec.Id;            
              insert attachment;
            }Catch(Exception e){
                system.debug('eMessage'+e);
            }
       //quoteTemplateLink=new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+pageRefUrl); 
            
      }
      if(pageRefUrl==null||pageRefUrl==''){
          pageRef=null;          
      }
      System.debug('###pageRef'+pageRef);
      return pageRef; 
    }
    public scpq__SciQuote__c getSterlingQuote(){
        return QuoteRec; 
    }
    Public Boolean getCAEntityError(){
        return CAEntityError;
    }
    Public PageReference getURLToTemplateDoc(){
        return quoteTemplateLink;
    } 
    Public String getLangCode(){
        return langCode;
    } 
    Public String getVFPageName(){
        return VFPageName;
    }
    Public Boolean getCommissionableAreaErr(){
        return commissionableAreaErr;
    }
    Public Boolean getCASWInfoBol(){
        return CASWInfoBol;
    }
    Public Boolean getSrvcEduBol(){
        return SrvcEduBol;
    }
    
    Public Boolean getOrderFormNoBol(){
        return orderFormNoBol;
    }
    Public Boolean getTerritoryConuntryBol(){
        return territoryConuntryBol;
    }
    
    //Added by (Mari-->ISTP,R1,2014)
    public Boolean gethasEligibleSKU()
    {
        return (isAPIQLtm || isCSMQLtm ||isRAQLtm);     
    }
    public List<SelectOption> getshippingMethods() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Ship to Reseller','Ship to Reseller'));
        options.add(new SelectOption('Ship to End User','Ship to End User'));
        
        return options;
    }
    //Added by (Mari-->ISTP,R1,2014)
    
    
    //Added by Yedra01 AR:1724 and 2187
    Public Boolean getShowTax(){
        return showTax;
    }
    //Added by ALLHA02 SAP ROW Project
    Public Boolean getShowContactSection(){
         return showContactSection;
    
    }
    
}