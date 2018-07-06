/*
 * Class for US419871 
 * Called from a rest resource class, cz_PlugExtension, which
 * in turn is called from a custom script -from SF CPQ Quote line editor
 * page.
 * Created by BAJPI01
 * 
*/
public class cz_GlobalSeatCountExtension {
    
    
    static Set<String> gpDunsSet = new Set<String>();		//set of Duns number when it's not blank or 999999999
    static Set<Id> blankOrNineNineAccSet = new Set<Id>();	//set of Account Ids having GP=Blank or 999999999
    static List<SBQQ__Subscription__c> SubscListForAccGpBlankOrNineNine;
    static List<SBQQ__Subscription__c> SubscListForAccGpNotBlank;
    static List<Asset> assetListForAccGpNotBlank;			//asset list of non blank/non 999 account
    static List<Asset> assetListForAccGpBlankOrNineNine;	//asset list of Blank/999 Account
    static List<SBQQ__Subscription__c> subscriptionList;	//combined list of subscription - includes one for Blank/99 GP and Non (Blank/999) Acc.
    static List<Asset> assetList;							//combined list of asset - includes one for Blank/99 GP and Non (Blank/999) Acc.
    
    
    static Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionMap;
	static Map<Id,Map<Id,Integer>> accountProductSeatCountMap;
    
    static Map<String,Map<Id,Integer>> gpDunsProdSeatCountMap;
    static Map<Id,List<SBQQ__Subscription__c>> gpDunsprodSubscriptionMap;
    
    static Map<Id,List<Asset>> prodAssetMap;
    static Map<Id,Map<Id,Integer>> accountAssetProductSeatCountMap;
    
    static Map<Id,List<Asset>> gpDunsprodAssetMap;
    static Map<String,Map<Id,Integer>> gpDunsAssetProdSeatCountMap;
    
    public static List<SBQQ__QuoteLine__c> getSeatCountForQuoteLines(List<SBQQ__QuoteLine__c> sbQuoteLineList){

        //sunji03 - US466300 
        Set<ID> products = new Set<ID>();
        Map<Id,Product2> productMapForGlbalSeatCountCalculation;

        Set<Id> sbQuoteIds = new Set<Id>();			//to get the quote id's for the quote line items being saved.
        Map<Id,SBQQ__Quote__c> sbQuoteMap;			//map to store Quote id, and quote details in a map
        
        //if line item size>0
        if(sbQuoteLineList!=null && sbQuoteLineList.size()>0){
            for(SBQQ__QuoteLine__c sbqli:sbQuoteLineList){
                sbQuoteIds.add(sbqli.SBQQ__Quote__c);
                //sunji03 - US466300 
                products.add(sbqli.SBQQ__Product__c);
            }
        }
        
        //if quote id's exist for the list of line items, get the quote details
        if(sbQuoteIds.size()>0){
            sbQuoteMap = new Map<Id,SBQQ__Quote__c>([Select Id,SBQQ__Account__c,SBQQ__Account__r.GU_Duns_Number__c from SBQQ__Quote__c
                                                     where ID in:sbQuoteIds]);
        }      

        //sunji03 - US466300 
        if (products.size() > 0)
        {
           productMapForGlbalSeatCountCalculation = new Map<Id,Product2>([select id, Volume_Price_Curve_Quantity_Criteria__c from product2 where id in:products and 
            Volume_Price_Curve_Quantity_Criteria__c =: Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats]);
        }  

        system.debug('productMapForGlbalSeatCountCalculation: ' + productMapForGlbalSeatCountCalculation);

        //sunji03 - US466300: only when there is at least one item in the item list, will go through global parent seat count caculation, otherwise, return 0
        if (productMapForGlbalSeatCountCalculation != null && productMapForGlbalSeatCountCalculation.size() > 0)
        {
            //for those quotes, forming a map of accounts, and its' corresponding GP Number, and
            //creating a set of GP Numbers, gpDunsSet, to query Subscriptions and Assets.
            createAccountGPSet(sbQuoteMap);
            
            //fetch subscription and asset records for the set of 
            fetchSubscriptionAndAssetRecords();
            
            //populate combined list of susbscription and asset, for different conditions
            populateCombinedList();
            
            //populate a Map of Account and related subscription/asset list.
            //and a map of <GP Duns,Related Subscription/asset List>
            populateSubscriptionMethod();
            populateAssetMethod();
            
            if(sbQuoteLineList!=null && sbQuoteLineList.size()>0){
               sbQuoteLineList = fetchGPSeatCount(sbQuoteLineList,sbQuoteMap,productMapForGlbalSeatCountCalculation);
            }
        }
        else 
        {
            //No item needs global seat count calculation, set values to 0 and return;
            for(SBQQ__QuoteLine__c quoteoli:sbQuoteLineList)
            {
                quoteoli.Global_Parent_Seat_Count__c = 0;
                quoteoli.GP_Seat_Count_System_Generated__c = 0;
            }
        }

        return sbQuoteLineList;
        
    }
    
    @TestVisible
    private static void createAccountGPSet(Map<Id,SBQQ__Quote__c> tempSbQuoteMap){
        
        //for those quotes, forming a map of accounts, and its' corresponding GP Number, and
        //creating a set of GP Numbers, gpDunsSet, to query Subscriptions and Assets.
        if(tempSbQuoteMap!=null && tempSbQuoteMap.size()>0){
            for(Id quoteid:tempSbQuoteMap.keySet()){
                SBQQ__Quote__c quote = tempSbQuoteMap.get(quoteid);
                if(quote!=null){
                    if(String.isNotBlank(quote.SBQQ__Account__r.GU_Duns_Number__c) && quote.SBQQ__Account__r.GU_Duns_Number__c!='999999999'){
                        gpDunsSet.add(quote.SBQQ__Account__r.GU_Duns_Number__c);                    
                    }
                    else{
                        blankOrNineNineAccSet.add(quote.SBQQ__Account__c);
                    }
                }                    
            } 
        }
    }
	
    
    @TestVisible
    private static void fetchSubscriptionAndAssetRecords(){
        //queries subscription and asset objects, for those GP numbers.
        //for Subscriptions, only for those records, which have been provisioned - or in other words, have an Instance ID,
        //and having an end date>=today, and is not a bundle product.
        //For Assets - should not be a bundle product, for GP!=999999999 or Blank/Null.
        if(gpDunsSet!=null && gpDunsSet.size()>0){
            if(SubscListForAccGpNotBlank==null){
                SubscListForAccGpNotBlank = new List<SBQQ__Subscription__c>();
                
                SubscListForAccGpNotBlank = [SELECT id,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__Product__r.SBQQ__Component__c,Instance_Id__c,
                                             SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Quantity__c,SBQQ__Account__c,Global_Parent_Account_Number__c
                                             from SBQQ__Subscription__c where 
                                             Global_Parent_Account_Number__c IN:gpDunsSet AND SBQQ__Product__c!=null and SBQQ__EndDate__c>=:System.today()
                                             AND SBQQ__Product__r.SBQQ__Component__c=TRUE AND Instance_Id__c!=NULL AND Instance_Id__c!=''];
                
            }
            
            
            if(assetListForAccGpNotBlank==null){
                assetListForAccGpNotBlank = new List<Asset>();
                assetListForAccGpNotBlank = [SELECT id,Product2Id,Quantity,Name,AccountId,Global_Parent_Account_Number__c
                                             from Asset where Global_Parent_Account_Number__c IN:gpDunsSet
                                             AND Product2Id!=null AND Product2.SBQQ__Component__c=TRUE];
                System.debug('========enter asset');
            }
            
            
        }
        
        //queries subscription and asset objects, for those GP numbers.
        //for Subscriptions, only for those records, which have been provisioned - or in other words, have an Instance ID,
        //and having an end date>=today, and is not a bundle product.
        //For Assets - should not be a bundle product, for GP=999999999 or Blank/Null
        if(blankOrNineNineAccSet!=null && blankOrNineNineAccSet.size()>0){
            if(SubscListForAccGpBlankOrNineNine==null){
                SubscListForAccGpBlankOrNineNine = new List<SBQQ__Subscription__c>();
                
                SubscListForAccGpBlankOrNineNine = [SELECT id,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__Product__r.SBQQ__Component__c,Instance_Id__c,
                                                    SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Quantity__c,SBQQ__Account__c,Global_Parent_Account_Number__c
                                                    from SBQQ__Subscription__c where 
                                                    SBQQ__Account__c IN:blankOrNineNineAccSet AND SBQQ__Product__c!=null and SBQQ__EndDate__c>=:System.today()
                                                    AND SBQQ__Product__r.SBQQ__Component__c=TRUE AND Instance_Id__c!=NULL AND Instance_Id__c!=''];
                
            }
            
            if(assetListForAccGpBlankOrNineNine==null){
                assetListForAccGpBlankOrNineNine = new List<Asset>();
                assetListForAccGpBlankOrNineNine = [SELECT id,Product2Id,Quantity,Name,AccountId,Global_Parent_Account_Number__c
                                                    from Asset where AccountId IN:blankOrNineNineAccSet
                                                    AND Product2Id!=null AND Product2.SBQQ__Component__c=TRUE];
            }
            
        }
    }
    
    @TestVisible
    private static void populateCombinedList(){
        if(subscriptionList==null){
            subscriptionList = new List<SBQQ__Subscription__c>();
            if(SubscListForAccGpNotBlank!=null && SubscListForAccGpNotBlank.size()>0)
                subscriptionList.addAll(SubscListForAccGpNotBlank);
            if(SubscListForAccGpBlankOrNineNine!=null && SubscListForAccGpBlankOrNineNine.size()>0)
                subscriptionList.addAll(SubscListForAccGpBlankOrNineNine);
        }
        if(assetList==null){
            assetList = new List<Asset>();
            if(assetListForAccGpNotBlank!=null && assetListForAccGpNotBlank.size()>0)
                assetList.addAll(assetListForAccGpNotBlank);
            if(assetListForAccGpBlankOrNineNine!=null && assetListForAccGpBlankOrNineNine.size()>0)
                assetList.addAll(assetListForAccGpBlankOrNineNine);
        }
    }
    
    @TestVisible
    private static void populateSubscriptionMethod(){
        
        Map<Id,List<SBQQ__Subscription__c>> accountSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
        Map<String,List<SBQQ__Subscription__c>> gpDunsSubscriptionMap = new Map<String,List<SBQQ__Subscription__c>>();
        
        if(subscriptionList!=null && subscriptionList.size()>0){
            for(SBQQ__Subscription__c subsc:subscriptionList){
                if(accountSubscriptionMap.containsKey(subsc.SBQQ__Account__c)){
                    accountSubscriptionMap.get(subsc.SBQQ__Account__c).add(subsc);
                }
                else{
                    accountSubscriptionMap.put(subsc.SBQQ__Account__c,new List<SBQQ__Subscription__c> {subsc});
                }
                if(String.isNotBlank(subsc.Global_Parent_Account_Number__c) && subsc.Global_Parent_Account_Number__c!='999999999'){
                    if(gpDunsSubscriptionMap.containsKey(subsc.Global_Parent_Account_Number__c)){
                        gpDunsSubscriptionMap.get(subsc.Global_Parent_Account_Number__c).add(subsc);
                    }
                    else{
                        gpDunsSubscriptionMap.put(subsc.Global_Parent_Account_Number__c,new List<SBQQ__Subscription__c> {subsc});
                    }
                }               
            }            
        }
        
        if(accountSubscriptionMap!=null && accountSubscriptionMap.size()>0)
            populateseatCountPerAccount(accountSubscriptionMap);
        
        if(gpDunsSubscriptionMap!=null && gpDunsSubscriptionMap.size()>0)
            populateSeatCountPerGPDuns(gpDunsSubscriptionMap);
        
    }
    
    @TestVisible
    private static void populateAssetMethod(){
        
        Map<Id,List<Asset>> accountAssetMap = new Map<Id,List<Asset>>();
        Map<String,List<Asset>> gpDunsAssetMap = new Map<String,List<Asset>>();
        
        if(assetList!=null && assetList.size()>0){
            for(Asset assetRecord:assetList){
                if(accountAssetMap.containsKey(assetRecord.AccountId)){
                    accountAssetMap.get(assetRecord.AccountId).add(assetRecord);
                }
                else{
                    accountAssetMap.put(assetRecord.AccountId,new List<Asset> {assetRecord});
                }
                if(String.isNotBlank(assetRecord.Global_Parent_Account_Number__c) && assetRecord.Global_Parent_Account_Number__c!='999999999'){
                    if(gpDunsAssetMap.containsKey(assetRecord.Global_Parent_Account_Number__c)){
                        gpDunsAssetMap.get(assetRecord.Global_Parent_Account_Number__c).add(assetRecord);
                    }
                    else{
                        gpDunsAssetMap.put(assetRecord.Global_Parent_Account_Number__c,new List<Asset> {assetRecord});
                    }
                }               
            }            
        }
        
        if(accountAssetMap!=null && accountAssetMap.size()>0)
            populateAssetseatCountPerAccount(accountAssetMap);
        
        if(gpDunsAssetMap!=null && gpDunsAssetMap.size()>0)
            populateAssetSeatCountPerGPDuns(gpDunsAssetMap);
        
    }
    
    
    //from the Map of Account and related Subscription Record,
    //for each account - takes the subscription list and forms a map of product and subscription list.
    //from the map of product,subscription list - forms a map of product and seat count.
    //puts that product,seat count map to form a map of (account,<product,seatcount>) map. 
    @TestVisible
    private static void populateseatCountPerAccount(Map<Id,List<SBQQ__Subscription__c>> accountSubscriptionMap){
        
        system.debug('---acc subsc map---');
        accountProductSeatCountMap = new Map<Id,Map<Id,Integer>>();
        for(Id accid:accountSubscriptionMap.keySet()){
            List<SBQQ__Subscription__c> accSubscList = accountSubscriptionMap.get(accid);
            prodSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
            Map<Id,Integer> prodSeatCountMap = new Map<Id,Integer>();
            if(accSubscList!=null && accSubscList.size()>0){
                for(SBQQ__Subscription__c subsc:accSubscList){
                    if(prodSubscriptionMap.containsKey(subsc.SBQQ__Product__c)){
                        prodSubscriptionMap.get(subsc.SBQQ__Product__c).add(subsc);
                    }
                    else{
                        prodSubscriptionMap.put(subsc.SBQQ__Product__c,new List<SBQQ__Subscription__c> {subsc});
                    }
                }
                if(prodSubscriptionMap!=null && prodSubscriptionMap.size()>0){
                    prodSeatCountMap = populateProductSeatCount(prodSubscriptionMap);
                }
            }
            accountProductSeatCountMap.put(accid,prodSeatCountMap);
        }
        system.debug('---acc prod seat count----'+accountProductSeatCountMap);
    }
    
    
    
    //from the Map of GP Duns Number and related Subscription Record,
    //for each GP Duns - takes the subscription list and forms a map of product and subscription list.
    //from the map of product,subscription list - forms a map of product and seat count.
    //puts that product,seat count map to form a map of (GP Duns Number,<product,seatcount>) map. 
    @TestVisible private static void populateSeatCountPerGPDuns(Map<String,List<SBQQ__Subscription__c>> gpDunsSubscriptionMap){
        gpDunsProdSeatCountMap = new Map<String,Map<Id,Integer>>();
        for(String gpDuns:gpDunsSubscriptionMap.keySet()){
            List<SBQQ__Subscription__c> gpDunsSubscList = gpDunsSubscriptionMap.get(gpDuns);
            gpDunsprodSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
            Map<Id,Integer> prodSeatCountMap = new Map<Id,Integer>();
            if(gpDunsSubscList!=null && gpDunsSubscList.size()>0){
                for(SBQQ__Subscription__c subsc:gpDunsSubscList){
                    if(gpDunsprodSubscriptionMap.containsKey(subsc.SBQQ__Product__c)){
                        gpDunsprodSubscriptionMap.get(subsc.SBQQ__Product__c).add(subsc);
                    }
                    else{
                        gpDunsprodSubscriptionMap.put(subsc.SBQQ__Product__c,new List<SBQQ__Subscription__c> {subsc});
                    }
                }
                if(gpDunsprodSubscriptionMap!=null && gpDunsprodSubscriptionMap.size()>0){
                    prodSeatCountMap = populateProductSeatCount(gpDunsprodSubscriptionMap);
                }
            }
            gpDunsProdSeatCountMap.put(gpDuns,prodSeatCountMap);
        }
    }
    
    
    //from the Map of Account and related Asset Record,
    //for each account - takes the Asset list and forms a map of product and Asset list.
    //from the map of product,Asset list - forms a map of product and seat count.
    //puts that product,seat count map to form a map of (account,<product,seatcount>) map.
    @TestVisible
    private static void populateAssetseatCountPerAccount(Map<Id,List<Asset>> accountAssetMap){
        accountAssetProductSeatCountMap = new Map<Id,Map<Id,Integer>>();
        for(Id accid:accountAssetMap.keySet()){
            List<Asset> accAssetList = accountAssetMap.get(accid);
            prodAssetMap = new Map<Id,List<Asset>>();
            Map<Id,Integer> prodAssetSeatCountMap = new Map<Id,Integer>();
            if(accAssetList!=null && accAssetList.size()>0){
                for(Asset assetRecord:accAssetList){
                    if(prodAssetMap.containsKey(assetRecord.Product2Id)){
                        prodAssetMap.get(assetRecord.Product2Id).add(assetRecord);
                    }
                    else{
                        prodAssetMap.put(assetRecord.Product2Id,new List<Asset> {assetRecord});
                    }
                }
                if(prodAssetMap!=null && prodAssetMap.size()>0){
                    prodAssetSeatCountMap = populateAssetProductSeatCount(prodAssetMap);
                }
            }
            accountAssetProductSeatCountMap.put(accid,prodAssetSeatCountMap);
        }
    }
    
    //from the Map of GP Duns Number and related Asset Record,
    //for each GP Duns - takes the Asset list and forms a map of product and Asset list.
    //from the map of product,Asset list - forms a map of product and seat count.
    //puts that product,seat count map to form a map of (GP Duns Number,<product,seatcount>) map.
    @TestVisible
    private static void populateAssetSeatCountPerGPDuns(Map<String,List<Asset>> gpDunsAssetMap){
        gpDunsAssetProdSeatCountMap = new Map<String,Map<Id,Integer>>();
        for(String gpDuns:gpDunsAssetMap.keySet()){
            List<Asset> gpDunsAssetList = gpDunsAssetMap.get(gpDuns);
            gpDunsprodAssetMap = new Map<Id,List<Asset>>();
            Map<Id,Integer> prodSeatCountMap = new Map<Id,Integer>();
            if(gpDunsAssetList!=null && gpDunsAssetList.size()>0){
                for(Asset assetRecord:gpDunsAssetList){
                    if(gpDunsprodAssetMap.containsKey(assetRecord.Product2Id)){
                        gpDunsprodAssetMap.get(assetRecord.Product2Id).add(assetRecord);
                    }
                    else{
                        gpDunsprodAssetMap.put(assetRecord.Product2Id,new List<Asset> {assetRecord});
                    }
                }
                if(gpDunsprodAssetMap!=null && gpDunsprodAssetMap.size()>0){
                    prodSeatCountMap = populateAssetProductSeatCount(gpDunsprodAssetMap);
                }
            }
            gpDunsAssetProdSeatCountMap.put(gpDuns,prodSeatCountMap);
        }
    }
    
    
    @TestVisible
    private static Map<Id,Integer> populateProductSeatCount(Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionDetailMap){
        
        Map<Id,Integer> prodSeatCount = new Map<Id,Integer>();
        List<SBQQ__Subscription__c> tempSubscriptionList;
        Integer totalQuantity;
        
        
        if(prodSubscriptionDetailMap!=null && prodSubscriptionDetailMap.size()>0){
            
            for(Id product:prodSubscriptionDetailMap.keySet()){
                totalQuantity = 0;
                tempSubscriptionList = new List<SBQQ__Subscription__c>();
                tempSubscriptionList = prodSubscriptionDetailMap.get(product);
                if(tempSubscriptionList.size()>0){
                    
                    for(SBQQ__Subscription__c tempSubscription : tempSubscriptionList){
                        if(totalQuantity==null)
                            totalQuantity = Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                        else{
                            if(tempSubscription.SBQQ__Quantity__c!=null)
                                totalQuantity += Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                        }                        
                    }
                }
                prodSeatCount.put(product,totalQuantity);
            }
        }
        
        return prodSeatCount;        
    }
    
    @TestVisible
    private static Map<Id,Integer> populateAssetProductSeatCount(Map<Id,List<Asset>> prodAssetDetailMap){
        
        Map<Id,Integer> prodAssetSeatCount = new Map<Id,Integer>();
        List<Asset> tempAssetList;
        Integer totalQuantity;
        
        
        if(prodAssetDetailMap!=null && prodAssetDetailMap.size()>0){
            
            for(Id product:prodAssetDetailMap.keySet()){
                totalQuantity = 0;
                tempAssetList = new List<Asset>();
                tempAssetList = prodAssetDetailMap.get(product);
                if(tempAssetList.size()>0){
                    
                    for(Asset tempAsset : tempAssetList){
                        if(totalQuantity==null)
                            totalQuantity = Integer.valueOf(tempAsset.Quantity);
                        else{
                            if(tempAsset.Quantity!=null)
                                totalQuantity += Integer.valueOf(tempAsset.Quantity);
                        }                        
                    }
                }
                prodAssetSeatCount.put(product,totalQuantity);
            }
        }
        
        return prodAssetSeatCount;        
    }
    
    @TestVisible
    private static List<SBQQ__QuoteLine__c> fetchGPSeatCount(List<SBQQ__QuoteLine__c> tempQuoteLineList, Map<Id,SBQQ__Quote__c> sbQuoteMap, Map<Id,product2> productMapForGlbalSeatCountCalculation){
        
        for(SBQQ__QuoteLine__c quoteoli:tempQuoteLineList){
            Id AccountId;
            Map<Id,Integer> prodSeatCount = new Map<Id,Integer>();
            Map<Id,Integer> prodAssetSeatCount = new Map<Id,Integer>();
            Integer seatcount;
            String gpDunsNumber;
            
            //sunji03 - US466300 
            string VolumePriceCurveQuantityCriteria = '';
            if (productMapForGlbalSeatCountCalculation != null && productMapForGlbalSeatCountCalculation.size() > 0 && productMapForGlbalSeatCountCalculation.get(quoteoli.SBQQ__Product__c) != null)
            {
               VolumePriceCurveQuantityCriteria = productMapForGlbalSeatCountCalculation.get(quoteoli.SBQQ__Product__c).Volume_Price_Curve_Quantity_Criteria__c;
            }

            system.debug(' sun is ' + quoteoli);
            system.debug(' sun is here ' + VolumePriceCurveQuantityCriteria);

            //sunji03 - US466300 
            if (VolumePriceCurveQuantityCriteria == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats)
            {
                if(sbQuoteMap!=null && sbQuoteMap.size()>0){
                    if(sbQuoteMap.containsKey(quoteoli.SBQQ__Quote__c)){
                        if(sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c!=null){
                            AccountId = sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c;
                            gpDunsNumber = sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__r.GU_Duns_Number__c;
                        }
                    }            
                }
                if((String.isNotBlank(gpDunsNumber) && gpDunsNumber=='999999999')||String.isBlank(gpDunsNumber)){
                    if(accountProductSeatCountMap!=null && accountProductSeatCountMap.size()>0){
                        if(AccountId!=null && accountProductSeatCountMap.containsKey(AccountId)){
                            prodSeatCount = accountProductSeatCountMap.get(AccountId);
                            if(prodSeatCount!=null && prodSeatCount.size()>0){
                                if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                                    seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                                    quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                                    if(quoteoli.Global_Parent_Seat_Count__c==null)
                                        quoteoli.Global_Parent_Seat_Count__c = seatcount;
                                }
                            }
                        }
                    }
                    if(accountAssetProductSeatCountMap!=null && accountAssetProductSeatCountMap.size()>0){
                        if(AccountId!=null && accountAssetProductSeatCountMap.containsKey(AccountId)){
                            prodAssetSeatCount = accountAssetProductSeatCountMap.get(AccountId);
                            if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                                if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                                    seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                                    quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                                    if(quoteoli.Global_Parent_Seat_Count__c==null)
                                        quoteoli.Global_Parent_Seat_Count__c = seatcount;
                                }
                            }
                        }
                    }
                }
                else if(String.isNotBlank(gpDunsNumber) && gpDunsNumber!='999999999'){
                    if(gpDunsProdSeatCountMap!=null && gpDunsProdSeatCountMap.size()>0){
                        if(gpDunsProdSeatCountMap.containsKey(gpDunsNumber)){
                            prodSeatCount = gpDunsProdSeatCountMap.get(gpDunsNumber);
                            if(prodSeatCount!=null && prodSeatCount.size()>0){
                                if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                                    seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                                    quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                                    if(quoteoli.Global_Parent_Seat_Count__c==null)
                                        quoteoli.Global_Parent_Seat_Count__c = seatcount;
                                }
                            }
                        }
                    }
                    if(gpDunsAssetProdSeatCountMap!=null && gpDunsAssetProdSeatCountMap.size()>0){
                        if(gpDunsAssetProdSeatCountMap.containsKey(gpDunsNumber)){
                            prodAssetSeatCount = gpDunsAssetProdSeatCountMap.get(gpDunsNumber);
                            if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                                if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                                    seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                                    quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                                    if(quoteoli.Global_Parent_Seat_Count__c==null)
                                        quoteoli.Global_Parent_Seat_Count__c = seatcount;
                                }
                            }
                        }
                    }
                }
                
                if(quoteoli.Global_Parent_Seat_Count__c==null)
                    quoteoli.Global_Parent_Seat_Count__c = 0;
                if(quoteoli.GP_Seat_Count_System_Generated__c==null)
                    quoteoli.GP_Seat_Count_System_Generated__c = 0;
            }
            else //if (VolumePriceCurveQuantityCriteria = 'Quote Only' || VolumePriceCurveQuantityCriteria == ''
            {
                quoteoli.Global_Parent_Seat_Count__c = 0;
                quoteoli.GP_Seat_Count_System_Generated__c = 0;
            }

        }
        
        system.debug(' sun is tempQuoteLineList ' + tempQuoteLineList);

        return tempQuoteLineList;
    }

}