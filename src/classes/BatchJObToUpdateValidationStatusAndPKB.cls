//batch job to update validatiuon Status and Publish Knowledge base fields
global class BatchJObToUpdateValidationStatusAndPKB implements Database.Batchable<sObject>, Database.stateful{

    global List<Knowledge__kav> listOfUpdatedArticle;
    global Database.QueryLocator start(Database.BatchableContext bc){
        listOfUpdatedArticle = new List<Knowledge__kav>();
        String listOfECMArticles = 'Select id, CADocid__c,KnowledgeArticleId,Product_Names__c, ValidationStatus, IsVisibleInPkb,urlName,title, articleNumber from Knowledge__kav where validationstatus=\'Not Validated\' and migrated_status__c =\'Published\' and Legacy_source__c=\'ECM\' AND publishStatus=\'Draft\' ';
        return Database.getQueryLocator(listOfECMArticles);   
    }
    
    global void execute(Database.BatchableContext bc, List<Knowledge__kav> listOfArticles){
        system.debug('==>'+listOfArticles);
        listOfUpdatedArticle.clear();
        if(listOfArticles <> null && listOfArticles.size() > 0){
           for(Knowledge__kav articleObj:listOfArticles){
               try{
            Boolean flag = false;                
                system.debug(' Knowledge Article to be updated : '+ articleObj.articleNumber );
               //if(articleObj.IsVisibleInPkb){
                   articleObj.IsVisibleInPkb=true;              
                  // flag = true; 
               //}
               if(articleObj.ValidationStatus !='Validated'){
                   articleObj.ValidationStatus='Validated';
                   //flag = true; 
               }
              String artTitle = articleObj.title.trim();
               
               artTitle=artTitle.replaceAll('[^a-zA-Z0-9 ]+','');
               artTitle=artTitle.trim();
               artTitle = artTitle.replaceAll('\\s+','-');
               articleObj.urlName = artTitle;
            
                //if(flag){
                    listOfUpdatedArticle.add(articleObj);    
               //}
           }catch(Exception er){
               System.debug(' An Error Occurred while processing article : '+articleObj.articlenumber +' with an Error : '+er.getMessage());          
           }
            }
            
            if(listOfUpdatedArticle<>null && listOfUpdatedArticle.size()>0){
                System.debug('listOfUpdatedArticle :'+ listOfUpdatedArticle.size());
                List<Database.SaveResult> updateExistingArticles = Database.update(listOfUpdatedArticle,false);    
                for(Database.SaveResult articleObj:updateExistingArticles){
                    if(articleObj.isSuccess()){
                        //system.debug('SUCCESSFULLY UPDATE---ARTICLE');
                    }else
                    {
                        system.debug('Article falied id: '+articleObj.getId()+' Error message: '+articleObj.getErrors());
                    }
                }
            }
            
        }else{
            System.debug(' There are no articles to be updated!');
        }
        
        }
    
     global void finish(Database.BatchableContext bc){
         System.debug(' Method: Finish Start --- ');
         //System.debug('listOfUpdatedArticle :'+ listOfUpdatedArticle.size());
    }
    
    
        
}