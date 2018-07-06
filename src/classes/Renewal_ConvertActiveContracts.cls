public class Renewal_ConvertActiveContracts {
    public static boolean fromClass{get;set;}
    public Transient Boolean ShowDataMessage {get;set;}
    public Transient Boolean ShowErrorMessage {get;set;}
    public Transient String catagoryname{get;set;}
    public Transient Boolean condition1;
    public static boolean isBatch = false;
    public static boolean isTest = false;
    public Transient String Ids; 
    public List<String> selectedIds = new List<String>();
    public Transient String Regions = 'Asia-Pacific,EMEA,Japan,LA,NA,WW,PS/CAN'; //sunji03 FY19, PS/CAN GEO is added
    public List<String> selectedRegionValues = new List<String>();
    Public Map<string, renewal_product__c> mapProductsRenewals = new Map<string, renewal_product__c>();
    List<Renewal__c> RenewalsList = new List<Renewal__c>();
    List<Renewal_Owner_Rules__c>  lstOwnerID = new  List<Renewal_Owner_Rules__c>();
    Map<String,String> OwnerMap = new Map<String,String>();
    Map<String,String> MTOwnerMap = new Map<String,String>();
    Map<String,String> ProdOwnerMap = new Map<String,String>();
    Map<String,Id> OwnerRuleMap = new Map<String,Id>();
    Map<Id,String> UserMap = new Map<Id,String>();
    List<Renewal_Owner_Account_Mapping__c>  lstAccOwnerID = new  List<Renewal_Owner_Account_Mapping__c>(); //Rao Account Mapping rules 
    Transient Map<String,Id> AccUserMap = new Map<String,Id>();  //FY15
     Map<Id,String> AccNameMap = new Map<Id,String>();  //FY15
    Map<String,Renewal__c> genRenewalMap = new Map<String,Renewal__c>();
    public List<Renewal__c> generatedRenewals = new List<Renewal__c> ();
    Set<string> errors = new set<string>();
    public  String sAccSegment='';
    public static  boolean isAmpFound = false; // Account Mapping Rules identifier 
  
    // Map for storing Chatter post information to be posted against generated renewals
    Map<String,FeedItem> renewalChatterPostMap = new Map<String,FeedItem>();
   Transient FeedItem renChatterPost;
    List<FeedItem> renChatterPost1 = new List<FeedItem>();

    public Set<String> getErrors (){
         return errors;   
    }
    public List<Renewal__c> getGeneratedRenewals(){
         return generatedRenewals;   
    }
    
    public Renewal_ConvertActiveContracts()
    {
        fromClass = true;
        Ids =ApexPages.currentPage().getParameters().get('records');
        if(Ids!=null)
            selectedIds = Ids.split(',');
    }
    
    public pagereference Proceed(){
        PageReference pageRef = new PageReference('/'+System.Label.Renewals_Tab);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void Renewal_ConvertActiveContractsMethod(){
        Transient Date dt1;
        Transient Date dt2;
         String error = Renewal_ConvertActiveContractsMain('listView',dt1,dt2,'');         


        if(error.contains('No Error'))
        {
            if(errors.size()>0)
                ShowErrorMessage = true;
            ShowDataMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Renewals have been generated Successfully. Please find the details below.'));
        }
        else if(error.contains('No Data'))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no eligible contract products for the data that you selected. No renewals generated.'));
        else if(error.contains('Exception'))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error(s) encountered during renewals generation. Please contact System Administrator for details.'));
        else if(error.contains('Error'))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error(s) encountered during renewals generation. Please check the segmentation of the Active Contract Product.'));
    } 
    
    public String Renewal_ConvertActiveContractsMain(
    String methodCalledFrom, Date startDate, Date endDate,String RegionValue){
    //    try{
                 
         // Rules with a Pre-Segmentation reference
         Map<String,List<Contracts_Grouping_Rules__c>> preSegGroupRulesMap = new Map<String,List<Contracts_Grouping_Rules__c>>();

         // Rules with a Sales Document Type reference
         Map<String,List<Contracts_Grouping_Rules__c>> salesDocTypeGroupRulesMap = new Map<String,List<Contracts_Grouping_Rules__c>>();

         // Rules with an Acquisition Product Group reference
         Map<String,List<Contracts_Grouping_Rules__c>> acqProductGroupRulesMap = new Map<String,List<Contracts_Grouping_Rules__c>>();

         // Rules with an Product BU Exclusion reference
         Map<String,List<Contracts_Grouping_Rules__c>> prodBUExclusionRulesMap = new Map<String,List<Contracts_Grouping_Rules__c>>();

         // Rules with a geographic reference get a list, since they are concatenations of different regions
         List<Contracts_Grouping_Rules__c> regionBasedRulesList = new List<Contracts_Grouping_Rules__c>();

         List<Contracts_Grouping_Rules__c> rulesList = new List<Contracts_Grouping_Rules__c>();

         // Separate mapping functions for renewal contracts and renewal products
         Map<Id,String> ACPRenewalMap = new Map<Id,String> ();
         Map<String,List<Active_Contract_Product__c>> RenewalContractMap = new Map<String,List<Active_Contract_Product__c>>();
         Map<String,Double> RenewalOcvUSDMap = new Map<String,Double>();
         
         Set<String> BusinessUnitList = new Set<String>();
         String strBusinessUnit='';

         /* Fetch all rules and add to seperate map */
                              
         for(Contracts_Grouping_Rules__c contractGrpRules :[Select c.SFDC_Product__c, c.Renewal_Segmentation__c, c.Product_Segmentation__c, 
                                                            c.Region__c, c.Product_Segmentation1__c, c.Product_Business_Unit__c, c.Rule_Type__c,
                                                            c.OCV_Lessthan__c, c.OCV_Greaterthan__c, c.Name, c.Exclude_Product__c, 
                                                            c.Area__c,c.Sales_Document_Type__c,c.Order_Of_Precedence__c From Contracts_Grouping_Rules__c c 
                                                            order by c.Order_Of_Precedence__c]){

                if(contractGrpRules.Rule_Type__c == 'ACQ'){
                    // Populate acqProductGroupRulesMap with all acquisition product-based rules                
                    if( acqProductGroupRulesMap.containsKey(contractGrpRules.SFDC_Product__c.toUpperCase())){
                        acqProductGroupRulesMap.get(contractGrpRules.SFDC_Product__c.toUpperCase()).add(contractGrpRules);
                    }else{
                        List<Contracts_Grouping_Rules__c> cg = new List<Contracts_Grouping_Rules__c>();
                        cg.add(contractGrpRules);
                        acqProductGroupRulesMap.put(contractGrpRules.SFDC_Product__c.toUpperCase(),cg);
                    }
                }
                else if(contractGrpRules.Rule_Type__c == 'SDT'){
                    // Populate salesDocTypeGroupRulesMap with all sales doc type-based rules                
                    if(salesDocTypeGroupRulesMap.containsKey(contractGrpRules.Sales_Document_Type__c.toUpperCase())){
                        salesDocTypeGroupRulesMap.get(contractGrpRules.Sales_Document_Type__c.toUpperCase()).add(contractGrpRules);
                    }else{
                        List<Contracts_Grouping_Rules__c> cg = new List<Contracts_Grouping_Rules__c>();
                        cg.add(contractGrpRules);
                        salesDocTypeGroupRulesMap.put(contractGrpRules.Sales_Document_Type__c.toUpperCase(),cg);
                    }
                }
                else if(contractGrpRules.Rule_Type__c == 'PRE'){
                    // Populate preSegGroupRulesMap with all pre-segmentation-based rules                
                    if(preSegGroupRulesMap.containsKey(contractGrpRules.Product_Segmentation1__c.toUpperCase())){
                        preSegGroupRulesMap.get(contractGrpRules.Product_Segmentation1__c.toUpperCase()).add(contractGrpRules);
                    }else{
                        List<Contracts_Grouping_Rules__c> cg = new List<Contracts_Grouping_Rules__c>();
                        cg.add(contractGrpRules);
                        preSegGroupRulesMap.put(contractGrpRules.Product_Segmentation1__c.toUpperCase(),cg);
                    }
                }   
                else if(contractGrpRules.Rule_Type__c == 'PEX'){   
                
                 if(prodBUExclusionRulesMap !=Null && prodBUExclusionRulesMap.size()>0)
                    {
                             
                    if(prodBUExclusionRulesMap.containsKey(contractGrpRules.Product_Business_Unit__c.toUpperCase())){
                        prodBUExclusionRulesMap.get(contractGrpRules.Product_Business_Unit__c.toUpperCase()).add(contractGrpRules);
                    }else{
                        List<Contracts_Grouping_Rules__c> cg = new List<Contracts_Grouping_Rules__c>();
                        cg.add(contractGrpRules);
                        if(contractGrpRules.region__c!= null)
                           prodBUExclusionRulesMap.put(contractGrpRules.Product_Business_Unit__c.toUpperCase(),cg);
                  } 
                }  
                }              
//                else if(contractGrpRules.Rule_Type__c == 'GEO')
                else // Geo-based rules + catchall
                    regionBasedRulesList.add(contractGrpRules);
                                                        
         } // end of contract grouping rules load 

        // if(acqProductGroupRulesMap.size()>0)   system.debug('--------acqProductGroupRulesMap-------'+acqProductGroupRulesMap);
        // if(salesDocTypeGroupRulesMap.size()>0) system.debug('--------salesDocTypeGroupRulesMap-------'+salesDocTypeGroupRulesMap);
        // if(preSegGroupRulesMap.size()>0)       system.debug('--------preSegGroupRulesMap-------'+preSegGroupRulesMap);
        // if(prodBUExclusionRulesMap.size()>0)   system.debug('--------prodBUExclusionRulesMap-------'+prodBUExclusionRulesMap);
        // if(regionBasedRulesList.size()>0)      system.debug('--------regionBasedRulesList-------'+regionBasedRulesList);
        
         //Added for Renewal Owner Assignment and Sharing Rules 6.05
         set<String> strRegion = new set<String>();
         set<String> strArea = new set<String>();
         set<String> strTerritory = new set<String>();
         set<String> strCountry = new set<String>();
         set<String> strStates = new set<String>();
         set<String> strSegment = new set<String>();

         //List<SFDC_Products__c> sfdcProds = SFDC_Products__c.getall().values();
         //system.debug('--------sfdcProds-------'+`);

         // Populate newacpList with all active contract products for selected contracts
         List<Active_Contract_Product__c> actProdList = new List<Active_Contract_Product__c>();
         List<Active_Contract_Product__c> newacplist; 
         system.debug('*********Ids*********'+selectedIds);

         if (methodCalledFrom=='TimeFrame')
         {
         isBatch = true;

         // Set up selectedRegionValues to limit ACP select when called from Generate Renewals page
         if (RegionValue != 'ALL' && RegionValue != '-None-')
            selectedRegionValues.add(RegionValue);
         else
            selectedRegionValues = Regions.split(',');
            
         system.debug('*********Ids*********'+selectedIds);
         integer limitgiven = 15000;
         if(isTest )
             limitgiven = 10;
       
             newacplist =  [Select a.Segmentation__c, a.Pre_Segmentation__c, a.Name, a.Dismantle_Date__c, a.OCV__c, a.Calculated_OCV_USD__c, 
                         a.AOCV__c, a.Raw_Maint_Calc_LC__c, a.ATTRF_CRV__c, a.ATTRF_CRV_USD__c, a.Currency__c, a.Product_Baseline_ATTRF_LC__c,a.Product_Baseline_ATTRF_USD__c,
                         a.Revenue_Per_Day__c,a.Current_Ann_Existing_Maintenance_LC__c,a.Renewal_Product__c,
                         //US500913 - PORAS01 - Adding Expiring ARR (LC) fields
                         a.ExpiringARRLC__c, //US500913 - PORAS01 - end
                         a.Product__c, a.Product__r.id, a.Product__r.name, a.product__r.Market_Focus_Area__c, a.product__r.Product_Group__c, 
                         a.Active_Contract__c, a.Active_Contract__r.OwnerId, a.Active_Contract__r.name,
                         a.Active_Contract__r.Sales_Document_Type_Text__c, a.Active_Contract__r.account__c, a.Active_Contract__r.account__r.name, 
                         a.Active_Contract__r.Account__r.BillingState,  a.Active_Contract__r.Account__r.Segment__c  ,  a.Active_Contract__r.Account__r.Region_Country__c,
                         a.Active_Contract__r.Territory_Country__c, a.Active_Contract__r.Region__c, a.Active_Contract__r.Area__c,
                         a.Active_Contract__r.Renewal_Currency__c, a.Active_Contract__r.Renewal_Currency__r.Name,
                         a.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode,instance_id__c,
                         (Select Installation_Date__c From Active_Contract_Line_Items__r 
                          where  Installation_Date__c != null order by Installation_Date__c ) 
                          From Active_Contract_Product__c a 
                          where a.Dismantle_Date__c  >=: startDate 
                            and a.Dismantle_Date__c <=: endDate
                            and a.Renewal_Product__c = null 
                            and a.Segmentation__c != 'Invalid'
                            and a.Pre_Segmentation__c != 'Term ended renewed'
                            and a.Active_Contract__r.Region__c =:selectedRegionValues
                          limit :limitgiven];
                          //And a.Active_Contract__c =:selectedIds  limit 9999];                      
         
         }else
         {                                   
                newacplist =                  [Select a.Segmentation__c, a.Pre_Segmentation__c, a.Name, a.Dismantle_Date__c, a.OCV__c, a.Calculated_OCV_USD__c, 
                         a.AOCV__c, a.Raw_Maint_Calc_LC__c, a.ATTRF_CRV__c, a.ATTRF_CRV_USD__c, a.Currency__c,a.Product_Baseline_ATTRF_LC__c,a.Product_Baseline_ATTRF_USD__c, 
                         a.Revenue_Per_Day__c,a.Current_Ann_Existing_Maintenance_LC__c,a.Renewal_Product__c,
                         //US500913 - PORAS01 - Adding Expiring ARR (LC) fields
                         a.ExpiringARRLC__c, //US500913 - PORAS01 - end
                         a.Product__c, a.Product__r.id, a.Product__r.name, a.product__r.Market_Focus_Area__c, a.product__r.Product_Group__c, 
                         a.Active_Contract__c, a.Active_Contract__r.OwnerId, a.Active_Contract__r.name,
                         a.Active_Contract__r.Sales_Document_Type_Text__c, a.Active_Contract__r.account__c, a.Active_Contract__r.account__r.name, 
                         a.Active_Contract__r.Account__r.BillingState,  a.Active_Contract__r.Account__r.Segment__c  , a.Active_Contract__r.Account__r.Region_Country__c,
                         a.Active_Contract__r.Territory_Country__c, a.Active_Contract__r.Region__c, a.Active_Contract__r.Area__c,
                         a.Active_Contract__r.Renewal_Currency__c, a.Active_Contract__r.Renewal_Currency__r.Name,
                         a.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode,instance_id__c,  
                         (Select Installation_Date__c From Active_Contract_Line_Items__r 
                          where  Installation_Date__c != null order by Installation_Date__c ) 
                          From Active_Contract_Product__c a where a.Active_Contract__c =:selectedIds limit 15000];                      
                          //and a.Dismantle_Date__c >= THIS_FISCAL_YEAR and a.Dismantle_Date__c <= NEXT_FISCAL_YEAR
          }
  
if(newacplist.size()> 0){              
  for(Active_Contract_Product__c acContractProd:newacplist ){ 

    // Cleanse key fields in case the data is dirty (sometimes happens with TOPS data) 2011-11-07
    if(acContractProd.product__r.Product_Group__c == null)
       acContractProd.product__r.Product_Group__c = '';
    if(acContractProd.Active_Contract__r.Sales_Document_Type_Text__c == null)
       acContractProd.Active_Contract__r.Sales_Document_Type_Text__c = '';
    if(acContractProd.Pre_Segmentation__c == null)
       acContractProd.Pre_Segmentation__c = '';

    if(acContractProd.Renewal_Product__c == null){   
     if(acContractProd.Segmentation__c <> 'Invalid'){ 
        if(acContractProd.Pre_Segmentation__c <> 'Term ended renewed'){
           if(!acContractProd.Active_Contract_Line_Items__r.isEmpty()){
            // System.Debug('acContractProd.Active_Contract_Line_Items__r: '+acContractProd.Active_Contract_Line_Items__r) ;


             if(!prodBUExclusionRulesMap.containsKey(acContractProd.product__r.Market_Focus_Area__c.toUpperCase())){

                   // FY13 - If the territory is not specified, do not allow renewal generation
                   if(acContractProd.Active_Contract__r.Territory_Country__c <> '' && 
                      acContractProd.Active_Contract__r.Territory_Country__c != null){

// Take into account the Region picklist if called from mass generation screen
// This logic is now in the 'methodCalledFrom == 'TimeFrame'' select stmt - commented out
//                   if(methodCalledFrom == 'listView' ||
//                      (methodCalledFrom == 'TimeFrame' && selectedRegionValues.contains(acContractProd.Active_Contract__r.Region__c))){                                                         
                       actProdList.add(acContractProd);
//                         }     

                       //for 6.05 - picking up the current Region, Area, Country, Territory, State, and Segmentation
                       if(acContractProd.Active_Contract__r.Region__c <> '' && acContractProd.Active_Contract__r.Region__c != null)
                          strRegion.Add(acContractProd.Active_Contract__r.Region__c) ;
                       if(acContractProd.Active_Contract__r.Area__c <> '' && acContractProd.Active_Contract__r.Area__c != null)
                          strArea.Add(acContractProd.Active_Contract__r.Area__c) ;
                       if(acContractProd.Active_Contract__r.Territory_Country__c <> '' && acContractProd.Active_Contract__r.Territory_Country__c != null)
                          strTerritory.Add(acContractProd.Active_Contract__r.Territory_Country__c) ;
                       if(acContractProd.Active_Contract__r.Account__r.Region_Country__c <> '' && acContractProd.Active_Contract__r.Account__r.Region_Country__c != null)
                          strCountry.Add(acContractProd.Active_Contract__r.Account__r.Region_Country__c) ;
                       if(acContractProd.Active_Contract__r.Account__r.BillingState <> '' && acContractProd.Active_Contract__r.Account__r.BillingState != null)
                          strStates.Add(acContractProd.Active_Contract__r.Account__r.BillingState) ;
                       if(acContractProd.Pre_Segmentation__c <> '' && acContractProd.Pre_Segmentation__c != null)
                          strSegment.Add(acContractProd.Pre_Segmentation__c) ;    

                    }else{ //place to show error msg for bad territory
                         if(!isBatch)    
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The territory for this Active Contract is not specified.(' + acContractProd.Active_Contract__r.name + ')')); 
             
                         }
                }else{ //place to show error msg for excluded product
                     if(!isBatch)    
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The business unit for this contract product is excluded.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
                     }
            }else{ //place to show error msg for no contract line items
               if(!isBatch)    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product has no line items.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
                 }
        }else{ //place to show error msg for Term ended renewed case
            if(!isBatch)    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product is already renewed.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
             }
     }else{ //place to show error msg for segmentation invalid case 
         if(!isBatch)    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Renewals will not be generated for Invalid contract products.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
          }
            
   }else{ //place to show error msg for Renewal_Product__c is not equal to null
        if(!isBatch)    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product is already attached to a renewal.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
        } 
  } // end for(Active_Contract_Product__c acContractProd:newacplist)
} // end if(newacplist.size()> 0)

 
       if(actProdList.size() ==0){
           System.Debug('To_Test_Region'+ strRegion+'Area' + strArea+ 'Territory'+strTerritory + 'Country'+ strCountry + 'States'+ strStates + 'Segmentation' + strSegment) ;
           return 'No Data';         
           }
            
       if(actProdList.size()>2000){
          if(!isBatch)    
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Batch mode is required because there are more than 2,000 contract products to process. Please select fewer contracts or use mass renewal generation.')); 
          else {
             System.Debug('Calling batch due ++++++++') ;
             Renewal_BatchGenerateRenewals bt = new Renewal_BatchGenerateRenewals(startDate,endDate,RegionValue,false);
             System.Debug('Calling batch due to actProdList.size() = '+actProdList.size()) ;
             ID batchprocessid = Database.executeBatch(bt,100);
             System.Debug('Calling end--------- ') ;
//           isBatch = true;
             return 'BatchCalled';
             }
          }

// ********** Load Renewal Owner Rules **********
// Load all records into either the MT list, or the non-MT list
     lstOwnerID = [Select Name, user__c, user__r.Name, user__r.IsActive, Region__c , Area__c, Territory__c,Product__c, Product_ids__c,
                     Country__c,Segmentation__c,States__c , Use_Renewal_Owner_Account_Mapping1__c , Account_Segment__c 
                     from  Renewal_Owner_Rules__c
                     where (Territory__c in : strTerritory)
                     order by country__c, Product__c]; 
        
        lstAccOwnerID = [select id, Account__r.Name,  Renewal_Owner__r.IsActive ,  Segmentation__c ,category__c, Renewal_Owner__c from Renewal_Owner_Account_Mapping__c where  Renewal_Owner__c != null Limit 4000];      
        // Renewal Owner Account Rules 
                  for ( Renewal_Owner_Account_Mapping__c OAM :lstAccOwnerID ) {
                    system.debug(OAM.Account__r.Name+' inside '+OAM.category__c+' inisisisi '+OAM.Renewal_Owner__c);
                if(OAM.Account__r.Name != null && OAM.Segmentation__c != null && OAM.category__c != null && OAM.Renewal_Owner__r.IsActive)
                //AccUserMap.put(OAM.Account__r.Name+'-'+OAM.Segmentation__c, OAM.Renewal_Owner__c  );
                catagoryname = OAM.category__c;
                AccUserMap.put(OAM.Account__r.Name+' '+OAM.category__c, OAM.Renewal_Owner__c);
                AccNameMap.put(OAM.Renewal_Owner__c, OAM.Account__r.Name+'-'+OAM.category__c+'-'+OAM.Segmentation__c);  
                if(OAM.category__c == null){
                    AccUserMap.put(OAM.Account__r.Name, OAM.Renewal_Owner__c);

                  //  AccNameMap.put(OAM.Renewal_Owner__c, OAM.Account__r.Name+'-'+OAM.category__c+'-'+OAM.Segmentation__c);  
                    AccNameMap.put(OAM.Renewal_Owner__c, OAM.Account__r.Name+'-'+OAM.Segmentation__c);  
                }/*else{
                   AccNameMap.put(OAM.Renewal_Owner__c, OAM.Account__r.Name+'-'+OAM.category__c+'-'+OAM.Segmentation__c);  
                }*/
                          
            }
        Map<String,Renewal_Owner_Rules__c> AccRuleMap = new Map<String,Renewal_Owner_Rules__c>();
        Boolean productFound =  false;
        //Integer i=0;
        Integer MTMapCount=0, ProdMapCount=0;

       System.Debug('lstOwnerID -- ' +  lstOwnerID);
    
// Correct values that were not specified
       for(Renewal_Owner_Rules__c Owner: lstOwnerID){                 
           if(Owner.Country__c == null)
              Owner.Country__c ='';
           if(Owner.States__c == null) 
              Owner.States__c ='';
            
            if ( ( Owner.User__c == null ) && owner.Use_Renewal_Owner_Account_Mapping1__c == true)
                AccRuleMap.put(owner.name, Owner);

           if(Owner.User__r.IsActive){
                                       
                if(Owner.User__c != null){
// Populate map to decode Rule Number to User Id|User Name
                   OwnerRuleMap.put(Owner.Name, Owner.user__c);
                   if(!UserMap.containsKey(Owner.user__c))
                       UserMap.put(Owner.user__c, Owner.user__r.Name);
               }

// For LT or HT, map [Territory]-[Segmentation]-[Country]-[States]
               if(Owner.Segmentation__c != 'MT'){
                   OwnerMap.put(Owner.Territory__c+'-'+Owner.Segmentation__c+'-'+Owner.Country__c+'-'+Owner.States__c,Owner.Name);                                                  
                   }
                   
// For MT with products, map [Territory]-[Segmentation]-[Country]-[States]-[progressive], [Product IDs]|[User]
               else if(Owner.Product_ids__c != null){                                                                                            
                   ProdOwnerMap.put(Owner.Territory__c+'-'+Owner.Segmentation__c+'-' + Owner.Country__c+'-' +
                                    Owner.States__c + '-'+ ProdMapCount,Owner.Product_ids__c + '|' +Owner.Name);
                   ProdMapCount++;
                   } 



// For MT w/out products, map [Territory]-[Segmentation]-[Country]-[States]-[progressive], [User]
               else if(Owner.Product_ids__c == null ){
                            if (Owner.Account_Segment__c != null &&  owner.Use_Renewal_Owner_Account_Mapping1__c != true){   // FY15
                                 MTOwnerMap.put(Owner.Territory__c+'-'+Owner.Segmentation__c+'-'+ MTMapCount +'-'+Owner.Account_Segment__c , Owner.Name);
                            } else{
                             MTOwnerMap.put(Owner.Territory__c+'-'+Owner.Segmentation__c+'-'+Owner.Country__c+'-'+
                                  Owner.States__c+ '-' + MTMapCount , Owner.Name);
                            }
                                                           
                   MTMapCount++;
                   } 
              } 

            
                                          
           else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'User '+Owner.User__r.Name+' in not active. Renewal owner rule '+Owner.Name+' ignored.')); 
           }

         system.debug('HT/LT OwnerMap --- >'+OwnerMap);
         system.debug('ProdOwnerMap --- > ' + ProdOwnerMap);
         system.debug('MTOwnerMap --- > ' + MTOwnerMap);
         system.debug('AccRuleMap --- > ' + AccRuleMap);
          

         Map<String,String> RenewalAccountMap = new Map<String,String>();
         Map<String,String> RenewalAreaMap = new Map<String,String>();
         Map<String,String> RenewalCountryMap = new Map<String,String>();
         Map<String,String> RenewalRegionMap = new Map<String,String>();
         Map<String,String> RenewalStateMap = new Map<String,String>();
         Map<String,String> RenewalTerritoryMap = new Map<String,String>();
         Map<String,String> RenewalProductMap = new Map<String,String>();
         Map<String,String> RenewalSDTypeMap = new Map<String,String>();
         Map<String,Date> RenewalInstallationDateMap = new Map<String,Date>();
         Map<String,String> RenewalGrpValueMap = new Map<String,String>();
         Map<String,String> RenewalCGRuleTypeMap = new Map<String,String>();
          Map<String,String> RenewalAccSegMap = new Map<String,String>();  // FY15
         
/* The following code will define a renewal shell in the Map genRenewalMap
** for each unique occurrence of: 
**      1) [Account]+[Territory]+[Currency]+[DismantleDate]+[RenewalGroupName]
**          Used for the Acquisition Product and Sales Doc Type CGRs
**      2) [Account]+[Territory]+[Currency]+[DismantleDate]+[RenewalSegmentation]
**          Used for the Pre-Segmentation CGRs
**      3) [Account]+[Territory]+[Currency]+[DismantleDate]
**          Used for any other CGRs
**
** The codes above are the keys that are used to refer to the Map genRenewalMap.
** If the renewal shell already exists in genRenewalMap, the existing entry will be updated.
*/

         for(Active_Contract_Product__c act : actProdList){ // ends line 491
// Take care of preliminaries for this Active Contract Product

             Date dtInstallationDate;
             String renewalKeyValue;
             String renewalGrpValue;
             String renewalCGRuleType;
             Renewal__c ren;

             // minimum installation date among contract line items from original query
                 for(Active_Contract_Line_Item__c acl : act.Active_Contract_Line_Items__r){
                     dtInstallationDate = acl.Installation_Date__c;
                     break;
                     }   

// Determine Renewal Key Value for this Active Contract Product

system.debug('PRE: '+act.Pre_Segmentation__c.toUpperCase()+' lookup '+preSegGroupRulesMap.get(act.Pre_Segmentation__c.toUpperCase()));
system.debug('SDT: '+act.Active_Contract__r.Sales_Document_Type_Text__c.toUpperCase()+' lookup '+salesDocTypeGroupRulesMap.get(act.Active_Contract__r.Sales_Document_Type_Text__c.toUpperCase()));
system.debug('ACQ: '+act.product__r.Product_Group__c.toUpperCase()+' lookup '+acqProductGroupRulesMap.get(act.product__r.Product_Group__c.toUpperCase()));

             // Order of rule checking must match rule order, changed to PRE, SDT, ACQ - 20111108
             // Set Renewal Group Value to Product Segmentation if this Active Contract Product matches a PRE rule
             // For pre-segmentation, we must match on the region/area, as not all regions have this rule
             if(preSegGroupRulesMap.size() > 0 && preSegGroupRulesMap.containsKey(act.Pre_Segmentation__c.toUpperCase())){
                List<Contracts_Grouping_Rules__c> psgList = preSegGroupRulesMap.get(act.Pre_Segmentation__c.toUpperCase());
                for(Contracts_Grouping_Rules__c cg :psgList){
                    if((cg.Region__c == null || cg.Region__c.contains(act.Active_Contract__r.Region__c.toUpperCase())) &&
                       (cg.Area__c == null || cg.Area__c.contains(act.Active_Contract__r.Area__c.toUpperCase()) ||  cg.Area__c == '-')){
                        renewalGrpValue = cg.Product_Segmentation1__c;
                        renewalCGRuleType = cg.Rule_Type__c;
                        break;
                        }   
                    }   
                }
             // Set Renewal Group Value to Renewal Group Name if this Active Contract Product matches a ACQ rule
             // It is sufficient to match on the product, as these require separate renewals in all geos
             else if(acqProductGroupRulesMap.size() > 0 && acqProductGroupRulesMap.containsKey(act.product__r.Product_Group__c.toUpperCase())){
                List<Contracts_Grouping_Rules__c> pgrList = acqProductGroupRulesMap.get(act.product__r.Product_Group__c.toUpperCase());
                for(Contracts_Grouping_Rules__c cg :pgrList){
                    renewalGrpValue = cg.Product_Segmentation__c;
                    renewalCGRuleType = cg.Rule_Type__c;
                    break;
                    } 
                }
              // Set Renewal Group Value to Renewal Group Name if this Active Contract Product matches a SDT rule
             // It is sufficient to match on the sales documenmt type, as these require separate renewals in all geos
             else if(salesDocTypeGroupRulesMap.size() > 0 && salesDocTypeGroupRulesMap.containsKey(act.Active_Contract__r.Sales_Document_Type_Text__c.toUpperCase())){
                List<Contracts_Grouping_Rules__c> sdtList = salesDocTypeGroupRulesMap.get(act.Active_Contract__r.Sales_Document_Type_Text__c.toUpperCase());
                for(Contracts_Grouping_Rules__c cg :sdtList){
                    renewalGrpValue = cg.Product_Segmentation__c;
                    renewalCGRuleType = cg.Rule_Type__c;
                    break;
                    }
                }
             // Otherwise set Renewal Group Value and Rule Type to empty
             else {
                  renewalGrpValue = '';
                  renewalCGRuleType = '';
                  }

            //FY13- Added Territory to the Key Field
             // Renewal Key Value is [Account]+[Territory]+[CurrencyIsoCode]+[DismantleDate]+[RenewalGroupValue defined above] 20111107

                  if(act.instance_id__c!= null)
                  
             renewalKeyValue = act.Active_Contract__r.account__c+'|'+act.Active_Contract__r.Territory_Country__c + '|' + act.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode+'|'+act.Dismantle_Date__c+'|'+ act.instance_id__c + '|'+ renewalGrpValue;
             
             
             else

             renewalKeyValue = act.Active_Contract__r.account__c+'|'+act.Active_Contract__r.Territory_Country__c + '|' + act.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode+'|'+act.Dismantle_Date__c+ '|'+ renewalGrpValue;
             
             // Check Renewal Key Value to determine if we instantiate or update a renewal object
             if(genRenewalMap.containskey(renewalKeyValue)){

                System.debug('Updating renewalKeyValue= '+renewalKeyValue+' renewalCGRuleType= '+renewalCGRuleType);

                // Update existing renewal shell
                ren = genRenewalMap.get(renewalKeyValue); 
                ren.Annual_OCV_LC__c += act.AOCV__c;
                ren.OCV__c += act.OCV__c;
                ren.ATTRF_CRV__c  += act.ATTRF_CRV__c;
                ren.Raw_Maint_Calc__c +=act.Raw_Maint_Calc_LC__c; 
                ren.Current_Ann_Existing_Maintenance_LC__c += act.Current_Ann_Existing_Maintenance_LC__c;
                ren.Revenue_Per_Day__c += act.Revenue_Per_Day__c;
                 if(act.Product_Baseline_ATTRF_LC__c!=null)
				ren.Baseline_ATTRF_LC__c +=act.Product_Baseline_ATTRF_LC__c;
                //US500913 - PORAS01 - Updating the expiring Arr fields on Renewal
                ren.Expiring_ARR_LC__c += act.ExpiringARRLC__c;                                    
                //US500913 - PORAS01 - End

                // If install date is older, use this one
                Date dtInstallationDateOld = RenewalInstallationDateMap.get(renewalKeyValue);
                if(dtInstallationDate < dtInstallationDateOld) 
                   RenewalInstallationDateMap.put(renewalKeyValue,dtInstallationDate);             
                }
             else {

                System.debug('Creating renewalKeyValue= '+renewalKeyValue+' renewalCGRuleType= '+renewalCGRuleType);

                // Instantiate new renewal shell and new Chatter post shell
                ren = new Renewal__c();
                renChatterPost = new FeedItem();
                renChatterPost.Body = 'Grouping, Segmentation, and Owner Details: ';
                renewalChatterPostMap.put(renewalKeyValue,renChatterPost);
                
                if(act.Dismantle_Date__c != null)
                   ren.Expected_Close_Date__c = act.Dismantle_Date__c.addDays(1);// expected close date is dismantle date + 1 day
                else { // if dismantle date not specified, default to 1st day of next fiscal year 
                     if(date.today().month() > 3)
                         ren.Expected_Close_Date__c = date.newInstance(date.today().year()+1, 4, 1); 
                     else
                         ren.Expected_Close_Date__c = date.newInstance(date.today().year(), 4, 1);
                     }
                ren.renewal_date__c = ren.Expected_Close_Date__c; // added by danva01 for renwal iii project.
                ren.Renewal_Currency__c = act.Active_Contract__r.Renewal_Currency__c;
                ren.CurrencyIsoCode = act.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode; 

                ren.Account__c = act.Active_Contract__r.account__c;
                ren.Annual_OCV_LC__c = act.AOCV__c;
                ren.OCV__c = act.OCV__c;
                ren.ATTRF_CRV__c =act.ATTRF_CRV__c;                         
                ren.Raw_Maint_Calc__c = act.Raw_Maint_Calc_LC__c;
                ren.Current_Ann_Existing_Maintenance_LC__c = act.Current_Ann_Existing_Maintenance_LC__c;
                ren.Revenue_Per_Day__c =act.Revenue_Per_Day__c;
                ren.Region__c = act.Active_Contract__r.Region__c; // Added for FY13
                ren.Area__c = act.Active_Contract__r.Area__c; // Added for FY13
                ren.Territory_Country__c = act.Active_Contract__r.Territory_Country__c; // Added for FY13
             //   ren.instance_id__c= act.instance_id__c;//4053
				ren.Baseline_ATTRF_LC__c =act.Product_Baseline_ATTRF_LC__c;
                //US500913 - PORAS01 - Updating the expiring Arr fields on Renewal
                ren.Expiring_ARR_LC__c = act.ExpiringARRLC__c;                                   
                //US500913 - PORAS01 - End
                  
                if(act.instance_id__c!= null)
                { 
                   ren.instance_id__c= act.instance_id__c;
                   ren.category__c='Agile Vision';
                }

                // Renewal segmentation will be determined when the contract grouping rules are run for the renewal (dependency)
                // Since renewal name is used as a reference in the code, set temporary value as renewalKeyValue 
                ren.Name = renewalKeyValue;

                if (ren.category__c!= null)
                {


                   //RenewalAccountMap.put(renewalKeyValue,act.Active_Contract__r.account__r.name+' '+ren.category__c);
                     RenewalAccountMap.put(renewalKeyValue,act.Active_Contract__r.account__r.name);
                }
                else {
                
                RenewalAccountMap.put(renewalKeyValue,act.Active_Contract__r.account__r.name);
                }
                system.debug('RenewalAccountMap' + RenewalAccountMap);
                RenewalAreaMap.put(renewalKeyValue,act.Active_Contract__r.Area__c);
                RenewalCountryMap.put(renewalKeyValue,act.Active_Contract__r.Account__r.Region_Country__c);
                RenewalRegionMap.put(renewalKeyValue,act.Active_Contract__r.Region__c);
                //commented as part of 2164
                //RenewalStateMap.put(renewalKeyValue,act.Active_Contract__r.Account__r.BillingState);
                RenewalTerritoryMap.put(renewalKeyValue,act.Active_Contract__r.Territory_Country__c);

                RenewalProductMap.put(renewalKeyValue,act.product__r.Product_Group__c.toUpperCase());
                RenewalInstallationDateMap.put(renewalKeyValue,dtInstallationDate);
                RenewalSDTypeMap.put(renewalKeyValue,act.Active_Contract__r.Sales_Document_Type_Text__c.toUpperCase());
                RenewalGrpValueMap.put(renewalKeyValue,renewalGrpValue);
                RenewalAccSegMap.put(renewalKeyValue, act.Active_Contract__r.Account__r.Segment__c ); //FY15

                RenewalCGRuleTypeMap.put(renewalKeyValue,renewalCGRuleType);
                }

//Moved these outside of the if-else, since this is common code
            // Update common maps for this active contract product
            if(RenewalContractMap.containsKey(renewalKeyValue))
                RenewalContractMap.get(renewalKeyValue).add(act);  
            else{
                List<Active_Contract_Product__c> tempList = new List<Active_Contract_Product__c>();
                tempList.add(act);
                RenewalContractMap.put(renewalKeyValue,tempList);
                }

            // Need sum of OCV in USD for segmentation rule determination
            if(RenewalOcvUSDMap.containsKey(renewalKeyValue)){
                Double renOcvUSD = RenewalOcvUSDMap.get(renewalKeyValue);
                RenewalOcvUSDMap.put(renewalKeyValue,renOcvUSD + act.Calculated_OCV_USD__c);
                }
            else
                RenewalOcvUSDMap.put(renewalKeyValue,act.Calculated_OCV_USD__c);

             ACPRenewalMap.put(act.Id,renewalKeyValue);

// Owner will be assigned after the contract grouping rules have run to determine segmentation (dependency) 

// Save renewal shell for this active contract product
             genRenewalMap.put(renewalKeyValue,ren);
          
         } // end of line 335 active product for loop 'for(Active_Contract_Product__c act : actProdList) '

         Map<String,Contracts_Grouping_Rules__c> rulesMap = new Map<String,Contracts_Grouping_Rules__c>();        
         
         // for segmentation of renewals  

         System.debug('genRenewalMap.keyset() --> ' + genRenewalMap.keyset());

// Each key defines a specific renewal that will be created based on the ACPs processed
         for(String key:  genRenewalMap.keyset()){  // ends line 810

// Create renewal from ACP info
             Renewal__c ren = genRenewalMap.get(key);
             String selectedCGRuleType = RenewalCGRuleTypeMap.get(key);
             String derivedSegmentation = '';
             String derivedSegmentationReason = '';
             String region = RenewalRegionMap.get(key).toUpperCase();
             String area = RenewalAreaMap.get(key).toUpperCase();
             String tempPost;
             Double ocvUSD = RenewalOcvUSDMap.get(key);

             if(area == null)
                 area='N/A';
             if(region == null)
                 region ='';

// ********** Determine Renewal Segmentation **********
// We previously identified certain renewals as being subject to an acquisition product (ACQ), pre-segmentation (PRE), or
// sales doc type (SDT) grouping rule. We will first check against the appropriate rule table entries to see if all criteria
// are still met. If the value has increased above a rule threshold, we may need to run against the non-specific rules. 

             System.debug('Define Renewal Seg: selectedCGRuleType='+selectedCGRuleType+' '+ region+'/'+area+'/'+ocvUSD+ ' Renewal = '+key);

             if(selectedCGRuleType == 'ACQ' && acqProductGroupRulesMap.containsKey(RenewalProductMap.get(key))){
                 List<Contracts_Grouping_Rules__c> acqProductRulesList = acqProductGroupRulesMap.get(RenewalProductMap.get(key));
                 for(Contracts_Grouping_Rules__c rt :acqProductRulesList){
                     System.debug('ACQ '+ rt.region__c.toUpperCase()+'/'+rt.area__c.toUpperCase()+'/< '+rt.OCV_Lessthan__c +'/> '+ rt.OCV_Greaterthan__c);
                     if((rt.Region__c == null || rt.Region__c.toUpperCase().contains(region)) &&
                         (rt.OCV_Lessthan__c >= ocvUSD || rt.OCV_Lessthan__c == null) &&
                         (rt.OCV_Greaterthan__c <= ocvUSD || rt.OCV_Greaterthan__c == null) &&
                         (rt.Area__c == null || rt.Area__c.toUpperCase().contains(area) ||  rt.Area__c == '-') && ((rt.SFDC_Product__c<>null && rt.SFDC_Product__c.contains(RenewalCGRuleTypeMap.get(key))) || (rt.SFDC_Product__c==null)))
                     {
                         System.debug('ACQ rt value matched '+rt + 'renewal '+key);
                         derivedSegmentation = rt.Renewal_Segmentation__c;
                         derivedSegmentationReason = 'The segmentation rule for acquisition product '+rt.Product_Segmentation__c+' was followed ('+rt.Order_Of_Precedence__c+'). ';
                         break;
                         } 
                     }
             } else if(selectedCGRuleType == 'SDT' && salesDocTypeGroupRulesMap.containsKey(RenewalSDTypeMap.get(key).toUpperCase())){
                 List<Contracts_Grouping_Rules__c> salesDocTypeRulesList = salesDocTypeGroupRulesMap.get(RenewalSDTypeMap.get(key).toUpperCase());
                 for(Contracts_Grouping_Rules__c rt :salesDocTypeRulesList){
                     System.debug('SDT '+ rt.region__c.toUpperCase()+'/'+rt.area__c.toUpperCase()+'/< '+rt.OCV_Lessthan__c +'/> '+ rt.OCV_Greaterthan__c);
                     if((rt.Region__c == null || rt.Region__c.toUpperCase().contains(region)) &&
                         (rt.OCV_Lessthan__c >= ocvUSD || rt.OCV_Lessthan__c == null) &&
                         (rt.OCV_Greaterthan__c <= ocvUSD || rt.OCV_Greaterthan__c == null) &&
                         (rt.Area__c == null || rt.Area__c.toUpperCase().contains(area) ||  rt.Area__c == '-')){
                         System.debug('SDT rt value matched '+rt + 'renewal '+key);
                         derivedSegmentation = rt.Renewal_Segmentation__c;
                         derivedSegmentationReason = 'The segmentation rule for '+rt.Product_Segmentation__c+' Sales Doc Type was followed ('+rt.Order_Of_Precedence__c+'). ';
                         break;
                         } 
                     }
             } else if(selectedCGRuleType == 'PRE' && preSegGroupRulesMap.containsKey(RenewalGrpValueMap.get(key).toUpperCase())){
                 List<Contracts_Grouping_Rules__c> preSegRulesList = preSegGroupRulesMap.get(RenewalGrpValueMap.get(key).toUpperCase());
                 for(Contracts_Grouping_Rules__c rt :preSegRulesList){
                     System.debug('PRE Seg='+ rt.region__c.toUpperCase()+'/'+rt.area__c.toUpperCase()+'/LT '+rt.OCV_Lessthan__c +'/GT '+ rt.OCV_Greaterthan__c);
                     if((rt.Region__c == null || rt.Region__c.toUpperCase().contains(region)) &&
                         (rt.OCV_Lessthan__c >= ocvUSD || rt.OCV_Lessthan__c == null) &&
                         (rt.OCV_Greaterthan__c <= ocvUSD || rt.OCV_Greaterthan__c == null) &&
                         (rt.Area__c == null || rt.Area__c.toUpperCase().contains(area) ||  rt.Area__c == '-')){
                         System.debug('PRE rt value matched '+rt + 'renewal '+key);
                         derivedSegmentation = rt.Renewal_Segmentation__c;
                         derivedSegmentationReason = 'The '+rt.Renewal_Segmentation__c+' pre-segmentation rule was followed ('+rt.Order_Of_Precedence__c+'). ';
                         break;
                         } 
                     }
                 }

// If these checks did not get us a segmentation value, check against the non-specific rules. 
             if(derivedSegmentation == '' && regionBasedRulesList.size() > 0){
                 for(Contracts_Grouping_Rules__c rt :regionBasedRulesList){
                     System.debug('Default '+ rt.region__c.toUpperCase()+'/'+rt.area__c.toUpperCase()+'/< '+rt.OCV_Lessthan__c +'/> '+ rt.OCV_Greaterthan__c);
                     if((rt.Region__c == null || rt.Region__c.toUpperCase().contains(region)) &&
                         (rt.OCV_Lessthan__c >= ocvUSD || rt.OCV_Lessthan__c == null) &&
                         (rt.OCV_Greaterthan__c <= ocvUSD || rt.OCV_Greaterthan__c == null) &&
                         (rt.Area__c == null || rt.Area__c.toUpperCase().contains(area) ||  rt.Area__c == '-')){
                         System.debug('default rt value matched '+rt + 'renewal name'+key);
                         derivedSegmentation = rt.Renewal_Segmentation__c;
                         derivedSegmentationReason = 'A segmentation of '+rt.Renewal_Segmentation__c+' was assigned based on the Region/Area/OCV values '+' ('+rt.Order_Of_Precedence__c+'). ';
                         break;
                         } 
                     }
                 }

// Populate the renewal segmentation
// If there was no satisfactory rule found, default the segmentation to MT and leave details in the Overall Comments field. 
             System.debug('Before: DS='+ derivedSegmentation +'/'+derivedSegmentationReason);

             if(derivedSegmentation != ''){
                 ren.Segmentation__c = derivedSegmentation;
                 }
             else{
                 ren.Segmentation__c = 'MT';
                 derivedSegmentationReason = 'No appropriate grouping/segmentation rule was found. Segmentation was defaulted to MT.';
                 }

// Create/Append Chatter post
             if(renewalChatterPostMap.containsKey(key))
                 renChatterPost = renewalChatterPostMap.get(key);
             else{
                 renChatterPost = new FeedItem();
                 renChatterPost.Body = 'Grouping, Segmentation, and Owner Details: ';
                 }

             tempPost = renChatterPost.Body;
             if(tempPost != null)
                 renChatterPost.Body = tempPost+' '+derivedSegmentationReason;
             else
                 renChatterPost.Body = derivedSegmentationReason;
             renewalChatterPostMap.put(key,renChatterPost);

             System.debug('After: RS='+ ren.Segmentation__c +'/'+derivedSegmentationReason);

// ********** Determine Renewal Projected Term **********
// Assign expected term based on length between earliest installation date and common dismantle date
             Date dtInstallationDate = RenewalInstallationDateMap.get(key);
             Date dtDismantleDate= ren.Expected_Close_Date__c.addDays(-1); 
             Integer monthsBetween =0;

             if(dtInstallationDate != null && dtDismantleDate!= null){
                 monthsBetween = dtInstallationDate.monthsBetween(dtDismantleDate.addDays(1));    
                 if(monthsBetween == 0)
                     monthsBetween =1;   // Set to 1 if less than 1 month
                 else if(monthsBetween >= 60)  
                     monthsBetween = 60; // Cap expected term at 60 months 
                 }
              else if(dtInstallationDate == null) 
                 monthsBetween = 12; // Set to 12 if install is null 

             ren.Projected_Time_Duration_Months__c =  monthsBetween;              

// ********** Determine Renewal Projected Value **********
// Assign Projected Renewal as ATTRF * term
             ren.Projected_Renewal__c = (ren.ATTRF_CRV__c * monthsBetween)/12;
            
             System.debug('ren.Projected_Renewal__c='+ ren.Projected_Renewal__c + ' monthsBetween=' + monthsBetween + ' ren.ATTRF_CRV__c='+ ren.ATTRF_CRV__c ) ;

// ********** Determine Renewal Name **********
// Generate renewal name based on account, segmentation, close date, and acq product where needed
// Indicate acquisiton product or sales doc type in renewal name, if this caused the segmentation
             String strAccName = (RenewalAccountMap.get(key)==null?'':RenewalAccountMap.get(key));
             String strSegText = ' '+ren.segmentation__c;
             String instanceid;
             Integer len;
             if(String.isNotBlank(ren.instance_id__c)){
                instanceid =  ' '+ren.instance_id__c;
             }else{
                instanceid = '';
             }
              
             String strExpDate = (ren.Expected_Close_Date__c==null?'':' '+datetime.newInstance(ren.Expected_Close_Date__c,Time.newInstance(0,0,0,0)).format('dd MMM yyyy'));
             String suffixCgR = ((selectedCGRuleType == 'ACQ' || selectedCGRuleType == 'SDT' || selectedCGRuleType == 'PRE')?' ('+RenewalGrpValueMap.get(key)+')':'');
             Integer targetLen = 80 - strSegText.length() - strExpDate.length() - suffixCgR.length();
            // String strAcccSegTxt = (RenewalAccountMap.get(key)==null?'':RenewalAccountMap.get(key))+'-' +ren.segmentation__c;
             String strAcccSegTxt = (RenewalAccountMap.get(key)==null?'':RenewalAccountMap.get(key));
              if(targetLen > 0)
             {
                 if(strAccName.length()>targetLen ) {            
                     ren.Name=strAccName.Substring(0,targetLen)+strSegText+strExpDate+ instanceid +suffixCgR;
                 		if(ren.Name.length()>80){ //Added by SAMTU01- US249089
                 			System.debug('--inside if loop---');
                			 System.debug('--Renewal Name is---'+ren.Name);
                              if(instanceid.length()>6)
                              {
                                 System.debug('--instanceid freater than 6---'+ren.Name);
                                 instanceid=instanceid.substring(0,7);
                                  len=58-suffixCgR.length();
                                  if(strAccName.length()>len){
                                      System.debug('--Account name length greater than len---'+ren.Name);
                                      System.debug('--strsegtext length---'+strSegText.length());
                                      System.debug('--strexpdate len---'+strExpDate.length());
                                      System.debug('--suffixcgr len---'+suffixCgR.length());
                                      ren.Name=strAccName.Substring(0,len)+strSegText+strExpDate+ instanceid +suffixCgR;
                                      System.debug('--final renewal name is---'+ren.Name);
                                      System.debug('--renewal length is---'+ren.Name.length());
                                  }
                                  else{
                                      System.debug('--Account name length lesser than len---'+ren.Name);
                                      //len=64-strAccName.length();
                                      ren.Name=strAccName+strSegText+strExpDate+ instanceid +suffixCgR;
                                  }
                              }
                            else
                            {
                                len=65-instanceid.length()-suffixCgR.length();
                                if(strAccName.length()>len){
                                      ren.Name=strAccName.Substring(0,len)+strSegText+strExpDate+ instanceid +suffixCgR;
                                  }
                                  else {
                                      ren.Name=strAccName+strSegText+strExpDate+ instanceid +suffixCgR;
                                  }
                                
                            }
                        }
					}
                  else
                  {
                      ren.Name=strAccName+strSegText+strExpDate+suffixCgR;
                      if(ren.Name.length()>80){
                 			System.debug('--inside else loop---');
                          System.debug('--Renewal Name is---'+ren.Name);
                      		 len=65-suffixCgR.length();
                                if(strAccName.length()>len){
                                      ren.Name=strAccName.Substring(0,len)+strSegText+strExpDate+suffixCgR;
                                  }
                                  else {
                                      ren.Name=strAccName+strSegText+strExpDate+suffixCgR;
                                  }
                      
                      }
                     
                      
                  } //Added by SAMTU01- US249089 - ends here
                     
                  
            }
             else
                 	 ren.Name=strAccName.Substring(0,80);

             

// ********** Determine Renewal Owner **********
// Use Renewal Owner Rule object to determine the owner, based on geographic characteristics, segmentation, and product
                    String baseSearch;
             if(ren.category__c == null){
                baseSearch = RenewalTerritoryMap.get(key)+'-'+ren.Segmentation__c+'-';
             }
            else{
                baseSearch = RenewalTerritoryMap.get(key)+'-'+ren.Segmentation__c+'-'+ren.category__c+'-';
             }                             
             
             String countrySearch = baseSearch + RenewalCountryMap.get(key)+'-';
             String countryStateSearch = countrySearch +( RenewalStateMap.get(key)==null?'':RenewalStateMap.get(key)); // FY15 RenewalStateMap.get(key);
             String stateOnlySearch = baseSearch +'-'+ ( RenewalStateMap.get(key)==null?'':RenewalStateMap.get(key));
             String searchHit;
             String searchRuleNum='';
             String renOwnerName;

// 1st Renewal Owner Rules list, divided by segmentation. OwnerMap has non-MT rules.
             if(ren.Segmentation__c != 'MT' && OwnerMap.size() >0){                    

                 system.debug('Full HT/LT Search: '+ countryStateSearch);

                 if(OwnerMap.get(countryStateSearch)!= null){
                     searchRuleNum = OwnerMap.get(countryStateSearch); // State + Country
                     searchHit = countryStateSearch;
                     }
                 else if(OwnerMap.get(stateOnlySearch)!= null){
                     searchRuleNum = OwnerMap.get(stateOnlySearch);    // State + No Country
                     searchHit = stateOnlySearch;
                     }
                 else if(OwnerMap.get(countrySearch)!= null){
                     searchRuleNum = OwnerMap.get(countrySearch);      // Country + No State 
                     searchHit = countrySearch;
                     }
                 else if(OwnerMap.get(baseSearch+'-')!= null){
                     searchRuleNum = OwnerMap.get(baseSearch+'-');     // No Country + No State 
                     searchHit = baseSearch;
                     }

                 system.debug('HT/LT Owner Match: '+ searchHit+' Rule '+searchRuleNum);
                 }

// 2nd Renewal Owner Rules list, divided by segmentation and product. ProdOwnerMap has MT product-based rules.
             if(selectedCGRuleType == 'ACQ' || selectedCGRuleType == 'PRE' || selectedCGRuleType == 'SDT' && ren.Segmentation__c == 'MT' && ProdOwnerMap.size() > 0){
                 system.debug('Full MT Product Search: '+ countryStateSearch);
                 for(Integer j=(ProdOwnerMap.size() -1 );j >= 0 ; j--){
                     String MapVal;                    

                     if(ProdOwnerMap.get(countryStateSearch+'-'+j)!= null){
                         MapVal = ProdOwnerMap.get(countryStateSearch+'-'+j); // State + Country
                         searchHit = countryStateSearch;
                         }
                     else if(ProdOwnerMap.get(stateOnlySearch +'-'+j)!= null){
                         MapVal = ProdOwnerMap.get(stateOnlySearch +'-'+j);   // State + No Country 
                         searchHit = stateOnlySearch ;
                         }
                     else if(ProdOwnerMap.get(countrySearch +'-'+j)!= null){
                         MapVal = ProdOwnerMap.get(countrySearch +'-'+j);     // Country + No State 
                         searchHit = countrySearch ;
                         }
                     else if(ProdOwnerMap.get(baseSearch+'--'+j)!= null){
                         MapVal = ProdOwnerMap.get(baseSearch+'--'+j);        // No Country + No State 
                         searchHit = baseSearch;
                         }
                   
                     if(MapVal!= null){
                         if(MapVal.contains('|') && RenewalGrpValueMap.containsKey(key)){
                             String renGroupVal = RenewalGrpValueMap.get(key);
                             List<String> ss = new List<String>();
                             ss = MapVal.split('\\|');
                             if(ss[0].contains(RenewalGrpValueMap.get(key))){
                                 searchRuleNum = ss[1].trim();
                                 j = -1;
                                 }
                             }
                         else{                     
                             searchRuleNum = MapVal;
                             j = -1;
                             }
                         }
                     system.debug('MT Owner Match: '+ searchHit+' Rule '+searchRuleNum+' MapVal '+MapVal);
                     } 
                 }
                System.Debug('sAccSegment='+sAccSegment +'RenewalAccSegMap='+RenewalAccSegMap);
// 3rd Renewal Owner Rules list, divided by segmentation. MTOwnerMap has MT rules.
                //FY15 Account Segment__c Map for MT and Product id null 
            if (RenewalAccSegMap.size() > 0  &&  RenewalAccSegMap != null)
               sAccSegment = RenewalAccSegMap.get(key);
             if(searchRuleNum == '' && ren.Segmentation__c == 'MT' && MTOwnerMap.size() > 0){
                 system.debug('Full MT Search: '+ countryStateSearch +'stateOnlySearch='+stateOnlySearch + 'countrySearch='+countrySearch+'baseSearch='+baseSearch);
                 for(Integer j=(MTOwnerMap.size() -1 );j >= 0 ; j--){
                     String MapVal;                    

                     if(MTOwnerMap.get(countryStateSearch+'-'+j )!= null){
                         MapVal = MTOwnerMap.get(countryStateSearch+'-'+j); // State + Country
                         searchHit = countryStateSearch +'-'+j;
                         }
                     else if(MTOwnerMap.get(stateOnlySearch +'-'+j)!= null){
                         MapVal = MTOwnerMap.get(stateOnlySearch +'-'+j);   // State + No Country 
                         searchHit = stateOnlySearch +'-'+j+ '-' + sAccSegment ;
                         }
                     else if(MTOwnerMap.get(countrySearch +'-'+j)!= null){
                         MapVal = MTOwnerMap.get(countrySearch +'-'+j);     // Country + No State 
                         searchHit = countrySearch  +'-'+j ;
                         }
                     else if(MTOwnerMap.get(baseSearch+'-'+j)!= null){
                         MapVal = MTOwnerMap.get(baseSearch+'-'+j);        // No Country + No State 
                         searchHit = baseSearch +'-'+j;
                         }
                    else if (MTOwnerMap.get(baseSearch+j + '-'+sAccSegment)!= null){   // FY15
                            System.debug('BASE:-'+baseSearch+j + '-'+sAccSegment +'MTOwnerMap='+MTOwnerMap); 
                         MapVal = MTOwnerMap.get(baseSearch+j + '-'+sAccSegment);        // No Country + No State + Acc Segment 
                         searchHit = baseSearch +j+sAccSegment;
                         
                    }    
                    System.debug('countryStateSearch='+ countryStateSearch +'-'+j);
                    System.debug('stateOnlySearch='+ stateOnlySearch +'-'+j);
                    System.debug('countrySearch='+ countrySearch +'-'+j);
                    System.debug('baseSearch='+ baseSearch +'-'+j);
                    
                    
                     if(MapVal!= null){
                         if(MapVal.contains('|') && RenewalGrpValueMap.containsKey(key)){
                             String renGroupVal = RenewalGrpValueMap.get(key);
                             List<String> ss = new List<String>();
                             ss = MapVal.split('\\|');
                             system.debug('ss[0]= '+ss[0]+'ss[1]= '+ss[1]+' RenewalGrpValueMap.get(key) '+RenewalGrpValueMap.get(key));
                             if(ss[0].contains(RenewalGrpValueMap.get(key))){
                                 searchRuleNum = ss[1].trim();
                                 j = -1;
                                 }
                             }
                         else{                     
                             searchRuleNum = MapVal;
                             j = -1;
                             }
                         }
                     system.debug('MT Owner Match:= '+ searchHit+' Rule= '+searchRuleNum+' MapVal= '+MapVal +'MTOwnerMap='+MTOwnerMap);
                     } 
                 }
                 
                 Id strOwner;
                 String strRenName;
                 // System.Debug('strAcccSegTxt '+ strAcccSegTxt +'******'+AccUserMap.get(strAcccSegTxt+' '+catagoryname)+ ':::AccUserMap'+AccUserMap);
                  for (String sRuleName :AccRuleMap.keySet())  {
                        if (AccRuleMap.get(sRuleName).Use_Renewal_Owner_Account_Mapping1__c == true ) {
                            //searchRuleNum =  sRuleName;
                            
                            if( AccUserMap.get(strAcccSegTxt+' '+ ren.category__c) != null ){
                                //change
                                strOwner =AccUserMap.get(strAcccSegTxt+' '+ ren.category__c);
                                strRenName=AccNameMap.get(strOwner);  //get the name of the renewal 
                                isAmpFound = true;
                            }
                            //strOwner = (AccUserMap.get(strAcccSegTxt) == null ? '':AccUserMap.get(strAcccSegTxt));    
                        }
                   }

// Decode Rule Number to User Id and User Name
             String ownerStatus;
            System.Debug('INSIDE: strOwner='+ strOwner  + 'strAcccSegTxt='+strAcccSegTxt +'searchRuleNum='+searchRuleNum +'-'+isAmpFound);
            System.debug( 'Inside4:-'+   strOwner   +'isAmpFound'+isAmpFound);
           
               if(searchRuleNum != null && searchRuleNum != ''){
               
                strOwner = OwnerRuleMap.get(searchRuleNum);
                 System.Debug('INSIDE2: strOwner='+ strOwner  + 'strAcccSegTxt='+strAcccSegTxt +'OwnerRuleMap='+OwnerRuleMap+'searchRuleNum='+searchRuleNum);
                 if(strOwner != null){
                     ren.OwnerId = strOwner;
                     renOwnerName = UserMap.get(strOwner);
                     ownerStatus = 'A Renewal Owner Rule was used to assign this renewal to '+renOwnerName+' ('+searchRuleNum+'). ';
                     system.debug('--------searchRuleNum/strOwner/Name-----'+searchRuleNum+'/'+strOwner+'/'+renOwnerName);
                     }
                 } else if ( isAmpFound ){
                   //renOwnerName = UserMap.get(strOwner);
                    //ownerStatus = 'A Renewal Owner Rule was used to assign this renewal to '+renOwnerName+' ('+searchRuleNum+'). ';
                    //system.debug('--------searchRuleNum/strOwner/Name-----'+searchRuleNum+'/'+strOwner+'/'+renOwnerName);
                    System.Debug('INSIDE1: strOwner='+ strOwner  + 'strAcccSegTxt='+strAcccSegTxt);
                    ren.OwnerId =  strOwner;
                    if (strRenName != null)
                    {   
                            strSegText = ' '+strRenName.Substring(strRenName.length()-2 , strRenName.length());
                        // ALLHA02 Modified to trim Renewal name to 80 char - AR 3761
                        Integer targetLength = 80 - strSegText.length() - strExpDate.length() - suffixCgR.length();
                        system.debug(strAcccSegTxt+'Before >0 check' +strAcccSegTxt.length()+'*****'+targetLength);
                        if(targetLength > 0)
                        {

                               system.debug(strAcccSegTxt+'after >0 check' +strAcccSegTxt.length()+'*****'+targetLength);


                                 if(strAcccSegTxt.length()>targetLength) 
                                 {
                                    if(String.isNotBlank(instanceid))            
                                        strRenName = strAcccSegTxt.Substring(0,targetLength)+strSegText+strExpDate+instanceid+suffixCgR;       
                                    else
                                        strRenName = strAcccSegTxt+strSegText+strExpDate+suffixCgR;
                                 }
                                 else
                                 {
                                 if(String.isNotBlank(instanceid))
                                        strRenName = strAcccSegTxt+strSegText+strExpDate+instanceid+suffixCgR;
                                    else
                                        strRenName = strAcccSegTxt+strSegText+strExpDate+suffixCgR;
                                }
                        }
                        else{
                            strRenName = strAcccSegTxt.Substring(0,80); 
                             }                                                           
                        
                            ren.Name = strRenName;  
                            ren.Segmentation__c = strSegText;
                       
                    }
             }

             if(ren.OwnerId == null)
                 ownerStatus = 'No appropriate Renewal Owner Rule was found. The user executing renewal generation was assigned as the owner. ';

// Create/Append Chatter post
             if(renewalChatterPostMap.containsKey(key))
                 renChatterPost = renewalChatterPostMap.get(key);
             else{
                 renChatterPost.Body = 'Grouping, Segmentation, and Owner Details: ';
                 renChatterPost = new FeedItem();
                 }

             tempPost = renChatterPost.Body;
             if(tempPost != null)
                 renChatterPost.Body = tempPost+ownerStatus ;
             else
                 renChatterPost.Body = ownerStatus ;
             renewalChatterPostMap.put(key,renChatterPost);

// ********** Locally store updates to Renewal Object **********
             genRenewalMap.put(key,ren);              

             } // end for(String key:  genRenewalMap.keyset()) - starts line 497   

// Define lists for creation of renewal products and renewal contracts
       List<Renewal_Product__c> rpList = new List<Renewal_Product__c>();
       List<Renewal_Contracts__c> RenewalContractList = new List<Renewal_Contracts__c>();
       List<Active_Contract_Product__c> acpList = new List<Active_Contract_Product__c>();
       Map<Id,Renewal_Product__c> rpMap = new Map<Id,Renewal_Product__c>();

// Commit insert of renewals 
       Database.SaveResult[] lsr = Database.insert(genRenewalMap.values(), false);
       Map<id,Renewal__c> mRen = new Map<id,renewal__c>([Select id, ATTRF_CRV__c , Projected_Renewal__c from Renewal__C where id in : genRenewalMap.values()]);

       System.debug('genRenewalMap.values()='+ genRenewalMap.values());

       Integer cntRenewal=0;

       for(String renewalKey : genRenewalMap.keySet()){
           Renewal__c keyedRenewal = genRenewalMap.get(renewalKey);                                                                   
           if(keyedRenewal.Id==null){
               errors.add(lsr[cntRenewal].getErrors()[0].getMessage());
               }
           else{
               generatedRenewals.add(keyedRenewal);

//             Post to Chatter feed
               if(renewalChatterPostMap.containsKey(renewalKey)){
                   renChatterPost = renewalChatterPostMap.get(renewalKey);
                   renChatterPost.ParentId = keyedRenewal.Id;
                   //insert renChatterPost;
                   renChatterPost1.add(renChatterPost);
                   }
               }
           System.debug('generatedRenewal #'+cntRenewal+' '+genRenewalMap.values().get(cntRenewal).Id+' '+genRenewalMap.values().get(cntRenewal).Name);
           cntRenewal++;
           }
           if (renChatterPost1.size()>0)
                Insert renChatterPost;

// Set up renewal product maps
       Set<Id> ContractSet;
       Map<Id,Set<Id>> RenewalContractIdMap = new Map<Id,Set<Id>>();
       Map<Id,String> ContractNbrMap = new Map<Id,String>();

       condition1= true;
       Map<String,Renewal_product__c> TestMap = new Map<String,Renewal_product__c>();

// ********** Create necessary Renewal Products **********
// Code correction 20111117: All references to variable renid in this for loop removed and substituted with ren.Id

       for(Active_Contract_Product__c acp: actProdList){
           
         System.debug('Begin [for actProdList] ACPName='+ acp.name+ ' ACPId='+ acp.Id);

// Grab the Renewal for this Active Contract Product
         
         Renewal__c ren;
         if(genRenewalMap.containsKey(ACPRenewalMap.get(acp.Id))){
             ren = genRenewalMap.get(ACPRenewalMap.get(acp.Id));                                                                   
             System.debug('Found ACPRenewalMap ren.name '+ ren.name+ ' ren.Id '+ ren.Id+ ' ACPId '+ acp.Id);
             }
         else
             System.debug('genRenewalMap not successful for ACPRenewalMap '+ACPRenewalMap.get(acp.Id)+' ACPId '+ acp.Id);

                
// Set Renewal Product name to current product name from product object
         Renewal_Product__c rp;
         if(mapProductsRenewals.containsKey(ren.Id + ',' + acp.Product__r.name)) // code changed to refer to ren.Id 20111117
             rp = mapProductsRenewals.get(ren.Id + ',' + acp.Product__r.name);   // code changed to refer to ren.Id 20111117
                      
// Define values for the Renewal Product based on the Active Contract Product
         if(rp ==null){
             // New Renewal Product needed. Initialize values, including Product and name 20111107
             System.debug('Creating Renewal Product for Renewal='+ren.Id+' Product='+acp.product__c+', '+acp.Product__r.name+' for ACP='+acp.Id+', '+acp.name);
             rp = new Renewal_Product__c();
             rp.Renewal__c = ren.Id;  // code changed to refer to ren.Id 20111117
             rp.Product__c = acp.Product__c;
             rp.Name = acp.Product__r.name;

             rp.Annual_OCV_LC__c = acp.AOCV__c;
             rp.ATTRF_CRV__c = acp.ATTRF_CRV__c;
             rp.OCV__c = acp.OCV__c;
             rp.Raw_Maintenance_Calc__c = acp.Raw_Maint_Calc_LC__c;
             rp.Current_Ann_Existing_Maintenance_LC__c = acp.Current_Ann_Existing_Maintenance_LC__c;
             rp.Revenue_Per_Day__c = acp.Revenue_Per_Day__c;
             //US500913 - PORAS01 - Updating the expiring Arr fields on Renewal
             rp.Expiring_ARR_LC__c = acp.ExpiringARRLC__c;                              
             //US500913 - PORAS01 - End
             if(acp.Product_Baseline_ATTRF_LC__c!=null)
			 	rp.Baseline_ATTRF_LC__c = acp.Product_Baseline_ATTRF_LC__c;
             }
         else{
             // Existing Renewal Product found. Update values.
             System.debug('Updating Renewal Product for Renewal='+ren.Id+' Product='+acp.product__c+', '+acp.Product__r.name+' for ACP='+acp.Id+', '+acp.name);
             rp.Annual_OCV_LC__c += acp.AOCV__c;
             rp.ATTRF_CRV__c += acp.ATTRF_CRV__c;
             rp.OCV__c +=acp.OCV__c;
             rp.Raw_Maintenance_Calc__c += acp.Raw_Maint_Calc_LC__c;
             rp.Current_Ann_Existing_Maintenance_LC__c += acp.Current_Ann_Existing_Maintenance_LC__c;
             rp.Revenue_Per_Day__c +=acp.Revenue_Per_Day__c;
             //US500913 - PORAS01 - Updating the expiring Arr fields on Renewal
             rp.Expiring_ARR_LC__c += acp.ExpiringARRLC__c;                              
             //US500913 - PORAS01 - End
             if(acp.Product_Baseline_ATTRF_LC__c!=null&&rp.Baseline_ATTRF_LC__c!=null)
			 	rp.Baseline_ATTRF_LC__c += acp.Product_Baseline_ATTRF_LC__c;
             else{
                 if(rp.Baseline_ATTRF_LC__c!=null)
                     rp.Baseline_ATTRF_LC__c += acp.Product_Baseline_ATTRF_LC__c;
                 else
                     rp.Baseline_ATTRF_LC__c = acp.Product_Baseline_ATTRF_LC__c;
             }
             }

            if(mRen.size() > 0  && ren.Id != null ) {
                 if(ren.Projected_Renewal__c != null && mRen.get(ren.Id).ATTRF_CRV__c != 0)  // code changed to refer to ren.Id 20111117
                 rp.Projected_Renewal_LC__c = ren.Projected_Renewal__c * (rp.ATTRF_CRV__c/mRen.get(ren.id).ATTRF_CRV__c ); // Changed from acp.ATTRF_CRV__c to rp.ATTRF_CRV__c 20111107
             else 
                 rp.Projected_Renewal_LC__c = 0;
             }

// Define values for the Renewal Product based on the Active Contract Product
         rpMap.put(acp.Id,rp);
         TestMap.put(ren.Id +',' + rp.name,rp); // code changed to refer to ren.Id 20111117
         mapProductsRenewals.put(rp.renewal__c + ',' + rp.name,rp); 

// Update of ACP Pre-Segmentation is on hold, because pre-segmentation should agree with contract segmentation 
// need to update pre-segmentation at active contract product level
//         Active_Contract_Product__c acpNew = new Active_Contract_Product__c(id = acp.Id);
//         acpList.add(acpNew);
               
         // Code revision 20111117: set up list of contract Ids for renewal contract creation
         if(RenewalContractIdMap.containsKey(ren.Id)){
             ContractSet = RenewalContractIdMap.get(ren.Id);
             if(!ContractSet.contains(acp.Active_Contract__c)){
                 ContractSet.add(acp.Active_Contract__c);
                 system.Debug('Contract Set for Renewal '+ren.Id+' - Added '+acp.Active_Contract__c+'/'+acp.Active_Contract__r.name);
                 }
             }
         else{
             ContractSet = new Set<Id>();
             ContractSet.add(acp.Active_Contract__c);
             system.Debug('Contract Set for Renewal '+ren.Id+' - Start '+acp.Active_Contract__c+'/'+acp.Active_Contract__r.name);
             }
         if(!ContractNbrMap.containsKey(acp.Active_Contract__c))
             ContractNbrMap.put(acp.Active_Contract__c,acp.Active_Contract__r.name);
         RenewalContractIdMap.put(ren.Id,ContractSet);
             
         } // end for(Active_Contract_Product__c acp: actProdList)

// Commit insert of renewal products 
         System.debug('RP MAP'+ rpMap.values());
         Database.Insert( testMap.values(),false);// insert renewal products
            
// Define Renewal Contracts based on the information compiled during the creation of the Renewal Products
        for(Id renewalId : RenewalContractIdMap.keySet()){
            system.Debug('Processing RC for Renewal '+renewalId+' RenewalContractIdMap.get(renewalId)='+RenewalContractIdMap.get(renewalId));
            for(Id Id1:  RenewalContractIdMap.get(renewalId)){    
                Renewal_Contracts__c rc = new Renewal_Contracts__c();              
                rc.active_contract__c =  Id1; //AcpRenewalIdsMap.get(renewalId);
                rc.renewal__c = renewalId;
                rc.name = ContractNbrMap.get(Id1);
                RenewalContractList.add(rc);
                system.debug('Added renewal contract for '+rc.active_contract__c+'/'+rc.name+' on renewal '+rc.renewal__c);
                }
            }
         
        // Update Active Contract Products based on the new association with the Renewal
        List<Active_Contract_Product__c> contractProductUpdateList = new List<Active_Contract_Product__c>();
        for(Id activeContractProductId : rpMap.keyset()){           
             Renewal_Product__c rproduct = rpMap.get(activeContractProductId);
             Active_Contract_Product__c ac = new Active_Contract_Product__c(id = activeContractProductId,Renewal_Product__c =rproduct.Id);
             contractProductUpdateList.add(ac);
             }

        // update active contracts with renewal product
        if(contractProductUpdateList.size()>0)
            update contractProductUpdateList; 

        // insert renewal contracts
        if(RenewalContractList.size()>0){
            insert RenewalContractList; 
            return 'No Error';                   
            }
        else          
           return '';                   
       // }   

      //  catch(Exception e){
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
          
         //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Exception' + e));
            //ApexPages.addMessage(msg); 
         //   return '';
        //}
    } // end of [public void Renewal_ConvertActiveContractsMethod]
  
  
  
   public PageReference recentRenewals() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id From Report r where DeveloperName=:'Recently_Created_Renewals'];
        PageReference ref = new PageReference('/'+report.Id);
        return ref;
        }
    
   
}