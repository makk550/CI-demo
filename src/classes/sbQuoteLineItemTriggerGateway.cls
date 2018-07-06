/*
 * Test Class = testSbQuoteLineTrigger 
 * Created by = BAJPI01
 * 
*/
public class sbQuoteLineItemTriggerGateway {
    
    public static Set<Id> sbQuoteIds = new Set<Id>();
    public static Map<Id,SBQQ__Quote__c> sbQuoteMap;        //map to store Quote id, and quote details in a map
    public static Map<Id,Map<Id,Integer>> accountProductSeatCountMap;
    public static Map<Id,Map<Id,Integer>> accountAssetProductSeatCountMap;
    static Map<Id,List<Asset>> prodAssetMap;
    static Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionMap;
    static Map<Id,List<Asset>> gpDunsprodAssetMap;
    static Set<String> gpDunsSet = new Set<String>();
    static Set<Id> blankOrNineNineAccSet = new Set<Id>();
    static Map<Id,List<SBQQ__Subscription__c>> gpDunsprodSubscriptionMap;
    public static Map<String,Map<Id,Integer>> gpDunsProdSeatCountMap;
    public static Map<String,Map<Id,Integer>> gpDunsAssetProdSeatCountMap;
    static List<SBQQ__Subscription__c> subscriptionList;
    static List<Asset> assetList;
    static List<SBQQ__Subscription__c> SubscListForAccGpBlankOrNineNine;
    static List<SBQQ__Subscription__c> SubscListForAccGpNotBlank;
    static List<Asset> assetListForAccGpNotBlank;
    static List<Asset> assetListForAccGpBlankOrNineNine;
    
    public static void loadSBQuoteLineItemBulkValues(){
        
        List<SBQQ__QuoteLine__c> listTrigger;
        Map<id,Sobject> mapSbqLines;                                                    //list of Quote Line Item Trigger, for loop in handler classes should be of
        //type SObject, hence we need to define and declare it on the top.
        
        SBQQ__QuoteLine__c oldSbQli;
        Map<Id,List<SBQQ__Subscription__c>> accountSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
        Map<Id,List<Asset>> accountAssetMap = new Map<Id,List<Asset>>();
        Map<String,List<SBQQ__Subscription__c>> gpDunsSubscriptionMap = new Map<String,List<SBQQ__Subscription__c>>();
        Map<String,List<Asset>> gpDunsAssetMap = new Map<String,List<Asset>>();
        
        if(Trigger.isInsert||Trigger.isUpdate){
            listTrigger = trigger.new;
            
        }
        else if(Trigger.isDelete)
            listTrigger = trigger.old;
        
        if(trigger.isAfter&&Trigger.isUpdate)
            mapSbqLines =trigger.oldMap;
        

          
        
        if(Trigger.isBefore){
            if(Trigger.isInsert||Trigger.isUpdate){
                for(SBQQ__QuoteLine__c sbqli:listTrigger){
                    sbQuoteIds.add(sbqli.SBQQ__Quote__c);
                }
            }
        }
        
        //need to query sb quote, to get account ID and GP number.
        if(sbQuoteIds!=null && sbQuoteIds.size()>0){
            if(sbQuoteMap==null)
	            sbQuoteMap = new Map<Id,SBQQ__Quote__c>([Select Id,SBQQ__Account__c,SBQQ__Account__r.GU_Duns_Number__c from SBQQ__Quote__c
                                                     where ID in:sbQuoteIds]);
        }
        
        //for those quotes, forming a map of accounts, and its' corresponding GP Number, and
        //creating a set of GP Numbers, gpDunsSet, to query Subscriptions and Assets.
        if(sbQuoteMap!=null && sbQuoteMap.size()>0){
            for(Id quoteid:sbQuoteMap.keySet()){
                SBQQ__Quote__c quote = sbQuoteMap.get(quoteid);
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
        
        //if there are subscriptions, creates a Map of Account and related subscription list.
        //and a map of <GP Duns,Related Subscription List>
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
        
        //if there are Assets, creates a Map of Account and related Assets list.
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
        
        //from the Map of Account and related Subscription Record,
        //for each account - takes the subscription list and forms a map of product and subscription list.
        //from the map of product,subscription list - forms a map of product and seat count.
        //puts that product,seat count map to form a map of (account,<product,seatcount>) map. 
        if(accountSubscriptionMap!=null && accountSubscriptionMap.size()>0){
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
        if(gpDunsSubscriptionMap!=null && gpDunsSubscriptionMap.size()>0){
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
        if(accountAssetMap!=null && accountAssetMap.size()>0){
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
        if(gpDunsAssetMap!=null && gpDunsAssetMap.size()>0){
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
    }
    
    
    
    public static Map<Id,Integer> populateProductSeatCount(Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionDetailMap){
        
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
    
    public static Map<Id,Integer> populateAssetProductSeatCount(Map<Id,List<Asset>> prodAssetDetailMap){
        
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
    
}