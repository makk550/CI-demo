//Associated Test Class : Test_BatchCustomerProductLandscape
global class BatchToPopulateCustomerProductLandscape implements Database.Batchable<sObject>,Database.Stateful {

    //Map<String,Date> aclMap = new Map<String,Date>();    
   
    Integer totalRecordsUpserted ;
    
    global BatchToPopulateCustomerProductLandscape() {
        totalRecordsUpserted = 0;
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){         
         System.debug('In start');
        String query = 'select id,Contract_Product__r.Active_Contract__r.Account__c,  PRODUCT_CODE__C,' ;
         query += 'Contract_Item__c,';
         query += 'Product_Instance_ID__c,Product_Material__c, Product_Material__r.Product_ID__c'; //CA_Product_Controller__c' ; //.Product_ID__c ' ;
         query += ' from Active_Contract_Line_Item__c ' ;
         query += ' where  LastModifiedDate = LAST_N_DAYS:150 ' ;  
         query += 'and Product_Material__r.Product_ID__c != null and Contract_Product__r.Active_Contract__r.Account__c != null' ;
         //query += ' and Product_Material__r.Product_ID__c = \'PD0598\' and Contract_Product__r.Active_Contract__r.Account__c = \'0013000000HQXhI\'' ;
         
        // query += ' and (Product_Material__c= \'a2Fa000000245UdEAI\' and Contract_Product__r.Active_Contract__r.Account__c = \'001a000001J6YuDAAV\') ';
         //(Product_Material__c= \'a2Fa000000245UdEAI\' OR Product_Material__c=\'a2Fa0000002ESqG\') and
         return Database.getQueryLocator(query); 
     }
    
    global void execute(Database.BatchableContext BC,List<Active_Contract_Line_Item__c> aggrACLByAccountProduct){   
        
        System.debug('In execute');
        //System.debug('aggrResult.size():'+aggrACLByAccountProduct.size());
        //System.debug('aggrResult:'+aggrACLByAccountProduct);
        String tempAccountProduct;
        Date tempDismantleDate;
        Map<String,String> accProdCNoMap = new Map<String,String>();
        Map<String,Active_Contract_Line_Item__c> accProductAcliMap = new Map<String,Active_Contract_Line_Item__c>();
        Map<String,Map<String,String>> accProductAcliDetailsMap = new Map<String,Map<String,String>>();

         for(Active_Contract_Line_Item__c ar : aggrACLByAccountProduct) {             
             tempAccountProduct = ar.Contract_Product__r.Active_Contract__r.Account__c + ';' + ar.Product_Material__r.Product_ID__c; //('CA_Product_Controller__c'); 
             if(accProdCNoMap.containsKey(tempAccountProduct)){
                 accProdCNoMap.put(tempAccountProduct, accProdCNoMap.get(tempAccountProduct) + ';' + ar.Contract_Item__c);
             } else {
                 accProdCNoMap.put(tempAccountProduct, ar.Contract_Item__c );
             }
             
            /* 
            tempAccountProduct = ar.Contract_Product__r.Active_Contract__r.Account__c + ';' + ar.Product_Material__r.Product_ID__c; //('CA_Product_Controller__c'); 
            tempDismantleDate = ar.DISMANTLING_DATE__C;
         
            if(accProductAcliMap.containsKey(tempAccountProduct)){
                
                //if(accProductAcliMap.get(tempAccountProduct).DISMANTLING_DATE__C < tempDismantleDate ){
                //System.debug('-----------------1--'+accProductAcliMap.containsKey(tempAccountProduct));
                if(  tempDismantleDate < (Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C'))  ){
                    //System.debug('tempDismantleDate:'+ tempDismantleDate + ';accProductAcliMap.get(DISMANTLING_DATE__C)):'+(Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C'))  );
                    accProductAcliMap.put(tempAccountProduct, ar);
                    //System.debug('In if, accProductAcliMap.get:'+ accProductAcliMap.get(tempAccountProduct));
                }
                
                //ContractNumbers:
                 Map<String,String> tempContractDetails = accProductAcliDetailsMap.get(tempAccountProduct);
                 tempContractDetails.put( 'ContractNumbers', tempContractDetails.get('ContractNumbers') + ';' + ar.Contract_Item__c );
                 tempContractDetails.put( 'ATTRFSum', String.valueOf( Decimal.valueOf(tempContractDetails.get('ATTRFSum')) +  (ar.Orig_ATTRF_LC__c != null ? ar.Orig_ATTRF_LC__c : 0) ) );
                 accProductAcliDetailsMap.put(tempAccountProduct, tempContractDetails );
            } else {
                accProductAcliMap.put(tempAccountProduct, ar);
                
                //ContractNumbers:
                Map<String,String> tempContractDetails = new Map<String,String>();
                tempContractDetails.put('ContractNumbers',ar.Contract_Item__c);
                tempContractDetails.put('ATTRFSum', String.valueOf(ar.Orig_ATTRF_LC__c != null ? ar.Orig_ATTRF_LC__c : 0) );
                accProductAcliDetailsMap.put(tempAccountProduct, tempContractDetails );  
            } */ 
            System.debug('In execute method,Map size:'+ accProductAcliMap.size());
        }
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<String> pdCodeSet = new Set<String>();
        List<PDD_Enhanced__c> cpLandscapeListToUpsert = new List<PDD_Enhanced__c>();
        /*
        for(String key : accProductAcliMap.keySet() ){   
            accountIdSet.add(key.substringBefore(';'));
            pdCodeSet.add(key.substringAfter(';'));
        } */
        for(String key : accProdCNoMap.keySet() ){   
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
        
       // DateTime lastFewHours = System.now().addHours(-3);
       /* List<PDD_Enhanced__c> pddEnhancedList = [select id,LastModifiedDate,AccountProduct__c, Nearest_Dismantle_Date__c
                                                 , ATTRF_Product_Contract_level_Summary__c, Associated_Contracts__c
                                                 from PDD_Enhanced__C where LastModifiedDate > :lastFewHours                                                  
                                                ]; */
        /*Map<String,PDD_Enhanced__c> pddEnhancedMap = new Map<String,PDD_Enhanced__c>();
        for(PDD_Enhanced__C pdd: [select id,LastModifiedDate,AccountProduct__c, Nearest_Dismantle_Date__c
                                                 , ATTRF_Product_Contract_level_Summary__c, Associated_Contracts__c
                                                 from PDD_Enhanced__C 
                                                where AccountProduct__c IN: accProductAcliMap.keySet()                                              
                                                ]){
            pddEnhancedMap.put(pdd.AccountProduct__c, pdd);
        } */
        
         for(String key : accProdCNoMap.keySet() ){ //for(String key : accProductAcliMap.keySet() ){ 
             PDD_Enhanced__c cpl = new PDD_Enhanced__c();
             cpl.Account__c = key.substringBefore(';');
             cpl.CA_Product_Controller__c = productCodeIdMap.get(key.substringAfter(';'));
             cpl.AccountProduct__c = key;
             
             List<PDD_Enhanced__c> existingPDD = [select id,LastModifiedDate,AccountProduct__c,Associated_Contracts__c
                                                  ,Contracts_from_batch__c
                                                  from PDD_Enhanced__c where AccountProduct__c = :key];
             if(existingPDD != null && existingPDD.size()>0 && String.isNotBlank(existingPDD[0].Contracts_from_batch__c ) )
                cpl.Contracts_from_batch__c = existingPDD[0].Contracts_from_batch__c + ';' + accProdCNoMap.get(key);
             else
                 cpl.Contracts_from_batch__c = accProdCNoMap.get(key);
             
             /*
             if(pddEnhancedMap.containsKey(key) && String.isNotBlank(pddEnhancedMap.get(key).Associated_Contracts__c) ){                 
                 cpl.Associated_Contracts__c = pddEnhancedMap.get(key).Associated_Contracts__c + ';' + accProductAcliDetailsMap.get(key).get('ContractNumbers');
             } else {
                 cpl.Associated_Contracts__c = accProductAcliDetailsMap.get(key).get('ContractNumbers');
             }      
            */
             
             cpLandscapeListToUpsert.add(cpl);            
        }
        
        System.debug('----------cpLandscapeListToUpsert:'+ cpLandscapeListToUpsert);
        if( cpLandscapeListToUpsert != null && cpLandscapeListToUpsert.size()>0 ){            
            totalRecordsUpserted += cpLandscapeListToUpsert.size();        
            //upsert cpLandscapeListToUpsert AccountProduct__c;
            Database.upsert(cpLandscapeListToUpsert,PDD_Enhanced__c.AccountProduct__c,false);
        }
        
    }         
    
    global void finish(Database.BatchableContext BC){
        System.debug('In finish, totalRecordsUpserted:'+totalRecordsUpserted);
        Database.executeBatch(new BatchToUpdatePDDFromACLI());
    }
    
}