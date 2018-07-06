/* ********************************************************************************************
* Created By : Aparna Samala
* Created For : Common class for creating opportunity line items from renewals
* Used Id  :   Renewal_AddOppProduct, Renewal_ConvToOppController,Renewal_MassOpportunityConv
* Modified By  Date             User Story      Details
* SAMAP01       6/12/2017       US370595        RevRec: SFDC Opportunity License Classification for renewal products
* SAMAP01    11/12/2017    US424523    RevRec TARR for opp line items -  TARR__c =acl.Material_TARR_LC__c
* SAMAP01    26/12/2017    US424951     RevRec: SFDC ACL Load capture List Price from SAP Contract
*  samap01      13/02/2017     US455553     Renewals Generate Opportunity displaying incorrect error message from batch process
* Test Class: Renewal_OpportunityUtilityClass_Test
* Code Covergae: 83%
* ********************************************************************************************/
public class Renewal_OpportunityUtilityClass {
    
    public Static Opportunity opp;
    public static Pricebook2 pb2 = new Pricebook2();
    public static string strpbid;
    public static PricebookEntry pbe;
    public static Map<id, PricebookEntry> mapPE ;
    public static List<Active_Contract_Line_Item__c> acllist ; 
    public static  Map<id, Decimal> mapACPSalesprice = new Map<id, Decimal>(); //samap01 
    public static Id NewOpportunityId;
       
    public static Opportunity getOpportunitydetails( Id oppId)   
    {
        opp = [Select o.Name,o.Id,o.Account.Name,o.CurrencyIsoCode, o.AccountId,o.closedate,StageName,
               o.Start_Date__c,o.End_Date__c,o.Detach_Contracts_Batch_Id__c ,o.Attach_Contracts_Batch_Id__c,o.Probability,
               o.New_Deal_Term_Months__c,o.Renewal_BatchId__c,o.Reason_duration_is_1_year__c,o.Status_at_end_of_term__c,o.Rpt_Territory_Country__c,o.RecordType.Name
               From Opportunity  o where o.Id =: oppId];
        System.debug('samap01 -getOpportunitydetails'+ opp);
        return opp;
    }
    //get it from custom settings - recordtype settings 
    public static String getPricebookId()
    {
        
        RecordTypes_Setting__c priceBookRec = RecordTypes_Setting__c.getValues('CA Product List');  //to get details from custom setting for Standard Price Book
        string priceBookRecValue;  //stores the pricebook ID.
        if(priceBookRec!=null)
            strpbid = priceBookRec.RecordType_Id__c;
        
       // pb2 = [select Id from Pricebook2 where Name='CA Product List' and IsActive=true];
       // pb2=  RecordTypes_Setting__c.getValues('PriceBook');
      //  if(pb2!=null)
          //  strpbid = pb2.Id;
        System.debug('samap01 - getPricebookId' +strpbid );
        return strpbid;
    }
    
    public static  Map<id, PricebookEntry> getPriceBookEntry( Set<Id> prodIds , string currencycode)
    {
        string strpricebookid =getPricebookId();
        System.debug('samap01 getPriceBookEntry ');
        Map<id, PricebookEntry> mapPBE = new Map<id, PricebookEntry>();
        if(prodIds.size()>0){
            for(PricebookEntry pe:[Select Id,Name, Product2id,product2.Commissionable_BU__c From PricebookEntry
                                   where Product2id in : prodIds and currencyIsoCode=:currencycode and Pricebook2Id=: strpricebookid  and IsActive =:true])
            {
                if(! mapPBE.keyset().contains(pe.Product2id))
                    mapPBE.put(pe.Product2id, pe);
            }
        }
        System.debug('samap01 getPriceBookEntry '+mapPBE);
        //mapPE =mapPBE;
        return mapPBE;
    }
    
    public static  Map<ID, Renewal__c> RetrieveRenewals(Set<Id> renwlids)
    {
        
        Map<ID, Renewal__c> maprenewalslist = new Map<ID, Renewal__c>([select id, Segmentation__c, name, Account__c, OwnerId, Expected_Close_Date__c, 
                    Converted_To_Opportunity__c, Overall_Comments__c, CurrencyIsoCode, Renewal_Risk__c, //US511578 - poras01 - adding Renewal_Risk_c to query 
                    Projected_Time_Duration_Months__c, OCV__c, Annual_OCV_LC__c,Baseline_ATTRF_LC__c, 
                    Sold_to_Ship_to_Party_Site_ID__c, Projected_Renewal__c,owner.isActive,
                    Local_Currency__c, New_Site_Id__c, Territory__c , // Changed for FY14 - was Territory_Country__c
                    Reason_duration_is_1_year__c,Status_at_end_of_term__c, (select active_contract__r.header_dismantle_date__c,
                                                                            active_contract__r.Contract_Term_Months__c from Renewals_Product_Contracts__r)
                    from Renewal__c 
                    where Id in : renwlids]); 
        return maprenewalslist;
    }
   
    
    public static  Map<Id, LIST<Active_Contract_Line_Item__C>>  getActiveContractLineItems( Set<Id> ActiveContractIds ,Id AccountId)
    {
        System.debug('samap01 getActiveContractLineItems  called');
        //SAMAP01- REVREC -For each Active contract line items attached to the selected product create Opportunity Product 
        
        Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>(); //Samap01
        List<Active_Contract_Line_Item__c>  aclineitems =    [Select
                                                              ID,
                                                              Raw_Maintenance_LC__c,
                                                              Orig_ATTRF_LC__c,
                                                              Baseline_ATTRF_LC__c,
                                                              AOCV__c,
                                                              Sales_Price__c,
                                                              Dismantling_Date__c,
                                                              Install_Dismantle_Duration_months__c,
                                                              OCV__c,
                                                              Sales_Document__c,
                                                              License_Type_Text__c,
                                                              // License_Classification__c ,
                                                              Product_Material__c,
                                                              Sales_Document_Item__c,
                                                              Projected_Renewal_Value__c, 
                                                              Contract_Product__c,   
                                                              Material_TARR_LC__c, //US424523 - SAMAP01 - TARR    
                                                              List_Price_License_LC__c, //US424951 -samap01 -list price
                                                              List_Price_Maintenance_LC__c, //US424951 -samap01 -list price
                                                              Renewal_Valuation_Type__c,
                                                              Contract_Product__r.name,
                                                              Contract_Product__r.Instance_Id__c,                     
                                                              Contract_Product__r.Converted_To_Opportunity__c,
                                                              Contract_Product__r.Dismantle_Date__c,
                                                              Contract_Product__r.Active_Contract__c, 
                                                              //Contract_Product__r.AOCV__c, 
                                                              //Contract_Product__r.OCV__c, 
                                                              Contract_Product__r.ATTRF_CRV__c,
                                                              Contract_Product__r.Product_Baseline_ATTRF_LC__c,  //adding baseline for baseline attrf req
                                                              Contract_Product__r.Segmentation__c, 
                                                              Contract_Product__r.Pre_Segmentation__c,
                                                              Contract_Product__r.Raw_Maint_Calc_LC__c, 
                                                              Contract_Product__r.Projected_Renewal_Calc__c, 
                                                              Contract_Product__r.Active_Contract_Number__c, 
                                                              Contract_Product__r.Renewal_Product__r.Renewal__r.Name,
                                                              Contract_Product__r.Renewal_Product__r.Projected_Time_Duration_Months__c,
                                                              Contract_Product__r.Active_Contract__r.Name,
                                                              Contract_Product__r.Active_Contract__r.Contract_Term_Months__c, 
                                                              Contract_Product__r.Product__c, 
                                                              Contract_Product__r.Sales_Price__c ,
                                                              Contract_Product__r.Product__r.Name, 
                                                              Contract_Product__r.Product__r.Family,
                                                              Contract_Product__r.Opportunity__r.Name,
                                                              Contract_Product__r.Opportunity__r.Opportunity_Number__c
                                                              From 
                                                              Active_Contract_Line_Item__c
                                                              where 
                                                       //samap01 dec 12th commented to check if needed       Contract_Product__r.Active_Contract__r.Account__c =: AccountId AND
                                                              Contract_Product__c in : ActiveContractIds ] ;

        if(aclineitems != null && aclineitems.size() > 0)
        {
            acllist = aclineitems;
            for(Active_Contract_Line_Item__C acl : aclineitems)
            {                                
                if (aclmap.containsKey(acl.Contract_Product__c)) {
                    aclmap.get(acl.Contract_Product__c).add(acl);
                }
                else {
                    aclmap.put(acl.Contract_Product__c, new List<Active_Contract_Line_Item__C>{ acl });
                }  
                
                
            }
        }
        System.debug('samap01 get active contract line items '+aclmap);
        return aclmap ;
    }
    
    public static List<Active_Contract_Product__C> getActiveContractProducts( Id renwlId)
    {       
        
        //get all ACP's Associate with the renewal and change the status of the field Converted To Opportunity to true;     
        List <Active_Contract_Product__c> ACP = 
            [Select Id, 
             Sales_Price__c, 
             name, 
             Converted_To_Opportunity__c,
             Dismantle_Date__c,
             Active_Contract__c, 
             AOCV__c, 
             OCV__c, 
             ATTRF_CRV__c,
             Product_Baseline_ATTRF_LC__c,  //adding baseline for baseline attrf req
             Segmentation__c, 
             Pre_Segmentation__c,
             Raw_Maint_Calc_LC__c, 
             Projected_Renewal_Calc__c, 
             Active_Contract_Number__c, 
             Renewal_Product__r.Renewal__r.Name,
             Renewal_Product__r.Projected_Time_Duration_Months__c,
             Active_Contract__r.Name,
             Active_Contract__r.Contract_Term_Months__c, 
             Product__c,           
             Product__r.Name, 
             Product__r.Family
             From Active_Contract_Product__c
             where Renewal_Product__r.Renewal__c=:renwlId
             and Converted_To_Opportunity__c <> true]; 
        
        System.debug('samap01 getActiveContractProducts'+ ACP);
        return ACP;
        
    }
    
     public static  Map<String, String> CreateOpportunity(Renewal__c rnwl)
    {
        Renewal_Contracts__c rc;
        Map<String, String> errorLog = new  Map<String, String>() ;
        if(rnwl.Renewals_Product_Contracts__r.size()>0)
            rc = rnwl.Renewals_Product_Contracts__r.get(0);
        try
        {
            SystemIdUtility.skipTrigger  = true;   
            if(rnwl.owner.isActive ==false)
            {
                errorLog.put(rnwl.name,'The Owner of the renewal is inactive and the renewal cannot be converted to Opportunity');
                return errorLog;    
            }
            
            if(rnwl.Converted_To_Opportunity__c==true){
                errorLog.put(rnwl.name,'The selected Renewal already been Converted into an Opportunity.');
                return errorLog;    
            }
            // based on Req. 10.09 LT option is addded by subsa03
            
            if(rnwl.Segmentation__c != 'HT' && rnwl.Segmentation__c  != 'MT' && rnwl.Segmentation__c  != 'LT'){
                errorLog.put(rnwl.name,'This Renewal has the Segmentation ' + rnwl.Segmentation__c  + ', so it cannot be Converted into an Opportunity.');
                return errorLog;    
            }
            
            // Check all ACP associated with the Renewal. If there are no ACP with Converted_to_Opportunity = false, 
            // do not create oppty (because ACPs are already on another oppty. - lfc - 03Mar2012
                  //US455553 -Renewals Generate Opportunity displaying incorrect error message from batch process
              Integer howManyACP = [Select COUNT() From Active_Contract_Product__c
                                      Where Converted_To_Opportunity__c <> true and
                                      Renewal_Product__r.Renewal__c = :rnwl.Id];
            
            System.debug(' howManyACP'+howManyACP);
             
                if(howManyACP == 0){
                     errorLog.put(rnwl.name,'All Active Contract Products are already associated to Opportunities.');
                        return errorLog;    
                }
            
            List<Territory> terr = [Select Id from Territory Where Country__c = : rnwl.Territory__c LIMIT 1 ]; //FY14
            
            // based on Req. 10.09 LT option is addded by subsa03
            Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
            String BusinessType;
            if(rnwl.Segmentation__c == 'HT')
                BusinessType = 'High Touch';
            else if(rnwl.Segmentation__c == 'MT')
                BusinessType = 'Medium Touch';
            else if(rnwl.Segmentation__c == 'LT')
                BusinessType = 'Low Touch';
            else if(rnwl.Segmentation__c == 'NT')
                BusinessType = 'No Touch';
            else 
                BusinessType = 'Unknown';    
            
            // FY13 - Set oppty close date to a date >= current date
            Date expCloseDate;
            if(rnwl.Expected_Close_Date__c >= date.today())
                expCloseDate = rnwl.Expected_Close_Date__c;
            else
                expCloseDate = date.today();
            System.debug('samap01 getActiveContractProducts ' +rnwl.Id);
            List <Active_Contract_Product__c> ACP =  Renewal_OpportunityUtilityClass.getActiveContractProducts(rnwl.Id);
            
            set<Id> prod = new set<Id>();       
            for(Active_Contract_Product__c actvCP : ACP){ 
                prod.add(actvCP.Product__c);
             
            }       
            
            Map<id,PricebookEntry> ACPProd = new Map<id,PricebookEntry>();  //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);          
             if(prod.size()>0)
           ACPProd = Renewal_OpportunityUtilityClass.getPriceBookEntry(prod,rnwl.Local_Currency__c);
            
            if(ACPProd == null || ACPProd.size() <= 0 || ACPProd.size() < prod.size()){
                system.debug('ACPProd --> ' + ACPProd.size());
                system.debug('prod--> ' + prod.size());
                errorLog.put(rnwl.name,'Pricebook Entry is not active for selected Renewal product(s)!');        
                 return errorLog;     
            }             
            /*********************************/       
            
            //        System.debug('rnwl.Projected_Renewal__c' +rnwl.Projected_Renewal__c);        
            Opportunity opp = new Opportunity(name=rnwl.name,
                                              AccountId=rnwl.Account__c,
                                              CloseDate=rnwl.Expected_Close_Date__c,
                                              Description=rnwl.Overall_Comments__c,
                                              New_Site_Id__c=rnwl.New_Site_Id__c,                                        
                                              CurrencyIsoCode=rnwl.Local_Currency__c,
                                              Inside_Outside__c='Outside',
                                              StageName=Label.Opp_Stage_20_Percent, 
                                              New_Deal_Term_months__c=rnwl.Projected_Time_Duration_Months__c,
                                              Stretch_Deal_Term_Months__c=rnwl.Projected_Time_Duration_Months__c,
                                              OwnerId=rnwl.OwnerId,
                                              Original_CV__c=rnwl.OCV__c,
                                              Site_ID__c=rnwl.Sold_to_Ship_to_Party_Site_ID__c,
                                              Type='Direct',
                                              RPD_Status__c='Requested',
                                              RecordTypeId = recId,
                                              Renewal__c=rnwl.id,
                                              Renewal_Risk__c = rnwl.Renewal_Risk__c, //US511578 - poras01 - passing value for Renewal Risk field from Renewal to opp
                                              Business_Type__c = BusinessType,
                                             //Projected_Renewal__c = rnwl.Projected_Renewal__c,
                                              Projected_Renewal__c = 0.0 , //samap01 - its gettin value from oli trigger - 0 to avoid doubling
                                              //likely flag set to true on opportunity
                                              RoadmapToPlan__c=true //US421493 - MERHA02
                                              // FY13                                          ,Comfort__c = rnwl.Projected_Renewal__c
                                             );
                //US311596 - Start/End Date on Opportunity - BAJPI01
                if(rc!=null){
                if(rc.active_contract__r.header_dismantle_date__c!=null){
                    opp.start_date__c = rc.active_contract__r.header_dismantle_date__c.addDays(1);
                    opp.end_date__c = opp.start_date__c.addMonths(Integer.valueOf(rnwl.Projected_Time_Duration_Months__c));
                    opp.end_date__c = opp.end_date__c.addDays(-1);
                    
                }
            }
           
            try{           
              
                if(terr <> null && terr.size()>0)
                    opp.TerritoryId = terr[0].id;
                  OpportunityHandler.renewalToOppConversion = true;//chajo30 - US368497                
                insert opp;                
                System.debug('samap01 opportunity created'+opp);
              
            }      
            catch (DMLException e) {           
                for (Integer index = 0; index < e.getNumDml(); index++){
                    errorLog.put(rnwl.name,e.getDmlMessage(index));
                }
                return errorLog;
            }                        
           NewOpportunityId = opp.Id;
            rnwl.Opportunity__c=NewOpportunityId;
            //updateRnwlFields(opp,opp.currencyisocode,rnwl); SAMAP01 -us423678 -xxxl
            errorLog =createChildObjects(opp,opp.currencyisocode,rnwl,errorLog) ;
           
        }
        catch(System.DmlException e){
            for (Integer index = 0; index < e.getNumDml(); index++){
                errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));                
            }
            return       errorLog;
            
        }
        catch(Exception e) {
            errorLog.put(rnwl.name,e.getMessage());
            return errorlog;
        }   
        SystemIdUtility.skipTrigger  = false;          
         return errorlog;
        
        
    }
     public static  Map<id,id> createProdRenewal( List<Active_Contract_Product__c> acplist, Opportunity opp)
    {
        System.debug('samap01 createProdRenewal  called');
        List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
        Map<id,id> mRCPACP = new Map<id,id>() ;
        if(acplist.size() >0)
        {
            for( Active_Contract_Product__C acp : acplist)
            {
                String RenewalName=acp.Active_Contract__r.Name;
                String RenewalproductName=acp.name;
                String segment;
                String cbuValue;
                If(acp.Segmentation__c =='HT'|| acp.Segmentation__c =='MT'||acp.Segmentation__c =='LT'||acp.Segmentation__c =='NT'){
                    segment=acp.Segmentation__c;  
                }else{ segment = acp.Pre_Segmentation__c; }
                
                if(RenewalName.length()>20)
                {
                    RenewalName =RenewalName.Substring(0,20);
                }
                if(RenewalproductName.length()>60)
                {
                    RenewalproductName =RenewalproductName.Substring(0,60);
                }
                caProdRnwl.add(new  CA_Product_Renewal__c(
                    Name= RenewalName+ '-' +RenewalproductName,
                    Active_Contract_Product__c= acp.id,
                    Contract__c = acp.Active_Contract__c,
                    Raw_Maintenance__c =acp.Raw_Maint_Calc_LC__c,
                    Renewal_Opportunity__c= opp.Id,
                    currencyIsoCode = opp.CurrencyIsoCode,
                    CAProductRenewal_Amount__c = acp.AOCV__c,
                    ATTRF__c = acp.ATTRF_CRV__c,
                    Baseline_ATTRF__c = acp.Product_Baseline_ATTRF_LC__c,
                    TRR__c= acp.AOCV__c,
                    Projected_Renewal__c= acp.Projected_Renewal_Calc__c
                    
                ));            
                
            }
            
            if(caProdRnwl.size()>0){
                System.debug('samap01 '+caProdRnwl );
                insert caProdRnwl;
                //FY13
                for(CA_Product_Renewal__c cpr: caProdRnwl)
                { 
                    mRCPACP.put(cpr.Active_Contract_Product__c, cpr.id);
                }
            }    
        }
        System.debug('samap01 - ca prod renewal created + mRCPACP ' +mRCPACP);
        return mRCPACP;
        
    }
   
     //Get all ACL for the ACPs for Opportunity Created
    //Create Renewal Contract Product for every ACP
    //Create OLI for every ACL 
    // Update Sales Price for every ACP = Sum of oli.salesprice 
    // Update Sales Price for every Renewal Contract Product = Sum of oli.salesprice  
    // Update ACL with  OLI id
    public static Map<String,String> createChildObjects(Opportunity opp, string currencycode, Renewal__c rnwl, Map<String, String> errorLog)
    {
        set<Id> prod = new set<Id>();    
        Set<Id> actId = new Set<Id>() ; 
        //string cbuValue;
        boolean flag;
        Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
        Savepoint sp = Database.setSavepoint();
        try
        {
            //Get ACP
            List <Active_Contract_Product__c> ACP = Renewal_OpportunityUtilityClass.getActiveContractProducts(rnwl.id);
            if(ACP!=null && ACP.size() >0)
            {
                for(Active_Contract_Product__c actvCP : ACP)
                { 
                    prod.add(actvCP.Product__c);                    
                    System.debug('samap01 -actids ' + actvcp.id);
                    
                }
                Map<id,PricebookEntry> ACPProd = new Map<id,PricebookEntry>();  //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);
                if(prod.size()>0){
                    for(PricebookEntry p : [Select Id,Name,Product2Id,product2.Commissionable_BU__c From PricebookEntry where Product2Id in :prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode                         =:currencycode]){
                        ACPProd.put(p.Product2Id,p);
                    }       
                }   
                for(Active_Contract_Product__c actvCP : ACP)
                {
                    if(ACPProd.get(actvCP.Product__c)!=null)
                    {
                        actId.add(actvCP.Id); 
                    }
                    else
                    {
                        flag =true;
                    }
                }
                
                if(flag==true){
                    errorLog.put(rnwl.name,'Pricebook Entry is not active for selected Renewal product(s)!');
                    errorLog.put(rnwl.name,'Unable to Generated Opportuntity'  );
                    Opportunity oppdelete = [select id from opportunity where id = :opp.Id];
                    system.debug('**hi** deleting the opp created as pricebook entry is not active' );
                    delete  oppdelete;
                    return errorLog;    
                }
                else{
                   
                    //Get ACL
                    Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>(); 
                    List <Active_Contract_Line_Item__c> aclineitems = new   List <Active_Contract_Line_Item__c> (); 
                    
                    aclmap = Renewal_OpportunityUtilityClass.getActiveContractLineItems(actId,opp.AccountId);
                    aclineitems = Renewal_OpportunityUtilityClass.acllist;
                    
                    //Create CA Prod Rnwl for all ACP
                    
                    Map<id,id> mRCPACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Renewal Contract Product           
                    
                    mRCPACP = Renewal_OpportunityUtilityClass.createProdRenewal(ACP, opp);
                    System.debug('samap01- prod renewal created - loop acp and create oli');
                    
                    Map<id,id> mapACLOLI = new Map<id,id>(); //SAMAP01 27/10 Opportunity_Product__c    
                    mapACLOLI = Renewal_OpportunityUtilityClass.CreateOpportunityproducts(actid, prod,aclmap,opp);
                    List<Active_Contract_Line_Item__c>  aclines = new List<Active_Contract_Line_Item__c>(); 
                    if(aclineitems!=null && aclineitems.size()>0){
                        for(Active_Contract_Line_Item__c acl : aclineitems )
                        {
                            acl.Opportunity_Product__c = mapACLOLI.get(acl.id);
                            aclines.add(acl);
                        }
                        if(aclines.size() > 0)
                        {
                            update aclines;
                            System.debug('samap01- acl updated' +aclines);
                        }
                    }
                    
                    
                    List<Active_Contract_Product__C> ActProduct = new List<Active_Contract_Product__c>();
                    
                        for(Active_Contract_Product__c actvp : ACP)
                      {       
                          actvp.Converted_To_Opportunity__c = true;
                          actvp.Opportunity__c = opp.id; 
                          actvp.Renewal_Contract_Product__c =mRCPACP.get(actvp.id);//FY13
                          System.debug(' samap01 - Renewal_Contract_Product__c mRCPACP.get(acp.id)'+mRCPACP.get(actvp.id));
                          actvp.Sales_Price__c =Renewal_OpportunityUtilityClass.mapACPSalesprice.get(actvp.id); 
                          ActProduct.add(actvp); 
              System.debug('samap01 -actvp'+ actvp);
                      }
             
                             
                     if(ActProduct.size() > 0)
                     {
                         update ActProduct;
                         System.debug('samap01 -ActProduct'+ ActProduct);
                     }
                    
                    //Renewal is converted
                    rnwl.Converted_To_Opportunity__c=true; 
                    update rnwl;
                     System.debug('samap01 -Renewal Updated'+ rnwl);
                }    
            }
            //  errorLog.put(rnwl.name,'Generated Opportuntity  ' + opp.name + '-' + opp.Id);
            //String oppurl ='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+'">'+opp.Name+'</a>';
             //  String oppurl =URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id ;
            errorLog.put(rnwl.name,'Generated Opportuntity '+ opp.name );
          

        return errorLog;
        
        //    return   errorLog;
        }
        catch(System.DmlException e){
            for (Integer index = 0; index < e.getNumDml(); index++){
                errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
            }
            errorLog.put(rnwl.name,'Unable to Generated Opportuntity'  );
           
            System.debug('samap01- error occured rollback all the inserts');
            Database.rollback(sp);
            return   errorLog;
        }
        catch(Exception e) {
            errorLog.put(rnwl.name,e.getMessage());
          
            Database.rollback(sp);
            return errorLog;
        } 
          
    }    
 
    
    public static Map<id,id> CreateOpportunityproducts(Set<id> activecontractprodids , Set<Id> prodids ,Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap , opportunity oppty)
    {
        // System.debug('samap01-CreateOpportunityproducts ' + prodids +'--'+ aclineitems+'--' +oppty );
        List<Opportunitylineitem> oppLineItm = NEW List<Opportunitylineitem>();
        Map<id,id> mACLOLI = new Map<id,id>();
        Map<id, PricebookEntry> mapPE = new Map<id,PricebookEntry>();
        Decimal Term_Month =   ARRandDurationCalculation.monthsbetweendates(oppty.Start_Date__c, oppty.End_Date__c);
        System.debug('samap01-CreateOpportunityproducts Term_Month'+Term_Month);
        Integer durationdays;
        if(oppty.Start_Date__c!=null && oppty.End_Date__c!=null)
            durationdays = oppty.Start_Date__c.daysBetween(oppty.End_Date__c)+1;
        System.debug('samap01-CreateOpportunityproducts durationdays'+durationdays);
        //get Pricbookentry
       //String  strpricebookid = getPricebookId();
        
        mapPE = getPriceBookEntry(prodids, oppty.CurrencyIsoCode);
        System.debug('samap01 mapPE '+mapPE);
        String cbuValue='';
        if(aclmap.size()>0)
        { 
            for( Id acpid :activecontractprodids) 
            {
                List<Active_Contract_Line_Item__c>  aclineitems = new List<Active_Contract_Line_Item__c>();
                aclineitems = aclmap.get(acpid);
             
                if(aclineitems!=null && aclineitems.size()>0 )
                {                  
                     decimal acpsalesprice=0;  
                    for(Active_Contract_Line_Item__C acl : aclineitems)
                    {
                        Decimal oliSalesPrice=0.0; // US450593 --- EOL Sales Price -- MERHA02
                        PricebookEntry p= mapPE.get(acl.Contract_Product__r.Product__c);
                        System.debug('samap01 mapPE '+ p +'--'+ acl.Contract_Product__r.Product__c);
                        if(mapPE.containskey(p.product2id)){
                            cbuValue = mapPE.get(p.product2id).product2.Commissionable_BU__c;
                        }  
                        if(acl.Projected_Renewal_Value__c != null )
                        {
                            acpsalesprice += acl.Projected_Renewal_Value__c ;
                            oliSalesPrice =acl.Projected_Renewal_Value__c  ;  //SAMAP01- REVREC UnitPrice=actvCP.Sales_Price__c,// FY13 Comfort__c = actvCP.Sales_Price__c,
                        }else{
                            oliSalesPrice=0;
                        }
                        
                        System.debug('samap01 cbuValue'+cbuValue);
                        String RenewalName=acl.Contract_Product__r.Active_Contract__r.Name;
                        String RenewalproductName=acl.Contract_Product__r.name;
                        String segment;
                        //String cbuValue;
                        If(acl.Contract_Product__r.Segmentation__c =='HT'|| acl.Contract_Product__r.Segmentation__c =='MT'||acl.Contract_Product__r.Segmentation__c =='LT'||acl.Contract_Product__r.Segmentation__c =='NT'){
                            segment=acl.Contract_Product__r.Segmentation__c;  
                        }else{ segment = acl.Contract_Product__r.Pre_Segmentation__c; }
                        
                        if(RenewalName.length()>20)
                        {
                            RenewalName =RenewalName.Substring(0,20);
                        }
                        if(RenewalproductName.length()>60)
                        {
                            RenewalproductName =RenewalproductName.Substring(0,60);
                        }

                        OpportunityLineItem oli = new OpportunityLineItem(
                            PricebookEntryId= p.id ,//p.id,
                            CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                            Active_Contract_Product__c = acl.Contract_Product__c,
                            Active_Contract_Line_Item__c =acl.ID,
                            Active_Contract__c=acl.Contract_Product__r.Active_Contract__c,
                            Opportunityid = oppty.Id,  
                            Baseline_ATTRF_LC__c = acl.Baseline_ATTRF_LC__c,
                            Stretch__c=acl.Projected_Renewal_Value__c,
                            Business_Type__c = 'Renewal',    
                            License__c = acl.License_Type_Text__c, 
                            Segmentation__c = segment ,
                            Original_Expiration_Date__c = acl.Dismantling_Date__c,
                            Original_Deal_Term_Months__c= acl.Install_Dismantle_Duration_months__c, 
                            New_Deal_Term_Months__c = acl.Contract_Product__r.Renewal_Product__r.Projected_Time_Duration_Months__c,
                            Original_CV__c= acl.OCV__c,
                            Offerings_Family__c = acl.Contract_Product__r.Product__r.Family, 
                            Original_Contract_IDs__c= acl.Contract_Product__r.Active_Contract_Number__c,
                          TARR__c =acl.Material_TARR_LC__c,
                            List_Price_License_LC__c= acl.List_Price_License_LC__c, //US424951
                            List_Price_Maintenance_LC__c =acl.List_Price_Maintenance_LC__c //US424951
                            );
                        // US450593 -- exclusion of EOL products -- MERHA02 -- start
                        if(acl.Renewal_Valuation_Type__c=='Invalid-EOL-No Replacement Product'||acl.Renewal_Valuation_Type__c=='Invalid - Federal Rebook'){
                            oli.Old_TRR__c = 0.0;
                            oli.Raw_Maintenance__c=0.0;
                            oli.ATTRF__c=0.0;
                            oli.UnitPrice = 0.0;
                        }
                        else{
                            oli.Old_TRR__c=acl.AOCV__c;   
                            oli.Raw_Maintenance__c=acl.Raw_Maintenance_LC__c; 
                            oli.ATTRF__c=acl.Orig_ATTRF_LC__c;
                            oli.UnitPrice = oliSalesPrice;
                        }
                        // US450593 -- exclusion of EOL products -- MERHA02 -- END              
                        oli.Start_Date__c = oppty.Start_Date__c;
                        oli.End_Date__c = oppty.End_Date__c;
                        
                   
                        if(oppty.Start_Date__c!=null && oppty.End_Date__c!=null){
                           // oli.TARR_New__c = (oli.UnitPrice / oli.Start_Date__c.daysBetween(oli.End_Date__c) +1 ) * 365 ;  //US424523 SAMAP01 -REVREC TARR NEW
                            oli.Duration_Days__c = durationdays; // oli.Start_Date__c.daysbetween(oli.End_Date__c)+1;
                            oli.Term_Month__c = Term_Month;
                            oli.New_Deal_Term_Months__c = oli.Term_Month__c;
                            
                            
                        }
                        oppLineItm.add(oli);
                        
                    }
                     mapACPSalesprice.put(acpid, acpsalesprice); 
                }
                
               
            }
            if(oppLineItm.size()>0){
                insert oppLineItm;
                System.debug('samap01-insert CreateOpportunityLineItems'+oppLineItm);
                //FY13
                for(OpportunityLineItem oli: oppLineItm)
                { 
                    // mOLIACP.put(oli.Active_Contract_Product__c,oli.id);
                    mACLOLI.put(oli.Active_Contract_Line_Item__c, oli.id); //SAMAP01 
                }
            }
            
        }
        oppLineItm.clear();
        System.debug('samap01 - acl oli'+mACLOLI);
        return mACLOLI;
    } 
    
    //samap01 - verify if the primary contact exists. If not show message
    public static boolean  Primarycontactexists(Opportunity o)
    {
        Boolean hasprimarycontact = true ;
         Integer closemonth;
         Integer closeyear;
        if(o.closedate != null)
        {
             closemonth = o.closedate.month();
             closeyear = o.closedate.year();
        }        
        Integer fyMonth = Opportunity_ContactRole_Class.fymonth;
        Integer fyYear = System.today().year();
                        
        Set < Id > oppsWithPrimaryContact = new Set < Id > ();
                for (OpportunityContactRole ocr: [SELECT OpportunityId
                                                  FROM OpportunityContactRole
                                                  WHERE IsPrimary = true
                                                  AND OpportunityId =: o.id
                                                 ]) {
                                                     oppsWithPrimaryContact.add(ocr.OpportunityId);
                                                     System.debug('Ocr Opp Id: ' + ocr.OpportunityId);
                                                 }
                
       // if ((o.Probability >= 20 && o.Probability != 100 && o.SBQQ__Renewal__c == false)|| 
            if ((o.Probability >= 20 && o.Probability != 100 )|| 
              (o.Probability == 100 
                                    && ((closemonth >= fymonth && closeyear == fyyear) 
         || (closemonth < fymonth && closeyear == fyyear + 1))) && !Opportunity_ContactRole_Class.insertedOpps.contains(o.Id))
        {  
                        if (!oppsWithPrimaryContact.contains(o.Id)) {
                                System.debug('Opp checking with ' + o.Id);
                           hasprimarycontact =false;
                        }
                          
                            
                        }
         return hasprimarycontact;           
                
    }
    public void emailLogs(Map<String, String> errorLog)
    {
        
        
        if(errorLog != null && errorLog.size() > 0)
        {
            String strResult;
            string subject1;
            strResult = strResult + 'Renewal Name' + '~' + 'Message' + '\n';
            Set<String> errorSet= new Set<String>();
            errorSet= errorLog.keySet();
            
            for(String s: errorSet)
                strResult = strResult + s + '~' + errorLog.get(s) +'\n';
            
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            strResult = strResult.replaceAll(',', ' ');          
            strResult = strResult.replaceAll('~', ',');          
            strResult = strResult.replaceAll('TRUE', 'Yes');          
            strResult = strResult.replaceAll('FALSE', 'No');          
            strResult = strResult.replaceAll('null', '');   
            blob csvBlob =   Blob.valueOf(strResult);
            string csvname= 'ErrorLog.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            
            email.setSubject('Error Log');
            
            
            email.setToAddresses(new String[] {UserInfo.getUserEmail() }); 
            
            email.setPlainTextBody('Error Log');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            if (r.get(0).isSuccess())
            {
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.CONFIRM,'Mail Sent')); 
            }
            else
            {
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Mail not sent')); 
            }
            
        }
        else
        {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'No Records to Email')); 
        }
    }
     
    
  
}