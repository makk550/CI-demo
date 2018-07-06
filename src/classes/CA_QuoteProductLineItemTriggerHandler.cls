public Class CA_QuoteProductLineItemTriggerHandler{

    public static void createAgreementLineItems(List<Quote_Product_Report__c> newListqpr){
     List<Quote_Product_Report__c> quotesList = newListqpr;
    List<Quote_Product_Report__c> listOfQuotes = new List<Quote_Product_Report__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements = new List<Apttus__APTS_Agreement__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements1 = new List<Apttus__APTS_Agreement__c>();
    Map<Id,List<Apttus__APTS_Agreement__c>> mapOfQuoteandAgreements = new Map<Id,List<Apttus__APTS_Agreement__c>>();
    List<Apttus__AgreementLineItem__c> listOfAgreementLineitems = new List<Apttus__AgreementLineItem__c>();
    Set<Id> quoteIds = new Set<Id>();
    Set<String> addQuoteIds = new Set<String>();
    System.debug('quotesList :'+quotesList );
        for(Quote_Product_Report__c qpr : quotesList){
            quoteIds.add(qpr.Sterling_Quote__c );
            addQuoteIds.add(qpr.CPQ_Quote_Number__c);
        }
        System.debug('quoteIds :'+quoteIds);
        System.debug('addquoteIds :'+addQuoteIds);
        if(quoteIds.size()>0)
        listOfagreements = [Select Id, CurrencyIsoCode, Name,Sterling_Quote__c,CA_Additional_Quote_Numbers__c  from Apttus__APTS_Agreement__c where (Sterling_Quote__c in:quoteIds or (CA_Additional_Quote_Numbers__c!=null and CA_Additional_Quote_Numbers__c LIKE: addQuoteIds ))and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        if(addQuoteIds.size() > 0)
        listOfagreements1 = [Select Id, CurrencyIsoCode, Name,Sterling_Quote__c,CA_Additional_Quote_Numbers__c  from Apttus__APTS_Agreement__c where ((CA_Additional_Quote_Numbers__c!=null and CA_Additional_Quote_Numbers__c LIKE: addQuoteIds)) and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        system.debug('Add Agreements size:::'+listOfagreements1.size());
        
        //listOfagreements.addAll(listOfagreements1);
        
        system.debug('listOfagreements.......'+listOfagreements+'size:'+listOfagreements.size()  );
         system.debug('newListqpr.......'+newListqpr);
         system.debug('newListqpr................'+newListqpr.size());
        //for primary quote line item
        for(Apttus__APTS_Agreement__c agree: listOfagreements){
         system.debug('$$$$');
            for(Quote_Product_Report__c quotesLineItem: newListqpr){
                 if(!(quotesLineItem.No_Charge_Product__c!=null && quotesLineItem.No_Charge_Product__c=='Y' && quotesLineItem.Reason_for_no_charge__c!=null && quotesLineItem.Reason_for_no_charge__c!='Stabilized'))
                 {    
           // system.debug('agree.Sterling_Quote__c:'+agree.Sterling_Quote__c);
             //system.debug('quotesLineItem.id:'+quotesLineItem.Sterling_Quote__c);
                if(agree.Sterling_Quote__c == quotesLineItem.Sterling_Quote__c){
                system.debug('^^^^^^');
                    Apttus__AgreementLineItem__c agr = new Apttus__AgreementLineItem__c();
                    agr.Apttus__AgreementId__c = agree.id;
                     agr.New_Additional_Quantity__c= quotesLineItem.New_Additional_Quantity__c;
                    agr.Existing_Quantity__c= quotesLineItem.Existing_Quantity__c;
                    //revrec special metric US341175
                    
                     agr.SpecialMetricsUsageQtyNewAdditional__c=quotesLineItem.SpecialMetricUsageQtyNewAdditional__c;
                     agr.SpecialMetricsUsageQtyExisting__c=quotesLineItem.Special_Metric_Usage_Qty_Existing__c;

                    if(quotesLineItem.Bus_Transaction_Type__c!=null)
                    {
                        if(quotesLineItem.Auth_Use_Model__c=='Special Metric')
                        {
                        if(quotesLineItem.Bus_Transaction_Type__c=='Time'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Product Migration'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Reinstatement')
                        {
                            agr.Use_Limitation__c=quotesLineItem.Special_Metric_Usage_Qty_Existing__c;
                        }
                        if(quotesLineItem.Bus_Transaction_Type__c=='New Product'|| quotesLineItem.Bus_Transaction_Type__c=='Distributed Capacity'|| quotesLineItem.Bus_Transaction_Type__c=='Education')
                        {
                            agr.Use_Limitation__c=quotesLineItem.SpecialMetricUsageQtyNewAdditional__c;
                        }
                        }
                        Else
                        {
                        if(quotesLineItem.Bus_Transaction_Type__c=='Time'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Product Migration'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Reinstatement' || quotesLineItem.Bus_Transaction_Type__c=='Mainframe Capacity' )
                        {
                            agr.Use_Limitation__c=quotesLineItem.Existing_Quantity__c;
                        }
                        if(quotesLineItem.Bus_Transaction_Type__c=='New Product'|| quotesLineItem.Bus_Transaction_Type__c=='Distributed Capacity'|| quotesLineItem.Bus_Transaction_Type__c=='Education')
                        {
                            agr.Use_Limitation__c=quotesLineItem.New_Additional_Quantity__c;
                        }
                        }
                            }
                           //change ends
                           ////change for svcs added by jagan
                                agr.Project_Description__c=quotesLineItem.Project_Description__c;
                                //change ends
                    agr.CA_Product_Code__c = quotesLineItem.Product_Material__r.Name;
                    agr.Quote_Line_Item_Id__c = quotesLineItem.id;
                    agr.CA_Auth_Use_Model__c = quotesLineItem.Auth_Use_Model__c;
                    agr.CA_Bus_Transaction_Type__c= quotesLineItem.Bus_Transaction_Type__c;
                    agr.CA_Delivery_Method__c = quotesLineItem.Delivery_Method__c;   
                    agr.CA_Disc_off_List_License_Subs__c = quotesLineItem.Lic_Sub_off_List__c;
                    agr.CA_End_Date__c = quotesLineItem.End_Date__c;
                    agr.CA_Effective_Date__c= quotesLineItem.Effective_Date__c;
                    agr.CA_License_Type__c = quotesLineItem.License_Type__c;
                    agr.CA_Line_Number__c= quotesLineItem.Line_Number__c;
                    agr.CA_Mainframe_Distributed__c= quotesLineItem.Mainframe_Distributed__c;
                    agr.CA_Monthly_ProductFeeforSubscriptionTerm__c= quotesLineItem.Monthly_Product_Fee_for_Subscriptionterm__c;
                    agr.CA_Operating_System__c= quotesLineItem.Operating_System__c;
                    agr.CA_Pricing_Group__c= quotesLineItem.CA_Pricing_Group__c;
                    agr.CA_Product_Name__c= quotesLineItem.Product_Name__c;
                    agr.CA_Proposed_Lic_Sub_Price__c= quotesLineItem.Proposed_Lic_Sub_Fee__c;
                    //Currency format change 
                    if(agr.CA_Proposed_Lic_Sub_Price__c>0){
                        agr.ProposedLicSubPrice__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Proposed_Lic_Sub_Price__c),agree.CurrencyIsoCode) ;
                    }
                    //change ends
                    agr.CA_Proposed_Maintenance_Price__c    = quotesLineItem.Proposed_Maint_Fee__c;
                    if(agr.CA_Proposed_Maintenance_Price__c>0){
                        agr.ProposedMaintenancePriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Proposed_Maintenance_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Shipping_Required__c= quotesLineItem.Shipping_Required__c;
                    agr.CA_Stated_Renewal_Price__c= quotesLineItem.Stated_Renewal_Fee__c;
                    if(agr.CA_Stated_Renewal_Price__c>0){
                        agr.StatedRenewalPriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Stated_Renewal_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Total_Proposed_Price__c= quotesLineItem.Total_Proposed_Price__c;
                  //Currency format change 
                    if(agr.CA_Total_Proposed_Price__c>0){
                        agr.TotalProposedPriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Total_Proposed_Price__c),agree.CurrencyIsoCode) ;
                    }
                    //change ends
                    agr.CA_Total_Quantity__c = quotesLineItem.Total_Quantity__c;
                    agr.CA_Volume_License_Subs_Price__c= quotesLineItem.Volume_License_Subs_Fee__c;
                    agr.CA_Volume_Maintenance_Price__c= quotesLineItem.Volume_Maintenance_Price__c;
                    agr.Activity_Type__c= quotesLineItem.Activity_Type__c;
                    agr.Change_Hours_Units__c= quotesLineItem.Change_Hours_Units__c;
                    agr.Charge_Code__c= quotesLineItem.Charge_Code__c;
                    agr.Cost_Center__c= quotesLineItem.Cost_Center__c;
                    agr.CA_CPQ_Quote_Number_Quote_Number__c= quotesLineItem.CPQ_Quote_Number__c;
                    agr.Discount__c= quotesLineItem.Discount__c;
                    agr.Discount_Exceeds_Reason__c= quotesLineItem.Discount_Exceeds_Reason__c;
                    agr.End_Date_of_Project__c= quotesLineItem.End_Dateof_Project__c;
                    agr.Estimated_Start_Date__c= quotesLineItem.Estimated_Start_Date__c;
                    agr.Exhibit_Comment__c= quotesLineItem.Exhibit_Comment__c;
                    agr.Expense_Amount_Included__c= quotesLineItem.Expense_Amount_Included__c;
                    agr.GSA_Rate__c= quotesLineItem.GSA_Rate__c;
                    agr.Hours_Units__c= quotesLineItem.Hours_Units__c;
                    agr.List_Rate__c= quotesLineItem.List_Rate__c;
                    agr.List_Rate_Revenue__c= quotesLineItem.List_Rate_Revenue__c;
                    agr.Planned_Project_Cost__c= quotesLineItem.Planned_Project_Cost__c;
                    agr.Planned_Project_Revenue__c= quotesLineItem.Planned_Project_Revenue__c;
                    agr.PO_Number__c= quotesLineItem.PO_Number__c;
                    agr.Product_1__c= quotesLineItem.Product_1__c;
                    agr.Product_1_Percent__c= quotesLineItem.Product_1_Percent__c;
                    agr.Product_2__c= quotesLineItem.Product_2__c;
                    agr.Product_2_Percent__c= quotesLineItem.Product_2_Percent__c;
                    agr.Product_3__c= quotesLineItem.Product_3__c;
                    agr.Product_3_Percent__c= quotesLineItem.Product_3_Percent__c;
                    agr.Project_Bill_Rate__c= quotesLineItem.Project_Bill_Rate__c;
                    agr.Contracted_Rate_Used_1__c= quotesLineItem.Contracted_Rate_Used_1__c;
                    agr.Project_Group__c= quotesLineItem.Project_Group__c;
                    agr.Project_Type__c= quotesLineItem.Project_Type__c;
                    agr.Role_Description__c = quotesLineItem.Role_Description__c;
                    agr.SAP_Contract_Line_Number__c= quotesLineItem.SAP_Contract_Line_Number__c;
                    agr.Project_Number__c= quotesLineItem.Project_Number__c;
                    agr.SAP_IO_User_Status__c= quotesLineItem.SAP_IO_User_Status__c;
                    agr.Service_Offering__c= quotesLineItem.Service_Offering__c;
                    agr.Services_Flag__c= quotesLineItem.Services_Flag__c;
                    agr.SKU__c= quotesLineItem.SKU__c;
                    agr.Std_Cost__c= quotesLineItem.Std_Cost__c;
                    agr.Vendor_Overhead__c= quotesLineItem.Vendor_Overhead__c;
                    agr.VSOE_Rate__c= quotesLineItem.VSOE_Rate__c;
                    agr.CA_License_Metric__c = quotesLineItem.License_Metric__c;
                    agr.CurrencyIsoCode = agree.CurrencyIsoCode;
                    agr.CA_Product_Instance_ID__c = quotesLineItem.Product_Instance_ID__c;
                    listOfAgreementLineitems.add(agr);
                }           
            }
            }
        }
        //for additional quote line item
           for(Apttus__APTS_Agreement__c agree: listOfagreements1){
         system.debug('$$$$');
            for(Quote_Product_Report__c quotesLineItem: newListqpr){
                 if(!(quotesLineItem.No_Charge_Product__c!=null && quotesLineItem.No_Charge_Product__c=='Y' && quotesLineItem.Reason_for_no_charge__c!=null && quotesLineItem.Reason_for_no_charge__c!='Stabilized'))
                 {
            system.debug('agree.Sterling_Quote__c:'+agree.Sterling_Quote__c);
             system.debug('quotesLineItem.id:'+quotesLineItem.Sterling_Quote__c);
                if(agree.CA_Additional_Quote_Numbers__c==quotesLineItem.CPQ_Quote_Number__c){
                system.debug('^^^^^^');
                    Apttus__AgreementLineItem__c agr = new Apttus__AgreementLineItem__c();
                    agr.Apttus__AgreementId__c = agree.id;
                     agr.New_Additional_Quantity__c= quotesLineItem.New_Additional_Quantity__c;
                    agr.Existing_Quantity__c= quotesLineItem.Existing_Quantity__c;
                    if(quotesLineItem.Bus_Transaction_Type__c!=null)
                    {
                        if(quotesLineItem.Bus_Transaction_Type__c=='Time'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Product Migration'|| quotesLineItem.Bus_Transaction_Type__c=='Time - Reinstatement')
                        {
                            agr.Use_Limitation__c=quotesLineItem.Existing_Quantity__c;
                        }
                        if(quotesLineItem.Bus_Transaction_Type__c=='New Product'|| quotesLineItem.Bus_Transaction_Type__c=='Distributed Capacity'|| quotesLineItem.Bus_Transaction_Type__c=='Mainframe Capacity')
                        {
                            agr.Use_Limitation__c=quotesLineItem.New_Additional_Quantity__c;
                        }
                        
                            }
                    //change for svcs added by jagan
                                agr.Project_Description__c=quotesLineItem.Project_Description__c;
                                //change ends
                    agr.CA_Product_Code__c = quotesLineItem.Product_Material__r.Name;
                    agr.Quote_Line_Item_Id__c = quotesLineItem.id;
                    agr.CA_Auth_Use_Model__c = quotesLineItem.Auth_Use_Model__c;
                    agr.CA_Bus_Transaction_Type__c= quotesLineItem.Bus_Transaction_Type__c;
                    agr.CA_Delivery_Method__c = quotesLineItem.Delivery_Method__c;   
                    agr.CA_Disc_off_List_License_Subs__c = quotesLineItem.Lic_Sub_off_List__c;
                    agr.CA_End_Date__c = quotesLineItem.End_Date__c;
                    agr.CA_Effective_Date__c= quotesLineItem.Effective_Date__c;
                    agr.CA_License_Type__c = quotesLineItem.License_Type__c;
                    agr.CA_Line_Number__c= quotesLineItem.Line_Number__c;
                    agr.CA_Mainframe_Distributed__c= quotesLineItem.Mainframe_Distributed__c;
                    agr.CA_Monthly_ProductFeeforSubscriptionTerm__c= quotesLineItem.Monthly_Product_Fee_for_Subscriptionterm__c;
                    agr.CA_Operating_System__c= quotesLineItem.Operating_System__c;
                    agr.CA_Pricing_Group__c= quotesLineItem.CA_Pricing_Group__c;
                    agr.CA_Product_Name__c= quotesLineItem.Product_Name__c;
                    agr.CA_Proposed_Lic_Sub_Price__c= quotesLineItem.Proposed_Lic_Sub_Fee__c;
                     //Currency format change 
                    if(agr.CA_Proposed_Lic_Sub_Price__c>0){
                        agr.ProposedLicSubPrice__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Proposed_Lic_Sub_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Proposed_Maintenance_Price__c    = quotesLineItem.Proposed_Maint_Fee__c;
                     if(agr.CA_Proposed_Maintenance_Price__c>0){
                        agr.ProposedMaintenancePriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Proposed_Maintenance_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Shipping_Required__c= quotesLineItem.Shipping_Required__c;
                    agr.CA_Stated_Renewal_Price__c= quotesLineItem.Stated_Renewal_Fee__c;
                    if(agr.CA_Stated_Renewal_Price__c>0){
                        agr.StatedRenewalPriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Stated_Renewal_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Total_Proposed_Price__c= quotesLineItem.Total_Proposed_Price__c;
                     //Currency format change 
                    if(agr.CA_Total_Proposed_Price__c>0){
                        agr.TotalProposedPriceText__c=CA_AgreementCustomTriggerHandler.Currencyformat(string.valueOf(agr.CA_Total_Proposed_Price__c),agree.CurrencyIsoCode) ;
                    }
                    agr.CA_Total_Quantity__c = quotesLineItem.Total_Quantity__c;
                    agr.CA_Volume_License_Subs_Price__c= quotesLineItem.Volume_License_Subs_Fee__c;
                    agr.CA_Volume_Maintenance_Price__c= quotesLineItem.Volume_Maintenance_Price__c;
                    agr.Activity_Type__c= quotesLineItem.Activity_Type__c;
                    agr.Change_Hours_Units__c= quotesLineItem.Change_Hours_Units__c;
                    agr.Charge_Code__c= quotesLineItem.Charge_Code__c;
                    agr.Cost_Center__c= quotesLineItem.Cost_Center__c;
                    agr.CA_CPQ_Quote_Number_Quote_Number__c= quotesLineItem.CPQ_Quote_Number__c;
                    agr.Discount__c= quotesLineItem.Discount__c;
                    agr.Discount_Exceeds_Reason__c= quotesLineItem.Discount_Exceeds_Reason__c;
                    agr.End_Date_of_Project__c= quotesLineItem.End_Dateof_Project__c;
                    agr.Estimated_Start_Date__c= quotesLineItem.Estimated_Start_Date__c;
                    agr.Exhibit_Comment__c= quotesLineItem.Exhibit_Comment__c;
                    agr.Expense_Amount_Included__c= quotesLineItem.Expense_Amount_Included__c;
                    agr.GSA_Rate__c= quotesLineItem.GSA_Rate__c;
                    agr.Hours_Units__c= quotesLineItem.Hours_Units__c;
                    agr.List_Rate__c= quotesLineItem.List_Rate__c;
                    agr.List_Rate_Revenue__c= quotesLineItem.List_Rate_Revenue__c;
                    agr.Planned_Project_Cost__c= quotesLineItem.Planned_Project_Cost__c;
                    agr.Planned_Project_Revenue__c= quotesLineItem.Planned_Project_Revenue__c;
                    agr.PO_Number__c= quotesLineItem.PO_Number__c;
                    agr.Product_1__c= quotesLineItem.Product_1__c;
                    agr.Product_1_Percent__c= quotesLineItem.Product_1_Percent__c;
                    agr.Product_2__c= quotesLineItem.Product_2__c;
                    agr.Product_2_Percent__c= quotesLineItem.Product_2_Percent__c;
                    agr.Product_3__c= quotesLineItem.Product_3__c;
                    agr.Product_3_Percent__c= quotesLineItem.Product_3_Percent__c;
                    agr.Project_Bill_Rate__c= quotesLineItem.Project_Bill_Rate__c;
                    agr.Contracted_Rate_Used_1__c= quotesLineItem.Contracted_Rate_Used_1__c;
                    agr.Project_Group__c= quotesLineItem.Project_Group__c;
                    agr.Project_Type__c= quotesLineItem.Project_Type__c;
                    agr.Role_Description__c = quotesLineItem.Role_Description__c;
                    agr.SAP_Contract_Line_Number__c= quotesLineItem.SAP_Contract_Line_Number__c;
                    agr.Project_Number__c= quotesLineItem.Project_Number__c;
                    agr.SAP_IO_User_Status__c= quotesLineItem.SAP_IO_User_Status__c;
                    agr.Service_Offering__c= quotesLineItem.Service_Offering__c;
                    agr.Services_Flag__c= quotesLineItem.Services_Flag__c;
                    agr.SKU__c= quotesLineItem.SKU__c;
                    agr.Std_Cost__c= quotesLineItem.Std_Cost__c;
                    agr.Vendor_Overhead__c= quotesLineItem.Vendor_Overhead__c;
                    agr.VSOE_Rate__c= quotesLineItem.VSOE_Rate__c;
                    agr.CA_License_Metric__c = quotesLineItem.License_Metric__c;
                    agr.CurrencyIsoCode = agree.CurrencyIsoCode;
                    agr.CA_Product_Instance_ID__c = quotesLineItem.Product_Instance_ID__c;
                    listOfAgreementLineitems.add(agr);
                }           
            }
            }
        }
        
        system.debug('listOfAgreementLineitems.....'+listOfAgreementLineitems+'listOfAgreementLineitems.....Size:'+listOfAgreementLineitems.size());
        if(listOfAgreementLineitems.size() > 0){
            insert listOfAgreementLineitems;
        }
    }

    public static void deleteAgreementLineItems(List<Quote_Product_Report__c> oldListqpr){
        
        Set<String> qLineItemsIds = new Set<String> ();
        for(Quote_Product_Report__c oldQpr: oldListqpr){            
            qLineItemsIds.add(oldQpr.CPQ_Quote_Number__c);
        }
        system.debug('********qLineItemsIds'+qLineItemsIds);
        if(qLineItemsIds!=null && qLineItemsIds.size()>0){
        List<Apttus__AgreementLineItem__c> listOfAgrLineItem = [Select id,Quote_Line_Item_Id__c from Apttus__AgreementLineItem__c where (CA_CPQ_Quote_Number_Quote_Number__c!=null AND CA_CPQ_Quote_Number_Quote_Number__c IN:qLineItemsIds) and (Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.Request or Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.In_Authoring)];
        system.debug('********listOfAgrLineItem'+listOfAgrLineItem);
        if(listOfAgrLineItem.size()>0){
            delete listOfAgrLineItem;
        }
        }
    }
}