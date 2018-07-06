/*****************************************************
Name : SAPRequestPayLoad
Created By :Patsa27
Created Date : August 18, 2018
Description : Creating JSON Request for SAP call out.
*******************************************************/
public class SAPRequestPayload {
    
      public Static SAPRequestPayloadutility.QuoteHeaderDetails HEADER_DETAILS=new SAPRequestPayloadutility.QuoteHeaderDetails();
      public Static SAPRequestPayloadutility.BillPlanDetails BILLPLAN_DETAILS=new SAPRequestPayloadutility.BillPlanDetails();
      public Static SAPRequestPayloadutility.QuoteIteamDetails ITEM_DETAILS=new SAPRequestPayloadutility.QuoteIteamDetails();
      public Static SAPRequestPayloadutility.QuotePricingDetails PRICING_DETAILS=new SAPRequestPayloadutility.QuotePricingDetails();
      public Static SAPRequestPayloadutility.QuoteVariantConfigDetails VARIANT_CONFIG_DETAILS=new SAPRequestPayloadutility.QuoteVariantConfigDetails();
      public Static SAPRequestPayloadutility.SalesText  SALES_TEXT=new SAPRequestPayloadutility.SalesText();
      Public Static Map<string,SBQQ__QuoteLine__c> parentQuoteLineMap=new Map<String,SBQQ__QuoteLine__c>();
      public static Map<String,SBQQ__QuoteLine__c> vCdetailMap=new Map<String,SBQQ__QuoteLine__c>();

    JSONGenerator g = JSON.createGenerator(false);
    
 public  string requestDataInjson(String QuoteId){  
        String jsons='';
        String replaceString;

     if(QuoteId!=null){
      SBQQ__Quote__c sQuote=[select id,Quote_Effective_Date__c ,EndUser_BPID__c,Reseller_BPID__c,SBQQ__PaymentTerms__c,Start_Date_Min__c,ExtnCAEaid__c,SAP_Quote_Number__c,SBQQ__NetAmount__c ,SBQQ__Type__c,End_Date_form__c,Salesforce_CPQ_Quote_Signed__c,(Select Date__c,Amount__c,Payment_Schedule_Total__c,Quote_Total__c from Payment_Plans__r),Document_Type__c,Caller_System__c,SoldTo_Country__c,CurrencyIsoCode,
                                 Opportunity_Number__c,Opportunity_Transaction_Type__c,Deal_Description__c,Name,Ramp_Indicator__c,
                             (select id,Name,Renewable_ARR__c,Unlimited__c,SBQQ__Product__r.License_Metric_CPQ__c,Term_Month_Calculated__c,Total_Maintenance_Test__c,SBQQ__Discount__c,SBQQ__EffectiveQuantity__c,SBQQ__Quantity__c,Maintenance_SAP__c,Hosting_Type__c,SBQQ__ListPrice__c,ELP_Total__c,Extended_List_Price_Maint_Product__c,Free_of_Charge_Product__c,SBQQ__AdditionalDiscountAmount__c,SBQQ__NetTotal__c,CA_License_Cert__c,Maintenance_Product__c,CA_License_Type__c,SAP_Operating_System__c,License_Type__c,Quote_Type__c,
                              SBQQ__Number__c,SBQQ__ProductCode__c,Upgrade_SAP__c,Maintenance_Parent_Quote_Line__c,Business_Transaction_Type_SAP__c,Quantity_License__c,Auth_Use_Mode__c,Quantity_Distributed_Capacity__c,End_Date__c,Start_Date__c,SBQQ__StartDate__c,SBQQ__EndDate__c,Instance_Id__c,List_Price_form__c from SBQQ__LineItems__r where SBQQ__ProductCode__c!=null and (SBQQ__Quantity__c!=0 or SBQQ__PriorQuantity__c!=null)),
                                 Ramp_Bridge_Order__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SoldTo_BPID__c,ShipTo_BPID__c,BillTo_BPID__c,
                                 Sales_Rep_PMF_Key__c,BillingContact_ID__c,ShippingContact_ID__c,TechnicalContact_ID__c, Sales_Organization__c from SBQQ__Quote__c where id=:QuoteId];
          
         Map<string,SBQQ__QuoteLine__c> upgradeMap=new  Map<string,SBQQ__QuoteLine__c>();
         List<SBQQ__QuoteLine__c> ListAmend=new List<SBQQ__QuoteLine__c>();
         List<SBQQ__QuoteLine__c> ListQuoteLines=new List<SBQQ__QuoteLine__c>();


         
         for(SBQQ__QuoteLine__c sbQQ:sQuote.SBQQ__LineItems__r){
             upgradeMap.put(sbQQ.SBQQ__ProductCode__c, sbQQ);
          if((sQuote.SBQQ__Type__c=='Amendment'&&sbQQ.SBQQ__NetTotal__c>0)||
                (sQuote.SBQQ__Type__c=='Amendment'&&sbQQ.SBQQ__NetTotal__c>=0&&(sbQQ.SBQQ__ProductCode__c=='AGIGAS990'||sbQQ.SBQQ__ProductCode__c=='AGCLHT990'))){
                 ListAmend.add(sbQQ);
                 
             }
             
             if((sbQQ.SBQQ__NetTotal__c>=0&&sQuote.SBQQ__Type__c=='Renewal')||(sbQQ.SBQQ__NetTotal__c>=0&&sQuote.SBQQ__Type__c=='Quote'&&sbQQ.SBQQ__Discount__c==100)||
                ((sbQQ.SBQQ__NetTotal__c>0&&sQuote.SBQQ__Type__c=='Quote')||(sbQQ.SBQQ__NetTotal__c>=0&&sQuote.SBQQ__Type__c=='Quote'&&(sbQQ.SBQQ__ProductCode__c=='AGIGAS990'||sbQQ.SBQQ__ProductCode__c=='AGCLHT990')))){
                   ListQuoteLines.add(sbQQ); 
             }
             
         }
         
         if(sQuote.SBQQ__Type__c=='Amendment'&&(upgradeMap.containsKey('AGEEUE990')||upgradeMap.containsKey('ACEEUE990')||upgradeMap.containsKey('ACEEUS990'))){
              SAPMid_YearUpgradePayLoad SAPmid=new SAPMid_YearUpgradePayLoad();
                replaceString=SAPmid.requestDataforAmendment(sQuote);
            
         }else if(sQuote.SBQQ__Type__c=='Renewal'&&upgradeMap.containsKey('ACEEUE990')){
             SAPUpgradeRenewalPayload SAPmid=new SAPUpgradeRenewalPayload();
                replaceString=SAPmid.requestDataforUpgRenewal(sQuote);
             
             
         }else { 
            for(SBQQ__QuoteLine__c sqline:sQuote.SBQQ__LineItems__r){
             
                parentQuoteLineMap.put(sqline.Name,sqline);
                
                if(sqline.Maintenance_Product__c=='Yes'){
                    vCdetailMap.put(sqline.Maintenance_Parent_Quote_Line__c, sqline);
                    
                  }
                  
                
            }
            
        
       if(ListAmend.size()>0&&sQuote.SBQQ__Type__c=='Amendment'){
             HEADER_DETAILS=SAPRequestPayloadutility.quoteHeaderLevelDetails(sQuote,ListAmend);
            BILLPLAN_DETAILS=SAPRequestPayloadutility.billPlanDetails(sQuote.Payment_Plans__r);
            PRICING_DETAILS=quotePricingDetails(ListAmend);
            ITEM_DETAILS=SAPRequestPayloadutility.quoteIteamDetails(ListAmend);
            VARIANT_CONFIG_DETAILS=quoteVarianConfigDetails(ListAmend);
             SALES_TEXT=SAPRequestPayloadutility.quoteSalesText(sQuote);
            
        }else if(ListQuoteLines.size()>0){
            HEADER_DETAILS=SAPRequestPayloadutility.quoteHeaderLevelDetails(sQuote,ListQuoteLines);
            BILLPLAN_DETAILS=SAPRequestPayloadutility.billPlanDetails(sQuote.Payment_Plans__r);
            PRICING_DETAILS=quotePricingDetails(ListQuoteLines);
            ITEM_DETAILS=SAPRequestPayloadutility.quoteIteamDetails(ListQuoteLines);
            VARIANT_CONFIG_DETAILS=quoteVarianConfigDetails(ListQuoteLines);
             SALES_TEXT=SAPRequestPayloadutility.quoteSalesText(sQuote);
        }
               g.writeStartObject();
               g.writeObjectField('HEADER_DETAILS', HEADER_DETAILS); 
               g.writeObjectField('BILLPLAN_DETAILS', BILLPLAN_DETAILS);
               g.writeObjectField('ITEM_DETAILS', ITEM_DETAILS);
               g.writeObjectField('PRICING_DETAILS', PRICING_DETAILS);
               g.writeObjectField('VARIANT_CONFIG_DETAILS', VARIANT_CONFIG_DETAILS);
               g.writeObjectField('SALES_TEXT', SALES_TEXT);

               g.writeEndObject(); 
           jsons=g.getAsString(); 
            replaceString=jsons.replace('null', '""');
          }   
            
        }

     
      return  replaceString; 

    }
       
  public static SAPRequestPayloadutility.QuotePricingDetails quotePricingDetails(List<SBQQ__QuoteLine__c> squoteLines){
      System.debug('==============squoteLines'+squoteLines.size());
   List<Object> quotePricingInf=new List<Object>();
      SAPRequestPayloadutility.QuotePricingDetails qpriceDetail=new SAPRequestPayloadutility.QuotePricingDetails();
      if(squoteLines!=null){     
		    for(SBQQ__QuoteLine__c quotLin:squoteLines){
			   System.debug('-----------enterloop');
			  if(quotLin.SBQQ__ProductCode__c!=null){
				 System.debug('==========enterproduct');
				 
			  if(quotLin.CA_License_Type__c=='Perpetual'){
				   quotLin.CA_License_Type__c='P';  
					 
			  }else if(quotLin.CA_License_Type__c=='Subscription'){
				   quotLin.CA_License_Type__c='S';
					  
			   }
             
          if(quotLin.CA_License_Type__c=='P'&&quotLin.Maintenance_Product__c!='Yes'){
                   String LineNumber=quotLin.Name.remove('QL-');
                 SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                 
                    listPric.VALUE=String.valueOf(quotLin.ELP_Total__c);
                    
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.List_DiscountAmount  listdiscount=new SAPRequestPayloadutility.List_DiscountAmount();
                   listdiscount.LINE_NUMBER=String.ValueOf(LineNumber);
                    listdiscount.NAME='LICENSE_DISC_AMOUNT';
                    listdiscount.VALUE=String.ValueOf(quotLin.SBQQ__Discount__c);
                 quotePricingInf.add(listdiscount);
                 SAPRequestPayloadutility.Licence_Price licencePrice=new SAPRequestPayloadutility.Licence_Price();
                    licencePrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    licencePrice.NAME='LICENSE_PRICE';
                    licencePrice.VALUE=String.valueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(licencePrice);
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                
                 
                 
             }
             
             if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c!='Renewal'&&quotLin.Maintenance_Product__c=='Yes'){
                 SBQQ__QuoteLine__c qutelin=parentQuoteLineMap.get(quotLin.Maintenance_Parent_Quote_Line__c);
                 String LineNumber=qutelin.name.remove('QL-');
                  SAPRequestPayloadutility.List_Maintaince listMaintaince=new SAPRequestPayloadutility.List_Maintaince();
                    listMaintaince.LINE_NUMBER=String.ValueOf(LineNumber);
                    listMaintaince.NAME='LIST_MAINTENANCE';
                 
                    listMaintaince.VALUE=String.valueOf(quotLin.Extended_List_Price_Maint_Product__c);
                    
                 quotePricingInf.add(listMaintaince);
                 SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount=new SAPRequestPayloadutility.Maintain_Discount_Amount();
                   maintainDisc_Amount.LINE_NUMBER=String.ValueOf(LineNumber);
                    maintainDisc_Amount.NAME='MAINT_DISC_AMOUNT';
                    maintainDisc_Amount.VALUE=String.valueOf(quotLin.SBQQ__Discount__c);
                 quotePricingInf.add(maintainDisc_Amount);
                 SAPRequestPayloadutility.Maintains_Price maintPrice=new SAPRequestPayloadutility.Maintains_Price();
                  maintPrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    maintPrice.NAME='MAINTENANCE_PRICE';
                    maintPrice.VALUE=String.ValueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(maintPrice);
                 
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
             }
               System.debug('quotLin=========='+quotLin.CA_License_Type__c);
               System.debug('quotLin=========='+quotLin.Quote_Type__c);
               System.debug('quotLin=========='+quotLin.Maintenance_Product__c);

            

             if(quotLin.CA_License_Type__c=='S'&&quotLin.Maintenance_Product__c!='Yes'){
                 String LineNumber=quotLin.Name.remove('QL-');
                 System.debug('------------entersubsecrptiom');
                SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                
                    listPric.VALUE=String.ValueOf(quotLin.ELP_Total__c);
                   
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.Subscript_Disc_Amount subscriptDiscunt=new SAPRequestPayloadutility.Subscript_Disc_Amount();
                    subscriptDiscunt.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptDiscunt.NAME='SUBSCRIPT_DISC_AMT';
                    subscriptDiscunt.VALUE=String.ValueOf(quotLin.SBQQ__Discount__c);
                 quotePricingInf.add(subscriptDiscunt);
                 SAPRequestPayloadutility.Subscription_Price subscriptprice=new SAPRequestPayloadutility.Subscription_Price();
                    subscriptprice.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptprice.NAME='SUBSCRIPTION_PRICE';
                    subscriptprice.VALUE=String.ValueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(subscriptprice);
                 SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
                 
             }
             
        
             
             if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Renewal'&&quotLin.Maintenance_Product__c=='Yes'){
                    SBQQ__QuoteLine__c qutelin=parentQuoteLineMap.get(quotLin.Maintenance_Parent_Quote_Line__c);

                            System.debug('==========qutelin===='+qutelin);
                          System.debug('==========quotLin.Name===='+quotLin.Name);  
                         System.debug('==========quotLin===='+quotLin);  
                  
                    
//                   String LineNumber=quotLin.Name.remove('QL-');
                   String LineNumber=qutelin.Name.remove('QL-');
                   
                        System.debug('==========qutelin===='+qutelin);
                       System.debug('==========quotLin.Name===='+quotLin.Name);
                   
                  SAPRequestPayloadutility.List_Maintaince listMaintaince=new SAPRequestPayloadutility.List_Maintaince();
                    listMaintaince.LINE_NUMBER=String.ValueOf(LineNumber);
                    listMaintaince.NAME='LIST_MAINTENANCE';
                    listMaintaince.VALUE=String.valueOf(quotLin.Extended_List_Price_Maint_Product__c); 
                quotePricingInf.add(listMaintaince);
                SAPRequestPayloadutility.Renewal_Disc_Amount renewalDisc=new SAPRequestPayloadutility.Renewal_Disc_Amount();
                    renewalDisc.LINE_NUMBER=String.ValueOf(LineNumber);
                    renewalDisc.NAME='RENEWAL_DISC_AMT';
                    renewalDisc.VALUE=String.valueOf(quotLin.SBQQ__Discount__c);
                     quotePricingInf.add(renewalDisc);
                SAPRequestPayloadutility.Maintains_Price maintPrice=new SAPRequestPayloadutility.Maintains_Price();
                    maintPrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    maintPrice.NAME='MAINTENANCE_PRICE';
                    maintPrice.VALUE=String.valueOf(quotLin.SBQQ__NetTotal__c);
                     quotePricingInf.add(maintPrice);
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                 
                 System.debug('========quotLin.CA_License_Cert__c'+quotLin.CA_License_Cert__c);
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
               }
                                         
              }
              
              
              
          }
          System.debug('==========quotePricingInf===='+quotePricingInf);
        qpriceDetail.row=quotePricingInf;
      }
      
               
        return qpriceDetail;
    }
    
 public static SAPRequestPayloadutility.QuoteVariantConfigDetails quoteVarianConfigDetails(List<SBQQ__QuoteLine__c> sbqLines){
     List<Object> varianList=new List<Object>();
     
     for(SBQQ__QuoteLine__c quoteLine :sbqLines){
         if(quoteLine.SBQQ__ProductCode__c!=null&&quoteLine.Maintenance_Product__c!='Yes'){
                         
                String LineNumber=quoteLine.Name.remove('QL-'); 
                  SAPRequestPayloadutility.ZZUnlimLicen zzUnlim=new SAPRequestPayloadutility.ZZUnlimLicen();
                      zzUnlim.LINE_NUMBER=string.valueOf(LineNumber);
                      zzUnlim.NAME='UNLIMITED_C';                   //'ZZ_UNLIM_LICENSE';
                      if(quoteLine.Unlimited__c==true)
                         zzUnlim.VALUE='TRUE';
                       else
                         zzUnlim.VALUE='FALSE'; 
                      varianList.add(zzUnlim);

             if(quoteLine.SAP_Operating_System__c!=null&&quoteLine.SAP_Operating_System__c!='nce'){
              SAPRequestPayloadutility.ZZOpsys zzops=new SAPRequestPayloadutility.ZZOpsys();
                 zzops.LINE_NUMBER=string.valueOf(LineNumber);
                 zzops.NAME='OPERATING_SYSTEM_ORDERABLE';
                 zzops.VALUE=quoteLine.SAP_Operating_System__c;
                 varianList.add(zzops);
             }
             if(quoteLine.CA_License_Type__c!=null){
             SAPRequestPayloadutility.ZZLICTYPE zzLiceType=new SAPRequestPayloadutility.ZZLICTYPE();
                 zzLiceType.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLiceType.NAME='LICENSE_TYPE';
                 zzLiceType.VALUE=quoteLine.CA_License_Type__c.subString(0,1);
                 varianList.add(zzLiceType);
             }
               SBQQ__QuoteLine__c vcquoteMaint = vCdetailMap.get(quoteLine.Name);
             System.debug('=======vcquoteMaint===='+vcquoteMaint);
               if(vcquoteMaint!=null){ 
                 SAPRequestPayloadutility.ZZMAINT zzMaint=new SAPRequestPayloadutility.ZZMAINT();
                 zzMaint.LINE_NUMBER=string.valueOf(LineNumber);
                 zzMaint.NAME='MAINTENANCE';
                 zzMaint.VALUE=vcquoteMaint.Maintenance_SAP__c;
                 varianList.add(zzMaint);
               }else if(quoteLine.Maintenance_SAP__c!='0'){
                 SAPRequestPayloadutility.ZZMAINT zzMaint=new SAPRequestPayloadutility.ZZMAINT();
                 zzMaint.LINE_NUMBER=string.valueOf(LineNumber);
                 zzMaint.NAME='MAINTENANCE';
                 zzMaint.VALUE=quoteLine.Maintenance_SAP__c;
                 varianList.add(zzMaint);                    
               }
             if(quoteLine.Business_Transaction_Type_SAP__c!=null){
             SAPRequestPayloadutility.ZZBUSTYPE zzbustype=new SAPRequestPayloadutility.ZZBUSTYPE();
                 zzbustype.LINE_NUMBER=string.valueOf(LineNumber);
                 zzbustype.NAME='BUSINESS_TRANSACTION_TYPE';
                 zzbustype.VALUE=quoteLine.Business_Transaction_Type_SAP__c.subString(0,1);
                 varianList.add(zzbustype);
             }
             System.debug('quoteLine.Auth_Use_Mode__c======'+quoteLine.Auth_Use_Mode__c);
            if(quoteLine.Auth_Use_Mode__c!=null){
             SAPRequestPayloadutility.ZZAUTHUSEMDL zzAuthmdl=new SAPRequestPayloadutility.ZZAUTHUSEMDL();
                 zzAuthmdl.LINE_NUMBER=string.valueOf(LineNumber);
                 zzAuthmdl.NAME='AUTHORIZED_USE_MODEL';
                 zzAuthmdl.VALUE=quoteLine.Auth_Use_Mode__c.subString(0,1);
                 varianList.add(zzAuthmdl);
             }
             System.debug('========quoteLine.Quantity_License__c'+quoteLine.Quantity_License__c);
             
        if(quoteLine.Quote_Type__c=='Amendment'){
             if(quoteLine.SBQQ__EffectiveQuantity__c!=null) {
            if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_100 &&
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                SAPRequestPayloadutility.UserPack_100 zzLicnt=new SAPRequestPayloadutility.UserPack_100();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='100_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt);
                 /*SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzadd);*/
          
            }else if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_1000 && 
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                
                SAPRequestPayloadutility.UserPack_1000 zzLicnt=new SAPRequestPayloadutility.UserPack_1000();
                 zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='1000_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt);
                /* SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzadd);*/                
                
                
            }else{
                 SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                 zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt);
                 SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzadd);              
                }
             }
        }else if(quoteLine.Business_Transaction_Type_SAP__c =='Distributed Capacity'){
              
             if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_100 &&
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                SAPRequestPayloadutility.UserPack_100 zzLicnt=new SAPRequestPayloadutility.UserPack_100();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='100_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt);
                /* SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzadd);*/
          
            }else if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_1000 &&
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                
                SAPRequestPayloadutility.UserPack_1000 zzLicnt=new SAPRequestPayloadutility.UserPack_1000();
                 zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='1000_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt);
                /* SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzadd);*/                
                
                
            }else{
                 SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                 zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__Quantity__c);
                 varianList.add(zzLicnt);
                 SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.SBQQ__Quantity__c);
                 varianList.add(zzadd);              
                 }


       }else{ 
            if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_100 &&
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                SAPRequestPayloadutility.UserPack_100 zzLicnt=new SAPRequestPayloadutility.UserPack_100();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='100_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.Quantity_License__c);
                 varianList.add(zzLicnt);
          
            }else if(quoteLine.SBQQ__Product__r.License_Metric_CPQ__c==System.Label.Pack_1000 &&
              quoteLine.Auth_Use_Mode__c.subString(0,1)=='I'){
                
                SAPRequestPayloadutility.UserPack_1000 zzLicnt=new SAPRequestPayloadutility.UserPack_1000();
                 zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='1000_PACK';
                 zzLicnt.VALUE=String.valueOf(quoteLine.Quantity_License__c);
                 varianList.add(zzLicnt);
                
                
            }else{
             SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(quoteLine.Quantity_License__c);
                 varianList.add(zzLicnt);
               }
         System.debug('=========quoteLine.Quantity_Distributed_Capacity__c'+quoteLine.Quantity_Distributed_Capacity__c);
           if(quoteLine.Quantity_Distributed_Capacity__c!=null){
             SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.Quantity_Distributed_Capacity__c);
                 varianList.add(zzadd);
             }
           }
     
             
         System.debug('quoteLine.Auth_Use_Mode__c======'+quoteLine.Upgrade_SAP__c);

            if(quoteLine.Upgrade_SAP__c!=null){
             SAPRequestPayloadutility.ZZUpgradte zzupgrade=new SAPRequestPayloadutility.ZZUpgradte();
                 zzupgrade.LINE_NUMBER=string.valueOf(LineNumber);
                 zzupgrade.NAME='UPGRADE_RENEWAL';
                 zzupgrade.VALUE=quoteLine.Upgrade_SAP__c;
                 varianList.add(zzupgrade);
             }
             
                           
             
         }
          
         
     }
    
      SAPRequestPayloadutility.QuoteVariantConfigDetails quotevarit=new SAPRequestPayloadutility.QuoteVariantConfigDetails();  
        quotevarit.row=varianList;
        return quotevarit;
    }
    
 

}