/*
* Test Class = Renewal_addMainFrameProductsTestClass.
* Coverage = 84%.
* Updated by BAJPI01 
/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMTU01      12/9/2017       US392086        RevRec: SFDC Real ARR MF Capacity Break out of License and Maintenance Fees
* SAMAP01      23/10/2017       US370554        RevRec: SFDC Opportunity License Classification for non renewal products
* ********************************************************************************************/


public class Renewal_addMainFrameProducts {
  
    @TestVisible private Boolean haserror;      //US312941 - BAJPI01
    private List<OpportunityLineItem> opplineitemlist = new List<OpportunityLineItem>();    //BAJPI01 - for uniform update of start/end date on opp header
    private List<OpportunityLineItem> updatedlineitemlist = new List<OpportunityLineItem>();  //BAJPI01 - for uniform update of start/end date on opp header
    private List<OpportunityLineItem> renewallineitems = new List<OpportunityLineItem>();  //BAJPI01 - for uniform update of start/end date on opp header
    private Set<String> Businesstype = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'};  //BAJPI01 - for uniform update of start/end date on opp header
  
    
    public Opportunity opportunity {get;set;}
    public OpportunityLineItem oppLineItem {get;set;}
    public Boolean alert {get; set;}     //allha02 3576
    public Date startdate;        //US312941 - BAJPI01
    public Date enddate;        //US312941 - BAJPI01
   
    public String lictype {get;set;} //SAMTU01 - US392086
    
      //samap01- revrec  US370554
     public String licclassification {get;set;}  
     //public String 
  
    public list<SelectOption> LicenseClassification {
        get{
            list<SelectOption> st= new list<SelectOption>(); 
            Schema.DescribeFieldResult lctypevalues = OpportunityLineItem.License_Classification__c.getDescribe();
            Schema.PicklistEntry[] entries_temp = lctypevalues.getPicklistValues();
            st.add(new SelectOption('Subscription','Subscription'));
            return st;
        }
        set; }
    
       public list<SelectOption> LicenseClassificationOverride {
        get{
            return LicenseClassificationmapper.LicenseClassificationOverride();
        }
        set; }    
    
    //SAMTU01 - US392086
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
    

     //SAMTU01 - US398729
    public list<SelectOption> BusinessTypeList {
        get{
            list<SelectOption> st= new list<SelectOption>();         
            
            Schema.DescribeFieldResult lctypevalues = OpportunityLineItem.Business_Type__c.getDescribe();
            Schema.PicklistEntry[] entries_temp = lctypevalues.getPicklistValues();            
           st.add(new SelectOption('MF Capacity','MF Capacity'));
           st.add(new SelectOption('MF Capacity Overage','MF Capacity Overage'));
                      
            return st;
        }
        set; }
    //SAMTU01 US398729 -end
    
    public Renewal_addMainFrameProducts(ApexPages.StandardController controller) {
        haserror=false;
        alert=false ;
        opportunity = [select Name,Business_Type__c,Original_Contract_IDs__c,New_Deal_Term_Months__c, CurrencyIsoCode ,
                       Stretch_Deal_Term_Months__c, Original_Expiration_Quarter__c,Start_Date__c,End_Date__c, 
                       Projected_Renewal__c,Stretch_Sales_Price_Gap_Reason__c,  Contract_Number_EU4cast__c,
                       Quote_Number__c,Business_Partner_ID__c,Status_at_end_of_term__c,Reason_duration_is_1_year__c,
                       Renewal_Quota_CV__c,Original_CV__c,Original_Deal_Term_Months__c,CloseDate,StageName,
                       (select id, Contract_Number__c, Business_Type__c, Quote_Number__c, OpportunityId, UnitPrice,Duration_Days__c,Business_Unit__c,
                        Stretch__c, Sales_Price_USD__c, Term_Month__c, New_Deal_Term_Months__c,Start_Date__c,End_Date__c, 
                           Corporate_ARR__c,Stretch_Corporate_ARR__c,License_Classification__c, Platform_Category__c,License_Classification_Override__c ,//samap01 -Revrec- US370554
                        Commissionable_BU__c,UF_License_Fee__c,Total_Maintenance__c,License__c,Opportunity.Rpt_Country__c,Opportunity.Stretch_Deal_Term_Months__c,Stretch_Total_Maintenance__c,Stretch_License_Fee__c,Override_Fees__c   //Added by SAMTU01 - US392086
                        from OpportunityLineItems
                        where PricebookEntry.product2.Family ='Mainframe Capacity'
                        and PricebookEntry.product2.name ='Mainframe Capacity'
                        and PricebookEntry.product2.Market_Focus_Area__c = 'Mainframe Capacity')
                       from Opportunity 
                       where Id=:ApexPages.currentPage().getParameters().get('oppid')
                       order by createddate asc]; 
        opplineitemlist = [select Id,Start_Date__c,End_Date__c,Business_Type__c from OpportunityLineItem
                           where OpportunityId=:ApexPages.currentPage().getParameters().get('oppid') and Business_Type__c in:Businesstype];
       
        if(opplineitemlist!=null && opplineitemlist.size()>0){
            for(OpportunityLineItem oli:opplineitemlist){
               if(oli.Business_Type__c=='Renewal'){
                    renewallineitems.add(oli);
                }
            }
        }
        
        oppLineItem = new  OpportunityLineItem();       
        if(opportunity.OpportunityLineItems.size()>0){                                    
            oppLineItem = opportunity.OpportunityLineItems.get(0);
            
            //US312941 - BAJPI01
            if(opplineItem.Start_Date__c==null && opportunity.Start_Date__c!=null)
                opplineItem.Start_Date__c = opportunity.Start_Date__c;
            if(opplineItem.End_Date__c==null && opportunity.End_Date__c!=null)
                opplineItem.End_Date__c = opportunity.End_Date__c;
            //US312941 - BAJPI01
            
            
            system.debug('---opplineitemlistsize----'+opplineitemlist.size());
                
        }
        else{
            
            List<PricebookEntry> oldPr = [select name,product2Id,pricebook2Id,product2.Commissionable_BU__c from  PricebookEntry where
                                          CurrencyIsoCode =:opportunity.CurrencyIsoCode 
                                          and product2.Family ='Mainframe Capacity'
                                          and product2.name ='Mainframe Capacity'
                                          and product2.Market_Focus_Area__c = 'Mainframe Capacity'
                                          and Pricebook2.IsActive = true];
            if(oldPr!=null && oldPr.size()>0){
                oppLineItem.PricebookEntryId = oldPr.get(0).Id;
            }
                                                    
            oppLineItem.OpportunityId = opportunity.Id;
           if(oppLineItem.Business_Type__c ==null)
          oppLineItem.Business_Type__c = 'MF Capacity'; //commented out by SAMTU01 - US398729
            //US312941 - BAJPI01
            if(opplineItem.Start_Date__c==null && opportunity.Start_Date__c!=null)
                opplineItem.Start_Date__c = opportunity.Start_Date__c;
            if(opplineItem.End_Date__c==null && opportunity.End_Date__c!=null)
                opplineItem.End_Date__c = opportunity.End_Date__c;
            //US312941 - BAJPI01
            
        }        
         IF( opplineItem.License__c == NULL ||  opplineItem.License__c == '' ) //SAMTU01 - US392086
            {
                opplineItem.License__c = 'Ratable';
                
            } 
              
                
            
        //SAMAP01- REVREC-US370554 -1/11/2017
        //String strbu ='Ma'
        System.debug(' samap01 opplineItem.License_Classification_Override__c '+opplineItem.License_Classification_Override__c);
        if(opplineItem.License_Classification_Override__c != null && opplineItem.License_Classification_Override__c != '')
            licclassification = opplineItem.License_Classification_Override__c;
        opplineItem = LicenseClassificationMapper.LicenseClassifcationset(opplineItem,oppLineItem.Business_Type__c,opplineItem.License_Classification_Override__c); //samap01 -revrec-US370554
         licclassification =LicenseClassificationMapper.licclassification;
            //SAMAP01- REVREC-US370554 
        
    }
    public pagereference saveproducts(){
        alert=false ; //allha02 3576
        try {
            //US312941 - BAJPI01
            if(haserror){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date cannot be greater than or equal to End Date.');
              ApexPages.addMessage(msg);
                return null;  
            }
            
            // fy13 - BR165 - default stretch deal term if not specified
            if(opportunity.Stretch_Deal_Term_Months__c == null || opportunity.Stretch_Deal_Term_Months__c == 0) {
                opportunity.Stretch_Deal_Term_Months__c = opportunity.New_Deal_Term_months__c;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Stretch Deal Term is required. Stretch Deal Term value adjusted to New Deal Term.');
                ApexPages.addMessage(myMsg);
                 getDaysBetweenLineItem();//SAMTU01 US392086 
                alert= true;
            }
            
            // fy13 - BR165 - default stretch amount if not specified
            if(oppLineItem.Stretch__c == null || oppLineItem.Stretch__c < oppLineItem.UnitPrice){
                oppLineItem.Stretch__c = oppLineItem.UnitPrice; //allha02 3576
                 getDaysBetweenLineItem();//SAMTU01 US392086 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Stretch is required and must be greater than or equal to Sales Price.  Stretch value adjusted.');
                ApexPages.addMessage(myMsg);
                alert= true;
            }
            
            oppLineItem.New_Deal_Term_Months__c= opportunity.New_Deal_Term_months__c;
            oppLineItem.Original_Deal_Term_Months__c = opportunity.Original_Deal_Term_Months__c;
            oppLineItem.Original_Contract_IDs__c = opportunity.Original_Contract_IDs__c;
          if(oppLineItem.Business_Type__c ==null)
          oppLineItem.Business_Type__c = 'MF Capacity';//commented out by SAMTU01 US392789
            oppLineItem.MF_Cap__c = TRUE;
             
            //SAMAP01- REVREC- us370554
            sYSTEM.debug('SAMAP01 --licclassification on save' +licclassification);
                opplineItem = LicenseClassificationMapper.LicenseClassifcationset(opplineItem,oppLineItem.Business_Type__c,licclassification); //samap01 -revrec-US370554
           
           //samap01 -Revrec -end            
                
            if((Opportunity.Reason_duration_is_1_year__c == null &&  opportunity.New_Deal_Term_Months__c < 12) ||(Opportunity.Status_at_end_of_term__c == null && opportunity.New_Deal_Term_Months__c < 12))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Reason duration is < 1 year and Status at end of term are required when New Deal Term (Months) < 12 for Renewal Opportunities');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            if(alert){ //allha02 3576
                return null;
            }
            
            update opportunity;
            upsert oppLineItem;
        }
        catch(DMLException e){
            
            ApexPages.addMessages(e);
            return null;
        }
        
        
        pagereference pr = new pagereference('/'+opportunity.Id);
        return pr;        
    }
    
    //US312941 - BAJPI01 - called when start/end date/unit price is changed at line item level. Recalculates Duration Days.
    public void getDaysBetweenLineItem(){
        startdate = oppLineItem.start_Date__c;
        enddate = oppLineItem.End_Date__c;
        system.debug('opplineitem>>'+oppLineItem);
        system.debug('start date---'+startdate);
        system.debug('end date---'+enddate);
        Decimal n = 0.00;
       
        if(startdate>=enddate){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Date cannot be greater than or equal to End Date.'));
            haserror =true;
        }
        else{
            haserror=false;
            
            if(startdate!=null && enddate!=null){
                oppLineItem.Duration_Days__c = startdate.daysBetween(enddate) + 1;
                n = ARRandDurationCalculation.monthsbetweendates(startdate,enddate);
                opplineItem.Term_Month__c = n;
            }  
            else{
                oppLineItem.Term_Month__c = 0;
                oppLineItem.Duration_Days__c = 0;
            }
            
             //addedby samtu01 US392086
            
            OpportunityLineItem oli = oppLineItem;
            decimal totMaint;   
            Decimal totSalesPrice = (oli.UnitPrice <> null? oli.UnitPrice : 0);
            Decimal termInYears =   (oli.Term_Month__c <> null? oli.Term_Month__c /12 : 0); 
            Decimal termInMonths =   (oli.Term_Month__c <> null? oli.Term_Month__c  : 0);
            
            Decimal UFLicenseFee = 0;
            //System.debug('---------opp.Rpt_Country__c--------'+opp.Rpt_Country__c);
            if(oli.Opportunity.Rpt_Country__c == Label.Korea_Country_Name){
                if(termInMonths <> 0){
                    UFLicenseFee =  (totSalesPrice/((0.1364/12*termInMonths)+1));
                    System.debug('----UFLicenseFee-----'+UFLicenseFee);
                    
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
                
                oli.UF_License_Fee__c = 0; // US461584 --- MERHA02
                oli.Total_Maintenance__c = 0;            
            }
            else if(oli.License__c == 'Upfront' || oli.License__c == 'Ratable')
            {
                oli.UF_License_Fee__c = UFLicenseFee.setScale(2);
                System.debug('------- oli.UF_License_Fee__c-----'+ oli.UF_License_Fee__c);
                oli.Total_Maintenance__c = totMaint.setScale(2);            
            }
            
            //addedby samtu01 - US392086 --end//
            //addedby samtu01 - US392086
            decimal totStretchMaint; 
            
            Decimal totStretch = (oli.Stretch__c <> null? oli.Stretch__c : 0);
            Decimal StretchtermInYears =   (opportunity.Stretch_Deal_Term_Months__c<> null? opportunity.Stretch_Deal_Term_Months__c/12 : 0); 
            Decimal StretchtermInMonths =   (opportunity.Stretch_Deal_Term_Months__c<> null? opportunity.Stretch_Deal_Term_Months__c: 0);
            System.debug('---stretch term in years---'+StretchtermInYears);
            Decimal StretchLicenseFee = 0;
            //System.debug('---------opp.Rpt_Country__c--------'+opp.Rpt_Country__c);
            if(oli.Opportunity.Rpt_Country__c == Label.Korea_Country_Name){
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
            
            if(oli.License__c == 'Subscription')
            {
                //oli.Stretch_License_Fee__c = oli.Stretch__c;
                oli.Stretch_License_Fee__c = 0; // US461584 --- MERHA02
                oli.Stretch_Total_Maintenance__c = 0;  
                
            }
            else if(oli.License__c == 'Ratable')
            {
                oli.Stretch_License_Fee__c = StretchLicenseFee.setScale(2);
                //System.debug('------- oli.UF_License_Fee__c-----'+ oli.UF_License_Fee__c);
                oli.Stretch_Total_Maintenance__c = totStretchMaint.setScale(2); 
                
            }
            
            //addedby samtu01 - US392086 end
            //  //samap01 -revrec
                lictype =oli.License__c;
                oli = LicenseClassificationMapper.LicenseClassifcationset(oli,oppLineItem.Business_Type__c,licclassification); //samap01 1/11 -revrec US370554
                licclassification =LicenseClassificationMapper.licclassification;
            //samap01 -revrec
            updateoppheaderdates();
            
        }
    }
    //US312941 - BAJPI01 - ends
     //added bu SAMTU01
    public void performStretchCalc(){
        System.debug('---in performStretchCalc--- ');
        OpportunityLineItem oli = oppLineItem;
        if(oli!=null)
        {
        decimal totUnitPrice1; 
        Decimal totalUfFee1 = (oli.Stretch_License_Fee__c<> null? oli.Stretch_License_Fee__c: 0);
        Decimal totalLicenseFee1 =   (oli.Stretch_Total_Maintenance__c<> null? oli.Stretch_Total_Maintenance__c: 0); 
        totUnitPrice1 = totalUfFee1 + totalLicenseFee1 ;
        oli.Stretch__c= totUnitPrice1;
        }
        
    }
    public void performSalesPriceCalc(){
        
        OpportunityLineItem oli = oppLineItem;
        if(oli!=null)
        {
        decimal totUnitPrice; 
        Decimal totalUfFee = (oli.UF_License_Fee__c <> null? oli.UF_License_Fee__c : 0);
        Decimal totalLicenseFee =   (oli.Total_Maintenance__c <> null? oli.Total_Maintenance__c : 0); 
        totUnitPrice = totalUfFee + totalLicenseFee ;
        oli.unitPrice  = totUnitPrice;
        }
    }
    //added bu SAMTU01--ends
    
    public void updateoppheaderdates(){
        
        Date minstartdate;
        Date maxenddate;
        if(opplineitemlist.size()>0){
            for(OpportunityLineItem oli:opplineitemlist){
                if(oli.id==oppLineItem.id)
                    updatedlineitemlist.add(oppLineItem);
                else
                    updatedlineitemlist.add(oli);
            }
        }
        else{
            updatedlineitemlist.add(oppLineItem);
            
        }
        
        if(updatedlineitemlist.size()>0){
            minstartdate = updatedlineitemlist[0].Start_Date__c;
            maxenddate = updatedlineitemlist[0].End_Date__c;
            for(OpportunityLineItem oli:updatedlineitemlist){
                if(oli.Start_Date__c!=null){
                    if(minstartdate!=null){
                        if(oli.Start_Date__c<minstartdate)
                            minstartdate = oli.Start_Date__c;
                    }
                    else{
                        minstartdate = oli.Start_Date__c;
                    }
                }
                if(oli.End_Date__c!=null){
                    if(maxenddate!=null){
                        if(oli.End_Date__c>maxenddate)
                            maxenddate = oli.End_Date__c;
                    }
                    else{
                        maxenddate = oli.End_Date__c;
                    }
                }
            }
            
        }
        opportunity.Start_Date__c =  minstartdate;
        opportunity.End_Date__c = maxenddate;
        
        //New Deal Term Months on Opp will be populated for Renewal Products only.
        System.debug('renewallineitems'+renewallineitems);
        if(renewallineitems!=null && renewallineitems.size()>0){
            minstartdate = renewallineitems[0].Start_Date__c;
            maxenddate = renewallineitems[0].End_Date__c;
            for(OpportunityLineItem oli:renewallineitems){
                if(oli.Start_Date__c!=null){
                    if(minstartdate!=null){
                        if(oli.Start_Date__c<minstartdate)
                            minstartdate = oli.Start_Date__c;
                    }
                    else{
                        minstartdate = oli.Start_Date__c;
                    }
                }
                if(oli.End_Date__c!=null){
                    if(maxenddate!=null){
                        if(oli.End_Date__c>maxenddate)
                            maxenddate = oli.End_Date__c;
                    }
                    else{
                        maxenddate = oli.End_Date__c;
                    }
                }
            }
            System.debug('++++in if'+oppLineItem);
            opportunity.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(minstartdate,maxenddate);
        }
        
       else{
            if(oppLineItem.start_Date__c!=null && oppLineItem.End_Date__c!=null){
                System.debug('++++in else'+oppLineItem);
                opportunity.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(oppLineItem.start_Date__c,oppLineItem.End_Date__c);
            }
      }
        
        if((opportunity.New_Deal_Term_Months__c!=null && opportunity.New_Deal_Term_Months__c<12)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Reason duration is < 1 year and Status at end of term fields are required when Projected Time Duration (Months) < 12');
            ApexPages.addMessage(msg);
        }
        
    }
    
 
    
}