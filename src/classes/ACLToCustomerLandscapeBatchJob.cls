global class ACLToCustomerLandscapeBatchJob { //implements Database.Batchable<AggregateResult>,Database.Stateful { 

    List<PDD_Enhanced__c> customerLandscapeList ;
    Map<String, AggregateResult> accProductAcliMap; //Active_Contract_Line_Item__c
    List<PDD_Enhanced__c> cplList;
    String tempAccountProduct;
    Date tempDismantleDate;
    
    global ACLToCustomerLandscapeBatchJob() {
        customerLandscapeList = new List<PDD_Enhanced__c>();
        accProductAcliMap = new Map<String,AggregateResult>(); //Active_Contract_Line_Item__c
        cplList = new List<PDD_Enhanced__c>();        
    }
    
    global Iterable<AggregateResult> start(Database.BatchableContext BC){ 
        System.debug('In start');
        String query = 'select id,Contract_Product__r.Active_Contract__r.Account__c, DISMANTLING_DATE__C, PRODUCT_CODE__C,' ;
         query += 'Product_Instance_ID__c,Product_Material__c, Product_Material__r.Product_ID__c'; //CA_Product_Controller__c' ; //.Product_ID__c ' ;
         query += ' from Active_Contract_Line_Item__c ' ;
         query += ' where  LastModifiedDate = LAST_N_DAYS:50 ' ;
        //(Product_Material__c= \'a2Fa000000245UdEAI\' OR Product_Material__c=\'a2Fa0000002ESqG\') and
         query += ' group by Product_Material__r.Product_ID__c ,Product_Material__c,' ;
         query += 'id,Contract_Product__r.Active_Contract__r.Account__c, DISMANTLING_DATE__C, PRODUCT_CODE__C, Product_Instance_ID__c' ;
        return new ACLAggregateResultIterable(query); 
    } 

    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        System.debug('In execute');
        System.debug('aggrResult.size():'+scope.size());
        System.debug('aggrResult:'+scope);
        
        Map<String,Active_Contract_Line_Item__c> accProductAcliMap = new Map<String,Active_Contract_Line_Item__c>();
        Map<String,Map<String,String>> accProductAcliDetailsMap = new Map<String,Map<String,String>>();
        
         for(sObject sObj : scope) {
            AggregateResult ar = (AggregateResult)sObj;
           /* tempAccountProduct = (String) ar.get('Account__c') + ';' + (String) ar.get('Product_ID__c'); //('CA_Product_Controller__c'); 
            tempDismantleDate = (Date) ar.get('DISMANTLING_DATE__C');// -- does this come from acli?
            System.debug('id:' + ar.get('id') + ';accId:'+ tempAccountProduct  + 'tempDismantleDate:'+ tempDismantleDate);
            
            if(accProductAcliMap.containsKey(tempAccountProduct)){
                //if(accProductAcliMap.get(tempAccountProduct).DISMANTLING_DATE__C < tempDismantleDate ){
                System.debug('-----------------1--'+accProductAcliMap.containsKey(tempAccountProduct));
                if( tempDismantleDate < (Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C')) ){
                    System.debug('tempDismantleDate:'+ tempDismantleDate + ';accProductAcliMap.get(DISMANTLING_DATE__C)):'+(Date)((accProductAcliMap.get(tempAccountProduct)).get('DISMANTLING_DATE__C'))  );
                    accProductAcliMap.put(tempAccountProduct, ar);
                    System.debug('In if, accProductAcliMap.get:'+ accProductAcliMap.get(tempAccountProduct));
                }
            } else {
                accProductAcliMap.put(tempAccountProduct, ar);
                System.debug('In else, accProductAcliMap.get:'+ accProductAcliMap.get(tempAccountProduct));
            } 
            System.debug('In execute method,Map size:'+ accProductAcliMap.size());
			* ************             
            tempAccountProduct = ar.get('Contract_Product__r.Active_Contract__r.Account__c') + ';' + ar.get('Product_Material__r.Product_ID__c'); //('CA_Product_Controller__c'); 
            tempDismantleDate = ar.get('DISMANTLING_DATE__C');
           // System.debug('id:' + ar.get('id') + ';accId:'+ tempAccountProduct  + 'tempDismantleDate:'+ tempDismantleDate);
         
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
                //System.debug('In else, accProductAcliMap.get:'+ accProductAcliMap.get(tempAccountProduct));
                
                //ContractNumbers:
                Map<String,String> tempContractDetails = new Map<String,String>();
                tempContractDetails.put('ContractNumbers',ar.Contract_Item__c);
                tempContractDetails.put('ATTRFSum', String.valueOf(ar.Orig_ATTRF_LC__c != null ? ar.Orig_ATTRF_LC__c : 0) );
                accProductAcliDetailsMap.put(tempAccountProduct, tempContractDetails );  
            } 
            System.debug('In execute method,Map size:'+ accProductAcliMap.size());
             
             
             
        }
        
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
        
         for(String key : accProductAcliMap.keySet() ){ 
            // System.debug('ATTRFSum:'+ accProductAcliDetailsMap.get(key).get('ATTRFSum'));
            // System.debug(' accProductAcliDetailsMap.get(key).get(ContractNumbers):'+ accProductAcliDetailsMap.get(key).get('ContractNumbers'));
             PDD_Enhanced__c cpl = new PDD_Enhanced__c();
             cpl.Account__c = key.substringBefore(';');
             cpl.CA_Product_Controller__c = productCodeIdMap.get(key.substringAfter(';'));
             cpl.AccountProduct__c = key;
             cpl.Nearest_Dismantle_Date__c = (Date)((accProductAcliMap.get(key)).get('DISMANTLING_DATE__C'));
             cpl.ATTRF_Product_Contract_level_Summary__c = Decimal.valueOf(accProductAcliDetailsMap.get(key).get('ATTRFSum'));
             cpl.Associated_Contracts__c = accProductAcliDetailsMap.get(key).get('ContractNumbers');
             cpLandscapeListToUpsert.add(cpl);            
        }
        
        System.debug('----------cpLandscapeListToUpsert:'+ cpLandscapeListToUpsert);
        if( cpLandscapeListToUpsert != null && cpLandscapeListToUpsert.size()>0 ){            
            totalRecordsUpserted += cpLandscapeListToUpsert.size();        
        	upsert cpLandscapeListToUpsert AccountProduct__c;
        }  */
         }//delete this on uncomment
    } 

    global void finish(Database.BatchableContext BC){        
        System.debug('Map size:'+ accProductAcliMap.size());
        Integer i=0;
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
        
         for(String key : accProductAcliMap.keySet() ){ 
             PDD_Enhanced__c cpl = new PDD_Enhanced__c();
             cpl.Account__c = key.substringBefore(';');
             cpl.CA_Product_Controller__c = productCodeIdMap.get(key.substringAfter(';'));
             cpl.AccountProduct__c = key;
             cpl.Nearest_Dismantle_Date__c = (Date)((accProductAcliMap.get(key)).get('DISMANTLING_DATE__C'));
             cpLandscapeListToUpsert.add(cpl);            
        }
        
        System.debug('----------cpLandscapeListToUpsert:'+ cpLandscapeListToUpsert);
        
        upsert cpLandscapeListToUpsert AccountProduct__c;
        
     
        
        
        
    } 
}