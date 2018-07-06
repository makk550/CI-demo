global class SAPPayloadRequiredFieldsValidations {
    
    
    WebService static List<string> validationProcess(String QuoteId){
      //US487512 & US489475 - PORAS01
        //Querying another field - "Concession_offered_due_to_a_prior_deal__c" & "Isthisdeallinkedtootherdeals__c"
      SBQQ__Quote__c sQuote=[select id,Start_Date_Min__c,SAP_Quote_Number__c,SBQQ__Primary__c,End_Date_form__c,Sales_Organization__c,TechnicalContact_Email__c,SBQQ__Opportunity2__r.RecordTypeId,SBQQ__Opportunity2__r.StageName, Salesforce_CPQ_Quote_Signed__c,(Select Name,Date__c,Amount__c,Payment_Schedule_Total__c,Quote_Total__c from Payment_Plans__r),SBQQ__Status__c,Document_Type__c,Caller_System__c,SoldTo_Country__c,CurrencyIsoCode,
                                 Opportunity_Number__c,Opportunity_Transaction_Type__c,Name,Ramp_Indicator__c,(select id,name,Renewable_ARR__c,Maintenance_Product__c,Auth_Use_Mode__c,Business_Transaction_Type_SAP__c,CA_License_Type__c,SAP_Operating_System__c,License_Type__c,Quote_Type__c,
                                                                                                               SBQQ__Number__c,SBQQ__ProductCode__c,Start_Date__c,End_Date__c,
                                                                                                               Instance_Id__c,List_Price_form__c from SBQQ__LineItems__r where SBQQ__ProductCode__c!=null and Maintenance_Product__c!='Yes'),
                                 Ramp_Bridge_Order__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SoldTo_BPID__c,ShipTo_BPID__c,BillTo_BPID__c,Concession_offered_due_to_a_prior_deal__c,//Isthisdeallinkedtootherdeals__c,
                                 Sales_Rep_PMF_Key__c,BillingContact_ID__c,ShippingContact_ID__c,TechnicalContact_ID__c from SBQQ__Quote__c where id=:QuoteId];
        //US487512 & US489475 - PORAS01 - End
        
      List<string> errorList=new List<String>();
      List<string> OkList=new List<String>();
        System.debug('========sQuote====='+sQuote.SBQQ__LineItems__r);
        RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');
        string entlSyncRecType;
        if(entlSync!=null)
            entlSyncRecType = entlSync.RecordType_Id__c;
       if(sQuote.SBQQ__Opportunity2__r.RecordTypeId==entlSyncRecType){
          string ermesage='';
            
            ermesage='Opportunity Record Type Entitlement Sync not supported for SAP integration.';
           errorList.add(ermesage); 
            
        }else{
        
        //US487512 & US489475 - PORAS01
        RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
        string steelBrickRecType;
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;
        if(String.isNotBlank(sQuote.SBQQ__Opportunity2__r.RecordTypeId) && sQuote.SBQQ__Opportunity2__r.RecordTypeId == steelBrickRecType){
            if(sQuote.SBQQ__Opportunity2__r.StageName == Label.Opp_Stage_Closed_Won && sQuote.SBQQ__Primary__c){
                if(String.isBlank(sQuote.Concession_offered_due_to_a_prior_deal__c)){
                    String ermesage = '';
                    ermesage = 'Discount Concession Flag must be set on Primary Quote to set Send to SAP';
                    errorList.add(ermesage);    
                }
                
                //Suppressing the contract linkage flag as per business requirement to hold it for now. *DO NOT REMOVE* - PORAS01
                /*if(String.isBlank(sQuote.Isthisdeallinkedtootherdeals__c)){
                    String ermesage = '';                    
                    ermesage = 'Contract Linkage Flag must be set on Primary Quote to set Send to SAP';
                    errorList.add(ermesage);
                }*/
                
            }       
        }
        //US487512 & US489475 - PORAS01 - End
        
        if(sQuote.SBQQ__Status__c=='Draft'||sQuote.SBQQ__Status__c=='Rejected'||sQuote.SBQQ__Status__c=='Denied'){
          string opermesage='';
            
            opermesage='Quote status should not be Draft/Rejected/Denied';
           errorList.add(opermesage); 
            
        }
        if(sQuote.SBQQ__LineItems__r==null||sQuote.SBQQ__LineItems__r.isEmpty()){
           string Linermesage='';
            
            Linermesage='Line items Required.';
          System.debug('=====Linermesage');
           errorList.add(Linermesage); 
            
        }else{
            
            for(SBQQ__QuoteLine__c sbqline:sQuote.SBQQ__LineItems__r){
              
                
              if(!String.isNotBlank(String.valueOf(sbqline.CA_License_Type__c))){
                  String LiMessage='';
                      LiMessage='License Type required'+' '+sbqline.name;  
                errorList.add(LiMessage);      
                
                }
                
                if(!String.isNotBlank(String.valueOf(sbqline.Auth_Use_Mode__c))){
                  String authMessage='';
                      authMessage='Auth Use Model required '+' '+sbqline.name;  
                errorList.add(authMessage);      
                
                }
                
               
                
                if(!String.isNotBlank(String.valueOf(sbqline.Start_Date__c))){
                  String quoteLineMessage='';
                      quoteLineMessage='Quote Line Start date required for'+' '+sbqline.name;
                errorList.add(quoteLineMessage);      
                
                }
                
                 if(!String.isNotBlank(String.valueOf(sbqline.End_Date__c))){
                  String quoteLineMessageend='';
                      quoteLineMessageend='Quote Line End Date required for'+' '+sbqline.name;  
                errorList.add(quoteLineMessageend);      
                
                }
                

               if(!String.isNotBlank(String.valueOf(sbqline.Business_Transaction_Type_SAP__c))){
                  String quoteLineBusinessTran='';
                      quoteLineBusinessTran='Business Transaction Type Required'+' '+sbqline.name;  
                    errorList.add(quoteLineBusinessTran);      
                
                }
                
               


                
                
          }
            
        }
        if(sQuote.Payment_Plans__r==null||sQuote.Payment_Plans__r.isEmpty()){
           String paymentPlanMessage='';
                      System.debug('=====paymentPlanMessage');

            paymentPlanMessage='Payment Plan Required';
            errorList.add(paymentPlanMessage);
            
            
        }else{
            
            for(Payment_Plan__c bilplan:sQuote.Payment_Plans__r){
                
                if(bilplan.Date__c==null){
                  errorList.add('Payment Plan Date Required'+' '+bilplan.name);  
                    
                }
                
                if(bilplan.Amount__c==null){
                   errorList.add('Payment Plan Amount Required'+' '+bilplan.name);  
                    
                }
                
                
                
            }
            
        }
        System.debug('document type'+sQuote.Document_Type__c);
        if(!String.isNotBlank(String.valueOf(sQuote.Document_Type__c))){
           String docMesaage='';
            docMesaage='Document Type Required';
            errorList.add(docMesaage);
                       
        }
         if(!String.isNotBlank(String.valueOf(sQuote.Sales_Rep_PMF_Key__c))){
           String salesrepMessage='';
            salesrepMessage='Sales Rep Required';
            errorList.add(salesrepMessage);
                       
        }

         if(!String.isNotBlank(String.valueOf(sQuote.Sales_Organization__c))){
           String salesOrgMessage='';
            salesOrgMessage='Sales Organization Required';
            errorList.add(salesOrgMessage);
                       
        }             
         if(!String.isNotBlank(String.valueOf(sQuote.TechnicalContact_Email__c))){
           String TCMail='';
            TCMail='Technical Contact Email Address Required';
            errorList.add(TCMail);
                       
        }
        
        if(!String.isNotBlank(String.valueOf(sQuote.Caller_System__c))){
             String CallMesaage='';
           CallMesaage='Caller System Required';
             errorList.add(CallMesaage);
        }
        if(!String.isNotBlank(String.valueOf(sQuote.SoldTo_Country__c))){
            String soldCountMesaage='';
           soldCountMesaage='Sold to Country Required';
             errorList.add(soldCountMesaage);
            
        }
        if(!String.isNotBlank(String.valueOf(sQuote.Opportunity_Number__c))){
              String oppNumbMesaage='';

            oppNumbMesaage='Opportunity Number Required';
               errorList.add(oppNumbMesaage);

        }
        if(!String.isNotBlank(String.valueOf(sQuote.Start_Date_Min__c))){
            String startDateMesaage='';
          startDateMesaage='Quote start Date Required';
               errorList.add(startDateMesaage);
            
        }
        if(!String.isNotBlank(String.valueOf(sQuote.End_Date_form__c))){
               String EndDateMesaage='';
             EndDateMesaage='Quote End date Required';
             errorList.add(EndDateMesaage);

        }
        if(!String.isNotBlank(String.valueOf(sQuote.SoldTo_BPID__c))){
               String soldtoMesaage='';
             soldtoMesaage='Sold to ID # Required';
             errorList.add(soldtoMesaage);

        }
        if(!String.isNotBlank(String.valueOf(sQuote.ShipTo_BPID__c))){
               String ShiptoMesaage='';
             ShiptoMesaage='Ship to ID # Required';
             errorList.add(ShiptoMesaage);

        }
        if(!String.isNotBlank(String.valueOf(sQuote.BillTo_BPID__c))){
               String BilltoMesaage='';
             BilltoMesaage='Bill to ID # Required';
             errorList.add(BilltoMesaage);

        }
        if(!String.isNotBlank(String.valueOf(sQuote.TechnicalContact_ID__c))){
               String TechMesaage='';
             TechMesaage='Technical contact Required';
             errorList.add(TechMesaage);

        }
        
        if(sQuote.SBQQ__Primary__c!=true){
           String primaryMesaage='';
             primaryMesaage='Quote should be primary.';
             errorList.add(primaryMesaage);  
            
          }
        } 
        
      
        
        if(errorList.size()>0){
          System.debug('===========errorList'+errorList);
           return errorList; 
        }else{
            string success='OK';
           OkList.add(success); 
            
        return OkList;            
        }  
    }
    
}