/*
* Test Class = TestSoxTriggersAndClasses
* Updated by - BAJPI01
* Coverage = 100%
*/
global class sfcpq_sox_deleted_pbentry_batch implements Database.Batchable<sObject>{
    
     global Database.QueryLocator start(Database.BatchableContext bc){
        
        string query;
        query = 'SELECT Id,Active__c,Currency__c,List_Price__c,Max_Allowable_Price__c,PriceBookEntry_ID__c,Product_ID__c,Product_Name__c,PBE_Deleted__c FROM SOX_PriceBookEntry__c where PBE_Deleted__c=false'; 
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc,List<SOX_PriceBookEntry__c> soxPbeList){
        
        List<PriceBookEntry> originalPbeList = new List<PriceBookEntry>();
        
        Set<Id> soxPbeIds = new Set<Id>();
        
        Map<Id,SOX_PriceBookEntry__c> soxPbeMap = new Map<Id,SOX_PriceBookEntry__c>();
        Map<Id,Boolean> soxPbeExistInPbe = new Map<Id,Boolean>();
        List<SOX_PriceBookEntry__c> deletedSoxPbeList = new List<SOX_PriceBookEntry__c>();
        
        for(SOX_PriceBookEntry__c soxpbe:soxPbeList){
            soxPbeIds.add(Id.Valueof(soxpbe.PriceBookEntry_ID__c));
            soxPbeMap.put(Id.Valueof(soxpbe.PriceBookEntry_ID__c),soxpbe);
            soxPbeExistInPbe.put(Id.Valueof(soxpbe.PriceBookEntry_ID__c),false);
        }
        
        if(soxPbeIds.size()>0){
            originalPbeList = [SELECT Id,IsActive,CurrencyIsoCode,UnitPrice,Product2Id,Product2.Name,
                               Max_Allowable_Price__c,CreatedById,CreatedDate,LastModifiedById,
                               LastModifiedDate FROM PriceBookEntry where Product2.Salesforce_CPQ_Product__c=true
                              AND Id IN:soxPbeIds];
            
        }
        
        if(originalPbeList.size()>0){
            
            for(PriceBookEntry pbe:originalPbeList){
                if(soxPbeIds.contains(pbe.Id)){
                    soxPbeExistInPbe.put(pbe.Id,true);
                }
            }
            
            for(Id soxpbeid:soxPbeExistInPbe.keyset()){
                Boolean exists = false;
                exists = soxPbeExistInPbe.get(soxpbeid);
                if(exists == false){
                    system.debug('---deleted pbe found----');
                    deletedSoxPbeList.add(soxPbeMap.get(soxpbeid));
                }
            }
            
        }
        else{
            deletedSoxPbeList.addAll(soxPbeList);
        }


        if(deletedSoxPbeList.size()>0){
            for(SOX_PriceBookEntry__c soxpbe:deletedSoxPbeList){ 
                soxpbe.PBE_Deleted__c = true;
            }
            update deletedSoxPbeList;
        }
            
        
    }
    
    global void finish(Database.BatchableContext bc){
    }
    

}