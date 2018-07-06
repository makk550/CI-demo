public Class CA_SBQuoteLineItemTriggerHandler{

    public static void createAgreementLineItems(List<SBQQ__QuoteLine__c> newListqpr){
     List<SBQQ__QuoteLine__c> quotesList = newListqpr;
    List<SBQQ__QuoteLine__c> listOfQuotes = new List<SBQQ__QuoteLine__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements = new List<Apttus__APTS_Agreement__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements1 = new List<Apttus__APTS_Agreement__c>();
    Map<Id,List<Apttus__APTS_Agreement__c>> mapOfQuoteandAgreements = new Map<Id,List<Apttus__APTS_Agreement__c>>();
    List<Apttus__AgreementLineItem__c> listOfAgreementLineitems = new List<Apttus__AgreementLineItem__c>();
    Set<Id> quoteIds = new Set<Id>();
        Map<String,String> AuthUseModelMAp= new Map<String,String>();
    Set<String> addQuoteIds = new Set<String>();
        Schema.DescribeFieldResult statusFieldDescription = SBQQ__QuoteLine__c.Auth_Use_Mode__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            //system.debug('inside for'+picklistEntry.getValue());
            AuthUseModelMAp.put(pickListEntry.getValue(),pickListEntry.getLabel());
           // NDAType.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        system.debug('AuthUseModelMAp: '+AuthUseModelMAp);
        list<Apttus__AgreementLineItem__c> agrLineItemToupdate=new list<Apttus__AgreementLineItem__c>();
        Map<String,Apttus__AgreementLineItem__c> SBQuoteLineNumberAgreementLineItem=new Map<String,Apttus__AgreementLineItem__c>();
    System.debug('quotesList :'+quotesList );
        for(SBQQ__QuoteLine__c qpr : quotesList){
            quoteIds.add(qpr.SBQQ__Quote__c );
            addQuoteIds.add(qpr.Quote__c);
        }
        System.debug('quoteIds :'+quoteIds);
        System.debug('addquoteIds :'+addQuoteIds);
        if(quoteIds.size()>0)
        listOfagreements = [Select Id, CurrencyIsoCode, Name,SF_Quote__c,Additional_Salesforce_Quote_Numbers__c  from Apttus__APTS_Agreement__c where (SF_Quote__c !=null and SF_Quote__c in:quoteIds )and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        if(addQuoteIds.size() > 0)
        listOfagreements1 = [Select Id, CurrencyIsoCode, Name,SF_Quote__c,Additional_Salesforce_Quote_Numbers__c  from Apttus__APTS_Agreement__c where ((Additional_Salesforce_Quote_Numbers__c	!=null and Additional_Salesforce_Quote_Numbers__c	 LIKE: addQuoteIds)) and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        system.debug('Add Agreements size:::'+listOfagreements1.size());
        
        //listOfagreements.addAll(listOfagreements1);
        
        system.debug('listOfagreements.......'+listOfagreements+'size:'+listOfagreements.size()  );
         system.debug('newListqpr.......'+newListqpr);
         system.debug('newListqpr................'+newListqpr.size());
        //for primary quote line item
        for(Apttus__APTS_Agreement__c agr: listOfagreements){
         system.debug('$$$$');
            for(SBQQ__QuoteLine__c SBQuote: newListqpr){
                if(!SBQuote.Parent_Bundle__c){
                       Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                           if(SBQuote.Maintenance_Product__c=='Yes'){
                              if(SBQuote.Maintenance_Parent_Quote_Line__c!=null && SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c)!=null)
                              {
                               alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c);
                              alitem.CA_Proposed_Maintenance_Price__c=SBQuote.Net_Total_Form__c;
                              alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                                  alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                                 // alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;
                                  system.debug('alitem.CA_Proposed_Maintenance_Price__c : '+alitem.CA_Proposed_Maintenance_Price__c);
                                  system.debug('alitem.CA_Proposed_Lic_Sub_Price__c : '+alitem.CA_Proposed_Lic_Sub_Price__c);
                                  if(alitem.CA_Proposed_Maintenance_Price__c!=null && alitem.CA_Proposed_Lic_Sub_Price__c!=null)
                                  alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;	
                                  else if(alitem.CA_Proposed_Maintenance_Price__c!=null)
                                   alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                  else if(alitem.CA_Proposed_Lic_Sub_Price__c!=null)
                                    alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Lic_Sub_Price__c;  
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Proposed_Maintenance_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                 SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Volume_Maintenance_Price__c=alitem.CA_Volume_Maintenance_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Total_Proposed_Price__c=alitem.CA_Total_Proposed_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Stated_Renewal_Price__c=alitem.CA_Stated_Renewal_Price__c;
                                  agrLineItemToupdate.add(alitem);
                              } 
                               }
                           else{
                               alitem.CA_Mainframe_Distributed__c= 'Distributed';
                       alitem.CA_CPQ_Quote_Number_Quote_Number__c=SBQuote.Quote__c;
                       system.debug('agr.Id :' +agr.Id);
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
                      // alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                               alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c;
                       if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c ;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                              // system.debug('SBQuote.Auth_Use_Mode__c '+ SBQuote.Auth_Use_Mode__c);
                     //alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                    system.debug('AuthUseModelMAp.get(SBQuote.Auth_Use_Mode__c) '+ AuthUseModelMAp.get(SBQuote.Auth_Use_Mode__c));
                     if(AuthUseModelMAp.get(SBQuote.Auth_Use_Mode__c)!=null)
                               alitem.CA_Auth_Use_Model__c = AuthUseModelMAp.get(SBQuote.Auth_Use_Mode__c);
                     alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                    /* if(SBQuote.SBQQ__RequiredBy__c!=null && SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null )
                               alitem.New_Additional_Quantity__c=SBQuote.SBQQ__RequiredBy__r.SBQQ__Quantity__c - SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c;
                     else
                              if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null )
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                              //  alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                     alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                    */          alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                                 alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                               if(SBQuote.SBQQ__RequiredBy__c!=null && SBQuote.SBQQ__RequiredBy__r.SBQQ__Quantity__c!=null && SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c!=null ){
                                   alitem.New_Additional_Quantity__c=SBQuote.SBQQ__RequiredBy__r.SBQQ__Quantity__c - SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c;
                                   alitem.Existing_Quantity__c= SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c;
                               }
                               else if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null ){
                                   alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                                   alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                               }
                               if(alitem.CA_Bus_Transaction_Type__c!=null){
                    if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement'){
                            alitem.Existing_Quantity__c=SBQuote.SBQQ__Quantity__c;    
                            alitem.Use_Limitation__c=alitem.Existing_Quantity__c;
                        alitem.New_Additional_Quantity__c=null;
                        }
                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                          alitem.Use_Limitation__c =alitem.New_Additional_Quantity__c;
                        system.debug('alitem.Use_Limitation__c: '+alitem.Use_Limitation__c);
                      SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                                              
                            listOfAgreementLineitems.add(alitem);
                            
                    }
                           }
               }
               /* else{
                    Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                    if(SBQuoteLineNumberAgreementLineItem!=null && SBQuote.SBQQ__RequiredBy__r.Name!=null)
                    alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.SBQQ__RequiredBy__r.Name);
                    alItem.New_Additional_Quantity__c=SBQuote.SBQQ__Quantity__c;
                    agrLineItemToupdate.add(alItem);
                }*/
            }
        }
        //for additional quote line item
           for(Apttus__APTS_Agreement__c agr: listOfagreements1){
         system.debug('$$$$');
            for(SBQQ__QuoteLine__c SBQuote: newListqpr){
                  if(!SBQuote.Parent_Bundle__c){
                       Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
                           if(SBQuote.Maintenance_Product__c=='Yes'){
                              if(SBQuote.Maintenance_Parent_Quote_Line__c!=null && SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c)!=null)
                              {
                                   alItem=SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c);
                              alitem.CA_Proposed_Maintenance_Price__c=SBQuote.Net_Total_Form__c;
                              alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                                  alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                                 // alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;
                                  system.debug('alitem.CA_Proposed_Maintenance_Price__c : '+alitem.CA_Proposed_Maintenance_Price__c);
                                  system.debug('alitem.CA_Proposed_Lic_Sub_Price__c : '+alitem.CA_Proposed_Lic_Sub_Price__c);
                                  if(alitem.CA_Proposed_Maintenance_Price__c!=null && alitem.CA_Proposed_Lic_Sub_Price__c!=null)
                                  alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c + alitem.CA_Proposed_Lic_Sub_Price__c;	
                                  else if(alitem.CA_Proposed_Maintenance_Price__c!=null)
                                   alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                  else if(alitem.CA_Proposed_Lic_Sub_Price__c!=null)
                                    alitem.CA_Total_Proposed_Price__c=alitem.CA_Proposed_Lic_Sub_Price__c;  
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Proposed_Maintenance_Price__c=alitem.CA_Proposed_Maintenance_Price__c;
                                 SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Volume_Maintenance_Price__c=alitem.CA_Volume_Maintenance_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Total_Proposed_Price__c=alitem.CA_Total_Proposed_Price__c;
                                  SBQuoteLineNumberAgreementLineItem.get(SBQuote.Maintenance_Parent_Quote_Line__c).CA_Stated_Renewal_Price__c=alitem.CA_Stated_Renewal_Price__c;
                                  agrLineItemToupdate.add(alitem);
                              } 
                               }
                           else{
                               alitem.CA_Mainframe_Distributed__c= 'Distributed';
                       alitem.CA_CPQ_Quote_Number_Quote_Number__c=SBQuote.Quote__c;
                       alitem.Apttus__AgreementId__c = agr.Id;
                               system.debug('agr.Id :' +agr.Id);
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
                      // alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                               alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c;
                       if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c ;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                              // system.debug('SBQuote.Auth_Use_Mode__c '+ SBQuote.Auth_Use_Mode__c);
                    // alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                      alitem.CA_Auth_Use_Model__c = AuthUseModelMAp.get(SBQuote.Auth_Use_Mode__c);
                               alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                               alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                                 alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                               if(SBQuote.SBQQ__RequiredBy__c!=null && SBQuote.SBQQ__RequiredBy__r.SBQQ__Quantity__c!=null && SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c!=null ){
                               alitem.New_Additional_Quantity__c=SBQuote.SBQQ__RequiredBy__r.SBQQ__Quantity__c - SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c;
                               alitem.Existing_Quantity__c= SBQuote.SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c;
                               }
                               else if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.SBQQ__PriorQuantity__c!=null ){
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c - SBQuote.SBQQ__PriorQuantity__c ;
                     alitem.Existing_Quantity__c = SBQuote.SBQQ__PriorQuantity__c ;
                               }
                    if(alitem.CA_Bus_Transaction_Type__c!=null){
                        if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement'){
                   // if(SBQuote.SBQQ__RequiredBy__c!=null)
                            alitem.Existing_Quantity__c=SBQuote.SBQQ__Quantity__c;    
                            alitem.Use_Limitation__c=alitem.Existing_Quantity__c;
                            alitem.New_Additional_Quantity__c=null;
                        }
                     //else
                       //        alitem.Use_Limitation__c = alitem.New_Additional_Quantity__c;
                      //  alitem.Use_Limitation__c = SBQuote.Quantity_Prior__c;
                       // system.debug('Inside Additional JK');
                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                     alitem.Use_Limitation__c = alitem.New_Additional_Quantity__c;
                      
                    }
                               SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                            listOfAgreementLineitems.add(alitem);
                           }
               }
                else{
                    
                }
            }
        }
        
        system.debug('listOfAgreementLineitems.....'+listOfAgreementLineitems+'listOfAgreementLineitems.....Size:'+listOfAgreementLineitems.size());
        try{
        if(listOfAgreementLineitems.size() > 0){
            insert listOfAgreementLineitems;
        }
        system.debug('agrLineItemToupdate: '+agrLineItemToupdate+'::::: agrLineItemToupdate.size :' +agrLineItemToupdate.size());
        if(agrLineItemToupdate.size()>0){
            update agrLineItemToupdate;
        }
    }
        catch(exception e)
        {system.debug('Exception thrown: '+e);}
    }
/*
    public static void updateAgreementLineItems(List<SBQQ__QuoteLine__c> newListqpr,Map<ID,SBQQ__QuoteLine__c> oldMap){
        
        List<SBQQ__QuoteLine__c> quotesList = newListqpr;
    List<SBQQ__QuoteLine__c> listOfQuotes = new List<SBQQ__QuoteLine__c>();
    List<Apttus__AgreementLineItem__c> listOfagreementlineItems = new List<Apttus__AgreementLineItem__c>();
     List<Apttus__AgreementLineItem__c> UpdatelistOfagreementlineItems = new List<Apttus__AgreementLineItem__c>();
        List<Apttus__APTS_Agreement__c> listOfagreements1 = new List<Apttus__APTS_Agreement__c>();
         Set<Id> quoteIds = new Set<Id>();
    Set<String> quoteName = new Set<String>();
        list<Apttus__AgreementLineItem__c> agrLineItemToupdate=new list<Apttus__AgreementLineItem__c>();
        Map<String,Apttus__AgreementLineItem__c> SBQuoteLineNumberAgreementLineItem=new Map<String,Apttus__AgreementLineItem__c>();
    System.debug('quotesList :'+quotesList );
        for(SBQQ__QuoteLine__c qpr : quotesList){
            quoteIds.add(qpr.SBQQ__Quote__c );
            quoteName.add(qpr.Quote__c);
        }
    listOfagreementlineItems=[Select Id,name,CA_Volume_Maintenance_Price__c,CA_CPQ_Quote_Number_Quote_Number__c,Apttus__AgreementId__c,CA_Disc_off_List_License_Subs__c,
CA_Effective_Date__c,CA_End_Date__c,CA_Line_Number__c,CA_License_Type__c,CA_Monthly_ProductFeeforSubscriptionTerm__c,CA_Operating_System__c,CA_Pricing_Group__c,CA_Product_Code__c,CA_Product_Name__c,CA_Proposed_Lic_Sub_Price__c,
CA_Proposed_Maintenance_Price__c,CA_Shipping_Required__c,CA_Total_Proposed_Price__c,CA_Total_Quantity__c,CA_Volume_License_Subs_Price__c,CA_Stated_Renewal_Price__c,CA_License_Metric__c,CA_Product_Instance_ID__c,CA_Auth_Use_Model__c,
CA_Bus_Transaction_Type__c,New_Additional_Quantity__c,Existing_Quantity__c,Use_Limitation__c from Apttus__AgreementLineItem__c where CA_CPQ_Quote_Number_Quote_Number__c 
IN :quoteName];
        for(Apttus__AgreementLineItem__c alitem: listOfagreementlineItems ){
            for(SBQQ__QuoteLine__c SBQuote: newListqpr )
            {
                if(alitem.CA_CPQ_Quote_Number_Quote_Number__c==SBQuote.Quote__c){
                   if(!SBQuote.Parent_Bundle__c){
                      // Apttus__AgreementLineItem__c alItem=new Apttus__AgreementLineItem__c();
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
                       //alitem.Apttus__AgreementId__c = agr.Id;
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
                       alitem.CA_Proposed_Maintenance_Price__c = SBQuote.Net_Total_Form__c;
                       alitem.CA_Shipping_Required__c='No';
                       alitem.CA_Total_Proposed_Price__c=SBQuote.SBQQ__NetTotal__c;
                       if(SBQuote.SBQQ__Quantity__c!=null && SBQuote.Quantity_Prior__c!=null)
                       alitem.CA_Total_Quantity__c=SBQuote.SBQQ__Quantity__c + SBQuote.Quantity_Prior__c;
                       alitem.CA_Volume_License_Subs_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Volume_Maintenance_Price__c=SBQuote.Volume_Discount_Price_form__c;
                       alitem.CA_Stated_Renewal_Price__c = SBQuote.CA_License_Cert__c;
                       alitem.CA_License_Metric__c = SBQuote.License_Metric_CPQ__c;
                       alitem.CA_Product_Instance_ID__c = SBQuote.Instance_ID__c;
                              // system.debug('SBQuote.Auth_Use_Mode__c '+ SBQuote.Auth_Use_Mode__c);
                    // alitem.CA_Auth_Use_Model__c = string.valueOf(SBQuote.get('Auth_Use_Mode__cLabel'));
                      alitem.CA_Auth_Use_Model__c = SBQuote.Auth_Use_Mode__c;
                               alitem.CA_Bus_Transaction_Type__c = SBQuote.Business_Transaction_Type_SAP__c;
                     alitem.New_Additional_Quantity__c = SBQuote.SBQQ__Quantity__c;
                     alitem.Existing_Quantity__c = SBQuote.Quantity_Prior__c;
                    if(alitem.CA_Bus_Transaction_Type__c!=null){
                    if(alitem.CA_Bus_Transaction_Type__c=='Time'|| alitem.CA_Bus_Transaction_Type__c==''|| alitem.CA_Bus_Transaction_Type__c=='Time - Reinstatement')
                     alitem.Use_Limitation__c = SBQuote.Quantity_Prior__c;
                      if(alitem.CA_Bus_Transaction_Type__c=='New Product'|| alitem.CA_Bus_Transaction_Type__c=='Distributed Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Mainframe Capacity'|| alitem.CA_Bus_Transaction_Type__c=='Education')
                     alitem.Use_Limitation__c = SBQuote.SBQQ__Quantity__c;
                      
                    }
                               SBQuoteLineNumberAgreementLineItem.put(SBQuote.Name,alitem);
                            UpdatelistOfagreementlineItems.add(alitem);
                           }
               }  
                }
            }
        }
         if(UpdatelistOfagreementlineItems.size()>0){
            update UpdatelistOfagreementlineItems;
        }
    }
    
    */
     public static void deleteAgreementLineItems(List<SBQQ__QuoteLine__c> oldListqpr){
        
        Set<String> qLineItemsIds = new Set<String> ();
        for(SBQQ__QuoteLine__c oldQpr: oldListqpr){            
            qLineItemsIds.add(oldQpr.Quote__c);
        }
        system.debug('********qLineItemsIds'+qLineItemsIds);
      //  List<Apttus__AgreementLineItem__c> listOfAgrLineItem = [Select id,Quote_Line_Item_Id__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__r.SF_Quote__c IN:qLineItemsIds and (Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.Request or Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.In_Authoring)];
        List<Apttus__AgreementLineItem__c> listOfAgrLineItem = [Select id,Quote_Line_Item_Id__c from Apttus__AgreementLineItem__c where CA_CPQ_Quote_Number_Quote_Number__c IN:qLineItemsIds and (Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.Request or Apttus__AgreementId__r.Apttus__Status_Category__c =: Label.In_Authoring)];
         system.debug('********listOfAgrLineItem'+listOfAgrLineItem);
        if(listOfAgrLineItem.size()>0){
            delete listOfAgrLineItem;
            
            
            List<SBQQ__QuoteLine__c> SBquotelinesToInsert=[Select ID,Name,Quote__c,Maintenance_Product__c,Maintenance_Parent_Quote_Line__c,Discount_form__c,Start_Date__c,SBQQ__Number__c,End_Date__c,CA_License_Type__c,Quote_Line_Number_SAP__c,Monthly_Unit_Price__c,SAP_Operating_System__c,Pricing_Group__c,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__NetTotal__c,Net_Total_Form__c,CA_License_Cert__c,SBQQ__Quantity__c,Volume_Discount_Price_form__c,SBQQ__Quote__c,Quantity_Prior__c,
                                                           License_Metric_CPQ__c,SBQQ__RequiredBy__c,SBQQ__RequiredBy__r.SBQQ__Quantity__c,SBQQ__RequiredBy__r.Quantity_Prior__c,SBQQ__RequiredBy__r.SBQQ__PriorQuantity__c,SBQQ__ProductCode__c,Instance_ID__c,Auth_Use_Mode__c,Business_Transaction_Type_SAP__c,Parent_Bundle__c,SBQQ__PriorQuantity__c from SBQQ__QuoteLine__c where Quote__c IN: qLineItemsIds];
           system.debug('SBquotelinesToInsert: '+SBquotelinesToInsert);
            createAgreementLineItems(SBquotelinesToInsert);
        }
        
    }
    
    
    private static integer count =0;
    public static boolean runOrNot(){
    if(count<3){
     count=count+1;
     return true;
    }else{
        return false;
    }
    }
}