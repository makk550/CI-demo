//batch job to update component and product names for articles
global class batchJobToUpdateArticles implements Database.Batchable<sObject>, Database.stateful{
    
    global List<Product_Component_Name_History__c> listOfHistory;
    global set<Id> setOfArticleIds;
    global set<String> setOfProductIds;
    global Map<String,String> mapOfOldAndNew;
    global Map<String,String> mapOfProductNameAndSynonyms;  
    global Map<String,String> mapOfProductIdAndName;
    global Map<Id, knowledge__kav> mapOfArticles;
    global List<String> listOfStrings;
    //global List<knowledge__kav> listOfDraftArticles;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        listOfHistory = new List<Product_Component_Name_History__c>();
        setOfArticleIds = new set<Id>();
        setOfProductIds = new set<String>();
        mapOfOldAndNew = new Map<String,String>();
        mapOfProductNameAndSynonyms = new Map<String,String>();
        mapOfProductIdAndName = new Map<String,String>();
        listOfStrings = new List<String>();
        mapOfArticles = new Map<Id, knowledge__kav>();
        String historyQueryString = 'Select id, Type__c, Record_ID__c, Old_Value__c, New_Value__c, Job_Date_Time__c from Product_Component_Name_History__c where Job_Date_Time__c=null';
        system.debug('DAATATATATATAT: '+Database.getQueryLocator(historyQueryString));
        return Database.getQueryLocator(historyQueryString);    
    }
    
    global void execute(Database.BatchableContext BC, List<Product_Component_Name_History__c> listOfExistingHistory){
        if(listOfExistingHistory<>null && listOfExistingHistory.size()>0){
            
            for(Product_Component_Name_History__c historyObj:listOfExistingHistory){
                if(String.isNotBlank(historyObj.Record_ID__c) && String.isBlank(historyObj.Old_Value__c) && String.isNotBlank(historyObj.New_Value__c) && String.isNotBlank(historyObj.Type__c) && historyObj.Type__c.equalsIgnoreCase('Product')){
                    setOfProductIds.add(historyObj.Record_ID__c);
                    if(mapOfProductNameAndSynonyms==null || mapOfProductNameAndSynonyms.size()==0 || mapOfProductNameAndSynonyms.isEmpty() || !mapOfProductNameAndSynonyms.containsKey(String.valueOf(historyObj.Record_ID__c).subString(0,15))){
                        mapOfProductNameAndSynonyms.put(String.valueOf(historyObj.Record_ID__c).subString(0,15), historyObj.New_Value__c+'; ');      
                    }else{
                        mapOfProductNameAndSynonyms.put(String.valueOf(historyObj.Record_ID__c).subString(0,15), mapOfProductNameAndSynonyms.get(String.valueOf(historyObj.Record_ID__c).subString(0,15))+historyObj.New_Value__c+'; ');    
                    } 
                    
                }else if(String.isNotBlank(historyObj.Record_ID__c) && String.isNotBlank(historyObj.Old_Value__c) && String.isNotBlank(historyObj.New_Value__c) && String.isNotBlank(historyObj.Type__c) && historyObj.Type__c.equalsIgnoreCase('Component')){
                    mapOfOldAndNew.put(historyObj.Old_Value__c,historyObj.New_Value__c);     
                }
                listOfHistory.add(historyObj);
            }
            system.debug('=========>'+mapOfOldAndNew);
            
            if(setOfProductIds<>null && setOfProductIds.size()>0){
                List<ca_product_controller__C> listOfCAProduct = [Select id, name from ca_product_controller__c where id IN:setOfProductIds AND name!=null AND name!=''];
                if(listOfCAProduct<>null && listOfCAProduct.size()>0){
                    for(ca_product_controller__c caProductObj:listOfCAProduct){
                        mapOfProductIdAndName.put(String.valueOf(caProductObj.Id).subString(0,15),caProductObj.Name);
                    }    
                }
            }
            
            List<knowledge__kav> listOfDraftArticles = [Select Id, Component_Names__c, Component_Codes__c, Product_Names__c, Releases__c,Store_Product_Ids__c from knowledge__kav where publishStatus='Draft'];
        
            if(listOfDraftArticles<>null && listOfDraftArticles.size()>0){
                for(knowledge__kav testObj:listOfDraftArticles){
                    if(mapOfProductNameAndSynonyms<>null && mapOfProductIdAndName<>null && mapOfProductIdAndName.size()>0 && mapOfProductNameAndSynonyms.size()>0 && String.isNotBlank(testObj.Product_Names__c)){
                        for(String productKey:mapOfProductIdAndName.keySet()){
                            if(String.isNotBlank(mapOfProductIdAndName.get(productKey)) && testObj.Product_Names__c.contains(mapOfProductIdAndName.get(productKey)+': ')){
                                testObj.Product_Names__c = testObj.Product_Names__c.replace(mapOfProductIdAndName.get(productKey)+': ',mapOfProductIdAndName.get(productKey)+': '+mapOfProductNameAndSynonyms.get(productKey));
                            }
                        }
                    } 
                    
                    if(mapOfOldAndNew<>null && mapOfOldAndNew.size()>0 && String.isNotBlank(testObj.Component_Names__c)){
                        for(String compOldValObj:mapOfOldAndNew.keySet()){
                            if(String.isNotBlank(compOldValObj) && mapOfOldAndNew.get(compOldValObj)!=null && testObj.Component_Names__c.contains(compOldValObj)){
                              testObj.Component_Names__c = testObj.Component_Names__c.replace(compOldValObj,mapOfOldAndNew.get(compOldValObj));    
                            }    
                        }    
                    }
                    
                    system.debug('---testObjaaaa.Product_Names__c-->'+testObj.Product_Names__c);
                    system.debug('---testObj.Component_Names__c-->'+testObj.Component_Names__c);
                    
                    if(String.isNotBlank(testObj.Product_Names__c)){
                      testObj.Product_Names__c = testObj.Product_Names__c.replace(';;',';');
                    }
                    
                    if((mapOfProductNameAndSynonyms<>null && mapOfProductNameAndSynonyms.size()>0 && String.isNotBlank(testObj.Product_Names__c)) || (mapOfOldAndNew<>null && mapOfOldAndNew.size()>0 && String.isNotBlank(testObj.Component_Names__c))){
                        mapOfArticles.put(testObj.Id,testObj);
                    }
                }  
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug(listOfHistory+'-----FINISH-----');
        system.debug('0-00-9-9-'+mapOfArticles);
        if(mapOfArticles<>null && mapOfArticles.size()>0){
            Boolean updatedFlag = false;
            if(!updatedFlag){
                List<knowledge__kav> listOfAllArticles = new List<knowledge__kav>();
                for(Id idVal:mapOfArticles.keySet()){
                  listOfAllArticles.add(mapOfArticles.get(idVal));      
                }
                if(listOfAllArticles<>null && listOfAllArticles.size()>0){
                  List<Database.SaveResult> updateExistingArticles = Database.update(listOfAllArticles,false);
                    for(Database.SaveResult articleObj:updateExistingArticles){
                    if(articleObj.isSuccess()){system.debug('SUCCESSFULLY UPDATE---ARTICLE');}else{system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());}                   }
                    updatedFlag = true;
                }
            }
            if(updatedFlag){
                List<Product_Component_Name_History__c> newListOfHistory = new List<Product_Component_Name_History__c>();
                for(Product_Component_Name_History__c historyObj:listOfHistory){
                    historyObj.Job_Date_Time__c = system.now(); 
                    newListOfHistory.add(historyObj);
                }
                if(newListOfHistory<>null && newListOfHistory.size()>0){
                    List<Database.SaveResult> updateHistory = Database.update(newListOfHistory,false);
                    for(Database.SaveResult updateObj:updateHistory){
                        if(updateObj.isSuccess()){
                            system.debug('SUCCESSFULLY UPDATE---HISTORY');    
                        }else{
                            system.debug('HISTORY falied id: '+updateObj.getId()+' Error message: '+updateObj.getErrors());    
                        } 
                    }
                    updatedFlag = false;        
                }
            }
        }       
    }
}