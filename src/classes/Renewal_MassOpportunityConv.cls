/* ********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       16/10/2017       US370595        RevRec: SFDC Opportunity License Classification for renewal products
* ********************************************************************************************/
public class Renewal_MassOpportunityConv {
    List<String> selectedIds = new List<String>();    
    //Map<String,String> errorLog = new Map<String,String>(); 
    public boolean showPageMessage {get;set;}
    public Map<String, String> errorLog { get; set; }
    public string EmailMsg { get; set; }
    public String Ids;
    Boolean flag;
    public List<Active_Contract_Line_Item__c>  AclProduct = new List<Active_Contract_Line_Item__c>(); //samap01 27/10
    
    public Boolean showEmailLogButton {get;  set;}
    public String backToTab {get;set;}
    public Decimal BatchNumber {get;set;}
    
    public Map<String, String> geterrorLog() {
        
        return errorLog;
    }
    public Renewal_MassOpportunityConv(){
        showPageMessage = false;
        errorLog = new Map<String, String>();      
        backToTab  = '/a1z/o';
        Ids =ApexPages.currentPage().getParameters().get('records');
        if(Ids!=null)
            selectedIds = Ids.split(',');
        system.debug('selectedIds -->' + selectedIds);
        
    }
    
    public pagereference RenewalConv(){
        
        Renewal_MassOpportunityConv rc = new Renewal_MassOpportunityConv();
        Date dt1;
        Date dt2;
        
        SystemIdUtility.skipTrigger  = true;
        //errorlog = rc.Renewal_ConvertRenewalsMain('listView',dt1,dt2,'');
        //errorlog = convRenewals();
        
        List<Renewal__c> selRenewalIds = [select id from Renewal__c where Id in :selectedIds];    //samap01 - modified 12/20       
        Set<Id> selIds = (new Map<Id,Renewal__c>(selRenewalIds)).keySet();
        // List<Renewal__c> selRenewallist = Renewal_OpportunityUtilityClass.RetrieveRenewals(selectedIds) ;
        
        List<Opp_Generation_Error_Log__c> genError = new List<Opp_Generation_Error_Log__c>(); 
        genError  = [Select Batch_Number__c From Opp_Generation_Error_Log__c where Batch_Number__c != null order by Batch_Number__c desc];
        
        if(genError != null && genError.size() > 0)
        {
            if(genError[0].Batch_Number__c != null)
                BatchNumber =  genError[0].Batch_Number__c; 
            else
                BatchNumber =-1; 
            
        }     
        else
            BatchNumber = -1;  
        /* To check number of batch jobs currently running */
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
            System.debug('samap01 -- batch job is getting called with ids '+selIds);
            BatchNumber  = BatchNumber + 1 ;
            batchRenewalConv btRenewalConv = new batchRenewalConv(selIds , BatchNumber);   //samap01 
            
            ID batchprocessid  = database.executeBatch(btRenewalConv,1);
            
            
        }
        else
        {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Records cannot be processed now .Please try after somtime.'));
        }
        
        
        return null;   
        
    }    
    
    public Map<String, String> convRenewals()
    {
        List<Renewal__c> ren =new List<Renewal__c>();
        for(Renewal__c rnwl : [select id, Segmentation__c, name, Account__c, OwnerId, Expected_Close_Date__c, 
                               Converted_To_Opportunity__c, Overall_Comments__c, CurrencyIsoCode,
                               Projected_Time_Duration_Months__c, OCV__c, Annual_OCV_LC__c, Baseline_ATTRF_LC__c, //adding baseline for baseline attrf req
                               Sold_to_Ship_to_Party_Site_ID__c, Projected_Renewal__c,owner.isActive,
                               Local_Currency__c, New_Site_Id__c, Territory__c, // Changed for FY14 - was Territory_Country__c
                               Reason_duration_is_1_year__c,Status_at_end_of_term__c, // AR 3051
                               (select active_contract__r.header_dismantle_date__c,
                                active_contract__r.Contract_Term_Months__c from Renewals_Product_Contracts__r)
                               from Renewal__c 
                               where Id in :selectedIds] )
        {
            errorLog = CreateOpp(rnwl);
        }
        return errorLog;
        //acc = [select id from Account where id=:rnwl.Account__c]; 
        
        
    }
    
    public Map<String, String> CreateOpp(Renewal__c rnwl)
    {  
        Renewal_Contracts__c rencontract;
        if(rnwl.Renewals_Product_Contracts__r.size()>0)
            rencontract = rnwl.Renewals_Product_Contracts__r.get(0);
        try
        {
            SystemIdUtility.skipTrigger  = true;   
            if(rnwl.owner.isActive ==false)
            {
                errorLog.put(rnwl.name,'The Owner of the renewal is inactive and the renewal cannot be converted to Opportunity');
                showEmailLogButton = true;
                return errorLog;    
            }
            
            if(rnwl.Converted_To_Opportunity__c==true){
                errorLog.put(rnwl.name,'The selected Renewal already been Converted into an Opportunity.');
                showEmailLogButton = true;
                return errorLog;    
            }
            // based on Req. 10.09 LT option is addded by subsa03
            
            if(rnwl.Segmentation__c != 'HT' && rnwl.Segmentation__c  != 'MT' && rnwl.Segmentation__c  != 'LT'){
                errorLog.put(rnwl.name,'This Renewal has the Segmentation ' + rnwl.Segmentation__c  + ', so it cannot be Converted into an Opportunity.');
                showEmailLogButton = true;
                return errorLog;    
            }
            
            // Check all ACP associated with the Renewal. If there are no ACP with Converted_to_Opportunity = false, 
            // do not create oppty (because ACPs are already on another oppty. - lfc - 03Mar2012
            Integer howManyACP = [Select COUNT() From Active_Contract_Product__c
                                  Where Converted_To_Opportunity__c <> true and
                                  Renewal_Product__r.Renewal__c = :rnwl.Id];
            
            if(howManyACP == 0){
                errorLog.put(rnwl.name,'All Active Contract Products are already associated to Opportunities.');
                showEmailLogButton = true;
                return errorLog;    
            }
            
            //FY13 Add the Territory to Opp
            //FY14 Territory terr = [Select Id from Territory Where Territory_Country__c = : rnwl.Territory_Country__c LIMIT 1 ];
            Territory terr = [Select Id from Territory Where Country__c = : rnwl.Territory__c LIMIT 1 ]; //FY14
            
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
            
            //        System.debug('rnwl.Projected_Renewal__c' +rnwl.Projected_Renewal__c);        
            Opportunity opp = new Opportunity(name=rnwl.name,
                                              AccountId=rnwl.Account__c,
                                              CloseDate=rnwl.Expected_Close_Date__c,
                                              Description=rnwl.Overall_Comments__c,
                                              New_Site_Id__c=rnwl.New_Site_Id__c,                                        
                                              CurrencyIsoCode=rnwl.Local_Currency__c,
                                              Inside_Outside__c='Outside',
                                              StageName=Label.Opp_Stage_20_Percent, // US149780 by SAMTU01
                                              New_Deal_Term_months__c=rnwl.Projected_Time_Duration_Months__c,
                                              Stretch_Deal_Term_Months__c=rnwl.Projected_Time_Duration_Months__c,
                                              OwnerId=rnwl.OwnerId,
                                              Original_CV__c=rnwl.OCV__c,
                                              Site_ID__c=rnwl.Sold_to_Ship_to_Party_Site_ID__c,
                                              Type='Direct',
                                              RPD_Status__c='Requested',
                                              RecordTypeId = recId,
                                              Renewal__c=rnwl.id,
                                              Business_Type__c = BusinessType,
                                              Projected_Renewal__c = rnwl.Projected_Renewal__c
                                              // FY13                                          ,Comfort__c = rnwl.Projected_Renewal__c
                                             );
            
            
            //AR 3051
            If(rnwl.Reason_duration_is_1_year__c!=null && rnwl.Status_at_end_of_term__c!=null)
            {
                opp.Reason_duration_is_1_year__c = rnwl.Reason_duration_is_1_year__c ;
                opp.Status_at_end_of_term__c = rnwl.Status_at_end_of_term__c ;
                
            }
            //US311596 - Start/End Date on Opportunity - BAJPI01
            if(rencontract!=null){
                if(rencontract.active_contract__r.header_dismantle_date__c!=null){
                    opp.start_date__c = rencontract.active_contract__r.header_dismantle_date__c.addDays(1);
                    opp.end_date__c = opp.start_date__c.addMonths(Integer.valueOf(rnwl.Projected_Time_Duration_Months__c));
                    opp.end_date__c = opp.end_date__c.addDays(-1);
                    
                }
            }
            //US311596 - Start/End Date on Opportunity - BAJPI01
            
            
            
            //System.debug('Opp Proj Renewal$$1 '+opp.Projected_Renewal__c);
            //try
            {            
                //FY13 - Assign the Terr on Opp from the Renewal Territory/Country Field
                if(terr <> null)
                    opp.TerritoryId = terr.id;
                insert opp;
                
                OpportunityHandler.renewalToOppConversion = true; //chajo30 - US368497
            }      
            
            
            Id id = opp.Id;
            rnwl.Opportunity__c=id;
            //updateRnwlFields(opp,opp.currencyisocode,rnwl);
            // //samap01 -11/28 
            createChildObjects(opp,opp.currencyisocode,rnwl);
            //        System.debug('Opp Proj Renewal$$3 '+opp);
            
            //redirect the page to the RPD Review for opportunity page.
        }
        catch(System.DmlException e){
            for (Integer index = 0; index < e.getNumDml(); index++){
                errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
            }
            return       errorLog;
        }
        catch(Exception e) {
            errorLog.put('',e.getMessage());
            //return 'Exception '+e;
            return errorlog;
        } 
        
        SystemIdUtility.skipTrigger  = false;          
        
        if(errorLog.size() > 0 )
            showEmailLogButton  = true;
        else
            showEmailLogButton = false;
        return errorlog;
        
        
    }
    
    
    
    //Get all ACL for the ACPs for Opportunity Created
    //Create Renewal Contract Product for every ACP
    //Create OLI for every ACL 
    // Update Sales Price for every ACP = Sum of oli.salesprice 
    // Update Sales Price for every Renewal Contract Product = Sum of oli.salesprice  
    // Update ACL with  OLI id
    public boolean createChildObjects(Opportunity opp, string currencycode, Renewal__c rnwl)
    {
        set<Id> prod = new set<Id>();    
        Set<Id> actId = new Set<Id>() ; 
        
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
                    errorLog.put('Error','Pricebook Entry is not active for selected Renewal product(s)!');
                    Opportunity oppdelete = [select id from opportunity where id = :opp.Id];
                    system.debug('**hi** deleting the opp created as pricebook entry is not active' );
                    delete  oppdelete;
                    return false;    
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
                    mapACLOLI = Renewal_OpportunityUtilityClass.CreateOpportunityproducts(actId, prod,aclmap,opp);
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
                }    
            }
            return   true;
        }
        catch(System.DmlException e){
            for (Integer index = 0; index < e.getNumDml(); index++){
                errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
            }
            System.debug('samap01- error occured rollback all the inserts');
            Database.rollback(sp);
            return       false;
        }
        catch(Exception e) {
            errorLog.put('',e.getMessage());
            //return 'Exception '+e;
            // An exception was caught. We need to revert back to our Savepoint
            // This will rollback all successful changes. So, if opps saved successfully
            // and then quotes failed, the opps will be rolled back as well
            Database.rollback(sp);
            return false;
        } 
        
        return true;
    }
    
    public Map<String, String> updateRnwlFields(Opportunity opp, string currencycode, Renewal__c rnwl){
        
        List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
        List<OpportunityLineItem> RnwlOppLnItm = new List<OpportunityLineItem>();
        //US311596 - Start/End Date on Opportunity - BAJPI01
        Date oppstartdate =  opp.start_date__c;
        Date oppenddate = opp.end_date__c;
        Integer durationdays;
        if(oppstartdate!=null && oppenddate!=null)
            durationdays = oppstartdate.daysBetween(oppenddate)+1;
        Decimal Term_Month =   ARRandDurationCalculation.monthsbetweendates(oppstartdate, oppenddate);
        //US311596 - Start/End Date on Opportunity - BAJPI01
        
        rnwl.Converted_To_Opportunity__c=true;      
        
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
             where Renewal_Product__r.Renewal__c=:rnwl.Id
             and Converted_To_Opportunity__c <> true]; // exclude ACPs already converted to Opptys - lfc - 06Mar2012
        
        
        
        set<Id> prod = new set<Id>();    
        //samap01- revrec
        Set<Id> actId = new Set<Id>() ; //samap01 -revrec - get all Active contract products          
        Map<Id, LIST<Active_Contract_Line_Item__C>> aclmap = new Map<id, LIST<Active_Contract_Line_Item__C >>(); //Samap01
        List <Active_Contract_Line_Item__c> aclineitems = new   List <Active_Contract_Line_Item__c> (); //samap01
        Set<Id> Activecontractproduct  = new Set <Id> ();
        //decimal acpsalesprice=0;
        //samap0q-reverec
        for(Active_Contract_Product__c actvCP : ACP){ 
            prod.add(actvCP.Product__c);
            actId.add(actvCP.Id); // samap01 -revrec 
            System.debug('samap01 -actids ' + actvcp.id);
        }       
        
        Map<id,PricebookEntry> ACPProd = new Map<id,PricebookEntry>();
        //([Select Id,Name From PricebookEntry where Product2Id  in : prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]);          
        for(PricebookEntry p : [Select Id,Name,Product2Id From PricebookEntry where Product2Id in :prod and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode]){ 
            ACPProd.put(p.Product2Id,p);
        }       
        //samap01 -revrec 
        if(actId.size()>0 )
        {
            System.debug('samap01 actId' +actId);
            //Get ACL information
            // aclmap = Renewal_OpportunityUtilityClass.getActiveContractLineItems(actId);
            // aclineitems = Renewal_OpportunityUtilityClass.acllist;
            aclineitems =   [Select
                             ID,
                             Raw_Maintenance_LC__c,
                             Orig_ATTRF_LC__c,
                             Baseline_ATTRF_LC__c,
                             AOCV__c,
                             Sales_Price__c,
                             Dismantling_Date__c,
                             Opportunity_product__c,
                             Renewal_Valuation_Type__c,
                             Install_Dismantle_Duration_months__c,
                             OCV__c,
                             Sales_Document__c,
                             License_Type_Text__c,
                             Product_Material__c,
                             Sales_Document_Item__c,
                             Contract_Product__c,                                                                 
                             Contract_Product__r.name,
                             Projected_Renewal_Value__c,
                             //Contract_Product__r.Sales_Price__c,                     
                             Contract_Product__r.Converted_To_Opportunity__c,
                             //Contract_Product__r.Dismantle_Date__c,
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
                             //Contract_Product__r.Product__c, 
                             Contract_Product__r.Sales_Price__c ,
                             Contract_Product__r.Product__r.Name, 
                             Contract_Product__r.Product__r.Family
                             From 
                             Active_Contract_Line_Item__c
                             where 
                             Contract_Product__c in : actId];
            
            if(aclineitems != null && aclineitems.size() > 0)
            {
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
        }
        //samap01 -revrec end
        if(ACPProd != null && ACPProd.size() > 0){
            for(Active_Contract_Product__c actvCP:ACP){ 
                //for(PricebookEntry p:[Select Id,Name From PricebookEntry where Product2Id =: actvCP.Product__c and Pricebook2.Name='CA Product List' and IsActive =:true and CurrencyIsoCode =:currencycode limit 1])
                
                if(ACPProd.get(actvCP.Product__c)!=null){
                    actvCP.Converted_To_Opportunity__c=true;
                    actvCP.Opportunity__c = opp.Id;      
                    
                    // avoid issue where null value causes OpportunityLiItm.UnitPrice to default to 1.0
                    if(actvCP.Projected_Renewal_Calc__c != null)
                        actvCP.Sales_Price__c = actvCP.Projected_Renewal_Calc__c;
                    else 
                        actvCP.Sales_Price__c = 0;
                    
                    String RenewalName= actvCP.Product__r.Name;
                    String RenewalproductName= actvCP.Active_Contract__r.Name;
                    String segment;
                    If(actvCP.Segmentation__c =='HT'||actvCP.Segmentation__c =='MT'||actvCP.Segmentation__c =='LT'||actvCP.Segmentation__c =='NT'){
                        segment=actvCP.Segmentation__c;  
                    }else{ segment = actvCP.Pre_Segmentation__c; }
                    
                    if(RenewalName!=null && RenewalName.length()>30)
                        RenewalName = RenewalName.Substring(0,30);
                    if(RenewalproductName !=null && RenewalproductName.length()>50)
                        RenewalproductName =RenewalproductName.Substring(0,50);
                    
                    caProdRnwl.add(new CA_Product_Renewal__c(
                        name=RenewalproductName +'-'+RenewalName,
                        Active_Contract_Product__c=actvCP.Id,
                        Contract__c=actvCP.Active_Contract__c,
                        CAProductRenewal_Amount__c=actvCP.AOCV__c,
                        Renewal_Opportunity__c=opp.Id,
                        Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                        ATTRF__c = actvCP.ATTRF_CRV__c,
                        Baseline_ATTRF__c = actvCP.Product_Baseline_ATTRF_LC__c,
                        trr__C = actvCP.AOCV__c, 
                        currencyIsoCode = currencycode,
                        Projected_Renewal__c= actvCP.Sales_Price__c
                    ));  
                    
                    //Get the active contract line items for each ACP and create opp line item
                    List<Active_Contract_Line_Item__C> aclmaplist = aclmap.get(actvCP.ID)  ;                  
                    if(aclmaplist != null && aclmaplist.size() >0 )
                    {
                        decimal acpsalesprice=0;
                        
                        for(Active_Contract_Line_Item__C acl : aclineitems)
                        {
                            Decimal oliSalesPrice=0.0; // US450593 --- EOL Sales Price -- MERHA02
                            PricebookEntry p= ACPProd.get(acl.Contract_Product__r.Product__c);
                            System.debug('samap01 mapPE '+ p +'--'+ acl.Contract_Product__r.Product__c);
                             
                            if(acl.Projected_Renewal_Value__c != null )
                            {
                                acpsalesprice += acl.Projected_Renewal_Value__c ;
                                oliSalesPrice =acl.Projected_Renewal_Value__c  ;  //SAMAP01- REVREC UnitPrice=actvCP.Sales_Price__c,// FY13 Comfort__c = actvCP.Sales_Price__c,
                            }else{
                                oliSalesPrice=0;
                            }
                            
                            
                            OpportunityLineItem oli = new OpportunityLineItem(
                                PricebookEntryId= ACPProd.get(acl.Contract_Product__r.Product__c).Id,
                                CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                                Active_Contract_Product__c = acl.Contract_Product__c,
                                Active_Contract_Line_Item__c =acl.ID,
                                Active_Contract__c=acl.Contract_Product__r.Active_Contract__c,
                                Opportunityid = opp.Id,
                                
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
                                Original_Contract_IDs__c= acl.Contract_Product__r.Active_Contract_Number__c);
                            
                            // US450593 -- exclusion of EOL products -- MERHA02 -- start
                            if(acl.Renewal_Valuation_Type__c=='Invalid-EOL-No Replacement Product'||acl.Renewal_Valuation_Type__c=='Invalid - Federal Rebook'){
                                oli.Old_TRR__c=0.0;
                                oli.ATTRF__c=0.0;
                                oli.Raw_Maintenance__c=0.0;
                                oli.UnitPrice = 0.0;
                            }
                            else{
                                oli.Old_TRR__c=acl.AOCV__c;
                                oli.ATTRF__c=acl.Orig_ATTRF_LC__c;
                                oli.Raw_Maintenance__c=acl.Raw_Maintenance_LC__c;
                                 oli.UnitPrice = oliSalesPrice;
                            }
                            // US450593 -- exclusion of EOL products -- MERHA02 -- end
                            
                            oli.Start_Date__c = opp.Start_Date__c;
                            oli.End_Date__c = opp.End_Date__c;
                            
                            if(opp.Start_Date__c!=null && opp.End_Date__c!=null){
                                
                                oli.Duration_Days__c = durationdays; // oli.Start_Date__c.daysbetween(oli.End_Date__c)+1;
                                oli.Term_Month__c = Term_Month;
                                oli.New_Deal_Term_Months__c = oli.Term_Month__c;
                               
                                
                            }
                            RnwlOppLnItm.add(oli);
                            
                        }
                        
                        actvCP.Sales_Price__c =acpsalesprice; //sales price sum of the acl price
                    }
                    
                }
                else{
                    flag = true;
                }          
                
            }
        }
        if(flag==true){
            errorLog.put('Error','Pricebook Entry is not active for selected Renewal product(s)!');
            return errorLog;    
        }else{
            
            //updates
            update rnwl;
            
            //FY13 -   start
            Map<id,id> mOLIACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Opplineitem
            Map<id,id> mRCPACP = new Map<id,id>(); //MAP to store the ids of Active Contract Product, Renewal Contract Product
            Map<id,id> mACLOLI = new Map<id,id>(); //SAMAP01 27/10 Opportunity_Product__c   
            //FY13 end
            
            if(caProdRnwl.size()>0){
                insert caProdRnwl;
                
                //FY13 - storing the ids of Active Contract Product, Renewal Contract Product in map
                for(CA_Product_Renewal__c cpr: caProdRnwl)
                { 
                    mRCPACP.put(cpr.Active_Contract_Product__c, cpr.id);
                }
            }       
            if(RnwlOppLnItm.size() >0){
                insert RnwlOppLnItm; 
                
                //FY13 - storing the ids of Active Contract Product, Opplineitem in map
                for(OpportunityLineItem oli: RnwlOppLnItm)
                { 
                    mOLIACP.put(oli.Active_Contract_Product__c,oli.id);
                    mACLOLI.put(oli.Active_Contract_Line_Item__c, oli.id); //SAMAP01 
                }
            } 
            
            //FY13 - Updating the ids of Renewal Contract Product, Opplineitem on Active Contract Product from the maps
            for(Active_Contract_Product__c a:ACP)
            {
                //a.Opportunity_Product__c =mOLIACP.get(a.id);//FY13
                a.Renewal_Contract_Product__c =mRCPACP.get(a.id);//FY13
            }
            
            if(ACP.size()>0){
                update ACP;
            }
            //samap01 -Revrec -27/10
            // after the OLI is insertedc - Update ACL with OLI ID for informatica jobs to function
            if(aclineitems.size()>0)
            {
                for(Active_Contract_Line_Item__c acl : aclineitems )
                {
                    acl.Opportunity_Product__c = mACLOLI.get(acl.id);
                    AclProduct.add(acl);
                }
                
            }
            if(AclProduct.size() > 0)
            {
                update AclProduct;
            }
            //samap01 -Revrec -27/10    
            return errorLog;
        }                         
    }
    
    public void emailLogs()
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
                //EmailMsg = 'Mail Sent';
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.CONFIRM,'Mail Sent')); 
                showPageMessage = true;
            }
            else
            {
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Mail not sent')); 
                //  EmailMsg = 'Mail not sent';
                showPageMessage = true;
            }
            
        }
        else
        {
            Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'No Records to Email')); 
            // EmailMsg = 'No Records to Email';
            showPageMessage = true;
        }
    }
    
    public String Renewal_ConvertRenewalsMain(
        String methodCalledFrom, Date startDate, Date endDate,String segmentation){
            
            Date oppstartdate;
            Date oppenddate;
            Integer durationdays;
            Set<id> productIdSet = new Set<Id>(); //to store product2id from pricebook entry - to query product2 to fetch CBU value.
            Map<id,string> prod2idCbuMap = new Map<id,string>();
           
            Boolean flag;
            
            Map<Id,Opportunity> oppInsert = new Map<Id,Opportunity>();
            Map<Id,Renewal__c> renUpdate = new  Map<Id,Renewal__c>();
            Map<Id,List<CA_Product_Renewal__c>> prodRenewalInsert = new  Map<Id,List<CA_Product_Renewal__c>>();
            Map<Id,List<OpportunityLineItem>> opplineItemInsert = new  Map<Id,List<OpportunityLineItem>>(); 
            Map<Id,List<Active_Contract_Product__c>> ActContractUpdate = new  Map<Id,List<Active_Contract_Product__c>>();
            
            
            try{
                Map<Id,Active_Contract_Product__c> RenewalToACPMap = new Map<Id,Active_Contract_Product__c>();
                Map<Id,Renewal__c> RenewalMap = new Map<Id,Renewal__c>();
                Map<Id,Renewal__c> productGroupMap = new Map<Id,Renewal__c>();
                Map<Id,Active_Contract_Product__c> ACPMap = new Map<Id,Active_Contract_Product__c>();
                Map<Id,PricebookEntry> acpToPriceBookEntryMap = new Map<Id,PricebookEntry>();
                
                Map<Id,Id> prodPBELookup = new Map<Id,Id>();
                Map<String,String> currPBELookup = new Map<String,String>();
                Set<String> prodCurrPBELookup = new Set<String>();
                Map<String,Id> prodCurrPBEItem = new Map<String,Id>();
                
                Map<String,Id> mapTerritoryToID = new Map<String,Id>();
                
                
                
                for(Active_Contract_Product__c acContractProd: 
                    [Select a.Name, 
                     a.AOCV__c,
                     a.OCV__c,
                     a.Active_Contract_Number__c,
                     a.ATTRF_CRV__c,
                     a.Product_Baseline_ATTRF_LC__c,
                     a.Dismantle_Date__c,
                     a.Product__c,
                     a.Converted_To_Opportunity__c,
                     a.Raw_Maint_Calc_LC__c,
                     a.Projected_Renewal_Calc__c,
                     a.Segmentation__c,
                     a.Pre_Segmentation__c,
                     a.Active_Contract__c, 
                     a.Active_Contract__r.Name,
                     a.Active_Contract__r.header_dismantle_date__c,
                     a.Active_Contract__r.Contract_Term_Months__c,
                     a.Renewal_Product__c, 
                     a.Renewal_Product__r.Projected_Renewal_LC__c,
                     a.Renewal_Product__r.Renewal__c,
                     a.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c,
                     a.Renewal_Product__r.Renewal__r.Segmentation__c, 
                     a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,
                     a.Renewal_Product__r.Renewal__r.Annual_OCV_LC__c, 
                     a.Renewal_Product__r.Renewal__r.OCV__c, 
                     a.Renewal_Product__r.Renewal__r.Expected_Close_Date__c, 
                     a.Renewal_Product__r.Renewal__r.Sold_to_Ship_to_Party_Site_ID__c,
                     a.Renewal_Product__r.Renewal__r.Account__c, 
                     a.Renewal_Product__r.Renewal__r.CurrencyIsoCode,
                     a.Renewal_Product__r.Renewal__r.Name,
                     a.Renewal_Product__r.Renewal__r.Renewal_Number__c,
                     a.Renewal_Product__r.Renewal__r.OwnerId,
                     a.Renewal_Product__r.Renewal__r.Overall_Comments__c,
                     a.Renewal_Product__r.Renewal__r.Projected_Renewal__c,
                     a.Renewal_Product__r.Renewal__r.Local_Currency__c,
                     a.Renewal_Product__r.Renewal__r.New_Site_Id__c,
                     a.Renewal_Product__r.Renewal__r.Territory__c, // FY14 - was Territory_Country__c 
                     a.Renewal_Product__r.Renewal__r.Owner.isActive 
                     From Active_Contract_Product__c a 
                     where a.Renewal_Product__r.Renewal__c in: selectedIds
                     and a.Renewal_Product__c != null
                     /////and a.Converted_To_Opportunity__c = false
                     /////and a.Renewal_Product__r.Renewal__r.Segmentation__c in ('HT', 'MT', 'LT')
                    ]
                   ){
                       
                       
                       
                       system.debug('-------1---------' + selectedIds);
                       ////////////////////////////////////////////////                     
                       
                       if(acContractProd.Renewal_Product__r.Renewal__r.owner.isActive ==false)
                       {
                           errorLog.put(acContractProd.Renewal_Product__r.Renewal__r.name,'The Owner of the renewal is inactive and the renewal cannot be converted to Opportunity');                         
                           system.debug('acContractProd.Renewal_Product__r.Renewal__r.owner.isActive --> ' + acContractProd.Renewal_Product__r.Renewal__r.owner.isActive);
                           return null;
                       }
                       
                       if(acContractProd.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c==true){
                           errorLog.put(acContractProd.Renewal_Product__r.Renewal__r.name,'The selected Renewal already been Converted into an Opportunity.');            
                           system.debug('The selected Renewal already been Converted into an Opportunity.');
                           return null;
                       }
                       // based on Req. 10.09 LT option is addded by subsa03
                       
                       if(acContractProd.Renewal_Product__r.Renewal__r.Segmentation__c != 'HT' && acContractProd.Renewal_Product__r.Renewal__r.Segmentation__c  != 'MT' && acContractProd.Renewal_Product__r.Renewal__r.Segmentation__c  != 'LT'){
                           errorLog.put(acContractProd.Renewal_Product__r.Renewal__r.name,'This Renewal has the Segmentation ' + acContractProd.Renewal_Product__r.Renewal__r.Segmentation__c  + ', so it cannot be Converted into an Opportunity.');               
                           system.debug('This Renewal has the Segmentation');
                           return null;
                       }      
                       
                       
                       Renewal__c renTmp = new Renewal__c(
                           Id = acContractProd.Renewal_Product__r.Renewal__c,
                           Name = acContractProd.Renewal_Product__r.Renewal__r.name,
                           Segmentation__c = acContractProd.Renewal_Product__r.Renewal__r.Segmentation__c,
                           Projected_Time_Duration_Months__c = acContractProd.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c);
                       
                       productGroupMap.put(acContractProd.ID,renTmp);                                   
                       RenewalToACPMap.put(acContractProd.Renewal_Product__r.Renewal__c,acContractProd);
                       RenewalMap.put(acContractProd.Renewal_Product__r.Renewal__c,renTmp);
                       ACPMap.put(acContractProd.Id,acContractProd);
                       
                       //FY13 Save the Territory for one-time lookup
                       
                       if(!mapTerritoryToID.containsKey(acContractProd.Renewal_Product__r.Renewal__r.Territory__c)) //FY14
                           mapTerritoryToID.put(acContractProd.Renewal_Product__r.Renewal__r.Territory__c,null); //FY14
                       
                       // Populate the characteristics for the one-time PBE lookup.
                       // These maps will be used to select and then filter all potential related PBEs.
                       if(currPBELookup.isEmpty())
                           currPBELookup.put(acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c,acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c);
                       else if(!currPBELookup.containsKey(acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c))
                           currPBELookup.put(acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c,acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c);
                       
                       if(prodPBELookup.isEmpty())
                           prodPBELookup.put(acContractProd.Product__c,acContractProd.Product__c);
                       else if(!prodPBELookup.containsKey(acContractProd.Product__c))
                           prodPBELookup.put(acContractProd.Product__c,acContractProd.Product__c);
                       
                       if(prodCurrPBELookup.isEmpty())
                           prodCurrPBELookup.add(acContractProd.Product__c+'!'+acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c);
                       else if(!prodCurrPBELookup.contains(acContractProd.Product__c+'!'+acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c))
                           prodCurrPBELookup.add(acContractProd.Product__c+'!'+acContractProd.Renewal_Product__r.Renewal__r.Local_Currency__c);
                       
                       System.debug('DEBUG_RMOC: Processed ACP ' + acContractProd);
                       
                       
                   } // for
                
                // Not likely that we will not find a single PBE, but drop a message if it happens
                if(prodCurrPBELookup.isEmpty())
                    errorLog.put(Ids,'No active Pricebook Entries found for the products on the selected Renewals');
                
                
                
                // following code was commented out, as the mass generation page now calls 
                // a different method (Renewals_MassGenerateOpp_New) - lfc - 08Mar2012
                
                List<Opportunity> OppList = new List<Opportunity>();
                List<Renewal__c> RenList = new List<Renewal__c>();
                
                Set<id> acpIds = new Set<id>(); //samap01
                Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
                
                for(Active_Contract_Product__c acp:RenewalToACPMap.values()){
                    
                    //SAMAP01 -US370595 -DEC 6
                    acpIds.add(acp.Id); 
                    String BusinessType;
                    
                    
                    if(acp.Renewal_Product__r.Renewal__r.Segmentation__c == 'HT')
                        BusinessType = 'High Touch';
                    else if(acp.Renewal_Product__r.Renewal__r.Segmentation__c == 'MT')
                        BusinessType = 'Medium Touch';    
                    else if(acp.Renewal_Product__r.Renewal__r.Segmentation__c == 'LT')
                        BusinessType = 'Low Touch';    
                    else if(acp.Renewal_Product__r.Renewal__r.Segmentation__c == 'NT')
                        BusinessType = 'No Touch';    
                    else 
                        BusinessType = 'Unknown';    
                    
                    
                    //             System.debug('DEBUG_RMOC: Loading Opportunity structure');
                    
                    // FY13 - Set oppty close date to a date >= current date
                    Date expCloseDate;
                    if(acp.Renewal_Product__r.Renewal__r.Expected_Close_Date__c >= date.today())
                        expCloseDate = acp.Renewal_Product__r.Renewal__r.Expected_Close_Date__c;
                    else
                        expCloseDate = date.today();
                    
                    Opportunity opp = new Opportunity(name = acp.Renewal_Product__r.Renewal__r.name,
                                                      AccountId = acp.Renewal_Product__r.Renewal__r.Account__c,
                                                      CloseDate =expCloseDate,
                                                      Description = acp.Renewal_Product__r.Renewal__r.Overall_Comments__c,                                        
                                                      CurrencyIsoCode = acp.Renewal_Product__r.Renewal__r.Local_Currency__c,
                                                      Inside_Outside__c = 'Outside',
                                                      RecordTypeId = recId,                                             
                                                      StageName=Label.Opp_Stage_20_Percent, //US149780 by SAMTU01
                                                      
                                                      New_Deal_Term_months__c = acp.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c,
                                                      Stretch_Deal_Term_Months__c=acp.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c,
                                                      OwnerId = acp.Renewal_Product__r.Renewal__r.OwnerId,
                                                      Original_CV__c = acp.Renewal_Product__r.Renewal__r.OCV__c,
                                                      Site_ID__c = acp.Renewal_Product__r.Renewal__r.Sold_to_Ship_to_Party_Site_ID__c,
                                                      Type = 'Direct',
                                                      RPD_Status__c = 'Requested',
                                                      Renewal__c = acp.Renewal_Product__r.Renewal__c,
                                                      Business_Type__c = BusinessType,
                                                      Projected_Renewal__c = acp.Renewal_Product__r.Renewal__r.Projected_Renewal__c,
                                                      //likely flag set to true on opportunity
                                                      RoadmapToPlan__c=true, //US421493 - MERHA02
                                                      New_Site_Id__c = acp.Renewal_Product__r.Renewal__r.New_Site_Id__c
                                                      // FY13                                              ,Comfort__c = acp.Renewal_Product__r.Renewal__r.Projected_Renewal__c
                                                     );
                    
                    //AR 3051
                    If(acp.Renewal_Product__r.Renewal__r.Reason_duration_is_1_year__c!=null && acp.Renewal_Product__r.Renewal__r.Status_at_end_of_term__c!=null)
                    {
                        opp.Reason_duration_is_1_year__c = acp.Renewal_Product__r.Renewal__r.Reason_duration_is_1_year__c ;
                        opp.Status_at_end_of_term__c = acp.Renewal_Product__r.Renewal__r.Status_at_end_of_term__c ;
                        
                    }
                    //US311596 - Start/End Date on Opportunity - BAJPI01
                    if(acp.active_contract__r.header_dismantle_date__c!=null){
                        opp.start_date__c = acp.active_contract__r.header_dismantle_date__c.addDays(1);
                        opp.end_date__c = opp.start_date__c.addMonths(Integer.valueOf(acp.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c));
                        opp.end_date__c = opp.end_date__c.addDays(-1);
                    }
                    //US311596 - Start/End Date on Opportunity - BAJPI01
                    
                    
                    
                    
                    
                    Renewal__c ren = new Renewal__c(id= acp.Renewal_Product__r.Renewal__c,
                                                    Converted_To_Opportunity__c = True);                             
                    OppList.add(opp);
                    
                    oppInsert.put(acp.Renewal_Product__r.Renewal__c,opp);
                    renUpdate.put(acp.Renewal_Product__r.Renewal__c,ren);
                    
                    RenList.add(ren);                               
                }
                
                // Retrieve all PriceBook Entries for the selected Active Contract Products
                for(PricebookEntry pbe:
                    [Select Id, Name, Product2Id,product2.Commissionable_BU__c, CurrencyIsoCode
                     From PricebookEntry
                     //              where Product2Id =: actvCP.Product__c
                     //                and CurrencyIsoCode =:actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c
                     where Product2Id in :prodPBELookup.values()
                     and CurrencyIsoCode in :currPBELookup.values()
                     and Pricebook2.Name='CA Product List' 
                     and IsActive =:true 
                     //              limit 1
                    ]){
                        
                        prod2idCbuMap.put(pbe.Product2Id, pbe.Product2.Commissionable_BU__c);
                        
                        // If this PBE matches on product and currency, store it in the map
                        if(!prodCurrPBELookup.isEmpty())
                            if(prodCurrPBELookup.contains(pbe.Product2Id+'!'+pbe.CurrencyIsoCode))
                            if(prodCurrPBEItem.isEmpty())
                            prodCurrPBEItem.put(pbe.Product2Id+'!'+pbe.CurrencyIsoCode,pbe.Id);
                        else if(!prodCurrPBEItem.containsKey(pbe.Product2Id+'!'+pbe.CurrencyIsoCode))
                            prodCurrPBEItem.put(pbe.Product2Id+'!'+pbe.CurrencyIsoCode,pbe.Id);
                    } // for
                
                
                System.debug('DEBUG_RMOC: prodCurrPBEItem ' + prodCurrPBEItem);
                
                //FY13 Retrieve all Territories for all relevant Renewals
                for(Territory terr: [Select Id, Country__c // FY14 - was Territory_Country__c  
                                     from Territory 
                                     //FY14                        Where Territory_Country__c in : mapTerritoryToID.keySet()]){
                                     Where Country__c in : mapTerritoryToID.keySet()]){ //FY14
                                         //FY14      if(mapTerritoryToID.containsKey(terr.Territory_Country__c))
                                         //FY14          mapTerritoryToID.put(terr.Territory_Country__c, terr.Id);
                                         if(mapTerritoryToID.containsKey(terr.Country__c)) //FY14
                                             mapTerritoryToID.put(terr.Country__c, terr.Id); //FY14
                                     }
                System.debug('mapTerritoryToID$$$ '+mapTerritoryToID);  
                
                if(OppList.size()>0){
                    for(Opportunity insertOpp :OppList){
                        Renewal__c baseRen = RenewalMap.get(insertOpp.Renewal__c);
                        
                        //FY14         if(mapTerritoryToID.containsKey(baseRen.Territory_Country__c))
                        //FY14              insertOpp.TerritoryId = mapTerritoryToID.get(baseRen.Territory_Country__c);
                        if(mapTerritoryToID.containsKey(baseRen.Territory__c)) //FY14
                            insertOpp.TerritoryId = mapTerritoryToID.get(baseRen.Territory__c); //FY14
                        
                        
                    }
                    List<Opportunity> oppUpdate = new List<Opportunity>();
                    for(Opportunity insertOpp :OppList){
                        Renewal__c baseRen = RenewalMap.get(insertOpp.Renewal__c);
                        if(errorlog.containsKey(baseRen.Name) || errorlog.containsKey(baseRen.Id)) 
                        {                         
                            
                        }   
                        else
                            oppUpdate.add(insertOpp);                                    
                    }
                    
                    
                    try
                    {
                        if(oppUpdate.size() > 0)
                        {                                   
                            OppList.clear();
                            OppList = oppUpdate;
                            //insert OppList;
                        }
                    }
                    catch(System.DmlException e)
                    {
                        for (Integer index = 0; index < e.getNumDml(); index++)
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                    }
                    
                }   
                
                System.debug('OppList$$$'+OppList);  
                System.debug('RenList$$$'+RenList);  
                
                Map<String,String> OppMap = new Map<String,String>();
                
                
                List<CA_Product_Renewal__c> caProdRnwl = new List<CA_Product_Renewal__c>();
                List<OpportunityLineItem> RnwlOppLnItm = new List<OpportunityLineItem>();       
                List<Active_Contract_Product__c> actProdList = new List<Active_Contract_Product__c>();
                
                
                //        System.debug('DEBUG_RMOC: Processing ACPs for RCP & OP');
                
                for(Active_Contract_Product__c actvCP:ACPMap.values()){
                    
                    if(actvCP.Active_Contract__r.header_dismantle_date__c!=null){
                        oppstartdate = actvCP.Active_Contract__r.header_dismantle_date__c.addDays(1);
                        oppenddate = oppstartdate.addMonths(Integer.valueOf(actvCP.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c));
                        oppenddate = oppenddate.addDays(-1);
                    }
                    
                    if(oppstartdate!=null && oppenddate!=null)
                        durationdays = oppstartdate.daysBetween(oppenddate)+1;
                    
                    if(!prodCurrPBEItem.isEmpty()){
                        if(prodCurrPBEItem.containsKey(actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c)){
                            
                            Renewal__c Ren = productGroupMap.get(actvCP.Id);
                            String oppId = OppMap.get(Ren.Id);
                            
                            // Set ACP values for update after insert of Opportunity Product and Renewal Contract Product
                            actvCP.Converted_To_Opportunity__c=true;
                            actvCP.Opportunity__c = oppId;      
                            
                            // avoid issue where null value causes OpportunityLiItm.UnitPrice to default to 1.0
                            if(actvCP.Projected_Renewal_Calc__c != null)
                                actvCP.Sales_Price__c = actvCP.Projected_Renewal_Calc__c;
                            else
                                actvCP.Sales_Price__c = 0;
                            
                            // Construct Opportunity Product strings
                            String RenewalName= actvCP.Name;
                            String RenewalproductName= actvCP.Active_Contract__r.Name;
                            String segment;
                            Id pbeID;
                            
                            If(actvCP.Segmentation__c =='HT'||actvCP.Segmentation__c =='MT'||actvCP.Segmentation__c =='LT'||actvCP.Segmentation__c =='NT')
                                segment = actvCP.Segmentation__c;  
                            else 
                                segment = actvCP.Pre_Segmentation__c;
                            
                            if(RenewalName!=null && RenewalName.length()>30)
                                RenewalName = RenewalName.Substring(0,30);
                            
                            if(RenewalproductName !=null && RenewalproductName.length()>50)
                                RenewalproductName =RenewalproductName.Substring(0,50);
                            
                            // Set up Renewal Contract Product record
                            caProdRnwl.add(new CA_Product_Renewal__c(
                                name=RenewalproductName +'-'+RenewalName,
                                Active_Contract_Product__c=actvCP.Id,
                                Contract__c=actvCP.Active_Contract__c,
                                CAProductRenewal_Amount__c=actvCP.AOCV__c,
                                Renewal_Opportunity__c=oppId,
                                Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                ATTRF__c = actvCP.ATTRF_CRV__c,
                                Baseline_ATTRF__c = actvCP.Product_Baseline_ATTRF_LC__c,
                                trr__C = actvCP.AOCV__c, 
                                CurrencyIsoCode=actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c,
                                Projected_Renewal__c= actvCP.Sales_Price__c
                                // FY13                               ,Inside_Outside__c ='Outside'
                            ));  
                            
                            List<CA_Product_Renewal__c> lst = new List<CA_Product_Renewal__c>();
                            if(prodRenewalInsert.get(Ren.Id) != null && prodRenewalInsert.get(Ren.Id).size() > 0)
                            {
                                lst = prodRenewalInsert.get(Ren.Id);
                                lst.add(new CA_Product_Renewal__c(
                                    name=RenewalproductName +'-'+RenewalName,
                                    Active_Contract_Product__c=actvCP.Id,
                                    Contract__c=actvCP.Active_Contract__c,
                                    CAProductRenewal_Amount__c=actvCP.AOCV__c,
                                    Renewal_Opportunity__c=oppId,
                                    Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                    ATTRF__c = actvCP.ATTRF_CRV__c,
                                    Baseline_ATTRF__c = actvCP.Product_Baseline_ATTRF_LC__c,
                                    trr__C = actvCP.AOCV__c, 
                                    CurrencyIsoCode=actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c,
                                    Projected_Renewal__c= actvCP.Sales_Price__c
                                    // FY13                               ,Inside_Outside__c ='Outside'
                                )); 
                                prodRenewalInsert.put(Ren.Id,lst); 
                            }
                            
                            
                            
                            // Set up Opportunity Product record
                            OpportunityLineItem opplineitem = new OpportunityLineItem(
                                PricebookEntryId= prodCurrPBEItem.get(actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c),
                                CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                                Active_Contract_Product__c = actvCP.Id,
                                Active_Contract__c = actvCP.Active_Contract__c,
                                Opportunityid = oppId,
                                Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                ATTRF__c = actvCP.ATTRF_CRV__c,
                                Baseline_ATTRF_LC__c = actvCP.Product_Baseline_ATTRF_LC__c,     //baseline attrf
                                Old_TRR__c = actvCP.AOCV__c,
                                Stretch__c = actvCP.Sales_Price__c,
                                UnitPrice = actvCP.Sales_Price__c,// FY13,Comfort__c = actvCP.Sales_Price__c,
                                Business_Type__c = 'Renewal',                                                         
                                Segmentation__c = segment ,
                                Original_Expiration_Date__c = actvCP.Dismantle_Date__c,
                                Original_Deal_Term_Months__c = actvCP.Active_Contract__r.Contract_Term_Months__c,
                                New_Deal_Term_Months__c = actvCP.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c,
                                Original_CV__c = actvCP.OCV__c,
                                Original_Contract_IDs__c = actvCP.Active_Contract_Number__c 
                                // FY13,Inside_Outside__c='Outside'                                                             
                            );
                            if(oppstartdate!=null && oppenddate!=null){
                                opplineitem.start_date__c = oppstartdate;
                                opplineitem.End_Date__c = oppenddate;
                                opplineitem.Duration_Days__c = durationdays;
                               
                            }
                            RnwlOppLnItm.add(opplineitem);
                            
                            List<OpportunityLineItem> lstoppItem = new List<OpportunityLineItem>();                
                            if(opplineItemInsert.get(Ren.Id) != null && opplineItemInsert.get(Ren.Id).size() > 0)
                            {
                               
                                lstoppItem= opplineItemInsert.get(Ren.Id);
                                OpportunityLineItem oppline = new OpportunityLineItem(
                                    PricebookEntryId= prodCurrPBEItem.get(actvCP.Product__c+'!'+actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c),
                                    CA_Contract_Product_Name__c = RenewalproductName +'-'+RenewalName,
                                    Active_Contract_Product__c = actvCP.Id,
                                    Active_Contract__c = actvCP.Active_Contract__c,
                                    Opportunityid = oppId,
                                    Raw_Maintenance__c = actvCP.Raw_Maint_Calc_LC__c,
                                    ATTRF__c = actvCP.ATTRF_CRV__c,
                                    Baseline_ATTRF_LC__c = actvCP.Product_Baseline_ATTRF_LC__c,     //baseline attrf
                                    Old_TRR__c = actvCP.AOCV__c,
                                    Stretch__c = actvCP.Sales_Price__c,
                                    UnitPrice = actvCP.Sales_Price__c,// FY13,Comfort__c = actvCP.Sales_Price__c,
                                    Business_Type__c = 'Renewal',                                                         
                                    Segmentation__c = segment ,
                                    Original_Expiration_Date__c = actvCP.Dismantle_Date__c,
                                    Original_Deal_Term_Months__c = actvCP.Active_Contract__r.Contract_Term_Months__c,
                                    New_Deal_Term_Months__c = actvCP.Renewal_Product__r.Renewal__r.Projected_Time_Duration_Months__c,
                                    Original_CV__c = actvCP.OCV__c,
                                    Original_Contract_IDs__c = actvCP.Active_Contract_Number__c// FY13,Inside_Outside__c='Outside'                                                             
                                );
                                //US311596 - Start/End Date on Opportunity - BAJPI01
                                if(oppstartdate!=null && oppenddate!=null){
                                    oppline.start_date__c = oppstartdate;
                                    oppline.End_Date__c = oppenddate;
                                    oppline.Duration_Days__c = durationdays;
                                    
                                }
                                //US311596 - Start/End Date on Opportunity - BAJPI01
                                lstoppItem.add(oppline);
                                opplineItemInsert.put(Ren.Id,lstoppItem); 
                            }
                            
                            
                            actProdList.add(actvCP);                                    
                        }
                        
                        else // No PBE found for this product/currency combination
                            errorLog.put(actvCP.Renewal_Product__r.Renewal__c,'Pricebook Entry is not active for selected Renewal ' + actvCP.Renewal_Product__r.Renewal__c + 
                                         ', Currency ' + actvCP.Renewal_Product__r.Renewal__r.Local_Currency__c + 
                                         ', Product ' + actvCP.Product__c);    
                    }
                    else // Not likely that we will not find a single PBE, but drop a message if it happens
                        errorLog.put(actvCP.Renewal_Product__r.Renewal__c,'No active Pricebook Entries found for the products on the selected Renewals');
                    
                    //        } // for PricebookEntry
                } 
                
                
                
                for(Renewal__c updRen : RenList)
                {               
                    try
                    {
                        insert oppInsert.get(updRen.id);
                        update renUpdate.get(updRen.id);
                        insert prodRenewalInsert.get(updRen.id);
                        insert opplineItemInsert.get(updRen.id);
                        update ActContractUpdate.get(updRen.id);
                    }
                    catch(System.DmlException e){
                        for (Integer index = 0; index < e.getNumDml(); index++){
                            errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                        }                                          
                    }                        
                }
                
                return '' ; //return errorLog;
            }
            catch(System.DmlException e){
                for (Integer index = 0; index < e.getNumDml(); index++){
                    errorLog.put(String.valueOf(e.getDmlId(index)),e.getDmlMessage(index));
                }
                return '' ; //return       errorLog;
            }
            catch(Exception e) {
                errorLog.put('',e.getMessage());
                //return 'Exception '+e;
                return '' ; // return errorlog;
            } 
            
        }
}