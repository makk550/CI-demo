public class QuoteTriggerHandler extends CPQTriggerHandler {

    public QuoteTriggerHandler() {}

    /* context overrides */

    public static Map<Id, Contract> ContractIdMap;

    
    protected override void beforeInsert() {
        
        Set<Id> oppIds = new Set<Id>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Set<Id> contractIdSet = new Set<Id>();
        //code to populate Currency on Quote, from Opportunity tied to it. - BAJPI01 - DE319735
        for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
            oppIds.add(quote.SBQQ__Opportunity2__c);
            
            if(quote.SBQQ__Type__c=='Renewal')
                quote.Business_Type__c = 'Renewal';                
            else if(quote.SBQQ__Type__c=='Quote')
                quote.Business_Type__c = 'New';
            else if(quote.SBQQ__Type__c=='Amendment')
                quote.Business_Type__c = 'Capacity';
                
        }
        
        if(oppIds!=null && oppIds.size()>0){
            oppMap = new Map<Id,Opportunity>([select id,CurrencyIsoCode,SBQQ__RenewedContract__c,
                                              SBQQ__AmendedContract__c from opportunity where id in:oppIds]);
        }
        
        if(oppMap!=null && oppMap.size()>0){
            for(Opportunity opp: oppMap.values()){
                if(opp.SBQQ__RenewedContract__c!=null)
                    contractIdSet.add(opp.SBQQ__RenewedContract__c);
                if(opp.SBQQ__AmendedContract__c!=null)
                    contractIdSet.add(opp.SBQQ__AmendedContract__c);
            }
        }
        
        if(contractIdSet!=null && contractIdSet.size()>0){
            getContractDetails(contractIdSet);
        }
        
        for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
            Opportunity opp = new Opportunity();
            if(oppMap.containsKey(quote.SBQQ__Opportunity2__c)){
                opp = oppMap.get(quote.SBQQ__Opportunity2__c);
            }
            
            if(opp!=null)
                quote.CurrencyIsoCode = opp.CurrencyIsoCode;
            if(ContractIdMap!=null && ContractIdMap.size()>0){
                
                if(opp!=null && opp.SBQQ__RenewedContract__c!=null && ContractIdMap.containsKey(opp.SBQQ__RenewedContract__c))
                    quote =  mapContractFieldsToQuote(quote,ContractIdMap.get(opp.SBQQ__RenewedContract__c));
                else if(opp!=null && opp.SBQQ__AmendedContract__c!=null && ContractIdMap.containsKey(opp.SBQQ__AmendedContract__c))
                    quote =  mapContractFieldsToQuote(quote,ContractIdMap.get(opp.SBQQ__AmendedContract__c));
                
            }
            //set effective date chajo30
            Date todaysDate = System.today();
            Integer numberOfDays = Date.daysInMonth(todaysDate.year(), todaysDate.month());
            Date lastDayOfMonth = Date.newInstance(todaysDate.year(), todaysDate.month(), numberOfDays);
            if(quote.SBQQ__StartDate__c < lastDayOfMonth){
                quote.Quote_Effective_Date__c = quote.SBQQ__StartDate__c;
            }else{
                quote.Quote_Effective_Date__c = lastDayOfMonth;
            }
            //end chajo30 
        }
        //code to populate Currency on Quote, from Opportunity tied to it. - BAJPI01 - DE319735
    }
    
    protected override void beforeUpdate() {
    
         Set<String> SoldToShipToId = new Set<String>(); //AMASA03
        
        // If Approval Status changes, change Record Id accordingly

        for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
            
            SBQQ__Quote__c oldQuote = (SBQQ__Quote__c) Trigger.oldMap.get(quote.Id);
            
            System.debug('This Quote Number is: ' + quote.id);

            //chajo30
            if(quote.SBQQ__StartDate__c != oldQuote.SBQQ__StartDate__c){
                Date todaysDate = System.today();
                Integer numberOfDays = Date.daysInMonth(todaysDate.year(), todaysDate.month());
                Date lastDayOfMonth = Date.newInstance(todaysDate.year(), todaysDate.month(), numberOfDays);
                if(quote.SBQQ__StartDate__c < lastDayOfMonth){
                    quote.Quote_Effective_Date__c = quote.SBQQ__StartDate__c;
                }else{
                    quote.Quote_Effective_Date__c = lastDayOfMonth;
                }                
            }
            //end chajo30
            
            // Recalled or Rejected, update to Quote - Draft
            if ( quote.ApprovalStatus__c != oldQuote.ApprovalStatus__c && ( quote.ApprovalStatus__c == 'Rejected' || quote.ApprovalStatus__c == 'Recalled' ) )
            {
                try {
                    quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - Draft').getRecordTypeId();
                    quote.SBQQ__Status__c = 'Draft';     
                }
                catch (Exception e) {}
            }
            
             // Updated to Quote Validated with no Validation errors
            if ( quote.SBQQ__Status__c != oldQuote.SBQQ__Status__c && quote.SBQQ__Status__c == 'Quote Validated' )
            {
                try {
                    quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - Validated').getRecordTypeId();
                    quote.SBQQ__Status__c = 'Quote Validated';
                }
                catch (Exception e) {}
            }
            
            // Updated to Draft from Quote Validated
            if ( oldQuote.SBQQ__Status__c == 'Quote Validated' && quote.SBQQ__Status__c == 'Draft' )
            {
                try {
                    quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - Draft').getRecordTypeId();
                }
                catch (Exception e) {}
            }
                        
            // Submitted, update to Quote - In Review
            else if ( quote.ApprovalStatus__c != oldQuote.ApprovalStatus__c && quote.ApprovalStatus__c == 'Pending' )
            {
                try {
                    quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - In Review').getRecordTypeId();
                    quote.SBQQ__Status__c = 'In Review';
                }
                catch (Exception e) {}
            }
            // Submitted, update to Quote - Approved
            else if ( quote.ApprovalStatus__c != oldQuote.ApprovalStatus__c && quote.ApprovalStatus__c == 'Approved' )
            {
                try {
                    quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Quote - Approved').getRecordTypeId();
                    quote.SBQQ__Status__c = 'Approved';
                }
                catch (Exception e) {}
            }
            
            //AMASA03
            if( !String.isEmpty(quote.SoldTo_BPID__c) && oldQuote.SoldTo_BPID__c != quote.SoldTo_BPID__c){
                SoldToShipToId.add(quote.SoldTo_BPID__c);
            }else{
                if(String.isEmpty(quote.SoldTo_BPID__c)){
                    quote.Sold_To__c = null;
                }
            }
            if( !String.isEmpty(quote.ShipTo_BPID__c) && oldQuote.ShipTo_BPID__c != quote.ShipTo_BPID__c){
                SoldToShipToId.add(quote.ShipTo_BPID__c);
            }else{
                if(String.isEmpty(quote.ShipTo_BPID__c)){
                    quote.Ship_To__c = null;
                }
            }
            //partner customer details site assc lookup - BAJPI01
            if( !String.isEmpty(quote.Reseller_BPID__c) && oldQuote.Reseller_BPID__c != quote.Reseller_BPID__c){
                SoldToShipToId.add(quote.Reseller_BPID__c);
            }else{
                if(String.isEmpty(quote.Reseller_BPID__c)){
                    quote.Reseller_ID__c = null;
                }
            }
            if( !String.isEmpty(quote.EndUser_BPID__c) && oldQuote.EndUser_BPID__c != quote.EndUser_BPID__c){
                SoldToShipToId.add(quote.EndUser_BPID__c);
            }else{
                if(String.isEmpty(quote.EndUser_BPID__c)){
                    quote.EndUser_ID__c = null;
                }
            }
            //partner customer details site assc lookup - BAJPI01
            
        }
         //AMASA03 - fecthing site association details and stamping on quote.
        if(SoldToShipToId.size() > 0){
            Map<String,Id> mapSite = new Map<String,Id>();
            List<Site_Association__c> SiteIdList =[select Id,SAP_Site_ID__c from Site_Association__c where SAP_Site_ID__c in :SoldToShipToId];
            for(Site_Association__c site : SiteIdList){
                 if(!mapSite.containsKey(site.SAP_Site_ID__c)){
                    System.debug('matched ');
                    mapSite.put(site.SAP_Site_ID__c, site.Id);
                }
            }
            for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
                SBQQ__Quote__c oldQuote = (SBQQ__Quote__c) Trigger.oldMap.get(quote.Id);
                if( !String.isEmpty(quote.SoldTo_BPID__c) && oldQuote.SoldTo_BPID__c != quote.SoldTo_BPID__c){
                    if(mapSite.containsKey(quote.SoldTo_BPID__c)){
                        quote.Sold_To__c =mapSite.get(quote.SoldTo_BPID__c);
                    }
                }
                if( !String.isEmpty(quote.ShipTo_BPID__c) && oldQuote.ShipTo_BPID__c != quote.ShipTo_BPID__c){
                    if(mapSite.containsKey(quote.ShipTo_BPID__c)){
                        quote.Ship_To__c =mapSite.get(quote.ShipTo_BPID__c);
                        
                    }
                }
                
                //partner customer details site assc lookup - BAJPI01
                if( !String.isEmpty(quote.Reseller_BPID__c) && oldQuote.Reseller_BPID__c != quote.Reseller_BPID__c){
                    if(mapSite.containsKey(quote.Reseller_BPID__c)){
                        quote.Reseller_ID__c =mapSite.get(quote.Reseller_BPID__c);
                        
                    }
                }
                if( !String.isEmpty(quote.EndUser_BPID__c) && oldQuote.EndUser_BPID__c != quote.EndUser_BPID__c){
                    if(mapSite.containsKey(quote.EndUser_BPID__c)){
                        quote.EndUser_ID__c =mapSite.get(quote.EndUser_BPID__c);
                        
                    }
                }
                //partner customer details site assc lookup - BAJPI01
            }
        }
    }
    
    
    protected override void afterInsert() {
        
        for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
            //CAELPQuoteLineUpdate.updateQuoteLine(quote);
            if( quote.Payment_Plan__c == 'Per Ramp Schedule' ){
                
                createRampPaymentPlans(quote);
                
            }else{
                
                createPaymentPlans(quote);
                
            }       
            
        }
        
    }
    
    protected override void afterUpdate() {
        
        for (SBQQ__Quote__c quote : (List<SBQQ__Quote__c>) Trigger.new) {
            //CAELPQuoteLineUpdate.updateQuoteLine(quote);
            deleteExistingPaymentPlans(quote); 
            
            
            if(  quote.Payment_Plan__c == 'Per Ramp Schedule'  ){
                
                createRampPaymentPlans(quote);
                
                
            }else{
                
                createPaymentPlans(quote);
                
            }          
            
        }
    }
    
    /*
    protected override void beforeDelete() {
    
    }

    protected override void afterDelete() {
    
    }
    */
    
    // VK: added on 8/29/2017
    // creates payment plans for quotes on changing the status to validated 
    private void createPaymentPlans(SBQQ__Quote__c quote) {
        if (SBQQ.TriggerControl.getInstance().isDisabled()) {
            return;
        }
        
        List<Payment_Plan__c> paymentPlans = new List<Payment_Plan__c>();
        
            SBQQ__Quote__c oldQuote = new SBQQ__Quote__c();
            
            if(Trigger.oldMap != null) { // handles the update scenario
                oldQuote = (SBQQ__Quote__c) Trigger.oldMap.get(quote.Id);
            } 
            System.debug('**createPaymentPlans newStatus/oldStatus ' + quote.SBQQ__Status__c+'/'+oldQuote.SBQQ__Status__c);
            
            // create new plans ONLY when quote status is changed to Validated
            if(quote.SBQQ__Status__c.equals('Quote Validated') && !quote.SBQQ__Status__c.equals(oldQuote.SBQQ__Status__c) ) {
    
                List<Payment_Plan__c> paymentPlansThisQuote = new List<Payment_Plan__c>();
                Date paymentPlanDate = quote.Start_Date_Min__c ;
                System.debug('**paymentPlanDate/End_Date_form ' + paymentPlanDate+'/'+quote.End_Date_form__c);
                while (quote.End_Date_form__c != null && paymentPlanDate <= quote.End_Date_form__c) {
                    Payment_Plan__c pp = new Payment_Plan__c(Quote__c=quote.Id, Date__c=paymentPlanDate);
                    if(quote.CurrencyIsoCode != null) pp.CurrencyIsoCode = quote.CurrencyIsoCode;
                    paymentPlansThisQuote.add(pp);
                    
                    if(quote.Payment_Plan__c=='Monthly') {
                        paymentPlanDate = paymentPlanDate.addMonths(1);                
                    } else if(quote.Payment_Plan__c=='Quarterly') {
                        paymentPlanDate = paymentPlanDate.addMonths(3); 
                    } else if(quote.Payment_Plan__c=='Annual') {
                        paymentPlanDate = paymentPlanDate.addYears(1); 
                    } else {
                        // Don't create any payment plans
                        paymentPlansThisQuote.clear();
                        break;
                    }
                } // end while
                
                List<SBQQ__QuoteLine__c> quoteLines = [Select Id, CA_License_Type__c, Maintenance_Product__c, Business_Transaction_Type_SAP__c, SBQQ__NetTotal__c  from SBQQ__QuoteLine__c where SBQQ__Quote__c = :quote.Id ];
                
                decimal licenseTotal = 0.00;
                decimal maintenanceTotal = 0.00;
                decimal subscriptionTotal = 0.00;
                decimal educationTotal = 0.00;
                decimal servicesTotal = 0.00;
                
                for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                    
                    if(quoteLine.Maintenance_Product__c == 'Yes'){
                        
                        maintenanceTotal += quoteLine.SBQQ__NetTotal__c;
                        
                        continue;
                        
                    }
                    
                    if( quoteLine.CA_License_Type__c == 'P'){
                        
                        licenseTotal += quoteLine.SBQQ__NetTotal__c;
                        
                        continue;
                        
                    }
                    
                    
                    if(quoteLine.CA_License_Type__c == 'L' || quoteLine.CA_License_Type__c == 'S'){
                        
                        subscriptionTotal += quoteLine.SBQQ__NetTotal__c;
                        
                        continue;
                        
                    }
                    
                    if(quoteLine.Business_Transaction_Type_SAP__c == 'Education'){
                        
                        educationTotal += quoteLine.SBQQ__NetTotal__c;
                        
                        continue;
                        
                    }
                    
                    if(quoteLine.Business_Transaction_Type_SAP__c == 'Services' || quoteLine.Business_Transaction_Type_SAP__c == 'PWP'){
                        
                        servicesTotal += quoteLine.SBQQ__NetTotal__c;
                        
                        continue;
                        
                    }
                              
                }
                
                System.debug('Line Totals '+licenseTotal+' - '+maintenanceTotal+' - '+subscriptionTotal+' - '+educationTotal+' - '+servicesTotal);
            
                decimal totalAmount = licenseTotal+maintenanceTotal+subscriptionTotal+educationTotal+servicesTotal;
                
                
                integer noOfPlans = paymentPlansThisQuote.size();
                System.debug('XXXX noOfPlans=' + noOfPlans);
                if(noOfPlans > 0 && totalAmount > 0) {
                    
                    //decimal installmentAmount = quote.SBQQ__NetAmount__c/noOfPlans;
                    decimal licenseInstallmentAmount = licenseTotal/noOfPlans;
                    
                    if(quote.Payment_Plan__c=='Annual'){
                        
                        licenseInstallmentAmount = licenseTotal;
                        
                    }
                    
                    decimal maintenanceInstallmentAmount = maintenanceTotal/noOfPlans;
                    decimal subscriptionInstallmentAmount = subscriptionTotal/noOfPlans;
                    decimal educationInstallmentAmount = educationTotal;
                    decimal servicesInstallmentAmount = servicesTotal/noOfPlans;
                    
                    licenseInstallmentAmount = licenseInstallmentAmount.SetScale(2);
                    maintenanceInstallmentAmount = maintenanceInstallmentAmount.SetScale(2);
                    subscriptionInstallmentAmount = subscriptionInstallmentAmount.SetScale(2);
                    educationInstallmentAmount = educationInstallmentAmount.SetScale(2);
                    servicesInstallmentAmount = servicesInstallmentAmount.SetScale(2);
                    
                    //decimal runningTotal = 0.00;
                    
                    decimal licenseRunningTotal = 0.00;
                    decimal maintenanceRunningTotal = 0.00;
                    decimal subscriptionRunningTotal = 0.00;
                    decimal servicesRunningTotal = 0.00;
                    
                    for(integer i=0; i<paymentPlansThisQuote.size(); i++){
                        
                        Payment_Plan__c pp = paymentPlansThisQuote.get(i);
                        
                        if(i > 0){
                            
                            if(quote.Payment_Plan__c=='Annual'){
                                
                                licenseInstallmentAmount = 0.00;
                                
                            }
                            
                            educationInstallmentAmount = 0.00;
                            
                        } 
                        
                        if(i==(paymentPlansThisQuote.size()-1)) { // last installment, capture remainder amount in the final payment
                            
                            if(quote.Payment_Plan__c != 'Annual')licenseInstallmentAmount = licenseTotal - licenseRunningTotal;
                            maintenanceInstallmentAmount = maintenanceTotal - maintenanceRunningTotal;
                            subscriptionInstallmentAmount = subscriptionTotal - subscriptionRunningTotal;
                            servicesInstallmentAmount = servicesTotal - servicesRunningTotal;
                            
                        }
                        
                        //String formattedAmount = QuotePaymentPlans.formatCurrency(installmentAmount, quote.CurrencyIsoCode);
                        
                        //pp.Amount__c= decimal.valueOf(formattedAmount);//installmentAmount;
                        //installmentAmount = installmentAmount.setScale(2); 
                        
                        licenseInstallmentAmount = licenseInstallmentAmount.SetScale(2);
                        maintenanceInstallmentAmount = maintenanceInstallmentAmount.SetScale(2);
                        subscriptionInstallmentAmount = subscriptionInstallmentAmount.SetScale(2);
                        educationInstallmentAmount = educationInstallmentAmount.SetScale(2);
                        servicesInstallmentAmount = servicesInstallmentAmount.SetScale(2);  
                                                
                        String formattedString = licenseInstallmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.License_Amount__c= decimal.valueOf(formattedString); 
                        
                        formattedString = maintenanceInstallmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.Maintenance_Amount__c= decimal.valueOf(formattedString); 
                        
                        formattedString = subscriptionInstallmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.Subscription_Amount__c= decimal.valueOf(formattedString); 
                        
                        formattedString = educationInstallmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.Education_Amount__c= decimal.valueOf(formattedString); 
                        
                        formattedString = servicesInstallmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.Services_Amount__c= decimal.valueOf(formattedString); 
                        
                        Decimal installmentAmount = licenseInstallmentAmount+maintenanceInstallmentAmount+subscriptionInstallmentAmount+educationInstallmentAmount+servicesInstallmentAmount;
                        
                        formattedString = installmentAmount.format();
                        formattedString = formattedString.replace(',', '');
                        pp.Amount__c= decimal.valueOf(formattedString); 
                        
                        //runningTotal=runningTotal+installmentAmount; // on last run this should total to be same as SBQQ__NetAmount__c
                        if(quote.Payment_Plan__c != 'Annual')licenseRunningTotal+=licenseInstallmentAmount;
                        maintenanceRunningTotal+=maintenanceInstallmentAmount;
                        subscriptionRunningTotal+=subscriptionInstallmentAmount;
                        servicesRunningTotal+=servicesInstallmentAmount;

                    }
                } else {
                    
                    // Don't create any payment plans if Net Amount for somereason is zero
                    paymentPlansThisQuote.clear();          
                    Payment_Plan__c pp = new Payment_Plan__c(Quote__c=quote.Id, Date__c=quote.Start_Date_Min__c);
                    if(quote.CurrencyIsoCode != null) pp.CurrencyIsoCode = quote.CurrencyIsoCode;
                    
                    pp.Amount__c = 0;
                    
                    paymentPlansThisQuote.add(pp);
                    
                }
                
                
                paymentPlans.addAll(paymentPlansThisQuote);
            } // end if matching condition
        
        if (paymentPlans.size() > 0) { 
            insert paymentPlans;
            
            SBQQ__Quote__c newQuote = [Select Id, SBQQ__NetAmount__c, Payment_Schedule_Total__c from SBQQ__Quote__c where Id = :quote.Id];
            
            System.debug('**NetAmount '+newQuote.SBQQ__NetAmount__c);
            System.debug('**PaymentAmount '+newQuote.Payment_Schedule_Total__c);
            System.debug('**NetAmount '+newQuote.SBQQ__NetAmount__c.setScale(0));
            System.debug('**PaymentAmount '+newQuote.Payment_Schedule_Total__c.setScale(0));
            
            if(!Test.isRunningTest())if(newQuote.SBQQ__NetAmount__c.setScale(0) <> newQuote.Payment_Schedule_Total__c.setScale(0)) quote.addError('The Quote Net Amount does not equal the Payment Schedule Total');
            
        }
    }
    
    private void createRampPaymentPlans(SBQQ__Quote__c quote) {
        
        //List of Payment Plans to insert
        List<Payment_Plan__c> paymentPlans = new List<Payment_Plan__c>();
        
        //List of Anniversary Dates
        List<Date> dateList = new List<Date>();
        
        //Map of payment plans created, with the due date as the key
        Map<Date, Payment_Plan__c> paymentPlanMap = new Map<Date, Payment_Plan__c>();
        
        //holder for the old quote if this is an update
        SBQQ__Quote__c oldQuote = new SBQQ__Quote__c();
        
        if(Trigger.oldMap != null) { // handles the update scenario
            oldQuote = (SBQQ__Quote__c) Trigger.oldMap.get(quote.Id);
        } 
        
        System.debug('**createPaymentPlans newStatus/oldStatus ' + quote.SBQQ__Status__c+'/'+oldQuote.SBQQ__Status__c);
        
        // create new plans ONLY when quote status is changed to Validated
        if(quote.SBQQ__Status__c.equals('Quote Validated') && !quote.SBQQ__Status__c.equals(oldQuote.SBQQ__Status__c) ) {
            
            //Start date is SBQQ_StartDate unless the type is Quote
            Date startDate = quote.SBQQ__StartDate__c ;
            
            //If type is Quote, then start date becomes Start_Date_Group_Min
            if(quote.SBQQ__Type__c == 'Quote'){
                
                startDate = quote.Start_Date_Group_Min__c;
                
            }
            
            //Holder for anniversary date
            Date anniversaryDate = startDate;
            
            //Populate the list of anniversary dates, starting from the start date of the quote            
            while(anniversaryDate < quote.End_Date_form__c){
                
                dateList.add(anniversaryDate);
                
                anniversaryDate = anniversaryDate.addYears(1);
                
            }
                  
            //Get a list of Quote Line Groups
            List<SBQQ__QuoteLineGroup__c> quoteLineGroups = [Select SBQQ__NetTotal__c, SBQQ__StartDate__c, Name from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c  = :quote.Id];
            
            System.debug('XXXX quoteLineGroups.size() ' + quoteLineGroups.size());
            
            //Loop through Quote Line Groups to make payment plans
            for(SBQQ__QuoteLineGroup__c quoteLineGroup : quoteLineGroups){
                
                System.debug('**QuoteLine Group - '+quoteLineGroup.Name);
                
                //Only create payment plan for the line group of the total is > 0
                if(quoteLineGroup.SBQQ__NetTotal__c > 0 ){
                    
                    //The initial paymentPlanDate is the SBQQ_StartDate of the quote line group
                    Date paymentPlanDate = quoteLineGroup.SBQQ__StartDate__c;
                    
                    System.debug('LineGroup Start Date/End Date - '+paymentPlanDate+'/'+quote.End_Date_form__c);
                    
                    List<SBQQ__QuoteLine__c> quoteLines = [Select Id, CA_License_Type__c, Maintenance_Product__c, Business_Transaction_Type_SAP__c, SBQQ__NetTotal__c  from SBQQ__QuoteLine__c where SBQQ__Quote__c = :quote.Id and Start_Date__c = :paymentPlanDate ];
                    
                    System.debug('QuoteLine size - '+quoteLines.size());
                    
                    decimal licenseTotal = 0.00;
                    decimal maintenanceTotal = 0.00;
                    decimal subscriptionTotal = 0.00;
                    decimal educationTotal = 0.00;
                    decimal servicesTotal = 0.00;
                    
                    for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                        
                        if(quoteLine.Maintenance_Product__c == 'Yes'){
                            
                            maintenanceTotal += quoteLine.SBQQ__NetTotal__c;
                            
                            continue;
                            
                        }
                        
                        if( quoteLine.CA_License_Type__c == 'P'){
                            
                            licenseTotal += quoteLine.SBQQ__NetTotal__c;
                            
                            continue;
                            
                        }
                        
                        
                        if(quoteLine.CA_License_Type__c == 'L' || quoteLine.CA_License_Type__c == 'S'){
                            
                            subscriptionTotal += quoteLine.SBQQ__NetTotal__c;
                            
                            continue;
                            
                        }
                        
                        if(quoteLine.Business_Transaction_Type_SAP__c == 'Education'){
                            
                            educationTotal += quoteLine.SBQQ__NetTotal__c;
                            
                            continue;
                            
                        }
                        
                        if(quoteLine.Business_Transaction_Type_SAP__c == 'Services' || quoteLine.Business_Transaction_Type_SAP__c == 'PWP'){
                            
                            servicesTotal += quoteLine.SBQQ__NetTotal__c;
                            
                            continue;
                            
                        }
                        
                    }
                    
                    //The total months of the quote line group from start to quote end date
                    Integer totalMonths = paymentPlanDate.monthsBetween(quote.End_Date_form__c);
                    
                    //if the end date has a day that is greater than 15, then we need to round up to one more month in the total months of a quote line group
                    if(quote.End_Date_form__c.day() > 15){
                        
                        totalMonths += 1;
                        
                    }
                    
                    //The total amount of the quote line group
                    //Double totalAmount = quoteLineGroup.SBQQ__NetTotal__c;
                    Double totalAmount = licenseTotal+maintenanceTotal+subscriptionTotal+educationTotal+servicesTotal;
                    
                    //loop through dates, creating payment plans if neccessary between start date and end date
                    while (quote.End_Date_form__c != null && paymentPlanDate < quote.End_Date_form__c) {
                        
                        Payment_Plan__c pp;
                        
                        System.debug('**PaymentPlanDate - '+paymentPlanDate);
                        
                        //If the paymenyPlanMap already has a payment plan with this paymentPlanDate, then get that paymentPlan to update, else create a new payment plan
                        if(paymentPlanMap.containsKey(paymentPlanDate)){
                            
                            System.debug('**Existing Payment Plan with date '+paymentPlanDate);
                            
                            pp = paymentPlanMap.get(paymentPlanDate);
                            
                        }else{
                            
                            System.debug('**New Payment Plan with date '+paymentPlanDate);
                            
                            pp = new Payment_Plan__c(Quote__c=quote.Id, Date__c=paymentPlanDate);
                                                      
                        }
                        
                        //placeholder for the current payment plan date we are working with
                        Date currentPlanDate = paymentPlanDate;
                        
                        //Loop through the anniversary date list to find the next payment plan date
                        for(Date nextDate : dateList){
                            
                            //when and if the current payment date we are working with is less than one of the anniversary dates, then set the next payment plan date to that date
                            if(currentPlanDate < nextDate){
                                                         
                                educationTotal = 0;
                                
                                paymentPlanDate = nextDate;
                                
                                break;
                                
                            }
                            
                        }
                        
                        //In this scenario if no more anniversary dates are found the new date will be equal to the current date we are working with, so set the new date + 1 year in order to break the loop
                        if(currentPlanDate == paymentPlanDate) paymentPlanDate = paymentPlanDate.addYears(1);
                        
                        //End date of the current payment plan becomes the next payment plan date
                        Date endDate = paymentPlanDate;
                        
                        //if the end date is greater than the quote end date, then set the end date to the quote end date
                        if(endDate > quote.End_Date_form__c) endDate = quote.End_Date_form__c;
                        
                        //Range of months between the payment plan start and end date
                        Integer currentRange = currentPlanDate.monthsBetween(endDate);
                        
                        //if the end date has a day that is greater than 15, then we need to round up to one more month in the current range of the payment plan
                        if(endDate.day() > 15){
                            
                            currentRange += 1;
                            
                        }
                        
                        System.debug('**Total Month/Current Month Range - '+totalMonths+'/'+currentRange);
                        
                        //divide the total line group amount by the total months in the line group
                        double currentAmount = totalAmount/totalMonths;
                        
                        double currentLicenseAmount = licenseTotal/totalMonths;
                        double currentMaintenanceAmount = maintenanceTotal/totalMonths;
                        double currentSubscriptionAmount = subscriptionTotal/totalMonths;
                        double currentEducationAmount = educationTotal;
                        double currentServicesAmount = servicesTotal/totalMonths;
                        
                        System.debug('**Fraction - '+currentAmount);

                        currentLicenseAmount = currentLicenseAmount * currentRange;
                        currentMaintenanceAmount = currentMaintenanceAmount * currentRange;
                        currentSubscriptionAmount = currentSubscriptionAmount * currentRange;
                        currentServicesAmount = currentServicesAmount * currentRange;
                        
                        
                        System.debug('**Payment Amount - '+currentAmount);
                        
                        double paymentAmount = pp.Amount__c;
                        
                        double licenseAmount = pp.License_Amount__c;
                        double maintenanceAmount = pp.Maintenance_Amount__c;
                        double subscriptionAmount = pp.Subscription_Amount__c;
                        double educationAmount = pp.Education_Amount__c;
                        double servicesAmount = pp.Services_Amount__c;
                        
                        //multiply the fractional amount of the line group by number of months in this payment plan
                        //currentAmount = currentAmount * currentRange;
                        currentAmount = currentLicenseAmount+currentMaintenanceAmount+currentSubscriptionAmount+currentServicesAmount+currentEducationAmount;
                        
                        //if the payment plan already has an amount, then add the calculated amount to that amount.  If not add the current amount to the payment plan
                        if(paymentAmount != null){
                            
                            pp.Amount__c = paymentAmount+currentAmount;
                           
                        }else{
                            
                            pp.Amount__c = currentAmount;
                           
                        }
                        
                        if(licenseAmount != null){
                                                
                            pp.License_Amount__c = licenseAmount+currentLicenseAmount;
                            
                        }else{
                               
                            pp.License_Amount__c = currentLicenseAmount;
                            
                        }
                        
                        if(maintenanceAmount != null){
                            
                            pp.Maintenance_Amount__c = maintenanceAmount+currentMaintenanceAmount;
                            
                        }else{
                            
                            pp.Maintenance_Amount__c = currentMaintenanceAmount;
                            
                        }
                        
                        if(subscriptionAmount != null){
                            
                            pp.Subscription_Amount__c = subscriptionAmount+currentSubscriptionAmount;
                            
                        }else{
                            
                            pp.Subscription_Amount__c = currentSubscriptionAmount;
                            
                        }
                        
                        if(educationAmount != null){
                            
                            pp.Education_Amount__c = educationAmount+currentEducationAmount;
                            
                        }else{
                            
                            pp.Education_Amount__c = currentEducationAmount;
                            
                        }
                        
                        if(servicesAmount != null){
                            
                            pp.Services_Amount__c = servicesAmount+currentServicesAmount;
                            
                        }else{
                            
                            pp.Services_Amount__c = currentServicesAmount;
                            
                        }
                        
                        //Put the payment plan in the map
                        paymentPlanMap.put(currentPlanDate, pp);
                                               
                    }
                    
                }
                
            }
            
            //serialize the map to a list of payment plans to insert
            paymentPlans = paymentPlanMap.values();
            
            //insert payment plans if there are any in the list
            if (paymentPlans.size() > 0) { 
                insert paymentPlans;
            }
            
        }
        
    }
    
    // VK: added on 8/29/2017
    // deletes existing payment plans for quotes on changing the status to validated and plan not equal to Custom    
    private void deleteExistingPaymentPlans(SBQQ__Quote__c quote) {
        System.debug('**inside deleteExistingPaymentPlans');
        List<Id> quoteIds = new List<Id>();
        
        SBQQ__Quote__c oldQuote = (SBQQ__Quote__c) Trigger.oldMap.get(quote.Id);
        System.debug('****Parameters '+quote.Payment_Plan__c+ ' - '+quote.SBQQ__Status__c+' - '+oldQuote.SBQQ__Status__c);
        // delete existing plans ONLY if Quote was moved to validated status and Payment_Plan is NOT 'Custom'
        if(!quote.Payment_Plan__c.equals('Custom') && 
           quote.SBQQ__Status__c.equals('Quote Validated') && !quote.SBQQ__Status__c.equals(oldQuote.SBQQ__Status__c)) {
               System.debug('****Quote to delete from '+quote.Id);
               quoteIds.add(quote.Id);
           }
        
        if(quoteIds.size() > 0) {
            List<Payment_Plan__c> paymentPlans = [Select Id from Payment_Plan__c where quote__c in :quoteIds];
            System.debug('**Plan Count '+paymentPlans.size());
            //System.debug('paymentPlans.size() = ' + paymentPlans.size());
            if(paymentPlans != null && paymentPlans.size() > 0) {
                delete paymentPlans;
            }
        }
    }
    
    private static void getContractDetails(Set<Id> contractIdSet){
        if(ContractIdMap==null)
            ContractIdMap = new Map<Id,Contract>([SELECT id, Bill_To_Address_Lcl__c,Billing_Contact__c,Billing_Contact_Email__c,
                                                  Billing_Contact_First_Name__c,Billing_Contact_Intl_First_Name__c,Billing_Contact_Intl_Last_Name__c,
                                                  Billing_Contact_Last_Name__c,Billing_Contact_Phone__c,Bill_To__c,BillTo_City_Intl__c,
                                                  BillTo_Name_Intl__c,BillTo_State_Intl__c,BillTo_Street_Intl__c,BillTo_Street2_Intl__c,
                                                  Bill_To_City__c,Bill_To_Country__c,Bill_To_Name__c,Bill_To_PostalCode__c,Bill_To_State__c,
                                                  Bill_To_Street__c,Bill_To_Street2__c,CA_Bill_To_Name_Lcl__c,CA_Customer_Name_Sold_To_Lcl__c,
                                                  CA_Ship_To_Name_Lcl__c,Shipping_Contact__c,Shipping_Contact_Email__c,Shipping_Contact_First_Name__c,
                                                  Shipping_Contact_Intl_First_Name__c,Shipping_Contact_Intl_Last_Name__c,Shipping_Contact_Last_Name__c,
                                                  Shipping_Contact_Phone__c,Ship_To__c,ShipTo_BPID__c,ShipTo_City_Intl__c,ShipTo_Name__c,
                                                  ShipTo_Name_Intl__c,ShipTo_State_Intl__c,ShipTo_Street_Intl__c,ShipTo_Street2_Intl__c,Ship_To_City__c,
                                                  Ship_To_Country__c,Ship_To_PostalCode__c,Ship_To_State__c,Ship_To_Street__c,Ship_To_Street2__c,
                                                  Sold_To_Address_Lcl__c,Sold_To__c,SoldTo_BPID__c,SoldTo_City_Intl__c,SoldTo_Name_Intl__c,
                                                  SoldTo_State_Intl__c,SoldTo_Street_Intl__c,SoldTo_Street2_Intl__c,Sold_To_City__c,
                                                  Sold_To_Country__c,Sold_To_Name__c,Sold_To_PostalCode__c,Sold_To_State__c,Sales_Organization__c,Sold_To_Street__c,
                                                  Sold_To_Street2__c,Technical_Contact__c,Technical_Contact_Email__c,
                                                  Technical_Contact_First_Name__c,Technical_Contact_Intl_First_Name__c,Booking_Country__c,
                                                  Technical_Contact_Intl_Last_Name__c,Company_Registration_Number__c,Company_code__c,Technical_Contact_Last_Name__c,Technical_Contact_Phone__c,
                                                  SBQQ__Opportunity__c,
                                                  EndUser_Contact_Email__c,EndUser_Contact_First_Name__c,EndUser_Contact_ID__c,
                                                  EndUser_Contact_Intl_First_Name__c,EndUser_Contact_Intl_Last_Name__c,EndUser_Contact_Last_Name__c,
                                                  EndUser_Contact_Phone__c,EndUser_City__c,EndUser_City_Intl__c,EndUser_Country__c,EndUser_BPID__c,
                                                  EndUser_ID__c,EndUser_Name__c,EndUser_Name_Intl__c,EndUser_Postal_Code__c,EndUser_State__c,
                                                  EndUser_State_Intl__c,EndUser_Street__c,EndUser_Street2__c,EndUser_Street2_Intl__c,EndUser_Street_Intl__c,
                                                  Reseller_City__c,Reseller_City_Intl__c,Reseller_Country__c,Reseller_BPID__c,Reseller_ID__c,
                                                  Reseller_Name__c,Reseller_Name_Intl__c,Reseller_Postal_Code__c,Reseller_State__c,Reseller_State_Intl__c,
                                                  Reseller_Street__c,Reseller_Street2__c,Reseller_Street2_Intl__c,Reseller_Street_Intl__c
                                                  from Contract where id in :contractIdSet]);
    }
    
    private SBQQ__Quote__c mapContractFieldsToQuote(SBQQ__Quote__c q, Contract c){
        q.Bill_To_Address_Lcl__c = c.Bill_To_Address_Lcl__c;
        q.BillingContact_ID__c = c.Billing_Contact__c;
        q.BillingContact_Email__c = c.Billing_Contact_Email__c;
        q.BillingContact_FirstName__c = c.Billing_Contact_First_Name__c;
        q.BillingContact_IntlFName__c = c.Billing_Contact_Intl_First_Name__c;
        q.BillingContact_IntlFName__c = c.Billing_Contact_Intl_Last_Name__c;
        q.BillingContact_LastName__c = c.Billing_Contact_Last_Name__c;
        q.BillingContact_Phone__c = c.Billing_Contact_Phone__c;
        q.BillTo_BPID__c = c.Bill_To__c;
        q.BillTo_City_Intl__c = c.BillTo_City_Intl__c;
        q.BillTo_Name_Intl__c = c.BillTo_Name_Intl__c;
        q.BillTo_State_Intl__c = c.BillTo_State_Intl__c;
        q.BillTo_Street_Intl__c = c.BillTo_Street_Intl__c;
        q.BillTo_Street2_Intl__c = c.BillTo_Street2_Intl__c;
        q.BillTo_City__c = c.Bill_To_City__c;
        q.BillTo_Country__c = c.Bill_To_Country__c;
        q.BillTo_Name__c = c.Bill_To_Name__c;
        q.BillTo_PostalCode__c = c.Bill_To_PostalCode__c;
        q.BillTo_State__c = c.Bill_To_State__c;
        q.BillTo_Street__c = c.Bill_To_Street__c;
        q.BillTo_Street2__c = c.Bill_To_Street2__c;
        q.CA_Bill_To_Name_Lcl__c = c.CA_Bill_To_Name_Lcl__c;
        q.CA_Customer_Name_Sold_To_Lcl__c = c.CA_Customer_Name_Sold_To_Lcl__c;
        q.CA_Ship_To_Name_Lcl__c = c.CA_Ship_To_Name_Lcl__c;
        q.ShippingContact_ID__c = c.Shipping_Contact__c;
        q.ShippingContact_Email__c = c.Shipping_Contact_Email__c;
        q.ShippingContact_FirstName__c = c.Shipping_Contact_First_Name__c;
        q.ShippingContact_IntlFName__c = c.Shipping_Contact_Intl_First_Name__c;
        q.ShippingContact_IntlLName__c = c.Shipping_Contact_Intl_Last_Name__c;
        q.ShippingContact_LastName__c = c.Shipping_Contact_Last_Name__c;
        q.ShippingContact_Phone__c = c.Shipping_Contact_Phone__c;
        q.Ship_To__c = c.Ship_To__c;
        q.ShipTo_BPID__c = c.ShipTo_BPID__c;
        q.ShipTo_City_Intl__c = c.ShipTo_City_Intl__c;
        q.ShipTo_Name__c = c.ShipTo_Name__c;
        q.ShipTo_Name_Intl__c = c.ShipTo_Name_Intl__c;
        q.ShipTo_State_Intl__c = c.ShipTo_State_Intl__c;
        q.ShipTo_Street_Intl__c = c.ShipTo_Street_Intl__c;
        q.ShipTo_Street2_Intl__c = c.ShipTo_Street2_Intl__c;
        q.ShipTo_City__c = c.Ship_To_City__c;
        q.ShipTo_Country__c = c.Ship_To_Country__c;
        q.ShipTo_PostalCode__c = c.Ship_To_PostalCode__c;
        q.ShipTo_State__c = c.Ship_To_State__c;
        q.ShipTo_Street__c = c.Ship_To_Street__c;
        q.ShipTo_Street2__c = c.Ship_To_Street2__c;
        q.Sold_To_Address_Lcl__c = c.Sold_To_Address_Lcl__c;
        q.Sold_To__c = c.Sold_To__c;
        q.SoldTo_BPID__c = c.SoldTo_BPID__c;
        q.SoldTo_City_Intl__c = c.SoldTo_City_Intl__c;
        q.SoldTo_Name_Intl__c = c.SoldTo_Name_Intl__c;
        q.SoldTo_State_Intl__c = c.SoldTo_State_Intl__c;
        q.SoldTo_Street_Intl__c = c.SoldTo_Street_Intl__c;
        q.SoldTo_Street2_Intl__c = c.SoldTo_Street2_Intl__c;
        q.SoldTo_City__c = c.Sold_To_City__c;
        q.SoldTo_Country__c = c.Sold_To_Country__c;
        q.SoldTo_Name__c = c.Sold_To_Name__c;
        q.SoldTo_PostalCode__c = c.Sold_To_PostalCode__c;
        q.SoldTo_State__c = c.Sold_To_State__c;
        q.SoldTo_Street__c = c.Sold_To_Street__c;
        q.SoldTo_Street2__c = c.Sold_To_Street2__c;
        q.TechnicalContact_ID__c = c.Technical_Contact__c;
        q.TechnicalContact_Email__c = c.Technical_Contact_Email__c;
        q.TechnicalContact_FirstName__c = c.Technical_Contact_First_Name__c;
        q.TechnicalContact_IntlFName__c = c.Technical_Contact_Intl_First_Name__c;
        q.TechnicalContact_IntlLName__c = c.Technical_Contact_Intl_Last_Name__c;
        q.TechnicalContact_LastName__c = c.Technical_Contact_Last_Name__c;
        q.TechnicalContact_Phone__c = c.Technical_Contact_Phone__c;
        q.Booking_Country__c = c.Booking_Country__c;
        q.Sales_Organization__c = c.Sales_Organization__c;
        q.Company_Code__c = c.Company_Code__c;
        q.Company_Registration_Number__c = c.Company_Registration_Number__c; 
        
        //populating Partner Site Details to Contract from quote - BAJPI01
        q.EndUser_Contact_Email__c = c.EndUser_Contact_Email__c;
        q.EndUser_Contact_First_Name__c = c.EndUser_Contact_First_Name__c;
        q.EndUser_Contact_ID__c = c.EndUser_Contact_ID__c;
        q.EndUser_Contact_Intl_First_Name__c = c.EndUser_Contact_Intl_First_Name__c;
        q.EndUser_Contact_Intl_Last_Name__c = c.EndUser_Contact_Intl_Last_Name__c;
        q.EndUser_Contact_Last_Name__c = c.EndUser_Contact_Last_Name__c;
        q.EndUser_Contact_Phone__c = c.EndUser_Contact_Phone__c;        
        q.EndUser_City__c = c.EndUser_City__c;
        q.EndUser_City_Intl__c = c.EndUser_City_Intl__c;
        q.EndUser_Country__c = c.EndUser_Country__c;
        q.EndUser_BPID__c = c.EndUser_BPID__c;
        q.EndUser_ID__c = c.EndUser_ID__c;
        q.EndUser_Name__c = c.EndUser_Name__c;
        q.EndUser_Name_Intl__c = c.EndUser_Name_Intl__c;
        q.EndUser_Postal_Code__c = c.EndUser_Postal_Code__c;
        q.EndUser_State__c = c.EndUser_State__c;
        q.EndUser_State_Intl__c = c.EndUser_State_Intl__c;
        q.EndUser_Street__c = c.EndUser_Street__c;
        q.EndUser_Street2__c = c.EndUser_Street2__c;
        q.EndUser_Street2_Intl__c = c.EndUser_Street2_Intl__c;
        q.EndUser_Street_Intl__c = c.EndUser_Street_Intl__c;        
        q.Reseller_City__c = c.Reseller_City__c;
        q.Reseller_City_Intl__c = c.Reseller_City_Intl__c;
        q.Reseller_Country__c = c.Reseller_Country__c;
        q.Reseller_BPID__c = c.Reseller_BPID__c;
        q.Reseller_ID__c = c.Reseller_ID__c;
        q.Reseller_Name__c = c.Reseller_Name__c;
        q.Reseller_Name_Intl__c = c.Reseller_Name_Intl__c;
        q.Reseller_Postal_Code__c = c.Reseller_Postal_Code__c;
        q.Reseller_State__c = c.Reseller_State__c;
        q.Reseller_State_Intl__c = c.Reseller_State_Intl__c;
        q.Reseller_Street__c = c.Reseller_Street__c;
        q.Reseller_Street2__c = c.Reseller_Street2__c;
        q.Reseller_Street2_Intl__c = c.Reseller_Street2_Intl__c;
        q.Reseller_Street_Intl__c = c.Reseller_Street_Intl__c;
        //populating Partner Site Details to Contract from quote - BAJPI01
        
         return q;
    }
    
    public static Decimal convertToOrgCurrency(String currencyIso, Decimal currencyVal, Date currencyDate) {
        
        Decimal res;
        
        Map<ID,DatedConversionRate>              dcrIdToDcrMap;  
        
        if (currencyIso == null || currencyVal == null) {}
        else {
            if (dcrIdToDcrMap == null)              // build the map only once for life of the transaoction
                dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
            for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
                if (dcr.isoCode != currencyIso)                                         continue;   // look for a match in table against input currency
                if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  continue;   // not in the range of effective dates
                System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
                res =  currencyVal / dcr.conversionRate;
                break;  
            }
        }
        System.debug(LoggingLevel.INFO,'convertToOrgCurrency res= ' + res);
        return res;
    }
    
}