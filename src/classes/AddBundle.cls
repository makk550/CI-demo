global class AddBundle 
{
    global class BundleAndProductInfo {
        webservice String bundleId;
        webService String ProductId;
        webService Decimal DefaultPrice;
        webService String ProductName;
        webService String family;
        webservice Decimal discount;
        webservice Decimal salesPrice;
        webservice Id OptyLineItemId;
    }   
    
    webservice static List<BundleAndProductInfo> fetchBundle(String bundleName, String newOrEdit) {
        Map<Id, Bundle__c> bundleMap = new Map<Id, Bundle__c>();
        Map<Id, OpportunityLineItem> optyLineItemMap = new Map<Id, OpportunityLineItem>();
        List<BundleAndProductInfo> bundleAndProductInfoList = new List<BundleAndProductInfo>();
        try {
            Bundle__c[] bundle = [Select Id,Product__c,Default_Price__c, Product__r.Name, Product__r.Family from Bundle__c where Name =: bundleName];
            
            if(bundle.size() != 0) {
                if(newOrEdit == 'edit') {
                    for(Integer s=0; s<bundle.size(); s++) {
                        bundleMap.put(bundle[s].Id,bundle[s]);
                    }
                    OpportunityLineItem[] optyLineItemArr = [Select Id, UnitPrice from OpportunityLineItem];
                    
                    if(optyLineItemArr.size() != 0) {
                        for(Integer s=0; s<optyLineItemArr.size(); s++) {
 //                           optyLineItemMap.put(optyLineItemArr[s].Bundle__c,optyLineItemArr[s]);
                        }
                    }
                }
                
                BundleAndProductInfo bundleAndProductInfo;
                OpportunityLineItem tempOptyLineItem;
                
                for(Integer g=0; g<bundle.size(); g++) {
                        bundleAndProductInfo = new BundleAndProductInfo();
                        bundleAndProductInfo.ProductId = bundle[g].Product__c;
                        bundleAndProductInfo.ProductName = bundle[g].Product__r.Name;
                        bundleAndProductInfo.family = bundle[g].Product__r.Family;
                        
                        bundleAndProductInfo.bundleId = bundle[g].Id;
                        bundleAndProductInfo.DefaultPrice = bundle[g].Default_Price__c;
                        
                        if(newOrEdit == 'edit'){
                            tempOptyLineItem = optyLineItemMap.get(bundle[g].Id);
                            bundleAndProductInfo.OptyLineItemId = tempOptyLineItem.Id;
                            bundleAndProductInfo.salesPrice = tempOptyLineItem.UnitPrice;
                          
                            if(bundle[g].Default_Price__c > tempOptyLineItem.UnitPrice) {
                                bundleAndProductInfo.discount = ((bundle[g].Default_Price__c - tempOptyLineItem.UnitPrice) / bundle[g].Default_Price__c) * 100;
                            } else {
                                bundleAndProductInfo.discount = 0.0;
                            }
                        } else {
                            bundleAndProductInfo.discount = 0.0;
                        }
                        bundleAndProductInfoList.add(bundleAndProductInfo);
                }       
            }
        } catch(Exception e){
            throw e;
        }
        System.debug(bundleAndProductInfoList);
        return bundleAndProductInfoList;
    }
    
    webservice static boolean insertOptyLineItem(OpportunityLineItem[] opptyLineItem, String OpptyId, String opptyCurrency) {
        boolean flag = true;
        Map<String,OpportunityLineItem> OptyLineItemMap = new Map<String,OpportunityLineItem>();
        Map<String,String> PricebookEntryMap = new Map<String,String>();
        List<OpportunityLineItem> OptyLineItemList = new List<OpportunityLineItem>();
        PricebookEntry[] pricebookEntry;        
        
        try {
            if(opptyLineItem.size() != 0){      
                for(Integer s=0; s<opptyLineItem.size(); s++) {
                    OptyLineItemMap.put(opptyLineItem[s].PricebookEntryId,opptyLineItem[s]);
                }
                Opportunity oppty = [Select Pricebook2Id from Opportunity where Id =: OpptyId];
                
                if(oppty != null) {
                    pricebookEntry = [Select Id, Product2Id from PricebookEntry Where IsActive=true and Pricebook2Id =: oppty.Pricebook2Id  and Product2Id in : OptyLineItemMap.keyset()  and CurrencyIsoCode =: opptyCurrency];
                }
                
                if(pricebookEntry != null) {
                    for(Integer s=0; s<pricebookEntry.size(); s++)
                    PricebookEntryMap.put(pricebookEntry[s].Product2Id,pricebookEntry[s].Id);
                    System.debug(opptyLineItem);
                    for(Integer g=0; g<opptyLineItem.size(); g++) {
                      OpportunityLineItem opptyLineItemNew = new OpportunityLineItem(); 
                      opptyLineItemNew.OpportunityId = OpptyId;
                      opptyLineItemNew.UnitPrice = opptyLineItem[g].UnitPrice;
  //                    opptyLineItemNew.Bundle__c = opptyLineItem[g].Bundle__c;
                      //Actually opptyLineItem[g].PricebookEntryId holds ProductId not PricebookEntryId.
                      //We used PricebookEntryId field to just send the ProductId....
                      opptyLineItemNew.PricebookEntryId = PricebookEntryMap.get(opptyLineItem[g].PricebookEntryId);               
                      OptyLineItemList.add(opptyLineItemNew);
                    }                           
                    insert OptyLineItemList;
                }           
            }
        } catch(Exception e) {
            flag = false;
        }
        return flag;
    }

    webservice static boolean updateOptyLineItem(OpportunityLineItem[] opptyLineItem) {
        boolean flag = true;
        
        try {
            update opptyLineItem;
        } catch(Exception e) {
            flag = false;
            throw e;
        }
        return flag;    
    }

    //Code Coverage: 91%
    public static testMethod void testBundles() {
        try {
            //create test records
            Account a = new Account(name='BundlesTestAccount', Customer_Category__c='Enterprise', Region_Country__c='US',BillingStreet = 'Arlington', BillingCity = 'VA', BillingCountry = 'US');
            insert a;
            
            Id pbId = [select Id from pricebook2 where name='Standard Price Book'][0].Id;

            Opportunity o = new Opportunity(name='BundlesTestOppty', AccountId=a.id,Reseller__c=a.id, Pricebook2id=pbId, stageName='Open', CloseDate=System.today());
            insert o;

            Product2 p = new product2(name='BundlesTestProduct');
            insert p;
            
            PriceBookEntry pbe = new PricebookEntry(pricebook2id = pbId, Product2Id = p.Id, UnitPrice=1.0, IsActive=true);
            insert pbe; 

            Bundle__c b = new Bundle__c(name='TestBundle', Country__c = 'US', CurrencyIsoCode = 'USD', Default_Price__c = 1.0, Product__c = p.id);
            insert b;
            
            //test fetchBundle
            List<BundleAndProductInfo> fetchResult1 = fetchBundle('TestBundle','new');
                
            OpportunityLineItem[] olis = new OpportunityLineItem[] {};
            //pricebookEntryId is used to pass in Product ID
            olis.add(new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = p.Id, Quantity=1.0, UnitPrice = b.Default_Price__c));
        
            //test insertOptyLineItem
            insertOptyLineItem(olis, o.Id, 'USD');
            
            //test fetchBundle
            //List<BundleAndProductInfo> fetchResult2 = fetchBundle('TestBundle','edit');
            
            //Test updateOptyLineItem
            //olis[0] = [select Id,UnitPrice from OpportunityLineItem where id = :fetchResult2[0].OptyLineItemId];
            //olis[0].UnitPrice = 1.0;
            //updateOptyLineItem(olis);
         
            //Cleanup test records
            //delete olis;
            //delete b;
            //delete pbe;
            //delete p;
            //delete o;
            //delete a;         
            
            //dependent Trigger tests
            //OppGrid.testOppGridTrigger();
            //TestGoogleAdWord.testGoogleAdwordTrigger();
            //TestGoogleAdWord.testIndirectOppTrigger();
        } catch (System.DmlException e) {
            throw e;
        }
    }
}