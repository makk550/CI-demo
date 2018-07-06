public class SAPMid_YearUpgradePayLoad {
    
     public Static SAPRequestPayloadutility.QuoteHeaderDetails HEADER_DETAILS=new SAPRequestPayloadutility.QuoteHeaderDetails();
      public Static SAPRequestPayloadutility.BillPlanDetails BILLPLAN_DETAILS=new SAPRequestPayloadutility.BillPlanDetails();
      public Static SAPRequestPayloadutility.QuoteIteamDetails ITEM_DETAILS=new SAPRequestPayloadutility.QuoteIteamDetails();
      public Static SAPRequestPayloadutility.QuotePricingDetails PRICING_DETAILS=new SAPRequestPayloadutility.QuotePricingDetails();
      public Static SAPRequestPayloadutility.QuoteVariantConfigDetails VARIANT_CONFIG_DETAILS=new SAPRequestPayloadutility.QuoteVariantConfigDetails();
      public Static SAPRequestPayloadutility.SalesText  SALES_TEXT=new SAPRequestPayloadutility.SalesText();
      Public Static Map<string,SBQQ__QuoteLine__c> parentQuoteLineMap=new Map<String,SBQQ__QuoteLine__c>();
      public static Map<String,SBQQ__QuoteLine__c> vCdetailMap=new Map<String,SBQQ__QuoteLine__c>();
      
      public static Decimal updradeListpricTotal1=0.0;
      public static Decimal updradeListpricTotal2=0.0;
      public static Decimal updradeListpricTotal3=0.0;

      public static Decimal UEtotalAGCUNL990=0.0;
      public static Decimal UEtotalACNUNL990=0.0;
      public static Decimal UEtotalACULTE990=0.0;

      public static Decimal EEtotalAGCEEE990=0.0;
      public static Decimal EEtotalACNEEE990=0.0;
      public static Decimal EEtotalACCEES990=0.0;

      public static Decimal maintupgradeListprice=0.00;
	  public static Decimal maintUEtotal=0.00;
	  public static Decimal maintEEtotal=0.00;
    
        
      
      public static List<SBQQ__QuoteLine__c> midYearUpgradeList=new List<SBQQ__QuoteLine__c>();
      public Static List<SBQQ__QuoteLine__c> UEnetTotalList=new List<SBQQ__QuoteLine__c>();
      public Static List<SBQQ__QuoteLine__c> EEnetTotalList=new List<SBQQ__QuoteLine__c>();

    JSONGenerator g = JSON.createGenerator(false);

    
    public  string requestDataforAmendment(SBQQ__Quote__c sQuote){  
        String jsons='';
        String replaceString;

        if(sQuote!=null){
     
            for(SBQQ__QuoteLine__c sqline:sQuote.SBQQ__LineItems__r){
                parentQuoteLineMap.put(sqline.Name,sqline);
                
                if(sqline.Maintenance_Product__c=='Yes'){
                    vCdetailMap.put(sqline.Maintenance_Parent_Quote_Line__c, sqline);
                    
                }
                
                
            }
                
               for(SBQQ__QuoteLine__c sqline:sQuote.SBQQ__LineItems__r){
                   
                 if(sqline.Quote_Type__C=='Amendment'&&sqline.CA_License_Type__c!=null&&sqline.SBQQ__ProductCode__c!=null&&(sqline.CA_License_Type__c.subString(0,1)=='S'&&sqline.Hosting_Type__c=='Hosted'&&(sqline.SBQQ__ProductCode__c.containsIgnoreCase('AGCEEE990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('AGCUNL990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('AGEEUE990')))||
                 (sqline.CA_License_Type__c.subString(0,1)=='P'&&sqline.Hosting_Type__c=='On Premise'&&(sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNEEE990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990')))||
                 (sqline.CA_License_Type__c.subString(0,1)=='S'&&sqline.Hosting_Type__c=='On Premise'&&(sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACCEES990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACULTE990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUS990')))){
                     
                    midYearUpgradeList.add(sqline);   
                       
                   }
                    
                
               }
               
         for(SBQQ__QuoteLine__c sqline:midYearUpgradeList){
                   
         if(sqline.SBQQ__ProductCode__c!=null&&(sqline.SBQQ__ProductCode__c.containsIgnoreCase('AGCUNL990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACULTE990'))){
                       
                     UEnetTotalList.add(sqline);  
                       
                       
                   }
                   
        if(sqline.SBQQ__ProductCode__c!=null&&(sqline.SBQQ__ProductCode__c.containsIgnoreCase('AGCEEE990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACNEEE990')||sqline.SBQQ__ProductCode__c.containsIgnoreCase('ACCEES990'))){
                       
                     EEnetTotalList.add(sqline);  
                       
                       
                   }
                   
                   
                   
                               
               }
              
            
            for(SBQQ__QuoteLine__c squoteLine:UEnetTotalList){
              if(squoteLine.SBQQ__ProductCode__c=='AGCUNL990'){
                    UEtotalAGCUNL990+=squoteLine.SBQQ__NetTotal__c; 
                     
                 }
              if(squoteLine.SBQQ__ProductCode__c=='ACNUNL990'){
                    UEtotalACNUNL990+=squoteLine.SBQQ__NetTotal__c; 
                     
                 }
              if(squoteLine.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')&&squoteLine.Maintenance_Product__c=='Yes'){
                    maintUEtotal+=squoteLine.SBQQ__NetTotal__c; 
                     
                 }
                 
              if(squoteLine.SBQQ__ProductCode__c=='ACULTE990'){
                    UEtotalACULTE990+=squoteLine.SBQQ__NetTotal__c; 
                     
                 }
                      
                 
              }
                 
           for(SBQQ__QuoteLine__c squoteLine:EEnetTotalList){
            if(squoteLine.SBQQ__ProductCode__c=='AGCEEE990'){ 
                 EEtotalAGCEEE990+=squoteLine.SBQQ__NetTotal__c;
               }
                   
			if(squoteLine.SBQQ__ProductCode__c=='ACNEEE990'){  
					 EEtotalACNEEE990+=squoteLine.SBQQ__NetTotal__c;
				   }
            if(squoteLine.SBQQ__ProductCode__c.containsIgnoreCase('ACNEEE990')&&squoteLine.Maintenance_Product__c=='Yes'){
                    maintEEtotal+=squoteLine.SBQQ__NetTotal__c; 
                     
                }
               
            if(squoteLine.SBQQ__ProductCode__c=='ACCEES990'){   
                 EEtotalACCEES990+=squoteLine.SBQQ__NetTotal__c;
               }
                   
                   
            }
            if(maintEEtotal<0){
                maintupgradeListprice=maintUEtotal+maintEEtotal;
                maintupgradeListprice.abs();
            }
            else {
               maintupgradeListprice=maintUEtotal-maintEEtotal;
               maintupgradeListprice.abs(); 
            }
            
            
            if(EEtotalAGCEEE990<0){
                updradeListpricTotal1=UEtotalAGCUNL990+EEtotalAGCEEE990;
                updradeListpricTotal1.abs();
            }
            else {
                    updradeListpricTotal1=UEtotalAGCUNL990-EEtotalAGCEEE990;
                updradeListpricTotal1.abs();
            }
            
            
            if(EEtotalACNEEE990<0){
                updradeListpricTotal2=UEtotalACNUNL990+EEtotalACNEEE990;
                updradeListpricTotal2.abs();
            }
            else {
                    updradeListpricTotal2=UEtotalACNUNL990-EEtotalACNEEE990;
                updradeListpricTotal2.abs();
            }
            
            if(EEtotalACCEES990<0){
                updradeListpricTotal3=UEtotalACULTE990+EEtotalACCEES990;
                updradeListpricTotal3.abs();
            }
            else {
               updradeListpricTotal3=UEtotalACULTE990-EEtotalACCEES990;
                updradeListpricTotal3.abs();
            }
                  
            HEADER_DETAILS=SAPRequestPayloadutility.quoteHeaderLevelDetails(sQuote,midYearUpgradeList);
            BILLPLAN_DETAILS=SAPRequestPayloadutility.billPlanDetails(sQuote.Payment_Plans__r);
            PRICING_DETAILS=quotePricingDetails(sQuote,midYearUpgradeList);
            ITEM_DETAILS=quoteIteamDetails(midYearUpgradeList);
            VARIANT_CONFIG_DETAILS=quoteVarianConfigDetails(midYearUpgradeList);
             SALES_TEXT=SAPRequestPayloadutility.quoteSalesText(sQuote);
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

     
     return  replaceString;  

    }
    
   
   public static SAPRequestPayloadutility.QuoteIteamDetails quoteIteamDetails(List<SBQQ__QuoteLine__c> sbqLines){
       List<SAPRequestPayloadutility.QuoteIteamList> quoteIteams=new List<SAPRequestPayloadutility.QuoteIteamList>();
              SAPRequestPayloadutility.QuoteIteamDetails quoteDetails=new SAPRequestPayloadutility.QuoteIteamDetails();
       System.debug('-------sbqLines-'+sbqLines);
       if(sbqLines!=null&&sbqLines.size()>0){
           for(SBQQ__QuoteLine__c quotLin :sbqLines ){
          if(quotLin.SBQQ__ProductCode__c!=null&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c!='AGCEEE990'&&quotLin.SBQQ__ProductCode__c!='ACNEEE990'&&quotLin.SBQQ__ProductCode__c!='ACCEES990'){
                String LineNumber=quotLin.Name.remove('QL-');
               SAPRequestPayloadutility.QuoteIteamList qutem=new SAPRequestPayloadutility.QuoteIteamList();
               qutem.LINE_NUMBER=String.ValueOf(LineNumber);
               qutem.MATERIAL=quotLin.SBQQ__ProductCode__c;
               qutem.QUANTITY='1';
               qutem.INSTALLATION_DATE=SAPRequestPayloadutility.ConcadnateDates(quotLin.Start_Date__c);
                System.debug(' qutem.INSTALLATION_DATE==============='+ qutem.INSTALLATION_DATE);
               qutem.DISMANTLING_DATE=SAPRequestPayloadutility.ConcadnateDates(quotLin.End_Date__c);
                System.debug(' qutem.DISMANTLING_DATE======'+ qutem.DISMANTLING_DATE);
               qutem.RENEWABLE_ARR=String.valueOf(quotLin.Renewable_ARR__c);
              SBQQ__QuoteLine__c squotelinemaint=vCdetailMap.get(quotLin.Name);
              if(String.isNotBlank(quotLin.Instance_Id__c)){
               qutem.PRODUCT_INSTANCE_ID=quotLin.Instance_Id__c;
              }else if(squotelinemaint!=null&&String.isNotBlank(squotelinemaint.Instance_Id__c)){
                qutem.PRODUCT_INSTANCE_ID=squotelinemaint.Instance_Id__c;    
              }else{
                   qutem.PRODUCT_INSTANCE_ID='';  
               }  
              if(quotLin.Free_of_Charge_Product__c==true)
                qutem.FOC_FLAG='X';
              else
               qutem.FOC_FLAG='';
              
               quoteIteams.add(qutem);  
            
            }
                 
        }
            
          quoteDetails.row=quoteIteams;
           
         }
        
        
        
        return quoteDetails;
    }
    
  
   


   
  public static SAPRequestPayloadutility.QuotePricingDetails quotePricingDetails(SBQQ__Quote__c squote,List<SBQQ__QuoteLine__c> squoteLines){
      
      String MainainceLineNumber;
               
   List<Object> quotePricingInf=new List<Object>();
      SAPRequestPayloadutility.QuotePricingDetails qpriceDetail=new SAPRequestPayloadutility.QuotePricingDetails();
      Map<String,SBQQ__QuoteLine__c> mapquoteLine=new Map<String,SBQQ__QuoteLine__c>();
      Set<string> mainaincesku=new set<string>();
      if(squoteLines!=null){ 
          for(SBQQ__QuoteLine__c quotLin:squoteLines){
                if(quotLin.CA_License_Type__c=='Perpetual'){
                   quotLin.CA_License_Type__c='P';  
                 
              }else if(quotLin.CA_License_Type__c=='Subscription'){
                  quotLin.CA_License_Type__c='S';
                  
              }
              if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Amendment'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990')){
                 mapquoteLine.put(quotLin.SBQQ__ProductCode__c, quotLin) ;
                  
              } 
             
              
              
          }
          if(mapquoteLine.size()>0){
             MainainceLineNumber=mapquoteLine.get('ACEEUE990').name.remove('QL-'); 
          }
          
        Integer maintNumtime=0;
       for(SBQQ__QuoteLine__c quotLin:squoteLines){
           System.debug('-----------enterloop');
         if(quotLin.SBQQ__ProductCode__c!=null&&quotLin.SBQQ__ProductCode__c!='AGCEEE990'&&quotLin.SBQQ__ProductCode__c!='ACNEEE990'&&quotLin.SBQQ__ProductCode__c!='ACNEEE990 - Maintenance'&&quotLin.SBQQ__ProductCode__c!='ACCEES990'){
             System.debug('==========enterproduct');
                if(quotLin.CA_License_Type__c=='Perpetual'){
                   quotLin.CA_License_Type__c='P';  
                 
               }else if(quotLin.CA_License_Type__c=='Subscription'){
                  quotLin.CA_License_Type__c='S';
                  
               }
              
                

              if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Amendment'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')){
                   
                  String LineNumber=quotLin.Name.remove('QL-');
                 SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.valueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.List_DiscountAmount  listdiscount=new SAPRequestPayloadutility.List_DiscountAmount();
                   listdiscount.LINE_NUMBER=String.ValueOf(LineNumber);
                    listdiscount.NAME='LICENSE_DISC_AMOUNT';
                    listdiscount.VALUE= '100';
                 quotePricingInf.add(listdiscount);
                 SAPRequestPayloadutility.Licence_Price licencePrice=new SAPRequestPayloadutility.Licence_Price();
                    licencePrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    licencePrice.NAME='LICENSE_PRICE';                                   
                    licencePrice.VALUE=String.valueOf(0);       //
                 quotePricingInf.add(licencePrice);
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);                
                 
             }
             
             if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Amendment'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUE990')){
                   String LineNumber=quotLin.Name.remove('QL-');
                 SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.valueOf(updradeListpricTotal2);
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.List_DiscountAmount  listdiscount=new SAPRequestPayloadutility.List_DiscountAmount();
                   listdiscount.LINE_NUMBER=String.ValueOf(LineNumber);
                    listdiscount.NAME='LICENSE_DISC_AMOUNT';
                    listdiscount.VALUE=String.ValueOf(0);
                 quotePricingInf.add(listdiscount);
                 SAPRequestPayloadutility.Licence_Price licencePrice=new SAPRequestPayloadutility.Licence_Price();
                    licencePrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    licencePrice.NAME='LICENSE_PRICE';
                    licencePrice.VALUE=String.valueOf(updradeListpricTotal2);       //squote.SBQQ__NetAmount__c
                 quotePricingInf.add(licencePrice);
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);                
                 
             }
             
              if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Amendment'&&quotLin.Maintenance_Product__c=='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACNUNL990')){
                   SBQQ__QuoteLine__c qutelin=parentQuoteLineMap.get(quotLin.Maintenance_Parent_Quote_Line__c);
                 String LineNumber=qutelin.name.remove('QL-');
                  SAPRequestPayloadutility.List_Maintaince listMaintaince=new SAPRequestPayloadutility.List_Maintaince();
                    listMaintaince.LINE_NUMBER=String.ValueOf(LineNumber);
                    listMaintaince.NAME='LIST_MAINTENANCE';
                    listMaintaince.VALUE=String.valueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(listMaintaince);
                 SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount=new SAPRequestPayloadutility.Maintain_Discount_Amount();
                   maintainDisc_Amount.LINE_NUMBER=String.ValueOf(LineNumber);
                    maintainDisc_Amount.NAME='MAINT_DISC_AMOUNT';
                    maintainDisc_Amount.VALUE=String.valueOf(100);
                 quotePricingInf.add(maintainDisc_Amount);
                 SAPRequestPayloadutility.Maintains_Price maintPrice=new SAPRequestPayloadutility.Maintains_Price();
                  maintPrice.LINE_NUMBER=String.ValueOf(LineNumber);
                    maintPrice.NAME='MAINTENANCE_PRICE';
                    maintPrice.VALUE=String.ValueOf(0);
                 quotePricingInf.add(maintPrice);  
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
             }
             
             if(quotLin.CA_License_Type__c=='P'&&quotLin.Quote_Type__c=='Amendment'&&quotLin.Maintenance_Product__c=='Yes'&&maintNumtime==0){
                  maintNumtime=1;
                  SAPRequestPayloadutility.List_Maintaince listMaintaince=new SAPRequestPayloadutility.List_Maintaince();
                    listMaintaince.LINE_NUMBER=String.ValueOf(MainainceLineNumber);
                    listMaintaince.NAME='LIST_MAINTENANCE';
                    listMaintaince.VALUE=String.valueOf(maintupgradeListprice);
                 quotePricingInf.add(listMaintaince);
                 SAPRequestPayloadutility.Maintain_Discount_Amount maintainDisc_Amount=new SAPRequestPayloadutility.Maintain_Discount_Amount();
                   maintainDisc_Amount.LINE_NUMBER=String.ValueOf(MainainceLineNumber);
                    maintainDisc_Amount.NAME='MAINT_DISC_AMOUNT';
                    maintainDisc_Amount.VALUE=String.valueOf(0);
                 quotePricingInf.add(maintainDisc_Amount);
                 SAPRequestPayloadutility.Maintains_Price maintPrice=new SAPRequestPayloadutility.Maintains_Price();
                  maintPrice.LINE_NUMBER=String.ValueOf(MainainceLineNumber);
                    maintPrice.NAME='MAINTENANCE_PRICE';
                    maintPrice.VALUE=String.ValueOf(maintupgradeListprice);
                 quotePricingInf.add(maintPrice);  
                  SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(MainainceLineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
             }
              

              
       
               if(quotLin.CA_License_Type__c=='S'&&quotLin.Hosting_Type__c=='Hosted'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('AGCUNL990')){
                  
                   String LineNumber=quotLin.Name.remove('QL-');
                 System.debug('------------entersubsecrptiom');
                SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.ValueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.Subscript_Disc_Amount subscriptDiscunt=new SAPRequestPayloadutility.Subscript_Disc_Amount();
                    subscriptDiscunt.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptDiscunt.NAME='SUBSCRIPT_DISC_AMT';
                    subscriptDiscunt.VALUE=String.ValueOf(100);
                 quotePricingInf.add(subscriptDiscunt);
                 SAPRequestPayloadutility.Subscription_Price subscriptprice=new SAPRequestPayloadutility.Subscription_Price();
                    subscriptprice.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptprice.NAME='SUBSCRIPTION_PRICE';
                    subscriptprice.VALUE=String.ValueOf(0);        //quotLin.SBQQ__NetTotal__c
                 quotePricingInf.add(subscriptprice);
                 SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
                 
             }
             
             if(quotLin.CA_License_Type__c=='S'&&quotLin.Hosting_Type__c=='Hosted'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('AGEEUE990')){
                 String LineNumber=quotLin.Name.remove('QL-');
                 System.debug('------------entersubsecrptiom');
                SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.ValueOf(updradeListpricTotal1);
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.Subscript_Disc_Amount subscriptDiscunt=new SAPRequestPayloadutility.Subscript_Disc_Amount();
                    subscriptDiscunt.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptDiscunt.NAME='SUBSCRIPT_DISC_AMT';
                    subscriptDiscunt.VALUE=String.ValueOf(0);
                 quotePricingInf.add(subscriptDiscunt);
                 SAPRequestPayloadutility.Subscription_Price subscriptprice=new SAPRequestPayloadutility.Subscription_Price();
                    subscriptprice.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptprice.NAME='SUBSCRIPTION_PRICE';
                    subscriptprice.VALUE=String.ValueOf(updradeListpricTotal1); 
                 quotePricingInf.add(subscriptprice);
                 SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
                 
             }
             
             
              
             
           
            if(quotLin.CA_License_Type__c=='S'&&quotLin.Hosting_Type__c=='On Premise'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACULTE990')){
                  
                   String LineNumber=quotLin.Name.remove('QL-');
                 System.debug('------------entersubsecrptiom');
                SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.ValueOf(quotLin.SBQQ__NetTotal__c);
                 quotePricingInf.add(listPric);
                 SAPRequestPayloadutility.Subscript_Disc_Amount subscriptDiscunt=new SAPRequestPayloadutility.Subscript_Disc_Amount();
                    subscriptDiscunt.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptDiscunt.NAME='SUBSCRIPT_DISC_AMT';
                    subscriptDiscunt.VALUE=String.ValueOf(100);
                 quotePricingInf.add(subscriptDiscunt);
                 SAPRequestPayloadutility.Subscription_Price subscriptprice=new SAPRequestPayloadutility.Subscription_Price();
                    subscriptprice.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptprice.NAME='SUBSCRIPTION_PRICE';
                    subscriptprice.VALUE=String.ValueOf(0);        //quotLin.SBQQ__NetTotal__c
                 quotePricingInf.add(subscriptprice);
                 SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
                 
             }
             
         if(quotLin.CA_License_Type__c=='S'&&quotLin.Hosting_Type__c=='On Premise'&&quotLin.Maintenance_Product__c!='Yes'&&quotLin.SBQQ__ProductCode__c.containsIgnoreCase('ACEEUS990')){
                 String LineNumber=quotLin.Name.remove('QL-');
                 System.debug('------------entersubsecrptiom');
              SAPRequestPayloadutility.ListPriceValues listPric=new SAPRequestPayloadutility.ListPriceValues();
                   listPric.LINE_NUMBER=String.ValueOf(LineNumber);
                    listPric.NAME='LIST_PRICE';
                    listPric.VALUE=String.ValueOf(updradeListpricTotal3);
                 quotePricingInf.add(listPric);
              SAPRequestPayloadutility.Subscript_Disc_Amount subscriptDiscunt=new SAPRequestPayloadutility.Subscript_Disc_Amount();
                    subscriptDiscunt.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptDiscunt.NAME='SUBSCRIPT_DISC_AMT';
                    subscriptDiscunt.VALUE=String.ValueOf(0);
                 quotePricingInf.add(subscriptDiscunt);
             SAPRequestPayloadutility.Subscription_Price subscriptprice=new SAPRequestPayloadutility.Subscription_Price();
                    subscriptprice.LINE_NUMBER=String.ValueOf(LineNumber);
                    subscriptprice.NAME='SUBSCRIPTION_PRICE';
                    subscriptprice.VALUE=String.ValueOf(updradeListpricTotal3); 
                 quotePricingInf.add(subscriptprice);
             SAPRequestPayloadutility.CA_LICENSECERT calicen=new SAPRequestPayloadutility.CA_LICENSECERT();
                     calicen.LINE_NUMBER=String.ValueOf(LineNumber);
                    calicen.NAME='CA_LICENSE_CERT';
                    calicen.VALUE=String.valueOf(quotLin.CA_License_Cert__c);
                    quotePricingInf.add(calicen);
                 
                 
             }
                       
          }
          System.debug('==========quotePricingInf===='+quotePricingInf);
       
      }
     qpriceDetail.row=quotePricingInf;  
    }
   return qpriceDetail;
  }  
 public static SAPRequestPayloadutility.QuoteVariantConfigDetails quoteVarianConfigDetails(List<SBQQ__QuoteLine__c> sbqLines){
     List<Object> varianList=new List<Object>();
       Decimal AGEEUE990Qutity=0;
       Decimal ACEEUE990Quantity=0;
       Decimal ACEEUS990Quantity=0;


     for(SBQQ__QuoteLine__c quoteLine :sbqLines){
         if(quoteLine.SBQQ__ProductCode__c!=null&&quoteLine.Maintenance_Product__c!='Yes'&&quoteLine.SBQQ__ProductCode__c!='AGCEEE990'&&quoteLine.SBQQ__ProductCode__c!='ACNEEE990'&&quoteLine.SBQQ__ProductCode__c!='ACCEES990'){
                         
                String LineNumber=quoteLine.Name.remove('QL-'); 
                
                if(quoteLine.SBQQ__ProductCode__c=='AGCUNL990'||quoteLine.SBQQ__ProductCode__c=='AGEEUE990')
                    AGEEUE990Qutity=quoteLine.SBQQ__EffectiveQuantity__c;
                if(quoteLine.SBQQ__ProductCode__c=='ACNUNL990'||quoteLine.SBQQ__ProductCode__c=='ACEEUE990')
                    ACEEUE990Quantity=quoteLine.SBQQ__EffectiveQuantity__c;
                if(quoteLine.SBQQ__ProductCode__c=='ACULTE990'||quoteLine.SBQQ__ProductCode__c=='ACEEUS990')
                    ACEEUS990Quantity=quoteLine.SBQQ__EffectiveQuantity__c;

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
             System.debug('========quoteLine.SBQQ__EffectiveQuantity__c'+quoteLine.SBQQ__EffectiveQuantity__c);
             if(quoteLine.SBQQ__EffectiveQuantity__c!=null&&quoteLine.SBQQ__ProductCode__c=='AGEEUE990'){
             SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(AGEEUE990Qutity);
                 varianList.add(zzLicnt);
             }else if(quoteLine.SBQQ__EffectiveQuantity__c!=null&&quoteLine.SBQQ__ProductCode__c=='ACEEUE990'){
             SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(ACEEUE990Quantity);
                 varianList.add(zzLicnt);
             }else  if(quoteLine.SBQQ__EffectiveQuantity__c!=null&&quoteLine.SBQQ__ProductCode__c=='ACEEUS990'){
             SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(ACEEUS990Quantity);
                 varianList.add(zzLicnt);
             }else if(quoteLine.SBQQ__EffectiveQuantity__c!=null){
                SAPRequestPayloadutility.ZZLICINST zzLicnt=new SAPRequestPayloadutility.ZZLICINST();
                zzLicnt.LINE_NUMBER=string.valueOf(LineNumber);
                 zzLicnt.NAME='LICENSED_QUANTITY';
                 zzLicnt.VALUE=String.valueOf(quoteLine.SBQQ__EffectiveQuantity__c);
                 varianList.add(zzLicnt); 
                 
                 
                 
             }
            
             
            if(quoteLine.Quantity_Distributed_Capacity__c!=null){
             SAPRequestPayloadutility.ZZADDINST zzadd=new SAPRequestPayloadutility.ZZADDINST();
                 zzadd.LINE_NUMBER=string.valueOf(LineNumber);
                 zzadd.NAME='ADDITIONAL_INSTANCES';
                 zzadd.VALUE=String.valueOf(quoteLine.Quantity_Distributed_Capacity__c);
                 varianList.add(zzadd);
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