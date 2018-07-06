global class KBArticleRefreshBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful{

    //String article ='TEC1786394';
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('SELECT id,kb_article_no__c, Status__c,KB_Article_Title__c,Status_Change_Date__c,Author__c FROM KB_Article__c');
    }

    global void execute(Database.BatchableContext BC, List<KB_Article__c> scope)
    {
        List<KB_Article__c> updateKBList=new List<KB_Article__c>();    
        Map<String,KB_Article__c> kbMap=new Map<String,KB_Article__c>();
        String endpointParam='';
        
        for (KB_Article__c kb: scope){
        
            kbMap.put(kb.kb_article_no__c.toUpperCase(),kb);
            endPointParam+=','+kb.KB_Article_No__c;
        }
        system.debug('------------???????????'+endPointParam);
            if(kbMap.size() > 0) {
              
                HttpRequest req = new HttpRequest();
                endPointParam=endPointParam.replaceFirst(',', '');
                if(System.URL.getSalesforceBaseUrl().getHost().containsIgnoreCase('cs')) {
                    req.setEndpoint(System.Label.KB_REFRESH_QA+ '?kbids=' + endPointParam);
                }else { 
                    req.setEndpoint(System.Label.KB_REFRESH_PROD+ '?kbids=' + endPointParam);
                }
                System.debug('kbMap is ' +req.getEndpoint());
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                req.setMethod('GET');
                req.setTimeout(120000);
                String response;
                try{ 
                   
                        if(Test.isRunningTest()) { 
                            response=KB_Refresh_ext.getSampleResponse();
                        }else { 
                            Layer7UtilCallout service=new Layer7UtilCallout();
                            response=service.processLayer7Services(req);
                            system.debug('kb refresh response:' + response);
                         
                        }
                        List<KB_Article__c> kbList=KBRefreshWrapper.parseResponse(response);
                    
                        System.debug('old kb' + kbList);
                        System.debug('new  kb' +kbMap.values());
                        //Iterating updated kb article list from ECM.
                        for(KB_Article__c kb: kbList) {
                            system.debug('KB ' + kb);
                            if(kbMap.get(kb.KB_Article_No__c) != null && (kb.Status__c == 'PUBLISHED' || kb.Status__c == 'RETIRED' || kb.Status__c == 'Draft' || kbMap.get(kb.KB_Article_No__c).Status__c == 'In Progress' )) {
                                    
                                    if ( kb.Status__c != 'Published' &&  kb.Status__c != 'Retired') {
                                        kb.Status__c = 'In Progress';                            
                                    }
                                    
                                    kb.Id=kbMap.get(kb.KB_Article_No__c.toUpperCase()).id;
                                    System.debug('in kb update list' + kb.KB_Article_No__c);
                                    updateKBList.add(kb);
                                    system.debug('updated kb: ' +kb);
                              }
                        }
                        
                   if(updateKBList.size()>0){
                       
                        Database.SaveResult[] srList = Database.update(updateKBList,false);
                        system.debug('updated srList: ' +srList);
                   
                   }
                   
                }catch(Exception e){}
    
      
        
            }
    }
    global void finish(Database.BatchableContext BC)
    {
    
    }
}