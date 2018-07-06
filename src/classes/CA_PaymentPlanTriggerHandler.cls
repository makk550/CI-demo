public Class CA_PaymentPlanTriggerHandler{
public static void createAgrPaymentPlan(List<PaymentPlan__c> newListpp){     
    List<Agreement_Payment_Plan__c> listOfQuotes = new List<Agreement_Payment_Plan__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements = new List<Apttus__APTS_Agreement__c>();
    List<Apttus__APTS_Agreement__c> listOfagreements1 = new List<Apttus__APTS_Agreement__c>();
    Map<Id,List<Apttus__APTS_Agreement__c>> mapOfQuoteandAgreements = new Map<Id,List<Apttus__APTS_Agreement__c>>();
    List<Agreement_Payment_Plan__c > listOfPaymentPlans= new List<Agreement_Payment_Plan__c >();
    Set<Id> quoteIds = new Set<Id>();
    Set<String> addQuoteIds = new Set<String>();
      for(PaymentPlan__c qpp : newListpp){
            quoteIds.add(qpp.Sterling_Quote__c );
            addQuoteIds.add(qpp.CPQ_Quote_NUmber__c);
        }
        System.debug('quoteIds :'+quoteIds);
        System.debug('Add quoteIds :'+addQuoteIds);
        if(quoteIds.size()>0)
        listOfagreements = [Select Id, CurrencyIsoCode, Name,Sterling_Quote__c, CA_Additional_Quote_Numbers__c  from Apttus__APTS_Agreement__c where Sterling_Quote__c in:quoteIds and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        if(addQuoteIds.size() > 0)
        listOfagreements1 = [Select Id, CurrencyIsoCode, Name,Sterling_Quote__c, CA_Additional_Quote_Numbers__c  from Apttus__APTS_Agreement__c where CA_Additional_Quote_Numbers__c LIKE: addQuoteIds and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring) ];
        
        system.debug('Add Agreements size:::'+listOfagreements1.size());
        //listOfagreements.addAll(listOfagreements1);
               
        
        system.debug('listOfagreements.......'+listOfagreements+'size:'+listOfagreements.size()  );
        system.debug('listOfagreements.......'+listOfagreements1+'size:'+listOfagreements1.size()  );
         system.debug('newListpp.......'+newListpp);
         system.debug('newListpp................'+newListpp.size());
    //for primary quote
        for(Apttus__APTS_Agreement__c agree: listOfagreements){
         system.debug('$$$$');
            for(PaymentPlan__c pp: newListpp){
            system.debug('agree.Sterling_Quote__c:'+agree.Sterling_Quote__c);
             system.debug('quotesLineItem.id:'+pp.Sterling_Quote__c);
                if(agree.Sterling_Quote__c == pp.Sterling_Quote__c){
                system.debug('^^^^^^');
                    Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                    app.CA_Committed_Payments__c = pp.Committed_Payment__c;
                    app.CPQ_Quote_Number__c = pp.CPQ_Quote_NUmber__c;
                    app.Date_Text__c = pp.Date_Text__c;
                    app.CA_License_Payment__c = pp.License_Payment__c;
                    app.Maintenance_Payment__c = pp.Maintenance_Payment__c;
                    app.CA_Payment_Date__c = pp.Payment_Date__c;
                    app.CA_Payment_Plan_Id__c = pp.Id;
                    app.Payment_Total__c = pp.Payment_Total__c;
                    app.Payment_Type__c = pp.Payment_Type__c;
                    app.Services_Payment__c = pp.Services_Payment__c;
                    app.Subscription_Payment__c = pp.Subscription_Payment__c;
                    app.Agreement__c = agree.Id;
                    app.Initial_Payment__c = pp.Initial_Payment__c;
                    app.Milestone_Description__c = pp.Milestone_Description__c;
                    app.Milestone_Number__c = pp.Milestone_Number__c;
                    app.Number_of_Milestones__c = pp.Number_of_Milestones__c;
                    app.Payment_Of_Total__c = pp.Payment_Percent_Of_Total__c;
                    app.Payment_Amount__c = pp.Payment_Amount__c;
                    app.CA_Payment_Date_Services__c = pp.Payment_Date_Services__c;
                    app.Project_ID__c = pp.Project_ID__c;
                    app.sfxId__c = pp.sfxId__c;
                    app.Total_Payments__c = pp.Total_Payments__c;
                    app.CurrencyIsoCode = agree.CurrencyIsoCode;
                    //app.Name = pp.Name;
                    listOfPaymentPlans.add(app);
                }           
            }
        }
    // for additional quote
            for(Apttus__APTS_Agreement__c agree: listOfagreements1){
         system.debug('$$$$');
            for(PaymentPlan__c pp: newListpp){
            system.debug('agree.CA_Additional_Quote_Numbers__c:'+agree.CA_Additional_Quote_Numbers__c);
             system.debug('payment plan quote number:'+pp.CPQ_Quote_NUmber__c);
                if(agree.CA_Additional_Quote_Numbers__c==pp.CPQ_Quote_NUmber__c){
                system.debug('^^^^^^');
                    Agreement_Payment_Plan__c app = new Agreement_Payment_Plan__c();
                    app.CA_Committed_Payments__c = pp.Committed_Payment__c;
                    app.CPQ_Quote_Number__c = pp.CPQ_Quote_NUmber__c;
                    app.Date_Text__c = pp.Date_Text__c;
                    app.CA_License_Payment__c = pp.License_Payment__c;
                    app.Maintenance_Payment__c = pp.Maintenance_Payment__c;
                    app.CA_Payment_Date__c = pp.Payment_Date__c;
                    app.CA_Payment_Plan_Id__c = pp.Id;
                    app.Payment_Total__c = pp.Payment_Total__c;
                    app.Payment_Type__c = pp.Payment_Type__c;
                    app.Services_Payment__c = pp.Services_Payment__c;
                    app.Subscription_Payment__c = pp.Subscription_Payment__c;
                    app.Agreement__c = agree.Id;
                    app.Initial_Payment__c = pp.Initial_Payment__c;
                    app.Milestone_Description__c = pp.Milestone_Description__c;
                    app.Milestone_Number__c = pp.Milestone_Number__c;
                    app.Number_of_Milestones__c = pp.Number_of_Milestones__c;
                    app.Payment_Of_Total__c = pp.Payment_Percent_Of_Total__c;
                    app.Payment_Amount__c = pp.Payment_Amount__c;
                    app.CA_Payment_Date_Services__c = pp.Payment_Date_Services__c;
                    app.Project_ID__c = pp.Project_ID__c;
                    app.sfxId__c = pp.sfxId__c;
                    app.Total_Payments__c = pp.Total_Payments__c;
                    app.CurrencyIsoCode = agree.CurrencyIsoCode;
                    //app.Name = pp.Name;
                    listOfPaymentPlans.add(app);
                }           
            }
        }
        system.debug('listOfPaymentPlans.....'+listOfPaymentPlans+'listOfPaymentPlans.....Size:'+listOfPaymentPlans.size());
        if(listOfPaymentPlans.size() > 0){
            insert listOfPaymentPlans;
        }
    }

    public static void deleteAgreementPaymentPlans(List<PaymentPlan__c> oldListpp){
        
        Set<String> qppIds = new Set<String> ();
        for(PaymentPlan__c oldQpr: oldListpp){            
            qppIds.add(oldQpr.CPQ_Quote_NUmber__c);
        }
        system.debug('********qppIds'+qppIds);
        List<Agreement_Payment_Plan__c> listOfPaymentPlan = [Select id,CA_Payment_Plan_Id__c from Agreement_Payment_Plan__c where CPQ_Quote_Number__c IN:qppIds and CA_Is_this_Payment_Plan_Manually_Added__c = false and (Agreement__r.Apttus__Status_Category__c =: Label.Request or Agreement__r.Apttus__Status_Category__c =: Label.In_Authoring)];
        system.debug('********listOfPaymentPlan'+listOfPaymentPlan );
        if(listOfPaymentPlan.size()>0){
            delete listOfPaymentPlan;
        }
    
    }

}