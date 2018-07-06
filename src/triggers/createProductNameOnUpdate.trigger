trigger createProductNameOnUpdate on CA_Product_Controller__c(before update){
    if(Trigger.isUpdate && Trigger.isBefore){
        Map<Id, CA_Product_Controller__c> mapOfOldMap = Trigger.oldMap;
        Map<Id, CA_Product_Controller__c> mapOfNewMap = Trigger.newMap;   
        
        if(mapOfNewMap<>null && mapOfOldMap<>null && mapOfNewMap.keySet()<>null && mapOfOldMap.keySet()<>null){
            List<Product_Names__c> listOfProductName = new List<Product_Names__c>();
            for(String recordId:mapOfNewMap.keySet()){
                String oldVal = mapOfOldMap.get(recordId).Name;
                String newVal = mapOfNewMap.get(recordId).Name;
                if(String.isNotBlank(newVal) && !oldVal.equalsIgnoreCase(newVal)){
                    Product_Names__c productName = new Product_Names__c();
                    productName.CA_Product_Controller__c = mapOfNewMap.get(recordId).Id;
                    productName.Product_Usage__c = 'Service Cloud';
                    productName.Product_Synonyms__c = newVal;
                    listOfProductName.add(productName);
                }
            }
            
            if(listOfProductName<>null && listOfProductName.size()>0){
                try{Database.insert(listOfProductName);}Catch(DMLException e){system.debug('Insertion Failed: '+e.getMessage());}
            }
        }
    }
}