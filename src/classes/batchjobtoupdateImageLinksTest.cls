//batch job to update image links
global class batchjobtoupdateImageLinksTest implements Database.Batchable<sObject>, Database.stateful{

    global List<Knowledge__kav> listOfUpdatedArticle;
    global Map<String,String> mapOfArticle;
    global set<String> setOfDocumentName;
    global set<String> listOfArtciles;
    global String recordid;
    global Integer limitValue;
    //ka10S0000004IVgQAM
    //
    global batchjobtoupdateImageLinksTest(String recordValue,Integer limitVal){
         recordid = recordValue;
         limitValue = limitVal;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        setOfDocumentName = new set<String>();
        mapOfArticle = new Map<String,String>();
        listOfUpdatedArticle = new List<Knowledge__kav>();
        listOfArtciles = new set<String>();
        //String listOfECMArticles = 'Select id, CADocid__c, Additional_Information__c, Component_Names__c, Answer__c, ImageUpdateDate__c, Background__c, Cause__c, Content4__c, Instructions__c, Content3__c, Introduction__c, Content1__c, Question__c, Content2__c, articleNumber from Knowledge__kav where RecordTypeId=\'0121k000000CgO9\' AND ImageUpdateDate__c=null AND publishStatus=\'Draft\'';
        String listOfECMArticles = 'Select id, CADocid__c, Additional_Information__c, Component_Names__c, Answer__c, ImageUpdateDate__c, Background__c, Cause__c, Content4__c, Instructions__c, Content3__c, Introduction__c, Content1__c, Question__c, Content2__c, articleNumber from Knowledge__kav where recordtypeid=\''+recordid+'\' and Legacy_Source__c=\'ECM\' AND publishStatus=\'Online\' limit '+limitValue+' ';
        return Database.getQueryLocator(listOfECMArticles);   
    }
    
    global void execute(Database.BatchableContext bc, List<Knowledge__kav> listOfArticles){
        //system.debug('==>'+listOfArticles);
        
        for(Knowledge__kav articleObj:listOfArticles){
            //system.debug('Article Number :  '+ articleObj.ArticleNumber);
            if(String.isNotBlank(articleObj.Component_Names__c)){
                Boolean flag = false;
                boolean Anchor = false;
                //system.debug('===asasd'+articleObj.Question__c);
                //to create new image urls
                if(String.isNotBlank(articleObj.Additional_Information__c) && articleObj.Additional_Information__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Answer__c) && articleObj.Answer__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Background__c) && articleObj.Background__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Cause__c) && articleObj.Cause__c.contains('/servlet/fileField?entityId')){

                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content4__c) && articleObj.Content4__c.contains('/servlet/fileField?entityId')){

                    flag = true;
                }
                if(String.isNotBlank(articleObj.Instructions__c) && articleObj.Instructions__c.contains('/servlet/fileField?entityId')){

                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content3__c)  && articleObj.Content3__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Introduction__c) && articleObj.Introduction__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Question__c) && articleObj.Question__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content2__c) && articleObj.Content2__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                if(String.isNotBlank(articleObj.Content1__c) && articleObj.Content1__c.contains('/servlet/fileField?entityId')){
                    flag = true;
                }
                
                //To create new article reference
               // system.debug('=-=-=-=--=>>>'+articleObj.Additional_Information__c);
                /*if(String.isNotBlank(articleObj.Additional_Information__c) && articleObj.Additional_Information__c.contains('<a')){
                    System.debug('12');
                    Anchor = true;
                     findAnchorTag(articleObj.Additional_Information__c);
                    //articleObj.Additional_Information__c=createArticleReference(articleObj.Additional_Information__c);
                    System.debug(' <aKB Url Not updated : Yes '+articleObj.ArticleNumber );
                }
                if(String.isNotBlank(articleObj.Answer__c) && articleObj.Answer__c.contains('<a')){
                    System.debug('2');
                    flag = true;
                    findAnchorTag(articleObj.Answer__c);
                }
                if(String.isNotBlank(articleObj.Background__c) && articleObj.Background__c.contains('<a')){
                    System.debug('3');
                    flag = true;
                    findAnchorTag(articleObj.Background__c);
                }
                if(String.isNotBlank(articleObj.Cause__c) && articleObj.Cause__c.contains('<a')){
                    System.debug('4');
                    flag = true;
                    findAnchorTag(articleObj.Cause__c);
                }
                if(String.isNotBlank(articleObj.Content4__c) && articleObj.Content4__c.contains('<a')){
                    System.debug('5');
                    flag = true;
                    findAnchorTag(articleObj.Content4__c);
                }
                if(String.isNotBlank(articleObj.Instructions__c) && articleObj.Instructions__c.contains('<img')){
                    System.debug('6');
                    system.debug('Instructions__c :'+ articleObj.Instructions__c);
                    flag = true;
                    findAnchorTag(articleObj.Instructions__c);
                }
                if(String.isNotBlank(articleObj.Content3__c)  && articleObj.Content3__c.contains('<a')){
                    System.debug('7');
                    flag = true;
                    findAnchorTag(articleObj.Content3__c);
                }
                if(String.isNotBlank(articleObj.Introduction__c) && articleObj.Introduction__c.contains('<a')){
                    System.debug('8');
                    flag = true;
                    findAnchorTag(articleObj.Introduction__c);
                }
                if(String.isNotBlank(articleObj.Question__c) && articleObj.Question__c.contains('<a')){
                    System.debug('9');
                    flag = true;
                    findAnchorTag(articleObj.Question__c);
                }
                if(String.isNotBlank(articleObj.Content2__c) && articleObj.Content2__c.contains('<a')){
                    System.debug('10');
                    flag = true;
                    findAnchorTag(articleObj.Content2__c);
                }
                if(String.isNotBlank(articleObj.Content1__c) && articleObj.Content1__c.contains('<a')){
                    System.debug('11');
                    flag = true;
                    findAnchorTag(articleObj.Content1__c);
                    //createArticleReference(articleObj.Content1__c);
                }*/
                
                if(flag){
                    System.debug(' Url Not updated : Yes '+articleObj.ArticleNumber );
                    //listOfArtciles.add(articleObj.ArticleNumber);
                   // listOfUpdatedArticle.add(articleObj);
                }
                
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(' In Method- Finish ----');
        //System.debug('List of Articles to be update :'+listOfArtciles.size()+ '   '+ listOfArtciles);
       // System.debug(listOfUpdatedArticle);
        /*if(listOfUpdatedArticle<>null && listOfUpdatedArticle.size()>0){
            List<Database.SaveResult> updateExistingArticles = Database.update(listOfUpdatedArticle,false);    
            for(Database.SaveResult articleObj:updateExistingArticles){
                if(articleObj.isSuccess()){system.debug('SUCCESSFULLY UPDATE---ARTICLE');}else{system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());}
            }
        }*/
    }     
    global void findAnchorTag(String contentValue){
        list<String> splitVal = contentValue.split('</a>');
        /*if(splitVal.size() > 1){
            for(String urlVal:splitVal){
                String url = urlVal.substringAfter('<a');
                if(string.isNotBlank(url)){
                    if(url.contains('/articles/Knowledge/')){
                        System.debug(' Article Url : '+ url );
                    }
                    if(url.contains('File_attachment__Body__s/servlet')){
                         System.debug(' File Attchement Url : '+ url );
                    }
                    
                }
            }
        }*/
    }
    /*public String createArticleReference(String generateExactURL){
        List<String> listOfReferences = generateExactURL.split('</a>');
       // System.debug('listOfReferences : '+ listOfReferences);
        String urlValue = '';
        if(listOfReferences<>null && listOfReferences.size()>0){
            for(String referenceURL:listOfReferences){
                
                if(referenceURL.contains('<a')){
                    String urlVal = referenceURL.subStringAfter('<a').substringAfter('href="').subStringBefore('"');
                   System.debug('urlVal : '+ urlVal);
                    
                    
                    
                              //String getURL = referenceURL.get(keyVal).subStringAfter('<a href="').SubStringBefore('"');
                                 urlValue = urlValue+ referenceURL.replace(urlVal, URL.getSalesforceBaseUrl().toExternalForm()+'/articles/Knowledge/Tip-Why-is-port-8550-being-queried-when-starting-an-SSH-session-what-effect-does-this-have-on-the-SSH-session');
        }else{
                    urlValue = urlValue + referenceURL;
                }
            }
}
        system.debug(' Final URL : '+urlValue);
        return urlValue;
    }*/
    /*public String createImageReference(String generateExactURL){
        List<String> listOfReferences = generateExactURL.split('</img>');
        System.debug('listOfReferences : '+ listOfReferences);
        String urlValue = '';
        if(listOfReferences<>null && listOfReferences.size()>0){
            for(String referenceURL:listOfReferences){
                
                if(referenceURL.contains('<img')){
                    String urlVal = referenceURL.subStringAfter('<img').substringAfter('src="').subStringBefore('"');
                   System.debug('urlVal : '+ urlVal);
                    
                    
                    
                              //String getURL = referenceURL.get(keyVal).subStringAfter('<a href="').SubStringBefore('"');
                                 urlValue = urlValue+ referenceURL.replace(urlVal, '/servlet/servlet.FileDownload?file=0151k0000000f3wAAA')+'</img>';
        }else{
                    urlValue = urlValue + referenceURL;
                }
            }
}
        system.debug(' Final URL : '+urlValue);
        return urlValue;
    }*/
}