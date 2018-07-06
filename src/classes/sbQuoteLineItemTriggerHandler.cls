public class sbQuoteLineItemTriggerHandler implements Itrigger{
    
    public void bulkBefore(){
        sbQuoteLineItemTriggerGateway.loadSBQuoteLineItemBulkValues();
    }
    
    public void bulkAfter(){
        sbQuoteLineItemTriggerGateway.loadSBQuoteLineItemBulkValues();
    }
    
    public void beforeInsert(SObject so){
        
        SBQQ__QuoteLine__c quoteOli = (SBQQ__QuoteLine__c)so;
        Id AccountId;
        Map<Id,Integer> prodSeatCount = new Map<Id,Integer>();
        Map<Id,Integer> prodAssetSeatCount = new Map<Id,Integer>();
        Integer seatcount;
        String gpDunsNumber;
        
        if(sbQuoteLineItemTriggerGateway.sbQuoteMap!=null && sbQuoteLineItemTriggerGateway.sbQuoteMap.size()>0){
            if(sbQuoteLineItemTriggerGateway.sbQuoteMap.containsKey(quoteoli.SBQQ__Quote__c)){
                if(sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c!=null){
                    AccountId = sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c;
                    gpDunsNumber = sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__r.GU_Duns_Number__c;
                }
            }            
        }
        if((String.isNotBlank(gpDunsNumber) && gpDunsNumber=='999999999')||String.isBlank(gpDunsNumber)){
            if(sbQuoteLineItemTriggerGateway.accountProductSeatCountMap!=null && sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.size()>0){
                if(AccountId!=null && sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.containsKey(AccountId)){
                    prodSeatCount = sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.get(AccountId);
                    if(prodSeatCount!=null && prodSeatCount.size()>0){
                        if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
            if(sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap!=null && sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.size()>0){
                if(AccountId!=null && sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.containsKey(AccountId)){
                    prodAssetSeatCount = sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.get(AccountId);
                    if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                        if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
        }
        else if(String.isNotBlank(gpDunsNumber) && gpDunsNumber!='999999999'){
            if(sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap!=null && sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.size()>0){
                if(sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.containsKey(gpDunsNumber)){
                    prodSeatCount = sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.get(gpDunsNumber);
                    if(prodSeatCount!=null && prodSeatCount.size()>0){
                        if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
            if(sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap!=null && sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.size()>0){
                if(sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.containsKey(gpDunsNumber)){
                    prodAssetSeatCount = sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.get(gpDunsNumber);
                    if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                        if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        SBQQ__QuoteLine__c quoteOli = (SBQQ__QuoteLine__c)so;
        Id AccountId;
        Map<Id,Integer> prodSeatCount = new Map<Id,Integer>();
        Map<Id,Integer> prodAssetSeatCount = new Map<Id,Integer>();
        Integer seatcount;
        String gpDunsNumber;
        if(sbQuoteLineItemTriggerGateway.sbQuoteMap!=null && sbQuoteLineItemTriggerGateway.sbQuoteMap.size()>0){
            if(sbQuoteLineItemTriggerGateway.sbQuoteMap.containsKey(quoteoli.SBQQ__Quote__c)){
                if(sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c!=null){
                    AccountId = sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__c;
                    gpDunsNumber = sbQuoteLineItemTriggerGateway.sbQuoteMap.get(quoteoli.SBQQ__Quote__c).SBQQ__Account__r.GU_Duns_Number__c;
                }
            }            
        }
        if(String.isNotBlank(gpDunsNumber) && gpDunsNumber=='999999999'){
            if(sbQuoteLineItemTriggerGateway.accountProductSeatCountMap!=null && sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.size()>0){
                if(AccountId!=null && sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.containsKey(AccountId)){
                    prodSeatCount = sbQuoteLineItemTriggerGateway.accountProductSeatCountMap.get(AccountId);
                    if(prodSeatCount!=null && prodSeatCount.size()>0){
                        if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
            if(sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap!=null && sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.size()>0){
                if(AccountId!=null && sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.containsKey(AccountId)){
                    prodAssetSeatCount = sbQuoteLineItemTriggerGateway.accountAssetProductSeatCountMap.get(AccountId);
                    if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                        if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
        }
        
        
        if(String.isNotBlank(gpDunsNumber) && gpDunsNumber!='999999999'){
            system.debug('---before update-----');
            if(sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap!=null && sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.size()>0){
                system.debug('----gp prod seat count----');
                if(sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.containsKey(gpDunsNumber)){
                    prodSeatCount = sbQuoteLineItemTriggerGateway.gpDunsProdSeatCountMap.get(gpDunsNumber);
                    system.debug('---prod seat count-----'+prodSeatCount);
                    if(prodSeatCount!=null && prodSeatCount.size()>0){
                        if(prodSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodSeatCount.get(quoteoli.SBQQ__Product__c);
                            system.debug('----seat count----'+seatcount);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            system.debug('--- GP seat count---'+quoteoli.Global_Parent_Seat_Count__c);
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
            if(sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap!=null && sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.size()>0){
                if(sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.containsKey(gpDunsNumber)){
                    prodAssetSeatCount = sbQuoteLineItemTriggerGateway.gpDunsAssetProdSeatCountMap.get(gpDunsNumber);
                    if(prodAssetSeatCount!=null && prodAssetSeatCount.size()>0){
                        if(prodAssetSeatCount.containsKey(quoteoli.SBQQ__Product__c)){
                            seatcount = prodAssetSeatCount.get(quoteoli.SBQQ__Product__c);
                            quoteoli.GP_Seat_Count_System_Generated__c = seatCount;
                            if(quoteoli.Global_Parent_Seat_Count__c==null||quoteoli.Global_Parent_Seat_Count__c==0)
                                quoteoli.Global_Parent_Seat_Count__c = seatcount;
                        }
                    }
                }
            }
        }
    }
    
    public void beforeDelete(SObject so){
        
    }
    
    public void afterInsert(SObject so){
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        
    }
    
    public void afterDelete(SObject so){
        
    }
    
    public void andFinally(){
        
    }
    
}