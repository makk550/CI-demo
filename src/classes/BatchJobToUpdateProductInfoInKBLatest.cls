//batch job to update products,components and releases in Migrated Articles 

global class BatchJobToUpdateProductInfoInKBLatest implements Database.Batchable<sObject>, Database.stateful{
    global Map<Integer,String> mapOfProductName;
    global Map<Integer,String> mapOfCompName;
    global Map<String,set<String>> mapOfCompCode;
    global Map<String,set<String>> mapOfRelease;
    global Map<String, String> finalReleaseMap;
    global Map<Id, knowledge__kav> mapOfArticles;
    global Map<String, Map<String,String>> compCodeAndNameMap;
    global map<String, set<String>> productReleasesMap;
    global map<String,map<String,String>> defaultCodeMap;
    global List<String> ecmProduct;
    global set<String> ecmReleases;
    global set<String> ecmComponents;
    global String releases='';
    global String components='';
    global String componentNames='';
    global String products='';
    global String keywords='';
    global boolean isColon;
    global set<String> colonProd;
    global String recordTypeIdValue;
    global BatchJobToUpdateProductInfoInKBLatest(String recordId){
           recordTypeIdValue = recordId;
    }
    global database.QueryLocator start(Database.BatchableContext batchObj){
        mapOfProductName =  new Map<Integer,String>();
        mapOfCompName =  new Map<Integer,String>();
        mapOfCompCode =  new Map<String,set<String>>();
        mapOfRelease =  new Map<String,set<String>>();
        finalReleaseMap = new Map<String,String>();
        mapOfArticles = new Map<Id, knowledge__kav>();
        compCodeAndNameMap = new Map<String, Map<String,String>>();
        productReleasesMap = new Map<String, set<String>>();
        defaultCodeMap = new map<String,map<String,String>>();
        ecmProduct = new List<String>();
        ecmReleases = new set<String>();
        ecmComponents = new set<String>();
        colonProd = new set<String>();
        String listOfECMArticles = 'Select id, ArticleNumber, CADocid__c, Product_Names__c, Component_Codes__c, Component_Names__c, Releases__c, Keywords__c from Knowledge__kav where recordTypeId=\''+recordTypeIdValue+'\' and Legacy_Source__c=\'ECM\' AND publishStatus=\'Draft\' AND Product_Association_update__c=0 limit 3000';
        return Database.getQueryLocator(listOfECMArticles);   
        }
    global void execute(Database.BatchableContext batchObj, List<Knowledge__kav> listOfknowledge){
        if(listOfknowledge<>null && listOfknowledge.size()>0){
            
            Integer count=0;
            Integer prodCount =0;
            compCodeAndNameMap.clear();
            productReleasesMap.clear();
            defaultCodeMap.clear();
            list<ECM_Product_Default_Code__c> defaultCodeDetails = [select ECM_Product_Name__c,Default_Comp_Code__c,Default_Comp_Name__c from ECM_Product_Default_Code__c];
            if(defaultCodeDetails <> null && defaultCodeDetails.size() > 0){
                for(ECM_Product_Default_Code__c defObj:defaultCodeDetails){
                    map<String,String> codeDetails = new map<String,String>();
                    codeDetails.put(defObj.Default_Comp_Code__c,defObj.Default_Comp_Name__c);
                    defaultCodeMap.put(defObj.ECM_Product_Name__c,codeDetails);
                }
            }
            for(Knowledge__kav kbObj:listOfknowledge){
                isColon = false;
                count = count+1;
                products='';
                mapOfProductName.clear();
                mapOfCompCode.clear();
                ecmProduct.clear();
                ecmComponents.clear();
                mapOfRelease.clear();
                ecmReleases.clear();
                finalReleaseMap.clear();
                keywords='';
                colonProd = new set<String>();
                System.debug(' Started updates on Article : Article Number'+kbObj.ArticleNumber+'  -  CADocid : --'+ kbObj.CADocid__c);
                if(String.isNotBlank(kbObj.Product_Names__c)){
                    
                 try{
                    if(kbObj.Product_Names__c.contains(';')){
                        List<String> splitByNewLine = kbObj.Product_Names__c.split(';');
                       //System.debug('--- splitByNewLine --'+splitByNewLine );
                        for(String pName:splitByNewLine){
                            
                            if(String.isNotBlank(pName)){
                                if(pName.contains(':')){
                                    isColon=true;
                                    colonProd.add(pName.trim());
                                }
                                String prodName = pName.trim();
                                ecmProduct.add(prodName.trim());
                                products+= prodName.trim()+'\n';
                            }
                        }
                    }else{
                        if(kbObj.Product_Names__c.contains(':')){
                                    isColon=true;
                                    colonProd.add(kbObj.Product_Names__c.trim());
                                }
                        ecmProduct.add(kbObj.Product_Names__c);
                        products+= kbObj.Product_Names__c.trim()+'\n';
                    }
                //System.debug(' ecmProduct : '+ ecmProduct);
                if(String.isNotBlank(products)){
                    kbObj.Product_Names__c = products;
                    setComponentsAndReleasesMap(ecmProduct);
                }
               // System.debug('ECM - Product :'+ ecmProduct);
                //System.debug('compCodeAndNameMap : --- '+compCodeAndNameMap);
                //System.debug(' productReleasesMap : --- '+ productReleasesMap);
                System.debug('Components Mapping process Start Here --- ');
                
                if(String.isNotBlank(kbObj.Component_Codes__c)){
                    list<String> splitCompByCommas = new list<String>();
                    if(kbObj.Component_Codes__c.contains(';')){
                        
                        splitCompByCommas = kbObj.Component_Codes__c.split(';');
                        /*for(String codeNameString:codeNameSplitAll){
                            
                            if(String.isNotBlank(codeNameString) ){
                                if(codeNameString.contains(':')){
                                    list<String> codeName = codeNameString.split(':');
                                    splitCompByCommas.add(codeName[1]);
                                }else{
                                    splitCompByCommas.add(codeNameString);
                                }
                                
                            }
                        }*/
                        
                    }else{
                        /*if(kbObj.Component_Codes__c.contains(':')){
                            list<String> codeNameSplit = kbObj.Component_Codes__c.split(':');
                            if(String.isNotBlank(codeNameSplit[1])){
                                splitCompByCommas.add(codeNameSplit[1]);
                            }
                        }else{
                             splitCompByCommas.add(kbObj.Component_Codes__c);     
                        }*/
                        splitCompByCommas.add(kbObj.Component_Codes__c);
                       
                    }
                    mapOfCompCode = findECMProductForComponents(splitCompByCommas);
                }
                if(String.isNotBlank(components)){
                   // kbObj.Component_Codes__c = kbobj.Component_Codes__c.replace(components);
                   kbObj.Component_Codes__c = components;
                    components='';
                }else{
                    kbObj.Component_Codes__c = components;
                }
                if(String.isNotBlank(componentNames)){
                   // kbObj.Component_Codes__c = kbobj.Component_Codes__c.replace(components);
                   kbObj.Component_Names__c = componentNames;
                    componentNames='';
                }else{
                    kbObj.Component_Names__c = componentNames;
                }
                                                       
                    if(String.isNotBlank(kbObj.Releases__c)){
                        //List<String> releasesList;
                        List<String> releaseValues;
                        String pName;
                        String release;
                        boolean flag=false;
                        if(kbObj.Releases__c.contains(';')){
                            List<String> splitByNewLine = kbObj.Releases__c.split(';');
                            for(String relVal:splitByNewLine){
                                flag = false;
                                pName='';
                                release='';
                                releaseValues = new List<String>();
                                if(isColon){
                                    if(colonProd <> null && colonProd.size() > 0){
                                        for(String pValue:colonProd){
                                            if(relVal.contains(pValue)){
                                                Integer k=relVal.indexOf(':',1+relVal.indexOf(':'));         
                                                pName = pValue;
                                                //System.debug('---colonProd : '+ relVal.substring(k+1));
                                                releaseValues = relVal.substring(k+1).split(':');
                                                release =releaseValues[1];
                                                // releasesList.add(prodReleases.substring(k+1));
                                                flag=true;
                                            }
                                        }
                                        if(!flag){
                                            releaseValues = relVal.split(':');
                                            pName = releaseValues[0].trim();
                                            release = releaseValues[2].trim();
                                        }
                                    }else{
                                         releaseValues = relVal.split(':');
                                         pName = releaseValues[0].trim();
                                         release = releaseValues[2].trim();
                                    }
                                    
                                }else{
                                    releaseValues = relVal.split(':');
                                    pName = releaseValues[0].trim();
                                    release = releaseValues[2].trim();
                                }
                            
                            if(String.isNotBlank(release)){
                                if(mapOfRelease.containsKey(pName)){
                                    set<String> releases = mapOfRelease.get(pName);
                                    releases.add(release);
                                    mapOfRelease.put(pName, releases);
                                    
                                }else{
                                    set<String> releases = new set<String>();
                                    releases.add(release);
                                    mapOfRelease.put(pName, releases);    
                                }
                            }
                        }
                        }else{
                            
                            if(isColon){
                                    if(colonProd <> null && colonProd.size() > 0){
                                        for(String pValue:colonProd){
                                            if(kbObj.Releases__c.contains(pValue)){
                                                Integer k=kbObj.Releases__c.indexOf(':',1+kbObj.Releases__c.indexOf(':'));         
                                                pName = pValue;
                                               // System.debug('---colonProd : '+ kbObj.Releases__c.substring(k+1));
                                                releaseValues = kbObj.Releases__c.substring(k+1).split(':');
                                                release =releaseValues[1];
                                                // releasesList.add(prodReleases.substring(k+1));
                                                flag=true;
                                            }
                                        }
                                        if(!flag){
                                            releaseValues = kbObj.Releases__c.split(':');
                                            pName = releaseValues[0].trim();
                                            release = releaseValues[2].trim();
                                        }
                                    }else{
                                         releaseValues = kbObj.Releases__c.split(':');
                                         pName = releaseValues[0].trim();
                                         release = releaseValues[2].trim();
                                    }
                                    
                            }else{
                             releaseValues = kbObj.Releases__c.split(':');
                             pName = releaseValues[0].trim();
                             release = releaseValues[2].trim();
                             if(String.isNotBlank(release)){                                
                                    set<String> releases = new set<String>();
                                    releases.add(release);
                                    mapOfRelease.put(pName, releases);    
                                
                            }
                            }
                            
                        }
                        
                    }else{
                       //mapOfRelease.put(count,kbObj.Product_Names__c); 
                    }
                
                finalReleaseMap = getMappedCAReleasesForECMProduct(mapOfRelease);
                if(String.isNotBlank(releases)){
                    kbObj.Releases__c = releases;
                    releases ='';
                }else{
                    kbObj.Releases__c = releases;
                }
                
                kbObj.Product_Association_update__c=1;
                if(String.isNotBlank(keywords)){
                    if(String.isNotBlank(kbObj.Keywords__c)){
                        kbObj.Keywords__c = kbObj.Keywords__c + Keywords;
                    }else{
                        kbObj.Keywords__c = Keywords;
                    }
                        
                }
                
                //System.debug('  Article :'+kbObj.ArticleNumber +'  --- updated values : '+kbObj);
                mapOfArticles.put(kbObj.Id,kbObj);
                System.debug('Products :  '+kbObj.Product_Names__c);
                System.debug('Component:  '+kbObj.Component_Codes__c);
                System.debug('kbObj : '+ kbObj.Releases__c +' Keywords : '+kbObj.Keywords__c);
                 
                 }catch(Exception er){
                     System.debug(' Error occured while precessing Article : '+ kbObj.ArticleNumber + '  with Error Messgae :'+ er.getMessage());
                 }  
                
            }else{
                System.debug(' Article with Number '+ kbObj.ArticleNumber +'  does not have associated products!');
            }
        }
    }
    }
    global void finish(Database.BatchableContext batchObj){
        system.debug('Method FINISH-----');
        system.debug('0-00-9-9-'+mapOfArticles.size());
       if(mapOfArticles<>null && mapOfArticles.size()>0){
            Boolean updatedFlag = false;
            if(!updatedFlag){
                List<knowledge__kav> listOfAllArticles = new List<knowledge__kav>();
                for(Id idVal:mapOfArticles.keySet()){
                  listOfAllArticles.add(mapOfArticles.get(idVal));      
                }
                system.debug(' total count of Article to be updated : '+listOfAllArticles.size());
                if(listOfAllArticles<>null && listOfAllArticles.size()>0){
                  List<Database.SaveResult> updateExistingArticles = Database.update(listOfAllArticles,false);
                    for(Database.SaveResult articleObj:updateExistingArticles){
                    if(articleObj.isSuccess()){
                       // system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                    }else{
                        system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());                
                    }                   
                    }
                    updatedFlag = true;
                }
            }
            
        }
    }
    
    public Map<String, String> getMappedCAReleasesForECMProduct(Map<String,set<String>> releasesMap){
    
           Map<String,String> updatedRelease = new Map<String,String>();
           set<String> releaseSet = new set<String>();
           set<String> matchedReleasesSet = new set<String>();
           set<String> releasesFromMap = new set<String>();
           set<String> prodKeySet= releasesMap.keySet();
           set<String> relSet = new set<String>();
           //Iterator<String> keyItr = prodKeySet.Iterator();
           Integer count=0; 
        String separator = ';';
        System.debug('releasesMap : '+releasesMap);
        set<String> missingReleases = new set<String>();
        if(productReleasesMap <> null && productReleasesMap.size() > 0){
            for(String pName: ecmProduct){
                if(releasesMap.containsKey(pName)){
                    count =0;
                    relSet.clear();
                    releaseSet.clear();
                    //String pName = keyItr.next();           
                    releaseSet = releasesMap.get(pName);
                    //System.debug('pName -- '+ pName+'  releaseSet --- '+ releaseSet);
                    if(productReleasesMap.containsKey(pName)){
                        releasesFromMap = productReleasesMap.get(pName);
                        for(String release: releaseSet){
                            if(releasesFromMap.contains(release)){
                                relSet.add(release);
                            }else{
                                missingReleases.add(release);
                            }
                        }
                        if(!relSet.isEmpty()){
                            releases = releases+pName+':';
                            for(String rel: relSet){
                                count++;
                                if(count < relSet.size()){
                                    releases = releases+rel+';';
                                }
                                else{
                                    releases = releases+rel+'\n';
                                }
                            }
                        }
                    }
                }
            }
            }
        if(missingReleases <> null && missingReleases.size() > 0){
            System.debug('  Missing Releases : '+ missingReleases);
            for(String value:missingReleases){
                if(String.isNotBlank(keywords)){
                    keywords=keywords+';'+value;
                }else{
                    keywords=value;
                }
            }
        }
           System.debug(' Keywords after Release Mapping : '+ keywords);
           System.debug('Release : '+ releases);        
           return updatedRelease;
    
    }
    
    public Map<String,set<String>> findECMProductForComponents(List<String> compsList){
            Map<String, set<String>> compsMap= new Map<String, set<String>>();
            Map<String, set<String>> compNameMap = new Map<String, set<String>>();
            Map<String, String> compDetailsMap = new map<String,String>();
            set<String> matchedCompSet = new set<String>();
            //set<String> compCode = new set<String>();
            //set<String> compName = new set<String>();
        System.debug(' Function : findECMProductForComponents -> Start Here --- '+ecmProduct+'  ---- '+compsList);
            if(compCodeAndNameMap <> null && compCodeAndNameMap.size() > 0){
                for(String prod: ecmProduct){
                    set<String> compCode = new set<String>();
                    set<string> compName = new set<String>();
                    if(compCodeAndNameMap.containsKey(prod)){
                        compDetailsMap = compCodeAndNameMap.get(prod);
                        
                        for(String component: compsList){
                            if(String.isNotBlank(component) && compDetailsMap.containsKey(component.trim())){
                                
                                compCode.add(component);
                                compName.add(compDetailsMap.get(component));
                                matchedCompSet.add(component);
                        }
                    }
                        if(!compCode.isEmpty()){
                            compsMap.put(prod,compCode);
                            compNameMap.put(prod,compName);
                        }
                        else{
                            System.debug(' The Product : '+prod+'does not have any matching component. so using default component value');
                            if(defaultCodeMap.containsKey(prod)){
                               map<String,String> codeDetails = defaultCodeMap.get(prod);
                               set<String> cCode = new set<String>();
                               set<String> cName = new set<String>();
                               cCode.addAll(codeDetails.keySet());
                               cName.addAll(codeDetails.values());
                               compsMap.put(prod,cCode);
                               compNameMap.put(prod,cName);
                            }
                            
                            
                        }
                        
                }
                
              }
                
            }        
            
            if(matchedCompSet.size() != compsList.size()){
                set<String> missingComp = new set<String>();
                for(String comCode:compsList){
                    if(!matchedCompSet.contains(comCode)){
                        missingComp.add(comCode);
                        if(String.isNotBlank(keywords)){
                            keywords=keywords+';'+comCode;
                        }else{
                            keywords = comCode;
                        }
                           
                    }
                    
                }
                System.debug('  Missing Components : '+missingComp);
            }
            System.debug(' Keywords After components Mapping : '+keywords);
            displayComponentsFormat(compsMap,compNameMap);
            return compsMap;        
    }
    public void displayComponentsFormat(Map<String, set<String>> compsMap, Map<String, set<String>> compNameMap){
        String finalCompsList='';
        String finalCompNameList='';
        //String pName;
        set<String> compSet = new set<String>();
        set<String> keySet = compsMap.keySet();
        Iterator<String> itr = keySet.Iterator();
        Integer count = 0;
        for(String pName:ecmProduct){
            //pName = itr.next();
            compSet = compsMap.get(pName);
            if(compSet <> null && compSet.size() > 0){
                finalCompsList = finalCompsList + pName+':';
                count = 0;
                for(String comp: compSet){
                    count++;
                    if(count < compSet.size())
                    {
                        finalCompsList= finalCompsList + comp+';';
                    }else{
                         finalCompsList = finalCompsList + comp+'\n';       
                        }
                }
            }
        }
        components =finalCompsList;
        // Component Names formatting ----
        // set<String> compSet = new set<String>();
       // set<String> keyNameSet = compNameMap.keySet();
       // Iterator<String> itrName = keyNameSet.Iterator();
        count = 0;
        for(String pName:ecmProduct){
           // pName = itrName.next();
            compSet = compNameMap.get(pName);
            if(compSet <> null && compSet.size() > 0){
                finalCompNameList = finalCompNameList + pName+':';
                count = 0;
                for(String comp: compSet){
                    count++;
                    if(count < compSet.size())
                    {
                        finalCompNameList= finalCompNameList + comp+';';
                    }else{
                         finalCompNameList = finalCompNameList + comp+'\n';       
                        }
                }
            }
        }
        componentNames = finalCompNameList;
    }
    global void setComponentsAndReleasesMap(List<String> productSet){
        set<String> ecmProd= new set<String>();
        set<String> availableProducts = new set<String>();
       // Map<String, String> compDetailsMap = new MAp<String, String>();
       
        for(String prod: productSet){
            if(!compCodeAndNameMap.containsKey(prod)){
                ecmProd.add(prod);
            }
        }
        //System.debug(' ecmProds which are not in Store in map  ---- '+ ecmProd);
        if(!ecmProd.isEmpty()){
            list<CA_KBProductAssociation__c> compDetails = [select ECM_Product__c,Component__c,Component_Name__c from CA_KBProductAssociation__c where ECM_Product__c IN:ecmProd];
            System.debug('compDetails : '+ compDetails);
            if(compDetails <>  null && compDetails.size() > 0){
                System.debug('compDetails Size---- '+ compDetails.size());
                for(CA_KBProductAssociation__c compObj: compDetails){
                    
                    if(String.isNotBlank(compObj.ECM_Product__c) && String.isNotBlank(compObj.Component__c)){
                       // System.debug('---- 1');
                        availableProducts.add(compObj.ECM_Product__c);
                        map<String,String> compDetailsMap = compCodeAndNameMap.get(compObj.ECM_Product__c);
                        //System.debug('---- 1 compDetailsMap --'+compDetailsMap );
                        if(compDetailsMap <> null && !compDetailsMap.containsKey(compObj.Component__c)){
                           // System.debug('2  '+compObj.Component__c );
                            compDetailsMap.put(compObj.Component__c,compObj.Component_Name__c);
                            compCodeAndNameMap.put(compObj.ECM_Product__c,compDetailsMap);
                           // System.debug('compDetailsMap : -- '+ compDetailsMap);
                            //compDetailsMap.clear();
                        }else{
                            if(compDetailsMap == null || compDetailsMap.isEmpty()){
                              //  System.debug('---- 2');
                                compDetailsMap = new Map<String,String>();
                                compDetailsMap.put(compObj.Component__c,compObj.Component_Name__c);
                                compCodeAndNameMap.put(compObj.ECM_Product__c,compDetailsMap);
                            }
                        }
                    }
                    
                }
                System.debug('compCodeAndNameMap ----- : '+ compCodeAndNameMap);
            }
            if(availableProducts.size() < ecmProd.size()){
                set<String> missingProducts = new set<String>();
                for(String prod: ecmProd){
                    if(!availableProducts.contains(prod)){
                        missingProducts.add(prod);
                    }
                }
                if(missingProducts.size() > 0){
                    System.debug(' ECM Products missing in Components Mapping Table : '+ missingProducts);
                    list<ECM_Multiple_Products_Mapping__c> alternativeProd = [select ECM_Products__c,ECM_Alternative__c from ECM_Multiple_Products_Mapping__c where ECM_Products__c IN:missingProducts ];
                    if(alternativeProd <> null && alternativeProd.size() > 0){
                        set<String> prodInAlternativeObj = new set<String>();
                        for(ECM_Multiple_Products_Mapping__c prod:alternativeProd){
                            prodInAlternativeObj.add(prod.ECM_Products__c);
                            String ecm = prod.ECM_Products__c;
                            String alter = prod.ECM_Alternative__c;
                            
                            list<CA_KBProductAssociation__c> comDetails = [select ECM_Product__c,Component__c,Component_Name__c from CA_KBProductAssociation__c where ECM_Product__c =:alter];
                            if(comDetails <>  null && comDetails.size() > 0){
                              Map<String, String> cTempMap = new Map<String, String>();
                                for(CA_KBProductAssociation__c tempObj: comDetails){
                                    if(String.isNotBlank(tempObj.Component__c)){
                                        cTempMap.put(tempObj.Component__c,tempObj.Component_Name__c);
                                    }
                                }
                                compCodeAndNameMap.put(prod.ECM_Products__c,cTempMap);
                }
                        }
                        
                        if(missingProducts.size() > prodInAlternativeObj.size() ){
                            set<String> noMapping = new set<String>();
                            for(String prodIn:missingProducts ){
                                if(!prodInAlternativeObj.contains(prodIn)){
                                    noMapping.add(prodIn);
                                }
                            }
                            System.debug(' Product Missing in Both Mapping Tables  for Components 1: '+noMapping);
                        }                        
                    }else{
                        System.debug(' Product Missing in Both Mapping Tables for Components  2: '+missingProducts);
                    }
                }
            }
           
            
            list<CA_Release_Mapping__c> releaseDetails =[select ECM_Product__c,Release__c from CA_Release_Mapping__c where ECM_Product__c IN:ecmProd];
            availableProducts.clear();
            if(releaseDetails <>  null && releaseDetails.size() > 0){
                for(CA_Release_Mapping__c releaseObj:releaseDetails ){
                    if(String.isNotBlank(releaseObj.ECM_Product__c)){
                        // set<String> caReleases = new set<String>();
                         availableProducts.add(releaseObj.ECM_Product__c);
                        if(productReleasesMap.containsKey(releaseObj.ECM_Product__c)){
                            
                            set<String> caReleases = productReleasesMap.get(releaseObj.ECM_Product__c);
                            caReleases.add(releaseObj.Release__c);
                            productReleasesMap.put(releaseObj.ECM_Product__c,caReleases);
                            //caReleases.clear();
                        }else{
                           // caReleases.clear();
                            if(String.isNotBlank(releaseObj.Release__c)){
                                set<String> caReleases = new set<String>();
                                caReleases.add(releaseObj.Release__c);
                                productReleasesMap.put(releaseObj.ECM_Product__c, caReleases);
                            }
                        }
                    }
                }
                
                
            }
            // Missing Product Code for Release
            
            if(availableProducts.size() < ecmProd.size()){
                set<String> missingProducts = new set<String>();
                for(String prod: ecmProd){
                    if(!availableProducts.contains(prod)){
                        missingProducts.add(prod);
                    }
                }
                if(missingProducts.size() > 0){
                    System.debug(' ECM Products missing in Releases Mapping Table : '+ missingProducts);
                    list<ECM_Multiple_Products_Mapping__c> alternativeProdRel = [select ECM_Products__c,ECM_Alternative__c from ECM_Multiple_Products_Mapping__c where ECM_Products__c IN:missingProducts ];
                    if(alternativeProdRel <> null && alternativeProdRel.size() > 0){
                        set<String> prodInAlternativeObj = new set<String>();
                        for(ECM_Multiple_Products_Mapping__c prod:alternativeProdRel){
                            prodInAlternativeObj.add(prod.ECM_Products__c);
                            String ecm = prod.ECM_Products__c;
                            String alter = prod.ECM_Alternative__c;
                            
                            list<CA_Release_Mapping__c> relDetails = [select ECM_Product__c,Release__c from CA_Release_Mapping__c where ECM_Product__c =:alter];
                            if(relDetails <>  null && relDetails.size() > 0){
                              set<String> rTempSet = new set<String>();
                                for(CA_Release_Mapping__c tempObj: relDetails){
                                    if(String.isNotBlank(tempObj.Release__c)){
                                        rTempSet.add(tempObj.Release__c);
                                    }
                                }
                                productReleasesMap.put(ecm,rTempSet);
                }
                        }
                        if(missingProducts.size() > prodInAlternativeObj.size() ){
                            set<String> noMapping = new set<String>();
                            for(String prodIn:missingProducts ){
                                if(!prodInAlternativeObj.contains(prodIn)){
                                    noMapping.add(prodIn);
                                }
                            }
                            System.debug(' Product Missing in Both Mapping Tables Releases : '+noMapping);
                        }                        
                    }else{
                        System.debug(' Product Missing in Both Mapping Tables for Releases  : '+missingProducts);
                    }
                }
            }
        }else{
            System.debug(' COmponent and releases data available in map for all products !');
        }
    }
}