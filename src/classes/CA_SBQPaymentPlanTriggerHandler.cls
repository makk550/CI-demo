public Class CA_SBQPaymentPlanTriggerHandler{
public static void createAgrPaymentPlan(List<Payment_Plan__c> newListpp){     
    List<Agreement_Payment_Plan__c> listOfQuotes = new List<Agreement_Payment_Plan__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements = new List<Apttus__APTS_Agreement__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements1 = new List<Apttus__APTS_Agreement__c>();
    Map<Id,List<Apttus__APTS_Agreement__c>> mapOfQuoteandAgreements = new Map<Id,List<Apttus__APTS_Agreement__c>>();
    List<Agreement_Payment_Plan__c > listOfPaymentPlans= new List<Agreement_Payment_Plan__c >();
    Set<Id> quoteIds = new Set<Id>();
    Set<String> addQuoteIds = new Set<String>();
      for(Payment_Plan__c qpp : newListpp){
          system.debug('qpp.Quote__c : ' +qpp.Quote__c);
            quoteIds.add(qpp.Quote__c );
            addQuoteIds.add(qpp.QuoteNumber__c);
        }
        System.debug('quoteIds :'+quoteIds);
        System.debug('Add quoteIds :'+addQuoteIds);
        if(quoteIds.size()>0)
        listOfagreements = [Select Id, CurrencyIsoCode, Name,SF_Quote__c,SF_Quote__r.Name, Additional_Salesforce_Quote_Numbers__c  from Apttus__APTS_Agreement__c where SF_Quote__c in:quoteIds and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        if(addQuoteIds.size() > 0)
        listOfagreements1 = [Select Id, CurrencyIsoCode, Name,SF_Quote__c,SF_Quote__r.Name, Additional_Salesforce_Quote_Numbers__c  from Apttus__APTS_Agreement__c where (Additional_Salesforce_Quote_Numbers__c	!=null and Additional_Salesforce_Quote_Numbers__c	 LIKE: addQuoteIds)and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        system.debug('Add Agreements size:::'+listOfagreements1.size());
        //listOfagreements.addAll(listOfagreements1);
               
        
        system.debug('listOfagreements.......'+listOfagreements+'size:'+listOfagreements.size()  );
        system.debug('listOfagreements.......'+listOfagreements1+'size:'+listOfagreements1.size()  );
         system.debug('newListpp.......'+newListpp);
         system.debug('newListpp................'+newListpp.size());
    //for primary quote
        for(Apttus__APTS_Agreement__c newagr: listOfagreements){
         system.debug('$$$$');
            for(Payment_Plan__c SBquotePay: newListpp){
             system.debug('newagr.SF_Quote__c 1:'+newagr.SF_Quote__c);
                 system.debug('SBquotePay.Quote__r.Name:'+SBquotePay.Quote__c);
            // system.debug('quotesLineItem.id:'+pp.Sterling_Quote__c);
                if(newagr.SF_Quote__c == SBquotePay.Quote__c){
                Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                            
                       app.Agreement__c = newagr.Id;
                       app.CPQ_Quote_Number__c=newagr.SF_Quote__r.Name;
                       app.CA_Payment_Date__c=SBquotePay.Date__c;
                    
                        //app.Payment_Total__c = SBquotePay.Payment_Schedule_Total__c + SBquotePay.Amount__c;
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
                       listOfPaymentPlans.add(app);
                    
                }           
            }
        }
    // for additional quote
            for(Apttus__APTS_Agreement__c newagr: listOfagreements1){
         system.debug('$$$$');
            for(Payment_Plan__c SBquotePay: newListpp){
           // system.debug('newagr.CA_Additional_Quote_Numbers__c:'+newagr.CA_Additional_Quote_Numbers__c);
            // system.debug('payment plan quote number:'+SBquotePay.CPQ_Quote_NUmber__c);
                if(newagr.Additional_Salesforce_Quote_Numbers__c==SBquotePay.QuoteNumber__c){
                Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                            
                       app.Agreement__c = newagr.Id;
                     app.CPQ_Quote_Number__c=newagr.SF_Quote__r.Name;
                       //app.CPQ_Quote_Number__c=String.valueOf(SBquotePay.Quote__r.Name);
                       app.CA_Payment_Date__c=SBquotePay.Date__c;
                    system.debug('SBquotePay.Payment_Schedule_Total__c; '+ SBquotePay.Payment_Schedule_Total__c);
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
                       listOfPaymentPlans.add(app);
                }           
            }
        }
        system.debug('listOfPaymentPlans.....'+listOfPaymentPlans+'listOfPaymentPlans.....Size:'+listOfPaymentPlans.size());
        if(listOfPaymentPlans.size() > 0){
            insert listOfPaymentPlans;
        }
    }

    public static void deleteAgreementPaymentPlans(List<Payment_Plan__c> oldListpp){
        
        Set<String> qppIds = new Set<String> ();
        for(Payment_Plan__c oldQpr: oldListpp){  
            system.debug('oldListpp '+oldListpp);
             system.debug('oldQpr.Quote__c'+oldQpr.QuoteNumber__c);
            qppIds.add(oldQpr.QuoteNumber__c);
        }
        system.debug('********qppIds'+qppIds);
        List<Agreement_Payment_Plan__c> listOfPaymentPlan = [Select id,CA_Payment_Plan_Id__c from Agreement_Payment_Plan__c where (CPQ_Quote_Number__c!=null and (CPQ_Quote_Number__c IN:qppIds)) and CA_Is_this_Payment_Plan_Manually_Added__c = false and (Agreement__r.Apttus__Status_Category__c =: Label.Request or Agreement__r.Apttus__Status_Category__c =: Label.In_Authoring)];
        system.debug('********listOfPaymentPlan'+listOfPaymentPlan );
        if(listOfPaymentPlan.size()>0){
            delete listOfPaymentPlan;
            list<Payment_Plan__c> listToInsert=[Select id,Name,Quote__c,License_Amount_CLM__c,Maintenance_Amount_CLM__c,Subscription_Amount_CLM__c,Education_Amount_CLM__c,Services_Amount_CLM__c,Amount_CLM__c,QuoteNumber__c,Amount__c,Date__c,Payment_Schedule_Total__c from Payment_Plan__c where QuoteNumber__c IN: qppIds];
            /*Map<ID,Payment_Plan__c> MAPQuoteIDToPaymentPlan= new Map<ID,Payment_Plan__c>();
            for(Apttus__APTS_Agreement__c agr:[Select id,Name,SF_Quote__c from Apttus__APTS_Agreement__c where SF_Quote__c IN:qppIds]){
                
            }*/
            if(listToInsert.size()>0)
            createAgrPaymentPlan(listToInsert);
            
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
   
}