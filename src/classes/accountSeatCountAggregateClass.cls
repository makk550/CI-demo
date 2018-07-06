/*
 * Test Class = accountSeatCountAggregateTestClass 
 * Created by = BAJPI01
 * Coverage = 95%
 * 
*/
public class accountSeatCountAggregateClass {

    
    @TestVisible
    Private string AccountId;                                   //id of account tied to the quote
    
    @TestVisible
    Private String pageURL;                                 //URL of the page
    
    @TestVisible
    Private Account accRecord = new Account();              //Account Record related to the quote.
    
    public String accountName {get;set;}                    //account name
    public String gpNumber {get;set;}                       //GP Number of account
    public Boolean renderGPSubscriptionDetails {get;set;}       //boolean to render the subcription section if subscription records exist for the GP Number
    public Boolean renderGPAssetDetails {get;set;}          //boolean to render the asset section if asset records exist for the GP Number
    public List<productAggregateClass> productAggregateList{get;set;}       //product aggregate list, to display on page
    public List<productAssetAggregateClass> productAssetAggregateList{get;set;}     //product aggregate list, to display on page
    public List<accountSubscriptionClass> accountSubscriptionList{get;set;}     //for each account, shows a detailed information about each prod, as per instance id.
    public List<accountAssetClass> accountAssetList{get;set;}
    
    public accountSeatCountAggregateClass(){
        system.debug('--entered---');
        renderGPSubscriptionDetails = false;
        pageURL = ApexPages.currentPage().getUrl();
        system.debug('----pageURL-----'+pageURL);
        
        
        //this part checks if the account value exists or not, and gives appropriate messages to the user
        //if it exists and user can access it, it calls two methods to fetch subscription and assets and does
        //all the calculations and processing through those methods
        if(pageURL.containsIgnoreCase('accId') && (String.isNotBlank(ApexPages.currentPage().getParameters().get('accId')))){
            AccountId = ApexPages.currentPage().getParameters().get('accId');
            system.debug('----acc id----'+AccountId);
            if(String.isNotBlank(AccountId) && AccountId!='null'){
                accRecord = [select Name,GU_Duns_Number__c from Account where id=:AccountId];
                if(accRecord!=null){
                    accountName = accRecord.Name;
                    gpNumber = accRecord.GU_DUNS_NUMBER__c;
                    fetchSubscriptionDetailsforGP();    //to fetch subscription details
                    fetchAssetDetailsforGP();           //to fetch asset details.
                }
                else{
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Account exists for this quote.'));
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Account exists for this quote.'));
            }
                                                  
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'You do not have access to this account.'));
        }
    }
    
    //queries subscription objects, for those GP numbers.
    //for Subscriptions, only for those records, which have been provisioned - or in other words, have an Instance ID,
    //and having an end date>=today, and is not a bundle product.
    public void fetchSubscriptionDetailsforGP(){
        
        List<SBQQ__Subscription__c> subscriptionList = new List<SBQQ__Subscription__c>();
        Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
        Map<Id,List<SBQQ__Subscription__c>> accountSubscriptionMap = new Map<Id,List<SBQQ__Subscription__c>>();
        
        
        //for Not Blank and Non 999 GP number, fetches all subscription records for the given GP.
        if(String.isNotBlank(gpNumber) && gpNumber!='999999999'){
            system.debug('---non 9999-----');
            subscriptionList = returnSubscriptionDetails(gpNumber);
        }   //fetches Subcription details for the given account, if GP is blank or 999....
        else if((String.isNotBlank(gpNumber) && gpNumber=='999999999')||String.isBlank(gpNumber)){
            system.debug('--- 9999 or blank-----');
            subscriptionList = returnAccSubscriptionDetails(gpNumber,AccountId);
        }
        
        //for the list of subscription records that are fetched, forms a map of 
        //Product and Related Subscriptions - prodSubscriptionMap.
        //and a map of account and related subcriptions - accountSubscriptionMap
        if(subscriptionList!=null && subscriptionList.size()>0){
            renderGPSubscriptionDetails = true;
            for(SBQQ__Subscription__c subsc : subscriptionList){
                
                if(prodSubscriptionMap.containsKey(subsc.SBQQ__Product__c)){
                    prodSubscriptionMap.get(subsc.SBQQ__Product__c).add(subsc);
                }
                else{
                    prodSubscriptionMap.put(subsc.SBQQ__Product__c,new List<SBQQ__Subscription__c> {subsc});
                }
                
                if(accountSubscriptionMap.containsKey(subsc.SBQQ__Account__c)){
                    accountSubscriptionMap.get(subsc.SBQQ__Account__c).add(subsc);
                }
                else{
                    accountSubscriptionMap.put(subsc.SBQQ__Account__c,new List<SBQQ__Subscription__c> {subsc});
                }
                
            }
            
            //calls a method to populate the seat count per product, from the
            //product subcription Map.
            if(prodSubscriptionMap!=null && prodSubscriptionMap.size()>0){
                populateProductSeatCount(prodSubscriptionMap);
            }
            
            //calls a method to populate the seat count per product and instance ID for each account
            // from the account subcription Map.
            if(accountSubscriptionMap!=null && accountSubscriptionMap.size()>0){
                populateAccountSubscriptionDetails(accountSubscriptionMap);
            }
            
        }
        else{
            renderGPSubscriptionDetails = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Subscriptions exists for the given account.'));
        }                
    }
    
    //queries asset objects, for those GP numbers.
    public void fetchAssetDetailsforGP(){
        
        List<Asset> assetList = new List<Asset>();
        Map<Id,List<Asset>> prodAssetMap = new Map<Id,List<Asset>>();
        Map<Id,List<Asset>> accountAssetMap = new Map<Id,List<Asset>>();
        
        //for Not Blank and Non 999 GP number, fetches all asset records for the given GP.
        if(String.isNotBlank(gpNumber) && gpNumber!='999999999'){
            system.debug('---non 9999-----');
            assetList = returnAssetDetails(gpNumber);
        }   //fetches asset details for the given account, if GP is blank or 999....
        else if((String.isNotBlank(gpNumber) && gpNumber=='999999999')||String.isBlank(gpNumber)){
            system.debug('--- 9999 or blank-----');
            assetList = returnAccAssetDetails(gpNumber,AccountId);
        }
        
        //for the list of asset records that are fetched, forms a map of 
        //Product and Related assets - prodAssetMap.
        //and a map of account and related assets - accountAssetMap
        if(assetList!=null && assetList.size()>0){
            renderGPAssetDetails = true;
            for(Asset assetRecord : assetList){
                
                if(prodAssetMap.containsKey(assetRecord.Product2Id)){
                    prodAssetMap.get(assetRecord.Product2Id).add(assetRecord);
                }
                else{
                    prodAssetMap.put(assetRecord.Product2Id,new List<Asset> {assetRecord});
                }
                
                if(accountAssetMap.containsKey(assetRecord.AccountId)){
                    accountAssetMap.get(assetRecord.AccountId).add(assetRecord);
                }
                else{
                    accountAssetMap.put(assetRecord.AccountId,new List<Asset> {assetRecord});
                }
            }
            
            //calls a method to populate the seat count per product, from the
            //product assets Map.
            if(prodAssetMap!=null && prodAssetMap.size()>0){
                populateProductAssetSeatCount(prodAssetMap);
            }
            
            //calls a method to populate the seat count per product for each account, from the
            //account asset Map.
            if(accountAssetMap!=null && accountAssetMap.size()>0){
                system.debug('----acc asset map----'+accountAssetMap.size());
                populateAccountAssetDetails(accountAssetMap);
            }
            
        }
        else{
            renderGPAssetDetails = false;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Asset exists for the given account.'));
        }
    }
    
    
    //for the product-subscription map, for each product, fetches the subscription list
    //and finds the min start date, max end date and seat count, for that product, and
    //adds it to the wrapper list - productAggregateList, that is displayed on the page.
    @TestVisible
    private void populateProductSeatCount(Map<Id,List<SBQQ__Subscription__c>> prodSubscriptionDetailMap){
        
        List<SBQQ__Subscription__c> tempSubscriptionList = new List<SBQQ__Subscription__c>();
        productAggregateList = new List<productAggregateClass>();
        productAggregateClass prodAggregateVariable;
        string prodName;
        Date minimumStartDate;
        Date maximumEndDate;
        Integer totalQuantity;
        List<Date> startDateList = new List<Date>();
        List<Date> endDateList = new List<Date>();
        
        if(prodSubscriptionDetailMap!=null && prodSubscriptionDetailMap.size()>0){
            
            for(Id product:prodSubscriptionDetailMap.keySet()){
                
                tempSubscriptionList = prodSubscriptionDetailMap.get(product);
                prodAggregateVariable = new productAggregateClass();
                if(tempSubscriptionList.size()>0){
                    prodName = tempSubscriptionList[0].SBQQ__ProductName__c;
                    system.debug('----name-----'+prodName);
                    for(SBQQ__Subscription__c tempSubscription : tempSubscriptionList){
                        
                        if(tempSubscription.SBQQ__StartDate__c!=null)
                            startDateList.add(tempSubscription.SBQQ__StartDate__c);
                        if(tempSubscription.SBQQ__EndDate__c!=null)
                            endDateList.add(tempSubscription.SBQQ__EndDate__c);

                        //sunji03 -US466300,DE361113, only add products with volume discount pricing criteria of "plus global seat count" to the list
                        if (tempSubscription.SBQQ__Product__r.Volume_Price_Curve_Quantity_Criteria__c == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats)
                        {
                            prodAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount = true;
                        }
                        else 
                        {
                            prodAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount = false;
                        }

                        if(totalQuantity==null)
                            totalQuantity = Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                        else{
                            if(tempSubscription.SBQQ__Quantity__c!=null)
                                totalQuantity += Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                        }   
                                          
                    }
                    if(startDateList!=null && startDateList.size()>0){
                        startDateList.sort();
                        minimumStartDate = startDateList.get(0);
                    }
                    
                    if(endDateList!=null && endDateList.size()>0){
                        endDateList.sort();
                        maximumEndDate = endDateList.get(endDateList.size()-1);
                    } 
                } 
                prodAggregateVariable.productName = prodName;
                prodAggregateVariable.startDate = minimumStartDate;
                prodAggregateVariable.endDate = maximumEndDate;
                prodAggregateVariable.quantity = totalQuantity;
                if (prodAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount)
                {
                    productAggregateList.add(prodAggregateVariable);
                }
                startDateList.clear();
                endDateList.clear();
                totalQuantity = 0;
                minimumStartDate = null;
                maximumEndDate = null;
                prodName = '';
            }
        }
        
    }
    
    
    
    //for the account-subscription map, for each account - forms a map of Prod+Instance Id and Subscription List - 
    // called prodInstanceIdSubscriptionMap. For this map, calls a method to populate wrapper list of type
    //accountSubscriptionAggregateClass, that is used to populate another wrapper list - 
    //accountSubscriptionList, that is displayed on the page - it shows the account name, ext ID, and Prod Name,
    //instance ID, min start date, max end date and seat count.
    @TestVisible
    private void populateAccountSubscriptionDetails(Map<Id,List<SBQQ__Subscription__c>> accountSubscriptionMap){
        
        List<SBQQ__Subscription__c> tempSubscList;
        Map<String,List<SBQQ__Subscription__c>> prodInstanceIdSubscriptionMap;
        List<accountSubscriptionAggregateClass> accsubsctempVariable;
        accountSubscriptionClass tempAccSubscVariable;
        String accountName;
        String accExtId;
        String mapKey;
        
        if(accountSubscriptionMap!=null && accountSubscriptionMap.size()>0){
            accountSubscriptionList = new List<accountSubscriptionClass>();
            for(Id accId:accountSubscriptionMap.keySet()){
                tempSubscList = accountSubscriptionMap.get(accId);
                tempAccSubscVariable = new accountSubscriptionClass();
                if(tempSubscList!=null && tempSubscList.size()>0){
                    accountName = tempSubscList[0].SBQQ__Account__r.Name;
                    accExtId = tempSubscList[0].SBQQ__Account__r.Enterprise_ID__c;
                    prodInstanceIdSubscriptionMap = new Map<String,List<SBQQ__Subscription__c>>();
                    for(SBQQ__Subscription__c subsc:tempSubscList){
                        mapKey = subsc.SBQQ__Product__c+subsc.Instance_Id__c;
                        if(prodInstanceIdSubscriptionMap.containsKey(mapKey)){
                            prodInstanceIdSubscriptionMap.get(mapKey).add(subsc);
                        }
                        else{
                            prodInstanceIdSubscriptionMap.put(mapKey,new List<SBQQ__Subscription__c> {subsc});
                        }
                    }
                    //the below method populates for the prod-instance ID and subsc list, a wrapper list of
                    //prod name,min start date, max end date, instance id and seat count.
                    if(prodInstanceIdSubscriptionMap!=null && prodInstanceIdSubscriptionMap.size()>0){
                        accsubsctempVariable = fetchaccSubscRecord(prodInstanceIdSubscriptionMap);
                    }
                }
                if(accsubsctempVariable!=null && accsubsctempVariable.size()>0){
                    tempAccSubscVariable.accSubscList.addAll(accsubsctempVariable);
                    tempAccSubscVariable.accId = accExtId;
                    tempAccSubscVariable.accName = accountName;
                    accountSubscriptionList.add(tempAccSubscVariable);
                }
            }
        }
    }
    
    
    //for the product+Instance ID and subscription map, for each product, fetches the subscription list
    //and finds the min start date, max end date and seat count, for that product+instance ID combination
    //method called for all accounts that have the same GP Number, is called from populateAccountSubscriptionDetails
    //method.
    @TestVisible
    private List<accountSubscriptionAggregateClass> fetchaccSubscRecord(Map<String,List<SBQQ__Subscription__c>> instanceSubscMap){
        
        List<accountSubscriptionAggregateClass> AccSubscList;
        accountSubscriptionAggregateClass tempAccSubscVariable;
        List<SBQQ__Subscription__c> tempSubscList;
        Date minimumStartDate;
        Date maximumEndDate;
        Integer totalQuantity = 0;
        List<Date> startDateList;
        List<Date> endDateList;
        
        if(instanceSubscMap!=null && instanceSubscMap.size()>0){
            AccSubscList = new List<accountSubscriptionAggregateClass>();
            for(String instance:instanceSubscMap.keySet()){
                tempAccSubscVariable = new accountSubscriptionAggregateClass();
                
                tempSubscList = instanceSubscMap.get(instance);
                startDateList = new List<Date>();
                endDateList = new List<Date>();
                if(tempSubscList!=null && tempSubscList.size()>0){
                    tempAccSubscVariable.instanceId = tempSubscList[0].Instance_id__c;
                    tempAccSubscVariable.prodName = tempSubscList[0].SBQQ__ProductName__c;
                    for(SBQQ__Subscription__c tempSubscription : tempSubscList){
                        if(tempSubscription.SBQQ__StartDate__c!=null)
                            startDateList.add(tempSubscription.SBQQ__StartDate__c);
                        if(tempSubscription.SBQQ__EndDate__c!=null)
                            endDateList.add(tempSubscription.SBQQ__EndDate__c);

                             if(totalQuantity==null)
                                totalQuantity = Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                            else{
                                if(tempSubscription.SBQQ__Quantity__c!=null)
                                    totalQuantity += Integer.valueOf(tempSubscription.SBQQ__Quantity__c);
                            }    
                       //sunji03 -US466300,DE361113, only add products with volume discount pricing criteria of "plus global seat count" to the list
                       if (tempSubscription.SBQQ__Product__r.Volume_Price_Curve_Quantity_Criteria__c == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats)
                       {
                           tempAccSubscVariable.VolumeDiscPricingIncludeGlobalSeatCount = true;
                        }   
                        else
                        {
                            tempAccSubscVariable.VolumeDiscPricingIncludeGlobalSeatCount = false;
                        }             
                    }
                    if(startDateList!=null && startDateList.size()>0){
                        startDateList.sort();
                        minimumStartDate = startDateList.get(0);
                    }
                    
                    if(endDateList!=null && endDateList.size()>0){
                        endDateList.sort();
                        maximumEndDate = endDateList.get(endDateList.size()-1);
                    } 
                    tempAccSubscVariable.minStartDate = minimumStartDate;
                    tempAccSubscVariable.maxEndDate = maximumEndDate;
                    tempAccSubscVariable.totalQuantity = totalQuantity;
                }
                if (tempAccSubscVariable.VolumeDiscPricingIncludeGlobalSeatCount)
                {
                    AccSubscList.add(tempAccSubscVariable);
                }
                totalQuantity = 0;
                minimumStartDate = null;
                maximumEndDate = null;
            }
        }
        return AccSubscList;
    }
    
    
    
    //for the product-asset map, for each product, fetches the asset list
    //and finds seat count, for that product, and
    //adds it to the wrapper list - productAssetAggregateList, that is displayed on the page.
     @TestVisible
    private void populateProductAssetSeatCount(Map<Id,List<Asset>> prodAssetDetailMap){
        
        List<Asset> tempAssetList = new List<Asset>();
        productAssetAggregateList = new List<productAssetAggregateClass>();
        productAssetAggregateClass prodAssetAggregateVariable;
        string prodName;
        Integer totalQuantity;
        
        if(prodAssetDetailMap!=null && prodAssetDetailMap.size()>0){
            
            for(Id product:prodAssetDetailMap.keySet()){
                
                tempAssetList = prodAssetDetailMap.get(product);
                prodAssetAggregateVariable = new productAssetAggregateClass();
                if(tempAssetList.size()>0){
                    prodName = tempAssetList[0].Name;
                    system.debug('----name-----'+prodName);
                    for(Asset tempAsset : tempAssetList){          
                        //sunji03 -US466300,DE361113, only add products with volume discount pricing criteria of "plus global seat count" to the list
                        if (tempAsset.Product2.Volume_Price_Curve_Quantity_Criteria__c == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats)
                        {
                            prodAssetAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount = true;
                        }     
                        else 
                        {
                            prodAssetAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount = false;
                        }

                        if(totalQuantity==null)
                                totalQuantity = Integer.valueOf(tempAsset.Quantity);
                            else{
                                if(tempAsset.Quantity!=null)
                                    totalQuantity += Integer.valueOf(tempAsset.Quantity);
                            }               
                    }
                } 
                prodAssetAggregateVariable.productName = prodName;
                prodAssetAggregateVariable.quantity = totalQuantity;
                if (prodAssetAggregateVariable.VolumeDiscPricingIncludeGlobalSeatCount)
                {
                    productAssetAggregateList.add(prodAssetAggregateVariable);
                }
                totalQuantity = 0;
                prodName = '';
            }
        }
    }
    
    
    //for the account-asset map, for each account - forms a map of Prod and asset List - 
    // called productAssetMap. For this map, calls a method to populate wrapper list of type
    //accountAssetAggregateClass, that is used to populate another wrapper list - 
    //accountAssetList, that is displayed on the page - it shows the account name, ext ID, and Prod Name,
    //and seat count.
    @TestVisible
    private void populateAccountAssetDetails(Map<Id,List<Asset>> accountAssetMap){
        system.debug('---acc asset method---');
        List<Asset> tempAssetList;
        Map<Id,List<Asset>> productAssetMap;
        Map<String,List<Asset>> productInstanceIdAssetMap;//chajo30
        List<accountAssetAggregateClass> accAssetTempVariable;
        accountAssetClass tempAccAssetVariable;
        String accountName;
        String accExtId;
        String mapKey;
        
        if(accountAssetMap!=null && accountAssetMap.size()>0){
            accountAssetList = new List<accountAssetClass>();
            for(Id accId:accountAssetMap.keySet()){
                tempAssetList = accountAssetMap.get(accId);
                tempAccAssetVariable = new accountAssetClass();
                if(tempAssetList!=null && tempAssetList.size()>0){
                    accountName = tempAssetList[0].Account.Name;
                    accExtId = tempAssetList[0].Account.Enterprise_ID__c;
                    productAssetMap = new Map<Id,List<Asset>>();

                    //chajo30
                    productInstanceIdAssetMap = new Map<String, List<Asset>>();

                    for(Asset tempAsset:tempAssetList){
                        mapKey = tempAsset.Product2.Name+tempAsset.Product_Instance_Id__c;
                        if(productInstanceIdAssetMap.containsKey(mapKey)){
                            productInstanceIdAssetMap.get(mapKey).add(tempAsset);
                        }
                        else{
                            productInstanceIdAssetMap.put(mapKey,new List<Asset> {tempAsset});
                        }
                    }
                    if(productInstanceIdAssetMap!=null && productInstanceIdAssetMap.size()>0){
                        accAssetTempVariable = fetchAccAssetRecord(productInstanceIdAssetMap);
                    }
                    //end chajo30

                }
                if(accAssetTempVariable!=null && accAssetTempVariable.size()>0){
                    system.debug('---adding to final list---'+accAssetTempVariable.size());
                    tempAccAssetVariable.accName = accountName;
                    tempAccAssetVariable.accId = accExtId;
                    tempAccAssetVariable.accAssetList.addAll(accAssetTempVariable);
                    accountAssetList.add(tempAccAssetVariable);
                }
            }
        }
    }
    
    //for the product and subscription map, for each product, fetches the assets list
    //and finds seat count, for that product.
    //method called for all accounts that have the same GP Number, is called from populateProductAssetSeatCount
    //method.
    @TestVisible
    private List<accountAssetAggregateClass> fetchAccAssetRecord(Map<String,List<Asset>> instanceProductAssetMap){
        
        system.debug('----fetch acc asset method----'+instanceProductAssetMap.size());
        
        List<accountAssetAggregateClass> AccAssetList;
        accountAssetAggregateClass tempAccAssetVariable;
        List<Asset> tempAssetList;
        Integer totalQuantity = 0;
        
        if(instanceProductAssetMap!=null && instanceProductAssetMap.size()>0){
            AccAssetList = new List<accountAssetAggregateClass>();
            for(String instanceId:instanceProductAssetMap.keySet()){
                tempAccAssetVariable = new accountAssetAggregateClass();                
                tempAssetList = instanceProductAssetMap.get(instanceId);
                if(tempAssetList!=null && tempAssetList.size()>0){
                    tempAccAssetVariable.prodName = tempAssetList[0].Product2.Name;
                    tempAccAssetVariable.instanceId = tempAssetList[0].Product_Instance_Id__c;//chajo30
                    for(Asset tempAsset : tempAssetList){
                        
                        if(totalQuantity==null)
                                totalQuantity = Integer.valueOf(tempAsset.Quantity);
                            else{
                                if(tempAsset.Quantity!=null)
                                    totalQuantity += Integer.valueOf(tempAsset.Quantity);
                            }  

                        //sunji03 -US466300,DE361113, only add products with volume discount pricing criteria of "plus global seat count" to the list
                        if (tempAsset.Product2.Volume_Price_Curve_Quantity_Criteria__c == Label.Volume_Price_Curve_Quantity_Criteria_Global_Seats)
                        {
                            tempAccAssetVariable.VolumeDiscPricingIncludeGlobalSeatCount = true;
                        }
                        else
                        {
                            tempAccAssetVariable.VolumeDiscPricingIncludeGlobalSeatCount = false;
                        }                      
                    }
                    
                    tempAccAssetVariable.totalQuantity = totalQuantity;
                }
                if (tempAccAssetVariable.VolumeDiscPricingIncludeGlobalSeatCount )
                {
                    AccAssetList.add(tempAccAssetVariable);
                }
                totalQuantity = 0;
            }
        }
        system.debug('----returning asset list----'+AccAssetList.size());
        return AccAssetList;
    }
    
    //this wrapper class is used to display seat count for Subscriptions, for
    //each product for the given GP Number.
    public class productAggregateClass{
        public String productName {get;set;}
        public Date startDate {get;set;}
        public Date endDate {get;set;}
        public Integer quantity {get;set;}
        public boolean VolumeDiscPricingIncludeGlobalSeatCount {get;set;}
    }
    
    //this wrapper class is used to display seat count for Assets, for
    //each product for the given GP Number.
    public class productAssetAggregateClass{
        public String productName {get;set;}
        public Integer quantity {get;set;}
        public boolean VolumeDiscPricingIncludeGlobalSeatCount {get;set;}
    }
    
    //this wrapper class is used to display seat count for Subscriptions, for
    //each product and instance ID, for the given GP Number.
    public class accountSubscriptionAggregateClass{
        public String prodName{get;set;}
        public String instanceId{get;set;}
        public Date minStartDate{get;set;}
        public Date maxEndDate{get;set;}
        public Integer totalQuantity{get;set;}
        public boolean VolumeDiscPricingIncludeGlobalSeatCount {get;set;}
    }
    
    //stores the account name, ext ID, and list of accountSubscriptionAggregateClass
    //wrapper class - to show detailed level information for each product for that
    //account
    public class accountSubscriptionClass{
        public String accName{get;set;}
        public String accId{get;set;}
        public List<accountSubscriptionAggregateClass> accSubscList{get;set;}
        
        public accountSubscriptionClass(){
            this.accSubscList = new List<accountSubscriptionAggregateClass>();
        }
    }
    
    //this wrapper class is used to display seat count for Assets, for
    //each product
    public class accountAssetAggregateClass{
        public String prodName{get;set;}
        public String instanceId{get;set;}//chajo30
        public Integer totalQuantity{get;set;}
        public boolean VolumeDiscPricingIncludeGlobalSeatCount {get;set;}
    }
    
    //stores the account name, ext ID, and list of accountAssetAggregateClass
    //wrapper class - to show detailed level information for each product for that
    //account
    public class accountAssetClass{
        public String accName{get;set;}
        public String accId{get;set;}
        public List<accountAssetAggregateClass> accAssetList{get;set;}
        
        public accountAssetClass(){
            this.accAssetList = new List<accountAssetAggregateClass>();
        }
    }
    
    //returns subscription details for the give GP Number
    @TestVisible
    private List<SBQQ__Subscription__c> returnSubscriptionDetails(String dunsGPNumber){
        return [SELECT
               id,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__Product__r.SBQQ__Component__c,Instance_Id__c,
               SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Quantity__c,SBQQ__Account__c,SBQQ__Account__r.Name,
                SBQQ__Account__r.Enterprise_ID__c, SBQQ__Product__r.Volume_Price_Curve_Quantity_Criteria__c from SBQQ__Subscription__c where
                Global_Parent_Account_Number__c=:dunsGPNumber AND 
                SBQQ__Product__c!=null AND SBQQ__EndDate__c>=:System.today()
               AND SBQQ__Product__r.Salesforce_CPQ_Product__c=TRUE AND SBQQ__Product__r.ProductCode!=null
                AND Instance_Id__c!=NULL AND Instance_Id__c!=''];
    }
    
    //returns subscription details for the give account
    @TestVisible
    private List<SBQQ__Subscription__c> returnAccSubscriptionDetails(String dunsGPNumber, ID AccountId){
        return [SELECT
               id,SBQQ__Product__c,SBQQ__ProductName__c,SBQQ__Product__r.SBQQ__Component__c,Instance_Id__c,
               SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Quantity__c,SBQQ__Account__c,SBQQ__Account__r.Name,
               SBQQ__Account__r.Enterprise_ID__c, SBQQ__Product__r.Volume_Price_Curve_Quantity_Criteria__c from SBQQ__Subscription__c where
                SBQQ__Account__c=:AccountId AND SBQQ__Product__c!=null and SBQQ__EndDate__c>=:System.today()               
               AND SBQQ__Product__r.Salesforce_CPQ_Product__c=TRUE AND SBQQ__Product__r.ProductCode!=null 
                AND Instance_Id__c!=NULL AND Instance_Id__c!=''];
    }
    
    //returns asset details for the give GP Number
    @TestVisible
    private List<Asset> returnAssetDetails(String dunsGPNumber){
        return [SELECT
               id,Product2Id,Quantity,Name,AccountId,Account.Name,
                Account.Enterprise_ID__c,Product2.Name,Product2.Volume_Price_Curve_Quantity_Criteria__c,Product_Instance_Id__c from Asset where 
               Global_Parent_Account_Number__c=:dunsGPNumber AND Product2Id!=null
               AND Product2.Salesforce_CPQ_Product__c=TRUE AND Product2.ProductCode!=null];
    }
    
    //returns Asset details for the account
    @TestVisible
    private List<Asset> returnAccAssetDetails(String dunsGPNumber, ID accId){
        return [SELECT
               id,Product2Id,Product2.Name,Product2.Volume_Price_Curve_Quantity_Criteria__c,Quantity,Name,AccountId,Account.Name,
                Account.Enterprise_ID__c, Product_Instance_Id__c from Asset where 
               AccountId=:accId
                AND Product2Id!=null AND Product2.Salesforce_CPQ_Product__c=TRUE
                AND Product2.ProductCode!=null];
    }

}