trigger insertAndUpdateProductName on Product_Names__c(before insert, after insert){

    if(Trigger.isInsert && Trigger.isBefore){
        Map<Id,String> mapOfProductName = new Map<Id,String>();
        Set<Id> setOfCaProduct = new Set<Id>();
        Set<String> setOfSynonyms = new Set<String>();
        Set<String> setOfUsage = new Set<String>();
        
        for(Product_Names__c productNameObj:Trigger.New){
            if(String.isNotBlank(productNameObj.CA_Product_Controller__c)){
                setOfCaProduct.add(productNameObj.CA_Product_Controller__c);
            }
            if(String.isNotBlank(productNameObj.Product_Usage__c)){
                setOfUsage.add(productNameObj.Product_Usage__c);
            }
            if(String.isNotBlank(productNameObj.Product_Synonyms__c)){
                setOfSynonyms.add(productNameObj.Product_Synonyms__c);
            }
        }
        
        if(setOfCaProduct<>null && setOfSynonyms<>null && setOfUsage<>null && setOfCaProduct.size()>0 && setOfSynonyms.size()>0 && setOfUsage.size()>0){
            List<Product_Names__c> listOfProductName = [Select Id,Product_Synonyms__c, CA_Product_Controller__c, Product_Usage__c from Product_Names__c where CA_Product_Controller__c IN:setOfCaProduct AND Product_Synonyms__c IN:setOfSynonyms AND Product_Usage__c IN:setOfUsage];
            if(listOfProductName<>null && listOfProductName.size()>0){
                Set<String> listOfCombinations = new Set<String>();
                for(Product_Names__c proNameObj:listOfProductName){listOfCombinations.add(proNameObj.CA_Product_Controller__c+'-'+proNameObj.Product_Synonyms__c+'-'+proNameObj.Product_Usage__c);}
                if(listOfCombinations<>null && listOfCombinations.size()>0){Set<String> setOfNewRecords = new Set<String>();
                    for(Product_Names__c productNameObject:Trigger.New){String prepareConcatString = productNameObject.CA_Product_Controller__c+'-'+productNameObject.Product_Synonyms__c+'-'+productNameObject.Product_Usage__c;
                        if(listOfCombinations.contains(prepareConcatString) || (setOfNewRecords<>null && setOfNewRecords.size()>0 && setOfNewRecords.contains(prepareConcatString))){
                            productNameObject.addError('Combination of '+productNameObject.Product_Synonyms__c+' and '+productNameObject.Product_Usage__c+' already exist');
                        }setOfNewRecords.add(prepareConcatString);}}
            }else{
                Set<String> setOfNewRecords = new Set<String>();
                for(Product_Names__c productNameObject:Trigger.New){
                    String prepareConcatString = productNameObject.CA_Product_Controller__c+'-'+productNameObject.Product_Synonyms__c+'-'+productNameObject.Product_Usage__c;
                    if(setOfNewRecords<>null && setOfNewRecords.size()>0 && setOfNewRecords.contains(prepareConcatString)){productNameObject.addError('Combination of '+productNameObject.Product_Synonyms__c+' and '+productNameObject.Product_Usage__c+' already exist');}
                    setOfNewRecords.add(prepareConcatString);
                }
            
            }
        }
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
        List<Product_Component_Name_History__c> listOfHistory = new List<Product_Component_Name_History__c>();
        
        for(Product_Names__c productNameObj:Trigger.New){
            if(String.isNotBlank(productNameObj.Product_Synonyms__c) && String.isNotBlank(productNameObj.CA_Product_Controller__c) && String.isNotBlank(productNameObj.Product_Usage__c) && !productNameObj.Product_Usage__c.equalsIgnoreCase(System.Label.ProductNameUsageSC)){
                Product_Component_Name_History__c historyObj = new Product_Component_Name_History__c();
                historyObj.Record_ID__c = productNameObj.CA_Product_Controller__c;
                historyObj.New_Value__c = productNameObj.Product_Synonyms__c;
                historyObj.Old_Value__c = '';
                historyObj.Type__c = 'Product';
                listOfHistory.add(historyObj);
            }
        }
        
        if(listOfHistory<>null && listOfHistory.size()>0){
            try{Database.insert(listOfHistory);}Catch(Exception e){system.debug('-----HISTORY INSERT-----FAILED');}
        }
    }
}