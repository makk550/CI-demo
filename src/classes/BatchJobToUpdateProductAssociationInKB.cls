global class BatchJobToUpdateProductAssociationInKB implements Database.Batchable<sObject>, Database.stateful {
    global Map<String, String> productMap;
    global Map<ID,Integer> prodCount;
    global Map<String, ID> ecmProductIds;
    global Map<ID,set<ID>> caProductsIds;
    global ID articleId;
    global List<KCS_Association__c> listOfKcsAssociation;
    global Map<ID,knowledge__kav> mapOfArticles;
    global Integer productAssociationFlag;
    global map<String,ID> xmdMap;
    global map<ID, set<ID>> xmdCaMap;
    global boolean isColon;
    global set<String> colonProd;
    global String recordTypeIdValue;
    global Integer limitVal;
    
    global BatchJobToUpdateProductAssociationInKB(String recordIdValue,Integer limitValue){
        recordTypeIdValue = recordIdValue;
        limitVal = limitValue;
        
    }
    
    global database.QueryLocator start(Database.BatchableContext batchObj){
        productMap = new Map<String, String>();
        prodCount = new Map<ID, Integer>();
        ecmProductIds = new Map<String, ID>();
        caProductsIds = new Map<ID,set<ID>>();
        productAssociationFlag =1;
        listOfKcsAssociation = new List<KCS_Association__c>();
        xmdMap = new map<String,ID>();
        xmdCaMap = new map<ID,set<ID>>();
        mapOfArticles = new Map<ID,knowledge__kav>();
        colonProd = new set<String>();
                 //articleId = new ID();
        String listOfECMArticles ='Select id, ArticleNumber, KnowledgeArticleId, CADocid__c, Product_Names__c, Component_Codes__c, Component_Names__c, Releases__c from Knowledge__kav where recordtypeid=\''+recordTypeIdValue+'\' AND Legacy_Source__c=\'ECM\' AND publishStatus=\'Draft\' AND Product_Association_update__c=1 limit '+limitVal+' ';
        return Database.getQueryLocator(listOfECMArticles);
        
    }
    global void execute(Database.BatchableContext batchObj, List<Knowledge__kav> listOfknowledge){
        
        if(listOfknowledge <> null && listOfknowledge.size() > 0){
            System.debug(' Number of Articles to be Associated : '+ listOfknowledge.size());
            System.debug('xmdMap : '+ xmdMap);
            //System.debug('xmdCaMap : '+ xmdCaMap);
            //code to get all ECM Product and CA Product Mapping
            List<XMD_Product__c> ECM_Prod_ID = [Select ID, Name from XMD_Product__c where Name != null AND Name!=''];
            System.debug('ECM_Prod_ID : '+ ECM_Prod_ID);
            if(ECM_Prod_ID <> null && ECM_Prod_ID.size() > 0){
                set<ID> ecmIds = new set<ID>();
                for(XMD_Product__c xmdObj:ECM_Prod_ID){
                    //  System.debug('ecm Name'+xmdObj.Name+' ID : '+xmdObj.ID);
                    xmdMap.put(xmdObj.Name,xmdObj.ID);
                    ecmIds.add(xmdObj.ID);
                }
                System.debug(' xmdMap Size : '+ xmdMap.size()+ '   xmdMap : '+ xmdMap);
                List<CA_XMD_Product_Mapping__c> caProductIdsList = [select CA_Product__c,XMD_Product__c from CA_XMD_Product_Mapping__c where CA_Product__c!=null AND CA_Product__c !='' AND XMD_Product__c IN:ecmIds];
                if(caProductIdsList <> null && caProductIdsList.size() > 0){
                    
                    
                    for(CA_XMD_Product_Mapping__c xmdMappingObj: caProductIdsList){                                     
                        set<ID> caIdSet = new set<ID>();
                        if(xmdCaMap <> null && !xmdCaMap.isEmpty()){                                             
                            caIdSet = xmdCaMap.get(xmdMappingObj.XMD_Product__c);
                            if(caIdSet <> null && !caIdSet.isEmpty()){
                                caIdSet.add(xmdMappingObj.CA_Product__c);
                                xmdCaMap.put(xmdMappingObj.XMD_Product__c,caIdSet);    
                            }else{
                                caIdSet= new set<ID>();
                                caIdSet.add(xmdMappingObj.CA_Product__c);
                                xmdCaMap.put(xmdMappingObj.XMD_Product__c,caIdSet);
                            }
                            
                        }else{
                            caIdSet.add(xmdMappingObj.CA_Product__c);
                            xmdCaMap.put(xmdMappingObj.XMD_Product__c,caIdSet);
                        }
                        
                        
                    }                            
                }
            }
            
            System.debug('xmdCaMap Size : '+ xmdCaMap.size()+' xmdCaMap : '+ xmdCaMap);
            listOfKcsAssociation.clear();
            mapOfArticles.clear();
            for(knowledge__kav kbObj: listOfknowledge){
                isColon = false;
                productMap.clear();
                prodCount.clear();
                ecmProductIds.clear();
                caProductsIds.clear();
                colonProd = new set<String>();
                System.debug(' Kb Number : '+ kbObj.ArticleNumber);
                if(String.isNotBlank(kbObj.Product_Names__c) && String.isNotBlank(kbObj.Component_Codes__c)){
                    articleId = kbObj.KnowledgeArticleId;
                    set<String> ecmProdSet = new set<String>();
                    if(kbObj.Product_Names__c.contains('\n')){
                        
                        List<String> prodList = kbObj.Product_Names__c.split('\n');
                        for(String value: prodList){
                            if(String.isNotBlank(value)){
                                if(value.contains(':')){
                                    isColon=true;
                                    colonProd.add(value.trim());
                                }
                                ecmProdSet.add(value.trim());
                            }
                        }                                                 
                    }else{
                        if(kbObj.Product_Names__c.contains(':')){
                            isColon=true;
                            colonProd.add(kbObj.Product_Names__c.trim());
                        }
                        ecmProdSet.add(kbObj.Product_Names__c.trim());
                    }
                    System.debug('isColon : '+ isColon +' ecmProdSet : '+ ecmProdSet);
                    
                    // COmponents Association Start from Here --- 
                    List<String> compList= new List<String>();
                    if(String.isNotBlank(kbObj.Component_Codes__c)){
                        if(kbObj.Component_Codes__c.contains('\n')){
                            compList = kbObj.Component_Codes__c.split('\n');
                        }else{
                            compList = kbObj.Component_Codes__c.split('\n');
                        }
                        componentsAssociation(compList);
                        System.debug('Components Association done succesfully!');
                    }else{
                        System.debug(' The Article with Id :'+ kbObj.ID + ' Does not have any components in Product Association.');
                    }
                    List<String> releaseList = new List<String>();
                    if(String.isNotBlank(kbObj.Releases__c)){
                        if(kbObj.Releases__c.contains('\n')){
                            releaseList = kbObj.Releases__c.split('\n');
                        }else{
                            releaseList = kbObj.Releases__c.split('\n');
                        }
                        releasesAssociation(releaseList);
                        System.debug('Releases Association done succesfully!');
                    } 
                    kbObj.Product_Association_update__c = 2;
                    mapOfArticles.put(kbObj.ID,kbObj);
                }else{
                    System.debug(' The Article with ArticleNuber : '+kbObj.ArticleNumber+ ' Does not have Components!' );
                }
                
                
            }
            
            // Added to update Objects
            System.debug(' the number of kcs records to be inserted : '+listOfKcsAssociation.size());
             //system.debug('kcs Records details  : '+listOfKcsAssociation);
             System.debug('number of mapOfArticles to updated : '+mapOfArticles.size());    
            if(listOfKcsAssociation<>null && listOfKcsAssociation.size()>0){
                Boolean updatedFlag = false;
                Boolean updatedArticles = false;
                if(!updatedFlag){
                    
                    List<Database.SaveResult> insertProductAssociation = Database.insert(listOfKcsAssociation,false);
                    for(Database.SaveResult articleObj:insertProductAssociation){
                        if(articleObj.isSuccess()){
                            //system.debug('SUCCESSFULLY Inserted---Product Association for Article');
                        }else{
                            system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                        }                   
                    }
                    updatedFlag = true;
                    
                }
                if(updatedFlag){
                    system.debug('MapOfArticles to be Updated-'+mapOfArticles);
                    if(mapOfArticles<>null && mapOfArticles.size()>0){     
                        List<knowledge__kav> listOfAllArticles = new List<knowledge__kav>();
                        for(Id idVal:mapOfArticles.keySet()){
                            listOfAllArticles.add(mapOfArticles.get(idVal));      
                        }
                        if(listOfAllArticles<>null && listOfAllArticles.size()>0){
                            List<Database.SaveResult> updateExistingArticles = Database.update(listOfAllArticles,false);
                            for(Database.SaveResult articleObj:updateExistingArticles){
                                if(articleObj.isSuccess()){
                                    //system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                                }else{
                                    system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                                }                   }
                            updatedArticles = true;
                        }           
                    }
                }
                
            }
            
        }
        
        
    }
        
    
    global void finish(Database.BatchableContext batchObj){
        
        System.debug('Method FINISH-----');
        System.debug(' the number of kcs records to be inserted : '+listOfKcsAssociation.size());
        //system.debug('kcs Records details  : '+listOfKcsAssociation);
        System.debug('number of mapOfArticles to updated : '+mapOfArticles.size());
     /*if(listOfKcsAssociation<>null && listOfKcsAssociation.size()>0){
            Boolean updatedFlag = false;
            Boolean updatedArticles = false;
            if(!updatedFlag){
                
                  List<Database.SaveResult> insertProductAssociation = Database.insert(listOfKcsAssociation,false);
                    for(Database.SaveResult articleObj:insertProductAssociation){
                    if(articleObj.isSuccess()){
                        //system.debug('SUCCESSFULLY Inserted---Product Association for Article');
                    }else{
                        system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                    }                   
                    }
                    updatedFlag = true;
                
            }
            if(updatedFlag){
                system.debug('MapOfArticles to be Updated-'+mapOfArticles);
                if(mapOfArticles<>null && mapOfArticles.size()>0){     
                List<knowledge__kav> listOfAllArticles = new List<knowledge__kav>();
                for(Id idVal:mapOfArticles.keySet()){
                  listOfAllArticles.add(mapOfArticles.get(idVal));      
                }
                if(listOfAllArticles<>null && listOfAllArticles.size()>0){
                    List<Database.SaveResult> updateExistingArticles = Database.update(listOfAllArticles,false);
                    for(Database.SaveResult articleObj:updateExistingArticles){
                    if(articleObj.isSuccess()){
                        //system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                    }else{
                        system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                    }                   }
                    updatedArticles = true;
                }           
        }
            }
            
        }*/
    }
    
    global void componentsAssociation(List<String> compList){
        integer count =0;
        //List<String> compsplit
         System.debug('compList : '+ compList);
        for(String prodComps: compList){
            
            if(String.isNotBlank(prodComps)){
               boolean flag = false;
                String ecm_Product_name;
                List<String> compsList = new List<String>();
                if(isColon){
                    if(colonProd <> null && colonProd.size() > 0){
                        System.debug('colonProd : '+ colonProd+ 'prodComps : '+ prodComps);
                        for(String pValue:colonProd){
                           // System.debug(' prodComps.contains(pValue) : '+ prodComps.contains(pValue));
                            if(prodComps.contains(pValue)){
                               // compsList = prodComps.split(pValue+':');
                                            Integer i=prodComps.indexOf(':',1+prodComps.indexOf(':'));         
                                //system.debug('compsList :  '+compsList);
                                ecm_Product_name = pValue;
                                System.debug('---colonProd : '+ prodComps.substring(i+1));
                                compsList.add(':');
                                compsList.add(prodComps.substring(i+1));
                                flag=true;
                            }
                        }
                        if(!flag){
                            compsList = prodComps.split(':');
                            ecm_Product_name = compsList.get(0).trim();
                        }
                    }else{
                        compsList = prodComps.split(':');
                        ecm_Product_name = compsList.get(0);
                    }
                }else{
                    compsList = prodComps.split(':');
                    ecm_Product_name = compsList.get(0);
                }
                
               // String ecm_Product_name = compsList.get(0);
                System.debug('ecm_Product_name  : '+ecm_Product_name);
                if(compsList.get(1) <> null && String.isNotBlank(compsList.get(1))){
                    List<String> compDetails = compsList.get(1).split(';');
                   // System.debug('compDetails : --'+compDetails );
                    ID ecmId = xmdMap.get(ecm_Product_name);
                    System.debug(' ecmId'+ ecmId);
                    set<ID> caIdset = xmdCaMap.get(ecmId);
                    System.debug('caIdset --: '+ caIdset);
                    List<CA_Product_Component__c> listOfCAComp = [Select id,Name,CA_Product_Controller__c, Component_Code__c from CA_Product_Component__c where Component_Code__c IN:compDetails AND CA_Product_Controller__c IN:caIdset];
                    if(listOfCAComp <> null && listOfCAComp.size() > 0){
                       count++;
                        prodCount.put(ecmId,count);
                       createComponentsAssociation(count,ecmId,listOfCAComp);
                    }                    
                }                
               }              
        }
    }
      global void createComponentsAssociation(Integer productCount,ID ecmId, List<CA_Product_Component__c> componentController ){
          System.debug('method: createComponentsAssociation --- Started');
          Map<String, ID> tempMap = new Map<String, ID>();
          KCS_Association__c kcsObj;
          if(componentController <> null && componentController.size() > 0){
              for(CA_Product_Component__c compObj: componentController){
                  kcsObj = new KCS_Association__c();
                  if(!tempMap.containsKey(compObj.Component_Code__c)){
                      tempMap.put(compObj.Component_Code__c,compObj.Id);
                      kcsObj.Component_ID__c = compObj.Id;
                      kcsObj.Product_ID__c = ecmId;
                      kcsObj.Product_Count__c = productCount;    
                      kcsObj.Article_Id__c =articleId;
                      if(productCount==1){
                        kcsObj.Primary__c= true;
                      }else{
                          kcsObj.Primary__c= false;
                      }
                      listOfKcsAssociation.add(kcsObj);
                  }
              }
          }else{
              System.debug(' Components are not matching');
          }
       System.debug('Components Association records are created for Product :'+ecmId+' ---Records: '+listOfKcsAssociation);   
      }
    
    
    global void releasesAssociation(List<String> releaseList){
        System.debug(' Method: releasesAssociation --- Started --'+releaseList);
        integer count =0;
        //List<String> compsplit
         boolean flag=false;
        for(String prodReleases: releaseList){
            
            if(String.isNotBlank(prodReleases)){
               String ecm_Product_name;
                flag = false;
                List<String> releasesList = new list<String>();
                if(isColon){
                    if(colonProd <> null && colonProd.size() > 0){
                        for(String pValue:colonProd){
                            if(prodReleases.contains(pValue)){
                                //releasesList = prodReleases.split(pValue+':');
                                 Integer k=prodReleases.indexOf(':',1+prodReleases.indexOf(':'));         
                               // system.debug('compsList :  '+compsList);
                                ecm_Product_name = pValue;
                                System.debug('---colonProd : '+ prodReleases.substring(k+1));
                                releasesList.add(':');
                                releasesList.add(prodReleases.substring(k+1));
                                flag=true;
                                
                            }
                        }
                        if(!flag){
                            releasesList = prodReleases.split(':');
                            ecm_Product_name = releasesList.get(0);
                        }
                    }else{
                        releasesList = prodReleases.split(':');
                        ecm_Product_name = releasesList.get(0);
                    }
                }else{
                    releasesList = prodReleases.split(':');
                    ecm_Product_name = releasesList.get(0);    
                }
                                
                if(releasesList.get(1) <> null && String.isNotBlank(releasesList.get(1))){
                    List<String> releaseDetails = releasesList.get(1).split(';');
                    ID ecmId = xmdMap.get(ecm_Product_name);
                    set<ID> caIdset = xmdCaMap.get(ecmId);
                    List<Product_Release__c> listOfCARelease = [Select Id,Product_Release__c,Product_Material__r.CA_Product_Controller__c from Product_Release__c where Product_Material__c!=null AND Product_Material__r.CA_Product_Controller__c!=null AND Product_Material__r.CA_Product_Controller__c IN:caIdset AND Product_Release__c IN:releaseDetails];
                   
                    if(listOfCARelease <> null && listOfCARelease.size() > 0){
                        System.debug('listOfCARelease : '+ listOfCARelease);
                        if(prodCount.containsKey(ecmId)){
                            count = prodCount.get(ecmId);
                        }else{
                            count = prodCount.size() + 1;
                          prodCount.put(ecmId,count);    
                        }
                       createReleasesAssociation(count,ecmId,listOfCARelease);
                    }                    
                }                
               }              
        }
    }
      global void createReleasesAssociation(Integer productCount,ID ecmId, List<Product_Release__c> releaseController ){
          System.debug('Method: createReleasesAssociation - Started ---');
          Map<String, ID> tempMap = new Map<String, ID>();
          KCS_Association__c kcsObj;
          if(releaseController <> null && releaseController.size() > 0){
              for(Product_Release__c releaseObj: releaseController){
                  kcsObj = new KCS_Association__c();
                  if(!tempMap.containsKey(releaseObj.Product_Release__c)){
                      tempMap.put(releaseObj.Product_Release__c,releaseObj.Id);
                      kcsObj.Release_ID__c = releaseObj.Id;
                      kcsObj.Product_ID__c = ecmId;
                      kcsObj.Product_Count__c = productCount;    
                      kcsObj.Article_Id__c =articleId;                      
                      if(productCount==1){
                        kcsObj.Primary__c= true;
                      }else{
                          kcsObj.Primary__c= false;
                      }
                      listOfKcsAssociation.add(kcsObj);
                  }
              }
          }else{
              System.debug(' Releases are not matching');
          }
          System.debug('TOtal available in listOfKcsAssociation before insert : '+listOfKcsAssociation);
      }
        
}