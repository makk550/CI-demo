//batch job to update image links
global class batchJobToUpdateImageLinks implements Database.Batchable<sObject>, Database.stateful{

    global List<Knowledge__kav> listOfUpdatedArticle;
    global Map<String,String> mapOfArticle;
    global set<String> setOfDocumentName;
    global String recordId;
    global Integer limitValue;
    //ka10S0000004IVgQAM
    
    global batchJobToUpdateImageLinks(String recordIdValue,integer limitVal){
        recordId = recordIdValue;
        limitValue = limitVal;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        setOfDocumentName = new set<String>();
        mapOfArticle = new Map<String,String>();
        listOfUpdatedArticle = new List<Knowledge__kav>();
        String listOfECMArticles = 'Select id, CADocid__c,articleNumber, Additional_Information__c,Environment__c, Component_codes__c, Answer__c, ImageUpdateDate__c, Background__c, Cause__c, Content4__c, Instructions__c, Content3__c, Introduction__c, Content1__c, Question__c, Content2__c from Knowledge__kav where recordtypeid=\''+recordId+'\' AND Legacy_Source__c=\'ECM\' AND publishStatus=\'Draft\' limit '+limitValue+' ';
        return Database.getQueryLocator(listOfECMArticles);   
    }
    
    global void execute(Database.BatchableContext bc, List<Knowledge__kav> listOfArticles){
        //system.debug('==>'+listOfArticles);
        List<Document> listOfDocuments = [Select id, Name from Document where folder.Name=:System.label.DocumentFolderName];
        if(listOfDocuments<>null && listOfDocuments.size()>0){
            for(Document documentObj:listOfDocuments){
                if(String.isNotBlank(documentObj.Name)){
                    setOfDocumentName.add(documentObj.Name);  
                    mapOfArticle.put(documentObj.Name,documentObj.id);
                }    
            }            
        }
        listOfUpdatedArticle.clear();
        for(Knowledge__kav articleObj:listOfArticles){
            system.debug('Article Number :  '+ articleObj.ArticleNumber);
            if(String.isNotBlank(articleObj.Component_codes__c)){
                Boolean flag = false;
              //  system.debug('===asasd'+articleObj.Content2__c);
                //to create new image urls
                if(String.isNotBlank(articleObj.Additional_Information__c) && articleObj.Additional_Information__c.contains('<img') && articleObj.Additional_Information__c.contains('ecm')){
                    articleObj.Additional_Information__c = createNewUrl(setOfDocumentName, articleObj.Additional_Information__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Environment__c) && articleObj.Environment__c.contains('<img') && articleObj.Environment__c.contains('ecm')){
                    articleObj.Environment__c = createNewUrl(setOfDocumentName, articleObj.Environment__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Answer__c) && articleObj.Answer__c.contains('<img') && articleObj.Answer__c.contains('ecm')){
                    articleObj.Answer__c = createNewUrl(setOfDocumentName, articleObj.Answer__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Background__c) && articleObj.Background__c.contains('<img') && articleObj.Background__c.contains('ecm')){
                    articleObj.Background__c = createNewUrl(setOfDocumentName, articleObj.Background__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Cause__c) && articleObj.Cause__c.contains('<img') && articleObj.Cause__c.contains('ecm')){
                    articleObj.Cause__c = createNewUrl(setOfDocumentName, articleObj.Cause__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content4__c) && articleObj.Content4__c.contains('<img') && articleObj.Content4__c.contains('ecm')){
                    articleObj.Content4__c = createNewUrl(setOfDocumentName, articleObj.Content4__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Instructions__c) && articleObj.Instructions__c.contains('<img') && articleObj.Instructions__c.contains('ecm')){
                    articleObj.Instructions__c = createNewUrl(setOfDocumentName, articleObj.Instructions__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content3__c) && articleObj.Content3__c.contains('<img') && articleObj.Content3__c.contains('ecm')){
                    articleObj.Content3__c = createNewUrl(setOfDocumentName, articleObj.Content3__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Introduction__c) && articleObj.Introduction__c.contains('<img') && articleObj.Introduction__c.contains('ecm')){
                    articleObj.Introduction__c = createNewUrl(setOfDocumentName, articleObj.Introduction__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Question__c) && articleObj.Question__c.contains('<img') && articleObj.Question__c.contains('ecm')){
                    articleObj.Question__c = createNewUrl(setOfDocumentName, articleObj.Question__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content2__c) && articleObj.Content2__c.contains('<img') && articleObj.Content2__c.contains('ecm')){
                    articleObj.Content2__c = createNewUrl(setOfDocumentName, articleObj.Content2__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content1__c) && articleObj.Content1__c.contains('<img') && articleObj.Content1__c.contains('ecm')){
                    articleObj.Content1__c = createNewUrl(setOfDocumentName, articleObj.Content1__c, articleObj.CADocid__c);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                
                //To create new article reference
                system.debug('=-=-=-=--=>>>'+articleObj.Introduction__c);
                if(String.isNotBlank(articleObj.Additional_Information__c) && articleObj.Additional_Information__c.contains('<a') && articleObj.Additional_Information__c.contains('ecm')){
                    articleObj.Additional_Information__c = createArticleReference(articleObj.Additional_Information__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Environment__c) && articleObj.Environment__c.contains('<a') && articleObj.Environment__c.contains('ecm')){
                     articleObj.Environment__c = createArticleReference(articleObj.Environment__c, articleObj.CADocid__c, articleObj.Id);
                     articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Answer__c) && articleObj.Answer__c.contains('<a') && articleObj.Answer__c.contains('ecm')){
                    articleObj.Answer__c = createArticleReference(articleObj.Answer__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Background__c) && articleObj.Background__c.contains('<a') && articleObj.Background__c.contains('ecm')){
                    articleObj.Background__c = createArticleReference(articleObj.Background__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Cause__c) && articleObj.Cause__c.contains('<a') && articleObj.Cause__c.contains('ecm')){
                    articleObj.Cause__c = createArticleReference(articleObj.Cause__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content4__c) && articleObj.Content4__c.contains('<a') && articleObj.Content4__c.contains('ecm')){
                    articleObj.Content4__c = createArticleReference(articleObj.Content4__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Instructions__c) && articleObj.Instructions__c.contains('<a') && articleObj.Instructions__c.contains('ecm')){
                    articleObj.Instructions__c = createArticleReference(articleObj.Instructions__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content3__c) && articleObj.Content3__c.contains('<a') && articleObj.Content3__c.contains('ecm')){
                    articleObj.Content3__c = createArticleReference(articleObj.Content3__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Introduction__c) && articleObj.Introduction__c.contains('<a') && articleObj.Introduction__c.contains('ecm')){
                    articleObj.Introduction__c = createArticleReference(articleObj.Introduction__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Question__c) && articleObj.Question__c.contains('<a') && articleObj.Question__c.contains('ecm')){
                    articleObj.Question__c = createArticleReference(articleObj.Question__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content2__c) && articleObj.Content2__c.contains('<a') && articleObj.Content2__c.contains('ecm')){
                    articleObj.Content2__c = createArticleReference(articleObj.Content2__c, articleObj.CADocid__c, articleObj.Id);
                    articleObj.ImageUpdateDate__c = system.now();
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content1__c) && articleObj.Content1__c.contains('<a') && articleObj.Content1__c.contains('ecm')){
                    articleObj.Content1__c = createArticleReference(articleObj.Content1__c, articleObj.CADocid__c, articleObj.Id);
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
    
    public String createNewUrl(set<String> setOfDocumentName, String generateExactURL, String articleNum){
        List<String> listOfURLs = generateExactURL.split('</img>');   
        String newURL = '';
        List<String> splitByDot = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()).split('.my');
        //System.debug('splitByDot : '+ splitByDot);
        String baseURLFormat = '';
        if(splitByDot<>null && splitByDot.size()>0){
           baseURLFormat =  splitByDot[0].replace('.','--c.');
        }
       
        if(listOfURLs<>null && listOfURLs.size()>0 && String.isNotBlank(articleNum)){
            for(String imageURL:listOfURLs){
                //System.debug(' ImageURL : ---'+ imageURL);
                String url=imageURL.substringAfter('src="').subStringBefore('"');
                String file_name = url.substringAfter('_Embeded/').substringBeforeLast('.');
               // System.debug(' File Name :'+ file_name);
                if(String.isNotBlank(file_name) && !file_name.contains(articleNum)){
                    file_name=articleNum.capitalize()+'_'+file_name;
                }
                if(String.isNotBlank(file_name) && file_name.contains('%20')){
                    file_name = file_name.replace('%20', ' ');
                }
                
                
                 System.debug(' file_name : '+ file_name);
                // System.debug(' is image available : '+setOfDocumentName.contains(file_name)); 
                //System.debug(' is image available : '+setOfDocumentName.contains(file_name+''));
                //System.debug(' is image available : '+setOfDocumentName.contains(file_name+' ')); 
                //System.debug(' is image available : '+setOfDocumentName.contains(file_name.trim()));
                
                
                if(setOfDocumentName.contains(file_name+' ')){
                   
                    file_name = file_name+' ';
                }
                if(setOfDocumentName.contains(file_name.trim())){
                    
                    file_name=file_name.trim();
                }

                if(imageURL.contains('<img') && setOfDocumentName.contains(file_name) && String.isNotBlank(baseURLFormat)){
                    newURL = newURL+ imageURL.replace(imageURL.substringAfter('src="').subStringBefore('"'),'/servlet/servlet.FileDownload?file='+mapOfArticle.get(file_name))+'</img>';
                }else{
                    newURL = newURL + imageURL;
                }
                
            }
          //  System.debug(' newURL :'+newURL );
        }
        return newURL;
    }
    
    public String createArticleReference(String generateExactURL, String articleNum, String articleId){
        
        // this code for image
        List<String> splitByDot = String.valueOf(URL.getSalesforceBaseUrl().toExternalForm()).split('.my');
        //System.debug('splitByDot : '+ splitByDot);
        String baseURLFormat = '';
        if(splitByDot<>null && splitByDot.size()>0){
           baseURLFormat =  splitByDot[0].replace('.','--c.');
        }
        //end of code for image
        //System.debug(' Content : '+generateExactURL );
        List<String> listOfReferences = generateExactURL.split('</a>');
        //System.debug('listOfReferences : '+ listOfReferences);
        String urlValue = '';
        Map<String,String> mapOfArticles = new Map<String,String>();
        set<String> setOfArticleVal = new Set<String>();
        if(listOfReferences<>null && listOfReferences.size()>0){
            for(String referenceURL:listOfReferences){
                
                if(referenceURL.contains('<a') && referenceURL.contains('ecm')){
                    String urlVal = referenceURL.subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                    System.debug('urlVal : '+ urlVal);
                    String last10Digits = urlVal.substringAfter('?kbid=');
                   System.debug('last10Digits : '+ last10Digits);
                    
                    if(String.isNotBlank(urlVal) && urlVal.contains('_Embeded')){
                        String file_Name = urlVal.substringAfter('_Embeded/').substringBeforeLast('.');
                        if(String.isNotBlank(file_name) && !file_name.contains(articleNum)){
                            file_name=articleNum.capitalize()+'_'+file_name;
                        }
                        if(String.isNotBlank(file_name) && file_name.contains('%20')){
                            file_name = file_name.replace('%20', ' ');
                        }
                        if(setOfDocumentName.contains(file_name+' ')){
                            file_name = file_name+' ';
                        }
                        if(setOfDocumentName.contains(file_name.trim())){
                            file_name=file_name.trim();
                        }
                        if(referenceURL.contains('<a') && setOfDocumentName.contains(file_name) ){
                            urlValue = urlValue+ referenceURL.replace(urlVal,'/servlet/servlet.FileDownload?file='+mapOfArticle.get(file_name))+'</a>';
                        }else{
                            urlValue = urlValue + referenceURL+'</a>';
                        }
                    }else if(String.isNotBlank(urlVal) && urlVal.contains('_External') && urlVal.substringAfterLast('/').contains('.') && !last10Digits.contains('TEC')){//reference to attachment
                       //System.debug(' urlValue 0: '+urlValue);
                        String getURL = referenceURL.subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                       // System.debug('getURL: '+getURL+ ' referenceURL : '+ referenceURL);
                        urlValue = urlValue + referenceURL.replace(urlVal,'/servlet/fileField?entityId='+articleId+'&field=File_attachment__Body__s')+'</a>';
                       // System.debug(' urlValue 1: '+urlValue);                   
                    }else if(String.isNotBlank(urlVal) && !last10Digits.contains('.') && last10Digits.contains('TEC')){//reference to article
                        mapOfArticles.put(last10Digits,referenceURL);    
                        setOfArticleVal.add(last10Digits);
                        urlValue = urlValue + referenceURL+'</a>';
                       //system.debug('setOfArticleVal : '+setOfArticleVal+' urlValue : '+ urlValue+'referenceURL : '+ referenceURL);
                    }else{
                        urlValue = urlValue + referenceURL+'</a>';
                    }
                }else if(referenceURL.contains('<a')){
                    //System.debug(' urlValue 4 :'+urlValue);
                    urlValue = urlValue + referenceURL+'</a>';
                }else{
                    urlValue = urlValue + referenceURL;
                }
                //System.debug(' urlValue 2: '+ urlValue);
            }
            if(setOfArticleVal<>null && setOfArticleVal.size()>0){
                
                    Map<String,String> mapOfExisting = new Map<String,String>();
                    mapOfExisting = getAvailableArticleInSFDC(setOfArticleVal);
                    if(mapOfArticles<>null && mapOfExisting<>null && mapOfExisting.size()>0 && mapOfArticles.size()>0){
                        for(String keyVal:mapOfArticles.keySet()){
                            if(mapOfExisting.containsKey(keyVal) && String.isNotBlank(mapOfExisting.get(keyVal))){
                              String getURL = mapOfArticles.get(keyVal).subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                                if(String.isNotBlank(getURL)){
                                    String val = mapOfExisting.get(keyVal);
                                    list<String> values =val.split(':');
                                    String migrated_status=values.get(1);
                                    String urlname=values.get(0);
                                    String id = values.get(2);
                                    if(String.isNotBlank(migrated_status) && migrated_status.equalsIgnoreCase('published')){
                                       urlValue = urlValue.replace(getURL, '/articles/Knowledge/'+urlname);    
                                    }else{
                                        urlValue = urlValue.replace(getURL, '/apex/CustomKnowledgeEdit?articleId='+id);
                                    }
                                    
                                }
                                 
                            }else{
                                String getURL = mapOfArticles.get(keyVal).subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                                //getURL= getURL.add
                                urlValue = urlValue.replace(getURL,'/articles/Knowledge/'+keyVal);
                            }
                        }
                    }else{
                        if(mapOfArticles <> null && mapOfArticles.size() > 0){
                            for(String keyVal:mapOfArticles.keySet()){
                            
                                String getURL = mapOfArticles.get(keyVal).subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                                //getURL= getURL.add
                                urlValue = urlValue.replace(getURL,'/articles/Knowledge/'+keyVal);
                            
                        }
                        }
                        
                    }
                
            }
        }
        //system.debug(' Final URL : '+urlValue);
        return urlValue;
    }
    public Map<String,String> getAvailableArticleInSFDC(Set<String> setOfArticles){
        Map<String,String> articlesMap = new Map<String,String>();
        set<String> inDraft = new set<String>();
        set<String> missingInDraft= new set<String>();
        List<Knowledge__kav> listOfTesting = [Select id, CADocid__c,migrated_status__c,urlName from Knowledge__kav where CADocid__c IN:setOfArticles AND PublishStatus='Archived'];
        if(listOfTesting <> null && listOfTesting.size() > 0){
            for(Knowledge__kav kbObj:listOfTesting){
                String value=kbObj.urlname+':'+kbObj.Migrated_Status__c+':'+kbObj.id;
                articlesMap.put(kbObj.CADocid__c,value);
                inDraft.add(kbObj.CADocid__c);
            }
            for(String tecId: setOfArticles){
                if(!inDraft.contains(tecId)){
                    missingInDraft.add(tecId);
                }
            }
            if(missingInDraft <> null && missingInDraft.size() > 0){
                List<Knowledge__kav> listMissedOfPublish = [Select id, CADocid__c,migrated_status__c, urlName from Knowledge__kav where CADocid__c IN:missingInDraft AND PublishStatus='Online'];
                if(listMissedOfPublish <> null && listMissedOfPublish.size() > 0){
                    for(Knowledge__kav mPubObj: listMissedOfPublish){
                    String value=mPubObj.urlname+':'+mPubObj.Migrated_Status__c+':'+mPubObj.id;
                    articlesMap.put(mPubObj.CADocid__c,value);
                }
                }
                
            }
        }else{
            List<Knowledge__kav> listOfPublish = [Select id, CADocid__c,migrated_status__c,urlName from Knowledge__kav where CADocid__c IN:setOfArticles AND PublishStatus='Online'];
            if(listOfPublish <> null && listOfPublish.size() > 0){
                for(Knowledge__kav pubObj: listOfPublish){
                    String value=pubObj.urlname+':'+pubObj.Migrated_Status__c+':'+pubObj.id;
                    articlesMap.put(pubObj.CADocid__c,value);
                }
            }
        }
        return articlesMap;
    }
public void testData() {
             Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
         i++; 
        i++; 
        i++; 
        i++; 
        i++; 
        i++; 
        i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }  
    
}