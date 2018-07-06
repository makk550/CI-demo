/*
* Test Class = TestSoxTriggersAndClasses
* Updated by - BAJPI01
* Coverage = 92%
*/
global class sfcpq_sox_pricebookentry_batch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        string query;
        query = 'SELECT Id,IsActive,CurrencyIsoCode,UnitPrice,Product2Id,ProductCode,Product2.Name,Max_Allowable_Price__c,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate FROM PriceBookEntry where Product2.Salesforce_CPQ_Product__c=true'; 
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc,List<PriceBookEntry> pbEntryList){
        
        Set<Id> pbeIds = new Set<Id>();
        Map<Id,PriceBookEntry> pbeMap = new Map<Id,PriceBookEntry>();
        Map<Id,Boolean> pbeExistInSoxPbe = new Map<Id,Boolean>();
        List<PriceBookEntry> missingPbeList = new List<PriceBookEntry>();
        

        List<SOX_PriceBookEntry__c> originalSoxPbeList = new List<SOX_PriceBookEntry__c>();
        List<SOX_PriceBookEntry__c> soxPbeListToInsert = new List<SOX_PriceBookEntry__c>();
        List<SOX_PriceBookEntry__c> soxPbeListToUpdate = new List<SOX_PriceBookEntry__c>();
        
        List<SFCPQ_SOX_Tracking__c> newPbeRecordsSoxTracking = new List<SFCPQ_SOX_Tracking__c>();
        
        for(PriceBookEntry pbe:pbEntryList){
            pbeIds.add(pbe.id);
            pbeMap.put(pbe.id,pbe);
            pbeExistInSoxPbe.put(pbe.id,false);
        }
        
        if(pbeIds.size()>0){
            originalSoxPbeList = [select Id,Active__c,Currency__c,List_Price__c,Max_Allowable_Price__c,PBE_Deleted__c,
                                  PBE_ModifiedBy__c,PBE_Modified_Date__c,PriceBookEntry_ID__c,Product_ID__c,Product_Name__c,
                                  Product_Code__c
                                 from SOX_PriceBookEntry__c where PriceBookEntry_ID__c IN:pbeIds AND PBE_Deleted__c=:false];
            
        }
        
        if(originalSoxPbeList.size()>0){
            
            for(SOX_PriceBookEntry__c soxpbe:originalSoxPbeList){
                if(pbeIds.contains(Id.valueOf(soxpbe.PriceBookEntry_ID__c))){
                    pbeExistInSoxPbe.put(Id.valueOf(soxpbe.PriceBookEntry_ID__c),true);
                }
                if(pbeMap.containsKey(Id.valueOf(soxpbe.PriceBookEntry_ID__c))){
                    PriceBookEntry pbe = pbeMap.get(Id.valueOf(soxpbe.PriceBookEntry_ID__c));
                    if(pbe.LastModifiedDate!=soxpbe.PBE_Modified_Date__c){
                        if(soxpbe.Active__c != pbe.IsActive)
                        	soxpbe.Active__c = pbe.IsActive;
                        if(soxpbe.Currency__c != pbe.CurrencyIsoCode)
                        	soxpbe.Currency__c = pbe.CurrencyIsoCode;
                        if(soxpbe.List_Price__c != pbe.UnitPrice)
                        	soxpbe.List_Price__c = pbe.UnitPrice;
                        if(soxpbe.Max_Allowable_Price__c != pbe.Max_Allowable_Price__c)
                        soxpbe.Max_Allowable_Price__c = pbe.Max_Allowable_Price__c;
                        if(soxpbe.PriceBookEntry_ID__c != pbe.Id)
	                        soxpbe.PriceBookEntry_ID__c = pbe.Id;
                        if(soxpbe.Product_ID__c != String.valueOf(pbe.Product2Id))
	                        soxpbe.Product_ID__c = String.valueOf(pbe.Product2Id);
                        if(soxpbe.Product_Code__c != pbe.ProductCode)
                            soxpbe.Product_Code__c = pbe.ProductCode;
                        if(soxpbe.Product_Name__c != pbe.Product2.Name)
                        	soxpbe.Product_Name__c = pbe.Product2.Name;
                        soxpbe.PBE_ModifiedBy__c = pbe.LastModifiedById;
                        soxpbe.PBE_Modified_Date__c = pbe.LastModifiedDate;
                        soxPbeListToUpdate.add(soxpbe);
                    }
                }
            }
            
            for(Id pbeid:pbeExistInSoxPbe.keyset()){
                Boolean exists = false;
                exists = pbeExistInSoxPbe.get(pbeid);
                if(exists == false){
                    system.debug('---missing pbe found----');
                    missingPbeList.add(pbeMap.get(pbeid));
                }
            }
            if(missingPbeList.size()>0){
                soxPbeListToInsert = populateSoxPbeList(missingPbeList);
                newPbeRecordsSoxTracking = populateSoxTrackingList(missingPbeList);
            } 
        }
        else{
            soxPbeListToInsert = populateSoxPbeList(pbeMap.values());
            newPbeRecordsSoxTracking = populateSoxTrackingList(pbeMap.values());
        }
        if(soxPbeListToInsert.size()>0){
            insert soxPbeListToInsert;
        }
        if(soxPbeListToUpdate.size()>0)
            update soxPbeListToUpdate;
        if(newPbeRecordsSoxTracking.size()>0){
            insert newPbeRecordsSoxTracking;
        }
        
    }
    
    public static List<SOX_PriceBookEntry__c> populateSoxPbeList(List<PriceBookEntry> tempPbeList){
        List<SOX_PriceBookEntry__c> soxPbeToInsert = new List<SOX_PriceBookEntry__c>();
        for(PriceBookEntry pbe:tempPbeList){
            SOX_PriceBookEntry__c temp = new SOX_PriceBookEntry__c();
            temp.Active__c = pbe.IsActive;
            temp.Currency__c = pbe.CurrencyIsoCode;
            temp.List_Price__c = pbe.UnitPrice;
            temp.Max_Allowable_Price__c = pbe.Max_Allowable_Price__c;
            temp.PriceBookEntry_ID__c = pbe.Id;
            temp.Product_ID__c = String.valueOf(pbe.Product2Id);
            temp.Product_Code__c = pbe.ProductCode;
            temp.Product_Name__c = pbe.Product2.Name;
            temp.PBE_CreatedBy__c = pbe.CreatedById;
            temp.PBE_Created_Date__c = pbe.CreatedDate;
            temp.PBE_ModifiedBy__c = pbe.LastModifiedById;
            temp.PBE_Modified_Date__c = pbe.LastModifiedDate;
            soxPbeToInsert.add(temp);
        }
        return soxPbeToInsert;
    }
    
    
        public static List<SFCPQ_SOX_Tracking__c> populateSoxTrackingList(List<PriceBookEntry> tempPbeList){
        List<SFCPQ_SOX_Tracking__c> soxTrackListToInsert = new List<SFCPQ_SOX_Tracking__c>();
        for(PriceBookEntry pbe:tempPbeList){
            SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
            temp.DML_Type__c = 'Insert';
            temp.Object_Name__c = 'PriceBookEntry';
            temp.Record_ID__c = pbe.Id;
            temp.PBE_Active__c = pbe.IsActive;
            temp.PBE_Currency__c = pbe.CurrencyIsoCode;
            temp.PBE_List_Price__c = pbe.UnitPrice;
            temp.PBE_Max_Allowable_Price__c = pbe.Max_Allowable_Price__c;
            temp.PBE_ProductID__c = String.valueOf(pbe.Product2Id);
            temp.PBE_ProductCode__c = pbe.ProductCode;
            temp.PBE_ProductName__c = pbe.Product2.Name;
            temp.PBE_CreatedBy__c = pbe.CreatedById;
            temp.PBE_CreatedDate__c = pbe.CreatedDate;
            soxTrackListToInsert.add(temp);
        }
        return soxTrackListToInsert;
    }
    
    global void finish(Database.BatchableContext bc){
        
        /*
        Datetime sysTime = System.now();

       // this would increase the time to 1 hour after current time
        sysTime = sysTime.addHours(1);

        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('PriceBookEntry Batch' + sysTime.getTime(),chron_exp, new sfcpq_sox_pricebookentry_batch());
        */
    }
    
}