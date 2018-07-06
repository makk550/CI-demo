trigger UpsertQuoteLineItemOnCoterm on Co_Term__c (after insert, after update,before insert,after delete) 
{
    system.debug('++++++++++++++++++++++UpsertQuoteLineItemOnCoterm started'); 
    List<PriceBook2> pricebook2List = [Select p.Name, p.Id From Pricebook2 p];
   static boolean testFlag = true;
    
    if(Trigger.isAfter && Trigger.isInsert){
        SystemIdUtility.skipUpdateCoTermTrigger = false;
       List<QuoteLineItem> qltList = new  List<QuoteLineItem>();
       Set<String> quoteIds = new Set<String>();
       Set<String> CoTermIds = new Set<String>();
       Set<String> SkuIds = new Set<String>();
       Map<String,Co_Term__c>cotermMap = new Map<String,Co_Term__c>();
       Map<String,Quote> quoteMap = new Map<String,Quote>();
        Map<String,Product2> mProduct = new Map<String,Product2>();
        
        for(Co_Term__c ct: trigger.new){
            quoteIds.add(ct.Quote__c);
            CoTermIds.add(ct.id); 
           
             if( ct.CPMS_Parent_Product_SKU__c != null && ct.CPMS_Parent_Product_SKU__c != '0'){
                 
                 SkuIds.add(ct.CPMS_Parent_Product_SKU__c);
               
            }else{
                 SkuIds.add(ct.Product_SKU__c);
            }
        }
        for( Product2 product : [select p.id, p.SKU__c,p.Disti_Discount__c, p.description,p.Product_Group__c from Product2 p where p.SKU__c  IN :SkuIds and Salesforce_CPQ_Product__c=false] ){
            mProduct.put(product.SKU__c, product);
        }
         
        for(Co_Term__c coterm: [select Days_to_Co_term__c,  Co_Term_Type_ID__c,Distil_Disc__c,Add_l_Disc__c,CPMS_Parent_Product_SKU__c,Qty__c,Quote__r.id,Product_SKU__c,Disti_Unit__c,MSRP_Unit__c,MSRP_Total__c,Pro_Rata_Total__c from Co_Term__c where id IN: CoTermIds ]){
            cotermMap.put(coterm.id, coterm);
        }
         
         for(Quote quote: [select id,CurrencyIsoCode from Quote where id IN : quoteIds]){
             if(pricebook2List != null && pricebook2List.get(1) != null){
                quote.Pricebook2Id = pricebook2List.get(1).Id;
            }
             quoteMap.put(quote.id, quote);
         }
         update quoteMap.values();
         
       for(Co_Term__c ct: trigger.new){
        
            Co_Term__c c = cotermMap.get(ct.id);
            
            Quote q = quoteMap.get(ct.Quote__c);
            system.debug('In to trigger.new'+c.CPMS_Parent_Product_SKU__c);
          
            List<QuoteLineItem> qlts = new List<QuoteLineItem>();
            if( c.CPMS_Parent_Product_SKU__c != null && c.CPMS_Parent_Product_SKU__c != '0'){
                    qlts = [select qt.id,qt.QuoteId,qt.MSRP_total__c,qt.SKU__c,qt.MSRP_Unit_Cost__c, 
                    qt.Discount_1__c,qt.Additional_Discount__c,qt.Avg_discount_value__c 
                    from QuoteLineItem qt where qt.QuoteId =: q.id AND qt.SKU__c =: c.CPMS_Parent_Product_SKU__c  ];   
                    
                    System.debug('************************* product entry '+qlts); 
                    System.debug('************************* product SKU '+c.CPMS_Parent_Product_SKU__c);
                    System.debug('************************* maint SKU-product'+c.Product_SKU__c);    
                          
            }else{
                    
                    qlts = [select qt.id,qt.QuoteId,qt.MSRP_total__c,qt.SKU__c,qt.MSRP_Unit_Cost__c, 
                    qt.Discount_1__c,qt.Additional_Discount__c,qt.Avg_discount_value__c 
                    from QuoteLineItem qt where qt.QuoteId =: q.id AND qt.SKU__c =: c.Product_SKU__c  ]; 
                    System.debug('************************* maintnance entry '+c.Product_SKU__c); 
                    System.debug('*************************maintnance  product SKU '+q.id);
                    System.debug('************************* maintnance  SKU-product'+c.CPMS_Parent_Product_SKU__c);                  
            }
           
            system.debug('Quoteline item Query'+qlts);
            if( qlts != null && qlts.size() > 0  ){
             system.debug('before test started');
                c.Quote_Line_Item__c = qlts.get(0).id;
                
                update c;
               
                if( c.CPMS_Parent_Product_SKU__c == null || c.CPMS_Parent_Product_SKU__c == '0'){
                    system.debug('test started');
                    List<Co_Term__c> updateCoTermList = [select id, Co_Term_Type_ID__c,CPMS_Parent_Product_SKU__c,Days_to_Co_term__c,Net_to_CA__c,Disti_Total__c,Distil_Disc__c,Add_l_Disc__c,MSRP_Unit__c,Qty__c,MSRP_Total__c from  Co_Term__c where Quote_Line_Item__c =: qlts.get(0).id ];
                    system.debug('test started111111111111');
                    if( updateCoTermList  != null && updateCoTermList.size() > 0 ){
                            Decimal discount = 0.00;
                            
                            Decimal additionalDisc = 0.00;
                            Decimal MSRPUnitPrice = 0.00;
                            Decimal MSRPTotal = 0.00;
                            Decimal qty = 0;
                            Decimal tempCoTermDays = 0;
                            Decimal cpmstotalPrice = 0;
                            Decimal typeId1 = 0;
                            Decimal distiTotal = 0;

                            for( Co_Term__c coTermO :updateCoTermList ){
                            system.debug('entered with same SKU value in quote line ietm');
                                if(  coTermO.CPMS_Parent_Product_SKU__c == null || coTermO.CPMS_Parent_Product_SKU__c == '0' ){
                                     
                                    qty += coTermO.Qty__c;
                                }
                                    discount += coTermO.Distil_Disc__c;
                                    
                                    additionalDisc += coTermO.Add_l_Disc__c;
                                    MSRPUnitPrice  = coTermO.MSRP_Unit__c;
                                    tempCoTermDays += coTermO.Days_to_Co_term__c;
                                    if(coTermO.Net_to_CA__c!=null)
                                    cpmstotalPrice = cpmstotalPrice + coTermO.Net_to_CA__c;
                                    else
                                    cpmstotalPrice = cpmstotalPrice;
                                    distiTotal += coTermO.Disti_Total__c;
                                     MSRPTotal += coTermO.MSRP_Total__c;
                                    typeId1 = coTermO.Co_Term_Type_ID__c;
                               
                            }
                            
                            //system.debug('@@@@@@@@@@@@@@@@@@@@@@@@'+ testTemp );
                    system.debug('discount Value :'+ discount );
                    system.debug('additionalDisc  value :'+ additionalDisc );
                    system.debug('MSRPUnitPrice  value :'+ MSRPUnitPrice );
                    system.debug('MSRPTotal value:'+MSRPTotal );
                    system.debug('Size Value :'+ updateCoTermList.size());
                    System.debug('total price' + cpmstotalPrice );
                            
                             Decimal size = updateCoTermList.size();
                             
                             QuoteLineItem updateQuoteLineItem = qlts.get(0);
                             if(mProduct.get(qlts.get(0).SKU__c)!=null&&mProduct.get(qlts.get(0).SKU__c).Disti_Discount__c!=null)
                             updateQuoteLineItem.Discount_1__c= mProduct.get(qlts.get(0).SKU__c).Disti_Discount__c;
                             updateQuoteLineItem.Avg_discount_value__c =(discount/size);
                             updateQuoteLineItem.MSRP_total__c = MSRPTotal ;
                             updateQuoteLineItem.Quantity = qty != 0 ? qty: 1;
                             updateQuoteLineItem.Disti_Total__c= distiTotal;
                             updateQuoteLineItem.CPMS_Type_id__c= typeId1;
                             
                             if( typeId1 == 1 ){
                                 updateQuoteLineItem.MSRP_Unit_Cost__c = MSRPUnitPrice ;
                             }
                             
                              Decimal MSRPUnitPrice11 = MSRPUnitPrice/size;
                              
                             updateQuoteLineItem.Additional_Discount__c= (additionalDisc/size);
                           
                           
                             //caculating successive discounts.    
                          Decimal  aggrigateDisc =  (( updateQuoteLineItem.Avg_discount_value__c*100) + (updateQuoteLineItem.Additional_Discount__c*100))/100;
                          Decimal  successiveDisc =   updateQuoteLineItem.Avg_discount_value__c * updateQuoteLineItem.Additional_Discount__c/100;                     
                          Decimal totDiscount = (aggrigateDisc- successiveDisc);
                          if(totDiscount!=null)
                             totDiscount =totDiscount.setscale(2);                                                              
                          
                          Decimal unitPrice111 = (cpmstotalPrice/(100-totDiscount))*100;  
                          
                       
                           if(unitPrice111 != 0){
                              updateQuoteLineItem.unitPrice =unitPrice111/updateQuoteLineItem.Quantity;
                          }else{
                              updateQuoteLineItem.unitPrice =0;
                          }
                          System.debug('unitPrice@@@@@@@@@@@@@@@@@@@@@ ' +  updateQuoteLineItem.unitPrice );   
                            
                             updateQuoteLineItem.Is_Co_Term_LineItem__c = true;
                              
                            system.debug(updateQuoteLineItem.Avg_discount_value__c+'&&&&'+discount+'&&&&'+size);
                             update updateQuoteLineItem;
                              system.debug('ended with same SKU value in quote line ietm');
                    
                    }
                
                }
              
            }
            else
            {
           // List<Product2> productList = new List<Product2> ();
            Product2 product;
            String skuVal = 'null';
            if( c.CPMS_Parent_Product_SKU__c != null && c.CPMS_Parent_Product_SKU__c != '0'){
                 //productList = [select p.id, p.description,p.Product_Group__c from Product2 p where p.SKU__c =: c.CPMS_Parent_Product_SKU__c ];
                  product = mProduct.get(c.CPMS_Parent_Product_SKU__c);
                 
                 skuVal = c.CPMS_Parent_Product_SKU__c;
            }else{
                //productList = [select p.id, p.description,p.Product_Group__c from Product2 p where p.SKU__c =: c.Product_SKU__c ];
                
                 product = mProduct.get(c.Product_SKU__c); 
                   skuVal = c.Product_SKU__c;
                   System.debug('--SKUVAL: '+skuval+'----product:'+product);
                     
            }
                if( product != null ){
                    //Product2 product = productList.get(0);
                    Decimal tempDiscount;
                    System.debug('Insertion Started' );
                    QuoteLineItem qlt = new QuoteLineItem();
                   
                    qlt.Quantity = c.Qty__c;
                    
                    //qlt.UnitPrice = c.MSRP_Unit__c;
                    if( c.Distil_Disc__c != null ){
                        qlt.Discount_1__c = c.Distil_Disc__c;
                        tempDiscount = c.Distil_Disc__c;
                    }
                    if( c.Add_l_Disc__c != null  && c.Add_l_Disc__c > 0 ){
                        qlt.Additional_Discount__c = c.Add_l_Disc__c;
                        tempDiscount = tempDiscount+c.Add_l_Disc__c;
                    }
                    qlt.Discount = tempDiscount;
                   
                    qlt.QuoteId = q.Id;
                    qlt.SKU__c = skuVal;
                    qlt.Disti__c = c.Disti_Unit__c;
                    qlt.Product_Description__c = product.Description;
                    qlt.Business_Unit__c = product.Product_Group__c;
                    qlt.MSRP_Unit_Cost__c = c.MSRP_Unit__c;
                    qlt.MSRP_total__c = c.MSRP_Total__c;
                    qlt.MSRP__c = c.Pro_Rata_Total__c;
                    qlt.Is_Co_Term_LineItem__c = true;
                    qlt.Avg_discount_value__c = c.Distil_Disc__c;
                    Decimal unitPrice = (qlt.MSRP_Unit_Cost__c/365)*c.Days_to_Co_term__c;
                    qlt.UnitPrice  = unitPrice;
                    
                    List<PricebookEntry> p1 = [Select p.UseStandardPrice, p.UnitPrice, p.ProductCode,
                     p.Product2Id, p.Pricebook2Id, p.Id, p.CurrencyIsoCode From PricebookEntry p 
                     where p.Product2Id =:  product.id AND  p.CurrencyIsoCode =: q.CurrencyIsoCode AND p.Pricebook2Id =: pricebook2List.get(1).Id
                     limit 1];
                     if(p1!= null && p1.size() > 0 && p1.get(0)!= null ){
                        qlt.PricebookEntryId = p1.get(0).id;
                     }
                     
                     System.debug('Insertion ended'+ qlt.PricebookEntryId);
                    
                    //qltList.add(qlt);
                    try{
                         insert qlt;
                    }catch( exception ex){
                        System.debug('Insertion failed');
                         // c.adderror('No Price book entry for  product '+c.Product_SKU__c);
                    }
                  
               
                // updating co term.    
               
                c.Quote_Line_Item__c = qlt.id;
                
                 testFlag = false;
                update c;
                 testFlag = true;
                }
            }
         
        }
        if( qltList != null && qltList.size() > 0 )
            insert qltList;
      
       SystemIdUtility.skipUpdateCoTermTrigger = true;
    }
    else if( SystemIdUtility.skipUpdateCoTermTrigger  && Trigger.isAfter && Trigger.isUpdate){
        Set<Id> quoteIds   = new Set<Id>();
        for(Co_Term__c coTerm : Trigger.New){
             quoteIds.add(coTerm.quote__c );
        }
        System.debug('quote ids: '+quoteIds);
        List<QuoteLineItem> qlts = new List<QuoteLineItem> ();
        Map<String,Product2> mProduct = new Map<String,Product2>();
        set<string>  skuset=new set<string>();
        for(QuoteLineItem ql:[select qt.id,qt.QuoteId,qt.MSRP_total__c,qt.MSRP_Unit_Cost__c, 
                qt.Discount_1__c,qt.Additional_Discount__c,qt.Is_Co_Term_LineItem__c,qt.SKU__c ,qt.Avg_discount_value__c 
                from QuoteLineItem qt where qt.QuoteId in: quoteIds])
                {
                qlts.add(ql);
                if(ql.sku__c!=null)
                skuset.add(ql.sku__c);
                }
                 for( Product2 product : [select p.id, p.SKU__c,p.Disti_Discount__c, p.description,p.Product_Group__c from Product2 p where p.SKU__c  IN :skuset and Salesforce_CPQ_Product__c=false] ){
            mProduct.put(product.SKU__c, product);
            }
                List<QuoteLineItem> updatedQli = new List<QuoteLineItem>();
        for( QuoteLineItem qlt : qlts ){
            List<Co_Term__c> updateCoTermList = [select id, Co_Term_Type_ID__c,CPMS_Parent_Product_SKU__c,Net_to_CA__c,Disti_Total__c,Distil_Disc__c,Add_l_Disc__c,Pro_Rata_Total__c,MSRP_Unit__c,Qty__c,MSRP_Total__c from  Co_Term__c where Quote_Line_Item__c =:qlt.id ];
                
            if( updateCoTermList  != null && updateCoTermList.size() > 0 ){
                    Decimal discount = 0.00;
                    Decimal additionalDisc = 0.00;
                    Decimal MSRPUnitPrice = 0.00;
                    Decimal MSRPTotal = 0.00;
                     Decimal prorateTotal = 0.00;
                    Decimal qty = 0;
                    Decimal cpmstotalPrice = 0;
                    Decimal testTemp = 0;
                    Decimal typeId1 =0;
                    Decimal distiTotal = 0;
                   
                    for( Co_Term__c coTermO :updateCoTermList ){
                    testTemp++;
                    system.debug('entered with same SKU value in quote line ietm');
                    if(  coTermO.CPMS_Parent_Product_SKU__c == null || coTermO.CPMS_Parent_Product_SKU__c == '0' ){
                       
                        qty += coTermO.Qty__c;
                        
                     }
                       discount += coTermO.Distil_Disc__c;
                       additionalDisc += coTermO.Add_l_Disc__c;
                       prorateTotal += coTermO.Pro_Rata_Total__c;
                        MSRPUnitPrice  = coTermO.MSRP_Unit__c;
                        if(coTermO.Net_to_CA__c!=null)
                        cpmstotalPrice = cpmstotalPrice + coTermO.Net_to_CA__c;
                        else
                        cpmstotalPrice = cpmstotalPrice;
                        
                        if(coTermO.Disti_Total__c!=null)
                        distiTotal += coTermO.Disti_Total__c;
                        if(coTermO.MSRP_Total__c!=null)
                        MSRPTotal += coTermO.MSRP_Total__c;
                        
                        typeId1 = coTermO.Co_Term_Type_ID__c;
                   
                    }
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@'+ testTemp );
                    system.debug('discount Value :'+ discount );
                    system.debug('additionalDisc  value :'+ additionalDisc );
                    system.debug('MSRPUnitPrice  value :'+ MSRPUnitPrice );
                    system.debug('MSRPTotal value:'+MSRPTotal );
                    system.debug('Size Value :'+ updateCoTermList.size());
                    System.debug('total price' + cpmstotalPrice );
                    
                     Decimal size = updateCoTermList.size();
                     QuoteLineItem updateQuoteLineItem = qlt;
                      if(mProduct.get(qlt.SKU__c)!=null&&mProduct.get(qlt.SKU__c).Disti_Discount__c!=null)
                     updateQuoteLineItem.Discount_1__c= mProduct.get(qlt.SKU__c).Disti_Discount__c;
                      updateQuoteLineItem.Avg_discount_value__c=(discount/size);
                     updateQuoteLineItem.Additional_Discount__c= (additionalDisc/size);
                     updateQuoteLineItem.MSRP_total__c =  MSRPTotal ;
                     
                     updateQuoteLineItem.Quantity = qty != 0 ? qty: 1;
                     updateQuoteLineItem.MSRP__c = prorateTotal;
                     
                      updateQuoteLineItem.Disti_Total__c= distiTotal;
                      updateQuoteLineItem.CPMS_Type_id__c= typeId1;
                     
                      if( typeId1 == 1 ){
                         updateQuoteLineItem.MSRP_Unit_Cost__c = MSRPUnitPrice ;
                      }
                                        
                      //caculating successive discounts.    
                      Decimal  aggrigateDisc =  (( updateQuoteLineItem.Avg_discount_value__c*100) + (updateQuoteLineItem.Additional_Discount__c*100))/100;
                      Decimal  successiveDisc =   updateQuoteLineItem.Avg_discount_value__c * updateQuoteLineItem.Additional_Discount__c/100;                     
                      Decimal totDiscount = (aggrigateDisc- successiveDisc);
                      if(totDiscount!=null)
                         totDiscount =totDiscount.setscale(2);                                                              
                      
                      Decimal unitPrice111 = (cpmstotalPrice/(100-totDiscount))*100;
                      if(unitPrice111 != 0){
                          updateQuoteLineItem.unitPrice =unitPrice111/updateQuoteLineItem.Quantity;
                      }else{
                          updateQuoteLineItem.unitPrice =0;
                      }
                                                                 
                     updateQuoteLineItem.Is_Co_Term_LineItem__c = true;                   
                     updatedQli.add(updateQuoteLineItem);
                  
                  
            }
        }
         update updatedQli;
       
    }
     else if(Trigger.isBefore && Trigger.isInsert)
     {
     System.debug('entered in Before Insert block');
            Set<string> skus = new Set<string>(); 
            Set<string> quoteIds = new Set<string>();
            Set<string> prodIds = new Set<string>();
             for(Co_Term__c coTerm : Trigger.New )
            {
                 if(coTerm.Product_SKU__c != null )
                 {
                     skus.add(coTerm.Product_SKU__c); 
                 }
                 //To create Parent Product for Product with maintenance scenario.
                 if( coTerm.CPMS_Parent_Product_SKU__c != null && coTerm.CPMS_Parent_Product_SKU__c.length()>0 ){
                     skus.add(coTerm.CPMS_Parent_Product_SKU__c);
                 }
                 
               quoteIds.add( coTerm.Quote__c );
            }
         
            Map<string, product2> mSKUProduct = new Map<string, product2>();
            Map<string, String> mSKUProductId = new Map<string, String>();
             
           for(Product2 prod: [ select id, SKU__c from Product2 where SKU__c IN : skus and Salesforce_CPQ_Product__c=false])
           {
               mSKUProduct.put(prod.SKU__c, prod);
               prodIds.add(prod.id);
               mSKUProductId.put(prod.id, prod.SKU__c);
           }
                
           
     
      
            for(Co_Term__c coTerm : Trigger.New )
            {
               if( coTerm.Product_SKU__c != null )
               {
                   if( mSKUProduct.get(coTerm.Product_SKU__c) == null)
                   {
                       coTerm.adderror('SKU ' + coTerm.Product_SKU__c + ' not found in Products');
                   }
               }
              else
                coTerm.adderror('No SKU found');
                  
            }
            
          
          
          // setting the co term currnecy value based on the quote currency.
          // defaulting currency to USD.
          // CPMS Supporting currencties are USD,GBP,EUR.
         
          Map<string, Quote> mQuote = new Map<string, Quote>();  
               
           for( Quote quote: [ select id, Opportunity.CurrencyIsoCode from quote where id IN : quoteIds])
           {
               mQuote.put(quote.id, quote);
           }
            
             for(Co_Term__c coTerm : Trigger.New )
            {
                String currencyVal = null;
                
                Quote tempQuote = mQuote.get(coTerm.Quote__c);
                
                if( tempQuote  != null ){
                    currencyVal = tempQuote.Opportunity.CurrencyIsoCode;
                }
                
                if( currencyVal != null && currencyVal == 'USD'){
                    coTerm.CurrencyIsoCode =  currencyVal; 
                }else  if( currencyVal != null && currencyVal == 'EUR'){
                    coTerm.CurrencyIsoCode =  currencyVal; 
                }else  if( currencyVal != null && currencyVal == 'GBP'){
                    coTerm.CurrencyIsoCode =  currencyVal; 
                }else{
                    coTerm.CurrencyIsoCode =  'USD'; 
                }
               
            }
        
     }
     
     if(Trigger.isDelete){
     System.debug('after delete started');
          Set<Id> qliIds= new Set<Id>();
          for(Co_Term__c coTerm : Trigger.Old){
          
              qliIds.add(coTerm.Quote_line_item__c);
          }
          System.debug('quote line items: '+qliIds);
         Map<id,QuoteLineItem> qliMap = new Map<id,QuoteLineItem>([select qt.id,qt.Is_Co_Term_LineItem__c 
                from QuoteLineItem qt where qt.id in: qliIds]);
           System.debug('quote line items map: '+qliMap);      
           List<Co_Term__c > coTermList = [select ct.id, ct.Quote_line_item__r.id
                from Co_Term__c  ct where ct.Quote_line_item__c in: qliIds];
                
          Map<Id,List<Co_Term__c>> assoCoTermWithQli = new Map<Id,List<Co_Term__c>>();
          
          system.debug('coTermList  size:'+ coTermList.size());
         if( coTermList != null && coTermList.size()>0){
              for( Co_Term__c cotermObj: coTermList ){
                  System.debug('for loop started'); 
                  if( assoCoTermWithQli.containsKey( cotermObj.Quote_line_item__r.id )){
                       System.debug('if condition started'); 
                      assoCoTermWithQli.get(cotermObj.Quote_line_item__r.id).add(cotermObj);
                  }else{
                  System.debug('eles condition started'); 
                      List<Co_Term__c > tempCoTermList = new List<Co_Term__c > ();
                      tempCoTermList.add(cotermObj );
                      assoCoTermWithQli.put( cotermObj.Quote_line_item__r.id,tempCoTermList );
                  }
              }
              if( assoCoTermWithQli != null ){
                   for (Id qliId : assoCoTermWithQli.keySet()){
                   
                       List<Co_Term__c > TempCTList = assoCoTermWithQli.get(qliId);
                       System.debug('temp co term list : '+ TempCTList.size());
                       if( TempCTList != null && TempCTList.size() == 0  ){
                           qliMap.get(qliId).Is_Co_Term_LineItem__c = false;
                       }
                   }
              }
         }else{
         
              for (Id qliId : qliMap.keySet()){
                   
                  qliMap.get(qliId).Is_Co_Term_LineItem__c = false;
               }
         }
          
          System.debug('final map:' + qliMap.values()); 
          update qliMap.values();
        
     }
     
}