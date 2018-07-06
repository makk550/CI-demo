//batch job to update image links
global class batchjobtoupdateKbLink implements Database.Batchable<sObject>, Database.stateful{

    global List<Knowledge__kav> listOfUpdatedArticle;
    global Map<String,String> mapOfArticle;
    global set<String> setOfDocumentName;
    global String recordId;
    global String migratedStatus;
    global Integer limitValue;
    //ka10S0000004IVgQAM
    
    global batchjobtoupdateKbLink(String recordIdValue,String migStatus, Integer limitVal){
        recordId = recordIdValue;
        migratedStatus = migStatus;
        limitValue = limitVal;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        setOfDocumentName = new set<String>();
        mapOfArticle = new Map<String,String>();
        listOfUpdatedArticle = new List<Knowledge__kav>();
        String listOfECMArticles = 'Select id, CADocid__c,articleNumber, Additional_Information__c, Component_codes__c, Answer__c, ImageUpdateDate__c, Content4__c, Content2__c from Knowledge__kav where recordtypeid=\''+recordId+'\' AND ImageUpdateDate__c != null AND Legacy_Source__c=\'ECM\' AND migrated_status__c=\''+migratedStatus+'\' AND publishStatus=\'Draft\' limit '+limitValue+' ';
        return Database.getQueryLocator(listOfECMArticles);   
    }
    
    global void execute(Database.BatchableContext bc, List<Knowledge__kav> listOfArticles){
        //system.debug('==>'+listOfArticles);
        
        listOfUpdatedArticle.clear();
        for(Knowledge__kav articleObj:listOfArticles){
            system.debug('Article Number :  '+ articleObj.ArticleNumber);
            if(String.isNotBlank(articleObj.Component_codes__c)){
                Boolean flag = false;
              //  system.debug('===asasd'+articleObj.Content2__c);
                //to create new image urls
                
                //To create new article reference
              //  system.debug('=-=-=-=--=>>>'+articleObj.Introduction__c);
                
                if(String.isNotBlank(articleObj.Content4__c) && articleObj.Content4__c.contains('<a') && articleObj.Content4__c.contains('articles') && articleObj.Content4__c.contains('Knowledge')){
                    articleObj.Content4__c = createArticleReference(articleObj.Content4__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                
                if(flag){
                    listOfUpdatedArticle.add(articleObj);    
                }
            }
        }
        
        if(listOfUpdatedArticle<>null && listOfUpdatedArticle.size()>0){
            System.debug(' listOfUpdatedArticle size : ' + listOfUpdatedArticle.size());
            List<Database.SaveResult> updateExistingArticles = Database.update(listOfUpdatedArticle,false);    
            for(Database.SaveResult articleObj:updateExistingArticles){
                if(articleObj.isSuccess()){
                    //system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                }else{
                    system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(' In Method- Finish ----');
        //System.debug('List of Article to be update :'+listOfUpdatedArticle);
        System.debug(listOfUpdatedArticle.size());
      /*if(listOfUpdatedArticle<>null && listOfUpdatedArticle.size()>0){
            List<Database.SaveResult> updateExistingArticles = Database.update(listOfUpdatedArticle,false);    
            for(Database.SaveResult articleObj:updateExistingArticles){
                if(articleObj.isSuccess()){
                    //system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                }else{
                    system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                }
            }
        }*/
    }
    
    public String createArticleReference(String generateExactURL, String articleNum, String articleId){
        
        
        List<String> listOfReferences = generateExactURL.split('</a>');
        //System.debug('listOfReferences : '+ listOfReferences);
        String urlValue = '';
        Map<String,String> mapOfArticles = new Map<String,String>();
        set<String> setOfArticleVal = new Set<String>();
        if(listOfReferences<>null && listOfReferences.size()>0){
            for(String referenceURL:listOfReferences){
                System.debug(' referenceURL : '+ referenceURL);
                if(referenceURL.contains('<a') && referenceURL.contains('articles') && referenceURL.containsIgnoreCase('Knowledge')){
                    String urlVal = referenceURL.subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                    System.debug('urlVal : '+ urlVal);
                    String last10Digits=urlVal.subStringAfter('/Knowledge/');
                    System.debug( ' last10Digits : '+ last10Digits);
                    if(String.isNotBlank(urlVal) && !last10Digits.contains('-') && last10Digits.containsIgnoreCase('TEC')){//reference to article
                        mapOfArticles.put(last10Digits,referenceURL);    
                        setOfArticleVal.add(last10Digits);
                        urlValue = urlValue + referenceURL+'</a>';
                    }else{
                        urlValue = urlValue + referenceURL+'</a>';
                    }
                }else if(referenceURL.contains('<a')){
                    urlValue = urlValue + referenceURL+'</a>';
                }else{
                    urlValue = urlValue + referenceURL;
                }
            }
            if(setOfArticleVal<>null && setOfArticleVal.size()>0){
                   List<Knowledge__kav> listOfTesting = [Select id, CADocid__c,urlName from Knowledge__kav where CADocid__c IN:setOfArticleVal AND PublishStatus='Draft'];
                if(listOfTesting<>null && listOfTesting.size()>0){
                    Map<String,String> mapOfExisting = new Map<String,String>();
                    for(Knowledge__kav testObj:listOfTesting){
                        //mapOfExisting.put(testObj.CADocid__c,testObj.Id);    
                        mapOfExisting.put(testObj.CADocid__c,testObj.urlname);
                    }
                    if(mapOfArticles<>null && mapOfExisting<>null && mapOfExisting.size()>0 && mapOfArticles.size()>0){
                        for(String keyVal:mapOfExisting.keySet()){
                            if(mapOfArticles.containsKey(keyVal) && String.isNotBlank(mapOfArticles.get(keyVal))){
                              String getURL = mapOfArticles.get(keyVal).subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                                System.debug('getURL : '+ getURL);
                                if(String.isNotBlank(getURL)){
                                    urlValue = urlValue.replace(getURL, '/articles/Knowledge/'+mapOfExisting.get(keyVal));
                                }
                                 
                            }
                        }
                    }
                
            }
        }
        }else{
            urlValue = generateExactURL;
        }
        system.debug(' Final URL : '+urlValue);
        return urlValue;
    }
    
}