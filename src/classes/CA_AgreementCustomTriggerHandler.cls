public Class CA_AgreementCustomTriggerHandler{
    
    public Static set<String> setComparison(set<String> masterSet, set<String> masterSettobeCompared){
        set<String> resultSet = new set<String>();
        for(String s :masterSet){
            if(!masterSettobeCompared.contains(s)){
                resultSet.add(s);
            }
        }
        system.debug('resultSet::::::::::'+resultSet);
        return resultSet;
    }
    
    
    /******
Description: This method is to create AgreementLineitem Records whenever an Agreement of Record Type "Transaction" is created.
******/
    
    public static void insertAgreementLineItemRecords(List<Apttus__APTS_Agreement__c> newAgreement){
        
    //List<Apttus__APTS_Agreement__c> listOfAgr = newAgreement;
    Set<Id> agreementIds = new Set<id>();
    Set<Id> sterQuoteIds = new Set<id>();
    Set<Id> SBQuoteIds = new Set<id>();  
    List<Apttus__AgreementLineItem__c> agreementLineItemsToInsert = new List<Apttus__AgreementLineItem__c>();
    List<Agreement_Payment_Plan__c> agreementPaymentPlanToInsert = new List<Agreement_Payment_Plan__c>();
        list<Apttus__AgreementLineItem__c> agrLineItemToupdate=new list<Apttus__AgreementLineItem__c>();
    Id transactionRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Transaction').getRecordTypeId();
    system.debug('transactionRecordTypeId .....'+transactionRecordTypeId );
        for(Apttus__APTS_Agreement__c currentAgreement: newAgreement){
            if(currentAgreement.RecordTypeId == transactionRecordTypeId  ){
                agreementIds.add(currentAgreement.Id);
                if(currentAgreement.Sterling_Quote__c != null)
                    sterQuoteIds.add(currentAgreement.Sterling_Quote__c);
                 if(currentAgreement.SF_Quote__c != null)
                    SBQuoteIds.add(currentAgreement.SF_Quote__c);
            }
        }
        system.debug('SQuoteIds.....'+sterQuoteIds);
        system.debug('SQuoteIds.....'+sterQuoteIds.size());
        if(sterQuoteIds.size()>0 && sterQuoteIds != null){
            List<Quote_Product_Report__c> quoteLineItemsList = [Select Id, Product_Material__r.Name,No_Charge_Product__c,Reason_for_no_charge__c,New_Additional_Quantity__c,Existing_Quantity__c, Product_Instance_ID__c, License_Metric__c, SAP_IO_User_Status__c, Sterling_Quote__c, Sterling_Quote__r.CA_CPQ_Quote_Number__c, CPQ_Quote_Number__c, Line_Number__c, Product_Name__c, Name, CA_Pricing_Group__c, Stated_Renewal_Fee__c, Total_Proposed_Price__c, Proposed_Lic_Sub_Fee__c, Proposed_Maint_Fee__c, Effective_Date__c, End_Date__c, Shipping_Required__c, Bus_Transaction_Type__c, Delivery_Method__c, Operating_System__c, Auth_Use_Model__c, License_Type__c, Total_Quantity__c, Monthly_Product_Fee_for_Subscriptionterm__c, Lic_Sub_off_List__c, Mainframe_Distributed__c, Volume_License_Subs_Fee__c, Volume_Maintenance_Price__c, Activity_Type__c,   Change_Hours_Units__c,  Charge_Code__c, Cost_Center__c, Discount__c, Discount_Exceeds_Reason__c, End_Dateof_Project__c,  Estimated_Start_Date__c,    Exhibit_Comment__c, Expense_Amount_Included__c, GSA_Rate__c,    Hours_Units__c, List_Rate__c,   List_Rate_Revenue__c,   Planned_Project_Cost__c,    Planned_Project_Revenue__c, PO_Number__c,   Product_1__c,   Product_1_Percent__c,   Product_2__c,   Product_2_Percent__c,   Product_3__c,   Product_3_Percent__c,   Project_Bill_Rate__c,   Contracted_Rate_Used_1__c,  Project_Group__c,   Project_Type__c,    Role_Description__c,    SAP_Contract_Line_Number__c,    Project_Number__c,  Service_Offering__c,    Services_Flag__c,   SKU__c, Std_Cost__c, 
                                                                Vendor_Overhead__c, VSOE_Rate__c, SpecialMetricUsageQtyNewAdditional__c, Special_Metric_Usage_Qty_Existing__c,Project_Description__c from Quote_Product_Report__c where Sterling_Quote__c IN: sterQuoteIds];
            
            List<PaymentPlan__c> payPlanList = [Select Id, Sterling_Quote__r.CA_CPQ_Quote_Number__c, Committed_Payment__c, CPQ_Quote_NUmber__c, Payment_Date__c, Date_Text__c, License_Payment__c, Maintenance_Payment__c, Payment_Total__c, Payment_Type__c, Services_Payment__c, Sterling_Quote__c, Subscription_Payment__c, Initial_Payment__c, Milestone_Description__c, Milestone_Number__c, Number_of_Milestones__c, Payment_Percent_Of_Total__c, Payment_Amount__c, Payment_Date_Services__c, Project_ID__c, sfxId__c, Total_Payments__c from PaymentPlan__c where Sterling_Quote__c IN: sterQuoteIds];
            
            //List<Quote_Product_Report__c> quoteLineItemsList= [Select Id , Name, CPQ_Quote_Number__c,Bus_Transaction_Type__c, CA_Pricing_Group__c,Product_Name__c,Auth_Use_Model__c, Effective_Date__c, End_Date__c, License_Type__c, Mainframe_Distributed__c, Operating_System__c, Proposed_Maint_Fee__c, Proposed_Lic_Sub_Fee__c, Shipping_Required__c, Volume_License_Subs_Fee__c, Volume_Maintenance_Price__c  from Quote_Product_Report__c where Sterling_Quote__c in : sterQuoteIds];
            system.debug('quoteLineItemsList.......'+quoteLineItemsList+'siiiizeee....'+quoteLineItemsList.size());
            system.debug('quoteLineItemsList.......'+newAgreement+'siiiizeee....'+newAgreement.size());
            
            Map<Id,List<Quote_Product_Report__c>> mapQuoteIdvsQPItems = new Map<Id,List<Quote_Product_Report__c>>();
            List<Quote_Product_Report__c> newQPList = new List<Quote_Product_Report__c>();
            if(quoteLineItemsList.size() > 0)
                for(Quote_Product_Report__c qpr : quoteLineItemsList) {
                    if(mapQuoteIdvsQPItems.containsKey(qpr.Sterling_Quote__c)) {
                        newQPList = mapQuoteIdvsQPItems.get(qpr.Sterling_Quote__c);
                        newQPList.add(qpr);
                        mapQuoteIdvsQPItems.put(qpr.Sterling_Quote__c,newQPList);
                    } else {
                        newQPList = new List<Quote_Product_Report__c>();
                        newQPList.add(qpr);
                        mapQuoteIdvsQPItems.put(qpr.Sterling_Quote__c,newQPList);
                    }
                }
            
            Map<Id,List<PaymentPlan__c>> mapQuoteIdvsPPItems = new Map<Id,List<PaymentPlan__c>>();
            List<PaymentPlan__c> newPPList = new List<PaymentPlan__c>();    
            
            if(payPlanList.size() > 0)     
                for(PaymentPlan__c pp : payPlanList) {
                    if(mapQuoteIdvsPPItems.containsKey(pp.Sterling_Quote__c)) {
                        newPPList = mapQuoteIdvsPPItems.get(pp.Sterling_Quote__c);
                        newPPList.add(pp);
                        mapQuoteIdvsPPItems.put(pp.Sterling_Quote__c,newPPList);
                    } else {
                        newPPList = new List<PaymentPlan__c>();
                        newPPList.add(pp);
                        mapQuoteIdvsPPItems.put(pp.Sterling_Quote__c,newpPList);
                    }
                }
            
            if(quoteLineItemsList.size()>0){
                for(Apttus__APTS_Agreement__c newAgre: newAgreement){ 
                    if(mapQuoteIdvsQPItems.containsKey(newAgre.Sterling_Quote__c)) {
                        for(Quote_Product_Report__c qi: mapQuoteIdvsQPItems.get(newAgre.Sterling_Quote__c)){
                            if(!(qi.No_Charge_Product__c!=null && qi.No_Charge_Product__c=='Y' && qi.Reason_for_no_charge__c!=null && qi.Reason_for_no_charge__c!='Stabilized'))
                            {
                                Apttus__AgreementLineItem__c alitem = new Apttus__AgreementLineItem__c();
                                alitem.CA_Auth_Use_Model__c = qi.Auth_Use_Model__c;
                                alitem.CA_Bus_Transaction_Type__c = qi.Bus_Transaction_Type__c;
                                //change for New/Additional quantity change
                                alitem.New_Additional_Quantity__c= qi.New_Additional_Quantity__c;
                                alitem.Existing_Quantity__c= qi.Existing_Quantity__c;
                                
                                //Added by Umang for Use Limitation and Special Metric usage Qty fields population
                                alitem.SpecialMetricsUsageQtyNewAdditional__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                                alitem.SpecialMetricsUsageQtyExisting__c=qi.Special_Metric_Usage_Qty_Existing__c;
                                
                                if(qi.Bus_Transaction_Type__c!=null)
                                {
                                    if(qi.Auth_Use_Model__c=='Special Metric')
                                    {
                                        if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c==''|| qi.Bus_Transaction_Type__c=='Time - Reinstatement')
                                        {
                                            alitem.Use_Limitation__c=qi.Special_Metric_Usage_Qty_Existing__c;
                                        }
                                        if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity'|| qi.Bus_Transaction_Type__c=='Education')
                                        {
                                            alitem.Use_Limitation__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                                        }
                                    }
                                    else
                                    {
                                        if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c=='Time - Product Migration'|| qi.Bus_Transaction_Type__c=='Time - Reinstatement' || qi.Bus_Transaction_Type__c=='Mainframe Capacity' )
                                        {
                                            alitem.Use_Limitation__c=qi.Existing_Quantity__c;
                                        }
                                        if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity')
                                        {
                                            alitem.Use_Limitation__c=qi.New_Additional_Quantity__c;
                                        }
                                    }
                                }
                                //Ended by Umang
                                //change ends
                                //change for svcs added by jagan
                                alitem.Project_Description__c=qi.Project_Description__c;
                                //change ends
                                alitem.CA_CPQ_Quote_Number_Quote_Number__c = qi.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                                alitem.CA_Delivery_Method__c = qi.Delivery_Method__c;
                            alitem.CA_Disc_off_List_License_Subs__c = qi.Lic_Sub_off_List__c;
                            alitem.CA_Effective_Date__c = qi.Effective_Date__c;
                            alitem.CA_End_Date__c = qi.End_Date__c;
                            alitem.CA_License_Type__c = qi.License_Type__c;
                            alitem.CA_Line_Number__c = qi.Line_Number__c;
                            alitem.CA_Mainframe_Distributed__c = qi.Mainframe_Distributed__c;
                            alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c = qi.Monthly_Product_Fee_for_Subscriptionterm__c;
                            alitem.CA_Operating_System__c = qi.Operating_System__c;
                            alitem.CA_Pricing_Group__c = qi.CA_Pricing_Group__c;
                            alitem.CA_Product_Code__c = qi.Product_Material__r.Name;
                            alitem.CA_Product_Name__c = qi.Product_Name__c;
                            alitem.CA_Proposed_Lic_Sub_Price__c = qi.Proposed_Lic_Sub_Fee__c;
                                 //Currency format change 
                                if(alitem.CA_Proposed_Lic_Sub_Price__c>0){
                                alitem.ProposedLicSubPrice__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Lic_Sub_Price__c),newagre.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Proposed_Maintenance_Price__c = qi.Proposed_Maint_Fee__c;
                                 if(alitem.CA_Proposed_Maintenance_Price__c>0){
                                alitem.ProposedMaintenancePriceText__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Maintenance_Price__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.Quote_Line_Item_Id__c = qi.Id;
                            alitem.CA_Shipping_Required__c = qi.Shipping_Required__c;
                            alitem.CA_Stated_Renewal_Price__c = qi.Stated_Renewal_Fee__c;
                                if(alitem.CA_Stated_Renewal_Price__c>0){
                                alitem.StatedRenewalPriceText__c=Currencyformat(string.valueOf(alitem.CA_Stated_Renewal_Price__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.CA_Total_Proposed_Price__c = qi.Total_Proposed_Price__c;
                            //Currency format change 
                                if(alitem.CA_Total_Proposed_Price__c>0){
                                alitem.TotalProposedPriceText__c=Currencyformat(string.valueOf(alitem.CA_Total_Proposed_Price__c),newagre.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Total_Quantity__c = qi.Total_Quantity__c;
                            alitem.CA_Volume_License_Subs_Price__c = qi.Volume_License_Subs_Fee__c;
                            alitem.CA_Volume_Maintenance_Price__c = qi.Volume_Maintenance_Price__c;
                            alitem.Activity_Type__c= qi.Activity_Type__c;
                            alitem.Change_Hours_Units__c= qi.Change_Hours_Units__c;
                            alitem.Charge_Code__c= qi.Charge_Code__c;
                            alitem.Cost_Center__c= qi.Cost_Center__c;
                            //alitem.CA_CPQ_Quote_Number_Quote_Number__c= qi.CPQ_Quote_Number__c;
                            alitem.Discount__c= qi.Discount__c;
                            alitem.Discount_Exceeds_Reason__c= qi.Discount_Exceeds_Reason__c;
                            alitem.End_Date_of_Project__c= qi.End_Dateof_Project__c;
                            alitem.Estimated_Start_Date__c= qi.Estimated_Start_Date__c;
                            alitem.Exhibit_Comment__c= qi.Exhibit_Comment__c;
                            alitem.Expense_Amount_Included__c= qi.Expense_Amount_Included__c;
                            if(alitem.Expense_Amount_Included__c>0){
                                alitem.Expense_Amount_Included_Text__c=Currencyformat(string.valueOf(alitem.Expense_Amount_Included__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.GSA_Rate__c= qi.GSA_Rate__c;
                            if(alitem.GSA_Rate__c>0){
                                alitem.GSARateText__c=Currencyformat(string.valueOf(alitem.GSA_Rate__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.Hours_Units__c= qi.Hours_Units__c;
                            alitem.List_Rate__c= qi.List_Rate__c;
                            if(alitem.List_Rate__c>0){
                                alitem.ListRateText__c=Currencyformat(string.valueOf(alitem.List_Rate__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.List_Rate_Revenue__c= qi.List_Rate_Revenue__c;
                            if(alitem.List_Rate_Revenue__c>0){
                                alitem.ListRateRevenueText__c=Currencyformat(string.valueOf(alitem.List_Rate_Revenue__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Cost__c= qi.Planned_Project_Cost__c;
                            if(alitem.Planned_Project_Cost__c>0){
                                alitem.PlannedProjectCostText__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Revenue__c= qi.Planned_Project_Revenue__c;
                            if(alitem.Planned_Project_Revenue__c>0){
                                alitem.PlannedProjectRevenuetext__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),newagre.CurrencyIsoCode) ;
                                }
                            alitem.PO_Number__c= qi.PO_Number__c;
                            alitem.Product_1__c= qi.Product_1__c;
                            alitem.Product_1_Percent__c= qi.Product_1_Percent__c;
                            alitem.Product_2__c= qi.Product_2__c;
                            alitem.Product_2_Percent__c= qi.Product_2_Percent__c;
                            alitem.Product_3__c= qi.Product_3__c;
                            alitem.Product_3_Percent__c= qi.Product_3_Percent__c;
                            alitem.Project_Bill_Rate__c= qi.Project_Bill_Rate__c;
                            if(alitem.Project_Bill_Rate__c>0){
                            alitem.ProjectBillRateText__c=Currencyformat(string.valueOf(alitem.Project_Bill_Rate__c),newagre.CurrencyIsoCode) ;
                            }
                            alitem.Contracted_Rate_Used_1__c= qi.Contracted_Rate_Used_1__c;
                            alitem.Project_Group__c= qi.Project_Group__c;
                            alitem.Project_Type__c= qi.Project_Type__c;
                            alitem.Role_Description__c = qi.Role_Description__c;
                            alitem.SAP_Contract_Line_Number__c= qi.SAP_Contract_Line_Number__c;
                            alitem.Project_Number__c= qi.Project_Number__c;
                            alitem.SAP_IO_User_Status__c= qi.SAP_IO_User_Status__c;
                            alitem.Service_Offering__c= qi.Service_Offering__c;
                            alitem.Services_Flag__c= qi.Services_Flag__c;
                            alitem.SKU__c= qi.SKU__c;
                            alitem.Std_Cost__c= qi.Std_Cost__c;
                            if(alitem.Std_Cost__c>0){
                            alitem.StdCostText__c=Currencyformat(string.valueOf(alitem.Std_Cost__c),newagre.CurrencyIsoCode) ;
                            }
                            alitem.Vendor_Overhead__c= qi.Vendor_Overhead__c;
                            alitem.VSOE_Rate__c= qi.VSOE_Rate__c;
                            if(alitem.VSOE_Rate__c>0){
                            alitem.VSOERateText__c=Currencyformat(string.valueOf(alitem.VSOE_Rate__c),newagre.CurrencyIsoCode) ;
                            }
                            alitem.CA_License_Metric__c = qi.License_Metric__c;
                                alitem.Apttus__AgreementId__c = newAgre.Id;
                                alitem.CurrencyIsoCode = newAgre.CurrencyIsoCode;
                                alitem.CA_Product_Instance_ID__c = qi.Product_Instance_ID__c;
                                agreementLineItemsToInsert.add(alitem);
                            }
                        }
                    }
                }    
            }
            if(payPlanList.size()>0){
                for(Apttus__APTS_Agreement__c newAgre: newAgreement) {
                    if(mapQuoteIdvsPPItems.containsKey(newAgre.Sterling_Quote__c)) {
                        for(PaymentPlan__c pp : mapQuoteIdvsPPItems.get(newAgre.Sterling_Quote__c)) {
                           Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                             app.CA_Committed_Payments__c = pp.Committed_Payment__c;
                        if(app.CA_Committed_Payments__c> 0){
                    app.CommittedPaymentsText__c=Currencyformat(string.valueOf(app.CA_Committed_Payments__c),newAgre.CurrencyIsoCode) ;
                }
                        
                        
                        app.CPQ_Quote_Number__c = pp.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                        app.Date_Text__c = pp.Date_Text__c;
                        app.CA_License_Payment__c = pp.License_Payment__c;
                        if(app.CA_License_Payment__c> 0){
                    app.LicenseText__c=Currencyformat(string.valueOf(app.CA_License_Payment__c),newAgre.CurrencyIsoCode) ;
                }
                        app.Maintenance_Payment__c = pp.Maintenance_Payment__c;
                        if(app.Maintenance_Payment__c> 0){
                            system.debug('app.Maintenance_Payment__c'+app.Maintenance_Payment__c);
                    app.MaintenanceText__c=Currencyformat(string.valueOf(app.Maintenance_Payment__c),newAgre.CurrencyIsoCode) ;
                }
                        app.CA_Payment_Date__c = pp.Payment_Date__c;
                        app.CA_Payment_Plan_Id__c = pp.Id;
                        app.Payment_Total__c = pp.Payment_Total__c;
                        if(app.Payment_Total__c> 0){
                            system.debug('app.Payment_Total__c'+app.Payment_Total__c);
                    app.PaymentTotaltext__c=Currencyformat(string.valueOf(app.Payment_Total__c),newAgre.CurrencyIsoCode) ;
                }
                        app.Payment_Type__c = pp.Payment_Type__c;
                        app.Services_Payment__c = pp.Services_Payment__c;
                        if(app.Services_Payment__c> 0){
                    app.EducationPaymentsText__c=Currencyformat(string.valueOf(app.Services_Payment__c),newAgre.CurrencyIsoCode) ;
                }
                        app.Subscription_Payment__c = pp.Subscription_Payment__c;
                        if(app.Subscription_Payment__c> 0){
                    app.SubscriptionText__c=Currencyformat(string.valueOf(app.Subscription_Payment__c),newAgre.CurrencyIsoCode) ;
                }
                        app.Initial_Payment__c = pp.Initial_Payment__c;
                        /* if(app.Initial_Payment__c> 0){
                    app.InitialPaymentText__c=Currencyformat(string.valueOf(app.Initial_Payment__c),newAgre.CurrencyIsoCode) ;
                }*/
                        app.Milestone_Description__c = pp.Milestone_Description__c;
                        app.Milestone_Number__c = pp.Milestone_Number__c;
                        app.Number_of_Milestones__c = pp.Number_of_Milestones__c;
                        app.Payment_Of_Total__c = pp.Payment_Percent_Of_Total__c;
                          /*  if(app.Payment_Of_Total__c> 0){
                        app.PaymentOfTotalText__c=Currencyformat(string.valueOf(app.Payment_Of_Total__c),newAgre.CurrencyIsoCode) ;
                }  */
                        app.Payment_Amount__c = pp.Payment_Amount__c;
                        if(app.Payment_Amount__c> 0){
                    app.PaymentAmountText__c=Currencyformat(string.valueOf(app.Payment_Amount__c),newAgre.CurrencyIsoCode) ;
                }
                        app.CA_Payment_Date_Services__c = pp.Payment_Date_Services__c;
                        app.Project_ID__c = pp.Project_ID__c;
                        app.sfxId__c = pp.sfxId__c;
                        app.Total_Payments__c = pp.Total_Payments__c;
                        if(app.Total_Payments__c> 0){
                    app.TotalPaymenttext__c=Currencyformat(string.valueOf(app.Total_Payments__c),newAgre.CurrencyIsoCode) ;
                }
                            app.Agreement__c = newAgre.Id;
                            app.CurrencyIsoCode = newAgre.CurrencyIsoCode;
                            agreementPaymentPlanToInsert.add(app);
                        }
                    }    
                }    
            }
        }
        if(SBQuoteIds.size()>0 && SBQuoteIds!= null){
           List<SBQQ__QuoteLine__c> SBquoteLineItemsList= [Select ID,Name,Quote__c,SBQQ__Number__c,SBQQ__PriorQuantity__c ,Maintenance_Product__c,Maintenance_Parent_Quote_Line__c,Discount_form__c,Start_Date__c,End_Date__c,CA_License_Type__c,Quote_Line_Number_SAP__c,Monthly_Unit_Price__c,SAP_Operating_System__c,Pricing_Group__c,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__NetTotal__c,Net_Total_Form__c,CA_License_Cert__c,SBQQ__Quantity__c,Volume_Discount_Price_form__c,SBQQ__Quote__c,Quantity_Prior__c,
                                                           License_Metric_CPQ__c,SBQQ__ProductCode__c,Instance_ID__c,toLabel(Auth_Use_Mode__c) Auth_Use_Mode__cLabel,Business_Transaction_Type_SAP__c,Parent_Bundle__c from SBQQ__QuoteLine__c where SBQQ__Quote__c IN: SBQuoteIds];
           List<Payment_Plan__c> PaymentPlanList=[Select ID,Quote__c,Quote__r.Name,Date__c,License_Amount_CLM__c,Maintenance_Amount_CLM__c,Subscription_Amount_CLM__c,Education_Amount_CLM__c,Services_Amount_CLM__c,Amount_CLM__c,Payment_Schedule_Total__c,Amount__c from Payment_Plan__c where Quote__c IN: SBQuoteIds];
           List<SBQQ__QuoteLine__c> newSBQuoteList;
           Map<ID,List<SBQQ__QuoteLine__c>> mapSBQuoteVSSBQuoteLineItem= new map<ID,List<SBQQ__QuoteLine__c>>();
            Map<String,Apttus__AgreementLineItem__c> SBQuoteLineNumberAgreementLineItem=new Map<String,Apttus__AgreementLineItem__c>();
           for(SBQQ__QuoteLine__c SBQuote:SBquoteLineItemsList)
           {
               if(mapSBQuoteVSSBQuoteLineItem<>null && mapSBQuoteVSSBQuoteLineItem.size()>0 && mapSBQuoteVSSBQuoteLineItem.containsKey(SBQuote.SBQQ__Quote__c))
                  {
                      newSBQuoteList= mapSBQuoteVSSBQuoteLineItem.get(SBQuote.SBQQ__Quote__c);
                      newSBQuoteList.add(SBQuote);
                      mapSBQuoteVSSBQuoteLineItem.put(SBQuote.SBQQ__Quote__c,newSBQuoteList);
                  }
               else{
                   newSBQuoteList= new list<SBQQ__QuoteLine__c>();
                   newSBQuoteList.add(SBQuote);
                   mapSBQuoteVSSBQuoteLineItem.put(SBQuote.SBQQ__Quote__c,newSBQuoteList);
                   
               }
           }
           Map<ID,List<Payment_Plan__c>> mapSBQuoteIDVSPaymentPlanList= new map<ID,List<Payment_Plan__c>>();
           List<Payment_Plan__c> newPaymentPlanList;
           for(Payment_Plan__c payp: PaymentPlanList){
               if(mapSBQuoteIDVSPaymentPlanList<>null && mapSBQuoteIDVSPaymentPlanList.size()>0 && mapSBQuoteIDVSPaymentPlanList.containsKey(payp.Quote__c)){
                   newPaymentPlanList=mapSBQuoteIDVSPaymentPlanList.get(payp.Quote__c);
                   newPaymentPlanList.add(payp);
                   mapSBQuoteIDVSPaymentPlanList.put(payp.Quote__c,newPaymentPlanList);
                   
               }
               else{
                   newPaymentPlanList= new list<Payment_Plan__c>();
                   newPaymentPlanList.add(payp);
                   mapSBQuoteIDVSPaymentPlanList.put(payp.Quote__c,newPaymentPlanList);
               }
               
               
           }
           if(SBquoteLineItemsList.size()>0){
           for(Apttus__APTS_Agreement__c agr: newAgreement){
               if(mapSBQuoteVSSBQuoteLineItem.containsKey(agr.SF_Quote__c)){
                   for(SBQQ__QuoteLine__c SBQuote:mapSBQuoteVSSBQuoteLineItem.get(agr.SF_Quote__c)){
                       if(!SBQuote.Parent_Bundle__c){
                       Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                           if(SBQuote.Maintenance_Product__c=='Yes'){
                              if(SBQuote.Maintenance_Parent_Quote_Line__c!=null && SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c)!=null)
                              {
                                   alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c);
                              alitem.CA_Proposed_Maintenance_Price__c=SBQuote.Net_Total_Form__c;
                              alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                                  alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                                  alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;	
                              SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Proposed_Maintenance_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                 SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Volume_Maintenance_Price__c=alitem.CA_Volume_Maintenance_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Total_Proposed_Price__c=alitem.CA_Total_Proposed_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Stated_Renewal_Price__c=alitem.CA_Stated_Renewal_Price__c;
                                  agrLineItemToupdate.add(alitem);
                              } 
                               }
                           else{
                       alitem.CA_CPQ_Quote_Number_Quote_Number__c=SBQuote.Quote__c;
                       alitem.Apttus__AgreementId__c = agr.Id;
                       alitem.CA_Disc_off_List_License_Subs__c = SBQuote.Discount_form__c;
                       alitem.CA_Effective_Date__c = SBQuote.Start_Date__c;
                       alitem.CA_End_Date__c = SBQuote.End_Date__c;
                       alitem.CA_Line_Number__c = SBQuote.SBQQ__Number__c;
                       alitem.CA_License_Type__c=SBQuote.CA_License_Type__c;
                       alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c=SBQuote.Monthly_Unit_Price__c;
                       alitem.CA_Operating_System__c=SBQuote.SAP_Operating_System__c;
                       alitem.CA_Pricing_Group__c=SBQuote.Pricing_Group__c;
                       alitem.CA_Product_Code__c=SBQuote.SBQQ__ProductCode__c ;
                       alitem.CA_Product_Name__c=SBQuote.SBQQ__ProductName__c;
                       alitem.CA_Proposed_Lic_Sub_Price__c=SBQuote.Net_Total_Form__c;
                       //alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                               alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c;
                      if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                              // system.debug('SBQuote.Auth_Use_Mode__c '+ SBQuote.Auth_Use_Mode__c);
                     alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                     alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                                alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                     if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null )
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                     alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                    if(alitem.CA_Bus_Transaction_Type__c!=null){
                    if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement'){
                            alitem.Existing_Quantity__c=SBQuote.SBQQ__Quantity__c;    
                            alitem.Use_Limitation__c=alitem.Existing_Quantity__c;
                        alitem.New_Additional_Quantity__c=null;
                        }

                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                     alitem.Use_Limitation__c = alitem.New_Additional_Quantity__c;
                      SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                        agreementLineItemsToInsert.add(alitem);
                    }
                           }
               }
                   }
           }
           }
           }
           if(PaymentPlanList.size()>0){
               for(Apttus__APTS_Agreement__c agr: newAgreement){
                   if(mapSBQuoteIDVSPaymentPlanList.containsKey(agr.SF_Quote__c)){
                   for(Payment_Plan__c payp: mapSBQuoteIDVSPaymentPlanList.get(agr.SF_Quote__c)){
                      Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                            
                       app.Agreement__c = agr.Id;
                       app.CPQ_Quote_Number__c=payp.Quote__r.Name;
                       app.CA_Payment_Date__c=payp.Date__c;
                       app.Payment_Total__c = payp.Amount__c;
                       app.CurrencyIsoCode = agr.CurrencyIsoCode;
                        //US482243 tensor h2 change start
                    app.CA_License_Payment__c= payp.License_Amount_CLM__c;
                    app.Maintenance_Payment__c=payp.Maintenance_Amount_CLM__c;
                    app.Subscription_Payment__c=payp.Subscription_Amount_CLM__c;
                    app.Services_Payment__c=payp.Education_Amount_CLM__c;
                    app.Payment_Amount__c=payp.Services_Amount_CLM__c;
                    app.Payment_Total__c=payp.Amount_CLM__c;
                    //change ends
                       agreementPaymentPlanToInsert.add(app);
                   }   
                   }
           }
           }
       }
        system.debug('AgreeToInsert......'+agreementLineItemsToInsert+'size.....'+agreementLineItemsToInsert.size());
        if(agreementLineItemsToInsert.size() > 0){ 
            insert agreementLineItemsToInsert;
        }
        if(agreementPaymentPlanToInsert.size()> 0) {
            insert agreementPaymentPlanToInsert;
        }
        if(agrLineItemToupdate.size()>0){
            update agrLineItemToupdate;
        }
    }
    
    //This Method to populate Legal Entities on Agreement
    public static void populateLegalEntityOnAgreement(Map<Id,Apttus__APTS_Agreement__c> oldMap,List<Apttus__APTS_Agreement__c> agrList){
        try{
            //List<Apttus__APTS_Agreement__c> updateAgreementsList = new List<Apttus__APTS_Agreement__c>();
            Set<Id> agrIds = new Set<Id>();
            if(oldMap != null) {
                for(Apttus__APTS_Agreement__c agr : agrList) {
                    if(agr.CA_Geo__c != oldMap.get(agr.Id).CA_Geo__c || agr.CA_Operating_Area__c != oldMap.get(agr.Id).CA_Operating_Area__c || agr.CA_Sales_Region__c != oldMap.get(agr.Id).CA_Sales_Region__c || agr.CA_Language__c != oldMap.get(agr.Id).CA_Language__c || agr.CA_Sales_Territory__c != oldMap.get(agr.Id).CA_Sales_Territory__c || agr.CA_Classified_Contract__c != oldMap.get(agr.Id).CA_Classified_Contract__c) {
                        agrIds.add(agr.Id);  
                    }
                }
            } else {
                for(Apttus__APTS_Agreement__c agr : agrList) {
                    agrIds.add(agr.Id);    
                }
            }
            
            List<Apttus__APTS_Agreement__c> updateAgrList = new List<Apttus__APTS_Agreement__c>();
            List<CLM_CA_Legal_Entities__c> cslist = CLM_CA_Legal_Entities__c.getAll().values();
            
            if(agrIds.size() > 0) {
                for(Apttus__APTS_Agreement__c agr : [Select Id, CA_Is_Legacy_Contract__c , CA_Classified_Contract__c, CA_Language__c, CA_Geo__c, CA_Operating_Area__c, CA_Sales_Region__c, CA_Sales_Territory__c, CA_Legal_Entity__c, CA_Legal_Entity_Address__c,CA_Wire_Transfer_Details__c, CA_Courts__c, CA_Laws__c, CA_Time_Zone__c from Apttus__APTS_Agreement__c where Id IN: agrIds]) {
                    //US466711
                                system.debug('agr.CA_Geo__c : ' +agr.CA_Geo__c);
                                if(agr.CA_Geo__c=='PS/CAN' && agr.CA_Classified_Contract__c == Label.CA_Yes ){
                                    agr.CA_Legal_Entity__c = Label.CA_SL;
                                }
                                //change ends 
                    for(CLM_CA_Legal_Entities__c c : cslist) {
                        String csv = agr.CA_Geo__c+'-'+agr.CA_Sales_Territory__c;
                        system.debug('csv value' +csv);
                        if(c.Name.contains(csv)){
                            system.debug('inside csv');
                            if(agr.CA_Language__c.containsIgnoreCase(c.CA_Language__c)) {
                                
                                if(agr.CA_Geo__c == Label.Geo && agr.CA_Operating_Area__c == Label.Operating_Area && agr.CA_Sales_Region__c != Label.Sales_Region && agr.CA_Classified_Contract__c == Label.CA_Yes) {
                                    agr.CA_Legal_Entity__c = Label.CA_SL;
                                } else {
                                    agr.CA_Legal_Entity__c = c.CA_Entity_Name__c;
                                }
                                //US466711
                                system.debug('agr.CA_Geo__c : ' +agr.CA_Geo__c);
                                if(agr.CA_Geo__c=='PS/CAN' && agr.CA_Classified_Contract__c == Label.CA_Yes ){
                                    agr.CA_Legal_Entity__c = Label.CA_SL;
                                }
                                //change ends
                                
                                agr.CA_Legal_Entity_Address__c = c.CA_Entity_Address__c;
                               // agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c;
                                //change for US366459 to accomodate extra values in ca Wire transfer field
                                if(c.CAWireTransferDetailsPart2__c!=null)
                                {
                                agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c+c.CAWireTransferDetailsPart2__c;
                                }
                                else{
                                   agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c; 
                                }
                                //change ends 
                                agr.CA_Courts__c = c.CA_Courts__c;
                                agr.CA_Laws__c = c.CA_Laws__c;
                                agr.CA_Time_Zone__c = c.CA_Time_Zone__c;
                                break;
                            } else {
                                if(c.CA_Language__c == 'English') {
                                    if(agr.CA_Geo__c == Label.Geo && agr.CA_Operating_Area__c == Label.Operating_Area && agr.CA_Sales_Region__c != Label.Sales_Region && agr.CA_Classified_Contract__c == Label.CA_Yes) {
                                        agr.CA_Legal_Entity__c = Label.CA_SL;
                                    } else {
                                        agr.CA_Legal_Entity__c = c.CA_Entity_Name__c;
                                    }
                                    
                                    agr.CA_Legal_Entity_Address__c = c.CA_Entity_Address__c;
                                   // agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c;
                                    //change for US366459 to accomodate extra values in ca Wire transfer field
                                if(c.CAWireTransferDetailsPart2__c!=null)
                                {
                                agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c+c.CAWireTransferDetailsPart2__c;
                                }
                                else{
                                   agr.CA_Wire_Transfer_Details__c = c.CA_Wire_Transfer_Details__c; 
                                }
                                //change ends 
                                    agr.CA_Courts__c = c.CA_Courts__c;
                                    agr.CA_Laws__c = c.CA_Laws__c;
                                    agr.CA_Time_Zone__c = c.CA_Time_Zone__c;
                                }
                            }
                        }
                    }
                    system.debug('Legal Entity Name:::'+agr.CA_Legal_Entity__c);
                    system.debug('Legal Entity Address:::'+agr.CA_Legal_Entity_Address__c);
                    updateAgrList.add(agr);
                }
            } 
            
            if(updateAgrList.size() > 0) {
                update updateAgrList;
            }
        } catch (Exception e) {
            system.debug('Error Message:::'+e.getMessage());
        }    
    }
    
    
    //This method is to update the Agreement Data based on the Primary Quote on Agreement
    public static void updateQuoteDataOnAgreement(Map<Id,Apttus__APTS_Agreement__c> oldMap,List<Apttus__APTS_Agreement__c> newAgrList) {
        try {
            Set<Id> quoteIds = new Set<Id>();
            Set<Id> agremIds = new Set<Id>();
            Set<Id> siteIds = new Set<Id>();
            Set<Id> SFquoteIds = new Set<Id>();
            Id NDARecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('NDA').getRecordTypeId();
            Id MasterRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Master').getRecordTypeId();
            
            system.debug('NDA Record Type Id:::'+NDARecordTypeId);
            system.debug('Master Record Type Id:::'+MasterRecordTypeId);
            system.debug('Agreement List Update Quote Data:::'+newAgrList);
            
            for(Apttus__APTS_Agreement__c agr : newAgrList) {
                if(agr.Apttus__Contract_End_Date__c != null)
                    agr.Apttus__Perpetual__c = false;
                else
                    agr.Apttus__Perpetual__c = true;
                 // US173823 added by Jagan- Is Legacy contract
                if(agr.CA_Is_Legacy_Contract__c != Label.CA_No){
                    agr.CA_Is_Legacy_Contract__c=Label.CA_Yes;
                }
                // US173823 change ends
                
                if(agr.CA_Sales_Type__c == Label.Direct)
                    agr.CA_Account_Type__c = Label.CA_Customer;
                else         
                    agr.CA_Account_Type__c = Label.CA_Partner;
                 if(agr.CA_Sales_Type__c == Label.Direct)
                    agr.CA_Account_Type__c = Label.CA_Customer;
                else         
                    agr.CA_Account_Type__c = Label.CA_Partner;
                system.debug('outside of a::::');
                if(agr.CA_Total_Agreement_Value__c > 0){
                    system.debug('inside of a::::');
                    agr.TotalAgreementValueText__c=Currencyformat(string.valueOf(agr.CA_Total_Agreement_Value__c),agr.CurrencyIsoCode) ;
                    system.debug('agr.TotalAgreementValueText__c : '+agr.TotalAgreementValueText__c);
                }
                if(agr.CA_Product_Total__c>0){
                    agr.ProductTotalText__c=Currencyformat(string.valueOf(agr.CA_Product_Total__c),agr.CurrencyIsoCode) ;
                }
                 if(agr.CA_Services_Quote_Total__c>0){
                    agr.ServicesTotalText__c=Currencyformat(string.valueOf(agr.CA_Services_Quote_Total__c),agr.CurrencyIsoCode) ;
                }
                 if(agr.CA_Services_Total__c>0){
                    agr.EducationTotalText__c=Currencyformat(string.valueOf(agr.CA_Services_Total__c),agr.CurrencyIsoCode) ;
                }
                //change for US373375(removing additional quote if primary quote is deleted)
                 
                    if(agr.Sterling_Quote__c==null)
                        agr.CA_Additional_Quote_Numbers__c=null;
                if(agr.SF_Quote__c==null)
                        agr.Additional_Salesforce_Quote_Numbers__c=null;
                    //change ends
                if(agr.CA_Total_Agreement_Value__c > 0 || agr.CA_Total_Services_Amount__c > 0)
                    agr.Apttus__Total_Contract_Value__c = agr.CA_Total_Agreement_Value__c + agr.CA_Total_Services_Amount__c;
                else
                    agr.Apttus__Total_Contract_Value__c = 0; 
                if(agr.CurrencyIsoCode!='USD'){
                    CurrencyType c=[Select ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE AND ISOCode=: agr.CurrencyIsoCode LIMIT 1];
                    system.debug('c.ConversionRate : '+c.ConversionRate);
                    agr.USD_Equivalent__c=agr.Apttus__Total_Contract_Value__c/c.ConversionRate;
                    system.debug('agr.USD_Equivalent__c : '+agr.USD_Equivalent__c);
                }
                else
                    agr.USD_Equivalent__c=agr.Apttus__Total_Contract_Value__c;
                //US484057 ends
                
                if(agr.Apttus__Status_Category__c == Label.In_Effect && agr.Apttus__Status__c == Label.Being_Amended){
                    Approval.lock(agr.Id);
                }     
                
                if(agr.CA_Is_Legacy_Contract__c == Label.CA_Yes && agr.Apttus__Status_Category__c == Label.Approved && agr.Apttus__Status__c == Label.Approved){
                    agr.Apttus__Status_Category__c = Label.In_Effect;
                    agr.Apttus__Status__c = Label.Activated;
                }
                
                if(agr.Apttus__Status_Category__c == Label.In_Authoring && agr.Apttus__Status__c == Label.Other_Party_Review){
                    agr.Apttus__Status__c = Label.Internal_Review;
                }
                
                if(agr.CA_Is_Legacy_Contract__c == Label.CA_Yes && (agr.CA_Agreement_Amends_Terms_of_Master__c == '' || agr.CA_Agreement_Amends_Terms_of_Master__c == null)){
                    agr.CA_Agreement_Amends_Terms_of_Master__c = Label.Not_Reviewed;
                }
                
                if(agr.Apttus__Status_Category__c == Label.Request && (agr.Apttus__Status__c == '' || agr.Apttus__Status__c == null)){
                    agr.Apttus__Status__c = Label.Request;
                }  
                
                if(agr.Apttus__Status_Category__c == Label.In_Approval && agr.Apttus__Status__c == Label.Pending_Approval && agr.Apttus_Approval__Approval_Status__c == Label.Cancelled) {
                    agr.Apttus__Status_Category__c = Label.In_Authoring;
                    agr.Apttus__Status__c = Label.Author_Contract;
                    agr.Apttus__IsLocked__c = false;
                    agr.Apttus_Approval__Approval_Status__c = Label.Not_Submitted;
                    Approval.unlock(agr);
                }
                
                if(agr.Apttus__Status_Category__c == Label.In_Authoring && agr.Apttus__Status__c == Label.Author_Contract && agr.Apttus_Approval__Approval_Status__c == Label.Not_Submitted) {
                    //agr.Apttus_Approval__Approval_Status__c = Label.Not_Submitted;
                    Approval.unlock(agr);
                }
                
                if(agr.Apttus_Approval__Approval_Status__c == Label.Cancelled || agr.Apttus_Approval__Approval_Status__c == Label.Cancelled){
                    agr.Apttus_Approval__Approval_Status__c = Label.Not_Submitted;
                } 
                
                if(agr.Is_Agreement_Generated__c == true) {
                    system.debug('Is Agreement Entry true');
                    if(agr.Apttus__Status_Category__c == Label.Request && agr.Apttus__Status__c == Label.Request && agr.CA_Record_Type_Name__c != Label.NDA) {
                        agr.Apttus__Status_Category__c = Label.In_Authoring;
                        agr.Apttus__Status__c = Label.Author_Contract;
                    }
                    else{
                        if(agr.CA_Record_Type_Name__c == Label.NDA && agr.CA_NDA_Flag__c == Label.Standard_NDA) {
                            agr.Apttus__Status_Category__c = Label.Approved;
                            agr.Apttus__Status__c = Label.Approved;
                            agr.Apttus__IsLocked__c = true;
                            Approval.lock(agr);
                        } else {
                            agr.Apttus__Status_Category__c = Label.In_Authoring;
                            agr.Apttus__Status__c = Label.Author_Contract;
                        }
                    }
                    agr.Is_Agreement_Generated__c = false;
                }
                system.debug('Agreement Status Category:::'+agr.Apttus__Status_Category__c);
                system.debug('Agreement Status :::'+agr.Apttus__Status__c);
                system.debug('Agreement Document Lock Status :::'+agr.Apttus__IsLocked__c);        
            }
            if(oldMap != null) {
                for(Apttus__APTS_Agreement__c agr : newAgrList) {
                    system.debug('inside 1:::');
                    if(agr.Sterling_Quote__c != oldMap.get(agr.Id).Sterling_Quote__c ||agr.SF_Quote__c != oldMap.get(agr.Id).SF_Quote__c || ((agr.Apttus__Status_Category__c == Label.In_Authoring && (oldMap.get(agr.Id).Apttus__Status_Category__c == Label.In_Approval || oldMap.get(agr.Id).Apttus__Status_Category__c == Label.Approved || oldMap.get(agr.Id).Apttus__Status_Category__c == Label.In_Effect)))) {
                        system.debug('inside 2:::');
                        if(!quoteIds.contains(agr.Sterling_Quote__c)) 
                            quoteIds.add(agr.Sterling_Quote__c);
                        if(!SFquoteIds.contains(agr.SF_Quote__c)) 
                            SFquoteIds.add(agr.SF_Quote__c);
                    /*    if(agr.SF_Quote__c != oldMap.get(agr.Id).SF_Quote__c || ((agr.Apttus__Status_Category__c == Label.In_Authoring && (oldMap.get(agr.Id).Apttus__Status_Category__c == Label.In_Approval || oldMap.get(agr.Id).Apttus__Status_Category__c == Label.Approved || oldMap.get(agr.Id).Apttus__Status_Category__c == Label.In_Effect)))) {
                            if(!SFquoteIds.contains(agr.SF_Quote__c)) 
                            SFquoteIds.add(agr.SF_Quote__c);
                        }*/
                            
                        if(agr.Apttus__IsLocked__c == false && oldMap.get(agr.Id).Apttus__IsLocked__c == true) {
                            if(!agremIds.contains(agr.Id))
                                agremIds.add(agr.Id);
                        }    
                        system.debug('agr.CA_Distributor_Name__c : '+agr.CA_Distributor_Name__c);
                        agr.CA_Street__c = '';
                        agr.CA_City__c = '';
                        agr.CA_State__c = '';
                        agr.CA_Zip_Code__c = '';
                        agr.CA_Country__c = '';
                        agr.CA_Street_Lcl__c = '';
                        agr.CA_City_Lcl__c = '';
                        agr.CA_State_Lcl__c = '';
                        agr.CA_Country_Lcl__c = '';
                        agr.CA_Bill_To_Street__c = '';
                        agr.Bill_To_City__c = '';
                        agr.CA_Bill_To_State__c = '';
                        agr.Bill_To_Zipcode__c = '';
                        agr.Bill_To_Country__c = '';
                        agr.Bill_To_Street_Lcl__c = '';
                        agr.Bill_To_City_Lcl__c = '';
                        agr.CA_Bill_To_State_Lcl__c = '';
                        agr.CA_Bill_To_Country_Lcl__c = '';
                        agr.CA_Ship_To_Street__c = '';
                        agr.CA_Ship_To_City__c = '';
                        agr.Ship_To_State__c = '';
                        agr.CA_Ship_To_Zipcode__c = ''; 
                        agr.Ship_To_Country__c = '';
                        agr.CA_Ship_To_Street_Lcl__c = '';
                        agr.Ship_To_City_Lcl__c = '';
                        agr.Ship_To_State_Lcl__c = '';
                        agr.CA_Ship_To_Country_Lcl__c = '';
                        agr.CA_Reseller_Street__c = '';
                        agr.CA_Reseller_City__c = '';
                        agr.CA_Reseller_State__c = '';
                        agr.CA_Reseller_Zipcode__c = '';
                        agr.CA_Reseller_Country__c = '';
                        agr.CA_Reseller_Street_Lcl__c = '';
                        agr.CA_Reseller_City_Lcl__c = '';
                        agr.CA_Reseller_State_Lcl__c = '';
                        agr.CA_Reseller_Country_Lcl__c = '';
                        agr.CA_Distributor_Street__c = '';
                        agr.CA_Distributor_City__c = '';
                        agr.CA_Distributor_State__c = '';
                        agr.Distributor_Zipcode__c = '';
                        agr.CA_Distributor_Country__c = '';
                        agr.CA_Distributor_Street_Lcl__c = '';
                        agr.CA_Distributor_City_Lcl__c = '';
                        agr.CA_Distributor_State_Lcl__c = '';
                        agr.CA_Distributor_Country_Lcl__c = '';
                        agr.CA_End_User_Street__c = '';
                        agr.CA_End_User_City__c = '';
                        agr.CA_End_User_State__c = '';
                        agr.CA_End_User_Zipcode__c = '';
                        agr.CA_End_User_Country__c = '';
                        agr.CA_End_User_Street_Lcl__c = '';
                        agr.CA_End_User_City_Lcl__c = '';
                        agr.CA_End_User_State_Lcl__c = '';
                        agr.CA_End_User_Country_Lcl__c = '';    
                    }
                    
                    if(agr.Tops_Site_Id_Sold_To_Id__c != oldMap.get(agr.Id).Tops_Site_Id_Sold_To_Id__c) {
                        if(!siteIds.contains(agr.Tops_Site_Id_Sold_To_Id__c)) 
                            siteIds.add(agr.Tops_Site_Id_Sold_To_Id__c);
                    }   
                    
                }
            } else {
                for(Apttus__APTS_Agreement__c agr : newAgrList) {
                    if(!quoteIds.contains(agr.Sterling_Quote__c)) 
                        quoteIds.add(agr.Sterling_Quote__c);
                     //added by Jagan for Tensor
                    if(agr.SF_Quote__c!=null)
                    if(!SFquoteIds.contains(agr.SF_Quote__c)) 
                        SFquoteIds.add(agr.SF_Quote__c);
                    if(!siteIds.contains(agr.Tops_Site_Id_Sold_To_Id__c)) 
                        siteIds.add(agr.Tops_Site_Id_Sold_To_Id__c);
                }
            }
            
            if(agremIds != null && agremIds.size() > 0) {
                Profile p = [select name from Profile where id = :UserInfo.getProfileId()];
                
                if(p.Name == Label.Admin_Profile) {
                    List<Apttus__AgreementLock__c> agrLocks = [Select Id from Apttus__AgreementLock__c where Apttus__AgreementId__c =: agremIds];
                    
                    if(agrLocks.size() > 0)
                        delete agrLocks;
                }
                
            }
            
            
            Map<Id,Site_Association__c> mapSiteAss = new Map<Id,Site_Association__c>();
            
            if(siteIds.size() > 0 && siteIds != null)
                mapSiteAss = new Map<Id,Site_Association__c>([select Id, Name, SAP_Site_ID__c, Street__c, Street2__c, Street3__c, City__c, State__c, Postal_Code__c, Country_Picklist__c, Region__c, Area__c, Territory_Country__c, Country__c from Site_Association__c where Id IN: siteIds]);
            system.debug('Site Ids size:::'+siteIds.size());
            if(mapSiteAss.size() > 0 && siteIds != null) {
                for(Apttus__APTS_Agreement__c agr : newAgrList) {
                    if(mapSiteAss.containsKey(agr.Tops_Site_Id_Sold_To_Id__c) && agr.Sterling_Quote__c == null){
                        agr.CA_Account_Name__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Name;
                        agr.CA_Customer_Name_Lcl__c = '';
                        agr.CA_Sold_To_Id__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).SAP_Site_ID__c;
                        agr.CA_Street__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Street__c;
                        if(mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Street2__c != null)
                            agr.CA_Street__c = agr.CA_Street__c+''+mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Street2__c;
                        if(mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Street3__c != null)
                            agr.CA_Street__c = agr.CA_Street__c+''+mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Street3__c;   
                        agr.CA_City__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).City__c; 
                        agr.CA_State__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).State__c;
                        agr.CA_Zip_Code__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Postal_Code__c;
                        if(mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Country_Picklist__c != null)
                            agr.CA_Country__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Country_Picklist__c.substring(0,2);
                        
                        agr.CA_Reseller_Id__c = agr.CA_Sold_To_Id__c;
                        agr.CA_Reseller_Name__c = agr.CA_Account_Name__c;
                        agr.CA_Reseller_Name_Lcl__c = '';
                        agr.CA_Reseller_Street__c = agr.CA_Street__c;
                        agr.CA_Reseller_City__c = agr.CA_City__c;
                        agr.CA_Reseller_State__c = agr.CA_State__c;
                        agr.CA_Reseller_Country__c = agr.CA_Country__c;
                        agr.CA_Reseller_Zipcode__c = agr.CA_Zip_Code__c;
                        agr.CA_Reseller_Street_Lcl__c = '';
                        agr.CA_Reseller_City_Lcl__c = '';
                        agr.CA_Reseller_State_Lcl__c = '';
                        agr.CA_Reseller_Country_Lcl__c = '';
                        agr.CA_Distributor_Id__c = agr.CA_Sold_To_Id__c;
                        agr.CA_Distributor_Name__c = agr.CA_Account_Name__c;
                        agr.CA_Distributor_Name_Lcl__c = '';
                        agr.CA_Distributor_Street__c = agr.CA_Street__c;
                        agr.CA_Distributor_City__c = agr.CA_City__c;
                        agr.CA_Distributor_State__c = agr.CA_State__c;
                        agr.Distributor_Zipcode__c = agr.CA_Zip_Code__c;
                        agr.CA_Distributor_Country__c = agr.CA_Country__c;
                        agr.CA_Distributor_Street_Lcl__c = '';
                        agr.CA_Distributor_City_Lcl__c = '';
                        agr.CA_Distributor_State_Lcl__c = '';
                        agr.CA_Distributor_Country_Lcl__c = '';
                        agr.CA_End_User_Id__c = agr.CA_Sold_To_Id__c;
                        agr.CA_End_User_Name__c = agr.CA_Account_Name__c;
                        agr.CA_End_User_Name_Lcl__c = '';
                        agr.CA_End_User_Contact_Name__c = '';
                        agr.CA_End_User_Contact_Name_Lcl__c = '';
                        agr.CA_End_User_Street__c = agr.CA_Street__c;
                        agr.CA_End_User_City__c = agr.CA_City__c;
                        agr.CA_End_User_State__c = agr.CA_State__c;
                        agr.CA_End_User_Zipcode__c = agr.CA_Zip_Code__c;
                        agr.CA_End_User_Country__c = agr.CA_Country__c;
                        agr.CA_End_User_Street_Lcl__c = '';
                        agr.CA_End_User_City_Lcl__c = '';
                        agr.CA_End_User_State_Lcl__c = '';
                        agr.CA_End_User_Country_Lcl__c = '';    
                        
                        if(agr.CA_Is_Legacy_Contract__c == Label.CA_Yes || agr.Tops_Site_Id_Sold_To_Id__c != null) {
                            agr.CA_Geo__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Region__c;
                            agr.CA_Operating_Area__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Area__c;
                            agr.CA_Sales_Region__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Territory_Country__c;
                            agr.CA_Sales_Territory__c = mapSiteAss.get(agr.Tops_Site_Id_Sold_To_Id__c).Country__c;
                        }    
                    }
                }
            }
            
            Map<Id,scpq__SciQuote__c> mapIdvsQuote = new Map<Id,scpq__SciQuote__c>();
            if(quoteIds.size() > 0 && quoteIds != null)
                mapIdvsQuote = new Map<Id,scpq__SciQuote__c>([Select Id, Region__c,SalesArea__c, CA_Sales_Area__c, Territory__c, Sub_Territory__c, CA_Contract_End_Date__c, CA_Effective_Date__c, CA_Brief_Deal_Desc__c, CA_Sold_To_ID__c, CA_Customer_Name_Sold_To__c, CA_Customer_Name_Sold_To_Lcl__c, Sold_To_Address__c, Sold_To_Address_Lcl__c, CA_Bill_To_ID__c, CA_Bill_To_Name__c, CA_Billing_Contact_Name__c, CA_Billing_Contact_Name_Lcl__c, CA_Bill_To_Name_Lcl__c, Bill_To_Address__c, Bill_To_Address_Lcl__c, Bill_To_Email_Address__c, Bill_To_Phone__c, CA_Ship_To_ID__c, CA_Ship_To_Name__c, CA_Ship_To_Name_Lcl__c, CA_Shipping_Contact_Name__c, CA_Shipping_Contact_Name_Lcl__c, Ship_To_Address__c, Ship_To_Address_Lcl__c, CA_Reseller_ID__c, CA_Reseller_Name__c, CA_Reseller_Name_Lcl__c, CA_Partner_Address__c, CA_Partner_Address_Lcl__c, CA_Distributor_ID__c, CA_Distributor_Name__c, CA_Distributor_Name_Lcl__c, CA_Distributor_Address__c, CA_Distributor_Address_Lcl__c, CA_End_User_ID__c, CA_End_User_Name__c, CA_End_User_Name_Lcl__c, CA_End_User_Address__c, CA_End_User_Address_Lcl__c, CA_End_User_Contact_Name__c, CA_End_User_Contact_Name_Lcl__c, CA_Service_Provider_ID__c, CA_Service_Provider_Name__c, CA_Technical_Contact_Name__c, CA_Technical_Contact_Name_Lcl__c, Technical_Contact_Phone__c, Technical_Contact_Email_Address__c, Average_Bill_Rate__c, CA_Services_Total__c, Expense_Cost__c, Expenses_Price__c, GSA_Schedule_Used__c, Labor_Cost__c, Labor_Discount__c, Labor_List__c, Labor_PCM__c, Labor_PCM_Percent__c, Labor_Revenue__c, SAP_Contract_Number__c, SAP_Contract_Balance__c, Program_Number__c, Service_Type__c, Services_Quote_Total__c, Transaction_Type__c, Total_Cost__c, Total_Hours__c, Total_PCM__c, Total_PCM_Percent__c, Total_Price__c, scpq__OpportunityId__r.Rpt_Region__c, scpq__OpportunityId__r.Rpt_Area__c, scpq__OpportunityId__r.Rpt_Territory_Country__c, scpq__OpportunityId__r.Rpt_Country__c, CA_SAP_Quote_Number__c, Discount_Due_To_Contractual_Credit_Oblig__c, Contract_Where_The_Credit_Exists__c ,End_User_Contact_Email_Address__c,End_User_Contact_Phone__c ,Company_Number__c from scpq__SciQuote__c where Id IN: quoteIds]); 
            
            if(mapIdvsQuote.size() > 0) {
                for(Apttus__APTS_Agreement__c agr : newAgrList) {
                    
                    if(mapIdvsQuote.containsKey(agr.Sterling_Quote__c)) {
                        scpq__SciQuote__c sq = mapIdvsQuote.get(agr.Sterling_Quote__c);
                        agr.CA_Geo__c = sq.Region__c;
                        agr.CA_Operating_Area__c = sq.SalesArea__c;
                        agr.CA_Sales_Region__c = sq.Territory__c;
                        agr.CA_Sales_Territory__c = sq.Sub_Territory__c;
                        system.debug('Geo::'+agr.CA_Geo__c+'--Operatin Area:::'+agr.CA_Operating_Area__c+'--Sales Region:::'+agr.CA_Sales_Region__c+'--Territory::::'+agr.CA_Sales_Territory__c);
                        agr.CA_Sold_To_Id__c = sq.CA_Sold_To_ID__c;
                        agr.CA_ABN_Number__c= sq.Company_Number__c;
                        agr.CA_Account_Name__c = sq.CA_Customer_Name_Sold_To__c;
                        agr.CA_Customer_Name_Lcl__c = sq.CA_Customer_Name_Sold_To_Lcl__c;
                        agr.CA_Technical_Contact_Name__c = sq.CA_Technical_Contact_Name__c;
                        agr.CA_Technical_Contact_Name_Lcl__c = sq.CA_Technical_Contact_Name_Lcl__c; 
                        agr.CA_Technical_Contact_Phone__c = sq.Technical_Contact_Phone__c;
                        agr.CA_Technical_Contact_Email_Address__c = sq.Technical_Contact_Email_Address__c;
                        agr.CA_Average_Bill_Rate__c = sq.Average_Bill_Rate__c;
                        agr.CA_Desc_of_Deal_Benefits_to_CA_Customer__c = sq.CA_Brief_Deal_Desc__c;
                        //agr.CA_Services_Total__c = sq.CA_Services_Total__c;
                        agr.CA_Expense_Cost__c = sq.Expense_Cost__c;
                        agr.CA_Expenses_Price__c = sq.Expenses_Price__c; 
                        agr.CA_GSA_Schedule_Used__c = sq.GSA_Schedule_Used__c;
                        agr.CA_Labor_Cost__c = sq.Labor_Cost__c;
                        agr.CA_Labor_Discount__c = sq.Labor_Discount__c;
                        agr.CA_Labor_List__c = sq.Labor_List__c;
                        agr.CA_Labor_PCM__c = sq.Labor_PCM__c;
                        agr.CA_Labor_PCM_Percent__c = sq.Labor_PCM_Percent__c;
                        agr.CA_Labor_Revenue__c =sq.Labor_Revenue__c;
                        agr.CA_SAP_Contract_Number__c = sq.SAP_Contract_Number__c;
                        //Added for US312680 by Umang
                        System.debug('SAP Qoute Number is ::::'+sq.CA_SAP_Quote_Number__c);
                        agr.CA_SAP_Quote_Number__c = sq.CA_SAP_Quote_Number__c;
                        agr.CA_IS_DISC_FNC__c = sq.Discount_Due_To_Contractual_Credit_Oblig__c;
                        agr.CA_CREDIT_DISC_DESC__c = sq.Contract_Where_The_Credit_Exists__c;
                        //Ended by Umang
                        agr.CA_SAP_Contract_Value__c = sq.SAP_Contract_Balance__c;
                        agr.CA_Program_Number__c = sq.Program_Number__c;
                        agr.CA_Services_Quote_Type__c = sq.Service_Type__c;
                        //agr.CA_Services_Quote_Total__c = sq.Services_Quote_Total__c;
                        agr.CA_Services_Transaction_Type__c = sq.Transaction_Type__c;
                        agr.CA_Total_Cost__c = sq.Total_Cost__c;
                        agr.CA_Total_Hours__c = sq.Total_Hours__c;
                        agr.CA_Total_PCM__c = sq.Total_PCM__c;
                        agr.CA_Total_PCM_Percent__c = sq.Total_PCM_Percent__c;
                        agr.CA_Total_Quote_Value__c = sq.Total_Price__c;
                        agr.Apttus__Contract_Start_Date__c = sq.CA_Effective_Date__c;
                        agr.Apttus__Contract_End_Date__c = sq.CA_Contract_End_Date__c;
                        
                        List<String> soldToAddress;
                        String streetAdd = '';
                        if(sq.Sold_To_Address__c != null)
                            soldToAddress = sq.Sold_To_Address__c.split(',');
                        
                        system.debug('Sold To Address:::'+soldToAddress);
                        if(soldToAddress != null) {
                            if(soldToAddress.size() >= 5) {
                                //agr.CA_Street__c = soldToAddress[soldToAddress.size()-5];
                                agr.CA_City__c = soldToAddress[soldToAddress.size()-4];
                                agr.CA_State__c = soldToAddress[soldToAddress.size()-3];
                                system.debug('Sold to zipcode:::'+soldToAddress[soldToAddress.size()-2]);
                                agr.CA_Zip_Code__c = soldToAddress[soldToAddress.size()-2];
                                system.debug('Zip code:::'+agr.CA_Zip_Code__c);
                                agr.CA_Country__c = soldToAddress[soldToAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=soldToAddress.size();i++){ 
                                    if(i<soldToAddress.size())                        
                                        streetAdd = ','+soldToAddress[soldToAddress.size()-i]+streetAdd ;
                                    if(i==soldToAddress.size())
                                        streetAdd = soldToAddress[soldToAddress.size()-i]+streetAdd ;                                
                                }
                                system.debug('Streeet....'+streetAdd);
                                agr.CA_Street__c = streetAdd;
                            }
                        } else {
                            agr.CA_Street__c = '';
                            agr.CA_City__c = '';
                            agr.CA_State__c = '';
                            agr.CA_Zip_Code__c = '';
                            agr.CA_Country__c = '';
                        }
                        List<String> soldToAddressLcl;
                        String soldToStreetLcl = '';
                        if(sq.Sold_To_Address_Lcl__c != null)
                            soldToAddressLcl = sq.Sold_To_Address_Lcl__c.split(',');
                        
                        if(soldToAddressLcl != null) {    
                            if(soldToAddressLcl.size() >= 5) {
                                system.debug('sq.scpq__OpportunityId__r.Rpt_Region__c: '+sq.scpq__OpportunityId__r.Rpt_Region__c );
                                system.debug('sq.scpq__OpportunityId__r.Rpt_Area__c: '+sq.scpq__OpportunityId__r.Rpt_Area__c );
                                system.debug('sq.scpq__OpportunityId__r.Rpt_Country__c: '+sq.scpq__OpportunityId__r.Rpt_Country__c);
                                system.debug('sq.scpq__OpportunityId__r.Rpt_Territory_Country__c: '+sq.scpq__OpportunityId__r.Rpt_Territory_Country__c );
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    system.debug(':::Jk');
                                    agr.CA_Country_Lcl__c = soldToAddressLcl[0];
                                    agr.CA_Zip_Code__c = soldToAddressLcl[1];
                                    agr.CA_State_Lcl__c = soldToAddressLcl[2];
                                    agr.CA_City_Lcl__c = soldToAddressLcl[3];
                                    //agr.CA_Street_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-1];
                                    for(Integer i=4; i<=soldToAddressLcl.size();i++){ 
                                        if(i<soldToAddressLcl.size())                        
                                            soldToStreetLcl = soldToStreetLcl+' '+soldToAddressLcl[i];
                                    }
                                    agr.CA_Street_Lcl__c = soldToStreetLcl;
                                } else {
                                    //agr.CA_Street_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-5];
                                    agr.CA_City_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-4];
                                    agr.CA_State_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-3];
                                    agr.CA_Zip_Code__c = soldToAddressLcl[soldToAddressLcl.size()-2];
                                    agr.CA_Country_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=soldToAddressLcl.size();i++){ 
                                        if(i<soldToAddressLcl.size())                        
                                            soldToStreetLcl = ','+soldToAddressLcl[soldToAddressLcl.size()-i]+soldToStreetLcl ;
                                        if(i==soldToAddressLcl.size())
                                            soldToStreetLcl = soldToAddressLcl[soldToAddressLcl.size()-i]+soldToStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+soldToStreetLcl );
                                    agr.CA_Street_Lcl__c = soldToStreetLcl ;
                                }
                            }  
                        } else {
                            agr.CA_Street_Lcl__c = '';
                            agr.CA_City_Lcl__c = '';
                            agr.CA_State_Lcl__c = '';
                            agr.CA_Country_Lcl__c = '';
                        } 
                        
                        agr.CA_Bill_To_Id__c = sq.CA_Bill_To_ID__c;
                        agr.CA_Billing_Contact_Name__c = sq.CA_Billing_Contact_Name__c;
                        agr.CA_Billing_Contact_Name_Lcl__c = sq.CA_Billing_Contact_Name_Lcl__c;
                        agr.CA_Bill_To_Name__c = sq.CA_Bill_To_Name__c;
                        agr.CA_Bill_To_Name_Lcl__c = sq.CA_Bill_To_Name_Lcl__c;
                        agr.CA_Bill_To_Email__c = sq.Bill_To_Email_Address__c;
                        agr.CA_Bill_To_Phone__c = sq.Bill_To_Phone__c;
                        List<String> billToAddress;
                        string billToStreet = ''; 
                        if(sq.Bill_To_Address__c != null)
                            billToAddress = sq.Bill_To_Address__c.split(',');
                        
                        if(billToAddress != null) {      
                            if(billToAddress.size() >= 5) {
                                //agr.CA_Bill_To_Street__c = billToAddress[billToAddress.size()-5];
                                agr.Bill_To_City__c = billToAddress[billToAddress.size()-4];
                                agr.CA_Bill_To_State__c = billToAddress[billToAddress.size()-3];
                                agr.Bill_To_Zipcode__c = billToAddress[billToAddress.size()-2];
                                agr.Bill_To_Country__c = billToAddress[billToAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=billToAddress.size();i++){ 
                                    if(i<billToAddress.size())                        
                                        billToStreet = ','+billToAddress[billToAddress.size()-i]+billToStreet ;
                                    if(i==billToAddress.size())
                                        billToStreet = billToAddress[billToAddress.size()-i]+billToStreet ;                                
                                }
                                system.debug('Streeet....'+billToStreet );
                                agr.CA_Bill_To_Street__c = billToStreet ;
                            }
                        } else {
                            agr.CA_Bill_To_Street__c = '';
                            agr.Bill_To_City__c = '';
                            agr.CA_Bill_To_State__c = '';
                            agr.Bill_To_Zipcode__c = '';
                            agr.Bill_To_Country__c = '';
                        }
                        
                        List<String> billToAddressLcl;
                        String billStreetAddLcl ='';
                        if(sq.Bill_To_Address_Lcl__c != null)
                            billToAddressLcl = sq.Bill_To_Address_Lcl__c.split(',');
                        
                        if(billToAddressLcl != null) {     
                            if(billToAddressLcl.size() >= 5) {
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    agr.CA_Bill_To_Country_Lcl__c = billToAddressLcl[0];
                                    agr.Bill_To_Zipcode__c = billToAddressLcl[1];
                                    agr.CA_Bill_To_State_Lcl__c = billToAddressLcl[2];
                                    agr.Bill_To_City_Lcl__c = billToAddressLcl[3];
                                    //agr.Bill_To_Street_Lcl__c = billToAddressLcl[billToAddressLcl.size()-1];
                                    for(Integer i=4; i<=billToAddressLcl.size();i++){ 
                                        if(i<billToAddressLcl.size())                        
                                            billStreetAddLcl = billStreetAddLcl+' '+billToAddressLcl[i];
                                    }
                                    agr.Bill_To_Street_Lcl__c = billStreetAddLcl;
                                } else {
                                    //agr.Bill_To_Street_Lcl__c = billToAddressLcl[billToAddressLcl.size()-5];
                                    agr.Bill_To_City_Lcl__c = billToAddressLcl[billToAddressLcl.size()-4];
                                    agr.CA_Bill_To_State_Lcl__c = billToAddressLcl[billToAddressLcl.size()-3];
                                    agr.Bill_To_Zipcode__c = billToAddressLcl[billToAddressLcl.size()-2];
                                    agr.CA_Bill_To_Country_Lcl__c = billToAddressLcl[billToAddressLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=billToAddressLcl.size();i++){ 
                                        if(i<billToAddressLcl.size())                        
                                            billStreetAddLcl = ','+billToAddressLcl[billToAddressLcl.size()-i]+billStreetAddLcl ;
                                        if(i==billToAddressLcl.size())
                                            billStreetAddLcl = billToAddressLcl[billToAddressLcl.size()-i]+billStreetAddLcl ;                                
                                    }
                                    system.debug('Streeet....'+billStreetAddLcl );
                                    agr.Bill_To_Street_Lcl__c = billStreetAddLcl ;
                                }
                            } 
                        } else {
                            agr.Bill_To_Street_Lcl__c = '';
                            agr.Bill_To_City_Lcl__c = '';
                            agr.CA_Bill_To_State_Lcl__c = '';
                            agr.CA_Bill_To_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Ship_To_Id__c = sq.CA_Ship_To_ID__c;
                        agr.CA_Ship_To_Name__c = sq.CA_Ship_To_Name__c;
                        agr.CA_Ship_To_Name_Lcl__c = sq.CA_Ship_To_Name_Lcl__c;
                        agr.CA_Shipping_Contact_Name__c = sq.CA_Shipping_Contact_Name__c;
                        agr.CA_Shipping_Contact_Name_Lcl__c = sq.CA_Shipping_Contact_Name_Lcl__c;
                        
                        List<String> shipToAddress;
                        String shiptoStreet = '';
                        if(sq.Ship_To_Address__c != null)
                            shipToAddress = sq.Ship_To_Address__c.split(',');
                        
                        if(shipToAddress != null) { 
                            if(shipToAddress.size() >= 5) {
                                //agr.CA_Ship_To_Street__c = shipToAddress[shipToAddress.size()-5];
                                agr.CA_Ship_To_City__c = shipToAddress[shipToAddress.size()-4];
                                agr.Ship_To_State__c = shipToAddress[shipToAddress.size()-3];
                                agr.CA_Ship_To_Zipcode__c = shipToAddress[shipToAddress.size()-2]; 
                                agr.Ship_To_Country__c = shipToAddress[shipToAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=shipToAddress.size();i++){ 
                                    if(i<shipToAddress.size())                        
                                        shiptoStreet = ','+shipToAddress[shipToAddress.size()-i]+shiptoStreet ;
                                    if(i==shipToAddress.size())
                                        shiptoStreet = shipToAddress[shipToAddress.size()-i]+shiptoStreet ;                                
                                }
                                system.debug('Streeet....'+shiptoStreet );
                                agr.CA_Ship_To_Street__c = shiptoStreet ;
                                
                            }  
                        } else {
                            agr.CA_Ship_To_Street__c = '';
                            agr.CA_Ship_To_City__c = '';
                            agr.Ship_To_State__c = '';
                            agr.CA_Ship_To_Zipcode__c = ''; 
                            agr.Ship_To_Country__c = '';
                        }
                        
                        List<String> shipToAddressLcl;
                        String shipTostreetLcl = '';
                        if(sq.Ship_To_Address_Lcl__c != null)
                            shipToAddressLcl = sq.Ship_To_Address_Lcl__c.split(',');
                        
                        if(shipToAddressLcl != null) {  
                            if(shipToAddressLcl.size() >= 5) {
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    agr.CA_Ship_To_Country_Lcl__c = shipToAddressLcl[0];
                                    agr.CA_Ship_To_Zipcode__c = shipToAddressLcl[1];
                                    agr.Ship_To_State_Lcl__c = shipToAddressLcl[2];
                                    agr.Ship_To_City_Lcl__c = shipToAddressLcl[3];
                                    
                                    for(Integer i=4; i<=shipToAddressLcl.size();i++){ 
                                        if(i<shipToAddressLcl.size())                        
                                            shipTostreetLcl = shipTostreetLcl+' '+shipToAddressLcl[i];
                                    }
                                    agr.CA_Ship_To_Street_Lcl__c = shipTostreetLcl;
                                } else {
                                    //agr.CA_Ship_To_Street_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-5];
                                    agr.Ship_To_City_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-4];
                                    agr.Ship_To_State_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-3];
                                    agr.CA_Ship_To_Zipcode__c = shipToAddressLcl[shipToAddressLcl.size()-2];
                                    agr.CA_Ship_To_Country_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=shipToAddressLcl.size();i++){ 
                                        if(i<shipToAddressLcl.size())                        
                                            shipTostreetLcl = ','+shipToAddressLcl[shipToAddressLcl.size()-i]+shipTostreetLcl ;
                                        if(i==shipToAddressLcl.size())
                                            shipTostreetLcl = shipToAddressLcl[shipToAddressLcl.size()-i]+shipTostreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+shipTostreetLcl );
                                    agr.CA_Ship_To_Street_Lcl__c = shipTostreetLcl ;
                                }
                            }
                        } else {
                            agr.CA_Ship_To_Street_Lcl__c = '';
                            agr.Ship_To_City_Lcl__c = '';
                            agr.Ship_To_State_Lcl__c = '';
                            agr.CA_Ship_To_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Reseller_Id__c = sq.CA_Reseller_ID__c;
                        agr.CA_Reseller_Name__c = sq.CA_Reseller_Name__c;
                        agr.CA_Reseller_Name_Lcl__c = sq.CA_Reseller_Name_Lcl__c;
                        
                        List<String> resellerAdd;
                        String resellerstreet = '';
                        if(sq.CA_Partner_Address__c != null)
                            resellerAdd = sq.CA_Partner_Address__c.split(',');
                        
                        if(resellerAdd != null) {  
                            if(resellerAdd.size() >= 5) {
                                //agr.CA_Reseller_Street__c = resellerAdd[resellerAdd.size()-5];
                                agr.CA_Reseller_City__c = resellerAdd[resellerAdd.size()-4];
                                agr.CA_Reseller_State__c = resellerAdd[resellerAdd.size()-3];
                                agr.CA_Reseller_Zipcode__c = resellerAdd[resellerAdd.size()-2];
                                agr.CA_Reseller_Country__c = resellerAdd[resellerAdd.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=resellerAdd.size();i++){ 
                                    if(i<resellerAdd.size())                        
                                        resellerstreet = ','+resellerAdd[resellerAdd.size()-i]+resellerstreet ;
                                    if(i==resellerAdd.size())
                                        resellerstreet = resellerAdd[resellerAdd.size()-i]+resellerstreet ;                                
                                }
                                system.debug('Streeet....'+resellerstreet );
                                agr.CA_Reseller_Street__c = resellerstreet ;
                            }
                        } else {
                            agr.CA_Reseller_Street__c = '';
                            agr.CA_Reseller_City__c = '';
                            agr.CA_Reseller_State__c = '';
                            agr.CA_Reseller_Zipcode__c = '';
                            agr.CA_Reseller_Country__c = '';
                        }
                        
                        List<String> resellerAddLcl;
                        String resellerStreetLcl = '';
                        if(sq.CA_Partner_Address_Lcl__c != null)
                            resellerAddLcl = sq.CA_Partner_Address_Lcl__c.split(',');
                        
                        if(resellerAddLcl != null) {  
                            if(resellerAddLcl.size() >= 5) {
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    agr.CA_Reseller_Country_Lcl__c = resellerAddLcl[0];
                                    agr.CA_Reseller_Zipcode__c = resellerAddLcl[1];
                                    agr.CA_Reseller_State_Lcl__c = resellerAddLcl[2];
                                    agr.CA_Reseller_City_Lcl__c = resellerAddLcl[3];
                                    //agr.CA_Reseller_Street_Lcl__c = resellerAddLcl[resellerAddLcl.size()-1];
                                    for(Integer i=4; i<=resellerAddLcl.size();i++){ 
                                        if(i<resellerAddLcl.size())                        
                                            resellerStreetLcl = resellerStreetLcl+' '+resellerAddLcl[i];
                                    }
                                    agr.CA_Reseller_Street_Lcl__c = resellerStreetLcl;
                                } else {
                                    //agr.CA_Reseller_Street_Lcl__c = resellerAddLcl[resellerAddLcl.size()-5];
                                    agr.CA_Reseller_City_Lcl__c = resellerAddLcl[resellerAddLcl.size()-4];
                                    agr.CA_Reseller_State_Lcl__c = resellerAddLcl[resellerAddLcl.size()-3];
                                    agr.CA_Reseller_Zipcode__c = resellerAddLcl[resellerAddLcl.size()-2];
                                    agr.CA_Reseller_Country_Lcl__c = resellerAddLcl[resellerAddLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=resellerAddLcl.size();i++){ 
                                        if(i<resellerAddLcl.size())                        
                                            resellerStreetLcl = ','+resellerAddLcl[resellerAddLcl.size()-i]+resellerStreetLcl ;
                                        if(i==resellerAddLcl.size())
                                            resellerStreetLcl = resellerAddLcl[resellerAddLcl.size()-i]+resellerStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+resellerStreetLcl );
                                    agr.CA_Reseller_Street_Lcl__c = resellerStreetLcl ;
                                }
                            }
                        } else {
                            agr.CA_Reseller_Street_Lcl__c = '';
                            agr.CA_Reseller_City_Lcl__c = '';
                            agr.CA_Reseller_State_Lcl__c = '';
                            agr.CA_Reseller_Country_Lcl__c = '';
                        }
                        agr.CA_Distributor_Id__c = sq.CA_Distributor_ID__c;
                        agr.CA_Distributor_Name__c = sq.CA_Distributor_Name__c;
                        agr.CA_Distributor_Name_Lcl__c = sq.CA_Distributor_Name_Lcl__c;
                        
                        List<String> distAddress;
                        String distStreet = '';
                        if(sq.CA_Distributor_Address__c != null) 
                            distAddress = sq.CA_Distributor_Address__c.split(',');
                        
                        if(distAddress != null) {  
                            if(distAddress.size() >= 5) {
                                //agr.CA_Distributor_Street__c = distAddress[distAddress.size()-5];
                                agr.CA_Distributor_City__c = distAddress[distAddress.size()-4];
                                agr.CA_Distributor_State__c = distAddress[distAddress.size()-3];
                                agr.Distributor_Zipcode__c = distAddress[distAddress.size()-2];
                                agr.CA_Distributor_Country__c = distAddress[distAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=distAddress.size();i++){ 
                                    if(i<distAddress.size())                        
                                        distStreet = ','+distAddress[distAddress.size()-i]+distStreet ;
                                    if(i==distAddress.size())
                                        distStreet = distAddress[distAddress.size()-i]+distStreet ;                                
                                }
                                system.debug('Streeet....'+distStreet );
                                agr.CA_Distributor_Street__c = distStreet ;
                            } 
                        } else {
                            agr.CA_Distributor_Street__c = '';
                            agr.CA_Distributor_City__c = '';
                            agr.CA_Distributor_State__c = '';
                            agr.Distributor_Zipcode__c = '';
                            agr.CA_Distributor_Country__c = '';
                        }  
                        
                        List<String> distAddressLcl;
                        String distStreetLcl ='';
                        if(sq.CA_Distributor_Address_Lcl__c != null) 
                            distAddressLcl = sq.CA_Distributor_Address_Lcl__c.split(',');
                        
                        if(distAddressLcl != null) {  
                            if(distAddressLcl.size() >= 5) {
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    agr.CA_Distributor_Country_Lcl__c = distAddress[0];
                                    agr.Distributor_Zipcode__c = distAddress[1];
                                    agr.CA_Distributor_State_Lcl__c = distAddress[2];
                                    agr.CA_Distributor_City_Lcl__c = distAddress[3];
                                    //agr.CA_Distributor_Street_Lcl__c = distAddress[distAddress.size()-1];
                                    
                                    for(Integer i=4; i<=distAddressLcl.size();i++){ 
                                        if(i<distAddressLcl.size())                        
                                            distStreetLcl = distStreetLcl+' '+distAddressLcl[i];
                                    }
                                    agr.CA_Distributor_Street_Lcl__c= distStreetLcl;
                                } else {
                                    //agr.CA_Distributor_Street_Lcl__c = distAddress[distAddress.size()-5];
                                    agr.CA_Distributor_City_Lcl__c = distAddress[distAddress.size()-4];
                                    agr.CA_Distributor_State_Lcl__c = distAddress[distAddress.size()-3];
                                    agr.Distributor_Zipcode__c = distAddress[distAddress.size()-1];
                                    agr.CA_Distributor_Country_Lcl__c = distAddress[distAddress.size()-2];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=distAddressLcl.size();i++){ 
                                        if(i<distAddressLcl.size())                        
                                            distStreetLcl = ','+distAddressLcl[distAddressLcl.size()-i]+distStreetLcl ;
                                        if(i==distAddressLcl.size())
                                            distStreetLcl = distAddressLcl[distAddressLcl.size()-i]+distStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+distStreetLcl );
                                    agr.CA_Distributor_Street_Lcl__c = distStreetLcl ;
                                }
                            }  
                        } else {
                            agr.CA_Distributor_Street_Lcl__c = '';
                            agr.CA_Distributor_City_Lcl__c = '';
                            agr.CA_Distributor_State_Lcl__c = '';
                            agr.CA_Distributor_Country_Lcl__c = '';
                        }
                        
                        agr.CA_End_User_Id__c = sq.CA_End_User_ID__c;
                        agr.CA_End_User_Name__c = sq.CA_End_User_Name__c;
                        agr.CA_End_User_Name_Lcl__c = sq.CA_End_User_Name_Lcl__c;
                        agr.CA_End_User_Contact_Name__c = sq.CA_End_User_Contact_Name__c;
                        agr.CA_End_User_Contact_Name_Lcl__c = sq.CA_End_User_Contact_Name_Lcl__c;
                        //US335023 added by Jagan
                        agr.EndUserEmailAddress__c=sq.End_User_Contact_Email_Address__c;
                        agr.EndUserContactPhone__c=sq.End_User_Contact_Phone__c;
                        //US335023 change ends
                        
                        List<String> endUserAddress;
                        string enduserStreet ='';
                        if(sq.CA_End_User_Address__c != null)
                            endUserAddress = sq.CA_End_User_Address__c.split(',');
                        
                        if(endUserAddress != null) {     
                            if(endUserAddress.size() >= 5){ 
                                //agr.CA_End_User_Street__c = endUserAddress[endUserAddress.size()-5];
                                agr.CA_End_User_City__c = endUserAddress[endUserAddress.size()-4];
                                agr.CA_End_User_State__c = endUserAddress[endUserAddress.size()-3];
                                agr.CA_End_User_Zipcode__c = endUserAddress[endUserAddress.size()-2];
                                agr.CA_End_User_Country__c = endUserAddress[endUserAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=endUserAddress .size();i++){ 
                                    if(i<endUserAddress .size())                        
                                        enduserStreet = ','+endUserAddress [endUserAddress .size()-i]+enduserStreet ;
                                    if(i==endUserAddress .size())
                                        enduserStreet = endUserAddress [endUserAddress .size()-i]+enduserStreet ;                                
                                }
                                system.debug('Streeet....'+enduserStreet );
                                agr.CA_End_User_Street__c = enduserStreet ;
                            }
                        } else {
                            agr.CA_End_User_Street__c = '';
                            agr.CA_End_User_City__c = '';
                            agr.CA_End_User_State__c = '';
                            agr.CA_End_User_Zipcode__c = '';
                            agr.CA_End_User_Country__c = '';
                        }
                        
                        List<String> endUserAddressLcl;
                        String enduserStreetLcl = '';
                        if(sq.CA_End_User_Address_Lcl__c != null)
                            endUserAddressLcl = sq.CA_End_User_Address_Lcl__c.split(',');
                        
                        if(endUserAddressLcl != null) {      
                            if(endUserAddressLcl.size() >= 5){
                                if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                    agr.CA_End_User_Country_Lcl__c = endUserAddressLcl[0];
                                    agr.CA_End_User_Zipcode__c = endUserAddressLcl[1];
                                    agr.CA_End_User_State_Lcl__c = endUserAddressLcl[2];
                                    agr.CA_End_User_City_Lcl__c = endUserAddressLcl[3];
                                    //agr.CA_End_User_Street_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-1];
                                    for(Integer i=4; i<=endUserAddressLcl.size();i++){ 
                                        if(i<endUserAddressLcl.size())                        
                                            enduserStreetLcl = enduserStreetLcl+' '+endUserAddressLcl[i];
                                    }
                                    agr.CA_End_User_Street_Lcl__c= enduserStreetLcl;
                                    
                                } else {
                                    //agr.CA_End_User_Street_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-5];
                                    agr.CA_End_User_City_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-4];
                                    agr.CA_End_User_State_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-3];
                                    agr.CA_End_User_Zipcode__c = endUserAddressLcl[endUserAddressLcl.size()-2];
                                    agr.CA_End_User_Country_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=endUserAddressLcl.size();i++){ 
                                        if(i<endUserAddressLcl.size())                        
                                            enduserStreetLcl = ','+endUserAddressLcl[endUserAddressLcl.size()-i]+enduserStreetLcl ;
                                        if(i==endUserAddressLcl.size())
                                            enduserStreetLcl = endUserAddressLcl[endUserAddressLcl.size()-i]+enduserStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+enduserStreetLcl );
                                    agr.CA_End_User_Street__c = enduserStreetLcl ;
                                }
                            } 
                        } else {
                            agr.CA_End_User_Street_Lcl__c = '';
                            agr.CA_End_User_City_Lcl__c = '';
                            agr.CA_End_User_State_Lcl__c = '';
                            agr.CA_End_User_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Outsourcer_Id__c = sq.CA_Service_Provider_ID__c;
                        agr.CA_Outsourcer_Name__c = sq.CA_Service_Provider_Name__c;
                         
                        
                    }
                }
            }  
            //added for tensor
            system.debug('Testing tensor quote update outside: SfQuoteIds' + SFquoteIds );
            Map<Id,SBQQ__Quote__c> mapIdvsSFQuote = new map<Id,SBQQ__Quote__c>();
            if(SFquoteIds != null && SFquoteIds.size() >0){
                 system.debug('Testing tensor quote update outside 1');
               mapIdvsSFQuote=new Map<ID,SBQQ__Quote__c>([Select Id,Rpt_Region__c,Rpt_Territory_Country__c,Rpt_Country__c,Company_Registration_Number__c,End_Date_form__c,BillTo_BPID__c,BillTo_Name_Intl__c,ShipTo_Name__c,ShipTo_Name_Intl__c,
                                                           ShipTo_Street__c,Sold_To_Address_Lcl__c,SoldTo_Name__c,SoldTo_Name_Intl__c, SoldTo_BPID__c,BillTo_City_Intl__c,BillTo_Country__c,BillTo_State__c,BillTo_State_Intl__c,
                                                           BillTo_Street_Intl__c,BillTo_Street2_Intl__c,BillTo_PostalCode__c,ShipTo_City__c,ShipTo_City_Intl__c,ShipTo_Country__c,
                                                           ShipTo_State__c,ShipTo_State_Intl__c,ShipTo_Street2__c,ShipTo_Street_Intl__c,ShipTo_Street2_Intl__c,
                                                           ShipTo_PostalCode__c,SoldTo_Street__c,SoldTo_Street2__c,SoldTo_Street_Intl__c,SoldTo_Street2_Intl__c,SoldTo_City__c,SoldTo_City_Intl__c,
                                                           SoldTo_State__c,SoldTo_State_Intl__c,SoldTo_Country__c,SoldTo_PostalCode__c,BillTo_Street__c,BillTo_Street2__c,BillTo_City__c ,CA_Customer_Name_Sold_To_Lcl__c,TechnicalContact_FirstName__c , TechnicalContact_LastName__c,
                                                           TechnicalContact_IntlFName__c ,  TechnicalContact_IntlLName__c,TechnicalContact_Phone__c,TechnicalContact_Email__c,Deal_Description__c,SBQQ__StartDate__c,SBQQ__EndDate__c,BillingContact_ID__c,BillingContact_FirstName__c ,
                                                           BillingContact_LastName__c,BillingContact_IntlFName__c , BillingContact_IntlLName__c,BillTo_Name__c,CA_Bill_To_Name_Lcl__c,BillingContact_Email__c,BillingContact_Phone__c,SBQQ__BillingStreet__c,  SBQQ__BillingCity__c, SBQQ__BillingState__c,
                                                           SBQQ__BillingPostalCode__c,  SBQQ__BillingCountry__c,Bill_To_Address_Lcl__c,ShipTo_BPID__c,SBQQ__ShippingName__c,CA_Ship_To_Name_Lcl__c,ShippingContact_FirstName__c ,ShippingContact_LastName__c,ShippingContact_IntlFName__c , ShippingContact_IntlLName__c,
                                                           SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c,  SBQQ__ShippingState__c, SBQQ__ShippingPostalCode__c,  SBQQ__ShippingCountry__c,Ship_To_Address_Lcl__c,Reseller_City__c,Reseller_City_Intl__c,Reseller_Country__c,Reseller_BPID__c,Reseller_Name__c,Reseller_Name_Intl__c,Reseller_Postal_Code__c,Reseller_State__c,Reseller_State_Intl__c,Reseller_Street__c,Reseller_Street_Intl__c,
                                                           EndUser_Contact_Email__c,EndUser_Contact_First_Name__c,EndUser_Contact_Last_Name__c,EndUser_Contact_ID__c,EndUser_Contact_Intl_First_Name__c,EndUser_Contact_Intl_Last_Name__c,EndUser_Contact_Phone__c,EndUser_Country__c,EndUser_City__c,
                                                           EndUser_City_Intl__c,EndUser_BPID__c,EndUser_Name__c,EndUser_Name_Intl__c,EndUser_Postal_Code__c,EndUser_State__c,EndUser_State_Intl__c,EndUser_Street__c,EndUser_Street_Intl__c from SBQQ__Quote__c where Id IN: SFquoteIds]);
                                  system.debug('Testing tensor quote update outside 1 mapIdvsSFQuote '+ mapIdvsSFQuote );
                if(mapIdvsSFQuote.size()>0){
                     system.debug('Testing tensor quote update outside 2');
                    for(Apttus__APTS_Agreement__c agr : newAgrList) {
                         system.debug('Testing tensor quote update outside 3');
                        if(mapIdvsSFQuote.containsKey(agr.SF_Quote__c)) {
                             system.debug('Testing tensor quote update outside 4');
                        SBQQ__Quote__c sbquote = mapIdvsSFQuote.get(agr.SF_Quote__c);
                             agr.CA_Geo__c=sbquote.Rpt_Region__c;
                            agr.CA_Sales_Region__c=sbquote.Rpt_Territory_Country__c;
                            agr.CA_Sales_Territory__c=sbquote.Rpt_Country__c;
                            agr.CA_Sold_To_Id__c = sbquote.SoldTo_BPID__c;
                            agr.CA_Account_Name__c=sbquote.SoldTo_Name__c;
                            agr.CA_Customer_Name_Lcl__c =sbquote.SoldTo_Name_Intl__c;
                            agr.CA_ABN_Number__c=sbquote.Company_Registration_Number__c;
                            agr.CA_Technical_Contact_Name__c=String.isNotBlank(sbquote.TechnicalContact_FirstName__c) &&
                                String.isNotBlank(sbquote.TechnicalContact_LastName__c)?sbquote.TechnicalContact_FirstName__c+' '+
                                sbquote.TechnicalContact_LastName__c:String.isNotBlank(sbquote.TechnicalContact_LastName__c)?
                                sbquote.TechnicalContact_LastName__c:(String.isNotBlank(sbquote.TechnicalContact_LastName__c)?sbquote.TechnicalContact_LastName__c:'');
                           // if(sbquote.TechnicalContact_FirstName__c!=null && sbquote.TechnicalContact_LastName__c!=null)
                            //agr.CA_Technical_Contact_Name__c =sbquote.TechnicalContact_FirstName__c + sbquote.TechnicalContact_LastName__c;
                            agr.CA_Technical_Contact_Name_Lcl__c=String.isNotBlank(sbquote.TechnicalContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.TechnicalContact_IntlLName__c)?sbquote.TechnicalContact_IntlFName__c+' '+
                                sbquote.TechnicalContact_IntlLName__c:String.isNotBlank(sbquote.TechnicalContact_IntlFName__c)?
                                sbquote.TechnicalContact_IntlFName__c:(String.isNotBlank(sbquote.TechnicalContact_IntlLName__c)?sbquote.TechnicalContact_IntlLName__c:'');
                            //        if(sbquote.TechnicalContact_IntlFName__c!=null && sbquote.TechnicalContact_IntlLName__c!=null)
                           // agr.CA_Technical_Contact_Name_Lcl__c =sbquote.TechnicalContact_IntlFName__c + sbquote.TechnicalContact_IntlLName__c;
                            agr.CA_Technical_Contact_Phone__c=sbquote.TechnicalContact_Phone__c;
                            system.debug('minus debug');
                            agr.CA_Technical_Contact_Email_Address__c=sbquote.TechnicalContact_Email__c;
                            agr.CA_Desc_of_Deal_Benefits_to_CA_Customer__c=sbquote.Deal_Description__c;
                            agr.Apttus__Contract_Start_Date__c=sbquote.SBQQ__StartDate__c;
                            agr.Apttus__Contract_End_Date__c=sbquote.End_Date_form__c;
                        //  agr.CA_Street__c =sbquote.Rpt_Region__c;
                            agr.CA_Street_Lcl__c =sbquote.Sold_To_Address_Lcl__c;
                            agr.CA_Bill_To_Id__c=sbquote.BillTo_BPID__c;
                            agr.CA_Billing_Contact_Name__c=String.isNotBlank(sbquote.BillingContact_FirstName__c) &&
                                String.isNotBlank(sbquote.BillingContact_LastName__c)?sbquote.BillingContact_FirstName__c+' '+
                                sbquote.BillingContact_LastName__c:String.isNotBlank(sbquote.BillingContact_FirstName__c)?
                                sbquote.BillingContact_FirstName__c:(String.isNotBlank(sbquote.BillingContact_LastName__c)?sbquote.BillingContact_LastName__c:'');
                          //  if(sbquote.BillingContact_FirstName__c!=null && sbquote.BillingContact_LastName__c!=null)
                           // agr.CA_Billing_Contact_Name__c =sbquote.BillingContact_FirstName__c + sbquote.BillingContact_LastName__c;
                           agr.CA_Billing_Contact_Name_Lcl__c=String.isNotBlank(sbquote.BillingContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.BillingContact_IntlLName__c)?sbquote.BillingContact_IntlFName__c+' '+
                                sbquote.BillingContact_IntlLName__c:String.isNotBlank(sbquote.BillingContact_IntlFName__c)?
                                sbquote.BillingContact_IntlFName__c:(String.isNotBlank(sbquote.BillingContact_IntlLName__c)?sbquote.BillingContact_IntlLName__c:'');
                          //  if(sbquote.BillingContact_FirstName__c!=null && sbquote.BillingContact_LastName__c!=null)
                                  //  if(sbquote.BillingContact_IntlFName__c!=null && sbquote.BillingContact_IntlLName__c!=null)
                            //agr.CA_Billing_Contact_Name_Lcl__c =sbquote.BillingContact_IntlFName__c + sbquote.BillingContact_IntlLName__c;
                            agr.CA_Bill_To_Name__c =sbquote.BillTo_Name__c;
                            agr.CA_Bill_To_Name_Lcl__c =sbquote.BillTo_Name_Intl__c;
                            agr.CA_Bill_To_Email__c=sbquote.BillingContact_Email__c;
                            agr.CA_Bill_To_Phone__c =sbquote.BillingContact_Phone__c;
                      //    agr.CA_Bill_To_Street__c =sbquote.Rpt_Region__c;
                            agr.Bill_To_Street_Lcl__c=sbquote.Bill_To_Address_Lcl__c;
                            agr.CA_Ship_To_Id__c =sbquote.ShipTo_BPID__c;
                            system.debug('zero debug');
                            agr.CA_Ship_To_Name__c =sbquote.ShipTo_Name__c;
                            agr.CA_Ship_To_Name_Lcl__c =sbquote.ShipTo_Name_Intl__c;
                            agr.CA_Shipping_Contact_Name__c=String.isNotBlank(sbquote.ShippingContact_FirstName__c) &&
                                String.isNotBlank(sbquote.ShippingContact_LastName__c)?sbquote.ShippingContact_FirstName__c+' '+
                                sbquote.ShippingContact_LastName__c:String.isNotBlank(sbquote.ShippingContact_FirstName__c)?
                                sbquote.ShippingContact_FirstName__c:(String.isNotBlank(sbquote.ShippingContact_LastName__c)?sbquote.ShippingContact_LastName__c:'');
                            //if(sbquote.ShippingContact_FirstName__c!=null && sbquote.ShippingContact_LastName__c!=null)
                            //agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_FirstName__c +' ' + sbquote.ShippingContact_LastName__c;
                            
                                  //  else if(sbquote.ShippingContact_FirstName__c!=null)
                              //agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_FirstName__c;
                            //else if(sbquote.ShippingContact_LastName__c!=null)
                              // agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_LastName__c; 
                            agr.CA_Shipping_Contact_Name_Lcl__c=String.isNotBlank(sbquote.ShippingContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.ShippingContact_IntlLName__c)?sbquote.ShippingContact_IntlFName__c+' '+
                                sbquote.ShippingContact_IntlLName__c:String.isNotBlank(sbquote.ShippingContact_IntlFName__c)?
                                sbquote.ShippingContact_IntlFName__c:(String.isNotBlank(sbquote.ShippingContact_IntlLName__c)?sbquote.ShippingContact_IntlLName__c:'');
                         //if(sbquote.ShippingContact_IntlFName__c !=null && sbquote.ShippingContact_IntlLName__c!=null)
                          //  agr.CA_Shipping_Contact_Name_Lcl__c =sbquote.ShippingContact_IntlFName__c +' ' + sbquote.ShippingContact_IntlLName__c;
                            
                      //      agr.CA_Ship_To_Street__c =sbquote.Rpt_Region__c; 
                            agr.CA_Ship_To_Street_Lcl__c =sbquote.Ship_To_Address_Lcl__c;
                             agr.Bill_To_City__c    = sbquote.BillTo_City__c;
				 agr.Bill_To_City_Lcl__c  = sbquote.BillTo_City_Intl__c;
				 agr.Bill_To_Country__c  = sbquote.BillTo_Country__c;
				 agr.CA_Bill_To_State__c  = sbquote.BillTo_State__c;
				 agr.CA_Bill_To_State_Lcl__c  = sbquote.BillTo_State_Intl__c;
                            system.debug('first debug');
                        //if(SBQuote.BillTo_Street__c ! =null && SBQuote.BillTo_Street2__c ! =null)
                  agr.CA_Bill_To_Street__c=String.isNotBlank(sbquote.BillTo_Street__c) &&
                                String.isNotBlank(sbquote.BillTo_Street2__c)?sbquote.BillTo_Street__c+' '+
                                sbquote.BillTo_Street2__c:String.isNotBlank(sbquote.BillTo_Street__c)?
                                sbquote.BillTo_Street__c:(String.isNotBlank(sbquote.BillTo_Street2__c)?sbquote.BillTo_Street2__c:'');
				//if(sbquote.BillTo_Street__c!=null && sbquote.BillTo_Street2__c!=null)
                  //      agr.CA_Bill_To_Street__c  = sbquote.BillTo_Street__c+sbquote.BillTo_Street2__c;
                    //        else if(sbquote.BillTo_Street__c!=null)
                      //        agr.CA_Bill_To_Street__c =  sbquote.BillTo_Street__c;
                        //     else if(sbquote.BillTo_Street2__c!=null)
                          //  agr.CA_Bill_To_Street__c =  sbquote.BillTo_Street2__c;
                          agr.Bill_To_Street_Lcl__c=String.isNotBlank(sbquote.BillTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.BillTo_Street2_Intl__c)?sbquote.BillTo_Street_Intl__c+' '+
                                sbquote.BillTo_Street2__c:String.isNotBlank(sbquote.BillTo_Street_Intl__c)?
                                sbquote.BillTo_Street_Intl__c:(String.isNotBlank(sbquote.BillTo_Street2_Intl__c)?sbquote.BillTo_Street2_Intl__c:'');
                       // if(sbquote.BillTo_Street_Intl__c !=null && sbquote.BillTo_Street2_Intl__c !=null)
				 //agr.Bill_To_Street_Lcl__c  = sbquote.BillTo_Street_Intl__c+' '+sbquote.BillTo_Street2_Intl__c;
                            agr.Bill_To_Zipcode__c =  sbquote.BillTo_PostalCode__c;
                            system.debug('second debug');
				 agr.CA_Ship_To_City__c  = sbquote.ShipTo_City__c;
                            system.debug('debug ---  sbquote.ShipTo_City__c ' + sbquote.ShipTo_City__c);
                            system.debug('debug ---  CA_Ship_To_City__c ' + agr.CA_Ship_To_City__c);
				 agr.Ship_To_City_Lcl__c  = sbquote.ShipTo_City_Intl__c;
				 agr.Ship_To_Country__c  = sbquote.ShipTo_Country__c;
				 agr.Ship_To_State__c  = sbquote.ShipTo_State__c;
				 agr.Ship_To_State_Lcl__c  = sbquote.ShipTo_State_Intl__c;
                            agr.CA_Ship_To_Street__c=String.isNotBlank(sbquote.ShipTo_Street__c) &&
                                String.isNotBlank(sbquote.ShipTo_Street2__c)?sbquote.ShipTo_Street__c+' '+
                                sbquote.ShipTo_Street2__c:String.isNotBlank(sbquote.ShipTo_Street__c)?
                                sbquote.ShipTo_Street__c:(String.isNotBlank(sbquote.ShipTo_Street2__c)?sbquote.ShipTo_Street2__c:'');
                       // if(sbquote.ShipTo_Street__c!=null && sbquote.ShipTo_Street2__c!=null)
				 //agr.CA_Ship_To_Street__c  = sbquote.ShipTo_Street__c+sbquote.ShipTo_Street2__c;
                        agr.CA_Ship_To_Street_Lcl__c=String.isNotBlank(sbquote.ShipTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street_Intl__c+' '+
                                sbquote.ShipTo_Street2_Intl__c:String.isNotBlank(sbquote.ShipTo_Street_Intl__c)?
                                sbquote.ShipTo_Street_Intl__c:(String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street2_Intl__c:'');     
			//	 agr.CA_Ship_To_Street_Lcl__c  = sbquote.ShipTo_Street_Intl__c+SBQuote.ShipTo_Street2_Intl__c;
				 agr.CA_Ship_To_Zipcode__c  = sbquote.ShipTo_PostalCode__c;
                           agr.CA_Street__c=String.isNotBlank(sbquote.SoldTo_Street__c) &&
                                String.isNotBlank(sbquote.SoldTo_Street2__c)?sbquote.SoldTo_Street__c+' '+
                                sbquote.SoldTo_Street2__c:String.isNotBlank(sbquote.SoldTo_Street__c)?
                                sbquote.SoldTo_Street__c:(String.isNotBlank(sbquote.SoldTo_Street2__c)?sbquote.SoldTo_Street2__c:'');
                       //  if(sbquote.SoldTo_Street__c!=null && sbquote.SoldTo_Street2__c!=null)
				 // agr.CA_Street__c  = sbquote.SoldTo_Street__c+sbquote.SoldTo_Street2__c;
				  agr.CA_Street_Lcl__c=String.isNotBlank(sbquote.SoldTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.SoldTo_Street2_Intl__c)?sbquote.SoldTo_Street_Intl__c+' '+
                                sbquote.ShipTo_Street2_Intl__c:String.isNotBlank(sbquote.SoldTo_Street_Intl__c)?
                                sbquote.SoldTo_Street_Intl__c:(String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street2_Intl__c:'');
                      //  if(sbquote.SoldTo_Street_Intl__c!=null && sbquote.SoldTo_Street2_Intl__c!=null)
				 //agr.CA_Street_Lcl__c  = sbquote.SoldTo_Street_Intl__c+sbquote.SoldTo_Street2_Intl__c;
				 agr.CA_City__c  = sbquote.SoldTo_City__c;
				 agr.CA_City_Lcl__c  = sbquote.SoldTo_City_Intl__c;
				 agr.CA_State__c = sbquote.SoldTo_State__c;
				 agr.CA_State_Lcl__c = sbquote.SoldTo_State_Intl__c;
				 agr.CA_Country__c = sbquote.SoldTo_Country__c;
				 agr.CA_Zip_Code__c = sbquote.SoldTo_PostalCode__c;
                 //	US496449 changes
                        agr.CA_Reseller_City__c=sbquote.Reseller_City__c;
                        agr.CA_Reseller_City_Lcl__c=sbquote.Reseller_City_Intl__c;
                        agr.CA_Reseller_Country__c=sbquote.Reseller_Country__c;
                        agr.CA_Reseller_Id__c=sbquote.Reseller_BPID__c;
                        agr.CA_Reseller_Name__c=sbquote.Reseller_Name__c;
                        agr.CA_Reseller_Name_Lcl__c=sbquote.Reseller_Name_Intl__c;
                        agr.CA_Reseller_Zipcode__c=sbquote.Reseller_Postal_Code__c;
                        agr.CA_Reseller_State__c=sbquote.Reseller_State__c;
                        agr.CA_Reseller_State_Lcl__c=sbquote.Reseller_State_Intl__c;
                        agr.CA_Reseller_Street__c=sbquote.Reseller_Street__c;
                       // agr.CA_Reseller_City__c=sbquote.Reseller_Street2__c;
                        //agr.CA_Reseller_City__c=sbquote.Reseller_Street2_Intl__c;
                        agr.CA_Reseller_Street_Lcl__c=sbquote.Reseller_Street_Intl__c;
                        agr.EndUserEmailAddress__c=sbquote.EndUser_Contact_Email__c;
                             if(sbquote.EndUser_Contact_First_Name__c !=null && sbquote.EndUser_Contact_Last_Name__c!=null)
                        agr.CA_End_User_Contact_Name__c=sbquote.EndUser_Contact_First_Name__c + ' ' + sbquote.EndUser_Contact_Last_Name__c;
                        system.debug('agr.CA_End_User_Contact_Name__c : '+agr.CA_End_User_Contact_Name__c);
                            //agr.CA_Reseller_City__c=sbquote.EndUser_Contact_Last_Name__c;
                        agr.CA_End_User_Id__c=sbquote.EndUser_Contact_ID__c;
                            if(sbquote.EndUser_Contact_Intl_First_Name__c !=null && sbquote.EndUser_Contact_Intl_Last_Name__c!=null)
                        agr.CA_End_User_Contact_Name_Lcl__c=sbquote.EndUser_Contact_Intl_First_Name__c + ' ' + sbquote.EndUser_Contact_Intl_Last_Name__c;
                        system.debug('agr.CA_End_User_Contact_Name_Lcl__c : '+agr.CA_End_User_Contact_Name_Lcl__c);
                            //agr.CA_Reseller_City__c=sbquote.EndUser_Contact_Intl_Last_Name__c;
                        agr.EndUserContactPhone__c=sbquote.EndUser_Contact_Phone__c;
                        agr.CA_End_User_Country__c=sbquote.EndUser_Country__c;
                        agr.CA_End_User_City__c=sbquote.EndUser_City__c;
                        agr.CA_End_User_City_Lcl__c=sbquote.EndUser_City_Intl__c;
                        agr.CA_End_User_Id__c=sbquote.EndUser_BPID__c;//
                        agr.CA_End_User_Name__c=sbquote.EndUser_Name__c;
                        agr.CA_End_User_Name_Lcl__c=sbquote.EndUser_Name_Intl__c;
                        agr.CA_End_User_Zipcode__c=sbquote.EndUser_Postal_Code__c;
                        agr.CA_End_User_State__c=sbquote.EndUser_State__c;
                        agr.CA_End_User_State_Lcl__c=sbquote.EndUser_State_Intl__c;
                        agr.CA_End_User_Street__c=sbquote.EndUser_Street__c;
                       // agr.CA_Reseller_City__c=sbquote.EndUser_Street2__c;
                       // agr.CA_Reseller_City__c=sbquote.EndUser_Street2_Intl__c;
                        agr.CA_End_User_Street_Lcl__c=sbquote.EndUser_Street_Intl__c;
                        //agr.CA_Reseller_City__c=sbquote.Reseller_Street2_Intl__c;
                        
                        // change end         
                        
                }
                    }         
            }
        }
        } catch(Exception e) {
            system.debug('Error Message:::'+e.getMessage());
        }
        
    }  
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    //This method is insert agreement lineitems whenever any "Additional quote numbers " are added.
    public static void insertAggLineItem(List<Apttus__APTS_Agreement__c> newAgrList,Map<id,Apttus__APTS_Agreement__c> oldAgrMap){
        
        Map<Apttus__APTS_Agreement__c,set<String>> mapTobeInserted = new Map<Apttus__APTS_Agreement__c,set<String>>();
        Map<Apttus__APTS_Agreement__c,set<String>> mapTobeInsertedSF = new Map<Apttus__APTS_Agreement__c,set<String>>();
    set<String> setTobedeleted = new set<String>();
        set<String> setTobedeletedSF = new set<String>();
    set<String> uniqueSet = new set<String>();
    set<String> uniqueSetSF = new set<String>();
    Set<String> setOld = new Set<String>();
        Set<String> setOldSF = new Set<String>();
    Set<String> setNew = new Set<String>();
        Set<String> setNewSF = new Set<String>();
    Map<String ,List<Quote_Product_Report__c>> mapQuoteLineItems = new Map<String ,List<Quote_Product_Report__c>>();
        Map<String ,List<SBQQ__QuoteLine__c>> mapQuoteLineItemsSF = new Map<String ,List<SBQQ__QuoteLine__c>>();
    System.debug('inside method');
   
    for(Apttus__APTS_Agreement__c newagr:newAgrList){
        if(oldAgrMap!=null && newagr != null && oldAgrMap.get(newagr.Id)!=null){
          if((oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!= newagr.CA_Additional_Quote_Numbers__c) ||(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!= newagr.Additional_Salesforce_Quote_Numbers__c) || ((newagr.Apttus__Status_Category__c == Label.In_Authoring && (oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.In_Approval || oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.Approved || oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.In_Effect)))){
               if(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!=null && oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c.contains(',')){
               system.debug('1111111111111111');
                 setOld.addAll(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c.split(','));
               }
               if(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!=null && oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c.contains(',')){
               system.debug('1111111111111111');
                 setOld.addAll(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c.split(','));
               }
               else if(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!=null){
               system.debug('22222222222');
                 setOld.add(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c);
               }
              else if(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!=null){
               system.debug('22222222222');
                 setOldSF.add(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c);
               }
                if(newagr.CA_Additional_Quote_Numbers__c!=null && newagr.CA_Additional_Quote_Numbers__c.contains(',')){
                system.debug('333333333333');
                 setNew.addAll(newagr.CA_Additional_Quote_Numbers__c.split(','));
               }
              if(newagr.Additional_Salesforce_Quote_Numbers__c!=null && newagr.Additional_Salesforce_Quote_Numbers__c.contains(',')){
                system.debug('333333333333');
                 setNewSF.addAll(newagr.Additional_Salesforce_Quote_Numbers__c.split(','));
               }
               else if(newagr.CA_Additional_Quote_Numbers__c!=null){
               system.debug('4444444444444444');
                 setNew.add(newagr.CA_Additional_Quote_Numbers__c);
               }
              else if(newagr.Additional_Salesforce_Quote_Numbers__c!=null){
               system.debug('4444444444444444');
                 setNewSF.add(newagr.Additional_Salesforce_Quote_Numbers__c);
               }
               
               mapTobeInserted.put(newagr,setnew);
              mapTobeInsertedSF.put(newagr,setnewSF);
               System.debug('****oldnewvalues_LineItem  '+setold+'****'+setnew);
               setTobedeleted.addAll(setold);
              setTobedeleted.addAll(setoldSF);
               uniqueSet.addAll(setnew);
              uniqueSetSF.addAll(setnewSF);
               system.debug('setTobedeleted&&&&&'+setTobedeleted);
               system.debug('setTobedeletedSF&&&&&'+setTobedeletedSF);
           }  
           else{
               if(newagr.CA_Additional_Quote_Numbers__c != null && oldAgrMap==null) {
                 if(newagr.CA_Additional_Quote_Numbers__c.contains(',')){
                     setNew.addAll(newagr.CA_Additional_Quote_Numbers__c.split(','));
                     system.debug('5555555555');
                   }
                   else{
                     setNew.add(newagr.CA_Additional_Quote_Numbers__c);
                     system.debug('666666666666666');
                   }
                 mapTobeInserted.put(newagr,setNew);
                 uniqueSet.addAll(setNew);
               }  
               if(newagr.Additional_Salesforce_Quote_Numbers__c != null && oldAgrMap==null) {
                 if(newagr.Additional_Salesforce_Quote_Numbers__c.contains(',')){
                     setNewSF.addAll(newagr.Additional_Salesforce_Quote_Numbers__c.split(','));
                     system.debug('5555555555');
                   }
                   else{
                     setNewSF.add(newagr.Additional_Salesforce_Quote_Numbers__c);
                     system.debug('666666666666666');
                   }
                 mapTobeInsertedSF.put(newagr,setNewSF);
                 uniqueSetSF.addAll(setNewSF);
               }  
           }
       }
    } 
       List<Quote_Product_Report__c> listOfquoteLineItem = new List<Quote_Product_Report__c>();
        List<SBQQ__QuoteLine__c> listOfquoteLineItemSF = new List<SBQQ__QuoteLine__c>();
        if(uniqueSet.size() > 0)
        for(Quote_Product_Report__c quoteProd: [Select id,Name,No_Charge_Product__c,Reason_for_no_charge__c,New_Additional_Quantity__c,Existing_Quantity__c,SpecialMetricUsageQtyNewAdditional__c,Special_Metric_Usage_Qty_Existing__c,Project_Description__c, Product_Material__r.Name, Product_Instance_Id__c, License_Metric__c,SAP_IO_User_Status__c,Auth_Use_Model__c,Bus_Transaction_Type__c,CPQ_Quote_Number__c,Delivery_Method__c,Sterling_Quote__r.CA_CPQ_Quote_Number__c,Lic_Sub_off_List__c,Effective_Date__c,End_Date__c,License_Type__c,Line_Number__c,Mainframe_Distributed__c,Monthly_Product_Fee_for_Subscriptionterm__c,Operating_System__c,CA_Pricing_Group__c,Product_Name__c,Proposed_Lic_Sub_Fee__c,Proposed_Maint_Fee__c,Shipping_Required__c,Stated_Renewal_Fee__c,Total_Proposed_Price__c,Total_Quantity__c,Volume_License_Subs_Fee__c,Volume_Maintenance_Price__c, Activity_Type__c,   Change_Hours_Units__c,  Charge_Code__c, Cost_Center__c, Discount__c,    Discount_Exceeds_Reason__c, End_Dateof_Project__c,  Estimated_Start_Date__c,    Exhibit_Comment__c, Expense_Amount_Included__c, GSA_Rate__c,    Hours_Units__c, List_Rate__c,   List_Rate_Revenue__c,   Planned_Project_Cost__c,    Planned_Project_Revenue__c, PO_Number__c,   Product_1__c,   Product_1_Percent__c,   Product_2__c,   Product_2_Percent__c,   Product_3__c,   Product_3_Percent__c,   Project_Bill_Rate__c,   Contracted_Rate_Used_1__c,  Project_Group__c,   Project_Type__c,    Role_Description__c,    SAP_Contract_Line_Number__c,    Project_Number__c,  Service_Offering__c,    Services_Flag__c,   SKU__c, Std_Cost__c,    Vendor_Overhead__c, VSOE_Rate__c from Quote_Product_Report__c where Sterling_Quote__r.CA_CPQ_Quote_Number__c in: uniqueSet]){
          if(mapQuoteLineItems!=null && mapQuoteLineItems.containsKey(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c)){
              List<Quote_Product_Report__c> lst= mapQuoteLineItems.get(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c);
              lst.add(quoteProd);
              mapQuoteLineItems.put(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c ,lst );
          }
          else{
            List<Quote_Product_Report__c> lst= new List<Quote_Product_Report__c>();
            lst.add(quoteProd);
            mapQuoteLineItems.put(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c , lst);
          }
        }
        system.debug('::: uniqueSetSF '+uniqueSetSF);
        if(uniqueSetSF.size() > 0)
         for(SBQQ__QuoteLine__c SFQuote: [Select ID,Name,Quote__c,SBQQ__Number__c,Discount_form__c,SBQQ__PriorQuantity__c,Maintenance_Product__c,Maintenance_Parent_Quote_Line__c,Start_Date__c,End_Date__c,CA_License_Type__c,Quote_Line_Number_SAP__c,Monthly_Unit_Price__c,SAP_Operating_System__c,Pricing_Group__c,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__NetTotal__c,Net_Total_Form__c,CA_License_Cert__c,SBQQ__Quantity__c,Volume_Discount_Price_form__c,SBQQ__Quote__c,Quantity_Prior__c,
                                                           License_Metric_CPQ__c,SBQQ__ProductCode__c,Instance_ID__c,toLabel(Auth_Use_Mode__c) Auth_Use_Mode__cLabel,Business_Transaction_Type_SAP__c,Parent_Bundle__c from SBQQ__QuoteLine__c where Quote__c IN: uniqueSetSF])
           {
               system.debug('::: 2 uniqueSetSF '+uniqueSetSF);
              if(mapQuoteLineItemsSF!=null && mapQuoteLineItemsSF.containsKey(SFQuote.Quote__c)){
              List<SBQQ__QuoteLine__c> lst= mapQuoteLineItemsSF.get(SFQuote.Quote__c);
              lst.add(SFQuote);
              mapQuoteLineItemsSF.put(SFQuote.Quote__c,lst );
          }
          else{
               system.debug('::: 3 uniqueSetSF '+uniqueSetSF);
            List<SBQQ__QuoteLine__c> lst= new List<SBQQ__QuoteLine__c>();
            lst.add(SFQuote);
            mapQuoteLineItemsSF.put(SFQuote.Quote__c , lst);
          }
        }
        List<Apttus__AgreementLineItem__c> listOfaggLineItem = new List<Apttus__AgreementLineItem__c >();
        
        
        system.debug('listOfquoteLineItem .....'+listOfquoteLineItem );
        
        System.debug('**********map'+mapTobeInserted);
        for(Apttus__APTS_Agreement__c newagr:mapTobeInserted.keySet()){
            System.debug('**********Jack'+mapTobeInserted.get(newagr));
            for(String quoteNumber: mapTobeInserted.get(newagr)){
                if(mapQuoteLineItems!=null && mapQuoteLineItems.containsKey(quoteNumber)){
                    for(Quote_Product_Report__c qi:mapQuoteLineItems.get(quoteNumber)){
                        if(!(qi.No_Charge_Product__c!=null && qi.No_Charge_Product__c=='Y' && qi.Reason_for_no_charge__c!=null && qi.Reason_for_no_charge__c!='Stabilized'))
                        {
                            system.debug('^^^^.....');                    
                            Apttus__AgreementLineItem__c alitem = new Apttus__AgreementLineItem__c();
                            alitem.CA_Auth_Use_Model__c = qi.Auth_Use_Model__c;
                            alitem.CA_Bus_Transaction_Type__c = qi.Bus_Transaction_Type__c;
                            //change for New/Additional quantity change
                            alitem.New_Additional_Quantity__c= qi.New_Additional_Quantity__c;
                            alitem.Existing_Quantity__c= qi.Existing_Quantity__c;
                            
                            //Added by Umang for Use Limitation and Special Metric usage Qty fields population
                            alitem.SpecialMetricsUsageQtyNewAdditional__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                            alitem.SpecialMetricsUsageQtyExisting__c=qi.Special_Metric_Usage_Qty_Existing__c;
                            
                            if(qi.Bus_Transaction_Type__c!=null)
                            {
                                if(qi.Auth_Use_Model__c=='Special Metric')
                                {
                                    if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c=='Time - Product Migration'|| qi.Bus_Transaction_Type__c=='Time - Reinstatement')
                                    {
                                        alitem.Use_Limitation__c=qi.Special_Metric_Usage_Qty_Existing__c;
                                    }
                                    if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity'|| qi.Bus_Transaction_Type__c=='Education')
                                    {
                                        alitem.Use_Limitation__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                                    }
                                }
                                else
                                {
                                    if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c=='Time - Product Migration'|| qi.Bus_Transaction_Type__c=='Time - Reinstatement' || qi.Bus_Transaction_Type__c=='Mainframe Capacity' )
                                    {
                                        alitem.Use_Limitation__c=qi.Existing_Quantity__c;
                                    }
                                    if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity')
                                    {
                                        alitem.Use_Limitation__c=qi.New_Additional_Quantity__c;
                                    }
                                }
                            }
                            //Ended by Umang
                            //change ends
                            //change for svcs added by jagan
                                alitem.Project_Description__c=qi.Project_Description__c;
                                //change ends
                            alitem.CA_CPQ_Quote_Number_Quote_Number__c = qi.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                            alitem.CA_Delivery_Method__c = qi.Delivery_Method__c;
                            alitem.CA_Disc_off_List_License_Subs__c = qi.Lic_Sub_off_List__c;
                            alitem.CA_Effective_Date__c = qi.Effective_Date__c;
                            alitem.CA_End_Date__c = qi.End_Date__c;
                            alitem.CA_License_Type__c = qi.License_Type__c;
                            alitem.CA_Line_Number__c = qi.Line_Number__c;
                            alitem.CA_Mainframe_Distributed__c = qi.Mainframe_Distributed__c;
                            alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c = qi.Monthly_Product_Fee_for_Subscriptionterm__c;
                            alitem.CA_Operating_System__c = qi.Operating_System__c;
                            alitem.CA_Pricing_Group__c = qi.CA_Pricing_Group__c;
                            alitem.CA_Product_Code__c = qi.Product_Material__r.Name;
                            alitem.CA_Product_Name__c = qi.Product_Name__c;
                            alitem.CA_Proposed_Lic_Sub_Price__c = qi.Proposed_Lic_Sub_Fee__c;
                            //Currency format change 
                                if(alitem.CA_Proposed_Lic_Sub_Price__c>0){
                                alitem.ProposedLicSubPrice__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Lic_Sub_Price__c),newagr.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Proposed_Maintenance_Price__c = qi.Proposed_Maint_Fee__c;
                            if(alitem.CA_Proposed_Maintenance_Price__c>0){
                                alitem.ProposedMaintenancePriceText__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Maintenance_Price__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.Quote_Line_Item_Id__c = qi.Id;
                            alitem.CA_Shipping_Required__c = qi.Shipping_Required__c;
                            alitem.CA_Stated_Renewal_Price__c = qi.Stated_Renewal_Fee__c;
                            if(alitem.CA_Stated_Renewal_Price__c>0){
                                alitem.StatedRenewalPriceText__c=Currencyformat(string.valueOf(alitem.CA_Stated_Renewal_Price__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.CA_Total_Proposed_Price__c = qi.Total_Proposed_Price__c;
                            //Currency format change 
                                if(alitem.CA_Total_Proposed_Price__c>0){
                                alitem.TotalProposedPriceText__c=Currencyformat(string.valueOf(alitem.CA_Total_Proposed_Price__c),newagr.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Total_Quantity__c = qi.Total_Quantity__c;
                            alitem.CA_Volume_License_Subs_Price__c = qi.Volume_License_Subs_Fee__c;
                            alitem.CA_Volume_Maintenance_Price__c = qi.Volume_Maintenance_Price__c;
                            alitem.Activity_Type__c= qi.Activity_Type__c;
                            alitem.Change_Hours_Units__c= qi.Change_Hours_Units__c;
                            alitem.Charge_Code__c= qi.Charge_Code__c;
                            alitem.Cost_Center__c= qi.Cost_Center__c;
                            //alitem.CA_CPQ_Quote_Number_Quote_Number__c= qi.CPQ_Quote_Number__c;
                            alitem.Discount__c= qi.Discount__c;
                            alitem.Discount_Exceeds_Reason__c= qi.Discount_Exceeds_Reason__c;
                            alitem.End_Date_of_Project__c= qi.End_Dateof_Project__c;
                            alitem.Estimated_Start_Date__c= qi.Estimated_Start_Date__c;
                            alitem.Exhibit_Comment__c= qi.Exhibit_Comment__c;
                            alitem.Expense_Amount_Included__c= qi.Expense_Amount_Included__c;
                            if(alitem.Expense_Amount_Included__c>0){
                                alitem.Expense_Amount_Included_Text__c=Currencyformat(string.valueOf(alitem.Expense_Amount_Included__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.GSA_Rate__c= qi.GSA_Rate__c;
                            if(alitem.GSA_Rate__c>0){
                                alitem.GSARateText__c=Currencyformat(string.valueOf(alitem.GSA_Rate__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.Hours_Units__c= qi.Hours_Units__c;
                            alitem.List_Rate__c= qi.List_Rate__c;
                            if(alitem.List_Rate__c>0){
                                alitem.ListRateText__c=Currencyformat(string.valueOf(alitem.List_Rate__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.List_Rate_Revenue__c= qi.List_Rate_Revenue__c;
                            if(alitem.List_Rate_Revenue__c>0){
                                alitem.ListRateRevenueText__c=Currencyformat(string.valueOf(alitem.List_Rate_Revenue__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Cost__c= qi.Planned_Project_Cost__c;
                            if(alitem.Planned_Project_Cost__c>0){
                                alitem.PlannedProjectCostText__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Revenue__c= qi.Planned_Project_Revenue__c;
                            if(alitem.Planned_Project_Revenue__c>0){
                                alitem.PlannedProjectRevenuetext__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),newagr.CurrencyIsoCode) ;
                                }
                            alitem.PO_Number__c= qi.PO_Number__c;
                            alitem.Product_1__c= qi.Product_1__c;
                            alitem.Product_1_Percent__c= qi.Product_1_Percent__c;
                            alitem.Product_2__c= qi.Product_2__c;
                            alitem.Product_2_Percent__c= qi.Product_2_Percent__c;
                            alitem.Product_3__c= qi.Product_3__c;
                            alitem.Product_3_Percent__c= qi.Product_3_Percent__c;
                            alitem.Project_Bill_Rate__c= qi.Project_Bill_Rate__c;
                            if(alitem.Project_Bill_Rate__c>0){
                            alitem.ProjectBillRateText__c=Currencyformat(string.valueOf(alitem.Project_Bill_Rate__c),newagr.CurrencyIsoCode) ;
                            }
                            alitem.Contracted_Rate_Used_1__c= qi.Contracted_Rate_Used_1__c;
                            alitem.Project_Group__c= qi.Project_Group__c;
                            alitem.Project_Type__c= qi.Project_Type__c;
                            alitem.Role_Description__c = qi.Role_Description__c;
                            alitem.SAP_Contract_Line_Number__c= qi.SAP_Contract_Line_Number__c;
                            alitem.Project_Number__c= qi.Project_Number__c;
                            alitem.SAP_IO_User_Status__c= qi.SAP_IO_User_Status__c;
                            alitem.Service_Offering__c= qi.Service_Offering__c;
                            alitem.Services_Flag__c= qi.Services_Flag__c;
                            alitem.SKU__c= qi.SKU__c;
                            alitem.Std_Cost__c= qi.Std_Cost__c;
                            if(alitem.Std_Cost__c>0){
                            alitem.StdCostText__c=Currencyformat(string.valueOf(alitem.Std_Cost__c),newagr.CurrencyIsoCode) ;
                            }
                            alitem.Vendor_Overhead__c= qi.Vendor_Overhead__c;
                            alitem.VSOE_Rate__c= qi.VSOE_Rate__c;
                            if(alitem.VSOE_Rate__c>0){
                            alitem.VSOERateText__c=Currencyformat(string.valueOf(alitem.VSOE_Rate__c),newagr.CurrencyIsoCode) ;
                            }
                            alitem.CA_License_Metric__c = qi.License_Metric__c;
                            alitem.Apttus__AgreementId__c = newagr.Id;
                            alitem.CurrencyIsoCode = newagr.CurrencyIsoCode;
                            alitem.CA_Product_Instance_ID__c = qi.Product_Instance_ID__c;
                            listOfaggLineItem .add(alitem);
                        }
                    }
                }   
            }
        }        
        
        system.debug('mapTobeInsertedSF : ' +mapTobeInsertedSF); 
        list<Apttus__AgreementLineItem__c> agrLineItemToupdate=new list<Apttus__AgreementLineItem__c>();
        Map<String,Apttus__AgreementLineItem__c> SBQuoteLineNumberAgreementLineItem=new Map<String,Apttus__AgreementLineItem__c>();
          for(Apttus__APTS_Agreement__c newagr:mapTobeInsertedSF.keySet()){
              system.debug('Inside 1111');
                System.debug('**********Jack'+mapTobeInsertedSF.get(newagr));
                for(String quoteNumber: mapTobeInsertedSF.get(newagr)){
                    system.debug('Inside 2222 quoteNumber '+quoteNumber);
                    system.debug('Inside 2222 mapQuoteLineItemsSF) '+mapQuoteLineItemsSF);
                 if(mapQuoteLineItemsSF!=null && mapQuoteLineItemsSF.containsKey(quoteNumber)){
                     system.debug('Inside 3333');
                  for(SBQQ__QuoteLine__c SBQuote:mapQuoteLineItemsSF.get(quoteNumber)){
                      system.debug('Inside 4444 SBQuote' +SBQuote);
                      if(!SBQuote.Parent_Bundle__c){
                          system.debug('Inside 5555');
                          
                       Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                          if(SBQuote.Maintenance_Product__c=='Yes'){
                              if(SBQuote.Maintenance_Parent_Quote_Line__c!=null && SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c)!=null)
                              {
                                   alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c);
                              alitem.CA_Proposed_Maintenance_Price__c=SBQuote.Net_Total_Form__c;
                              alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                                  alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                                  alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;	
                              SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Proposed_Maintenance_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                 SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Volume_Maintenance_Price__c=alitem.CA_Volume_Maintenance_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Total_Proposed_Price__c=alitem.CA_Total_Proposed_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Stated_Renewal_Price__c=alitem.CA_Stated_Renewal_Price__c;
                                  agrLineItemToupdate.add(alitem);
                              } 
                          }
                          else  
                          {
                       alitem.CA_CPQ_Quote_Number_Quote_Number__c=SBQuote.Quote__c;
                       alitem.Apttus__AgreementId__c = newagr.Id;
                          
                       alitem.CA_Disc_off_List_License_Subs__c = SBQuote.Discount_form__c;
                       alitem.CA_Effective_Date__c = SBQuote.Start_Date__c;
                       alitem.CA_End_Date__c = SBQuote.End_Date__c;
                       alitem.CA_Line_Number__c = SBQuote.SBQQ__Number__c;
                       alitem.CA_License_Type__c=SBQuote.CA_License_Type__c;
                          system.debug('Inside 6666');
                       alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c=SBQuote.Monthly_Unit_Price__c;
                       alitem.CA_Operating_System__c=SBQuote.SAP_Operating_System__c;
                       alitem.CA_Pricing_Group__c=SBQuote.Pricing_Group__c;
                       alitem.CA_Product_Code__c=SBQuote.SBQQ__ProductCode__c ;
                       alitem.CA_Product_Name__c=SBQuote.SBQQ__ProductName__c;
                       alitem.CA_Proposed_Lic_Sub_Price__c=SBQuote.Net_Total_Form__c;
                       //alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c;
                       if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                    alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                     alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                              alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                     if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null )
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                              alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c;
                    if(alitem.CA_Bus_Transaction_Type__c!=null){
                    if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement'){
                           alitem.Existing_Quantity__c=SBQuote.SBQQ__Quantity__c;    
                            alitem.Use_Limitation__c=alitem.Existing_Quantity__c;
                        alitem.New_Additional_Quantity__c=null;
                        }

                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                     alitem.Use_Limitation__c = alitem.New_Additional_Quantity__c;
                         SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                        listOfaggLineItem.add(alitem);
                    } 
                    }
               }
                      
                  }
                 }
                }
          }
                      
        System.debug('*******setTobedeletedLineitem'+setTobedeleted);
        List<Apttus__AgreementLineItem__c> lstTobeDeleted = new List<Apttus__AgreementLineItem__c>();
        if(setTobedeleted.size()>0)
        for(Apttus__AgreementLineItem__c lineItem : [select id,CA_CPQ_Quote_Number_Quote_Number__c,Apttus__AgreementId__r.Sterling_Quote__r.CA_CPQ_Quote_Number__c,Apttus__AgreementId__r.SF_Quote__r.Name from Apttus__AgreementLineItem__c where CA_CPQ_Quote_Number_Quote_Number__c in: setTobedeleted]){
            if(lineItem.Apttus__AgreementId__r.Sterling_Quote__c!=null && lineItem.CA_CPQ_Quote_Number_Quote_Number__c != lineItem.Apttus__AgreementId__r.Sterling_Quote__r.CA_CPQ_Quote_Number__c){
              lstTobeDeleted.add(lineItem );
             }
            if(lineItem.Apttus__AgreementId__r.SF_Quote__c!=null && lineItem.CA_CPQ_Quote_Number_Quote_Number__c != lineItem.Apttus__AgreementId__r.SF_Quote__r.Name)
        lstTobeDeleted.add(lineItem );
        }
        try{
            System.debug('*******lstTobeDeletedLineItem'+lstTobeDeleted);
            delete lstTobeDeleted;
        }Catch(Exception e){
            system.debug('Exception Ocurred:::'+e);
        } 
        try{
            if(agrLineItemToupdate.size()>0){
                update agrLineItemToupdate;
            }
        }
        catch(Exception e)
        {
            system.debug('Exception Ocurred in update:::'+e);
        }
        try{
            system.debug('listOfaggLineItem .....'+listOfaggLineItem);
            if(listOfaggLineItem .size()>0){
                insert listOfaggLineItem;
            }
        }Catch(Exception e){
            system.debug('Exception Ocurred:::'+e);
        } 
    }
    
    //Update Agreement Status on DDR
     public static void updateAgreementStatusonDDR(List<Apttus__APTS_Agreement__c> newAgreement) {
        if(test.isRunningTest()) return;
        try{
            system.debug('Update DDR Status Method');
            List<Deal_Desk_Review__c> updateDDR = new List<Deal_Desk_Review__c>();
            Map<Id,Apttus__APTS_Agreement__c> mapDDRIdvsAgreement = new Map<Id,Apttus__APTS_Agreement__c>();
            Set<Id> ddrIds = new set<Id>();
            
            for(Apttus__APTS_Agreement__c agr : newAgreement){
                if(agr.CA_DDR__c != null) {
                    if(!ddrIds.contains(agr.CA_DDR__c)) {
                        ddrIds.add(agr.CA_DDR__c);
                        mapDDRIdvsAgreement.put(agr.CA_DDR__c,agr);
                    }
                }   
            }
            
            system.debug('Set DDR Ids::::'+ddrIds);
            
            List<Deal_Desk_Review__c> ddrList = new List<Deal_Desk_Review__c>(); 
            
            if(ddrIds.size() > 0)
                ddrList = [Select Id,Apttus_Agreement__c,Agreement__c from Deal_Desk_Review__c where ID IN: ddrIds];
            
            if(ddrList.size() > 0 && ddrList != null)
                for(Deal_Desk_Review__c ddr : ddrList) {
                    if(mapDDRIdvsAgreement.containsKey(ddr.Id)){
                     if(((ddr.Apttus_Agreement__c!=null && ddr.Apttus_Agreement__c != mapDDRIdvsAgreement.get(ddr.Id).Apttus__Status__c) || ddr.Apttus_Agreement__c==null) || ((ddr.Agreement__c!=null && ddr.Agreement__c != mapDDRIdvsAgreement.get(ddr.Id).Id)) || ddr.Agreement__c==null)
                       {
                        ddr.Apttus_Agreement__c = mapDDRIdvsAgreement.get(ddr.Id).Apttus__Status__c;
                        ddr.Agreement__c = mapDDRIdvsAgreement.get(ddr.Id).Id;
                        updateDDR.add(ddr);
                       }
                    }
                }
            system.debug('Updated DDR Size:::'+updateDDR);
            if(updateDDR.size() > 0)
                update updateDDR;
        } catch (Exception e) {
            system.debug('Error Message::'+e.getMessage());
        }        
    }
    
    //This Method will udpate Approver Specific comments on the Approval Requests.
    public static void updateApprovalRequestComments(List<Apttus__APTS_Agreement__c> newAgrList){
        
        try{
            system.debug('Update Approval Requests Method:::');
            Set<Id> agrIds = new Set<Id>();
            
            for(Apttus__APTS_Agreement__c agr : newAgrList) {
                if(agr.Apttus__Status_Category__c == Label.In_Approval && agr.Apttus__Status__c == Label.Pending_Approval) {
                    if(!agrIds.contains(agr.Id))
                        agrIds.add(agr.Id);
                }
            }
            system.debug('Agreement Ids size:::'+agrIds.size());
            if(agrIds.size() > 0) {
                List<Apttus_Approval__Approval_Request__c> appReqList = [Select Id,Apttus_Approval__Parent_Agreement__c, Apttus_Approval__Related_Agreement__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__StepLabel__c from Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Agreement__c IN: agrIds];
                
                Map<Id,List<Apttus_Approval__Approval_Request__c>> mapIdvsAppReq = new Map<Id,List<Apttus_Approval__Approval_Request__c>>();
                List<Apttus_Approval__Approval_Request__c> appList;
                
                for(Apttus_Approval__Approval_Request__c appReq : appReqList){
                    if(mapIdvsAppReq.containsKey(appReq.Apttus_Approval__Related_Agreement__c)){
                        appList = mapIdvsAppReq.get(appReq.Apttus_Approval__Related_Agreement__c);
                        appList.add(appReq);
                        mapIdvsAppReq.put(appReq.Apttus_Approval__Related_Agreement__c,appList);
                    } else {
                        appList = new List<Apttus_Approval__Approval_Request__c>();
                        appList.add(appReq);
                        mapIdvsAppReq.put(appReq.Apttus_Approval__Related_Agreement__c,appList);
                    }
                }
                
                List<Apttus_Approval__Approval_Request__c> updateAppReqList = new List<Apttus_Approval__Approval_Request__c>();
                
                for(Apttus__APTS_Agreement__c agr : newAgrList) {
                    if(mapIdvsAppReq.containsKey(agr.Id)){
                        for(Apttus_Approval__Approval_Request__c appReq : mapIdvsAppReq.get(agr.Id)){
                            if(appReq.Apttus_Approval__StepLabel__c == Label.Level_1) {
                                
                                if(agr.Agreement_Approver__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L1_Approver1_Comments__c;
                                if(agr.Agreement_Approver2__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver2__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L1_Approver2_Comments__c;
                                if(agr.Agreement_Approver3__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver3__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L1_Approver3_Comments__c;
                                if(agr.Agreement_Approver4__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver4__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L1_Approver4_Comments__c;
                                
                                if(appReq.Apttus_Approval__Assigned_To_Id__c == null)
                                    appReq.CA_Approver_Specific_Comments__c = Label.CA_SystemUseOnly;    
                            }
                            if(appReq.Apttus_Approval__StepLabel__c == Label.Level_2) {
                                if(agr.Agreement_Approver1_L2__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver1_L2__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L2_Approver1_Comments__c;
                                if(agr.Agreement_Approver2_L2__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver2_L2__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L2_Approver2_Comments__c;
                                if(agr.Agreement_Approver3_L2__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver3_L2__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L2_Approver3_Comments__c;
                                if(agr.Agreement_Approver4_L2__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver4_L2__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L2_Approver4_Comments__c;
                                
                                if(appReq.Apttus_Approval__Assigned_To_Id__c == null)
                                    appReq.CA_Approver_Specific_Comments__c = Label.CA_SystemUseOnly;        
                            }
                            if(appReq.Apttus_Approval__StepLabel__c == Label.Level_3) {
                                if(agr.Agreement_Approver1_L3__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver1_L3__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L3_Approver1_Comments__c;
                                if(agr.Agreement_Approver2_L3__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver2_L3__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L3_Approver2_Comments__c;
                                if(agr.Agreement_Approver3_L3__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver3_L3__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L3_Approver3_Comments__c;
                                if(agr.Agreement_Approver4_L3__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver4_L3__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L3_Approver4_Comments__c;
                                
                                if(appReq.Apttus_Approval__Assigned_To_Id__c == null)
                                    appReq.CA_Approver_Specific_Comments__c = Label.CA_SystemUseOnly;        
                            }
                            if(appReq.Apttus_Approval__StepLabel__c == Label.Level_4) {
                                if(agr.Agreement_Approver1_L4__c != null)
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver1_L4__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L4_Approver1_Comments__c;
                                if(agr.Agreement_Approver2_L4__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver2_L4__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L4_Approver2_Comments__c;
                                if(agr.Agreement_Approver3_L4__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver3_L4__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L4_Approver3_Comments__c;
                                if(agr.Agreement_Approver4_L4__c != null)   
                                    if(appReq.Apttus_Approval__Assigned_To_Id__c == string.valueof(agr.Agreement_Approver4_L4__c))
                                    appReq.CA_Approver_Specific_Comments__c = agr.L4_Approver4_Comments__c;
                                
                                if(appReq.Apttus_Approval__Assigned_To_Id__c == null)
                                    appReq.CA_Approver_Specific_Comments__c = Label.CA_SystemUseOnly;        
                            }
                            updateAppReqList.add(appReq);
                        }
                        
                    }
                }
                system.debug('Updated Approval Request Size:::'+updateAppReqList);
                if(updateAppReqList.size() > 0) {
                    update updateAppReqList;
                }
            }
        } catch(Exception e) {
            e.getMessage();
        }    
    }
    
    //Remove Approvers once the agreement status is either Approved/Rejected
    public static void removeAgreementApprovers(Map<Id,Apttus__APTS_Agreement__c> oldMap, Map<Id,Apttus__APTS_Agreement__c> newMap){
        try {
            Set<Id> agrIds = new Set<Id>();
            
            for(Apttus__APTS_Agreement__c agr : newMap.values()) {
                if( (agr.CA_Remove_All_Original_Approvers__c == true && oldMap.get(agr.Id).CA_Remove_All_Original_Approvers__c == false )) {
                    agrIds.add(agr.Id);
                    //agr.CA_Remove_All_Original_Approvers__c = false;
                    //updateAgrList.add(agr);
                }
                if((agr.Apttus__Status_Category__c == Label.In_Approval && agr.Apttus__Status__c == Label.Pending_Approval ) ) {
                    Approval.lock(agr.Id);
                }
            }
            system.debug('agrIds:::'+agrIds);
            List<Approver__c> apprList;
            if(agrIds.size() > 0 && agrIds != null)
                apprList = [Select Id,CA_Agreement__c from Approver__c where CA_Agreement__c IN: agrIds];
            
            if(apprList.size() > 0)
                delete apprList;
        } catch(Exception e) {
            e.getMessage();
        }
    }
    
    //To insert payment plans and agreement line items whenever Primary quote is changed  
    public static void insertPaymentPlansAndLineItemsFromPrimaryQuote(List<Apttus__APTS_Agreement__c> newAgreement,Map<Id,Apttus__APTS_Agreement__c> oldAgrMap){
        try{
             Set<Id> sterQuoteIds= new Set<id>();
    Set<Id> SBQuoteIds= new Set<id>();
    Set<Id> aggIdToDelete = new Set<Id>();
    Set<Id> oldQuoteIds = new Set<Id>();
    Set<Id> oldSBQuoteIds = new Set<Id>();
            for(Apttus__APTS_Agreement__c currentAgreement: newAgreement){     
                system.debug('currentAgreement.Sterling_Quote__c****'+currentAgreement.Sterling_Quote__c); 
                system.debug('oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c*****'+oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c);
                system.debug('oldAgrMap****'+oldAgrMap);    
                
                if((currentAgreement.Sterling_Quote__c !=null && oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c != currentAgreement.Sterling_Quote__c && oldAgrMap!=null) || (currentAgreement.Apttus__Status_Category__c == Label.In_Authoring && (oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.In_Approval || oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.Approved || oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.In_Effect))){         
                    sterQuoteIds.add(currentAgreement.Sterling_Quote__c);
                    oldQuoteIds.add(oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c);
                    system.debug('BLock1*****'); 
                }
                else if(currentAgreement.Sterling_Quote__c != null && oldAgrMap == null && oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c == null){          
                    sterQuoteIds.add(currentAgreement.Sterling_Quote__c);
                    system.debug('BLock2*****'); 
                }              
                else if(oldAgrMap.get(currentAgreement.Id).Sterling_Quote__c != null && currentAgreement.Sterling_Quote__c == null){
                    aggIdToDelete.add(currentAgreement.id);
                    system.debug('BLock3*****');
                }
                 //for steelbrick US381112 tensor
        else if((currentAgreement.SF_Quote__c !=null && oldAgrMap.get(currentAgreement.Id).SF_Quote__c != currentAgreement.SF_Quote__c && oldAgrMap!=null) || (currentAgreement.Apttus__Status_Category__c == Label.In_Authoring && (oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.In_Approval || oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.Approved || oldAgrMap.get(currentAgreement.Id).Apttus__Status_Category__c == Label.In_Effect))){         
                    SBQuoteIds.add(currentAgreement.SF_Quote__c);
                    oldSBQuoteIds.add(oldAgrMap.get(currentAgreement.Id).SF_Quote__c);
                     system.debug('BLock1*****'); 
                }
                else if(currentAgreement.SF_Quote__c != null && oldAgrMap == null && oldAgrMap.get(currentAgreement.Id).SF_Quote__c == null){          
                    SBQuoteIds.add(currentAgreement.SF_Quote__c);
                     system.debug('BLock2*****'); 
                }              
                else if(oldAgrMap.get(currentAgreement.Id).SF_Quote__c != null && currentAgreement.SF_Quote__c == null){
                    aggIdToDelete.add(currentAgreement.id);
                    system.debug('BLock3*****');
                    
                }
            }
            
            system.debug('inside debug insertPaymentPlansAndLineItemsFromPrimaryQuote Jagan' );
    List<PaymentPlan__c> listOfQuotePaymentPlan = new List<PaymentPlan__c>();
    List<Quote_Product_Report__c> listOfQuoteLineItem = new List<Quote_Product_Report__c>();
    List<SBQQ__QuoteLine__c> SBquoteLineItemsList = new List<SBQQ__QuoteLine__c>();
    List<Payment_Plan__c> PaymentPlanList = new List<Payment_Plan__c>();
    list<Apttus__AgreementLineItem__c> agrLineItemToupdate=new list<Apttus__AgreementLineItem__c>();
    Map<String,Apttus__AgreementLineItem__c> SBQuoteLineNumberAgreementLineItem=new Map<String,Apttus__AgreementLineItem__c>();        
    if(sterQuoteIds.size() > 0)
        listOfQuotePaymentPlan = [Select Id, Sterling_Quote__r.CA_CPQ_Quote_Number__c, Committed_Payment__c, CPQ_Quote_NUmber__c, Payment_Date__c, Date_Text__c, License_Payment__c, Maintenance_Payment__c, Payment_Total__c, Payment_Type__c, Services_Payment__c, Sterling_Quote__c, Subscription_Payment__c, Initial_Payment__c, Milestone_Description__c, Milestone_Number__c, Number_of_Milestones__c, Payment_Percent_Of_Total__c, Payment_Amount__c, Payment_Date_Services__c, Project_ID__c, sfxId__c, Total_Payments__c from PaymentPlan__c where Sterling_Quote__c IN:sterQuoteIds];
    
    if(sterQuoteIds.size() > 0)
        //listOfQuoteLineItem = [Select Id, Product_Material__r.Name, Product_Instance_ID__c, License_Metric__c, SAP_IO_User_Status__c, Sterling_Quote__c, Sterling_Quote__r.CA_CPQ_Quote_Number__c, CPQ_Quote_Number__c, Line_Number__c, Product_Name__c, Name, CA_Pricing_Group__c, Stated_Renewal_Fee__c, Total_Proposed_Price__c, Proposed_Lic_Sub_Fee__c, Proposed_Maint_Fee__c, Effective_Date__c, End_Date__c, Shipping_Required__c, Bus_Transaction_Type__c, Delivery_Method__c, Operating_System__c, Auth_Use_Model__c, License_Type__c, Total_Quantity__c, Monthly_Product_Fee_for_Subscriptionterm__c, Lic_Sub_off_List__c, Mainframe_Distributed__c, Volume_License_Subs_Fee__c, Volume_Maintenance_Price__c, Activity_Type__c,  Change_Hours_Units__c,  Charge_Code__c, Cost_Center__c, Discount__c,    Discount_Exceeds_Reason__c, End_Dateof_Project__c,  Estimated_Start_Date__c,    Exhibit_Comment__c, Expense_Amount_Included__c, GSA_Rate__c,    Hours_Units__c, List_Rate__c,   List_Rate_Revenue__c,   Planned_Project_Cost__c,    Planned_Project_Revenue__c, PO_Number__c,   Product_1__c,   Product_1_Percent__c,   Product_2__c,   Product_2_Percent__c,   Product_3__c,   Product_3_Percent__c,   Project_Bill_Rate__c,   Contracted_Rate_Used_1__c,  Project_Group__c,   Project_Type__c,    Role_Description__c,    SAP_Contract_Line_Number__c,    Project_Number__c,   Service_Offering__c,    Services_Flag__c,   SKU__c, Std_Cost__c,    Vendor_Overhead__c, VSOE_Rate__c ,No_Charge_Product__c ,Reason_for_no_charge__c from Quote_Product_Report__c where Sterling_Quote__c IN:sterQuoteIds];
        listOfQuoteLineItem = [Select Id, Product_Material__r.Name, Product_Instance_ID__c, License_Metric__c, SAP_IO_User_Status__c, Sterling_Quote__c, Sterling_Quote__r.CA_CPQ_Quote_Number__c, CPQ_Quote_Number__c, Line_Number__c, Product_Name__c, Name, CA_Pricing_Group__c, Stated_Renewal_Fee__c, Total_Proposed_Price__c, Proposed_Lic_Sub_Fee__c, Proposed_Maint_Fee__c, Effective_Date__c, End_Date__c, Shipping_Required__c, Bus_Transaction_Type__c, Delivery_Method__c, Operating_System__c, Auth_Use_Model__c, License_Type__c, Total_Quantity__c, Monthly_Product_Fee_for_Subscriptionterm__c, Lic_Sub_off_List__c, Mainframe_Distributed__c, Volume_License_Subs_Fee__c, Volume_Maintenance_Price__c, Activity_Type__c,  Change_Hours_Units__c,  Charge_Code__c, Cost_Center__c, Discount__c,    Discount_Exceeds_Reason__c, End_Dateof_Project__c,  Estimated_Start_Date__c,    Exhibit_Comment__c, Expense_Amount_Included__c, GSA_Rate__c,    Hours_Units__c, List_Rate__c,   List_Rate_Revenue__c,   Planned_Project_Cost__c,    Planned_Project_Revenue__c, PO_Number__c,   Product_1__c,   Product_1_Percent__c,   Product_2__c,   Product_2_Percent__c,   Product_3__c,   Product_3_Percent__c,   Project_Bill_Rate__c,   Contracted_Rate_Used_1__c,  Project_Group__c,   Project_Type__c,    Role_Description__c,    SAP_Contract_Line_Number__c,    Project_Number__c,   Service_Offering__c,    Services_Flag__c,   SKU__c, Std_Cost__c,    Vendor_Overhead__c, VSOE_Rate__c ,No_Charge_Product__c ,Reason_for_no_charge__c,New_Additional_Quantity__c,Existing_Quantity__c,SpecialMetricUsageQtyNewAdditional__c,Special_Metric_Usage_Qty_Existing__c,Project_Description__c from Quote_Product_Report__c where Sterling_Quote__c IN:sterQuoteIds];
        //tensor changes
        if(SBQuoteIds.size()>0){
     //   SBquoteLineItemsList= [Select ID,Quote__c,Discount_form__c,Start_Date__c,End_Date__c,CA_License_Type__c,Quote_Line_Number_SAP__c,Monthly_Unit_Price__c,SAP_Operating_System__c,Pricing_Group__c,SBQQ__Product__c,SBQQ__ProductName__c,Net_Total_Form__c,CA_License_Cert__c,SBQQ__Quantity__c,Volume_Discount_Price_form__c,SBQQ__Quote__c,Quantity_Prior__c,SBQQ__NetTotal__c from SBQQ__QuoteLine__c where SBQQ__Quote__c IN: SBQuoteIds];
      SBquoteLineItemsList= [Select ID,Name,Quote__c,SBQQ__Number__c,Discount_form__c,SBQQ__PriorQuantity__c ,Maintenance_Product__c,Maintenance_Parent_Quote_Line__c,Start_Date__c,End_Date__c,CA_License_Type__c,Quote_Line_Number_SAP__c,Monthly_Unit_Price__c,SAP_Operating_System__c,Pricing_Group__c,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__NetTotal__c,Net_Total_Form__c,CA_License_Cert__c,SBQQ__Quantity__c,Volume_Discount_Price_form__c,SBQQ__Quote__c,Quantity_Prior__c,
                                                         SBQQ__ProductCode__c,  License_Metric_CPQ__c,Instance_ID__c,toLabel(Auth_Use_Mode__c) Auth_Use_Mode__cLabel,Business_Transaction_Type_SAP__c,Parent_Bundle__c from SBQQ__QuoteLine__c where SBQQ__Quote__c IN: SBQuoteIds];
            PaymentPlanList=[Select ID,Quote__c,Quote__r.Name,Date__c,License_Amount_CLM__c,Maintenance_Amount_CLM__c,Subscription_Amount_CLM__c,Education_Amount_CLM__c,Services_Amount_CLM__c,Amount_CLM__c,Payment_Schedule_Total__c,Amount__c from Payment_Plan__c where Quote__c IN: SBQuoteIds];
        }//end
            
            List<Agreement_Payment_Plan__c> listOfAgrPaymentPlanToInsert = new List<Agreement_Payment_Plan__c>();
            List<Apttus__AgreementLineItem__c> listOfAgrLineItemsToInsert = new List<Apttus__AgreementLineItem__c>();  
            system.debug('listOfQuotePaymentPlan****'+listOfQuotePaymentPlan);
            system.debug('listOfQuoteLineItem *****'+listOfQuoteLineItem ); 
            for(Apttus__APTS_Agreement__c agr:newAgreement){
                if(listOfQuotePaymentPlan.size()>0){
                    for(PaymentPlan__c pp : listOfQuotePaymentPlan){
                         Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                        app.CA_Committed_Payments__c = pp.Committed_Payment__c;
                        if(app.CA_Committed_Payments__c> 0){
                    app.CommittedPaymentsText__c=Currencyformat(string.valueOf(app.CA_Committed_Payments__c),agr.CurrencyIsoCode) ;
                }
                        
                        
                        app.CPQ_Quote_Number__c = pp.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                        app.Date_Text__c = pp.Date_Text__c;
                        app.CA_License_Payment__c = pp.License_Payment__c;
                        if(app.CA_License_Payment__c> 0){
                    app.LicenseText__c=Currencyformat(string.valueOf(app.CA_License_Payment__c),agr.CurrencyIsoCode) ;
                }
                        app.Maintenance_Payment__c = pp.Maintenance_Payment__c;
                        if(app.Maintenance_Payment__c> 0){
                            system.debug('app.Maintenance_Payment__c'+app.Maintenance_Payment__c);
                    app.MaintenanceText__c=Currencyformat(string.valueOf(app.Maintenance_Payment__c),agr.CurrencyIsoCode) ;
                }
                        app.CA_Payment_Date__c = pp.Payment_Date__c;
                        app.CA_Payment_Plan_Id__c = pp.Id;
                        app.Payment_Total__c = pp.Payment_Total__c;
                        if(app.Payment_Total__c> 0){
                            system.debug('app.Payment_Total__c'+app.Payment_Total__c);
                    app.PaymentTotaltext__c=Currencyformat(string.valueOf(app.Payment_Total__c),agr.CurrencyIsoCode) ;
                }
                        app.Payment_Type__c = pp.Payment_Type__c;
                        app.Services_Payment__c = pp.Services_Payment__c;
                        if(app.Services_Payment__c> 0){
                    app.EducationPaymentsText__c=Currencyformat(string.valueOf(app.Services_Payment__c),agr.CurrencyIsoCode) ;
                }
                        app.Subscription_Payment__c = pp.Subscription_Payment__c;
                        if(app.Subscription_Payment__c> 0){
                    app.SubscriptionText__c=Currencyformat(string.valueOf(app.Subscription_Payment__c),agr.CurrencyIsoCode) ;
                }
                        
                        app.Initial_Payment__c = pp.Initial_Payment__c;
                    /*     if(app.Initial_Payment__c> 0){
                    app.InitialPaymentText__c=Currencyformat(string.valueOf(app.Initial_Payment__c),agr.CurrencyIsoCode) ;
                } */
                        app.Milestone_Description__c = pp.Milestone_Description__c;
                        app.Milestone_Number__c = pp.Milestone_Number__c;
                        app.Number_of_Milestones__c = pp.Number_of_Milestones__c;
                        app.Payment_Of_Total__c = pp.Payment_Percent_Of_Total__c;
                       /* if(app.Payment_Of_Total__c> 0){
                        app.PaymentOfTotalText__c=Currencyformat(string.valueOf(app.Payment_Of_Total__c),agr.CurrencyIsoCode) ;
                }  */
                        app.Payment_Amount__c = pp.Payment_Amount__c;
                        if(app.Payment_Amount__c> 0){
                    app.PaymentAmountText__c=Currencyformat(string.valueOf(app.Payment_Amount__c),agr.CurrencyIsoCode) ;
                }
                        app.CA_Payment_Date_Services__c = pp.Payment_Date_Services__c;
                        app.Project_ID__c = pp.Project_ID__c;
                        app.sfxId__c = pp.sfxId__c;
                        app.Total_Payments__c = pp.Total_Payments__c;
                        if(app.Total_Payments__c> 0){
                    app.TotalPaymenttext__c=Currencyformat(string.valueOf(app.Total_Payments__c),agr.CurrencyIsoCode) ;
                }
                        app.Agreement__c = agr.Id;
                        app.CurrencyIsoCode = agr.CurrencyIsoCode;
                        
                        listOfAgrPaymentPlanToInsert.add(app);
                    }
                }
                if(listOfQuoteLineItem.size()>0){
                    for(Quote_Product_Report__c qi: listOfQuoteLineItem){
                        if(!(qi.No_Charge_Product__c!=null && qi.No_Charge_Product__c=='Y' && qi.Reason_for_no_charge__c!=null && qi.Reason_for_no_charge__c!='Stabilized'))
                        {
                            Apttus__AgreementLineItem__c alitem = new Apttus__AgreementLineItem__c();
                            alitem.CA_Auth_Use_Model__c = qi.Auth_Use_Model__c;
                            alitem.CA_Bus_Transaction_Type__c = qi.Bus_Transaction_Type__c;
                            //change for New/Additional quantity change
                            alitem.New_Additional_Quantity__c= qi.New_Additional_Quantity__c;
                            alitem.Existing_Quantity__c= qi.Existing_Quantity__c;
                            
                            //Added by Jagan for Use Limitation and Special Metric usage Qty fields population
                            alitem.SpecialMetricsUsageQtyNewAdditional__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                            alitem.SpecialMetricsUsageQtyExisting__c=qi.Special_Metric_Usage_Qty_Existing__c;
                            
                            if(qi.Bus_Transaction_Type__c!=null)
                            {
                                if(qi.Auth_Use_Model__c=='Special Metric')
                                {
                                    if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c=='Time - Product Migration'|| qi.Bus_Transaction_Type__c=='Time - Reinstatement')
                                    {
                                        alitem.Use_Limitation__c=qi.Special_Metric_Usage_Qty_Existing__c;
                                    }
                                    if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity' || qi.Bus_Transaction_Type__c=='Education')
                                    {
                                        alitem.Use_Limitation__c=qi.SpecialMetricUsageQtyNewAdditional__c;
                                    }
                                }
                                else
                                {
                                    if(qi.Bus_Transaction_Type__c=='Time'|| qi.Bus_Transaction_Type__c=='Time - Product Migration'|| qi.Bus_Transaction_Type__c=='Time - Reinstatement' || qi.Bus_Transaction_Type__c=='Mainframe Capacity' )
                                    {
                                        alitem.Use_Limitation__c=qi.Existing_Quantity__c;
                                    }
                                    if(qi.Bus_Transaction_Type__c=='New Product'|| qi.Bus_Transaction_Type__c=='Distributed Capacity'|| qi.Bus_Transaction_Type__c=='Mainframe Capacity')
                                    {
                                        alitem.Use_Limitation__c=qi.New_Additional_Quantity__c;
                                    }
                                }
                            }
                            //Ended by Jagan
                            //change ends
                            //change for svcs added by jagan
                                alitem.Project_Description__c=qi.Project_Description__c;
                                //change ends
                             alitem.CA_CPQ_Quote_Number_Quote_Number__c = qi.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                            alitem.CA_Delivery_Method__c = qi.Delivery_Method__c;
                            alitem.CA_Disc_off_List_License_Subs__c = qi.Lic_Sub_off_List__c;
                            alitem.CA_Effective_Date__c = qi.Effective_Date__c;
                            alitem.CA_End_Date__c = qi.End_Date__c;
                            alitem.CA_License_Type__c = qi.License_Type__c;
                            alitem.CA_Line_Number__c = qi.Line_Number__c;
                            alitem.CA_Mainframe_Distributed__c = qi.Mainframe_Distributed__c;
                            alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c = qi.Monthly_Product_Fee_for_Subscriptionterm__c;
                            alitem.CA_Operating_System__c = qi.Operating_System__c;
                            alitem.CA_Pricing_Group__c = qi.CA_Pricing_Group__c;
                            alitem.CA_Product_Code__c = qi.Product_Material__r.Name;
                            alitem.CA_Product_Name__c = qi.Product_Name__c;
                            alitem.CA_Proposed_Lic_Sub_Price__c = qi.Proposed_Lic_Sub_Fee__c;
                            //Currency format change 
                                if(alitem.CA_Proposed_Lic_Sub_Price__c>0){
                                alitem.ProposedLicSubPrice__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Lic_Sub_Price__c),agr.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Proposed_Maintenance_Price__c = qi.Proposed_Maint_Fee__c;
                            if(alitem.CA_Proposed_Maintenance_Price__c>0){
                                alitem.ProposedMaintenancePriceText__c=Currencyformat(string.valueOf(alitem.CA_Proposed_Maintenance_Price__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.Quote_Line_Item_Id__c = qi.Id;
                            alitem.CA_Shipping_Required__c = qi.Shipping_Required__c;
                            alitem.CA_Stated_Renewal_Price__c = qi.Stated_Renewal_Fee__c;
                            if(alitem.CA_Stated_Renewal_Price__c>0){
                                alitem.StatedRenewalPriceText__c=Currencyformat(string.valueOf(alitem.CA_Stated_Renewal_Price__c),agr.CurrencyIsoCode) ;
                                }
                            
                            alitem.CA_Total_Proposed_Price__c = qi.Total_Proposed_Price__c;
                            //Currency format change 
                                if(alitem.CA_Total_Proposed_Price__c>0){
                                alitem.TotalProposedPriceText__c=Currencyformat(string.valueOf(alitem.CA_Total_Proposed_Price__c),agr.CurrencyIsoCode) ;
                                }
                                //change ends
                            alitem.CA_Total_Quantity__c = qi.Total_Quantity__c;
                            alitem.CA_Volume_License_Subs_Price__c = qi.Volume_License_Subs_Fee__c;
                            alitem.CA_Volume_Maintenance_Price__c = qi.Volume_Maintenance_Price__c;
                            alitem.Activity_Type__c= qi.Activity_Type__c;
                            alitem.Change_Hours_Units__c= qi.Change_Hours_Units__c;
                            alitem.Charge_Code__c= qi.Charge_Code__c;
                            alitem.Cost_Center__c= qi.Cost_Center__c;
                            //alitem.CA_CPQ_Quote_Number_Quote_Number__c= qi.CPQ_Quote_Number__c;
                            alitem.Discount__c= qi.Discount__c;
                            alitem.Discount_Exceeds_Reason__c= qi.Discount_Exceeds_Reason__c;
                            alitem.End_Date_of_Project__c= qi.End_Dateof_Project__c;
                            alitem.Estimated_Start_Date__c= qi.Estimated_Start_Date__c;
                            alitem.Exhibit_Comment__c= qi.Exhibit_Comment__c;
                            alitem.Expense_Amount_Included__c= qi.Expense_Amount_Included__c;
                           // alitem.Expense_Amount_Included__c= qi.GSA_Rate__c;
                            if(alitem.Expense_Amount_Included__c>0){
                                alitem.Expense_Amount_Included_Text__c=Currencyformat(string.valueOf(alitem.Expense_Amount_Included__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.GSA_Rate__c= qi.GSA_Rate__c;
                            if(alitem.GSA_Rate__c>0){
                                alitem.GSARateText__c=Currencyformat(string.valueOf(alitem.GSA_Rate__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.Hours_Units__c= qi.Hours_Units__c;
                            alitem.List_Rate__c= qi.List_Rate__c;
                            if(alitem.List_Rate__c>0){
                                alitem.ListRateText__c=Currencyformat(string.valueOf(alitem.List_Rate__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.List_Rate_Revenue__c= qi.List_Rate_Revenue__c;
                            if(alitem.List_Rate_Revenue__c>0){
                                alitem.ListRateRevenueText__c=Currencyformat(string.valueOf(alitem.List_Rate_Revenue__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Cost__c= qi.Planned_Project_Cost__c;
                            if(alitem.Planned_Project_Cost__c>0){
                                alitem.PlannedProjectCostText__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.Planned_Project_Revenue__c= qi.Planned_Project_Revenue__c;
                            if(alitem.Planned_Project_Revenue__c>0){
                                alitem.PlannedProjectRevenuetext__c=Currencyformat(string.valueOf(alitem.Planned_Project_Cost__c),agr.CurrencyIsoCode) ;
                                }
                            alitem.PO_Number__c= qi.PO_Number__c;
                            alitem.Product_1__c= qi.Product_1__c;
                            alitem.Product_1_Percent__c= qi.Product_1_Percent__c;
                            alitem.Product_2__c= qi.Product_2__c;
                            alitem.Product_2_Percent__c= qi.Product_2_Percent__c;
                            alitem.Product_3__c= qi.Product_3__c;
                            alitem.Product_3_Percent__c= qi.Product_3_Percent__c;
                            alitem.Project_Bill_Rate__c= qi.Project_Bill_Rate__c;
                            if(alitem.Project_Bill_Rate__c>0){
                            alitem.ProjectBillRateText__c=Currencyformat(string.valueOf(alitem.Project_Bill_Rate__c),agr.CurrencyIsoCode) ;
                            }
                            alitem.Contracted_Rate_Used_1__c= qi.Contracted_Rate_Used_1__c;
                            alitem.Project_Group__c= qi.Project_Group__c;
                            alitem.Project_Type__c= qi.Project_Type__c;
                            alitem.Role_Description__c = qi.Role_Description__c;
                            alitem.SAP_Contract_Line_Number__c= qi.SAP_Contract_Line_Number__c;
                            alitem.Project_Number__c= qi.Project_Number__c;
                            alitem.SAP_IO_User_Status__c= qi.SAP_IO_User_Status__c;
                            alitem.Service_Offering__c= qi.Service_Offering__c;
                            alitem.Services_Flag__c= qi.Services_Flag__c;
                            alitem.SKU__c= qi.SKU__c;
                            alitem.Std_Cost__c= qi.Std_Cost__c;
                            if(alitem.Std_Cost__c>0){
                            alitem.StdCostText__c=Currencyformat(string.valueOf(alitem.Std_Cost__c),agr.CurrencyIsoCode) ;
                            }
                            alitem.Vendor_Overhead__c= qi.Vendor_Overhead__c;
                            alitem.VSOE_Rate__c= qi.VSOE_Rate__c;
                            if(alitem.VSOE_Rate__c>0){
                            alitem.VSOERateText__c=Currencyformat(string.valueOf(alitem.VSOE_Rate__c),agr.CurrencyIsoCode) ;
                            }
                            alitem.CA_License_Metric__c = qi.License_Metric__c;
                            alitem.Apttus__AgreementId__c = agr.Id;
                            alitem.CurrencyIsoCode = agr.CurrencyIsoCode;
                            alitem.CA_Product_Instance_ID__c = qi.Product_Instance_ID__c;
                            listOfAgrLineItemsToInsert.add(alitem);
                        }
                    } 
                }
                     if(SBquoteLineItemsList.size() > 0)
            {
                 for(SBQQ__QuoteLine__c SBQuote: SBquoteLineItemsList){
                     if(!SBQuote.Parent_Bundle__c){
                      Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                         if(SBQuote.Maintenance_Product__c=='Yes'){
                              if(SBQuote.Maintenance_Parent_Quote_Line__c!=null && SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c)!=null)
                              {
                                  alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c);
                              alitem.CA_Proposed_Maintenance_Price__c=SBQuote.Net_Total_Form__c;
                              alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                                  alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;	
                              SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Proposed_Maintenance_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                 SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Volume_Maintenance_Price__c=alitem.CA_Volume_Maintenance_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Total_Proposed_Price__c=alitem.CA_Total_Proposed_Price__c;
                                  agrLineItemToupdate.add(alitem);
                              } 
                          }
                         else{
                       alitem.CA_CPQ_Quote_Number_Quote_Number__c=SBQuote.Quote__c;
                       alitem.Apttus__AgreementId__c = agr.Id;
                       alitem.CA_Disc_off_List_License_Subs__c = SBQuote.Discount_form__c;
                       alitem.CA_Effective_Date__c = SBQuote.Start_Date__c;
                       alitem.CA_End_Date__c = SBQuote.End_Date__c;
                       alitem.CA_Line_Number__c = SBQuote.SBQQ__Number__c;
                       alitem.CA_License_Type__c=SBQuote.CA_License_Type__c;
                       alitem.CA_Monthly_ProductFeeforSubscriptionTerm__c=SBQuote.Monthly_Unit_Price__c;
                       alitem.CA_Operating_System__c=SBQuote.SAP_Operating_System__c;
                       alitem.CA_Pricing_Group__c=SBQuote.Pricing_Group__c;
                       alitem.CA_Product_Code__c=SBQuote.SBQQ__ProductCode__c;
                       alitem.CA_Product_Name__c=SBQuote.SBQQ__ProductName__c;
                       alitem.CA_Proposed_Lic_Sub_Price__c=SBQuote.Net_Total_Form__c;
                      // alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                             alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c;
                     if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                            
                     alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                          
                     alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                    if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null )
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                             alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                     if(alitem.CA_Bus_Transaction_Type__c!=null){
                    if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement'){
                            alitem.Existing_Quantity__c=SBQuote.SBQQ__Quantity__c;    
                            alitem.Use_Limitation__c=alitem.Existing_Quantity__c;
                        alitem.New_Additional_Quantity__c=null;
                        }

                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                     alitem.Use_Limitation__c = alitem.New_Additional_Quantity__c;
                     }
                     
                    //system.debug('SBQuote.Auth_Use_Mode__c 3rd '+ SBQuote.Auth_Use_Mode__c);
                     SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                       listOfAgrLineItemsToInsert.add(alitem);
                         } 
            }
                 }
            
        }
           if(PaymentPlanList.size()>0){
                for(Payment_Plan__c payp:PaymentPlanList){
                    Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                            
                       app.Agreement__c = agr.Id;
                       app.CPQ_Quote_Number__c=payp.Quote__r.Name;
                       app.CA_Payment_Date__c=payp.Date__c;
                       app.Payment_Total__c = payp.Amount__c;
                       app.CurrencyIsoCode = agr.CurrencyIsoCode;
                      //US482243 tensor h2 change start
                    app.CA_License_Payment__c= payp.License_Amount_CLM__c;
                    app.Maintenance_Payment__c=payp.Maintenance_Amount_CLM__c;
                    app.Subscription_Payment__c=payp.Subscription_Amount_CLM__c;
                    app.Services_Payment__c=payp.Education_Amount_CLM__c;
                    app.Payment_Amount__c=payp.Services_Amount_CLM__c;
                    app.Payment_Total__c=payp.Amount_CLM__c;
                    //change ends
                       listOfAgrPaymentPlanToInsert.add(app);
                }         
                    
                }
            }
            
            if(aggIdToDelete.size()>0){
                List<Agreement_Payment_Plan__c> agrPayPLanTodelete = new List<Agreement_Payment_Plan__c >();
                for(Agreement_Payment_Plan__c app: [Select id,Name,Agreement__r.id from Agreement_Payment_Plan__c where Agreement__r.id in:aggIdToDelete and CA_Is_this_Payment_Plan_Manually_Added__c = false ]){
                    agrPayPLanTodelete.add(app);
                }
                if(agrPayPLanTodelete.size()>0){
                    delete agrPayPLanTodelete;
                }
                List<Apttus__AgreementLineItem__c> agrLineItemTodelete = new List<Apttus__AgreementLineItem__c>();
                for(Apttus__AgreementLineItem__c alitem: [Select id,Name,Apttus__AgreementId__r.id from Apttus__AgreementLineItem__c where Apttus__AgreementId__r.id IN:aggIdToDelete ]){
                    agrLineItemTodelete.add(alitem);
                }
                if(agrLineItemTodelete.size()>0){
                    delete agrLineItemTodelete ;
                }
            }
            system.debug('oldQuoteIds*****'+oldQuoteIds);
            if(oldQuoteIds.size()>0){
                List<scpq__SciQuote__c> sterlingQuoteList = new List<scpq__SciQuote__c>();
                sterlingQuoteList = [Select id,Name,CA_CPQ_Quote_Number__c from scpq__SciQuote__c where id in:oldQuoteIds];
                Set<String> cpqNumbers = new Set<String>();
                if(sterlingQuoteList .size()>0){
                    for(scpq__SciQuote__c ster:sterlingQuoteList){
                        cpqNumbers.add(ster.CA_CPQ_Quote_Number__c );
                    }
                    
                    system.debug('cpqNumbers&&&&&'+cpqNumbers);
                    List<Agreement_Payment_Plan__c> agrPayPLanTodeleteOnUpdate = new List<Agreement_Payment_Plan__c >();
                    List<Apttus__AgreementLineItem__c> listOfAgrLineItemsToDelete = new List<Apttus__AgreementLineItem__c>();
                    for(Agreement_Payment_Plan__c app: [Select id,Name,CPQ_Quote_Number__c from Agreement_Payment_Plan__c where CPQ_Quote_Number__c in:cpqNumbers]){
                        agrPayPLanTodeleteOnUpdate.add(app);
                    } 
                    for(Apttus__AgreementLineItem__c alitem: [Select id,Name,CA_CPQ_Quote_Number_Quote_Number__c from Apttus__AgreementLineItem__c where CA_CPQ_Quote_Number_Quote_Number__c in:cpqNumbers]){
                        listOfAgrLineItemsToDelete.add(alitem);
                    }  
                    system.debug('listOfAgrLineItemsToDelete****'+listOfAgrLineItemsToDelete);
                    system.debug('agrPayPLanTodeleteOnUpdate****'+agrPayPLanTodeleteOnUpdate);     
                    if(agrPayPLanTodeleteOnUpdate.size()>0){
                        delete agrPayPLanTodeleteOnUpdate;
                    }
                    if(listOfAgrLineItemsToDelete.size()>0){
                        delete listOfAgrLineItemsToDelete;
                    }
                }
            }
            system.debug('oldSBQuoteIds: '+oldSBQuoteIds);
            if(oldSBQuoteIds.size()>0){
                List<SBQQ__Quote__c> SBQuoteList=[Select id,Name from SBQQ__Quote__c where id in:oldSBQuoteIds];
                Set<String> SFQuoteNames= new Set<String>();
                for(SBQQ__Quote__c SFQuote: SBQuoteList){
                    SFQuoteNames.add(SFQuote.Name);
                }
                system.debug('SFQuoteNames: '+SFQuoteNames);
                List<Apttus__AgreementLineItem__c> LinesDeleteOnUpdate=new List<Apttus__AgreementLineItem__c>();
                List<Agreement_Payment_Plan__c> PaymentPlansToDeleteOnUpdate=new List<Agreement_Payment_Plan__c>();
                Set<ID> agrIds=new Set<ID>();
                for(Apttus__APTS_Agreement__c agrem: newAgreement )
                {
                    agrIds.add(agrem.id);
               // List<Apttus__AgreementLineItem__c> LinesDeleteOnUpdate=[Select id,name,CA_CPQ_Quote_Number_Quote_Number__c from Apttus__AgreementLineItem__c where CA_CPQ_Quote_Number_Quote_Number__c IN:SFQuoteNames ];
               // List<Agreement_Payment_Plan__c> PaymentPlansToDeleteOnUpdate=[Select id,name,CPQ_Quote_Number__c from Agreement_Payment_Plan__c where CPQ_Quote_Number__c In:SFQuoteNames];
                }
               LinesDeleteOnUpdate=[Select id,name,CA_CPQ_Quote_Number_Quote_Number__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c IN :agrIds and CA_CPQ_Quote_Number_Quote_Number__c IN: SFQuoteNames ];
               PaymentPlansToDeleteOnUpdate=[Select id,name,CPQ_Quote_Number__c from Agreement_Payment_Plan__c where Agreement__c IN: agrIds and CPQ_Quote_Number__c IN: SFQuoteNames];
                
                if(LinesDeleteOnUpdate.size()>0){
                    delete LinesDeleteOnUpdate;
                }
                if(PaymentPlansToDeleteOnUpdate.size()>0){
                    delete PaymentPlansToDeleteOnUpdate;
                }
            }
            system.debug('listOfAgrPaymentPlanToInsert*****'+listOfAgrPaymentPlanToInsert);
            system.debug('listOfAgrLineItemsToInsert*****'+listOfAgrLineItemsToInsert);
            if(listOfAgrPaymentPlanToInsert.size()>0){
                insert listOfAgrPaymentPlanToInsert;
            }
            if(listOfAgrLineItemsToInsert.size()>0){
                insert listOfAgrLineItemsToInsert;          
            }
            if(agrLineItemToupdate.size()>0){
                update agrLineItemToupdate;
            }
        }Catch(Exception e){
            e.getMessage();
        }
    }
    //This method is insert Payment lineitems whenever any "Additional quote numbers " are added.
    public static void insertPaymentLineItemFromAdditionalQuotes(List<Apttus__APTS_Agreement__c> newAgrList,Map<id,Apttus__APTS_Agreement__c> oldAgrMap){
        try{
             Map<Apttus__APTS_Agreement__c,set<String>> mapTobeInserted = new Map<Apttus__APTS_Agreement__c,set<String>>();
         Map<Apttus__APTS_Agreement__c,set<String>> mapTobeInsertedSF = new Map<Apttus__APTS_Agreement__c,set<String>>();
    set<String> setTobedeleted = new set<String>();
    set<String> uniqueSet = new set<String>();
    Set<String> setOld = new Set<String>();
    Set<String> setNew = new Set<String>();
        set<String> setTobedeletedSF = new set<String>();
    set<String> uniqueSetSF = new set<String>();
    Set<String> setOldSF = new Set<String>();
    Set<String> setNewSF = new Set<String>();
    Map<String ,List<PaymentPlan__c>> mapQuotePaymentPlan = new Map<String ,List<PaymentPlan__c>>();
         Map<String ,List<Payment_Plan__c>> mapQuotePaymentPlanSF = new Map<String ,List<Payment_Plan__c>>();
    System.debug('inside method');
    for(Apttus__APTS_Agreement__c newagr:newAgrList){
        if(oldAgrMap!=null && newagr != null && oldAgrMap.get(newagr.Id)!=null){
          if((oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!= newagr.CA_Additional_Quote_Numbers__c) ||(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!= newagr.Additional_Salesforce_Quote_Numbers__c) || ((newagr.Apttus__Status_Category__c == Label.In_Authoring && (oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.In_Approval || oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.Approved || oldAgrMap.get(newagr.Id).Apttus__Status_Category__c == Label.In_Effect)))){
               if(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!=null && oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c.contains(',')){
               system.debug('1111111111111111');
                 setOld.addAll(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c.split(','));
               }
               if(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!=null && oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c.contains(',')){
               system.debug('1111111111111111');
                 setOld.addAll(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c.split(','));
               }
               else if(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c!=null){
               system.debug('22222222222');
                 setOld.add(oldAgrMap.get(newagr.Id).CA_Additional_Quote_Numbers__c);
               }
              else if(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c!=null){
               system.debug('22222222222');
                 setOldSF.add(oldAgrMap.get(newagr.Id).Additional_Salesforce_Quote_Numbers__c);
               }
                if(newagr.CA_Additional_Quote_Numbers__c!=null && newagr.CA_Additional_Quote_Numbers__c.contains(',')){
                system.debug('333333333333');
                 setNew.addAll(newagr.CA_Additional_Quote_Numbers__c.split(','));
               }
              if(newagr.Additional_Salesforce_Quote_Numbers__c!=null && newagr.Additional_Salesforce_Quote_Numbers__c.contains(',')){
                system.debug('333333333333');
                 setNewSF.addAll(newagr.Additional_Salesforce_Quote_Numbers__c.split(','));
               }
               else if(newagr.CA_Additional_Quote_Numbers__c!=null){
               system.debug('4444444444444444');
                 setNew.add(newagr.CA_Additional_Quote_Numbers__c);
               }
              else if(newagr.Additional_Salesforce_Quote_Numbers__c!=null){
               system.debug('4444444444444444');
                 setNewSF.add(newagr.Additional_Salesforce_Quote_Numbers__c);
               }
               
               mapTobeInserted.put(newagr,setnew);
              mapTobeInsertedSF.put(newagr,setnewSF);
               System.debug('****oldnewvalues_LineItem  '+setold+'****'+setnew);
               setTobedeleted.addAll(setold);
              setTobedeleted.addAll(setoldSF);
               uniqueSet.addAll(setnew);
              uniqueSetSF.addAll(setnewSF);
               system.debug('setTobedeleted&&&&&'+setTobedeleted);
               system.debug('setTobedeletedSF&&&&&'+setTobedeletedSF);
           }  
           else{
               if(newagr.CA_Additional_Quote_Numbers__c != null && oldAgrMap==null) {
                 if(newagr.CA_Additional_Quote_Numbers__c.contains(',')){
                     setNew.addAll(newagr.CA_Additional_Quote_Numbers__c.split(','));
                     system.debug('5555555555');
                   }
                   else{
                     setNew.add(newagr.CA_Additional_Quote_Numbers__c);
                     system.debug('666666666666666');
                   }
                 mapTobeInserted.put(newagr,setNew);
                 uniqueSet.addAll(setNew);
               }  
               if(newagr.Additional_Salesforce_Quote_Numbers__c != null && oldAgrMap==null) {
                 if(newagr.Additional_Salesforce_Quote_Numbers__c.contains(',')){
                     setNewSF.addAll(newagr.Additional_Salesforce_Quote_Numbers__c.split(','));
                     system.debug('5555555555');
                   }
                   else{
                     setNewSF.add(newagr.Additional_Salesforce_Quote_Numbers__c);
                     system.debug('666666666666666');
                   }
                 mapTobeInsertedSF.put(newagr,setNewSF);
                 uniqueSetSF.addAll(setNewSF);
               }  
           }
       }
    } 
        
           // List<PaymentPlan__c> listOfquoteLineItem = new List<PaymentPlan__c>();
            system.debug('Set New Values:::'+setNew);
            system.debug('Set Old Values:::'+setOld);
            system.debug('Unique Set Values:::'+uniqueSet);
            if(uniqueSet.size() > 0)
                for(PaymentPlan__c quoteProd: [Select id,Name,Payment_Date__c,Sterling_Quote__c,Committed_Payment__c,Sterling_Quote__r.CA_CPQ_Quote_Number__c,Date_Text__c,License_Payment__c,Maintenance_Payment__c, Payment_Total__c,Payment_Type__c, Services_Payment__c, Subscription_Payment__c, Initial_Payment__c, Milestone_Description__c, Milestone_Number__c, Number_of_Milestones__c, Payment_Percent_Of_Total__c, Payment_Amount__c, Payment_Date_Services__c, Project_ID__c, sfxId__c, Total_Payments__c  from PaymentPlan__c where Sterling_Quote__r.CA_CPQ_Quote_Number__c in: uniqueSet]){
                    if(mapQuotePaymentPlan !=null && mapQuotePaymentPlan .containsKey(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c)){
                        List<PaymentPlan__c> lst= mapQuotePaymentPlan .get(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c);
                        lst.add(quoteProd);
                        mapQuotePaymentPlan .put(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c ,lst );
                    }
                    else{
                        List<PaymentPlan__c> lst= new List<PaymentPlan__c>();
                        lst.add(quoteProd);
                        mapQuotePaymentPlan .put(quoteProd.Sterling_Quote__r.CA_CPQ_Quote_Number__c , lst);
                    }
                }
            List<Agreement_Payment_Plan__c > listOfAgrPaymentPlanToInsert= new List<Agreement_Payment_Plan__c >();   
            system.debug('mapQuotePaymentPlan Values:::'+mapQuotePaymentPlan);
            for(Apttus__APTS_Agreement__c newagr:mapTobeInserted.keySet()){
                System.debug('**********'+mapTobeInserted.get(newagr));
                for(String quoteNumber: mapTobeInserted.get(newagr)){
                    if(mapQuotePaymentPlan !=null && mapQuotePaymentPlan .containsKey(quoteNumber)){
                        for(PaymentPlan__c qpay:mapQuotePaymentPlan.get(quoteNumber)){
                            system.debug('^^^^.....');
                             Agreement_Payment_Plan__c agPay = new Agreement_Payment_Plan__c();
                            agPay.Agreement__c = newagr.id;
                            agPay.CurrencyIsoCode = newagr.CurrencyIsoCode;
                            agPay.CA_Committed_Payments__c = qpay.Committed_Payment__c;
                            if(agPay.CA_Committed_Payments__c> 0){
                    agPay.CommittedPaymentsText__c=Currencyformat(string.valueOf(agPay.CA_Committed_Payments__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.CPQ_Quote_Number__c = qpay.Sterling_Quote__r.CA_CPQ_Quote_Number__c;
                            agPay.Date_Text__c = qpay.Date_Text__c;
                            agPay.CA_Payment_Date__c = qpay.Payment_Date__c;
                            agPay.CA_License_Payment__c = qpay.License_Payment__c;
                            if(agPay.CA_License_Payment__c> 0){
                    agPay.LicenseText__c=Currencyformat(string.valueOf(agPay.CA_License_Payment__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.Maintenance_Payment__c = qpay.Maintenance_Payment__c;
                            if(agPay.Maintenance_Payment__c> 0){
                    agPay.MaintenanceText__c=Currencyformat(string.valueOf(agPay.Maintenance_Payment__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.Payment_Total__c = qpay.Payment_Total__c;
                             if(agPay.Payment_Total__c> 0){
                    agPay.PaymentTotaltext__c=Currencyformat(string.valueOf(agPay.Payment_Total__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.Payment_Type__c = qpay.Payment_Type__c;
                            agPay.Services_Payment__c = qpay.Services_Payment__c;
                            if(agPay.Services_Payment__c> 0){
                    agPay.EducationPaymentsText__c=Currencyformat(string.valueOf(agPay.Services_Payment__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.Subscription_Payment__c = qpay.Subscription_Payment__c;
                             if(agPay.Subscription_Payment__c> 0){
                    agPay.SubscriptionText__c=Currencyformat(string.valueOf(agPay.Subscription_Payment__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.Initial_Payment__c = qpay.Initial_Payment__c;
                        /*    if(agPay.Initial_Payment__c> 0){
                    agPay.InitialPaymentText__c=Currencyformat(string.valueOf(agPay.Initial_Payment__c),newagr.CurrencyIsoCode) ;
                }*/
                            agPay.Milestone_Description__c = qpay.Milestone_Description__c;
                            agPay.Milestone_Number__c = qpay.Milestone_Number__c;
                            agPay.Number_of_Milestones__c = qpay.Number_of_Milestones__c;
                            agPay.Payment_Of_Total__c = qpay.Payment_Percent_Of_Total__c;
                           /* if(agPay.Payment_Of_Total__c> 0){
                        agPay.PaymentOfTotalText__c=Currencyformat(string.valueOf(agPay.Payment_Of_Total__c),newagr.CurrencyIsoCode) ;
                } */
                            agPay.Payment_Amount__c = qpay.Payment_Amount__c;
                            if(agPay.Payment_Amount__c> 0){
                    agPay.PaymentAmountText__c=Currencyformat(string.valueOf(agPay.Payment_Amount__c),newagr.CurrencyIsoCode) ;
                }
                            agPay.CA_Payment_Date_Services__c = qpay.Payment_Date_Services__c;
                            agPay.Project_ID__c = qpay.Project_ID__c;
                            agPay.sfxId__c = qpay.sfxId__c;
                            agPay.Total_Payments__c = qpay.Total_Payments__c;
                            if(agPay.Total_Payments__c> 0){
                    agPay.TotalPaymenttext__c=Currencyformat(string.valueOf(agPay.Total_Payments__c),newagr.CurrencyIsoCode) ;
                }
                            listOfAgrPaymentPlanToInsert.add(agPay);
                        }
                    }   
                }
            }
            
             if(uniqueSetSF.size() > 0){
             for(Payment_Plan__c SBQuotePay: [Select ID,Quote__c,Quote__r.Name,Date__c,License_Amount_CLM__c,Maintenance_Amount_CLM__c,Subscription_Amount_CLM__c,Education_Amount_CLM__c,Payment_Schedule_Total__c,Amount__c from Payment_Plan__c where Quote__r.Name IN: uniqueSetSF]){
                 if(mapQuotePaymentPlanSF !=null && mapQuotePaymentPlanSF.containsKey(SBQuotePay.Quote__r.Name)){
              List<Payment_Plan__c> lst= mapQuotePaymentPlanSF.get(SBQuotePay.Quote__r.Name);
              lst.add(SBQuotePay);
              mapQuotePaymentPlanSF.put(SBQuotePay.Quote__r.Name ,lst);
          }
          else{
            List<Payment_Plan__c> lst= new List<Payment_Plan__c>();
            lst.add(SBQuotePay);
            mapQuotePaymentPlanSF.put(SBQuotePay.Quote__r.Name ,lst);
          }
        }
            for(Apttus__APTS_Agreement__c newagr:mapTobeInsertedSF.keySet()){
                if(mapTobeInsertedSF.get(newagr)!=null)
            for(String quotenumber:mapTobeInsertedSF.get(newagr)){
                for(Payment_Plan__c SBquotePay:mapQuotePaymentPlanSF.get(quotenumber) )
                {
                    Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                            
                       app.Agreement__c = newagr.Id;
                       app.CPQ_Quote_Number__c=SBquotePay.Quote__r.Name;
                       app.CA_Payment_Date__c=SBquotePay.Date__c;
                       app.Payment_Total__c = SBquotePay.Amount__c;
                       app.CurrencyIsoCode = newagr.CurrencyIsoCode;
                      //US482243 tensor h2 change start
                    app.CA_License_Payment__c= SBquotePay.License_Amount_CLM__c;
                    app.Maintenance_Payment__c=SBquotePay.Maintenance_Amount_CLM__c;
                    app.Subscription_Payment__c=SBquotePay.Subscription_Amount_CLM__c;
                    app.Services_Payment__c=SBquotePay.Education_Amount_CLM__c;
                    app.Payment_Amount__c=SBquotePay.Services_Amount_CLM__c;
                    app.Payment_Total__c=SBquotePay.Amount_CLM__c;
                    //change ends
                       listOfAgrPaymentPlanToInsert.add(app);
                }
            }
            } 
        }
        
            
            
            System.debug('*******setTobedeleted'+setTobedeleted);
            List<Agreement_Payment_Plan__c > lstTobeDeleted = new List<Agreement_Payment_Plan__c >();
            if(setTobedeleted.size() > 0)
                for(Agreement_Payment_Plan__c lineItem : [select id,CPQ_Quote_Number__c,Agreement__r.Sterling_Quote__r.CA_CPQ_Quote_Number__c,Agreement__r.SF_Quote__r.Name from Agreement_Payment_Plan__c where CPQ_Quote_Number__c in: setTobedeleted]){
                   //if(lineItem.Agreement__r.Sterling_Quote__r.CA_CPQ_Quote_Number__c!=null && lineItem.CPQ_Quote_Number__c  != lineItem.Agreement__r.Sterling_Quote__r.CA_CPQ_Quote_Number__c){
                     //   lstTobeDeleted.add(lineItem );
              //          if(lineItem.Agreement__r.SF_Quote__r.Name!=null && lineItem.CPQ_Quote_Number__c  != lineItem.Agreement__r.SF_Quote__r.Name){
              lstTobeDeleted.add(lineItem );
            //}
                    //}
    }
            System.debug('*******lstTobeDeleted'+lstTobeDeleted);
            delete lstTobeDeleted;
            
            system.debug('listOfAgrPaymentPlanToInsert******'+listOfAgrPaymentPlanToInsert);
            if(listOfAgrPaymentPlanToInsert.size()>0){
                insert listOfAgrPaymentPlanToInsert;
            }
        }Catch(Exception e){
            e.getMessage();
        }
        
    }
    //This method is created to Copy the Agreement POB records from Parent to Child Agreement
    public  static void insertAgreementPOBtoChildAgreement(List<Apttus__APTS_Agreement__c> newAgrList,Map<id,Apttus__APTS_Agreement__c> oldAgrMap) {
        System.debug('*****Entering the insertAgreementPOBtoChildAgreement method');
        for(Apttus__APTS_Agreement__c agmtSO: newAgrList) {
            CA_AgreementPOBUtility.prepareAndInsertAgreementPOBs(agmtSO,oldAgrMap.get(agmtSO.id));
        }
        System.debug('*****Exiting the insertAgreementPOBtoChildAgreement method');
    }
    //This method is to update Parent POB when child POB is activated US463225,US444873
    public static void updateParentPOB(list<Apttus__APTS_Agreement__c> agrlist, Map<id,Apttus__APTS_Agreement__c> oldMapValue){
        Set<Id> agrids=new Set<Id>();
        Set<Id> pobIds= new Set<Id>();
        List<Agreement_POB__c> ParentPOBListToBeUpdated=new List<Agreement_POB__c>();
        List<Agreement_POB__c> POBList=new List<Agreement_POB__c>();
        Map<Id,Agreement_POB__c> ParentPOBtoChild=new Map<Id,Agreement_POB__c>();
        for(Apttus__APTS_Agreement__c agr:agrlist){
            system.debug('agr.Apttus__Status__c : '+agr.Apttus__Status__c);
            system.debug('oldMapValue.get(agr.Id).Apttus__Status__c : '+oldMapValue.get(agr.Id).Apttus__Status__c);
            if(agr.Apttus__Status__c=='Activated' && oldMapValue.get(agr.Id).Apttus__Status__c!=agr.Apttus__Status__c){
                agrids.add(agr.Id);
            }
            }
        system.debug('agrids : '+agrids);
          List<Agreement_POB__c> listPoB=new List<Agreement_POB__c>();
     if(agrids.size()>0){
        for(Agreement_POB__c pob : [Select Credit_Amount__c,(Select Id,Credit_Amount__c,Credit_Amount_Percent__c,Effective_Date__c,Expiration_Date__c,Perpetual__c,CommentsLong__c,Parent_Agreement_POB__c,Related_Agreement_POB__c,Agreement__r.CA_Agreement_Type__c,POB_modified__c,Updated_from_child__c,Has_POB_Changed__c from Related_Agreement_POBs__r),(Select Id,Credit_Amount__c,Credit_Amount_Percent__c,Effective_Date__c,Expiration_Date__c,Perpetual__c,CommentsLong__c,Parent_Agreement_POB__c,Related_Agreement_POB__c,Agreement__r.CA_Agreement_Type__c,POB_modified__c,Updated_from_child__c,Has_POB_Changed__c from Parent_Agreement_POBs__r),Credit_Amount_Percent__c,Effective_Date__c,Expiration_Date__c,Perpetual__c,CommentsLong__c,Parent_Agreement_POB__c,Related_Agreement_POB__c,LastModifiedDate, LastModifiedBy.name from Agreement_POB__c where Has_POB_Changed__c='Yes' AND Agreement__c IN: agrids]){
            if(pob.Parent_Agreement_POB__c!=null){
            ParentPOBtoChild.put(pob.Parent_Agreement_POB__c,pob);
            listPoB.addAll(pob.Parent_Agreement_POBs__r);    
            }
            else if(pob.Related_Agreement_POB__c!=null)
            {
             ParentPOBtoChild.put(pob.Related_Agreement_POB__c,pob);
                listPoB.addAll(pob.Related_Agreement_POBs__r);  
            }
        }
	 }
        system.debug('pobIds : '+pobIds);
        for(Agreement_POB__c ParentPob:listPoB)
        {
            system.debug('ParentPob.Agreement__r.CA_Agreement_Type__c : '+ParentPob.Agreement__r.CA_Agreement_Type__c);
            if(ParentPob.Agreement__r.CA_Agreement_Type__c=='Foundation/Module'){
            ParentPob.Credit_Amount__c=ParentPOBtoChild.get(ParentPob.Id).Credit_Amount__c;
            ParentPob.Credit_Amount_Percent__c=ParentPOBtoChild.get(ParentPob.Id).Credit_Amount_Percent__c;
            ParentPob.Effective_Date__c=ParentPOBtoChild.get(ParentPob.Id).Effective_Date__c;
            ParentPob.Expiration_Date__c=ParentPOBtoChild.get(ParentPob.Id).Expiration_Date__c;
            ParentPob.CommentsLong__c=ParentPOBtoChild.get(ParentPob.Id).CommentsLong__c;
            ParentPob.Updated_from_child__c=ParentPOBtoChild.get(ParentPob.Id).LastModifiedBy.name+' ' +string.valueOf(ParentPOBtoChild.get(ParentPob.Id).LastModifiedDate);
            ParentPob.POB_modified__c=true;
            ParentPob.Has_POB_Changed__c='Yes';
                system.debug('success');
                
            }
            else if(ParentPob.Agreement__r.CA_Agreement_Type__c!='NDA'){
                ParentPob.POB_modified__c=true;
               // ParentPob.Has_POB_Changed__c='Yes';
                ParentPob.Updated_from_child__c=ParentPOBtoChild.get(ParentPob.Id).LastModifiedBy.name+' ' +string.valueOf(ParentPOBtoChild.get(ParentPob.Id).LastModifiedDate);
 }
            ParentPOBListToBeUpdated.add(ParentPob);
        }
        system.debug('ParentPOBListToBeUpdated : '+ParentPOBListToBeUpdated);
        if(ParentPOBListToBeUpdated.size()>0)
            update ParentPOBListToBeUpdated;
    }
    
     //this method is to display required currency format
    public static String Currencyformat(String string1, String CurrencyISOCode){
        String string2=',';
                    
                    integer l= string1.length()-3;
                    for(integer i=l-3;i>0;i=i-3){
                        if(i>0){
                            string1=string1.substring(0, i) + string2 + string1.substring(i, string1.length());
                            system.debug('string1'+string1);
                        }
                    }
                    
                
                        List<CLM_CurrencyCodes_Symbols__c> cslist = CLM_CurrencyCodes_Symbols__c.getAll().values(); 
                   
                   // String tomatch= agr.CA_Country__c.substring(0,2) + '-' + agr.CurrencyIsoCode;
                        for(CLM_CurrencyCodes_Symbols__c c : cslist) {
                            //system.debug('c.Name '+c.Name);
                            //system.debug('tomatch '+tomatch);
                            if(c.CurrencyCode__c.containsIgnoreCase(CurrencyISOCode)){
                               //string1=c.CurrencyCode__c +' '+ string1 + ' ' + c.CurrencySymbol__c;
                                 if(c.CurrencyCode__c=='CHF'){
                                     string1=(string1.substring(0, string1.length()-2)).replace(',','\'')+string1.substring(string1.length()-2, string1.length());
                                }

                                else if(c.CurrencyCode__c=='JPY'||c.CurrencyCode__c=='KRW'){
                                    string1=string1.substring(0,string1.length()-3);
                                }
                                else if((c.CurrencyCode__c=='EUR' && c.CountryCode__c!='IE')||c.CurrencyCode__c=='CZK'||c.CurrencyCode__c=='DKK'
                                       ||c.CurrencyCode__c=='NOK'||c.CurrencyCode__c=='PLN'||c.CurrencyCode__c=='SEK'||c.CurrencyCode__c=='TRY'
                                       ||c.CurrencyCode__c=='BRL'||(c.CurrencyCode__c=='USD'&&c.CountryCode__c=='RU')||(c.CurrencyCode__c=='USD'&&c.CountryCode__c=='SA'))
                                {
                                    system.debug('string1 '+string1);
                                    string1=(string1.substring(0, string1.length()-2)).replace(',','.')+string1.substring(string1.length()-2, string1.length());
                                    system.debug('string1 '+string1);
                                    string1=string1.substring(0, string1.length()-3)+(string1.substring(string1.length()-3,string1.length())).replace('.',',');
                                    system.debug('string1 '+string1);
                                }
                                
                             //   else if(){
                                    
                               // }
                               // string1=c.CurrencyCode__c +' '+ string1 + ' ' + c.CurrencySymbol__c;
                               string1=c.CurrencySymbol__c +' '+ string1; 
                                 break;
                            }
                        }
                        
                    
       return string1;
    }
}