global class Renewal_BatchGenerateRenewals implements Database.Batchable<sObject>{
    global final Date startDate;
    global final Date endDate;
    global final String RegionValue;
    global final Boolean isTest;
    public Boolean condition1;
    public static boolean isTest;
    
    public List<String> selectedIds = new List<String>();
    Public Map<string, renewal_product__c> mapProductsRenewals = new Map<string, renewal_product__c>();
    Set<string> errors = new set<string>();
    public List<Renewal__c> generatedRenewals = new List<Renewal__c> ();
    Map<String,Id> OwnerRuleMap = new Map<String,Id>();
    Map<Id,String> UserMap = new Map<Id,String>();
    Map<String,String> OwnerMap = new Map<String,String>();
    Map<String,String> ProdOwnerMap = new Map<String,String>();
    Map<String,String> MTOwnerMap = new Map<String,String>();
    Map<String,Renewal__c> genRenewalMap = new Map<String,Renewal__c>();
    List<Renewal_Owner_Rules__c>  lstOwnerID = new  List<Renewal_Owner_Rules__c>();
    public String sAccSegment='';
  // Map for storing Chatter post information to be posted against generated renewals
    Map<String,FeedItem> renewalChatterPostMap = new Map<String,FeedItem>();
    FeedItem renChatterPost;
    List<FeedItem> renChatterPost1 = new List<FeedItem>();
    List<Renewal_Owner_Account_Mapping__c>  lstAccOwnerID = new  List<Renewal_Owner_Account_Mapping__c>(); //Rao Account Mapping rules 
    
    public static boolean isAmpFound = false; // Account Mapping Rules identifier 
    //Added for Renewal Owner Assignment and Sharing Rules 6.05
    global    Set<String> strRegion = new set<String>();
    global    Set<String>  strArea = new set<String>();
    global    Set<String>  strTerritory = new set<String>();
    global id OwnerId;
    Map<Id,String> AccNameMap = new Map<Id,String>();  //FY15
    Map<String,Id> AccUserMap = new Map<String,Id>();  //FY15


    global Renewal_BatchGenerateRenewals(Date strtDt,Date endDt,String regionVal, Boolean calledFromTest){
        startDate = strtDt;
        endDate= endDt;
        RegionValue= regionVal;
        isTest = calledFromTest;
                                                         
                                                         
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(isTest == false){
        return Database.getQueryLocator([Select a.Segmentation__c, a.Pre_Segmentation__c,a.OCV__c, a.Name, a.Dismantle_Date__c,  a.Calculated_OCV_USD__c,
                                         				//US500913 - PORAS01 - Adding Expiring ARR (LC) fields
                         								a.ExpiringARRLC__c, //US500913 - PORAS01 - end
                                                        a.Active_Contract__r.Territory_Country__c, a.Active_Contract__r.Region__c,a.Active_Contract__r.Area__c,
                                                         a.Active_Contract__c,a.Active_Contract__r.account__r.name, a.AOCV__c,a.Currency__c,
                                                         a.Revenue_Per_Day__c,a.Current_Ann_Existing_Maintenance_LC__c,
                                                         a.Active_Contract__r.account__c,a.ATTRF_CRV__c,a.Product__c,a.Active_Contract__r.Renewal_Currency__r.Conversion_Rate__c,
                                                         a.Product__r.name,a.product__r.Market_Focus_Area__c,a.Active_Contract__r.Sales_Document_Type__c,
                                                         a.Active_Contract__r.Renewal_Currency__c,a.Raw_Maint_Calc_LC__c,a.Active_Contract__r.name,
                                                         a.Active_Contract__r.Renewal_Currency__r.Name,product__r.Product_Group__c, Active_Contract__r.Sales_Document_Type_Text__c ,Active_Contract_Product__c.Renewal_Product__c,
                                                         a.Active_Contract__r.Account__r.Region_Country__c, a.Active_Contract__r.Account__r.BillingState , 
                                                         Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode , 
                                                         (Select Installation_Date__c From Active_Contract_Line_Items__r 
                                                         where  Installation_Date__c != null order by Installation_Date__c ) 
                                                         From Active_Contract_Product__c a 
                                                         where a.Renewal_Product__c = null
                                                         and a.Segmentation__c != 'Invalid' 
                                                         and a.Dismantle_Date__c  >: startDate 
                                                         and a.Dismantle_Date__c <: endDate
                                                         order by a.Active_Contract__r.account__r.name limit 25000  ]);

        } else {
        return Database.getQueryLocator([Select a.Segmentation__c, a.Pre_Segmentation__c,a.OCV__c, a.Name, a.Dismantle_Date__c,  a.Calculated_OCV_USD__c,
                                         				//US500913 - PORAS01 - Adding Expiring ARR (LC) fields
                         								a.ExpiringARRLC__c, //US500913 - PORAS01 - end
                                                        a.Active_Contract__r.Territory_Country__c, a.Active_Contract__r.Region__c,a.Active_Contract__r.Area__c,
                                                         a.Active_Contract__c,a.Active_Contract__r.account__r.name, a.AOCV__c,a.Currency__c,
                                                         a.Revenue_Per_Day__c,a.Current_Ann_Existing_Maintenance_LC__c,
                                                         a.Active_Contract__r.account__c,a.ATTRF_CRV__c,a.Product__c,a.Active_Contract__r.Renewal_Currency__r.Conversion_Rate__c,
                                                         a.Product__r.name,a.product__r.Market_Focus_Area__c,a.Active_Contract__r.Sales_Document_Type__c,
                                                         a.Active_Contract__r.Renewal_Currency__c,a.Raw_Maint_Calc_LC__c,a.Active_Contract__r.name,
                                                         a.Active_Contract__r.Renewal_Currency__r.Name,product__r.Product_Group__c, Active_Contract__r.Sales_Document_Type_Text__c ,Active_Contract_Product__c.Renewal_Product__c,
                                                         a.Active_Contract__r.Account__r.Region_Country__c, a.Active_Contract__r.Account__r.BillingState , 
                                                         Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode , 
                                                         (Select Installation_Date__c From Active_Contract_Line_Items__r 
                                                         where  Installation_Date__c != null order by Installation_Date__c ) 
                                                         From Active_Contract_Product__c a 
                                                         where a.Renewal_Product__c = null
                                                         and a.Segmentation__c != 'Invalid' 
                                                         and a.Dismantle_Date__c  >: startDate 
                                                         and a.Dismantle_Date__c <: endDate
                                                         order by a.Active_Contract__r.account__r.name LIMIT 10]);
                                                     
                                                        /// and a.Dismantle_Date__c  >: startDate 
                                                         ///and a.Dismantle_Date__c <: endDate
                                                        //// order by a.Active_Contract__r.account__r.name limit 200]);
        }                                                 
//        return Database.getQueryLocator('select Calculated_AOCV_USD__c,Calculated_OCV_USD__c,account__c from active_contract__c');
    }
    global void execute(Database.BatchableContext BC, List<Active_Contract_Product__c> scope){
        processResult(scope);      
   }
   global void processResult(List<Active_Contract_Product__c> scope)
   {
   
   
  
      
      // try{    
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
                                                            c.Area__c,c.Sales_Document_Type__c,c.Order_Of_Precedence__c  From Contracts_Grouping_Rules__c c 
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
                    if(prodBUExclusionRulesMap.containsKey(contractGrpRules.Product_Business_Unit__c.toUpperCase())){
                        prodBUExclusionRulesMap.get(contractGrpRules.Product_Business_Unit__c.toUpperCase()).add(contractGrpRules);
                    }else{
                        List<Contracts_Grouping_Rules__c> cg = new List<Contracts_Grouping_Rules__c>();
                        cg.add(contractGrpRules);
                        if(contractGrpRules.region__c!= null)
                           prodBUExclusionRulesMap.put(contractGrpRules.Product_Business_Unit__c.toUpperCase(),cg);
                    }
                }                
//                else if(contractGrpRules.Rule_Type__c == 'GEO')
               // else // Geo-based rules + catchall
               else if (contractGrpRules != null)
                    regionBasedRulesList.add(contractGrpRules);
                                                        
         } // end of contract grouping rules load 

        // if(acqProductGroupRulesMap.size()>0)   system.debug('--------acqProductGroupRulesMap-------'+acqProductGroupRulesMap);
         //if(salesDocTypeGroupRulesMap.size()>0) system.debug('--------salesDocTypeGroupRulesMap-------'+salesDocTypeGroupRulesMap);
         //if(preSegGroupRulesMap.size()>0)       system.debug('--------preSegGroupRulesMap-------'+preSegGroupRulesMap);
         //if(prodBUExclusionRulesMap.size()>0)   system.debug('--------prodBUExclusionRulesMap-------'+prodBUExclusionRulesMap);
         //if(regionBasedRulesList.size()>0)      system.debug('--------regionBasedRulesList-------'+regionBasedRulesList);
       
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
          

         
  
if(scope.size()> 0){              
  for(Active_Contract_Product__c acContractProd:scope)
  { 
        system.debug('222');
    // Cleanse key fields in case the data is dirty (sometimes happens with TOPS data) 2011-11-07
    if(acContractProd.product__r.Product_Group__c == null)
        if(acContractProd.product__r <> null)
           acContractProd.product__r.Product_Group__c = '';
    if(acContractProd.Active_Contract__r.Sales_Document_Type_Text__c == null)
         if(acContractProd.Active_Contract__r <> null)
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
                       if(RegionValue=='-None-' || RegionValue == acContractProd.Active_Contract__r.Region__c){                                                         
                           actProdList.add(acContractProd);
                           }     

                       //for 6.05 - picking up the current Region, Area, Country, Territory, State, and Segmentation
                       if(acContractProd.Active_Contract__r.Region__c <> '' || acContractProd.Active_Contract__r.Region__c != null)
                          strRegion.Add(acContractProd.Active_Contract__r.Region__c) ;
                       if(acContractProd.Active_Contract__r.Area__c <> '' || acContractProd.Active_Contract__r.Area__c != null)
                          strArea.Add(acContractProd.Active_Contract__r.Area__c) ;
                       if(acContractProd.Active_Contract__r.Territory_Country__c <> '' || acContractProd.Active_Contract__r.Territory_Country__c != null)
                          strTerritory.Add(acContractProd.Active_Contract__r.Territory_Country__c) ;
                       if(acContractProd.Active_Contract__r.Account__r.Region_Country__c <> '' || acContractProd.Active_Contract__r.Account__r.Region_Country__c != null)
                          strCountry.Add(acContractProd.Active_Contract__r.Account__r.Region_Country__c) ;
                       if(acContractProd.Active_Contract__r.Account__r.BillingState <> '' || acContractProd.Active_Contract__r.Account__r.BillingState != null)
                          strStates.Add(acContractProd.Active_Contract__r.Account__r.BillingState) ;
                       if(acContractProd.Pre_Segmentation__c <> '' || acContractProd.Pre_Segmentation__c != null)
                          strSegment.Add(acContractProd.Pre_Segmentation__c) ;    

                    }else{ //place to show error msg for bad territory
//                         if(!isBatch)    
//                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The territory for this Active Contract is not specified.(' + acContractProd.Active_Contract__r.name + ')')); 
             
                         }
                }else{ //place to show error msg for excluded product
                    /// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The business unit for this contract product is excluded.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
                     }
            }else{ //place to show error msg for no contract line items
                 ////ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product has no line items.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
                 }
        }else{ //place to show error msg for Term ended renewed case
             ////ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product is already renewed.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
             
             }
     }else{ //place to show error msg for segmentation invalid case 
       ////ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Renewals will not be generated for Invalid contract products.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
          }
            
   }else{ //place to show error msg for Renewal_Product__c is not equal to null
     ////ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This contract product is already attached to a renewal.(' + acContractProd.Active_Contract__r.name  + '-' + acContractProd.Name + ')')); 
        } 
  } // end for(Active_Contract_Product__c acContractProd:newacplist)
} // end if(newacplist.size()> 0)

 
       if(actProdList.size() ==0){
            return; // 'No Data';
            System.Debug('To_Test_Region'+ strRegion+'Area' + strArea+ 'Teritory'+strTerritory + 'Country'+ strCountry + 'States'+ strStates + 'Segmentation' + strSegment) ;
            }

// ********** Load Renewal Owner Rules **********
// Load all records into either the MT list, or the non-MT list

       lstOwnerID = [Select Name, user__c, user__r.Name, user__r.IsActive, Region__c , Area__c, Territory__c,Product__c, Product_ids__c,
                            Country__c,Segmentation__c,States__c
                     from  Renewal_Owner_Rules__c
                     where (Territory__c in : strTerritory)
                     order by country__c, Product__c]; 
                     
        // Renewal Owner Account Rules 
        lstAccOwnerID = [select id, Account__r.Name,  Renewal_Owner__r.IsActive ,  Segmentation__c , Renewal_Owner__c from Renewal_Owner_Account_Mapping__c where  Renewal_Owner__c != null    Limit 9999];      
            for ( Renewal_Owner_Account_Mapping__c OAM :lstAccOwnerID ) {
                if(OAM.Account__r.Name != null && OAM.Segmentation__c != null && OAM.Renewal_Owner__r.IsActive)
                //AccUserMap.put(OAM.Account__r.Name+'-'+OAM.Segmentation__c, OAM.Renewal_Owner__c  );
                AccUserMap.put(OAM.Account__r.Name, OAM.Renewal_Owner__c  );
                AccNameMap.put(OAM.Renewal_Owner__c, OAM.Account__r.Name+'-'+OAM.Segmentation__c );
            
            }
        Map<String,Renewal_Owner_Rules__c> AccRuleMap = new Map<String,Renewal_Owner_Rules__c>();            
     
       Boolean productFound =  false;
       Integer i=0;
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
                                       
// Populate map to decode Rule Number to User Id|User Name
                if(Owner.User__c != null){
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
           //else       ///ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'User '+Owner.User__r.Name+' in not active. Renewal owner rule '+Owner.Name+' ignored.')); 
           }

         

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
             // Otherwise set Renewal Group Value and Rule Type to empty
             else {
                  renewalGrpValue = '';
                  renewalCGRuleType = '';
                  }

            //FY13- Added Territory to the Key Field
             // Renewal Key Value is [Account]+[Territory]+[CurrencyIsoCode]+[DismantleDate]+[RenewalGroupValue defined above] 20111107
             renewalKeyValue = act.Active_Contract__r.account__c + '|' + act.Active_Contract__r.Territory_Country__c + '|' +  act.Active_Contract__r.account__c+'|'+act.Active_Contract__r.Renewal_Currency__r.CurrencyIsoCode+'|'+act.Dismantle_Date__c+'|'+renewalGrpValue;

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
				//US500913 - PORAS01 - Updating the expiring Arr fields on Renewal
                ren.Expiring_ARR_LC__c = act.ExpiringARRLC__c;                                 
                //US500913 - PORAS01 - End
                
                // Renewal segmentation will be determined when the contract grouping rules are run for the renewal (dependency)
                // Since renewal name is used as a reference in the code, set temporary value as renewalKeyValue 
                ren.Name = renewalKeyValue;

                RenewalAccountMap.put(renewalKeyValue,act.Active_Contract__r.account__r.name);
                RenewalAreaMap.put(renewalKeyValue,act.Active_Contract__r.Area__c);
                RenewalCountryMap.put(renewalKeyValue,act.Active_Contract__r.Account__r.Region_Country__c);
                RenewalRegionMap.put(renewalKeyValue,act.Active_Contract__r.Region__c);
                //Commented as part of 2164
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
             String region = RenewalRegionMap.get(key);
             if(region <> null)  region = region.toUpperCase();
             String area = RenewalAreaMap.get(key);
             if(area <> null) area = area.toUpperCase();
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
                         (rt.Area__c == null || rt.Area__c.toUpperCase().contains(area) ||  rt.Area__c == '-')){
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
             String strExpDate = (ren.Expected_Close_Date__c==null?'':' '+datetime.newInstance(ren.Expected_Close_Date__c,Time.newInstance(0,0,0,0)).format('dd MMM yyyy'));
             String suffixCgR = ((selectedCGRuleType == 'ACQ' || selectedCGRuleType == 'SDT')?' ('+RenewalGrpValueMap.get(key)+')':'');
             Integer targetLen = 80 - strSegText.length() - strExpDate.length() - suffixCgR.length();
             //String strAcccSegTxt = (RenewalAccountMap.get(key)==null?'':RenewalAccountMap.get(key))+'-' +ren.segmentation__c;
             String strAcccSegTxt = (RenewalAccountMap.get(key)==null?'':RenewalAccountMap.get(key));
             if(targetLen > 0)
                 if(strAccName.length()>targetLen)             
                     ren.Name=strAccName.Substring(0,targetLen)+strSegText+strExpDate+suffixCgR;
                 else
                     ren.Name=strAccName+strSegText+strExpDate+suffixCgR;
             else
                 ren.Name=strAccName.Substring(0,80);

// ********** Determine Renewal Owner **********
// Use Renewal Owner Rule object to determine the owner, based on geographic characteristics, segmentation, and product
                                         
             String baseSearch = RenewalTerritoryMap.get(key)+'-'+ren.Segmentation__c+'-';
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
             if(selectedCGRuleType == 'ACQ' && ren.Segmentation__c == 'MT' && ProdOwnerMap.size() > 0){
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

// 3rd Renewal Owner Rules list, divided by segmentation. MTOwnerMap has MT rules.

                 //FY15 Account Segment__c Map for MT and Product id null 
                 if (RenewalAccSegMap.size() > 0  &&  RenewalAccSegMap != null)
                  sAccSegment = RenewalAccSegMap.get(key);
                  
             if(searchRuleNum == '' && ren.Segmentation__c == 'MT' && MTOwnerMap.size() > 0){
                 system.debug('Full MT Search: '+ countryStateSearch);
                 for(Integer j=(MTOwnerMap.size() -1 );j >= 0 ; j--){
                     String MapVal;                    

                     if(MTOwnerMap.get(countryStateSearch+'-'+j)!= null){
                         MapVal = MTOwnerMap.get(countryStateSearch+'-'+j); // State + Country
                         searchHit = countryStateSearch;
                         }
                     else if(MTOwnerMap.get(stateOnlySearch +'-'+j)!= null){
                         MapVal = MTOwnerMap.get(stateOnlySearch +'-'+j);   // State + No Country 
                         searchHit = stateOnlySearch ;
                         }
                     else if(MTOwnerMap.get(countrySearch +'-'+j)!= null){
                         MapVal = MTOwnerMap.get(countrySearch +'-'+j);     // Country + No State 
                         searchHit = countrySearch ;
                         }
                     else if(MTOwnerMap.get(baseSearch+'--'+j)!= null){
                         MapVal = MTOwnerMap.get(baseSearch+'--'+j);        // No Country + No State 
                         searchHit = baseSearch;
                         }
                     else if (MTOwnerMap.get(baseSearch+j + '-'+sAccSegment)!= null){   // FY15
                           
                         MapVal = MTOwnerMap.get(baseSearch+j + '-'+sAccSegment);        // No Country + No State + Acc Segment 
                         searchHit = baseSearch +j+sAccSegment;
                    }    
                   
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
                     system.debug('MT Owner Match: '+ searchHit+' Rule '+searchRuleNum+' MapVal '+MapVal);
                     } 
                 }
                  //Fy15 Acccount mapping rules 
                  Id strOwner;
                  String strRenName;
                  for (String sRuleName :AccRuleMap.keySet())  {
                        if (AccRuleMap.get(sRuleName).Use_Renewal_Owner_Account_Mapping1__c == true ) {
                            //searchRuleNum =  sRuleName;
                            
                            if( AccUserMap.get(strAcccSegTxt) != null ){
                                strOwner =AccUserMap.get(strAcccSegTxt);
                                strRenName=    AccNameMap.get(strOwner); // get the name of the renewal 
                                isAmpFound = true;
                            }
                        }
                   } // end for

                 

// Decode Rule Number to User Id and User Name
             String ownerStatus;
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
                    System.Debug('INSIDE1: strOwner='+ strOwner  + 'strAcccSegTxt='+strAcccSegTxt);
                    ren.OwnerId =  strOwner;
                    if (strRenName != null)
                    {   
                            strSegText = strRenName.Substring(strRenName.length()-2 , strRenName.length());
                            strRenName = strAcccSegTxt ; //strRenName.Substring(0 , strRenName.length()-2);
                            strRenName = strRenName+strSegText+strExpDate+suffixCgR;
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

       System.debug('----genRenewalMap.values()='+  genRenewalMap.values()+ '--lsr --'+lsr );

       Integer cntRenewal=0;

       for(String renewalKey : genRenewalMap.keySet()){
           Renewal__c keyedRenewal = genRenewalMap.get(renewalKey);                                                                   
           System.Debug('keyedRenewal '+ keyedRenewal.id );
           if(keyedRenewal.Id==null){
               errors.add(lsr[cntRenewal].getErrors()[0].getMessage());
               }
           else{
               generatedRenewals.add(keyedRenewal);

//             Post to Chatter feed
               if(renewalChatterPostMap.containsKey(renewalKey)){
                   renChatterPost = renewalChatterPostMap.get(renewalKey);
                   renChatterPost.ParentId = keyedRenewal.Id;
                   /// insert renChatterPost;
                   renChatterPost1.add(renChatterPost);
                   }
               }

           cntRenewal++;
           }
       
       System.Debug('+++++++++cntRenewal'+ cntRenewal  + renChatterPost1);    
       if (renChatterPost1.size()>0)
           Insert renChatterPost1;

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
             System.debug('Ren--------------'+ genRenewalMap.get(ACPRenewalMap.get(acp.Id)));                                                       
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
             }

         if(ren.Projected_Renewal__c != null &&  ren.Id  != null  )  // code changed to refer to ren.Id 20111117
             if(mRen.get(ren.Id).ATTRF_CRV__c != null)
             if (mRen.get(ren.Id).ATTRF_CRV__c  != 0)
                 rp.Projected_Renewal_LC__c = ren.Projected_Renewal__c * (rp.ATTRF_CRV__c/mRen.get(ren.id).ATTRF_CRV__c ); // Changed from acp.ATTRF_CRV__c to rp.ATTRF_CRV__c 20111107
         else 
             rp.Projected_Renewal_LC__c = 0;

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
           // return 'No Error';                   
            }
        //else          
          // return '';                   
                system.debug('33333');
       // }   

     //   catch(Exception e){
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
          
      //      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Exception' + e));
            //ApexPages.addMessage(msg); 
           /// return '';
           
                   system.debug('222222');
        //}
      
      
   }
    global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =
        :BC.getJobId()];
        
        //a.CreatedBy.Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Renewal Generation Batch Process ' + a.Status);
        mail.setPlainTextBody
        ('Renewal generation batch job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        mail.setHtmlBody('Renewal generation batch job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.<br/>Check generated Renewals at  <a href=https://na1.salesforce.com/'+System.Label.Renewals_Tab+'>click here</a>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}