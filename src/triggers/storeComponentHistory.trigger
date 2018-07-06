trigger storeComponentHistory on CA_Product_Component__c(After update){

    List<Product_Component_Name_History__c> listOfHistory = new List<Product_Component_Name_History__c>();

    if(Trigger.isUpdate && Trigger.isAfter){    
        for(CA_Product_Component__c compObj:Trigger.New){
            String oldCompValue = Trigger.oldMap.get(compObj.Id).Name;
            if(String.isNotBlank(compObj.Name) && String.isNotBlank(oldCompValue) && !compObj.Name.equalsIgnoreCase(oldCompValue)){
                Product_Component_Name_History__c historyObj = new Product_Component_Name_History__c();
                historyObj.Record_ID__c = compObj.Id;
                historyObj.New_Value__c = compObj.Name;
                historyObj.Old_Value__c = oldCompValue;
                historyObj.Type__c = 'Component';
                listOfHistory.add(historyObj);
            }
        }
        
        if(listOfHistory<>null && listOfHistory.size()>0){
            try{Database.insert(listOfHistory);}Catch(Exception e){system.debug('-----HISTORY INSERT-----FAILED');}
        }
    }
}