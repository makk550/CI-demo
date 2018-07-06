/* ********************************************************************************************
* Modified By  Date         User Story    Details
* SAMAP01    03/10/2017    US370591       RevRec: SFDC Opportunity Slipped Deal
* BAJPI01    28/10/2017     us423678    Optimization for Revrec
* SAMAP01    11/12/2017     US424523    RevRec TARR for opp line items
* ********************************************************************************************/
public class OpportunityLineItemHandler implements ITrigger{
    public void bulkBefore(){
        OpportunityLineItemGateway.loadOpportunityLineItemBulkValues();
    }
    public void bulkAfter(){
        OpportunityLineItemGateway.loadOpportunityLineItemBulkValues();
    }
    public void beforeInsert(SObject so){
        OpportunityLineItem oli = (OpportunityLineItem)so;
        Map<Id,PriceBookEntry> pbeMap = OpportunityLineItemGateway.pbeMap;
        //OppLIPullUpfront
        oli.Upfront_Revenue_Eligible__c =(oli.PricebookEntryId <> null && pbeMap.get(oli.PricebookEntryId) <> null && pbeMap.get(oli.PricebookEntryId).Product2 <> null  && pbeMap.get(oli.PricebookEntryId).Product2.Upfront_Revenue_Eligible__c  <> null && pbeMap.get(oli.PricebookEntryId).Product2.Upfront_Revenue_Eligible__c == 'Yes');
        
        if( OpportunityHandler.RenewalsMassConversion ==false) //samap01 -US423678 
            flagProduct(oli);
        
        //Tensor code starts here - syncing of SF CPQ Quote Line Item to Opp Line Item
        Product2 prodVariable;
        String cbuValue;
        Decimal totalprice = 0;
        Decimal DurationDays = 0;
        String reptCountry;
        String scbu;
        String maintProd;
        Opportunity Opp;
        
        if(OpportunityLineItemGateway.oppMap!=null && OpportunityLineItemGateway.oppMap.size()>0){
            reptCountry = OpportunityLineItemGateway.oppMap.get(oli.OpportunityId).Rpt_Country__c;
            opp = OpportunityLineItemGateway.oppMap.get(oli.OpportunityId);
        }
        
        
        if(oli.SBQQ__QuoteLine__c!=null){
            totalprice = oli.TotalPrice;
            oli.Stretch__c = totalprice;
            if(oli.Start_Date__c!=null && oli.End_Date__c!=null){
                oli.Term_Month__c = ARRandDurationCalculation.monthsbetweendates(oli.Start_Date__c, oli.End_Date__c);
                oli.Stretch_Duration__c = oli.Term_Month__c;
                DurationDays = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
               
                oli.Duration_Days__c = DurationDays;
            }
            
            if(OpportunityLineItemGateway.sbProductMap!=null && OpportunityLineItemGateway.sbProductMap.size()>0){
                if(OpportunityLineItemGateway.sbProductMap.containsKey(oli.Product2Id)){
                    scbu = OpportunityLineItemGateway.sbProductMap.get(oli.Product2Id).Market_Focus_Area__c;
                    prodVariable = OpportunityLineItemGateway.sbProductMap.get(oli.Product2Id);
                    maintProd = OpportunityLineItemGateway.sbProductMap.get(oli.Product2Id).Maintenance_Product__c;
                }
                
                if(prodVariable!=null && String.isNotBlank(prodVariable.Commissionable_BU__c))
                    cbuValue = prodVariable.Commissionable_BU__c;
                
                if(String.isNotBlank(maintProd) && maintProd=='Yes'){
                    oli.UF_License_Fee__c = 0;
                    oli.Total_Maintenance__c = oli.TotalPrice; 
                    oli.Stretch_License_Fee__c= 0;
                    oli.Stretch_Total_Maintenance__c= oli.Stretch__c;   
                }
                else{
                    //US461584 -- merha02
                    if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription'){
                        oli.UF_License_Fee__c=0;
                        oli.Stretch_License_Fee__c=0;
                    }else{
                        oli.UF_License_Fee__c = oli.TotalPrice;
                        oli.Stretch_License_Fee__c= oli.Stretch__c;
                    }
                    oli.Total_Maintenance__c = 0; 
                    
                    oli.Stretch_Total_Maintenance__c= 0;   
                }
                
            }
            
                     
        }
        
        if(opp!=null && String.isNotBlank(OpportunityLineItemGateway.steelBrickRecType) && 
           opp.RecordTypeId==OpportunityLineItemGateway.steelBrickRecType && opp.SBQQ__Renewal__c==true && opp.SBQQ__PrimaryQuote__c==null){
               oli.Business_Type__c = 'Renewal';
           }
        //Tensor code ends here - syncing of SF CPQ Quote Line Item to Opp Line Item
        
         //US424938 MERHA02 point in time calculations --- start
        Decimal lineItemTotalPrice=0;
        List<String> designationValues = new List<String>();
        if(String.isNotBlank(opp.Account.Account_Type__c)){
            designationValues = opp.Account.Account_Type__c.split(';');
        }
        if(oli.Discount==null)
            oli.Discount=0;
        if(oli.UnitPrice!=null && oli.Discount!=null && oli.Quantity!=null )
        	lineItemTotalPrice=(oli.UnitPrice-(oli.UnitPrice*oli.Discount))*oli.Quantity;
        
        if(!(opp.Rpt_Area__c=='Public Sector' || (opp.Rpt_Area__c=='Canada' && (designationValues.contains('Federal') || designationValues.contains('Government') || designationValues.contains('SLED'))))){
            Decimal Stretch_Duration=0.0;
            if(oli.Business_Type__c=='New'||oli.Business_Type__c=='Capacity'||oli.Business_Type__c=='Upgrade'||oli.Business_Type__c=='Maintenance'){
                Stretch_Duration=oli.Stretch_Duration__c;
            }
            else if(oli.Business_Type__c=='Renewal'||oli.Business_Type__c=='MF Capacity'){
                Stretch_Duration=opp.Stretch_Deal_Term_Months__c;
            }
            
            List<License_Factor__c> licenseFactor_values=License_Factor__c.getall().values();        
            if(oli.Business_Type__c=='MF Capacity Overage'){
                if(lineItemTotalPrice!=null){
                    oli.Point_In_Time_License__c=lineItemTotalPrice;
                }
                if(oli.Stretch__c!=null){
                    oli.Point_In_Time_License_Stretch__c=oli.Stretch__c;
                }
                
            }
            else{
                if(oli.License_Classification__c=='Perpetual'|| oli.License_Classification__c=='UMF' || oli.License_Classification__c=='Subscription' ){
                    Decimal license_factor=0.0;
                    Decimal Stretch_license_factor=0.0;
                    if(licenseFactor_values!=null && licenseFactor_values.size()>0){
                        for(License_Factor__c lf : licenseFactor_values){
                            if(oli.Duration_Months__c!=null){
                                if(oli.Duration_Months__c>=lf.Lower_Limit__c && oli.Duration_Months__c<=lf.Upper_Limit__c){
                                    license_factor=lf.Factor__c;
                                    System.debug('--------license_factor-------'+license_factor);
                                }
                            }
                            
                            if(Stretch_Duration!=null){
                                if(Stretch_Duration>=lf.Lower_Limit__c && Stretch_Duration<=lf.Upper_Limit__c){
                                    Stretch_license_factor=lf.Factor__c;
                                    System.debug('------Stretch_license_factor-----'+Stretch_license_factor);
                                }
                            }
                            
                            
                        }
                    }
                    
                    if(lineItemTotalPrice!=null){
                         oli.Point_In_Time_License__c = lineItemTotalPrice * ( license_factor / 100 ) ;
                        
                    }
                    if(oli.Stretch__c!=null){
                        oli.Point_In_Time_License_Stretch__c=oli.Stretch__c*(Stretch_license_factor/100);
                    }
                    
                }
                else{
                    oli.Point_In_Time_License__c=0.0;
                    oli.Point_In_Time_License_Stretch__c=0.0;
                }
            } 
        }
        else{
             oli.Point_In_Time_License__c=0.0;
             oli.Point_In_Time_License_Stretch__c=0.0;
        }
         //US424938 MERHA02 point in time calculations --- end
         
        //US424523 SAMAP01 -REVREC TARR NEW
        
        if(oli.Business_Type__c == 'Renewal')
        {
            If(oli.Start_Date__c !=null && oli.End_Date__c != null )
            {
                integer daysbetween = (oli.Start_Date__c.daysBetween(oli.End_Date__c) );
                if(daysbetween!=null && daysbetween >0 && oli.UnitPrice!=null)
                {
                    oli.TARR_New__c = (oli.UnitPrice /daysbetween ) * 365 ;   
                }
                else
                { 
                    oli.TARR_New__c =0.0;
                    
                }
                
            }
            else
            {
                oli.TARR_New__c =0.0; 
            }
        }
        else
        {
            If(opp.Start_Date__c !=null && opp.End_Date__c != null)
            {
                integer daysbetween =(opp.Start_Date__c.daysBetween(opp.End_Date__c)) ;
                if(daysbetween!=null && daysbetween >0 && oli.UnitPrice!=null)
                {
                    oli.TARR_New__c = (oli.UnitPrice /daysbetween ) * 365 ;   
                }
                else
                { 
                    oli.TARR_New__c =0.0;
                    
                }
            }
            else
            {
                oli.TARR_New__c =0.0; 
            }
        }
        
        //US424523 SAMAP01 -REVREC TARR NEW
        
    }
    public void beforeUpdate(SObject oldSo, SObject so){
        OpportunityLineItem oli = (OpportunityLineItem)so;
        OpportunityLineItem oldOli = (OpportunityLineItem)oldSo;
        flagProduct(oli);
        
        //Tensor code starts here - syncing of SF CPQ Quote Line Item to Opp Line Item
        Product2 prodVariable;
        String cbuValue;
        Decimal totalprice = 0;
        Decimal DurationDays = 0;
        String reptCountry;
        String maintProd;
        Opportunity Opp;
        
        if(OpportunityLineItemGateway.oppMap!=null && OpportunityLineItemGateway.oppMap.size()>0){
            reptCountry = OpportunityLineItemGateway.oppMap.get(oli.OpportunityId).Rpt_Country__c;
            opp = OpportunityLineItemGateway.oppMap.get(oli.OpportunityId);
        }
        
        if(oli.SBQQ__QuoteLine__c!=null){
            totalprice = oli.TotalPrice;
            if(oldOli.Quantity == oli.Quantity){
                if(oli.Stretch__c!=null && totalprice!=null && oli.Stretch__c<totalprice)
                    oli.Stretch__c=totalprice;
                else if(oli.Stretch__c==null)
                    oli.Stretch__c = totalprice;
            }
            if(oldOli.Quantity != oli.Quantity)
                oli.Stretch__c=totalprice;
            
            if(oli.Start_Date__c!=null && oli.End_Date__c!=null){
                oli.Term_Month__c = ARRandDurationCalculation.monthsbetweendates(oli.Start_Date__c, oli.End_Date__c);
                if(oli.Stretch_Duration__c==null || (oli.Stretch_Duration__c!=null && oli.Term_Month__c>oli.Stretch_Duration__c))
                    oli.Stretch_Duration__c = oli.Term_Month__c;
                DurationDays = oli.Start_Date__c.daysBetween(oli.End_Date__c)+1;
                
                oli.Duration_Days__c = DurationDays;
            }
            
            if(OpportunityLineItemGateway.sbProductMap!=null && OpportunityLineItemGateway.sbProductMap.size()>0){
                if(OpportunityLineItemGateway.sbProductMap.containsKey(oli.Product2Id)){
                    
                    maintProd = OpportunityLineItemGateway.sbProductMap.get(oli.Product2Id).Maintenance_Product__c;
                }
                
                
                if(String.isNotBlank(maintProd) && maintProd=='Yes'){
                    oli.UF_License_Fee__c = 0;
                    oli.Total_Maintenance__c = oli.TotalPrice; 
                    oli.Stretch_License_Fee__c= 0;
                    oli.Stretch_Total_Maintenance__c= oli.Stretch__c;   
                }
                else{
                    //US461584 -- merha02
                     if(oli.License__c == 'SAAS' || oli.License__c == 'Subscription'){
                        oli.UF_License_Fee__c=0;
                        oli.Stretch_License_Fee__c=0;
                    }else{
                        oli.UF_License_Fee__c = oli.TotalPrice;
                        oli.Stretch_License_Fee__c= oli.Stretch__c;
                    }
                    
                    oli.Total_Maintenance__c = 0; 
                    
                    oli.Stretch_Total_Maintenance__c= 0;   
                }
                
            }
            
            
			}
        
        if(opp!=null && String.isNotBlank(OpportunityLineItemGateway.steelBrickRecType) && 
           opp.RecordTypeId==OpportunityLineItemGateway.steelBrickRecType && opp.SBQQ__Renewal__c==true && opp.SBQQ__PrimaryQuote__c==null){
               oli.Business_Type__c = 'Renewal';
           }
        //Tensor code ends here - syncing of SF CPQ Quote Line Item to Opp Line Item
        
      //US424938 MERHA02 point in time calculations --- start
        Decimal lineItemTotalPrice=0;
        List<String> designationValues = new List<String>();
        if(String.isNotBlank(opp.Account.Account_Type__c)){
            designationValues = opp.Account.Account_Type__c.split(';');
        }
        if(oli.Discount==null)
            oli.Discount=0;
        if(oli.UnitPrice!=null && oli.Discount!=null && oli.Quantity!=null )
        	lineItemTotalPrice=(oli.UnitPrice-(oli.UnitPrice*oli.Discount))*oli.Quantity;
        
        if(!(opp.Rpt_Area__c=='Public Sector' || (opp.Rpt_Area__c=='Canada' && (designationValues.contains('Federal') || designationValues.contains('Government') || designationValues.contains('SLED'))))){
            Decimal Stretch_Duration=0.0;
            if(oli.Business_Type__c=='New'||oli.Business_Type__c=='Capacity'||oli.Business_Type__c=='Upgrade'||oli.Business_Type__c=='Maintenance'){
                Stretch_Duration=oli.Stretch_Duration__c;
            }
            else if(oli.Business_Type__c=='Renewal'||oli.Business_Type__c=='MF Capacity'){
                Stretch_Duration=opp.Stretch_Deal_Term_Months__c;
            }
            
            List<License_Factor__c> licenseFactor_values=License_Factor__c.getall().values();        
            if(oli.Business_Type__c=='MF Capacity Overage'){
                if(lineItemTotalPrice!=null){
                    oli.Point_In_Time_License__c=lineItemTotalPrice;
                }
                if(oli.Stretch__c!=null){
                    oli.Point_In_Time_License_Stretch__c=oli.Stretch__c;
                }
                
            }
            else{
                if(oli.License_Classification__c=='Perpetual'|| oli.License_Classification__c=='UMF' || oli.License_Classification__c=='Subscription' ){
                    Decimal license_factor=0.0;
                    Decimal Stretch_license_factor=0.0;
                    if(licenseFactor_values!=null && licenseFactor_values.size()>0){
                        for(License_Factor__c lf : licenseFactor_values){
                            if(oli.Duration_Months__c!=null){
                                if(oli.Duration_Months__c>=lf.Lower_Limit__c && oli.Duration_Months__c<=lf.Upper_Limit__c){
                                    license_factor=lf.Factor__c;
                                    System.debug('--------license_factor-------'+license_factor);
                                }
                            }
                            
                            if(Stretch_Duration!=null){
                                if(Stretch_Duration>=lf.Lower_Limit__c && Stretch_Duration<=lf.Upper_Limit__c){
                                    Stretch_license_factor=lf.Factor__c;
                                    System.debug('------Stretch_license_factor-----'+Stretch_license_factor);
                                }
                            }
                            
                            
                        }
                    }
                    
                    if(lineItemTotalPrice!=null){
                         oli.Point_In_Time_License__c = lineItemTotalPrice * ( license_factor / 100 ) ;
                        
                    }
                    if(oli.Stretch__c!=null){
                        oli.Point_In_Time_License_Stretch__c=oli.Stretch__c*(Stretch_license_factor/100);
                    }
                    
                }
                else{
                    oli.Point_In_Time_License__c=0.0;
                    oli.Point_In_Time_License_Stretch__c=0.0;
                }
            } 
        }
        else{
             oli.Point_In_Time_License__c=0.0;
             oli.Point_In_Time_License_Stretch__c=0.0;
        }
         //US424938 MERHA02 point in time calculations --- end
         
        //US424523 SAMAP01 -REVREC TARR NEW
        if(oli.Business_Type__c == 'Renewal')
        {
            If(oli.Start_Date__c !=null && oli.End_Date__c != null)
            {
                integer daysbetween = (oli.Start_Date__c.daysBetween(oli.End_Date__c) );
                if(daysbetween!=null && daysbetween >0 && oli.UnitPrice!=null)
                {
                    oli.TARR_New__c = (oli.UnitPrice /daysbetween ) * 365 ;   
                }
                else
                { 
                    oli.TARR_New__c =0.0;
                    
                }
                
            }
            else
            {
                oli.TARR_New__c =0.0; 
            }
        }
        else
        {
            If(opp.Start_Date__c !=null && opp.End_Date__c != null)
            {
                integer daysbetween = (opp.Start_Date__c.daysBetween(opp.End_Date__c));
                if(daysbetween!=null && daysbetween >0 && oli.UnitPrice!=null)
                {
                    oli.TARR_New__c = (oli.UnitPrice /daysbetween ) * 365 ;   
                }
                else
                { 
                    oli.TARR_New__c =0.0;
                    
                }
            }
            else
            {
                oli.TARR_New__c =0.0; 
            }
        } 
        //US424523 SAMAP01 -REVREC TARR NEW
    }
    
    public void beforeDelete(SObject so){
        OpportunityLineItem oli = (OpportunityLineItem)so; 
 
    }
    
    
    public void afterInsert(SObject so){
        system.debug('ObjectName:'+so);
        OpportunityLineItem oli = (OpportunityLineItem)so;
        Opportunity opp = OpportunityLineItemGateway.getOpportunitytoUpdate(oli.OpportunityId);
        //OLISetOppStatusToReneqested & OppLIAttachDetachRenewals
        system.debug('oli.business_type__c:'+oli.business_type__c);
        if(oli.business_type__c == 'Renewal'){
            //Opportunity opp = OpportunityLineItemGateway.getOpportunitytoUpdate(oli.OpportunityId);
            system.debug('oli.OpportunityId:'+oli.OpportunityId);
            opp.rpd_status__c = 'Requested';
            decimal pr = opp.Projected_renewal__c;
            decimal ppr = opp.Partner_Sales_Price__c;
            if(pr == null)
                pr =0;
            if(ppr == null)
                ppr =0;
            pr += oli.UnitPrice;                                                            
            if(oli.Partner_Added__c == true)
                ppr += oli.partner_sales_price__c;                    
            opp.Projected_renewal__c = pr;
            opp.Partner_Sales_Price__c = ppr;
            OpportunityLineItemGateway.opportunitiesToUpdate.put(opp.id,opp);
        }
        
    }
    public void afterUpdate(SObject oldSo, SObject so){
        OpportunityLineItem oli = (OpportunityLineItem)so;
        OpportunityLineItem Old_oli = (OpportunityLineItem)oldSo;

    }
    public void afterDelete(SObject so){
        OpportunityLineItem oli = (OpportunityLineItem)so;
        
        //OLISetOppStatusToReneqested & OppLIAttachDetachRenewals
        Opportunity opp = OpportunityLineItemGateway.getOpportunitytoUpdate(oli.OpportunityId);
        if(oli.business_type__c == 'Renewal'){
            opp.rpd_status__c = 'Requested';
            decimal pr = opp.Projected_renewal__c;
            if(pr == null)
                pr =0;
            pr -= oli.UnitPrice;
            opp.Projected_renewal__c = pr;
        }
        decimal ppr = opp.Partner_Sales_Price__c;                    
        if(ppr == null)
            ppr = 0;
        if(oli.Partner_Added__c == true)
            ppr -= oli.UnitPrice;                    
        opp.Partner_Sales_Price__c = ppr;
        OpportunityLineItemGateway.opportunitiesToUpdate.put(opp.id,opp);
        
        
    }
    public void andFinally(){
        
        //US326192 - BAJPI01 - start/end date update on opp header.
        Set<String> Businesstype = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'};
            Map<id,List<OpportunityLineItem>> oppAndLineItemsMap = new Map<id,List<OpportunityLineItem>>();
        List<OpportunityLineItem> opplineitems = new List<OpportunityLineItem>();
        Map<String,Decimal> isoCodeToConversionRate=new Map<String,Decimal>();
        Date minStartDate;
        Date maxEndDate;
        UniqueBusinessUnit UBU = new UniqueBusinessUnit();
        if(Trigger.isAfter){
            if(OpportunityLineItemGateway.opportunitiesToUpdate!=null && OpportunityLineItemGateway.opportunitiesToUpdate.size()>0){
                
                for(OpportunityLineItem tempOli:  [select id,Start_Date__c,End_Date__c,OpportunityId,Business_Type__c,
                                                   Active_Contract_Product__r.Dismantle_Date__c ,SBQQ__QuoteLine__r.End_Date__c,Active_Contract_Product__r.Active_Contract__r.Contract_Term_Months__c, //samap01 from OpportunityLineItem
                                                   Active_Contract_Product__c,Active_Contract_Product__r.Active_Contract__r.Status_Formula__c,
                                                   PricebookEntry.Product2.Family,Deal_Program_Eligibility_Status__c,UnitPrice,TotalPrice,
                                                   Active_Contract__c,Active_Contract__r.Total_TARR_LC__c,UF_License_Fee__c,Corporate_ARR__c,Stretch_Corporate_ARR__c,
                                                   PricebookEntry.Name,RejectedByCA__c,Business_Unit__c 
                                                   from OpportunityLineItem where OpportunityId in:OpportunityLineItemGateway.opportunitiesToUpdate.keySet()]){
                                                       opplineitems.add(tempOli);
                                                   }
                
                //comparison - iso code
                for(CurrencyType ct : [SELECT IsoCode, ConversionRate FROM CurrencyType]){
                    isoCodeToConversionRate.put(ct.IsoCode, ct.ConversionRate);
                }
                
            }
            if(opplineitems!=null && opplineitems.size()>0){
                for(OpportunityLineItem oli:opplineitems){
                    if(oppAndLineItemsMap.get(oli.OpportunityId)!=null){
                        oppAndLineItemsMap.get(oli.OpportunityId).add(oli);
                    }
                    else{
                        List<OpportunityLineItem> opplineitemlist = new List<OpportunityLineItem>();
                        opplineitemlist.add(oli);
                        oppAndLineItemsMap.put(oli.OpportunityId,opplineitemlist);
                    }
                }
                //for opps that do not have any opp line item, adding empty list to map
                for(Opportunity Opp : OpportunityLineItemGateway.opportunitiesToUpdate.values()){
                    if(!oppAndLineItemsMap.containsKey(opp.id)){
                        oppAndLineItemsMap.put(opp.id,new List<OpportunityLineItem>());
                    }
                }
            }
            else{    //if no line item exist, for all opps, change ARR field values to 0 for those opps.
                if(OpportunityLineItemGateway.opportunitiesToUpdate!=null && OpportunityLineItemGateway.opportunitiesToUpdate.size()>0){
                    for(Opportunity Opp : OpportunityLineItemGateway.opportunitiesToUpdate.values()){
                        opp.ARR_Capacity_Upsell__c=0;
                        opp.ARR_New_Product__c = 0;
                        opp.ARR_Renewal__c = 0;
                        opp.TotalARRStretch__c = 0;
                        opp.Header_TARR_Old_SFDC__c=0; // US447735 --- to update Header TARR on opp -- MERHA02
                        opp.Total_ARR_License_Fee__c=0; // US459020 -- ARR Total License Fee-- MERHA02
                        opp.Opportunity_Type__c = null; //moved from gateway to handler.
                        opp.Driving_Sales_Coverage_Business_Unit__c = '';	//BAJPI01 US454113 - Missing SCBU on Opp header
                        OpportunityLineItemGateway.opportunitiesToUpdate.put(opp.id,opp);
                    }                                
                }
            }
            
            if(oppAndLineItemsMap!=null && oppAndLineItemsMap.size()>0){
                for(Id oppid : oppAndLineItemsMap.keySet()){
                    List<OpportunityLineItem> lineitemlist = oppAndLineItemsMap.get(oppid);
                    List<OpportunityLineItem> renewalOppLine;
                    Map<Id,Decimal> AC_TARR = new Map<Id,Decimal>(); // map of AC and its TARR value
                    
                    if(lineitemlist!=null && lineitemlist.size()>0){
                        Opportunity opp = OpportunityLineItemGateway.opportunitiesToUpdate.get(oppid);
                        renewalOppLine = New List<OpportunityLineItem>();
                        
                        //BAJPI01 US454113 - Missing SCBU on Opp header
                        if(OpportunityLineItemGateway.updateOppIds!=null && OpportunityLineItemGateway.updateOppIds.size()>0 && OpportunityLineItemGateway.updateOppIds.contains(oppid))
                        	opp.Driving_Sales_Coverage_Business_Unit__c = UBU.processOpprLineItems(lineitemlist);
                        //BAJPI01 US454113 - Missing SCBU on Opp header
                        
                        
                        //movingf from gateway to handler - BAJPI01
                        Set<String> setFamily = new Set<String>();
                        Boolean isValidated=true;
                        Boolean rpdStatusVariable = false;
                        Decimal Original_Deal_Term_Months=0;
                        Date Original_Expiration_Date;
                        //partner module - BAJPI01, moving from gateway to handler 
                        Double price = 0;
                        String pbeName = '';
                        Decimal oppSalesPrice;
                        //partner module - BAJPI01, moving from gateway to handler 
                        //moving from gateway to handler - BAJPI01
                        Decimal TARR_value=0; // sum of tarr values
                        //chajo30 US397193
                        double totalSBLineItems = 0;
                        double sbSlipCount = 0;
                        String recordTypeByName;  
                        if(opp.recordtypeid != null){
                            recordTypeByName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordtypeid).getname();
                        }
                        //end chajo30
                        opp.ARR_Capacity_Upsell__c=0;
                        opp.ARR_New_Product__c = 0;
                        opp.ARR_Renewal__c = 0;
                        opp.TotalARRStretch__c = 0;
                        opp.Header_TARR_Old_SFDC__c=0; // US447735 --- to update Header TARR on opp -- MERHA02
                        opp.Total_ARR_License_Fee__c=0; // US459020 -- ARR Total License Fee-- MERHA02
                        if(recordTypeByName == 'SB Record Type'){
                            opp.Slipped_Deal__c = 'No';
                        }
                        minStartDate = lineitemlist[0].Start_Date__c;
                        maxEndDate = lineitemlist[0].End_Date__c;
                        for(OpportunityLineItem oli:lineitemlist){
                            if(oli.Start_Date__c!=null){
                                if(minstartdate!=null){
                                    if(oli.Start_Date__c<minstartdate)
                                        minstartdate = oli.Start_Date__c;
                                }
                                else{
                                    minstartdate = oli.Start_Date__c;
                                }
                            }
                            if(oli.End_Date__c!=null){
                                if(maxenddate!=null){
                                    if(oli.End_Date__c>maxenddate)
                                        maxenddate = oli.End_Date__c;
                                }
                                else{
                                    maxenddate = oli.End_Date__c;
                                }
                            }
                            if(oli.Business_Type__c=='New' && oli.Corporate_ARR__c!=null)
                                opp.ARR_New_Product__c += oli.Corporate_ARR__c;
                            if(oli.Business_Type__c=='Renewal' && oli.Corporate_ARR__c!=null)
                                opp.ARR_Renewal__c += oli.Corporate_ARR__c;
                            if((oli.Business_Type__c=='Capacity' ||oli.Business_Type__c=='MF Capacity' || oli.Business_Type__c=='Upgrade') && oli.Corporate_ARR__c!=null)
                                opp.ARR_Capacity_Upsell__c += oli.Corporate_ARR__c;
                            
                            if(oli.Stretch_Corporate_ARR__c != null)
                            {
                                opp.TotalARRStretch__c += oli.Stretch_Corporate_ARR__c; //Corporate ARR Stretch - MERHA02
                            }
                            if(oli.UF_License_Fee__c!=null){
                                opp.Total_ARR_License_Fee__c += oli.UF_License_Fee__c; // US459020 -- ARR Total License Fee-- MERHA02
                            }
                            
                            
                             // US447735 --- to update Header TARR on opp -- MERHA02 -- start
                            if(oli.Active_Contract__c!=null){
                                if(!AC_TARR.containsKey(oli.Active_Contract__c)){
                                    if(oli.Active_Contract__r.Total_TARR_LC__c!=null){
                                         AC_TARR.put(oli.Active_Contract__c,oli.Active_Contract__r.Total_TARR_LC__c);
                                        TARR_value = TARR_value + oli.Active_Contract__r.Total_TARR_LC__c;
                                    
                                    }
                              }
                            }
                            // US447735 --- to update Header TARR on opp -- MERHA02 -- end
                            
                            //chajo30 US397193
                            System.debug('chajo30 recodtype: ' + recordTypeByName );
                            if(recordTypeByName == 'SB Record Type'){
                                String Businesstypec =oli.Business_Type__c; 
                                if(oli.SBQQ__QuoteLine__r.End_Date__c != null){
                                    totalSBLineItems++;  
                                    if(oli.SBQQ__QuoteLine__r.End_Date__c < opp.CloseDate){
                                        opp.Slipped_Deal__c = 'Partial';
                                        sbSlipCount++;
                                        System.debug('--inside SB slipped deal');
                                    }    
                                }
                            }
                            //end chajo30 
                            if(oli.Business_Type__c=='Renewal' && oli.Active_Contract_Product__c!=null)
                                renewalOppLine.add(oli); 
                            
                            //moved from gateway to handler - BAJPI01
                            setFamily.add(((oli.PricebookEntry.Product2.Family == 'Renewal' || oli.PricebookEntry.Product2.Family == 'Time' || oli.PricebookEntry.Product2.Family == 'Mainframe Capacity' || oli.Business_Type__c == 'Renewal') ?'Renewal':oli.PricebookEntry.Product2.Family));
                            
                            //partner module from gateway to handler
                            if(oli.UnitPrice != null && oli.Deal_Program_Eligibility_Status__c=='Eligible')
                                price = price + oli.UnitPrice;
                            if(oli.PricebookEntry.Name != null && oli.Deal_Program_Eligibility_Status__c=='Eligible' && oli.RejectedByCA__c!= true){
                                if(pbeName == '')
                                    pbeName = oli.PricebookEntry.Name; 
                                else
                                    pbeName = pbeName + ', ' + oli.PricebookEntry.Name; 
                            }
                            //partner module from gateway to handler                            
                            
                            if(recordTypeByName!=null && recordTypeByName!='SB Record Type' && recordTypeByName!='Entitlement Sync' && oli.Business_Type__c=='Renewal'){
                                rpdStatusVariable = true;
                                if(Original_Expiration_Date == null ||  oli.Active_Contract_Product__r.Dismantle_Date__c < Original_Expiration_Date){   
                                    Original_Expiration_Date = oli.Active_Contract_Product__r.Dismantle_Date__c;
                                    Original_Deal_Term_Months = oli.Active_Contract_Product__r.Active_Contract__r.Contract_Term_Months__c; 
                                }
                            }
                            //moved from gateway to handler - BAJPI01
                            
                        }
                        
                        if(renewalOppLine!=null && renewalOppLine.size()>0){
                            opp = OpportunityLineItemGateway.updateFinanceValuation(opp,renewalOppLine);
                        }
                        opp.Header_TARR_Old_SFDC__c=TARR_value;// US447735 --- to update Header TARR on opp -- MERHA02
                        //chajo30 US397193
                        if(recordTypeByName == 'SB Record Type' && sbSlipCount == totalSBLineItems ){
                            opp.Slipped_Deal__c='Yes';
                            System.debug('SB slipped deal is true');
                        }
                        //end chajo30
                        
                        //moved from gateway to handler - BAJPI01
                        opp.Opportunity_Type__c = OpportunityLineItemGateway.calculateOpportunityType(setFamily);
                        opp.Original_Expiration_Date__c = Original_Expiration_Date;
                        opp.Original_Deal_Term_Months__c = Original_Deal_Term_Months;
                        if(rpdStatusVariable==true)
                            opp.rpd_status__c = 'Requested';
                        
                        //partner module from gateway to handler
                        if(opp.Deal_Registration_Status__c != 'Sale Approved'){
                            if(Trigger.isUpdate){
                                if(opp.Reseller_Estimated_Value__c != price)
                                    opp.Reseller_Estimated_Value__c = price;
                                if(opp.Reseller_Product_Name__c != pbeName)
                                    opp.Reseller_Product_Name__c = pbeName;
                            }
                            else{
                                opp.Reseller_Estimated_Value__c = price;
                                opp.Reseller_Product_Name__c = pbeName;
                            }
                            
                            oppSalesPrice = opp.Reseller_Estimated_Value__c;
                            if(opp.Deal_Registration_Program__c != null && opp.CurrencyIsoCode!= opp.Deal_Registration_Program__r.CurrencyIsoCode )
                            {
                                oppSalesPrice = opp.Reseller_Estimated_Value__c*isoCodeToConversionRate.get(opp.Deal_Registration_Program__r.CurrencyIsoCode);
                            }
                            if(opp.Deal_Registration_Program__c != null && oppSalesPrice>=opp.Deal_Registration_Program__r.Min_Deal_Value__c && oppSalesPrice<=opp.Deal_Registration_Program__r.Max_Deal_Value__c)
                            { 
                                opp.MinMaxError__c = false; 
                            }
                            else
                            {
                                
                                opp.MinMaxError__c = true;
                            }
                            //partner module from gateway to handler
                        } 
                        
                        //moved from gateway to handler - BAJPI01
                        
                        opp.Start_Date__c = minStartDate;
                        opp.End_Date__c = maxEndDate;
                         //US422479 sunji03 
                        if(renewalOppLine!=null && renewalOppLine.size()>0){
                            opp.New_Deal_Term_months__c = ARRandDurationCalculation.monthsbetweendates(opp.Start_Date__c,opp.End_Date__c);
                        }
                        OpportunityLineItemGateway.opportunitiesToUpdate.put(oppid,opp);
                    }
                    else{    //if for a given opp, there are no line items, change ARR fields to 0.
                        Opportunity opp = OpportunityLineItemGateway.opportunitiesToUpdate.get(oppid);
                        opp.ARR_Capacity_Upsell__c=0;
                        opp.ARR_New_Product__c = 0;
                        opp.ARR_Renewal__c = 0;
                        opp.TotalARRStretch__c = 0;
                        opp.Header_TARR_Old_SFDC__c=0; // US447735 --- to update Header TARR on opp -- MERHA02
                        opp.Total_ARR_License_Fee__c =0; // US459020 -- ARR Total License Fee-- MERHA02
                        opp.Opportunity_Type__c = null; //moved from gateway to handler.
                        opp.Driving_Sales_Coverage_Business_Unit__c = '';	//BAJPI01 US454113 - Missing SCBU on Opp header
                        OpportunityLineItemGateway.opportunitiesToUpdate.put(oppid,opp);
                    }
                }
            }
            //US326192 - BAJPI01 - start/end date update of opp header ends here.
            
            if(OpportunityLineItemGateway.opportunitiesToUpdate!=null && OpportunityLineItemGateway.opportunitiesToUpdate.size()>0){
                system.debug('TestOppValues'+OpportunityLineItemGateway.opportunitiesToUpdate.values());
                try{  
                    update OpportunityLineItemGateway.opportunitiesToUpdate.values();
                }
                Catch(DMLException e){  
                }
            }
            
        }        
        if(Trigger.isInsert && Trigger.isAfter){
            System.debug('xmlstring======================'+OpportunityLineItemGateway.xmlStrings);
            
            // To handle batch
            if(!system.isBatch() && !Test.isRunningTest())
                NewLogoHandler.callEAIforNewLogo(OpportunityLineItemGateway.xmlStrings);
        }
    }
    
    
    private static void flagProduct(OpportunityLineItem oli){
        Map<Id,PriceBookEntry> pbeMap = OpportunityLineItemGateway.pbeMap;
        //Nimsoft flag and Layer7 Product flag
        if((oli.Nimsoft_Product_Flag__c == false || oli.L7_Product_Flag__c == false) && (pbeMap.get(oli.PricebookEntryId) != null && pbeMap.get(oli.PricebookEntryId).Product2 != null && pbeMap.get(oli.PricebookEntryId).Product2.name != null)){
            String product2Name = pbeMap.get(oli.PricebookEntryId).Product2.name;
            product2Name=product2Name.toLowerCase();                 
            if((product2Name.contains('nimsoft')) || (product2Name.contains('cloud service management')) || (product2Name.contains('unified infrastructure management')))
                oli.Nimsoft_Product_Flag__c=true;
            String   product2MarketFocusArea= pbeMap.get(oli.PricebookEntryId).Product2.Market_Focus_Area__c;// ILT for FY16 by YEDRA01
            if(product2MarketFocusArea!=null)
                product2MarketFocusArea = product2MarketFocusArea.toLowerCase();// ILT for FY16 by YEDRA01
            
            if((product2Name.contains('layer')) || (product2Name.contains('api portal on-premise')) || (product2Name.contains('api management')) || (product2Name.contains('api gateway')) || (product2Name.contains('ilt') && product2MarketFocusArea.contains('api management')))//changes ILT for FY16 by YEDRA01
                oli.L7_Product_Flag__c=true;
        }
    }
}