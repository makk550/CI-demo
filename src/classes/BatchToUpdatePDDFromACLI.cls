global class BatchToUpdatePDDFromACLI implements Database.Batchable<sObject>,Database.Stateful{
    
    global List<String> exception_List = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select id,LastModifiedDate,AccountProduct__c, Nearest_Dismantle_Date__c ' ;
        query += ', ATTRF_Product_Contract_level_Summary__c, Associated_Contracts__c,Contracts_from_batch__c' ;
        query += ' from PDD_Enhanced__C ';        
        //query += ' where Account__c = \'0013000000HQXhI\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<PDD_Enhanced__C> pddEnhancedList){ 
        
        List<String> contractList = new List<String>();
        Map<String,PDD_Enhanced__c> pddMap = new Map<String,PDD_Enhanced__c>();
        for(PDD_Enhanced__c pdd : pddEnhancedList ){
            pddMap.put(pdd.AccountProduct__c,pdd);
            if( String.isNotBlank( pdd.Contracts_from_batch__c ))
                contractList.addAll(pdd.Contracts_from_batch__c.split(';'));            
        }
        
        String tempAccountProduct;
        Date tempDismantleDate;
        Map<String,Active_Contract_Line_Item__c> accProductAcliMap = new Map<String,Active_Contract_Line_Item__c>();
        Map<String, Set<Date>> acliProductDismantleDateMap = new Map<String, Set<Date>>();
        Map<String,Map<String,String>> accProductAcliDetailsMap = new Map<String,Map<String,String>>();
        
        
        List<Active_Contract_Line_Item__C> acliList = [select id, ATTRF_CRV_USD__c, Contract_Item__c, DISMANTLING_DATE__C 
                                                       ,Contract_Product__r.Active_Contract__r.Account__c 
                                                       ,Product_Material__r.Product_ID__c
                                                       from Active_Contract_Line_Item__C where Contract_Item__c IN :contractList                                                       
                                                      ];
        //Orig_ATTRF_LC__c
        
        for(Active_Contract_Line_Item__c ar : acliList) { 
            tempAccountProduct = ar.Contract_Product__r.Active_Contract__r.Account__c + ';' + ar.Product_Material__r.Product_ID__c; //('CA_Product_Controller__c'); 
            tempDismantleDate = ar.DISMANTLING_DATE__C;
            
            //if(accProductAcliMap.containsKey(tempAccountProduct)){
            if(accProductAcliDetailsMap.containsKey(tempAccountProduct)) {
                
                if(tempDismantleDate> System.today()) {
                    if(acliProductDismantleDateMap.containsKey(tempAccountProduct) ){
                        Set<Date> tempDatesSet = acliProductDismantleDateMap.get(tempAccountProduct); 
                        tempDatesSet.add(tempDismantleDate);
                        acliProductDismantleDateMap.put(tempAccountProduct,tempDatesSet);
                    } else {
                        acliProductDismantleDateMap.put(tempAccountProduct, new Set<Date>{ar.Dismantling_Date__c});
                    } 
                }
               
                /*
                if(  tempDismantleDate < (Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C')) 
                    && tempDismantleDate > System.today()
                  ){
                    System.debug('In if tempDismantleDate:'+ tempDismantleDate + ';accProductAcliMap.get(DISMANTLING_DATE__C)):'+(Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C'))  );
                    accProductAcliMap.put(tempAccountProduct, ar);
                    //System.debug('In if, accProductAcliMap.get:'+ accProductAcliMap.get(tempAccountProduct).);
                } */
                Map<String,String> tempContractDetails = accProductAcliDetailsMap.get(tempAccountProduct);
                tempContractDetails.put( 'ATTRFSum', String.valueOf( Decimal.valueOf(tempContractDetails.get('ATTRFSum')) +  (ar.ATTRF_CRV_USD__c != null ? ar.ATTRF_CRV_USD__c : 0) ) );
                accProductAcliDetailsMap.put(tempAccountProduct, tempContractDetails );
            }
            else {
                System.debug('In else,' + ar.DISMANTLING_DATE__C);
                accProductAcliMap.put(tempAccountProduct, ar);
                if(ar.Dismantling_Date__c > System.today())
                    acliProductDismantleDateMap.put(tempAccountProduct, new Set<Date>{ar.Dismantling_Date__c});
                
                //ATTRF Sum:
                Map<String,String> tempContractDetails = new Map<String,String>();
                tempContractDetails.put('ATTRFSum', String.valueOf(ar.ATTRF_CRV_USD__c != null ? ar.ATTRF_CRV_USD__c : 0) );
                accProductAcliDetailsMap.put(tempAccountProduct, tempContractDetails );  
            }
        }
            System.debug('In execute method,Map size:'+ accProductAcliMap.size());
            
            Set<Id> accountIdSet = new Set<Id>();
            Set<String> pdCodeSet = new Set<String>();
            List<PDD_Enhanced__c> cpLandscapeListToUpsert = new List<PDD_Enhanced__c>();
            
            for(String key : accProductAcliMap.keySet() ){   
                accountIdSet.add(key.substringBefore(';'));
                pdCodeSet.add(key.substringAfter(';'));
            }
            
            List<CA_Product_Controller__c> caproductList = [select id,Name,Product_ID__c from CA_Product_Controller__c
                                                            where Product_ID__c IN :pdCodeSet
                                                           ];
            Map<String,Id> productCodeIdMap =  new Map<String,ID>();
            for(CA_Product_Controller__C caproduct: caproductList){
                productCodeIdMap.put(caproduct.Product_ID__c,caproduct.Id);
            }
            
        List<Date> dlist ;
        
        for(String key : pddMap.keySet() ){//for(String key : accProductAcliMap.keySet() ){ 
            if( String.isNotBlank(pddMap.get(key).Contracts_from_batch__c)  ) {                
                PDD_Enhanced__c cpl = new PDD_Enhanced__c();
                //cpl.Account__c = key.substringBefore(';');
                //cpl.CA_Product_Controller__c = productCodeIdMap.get(key.substringAfter(';'));
                cpl.AccountProduct__c = key;
                cpl.Associated_Contracts__c = pddMap.get(key).Contracts_from_batch__c;
                cpl.Contracts_from_batch__c = '';
                cpl.Nearest_Dismantle_Date__c = (Date)((accProductAcliMap.get(key)).get('DISMANTLING_DATE__C'));                
                cpl.ATTRF_Product_Contract_level_Summary__c = Decimal.valueOf(accProductAcliDetailsMap.get(key).get('ATTRFSum'));
                if(acliProductDismantleDateMap.containsKey(key)){
                    dlist = new List<Date>(acliProductDismantleDateMap.get(key));                    
                    if( dlist!=null && dlist.size() > 0){
                        dlist.sort();
                        cpl.Nearest_Dismantle_Date__c = dlist.get(0);
                        dlist.clear(); 
                    } /*else {
                        cpl.Nearest_Dismantle_Date__c = null;
                    } */
                } else {
                    cpl.Nearest_Dismantle_Date__c = null;
                }              
                cpLandscapeListToUpsert.add(cpl);  
            }
        }
        
        System.debug('----------cpLandscapeListToUpsert:'+ cpLandscapeListToUpsert);
        List<Database.UpsertResult> resultList;
        if( cpLandscapeListToUpsert != null && cpLandscapeListToUpsert.size()>0 ){     
            //upsert cpLandscapeListToUpsert AccountProduct__c;
           resultList = Database.upsert(cpLandscapeListToUpsert, PDD_Enhanced__c.AccountProduct__c, false);
        }
        
        System.debug('*************heapsize:'+ Limits.getHeapSize());
        System.debug('*************heaplimit:'+ Limits.getLimitHeapSize());
        
        if( resultList != null ) {
        for(Database.UpsertResult sr : resultList){
            String msg='';
            if(!sr.isSuccess() ) {
                msg += sr.getId() + '\n'+'Error: "';        
                for(Database.Error err: sr.getErrors()){  
                     msg += err.getmessage()+'"\n\n';
                } 
            }
            if(msg!='')
                exception_List.add(msg);
        }
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('exception_List------------------------------------------------->:');
        for(String s: exception_List){
            System.debug('***:'+s);
        }
    }
    
}