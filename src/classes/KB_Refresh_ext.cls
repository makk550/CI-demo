public class KB_Refresh_ext {
    private final Case caseObj;
    Map<String,KB_Article__c> kbMap=new Map<String,KB_Article__c>();
    public String message{get;set;}
    public KB_Refresh_ext(ApexPages.StandardController stdController) {
        this.caseObj=(Case)stdController.getRecord();
        //        message='For Case#' + caseObj.casenumber + ', KB Article data sync is in progress. <br/>Please dont close this window. ';  
    }
    public void refreshCaseKB() {
        String endpointParam='';
        for(KB_Article__c kb:[SELECT id,kb_article_no__c, Status__c FROM KB_Article__c WHERE id IN (SELECT kb_article__C FROM KB_Article_Case__c WHERE case__C =:caseObj.Id)]) {
            kbMap.put(kb.kb_article_no__c.toUpperCase(),kb);
            endPointParam+=','+kb.KB_Article_No__c;
        }
        
        if(kbMap.size() > 0) {
            List<String> kbNoList=new List<String>();
            //Http h = new Http();
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
                    response=getSampleResponse();
                }else { 
                    Layer7UtilCallout service=new Layer7UtilCallout();
                    response=service.processLayer7Services(req);
                }
                //HttpResponse res = h.send(req);
                
                system.debug('kb refresh response:' + response);
                List<KB_Article__c> kbList=KBRefreshWrapper.parseResponse(response);
                List<KB_Article__c> updateKBList=new List<KB_Article__c>();
                System.debug('old kb' + kbList);
                System.debug('new  kb' +kbMap.values());
                //Iterating updated kb article list from ECM.
                for(KB_Article__c kb: kbList) {
                    system.debug('KB ' + kb);
                    if(kbMap.get(kb.KB_Article_No__c) != null && 
                       (kb.Status__c == 'PUBLISHED' ||
                        kb.Status__c == 'RETIRED'   || kb.Status__c == 'Draft' ||
                        kbMap.get(kb.KB_Article_No__c).Status__c == 'In Progress' )) {
                            //SFDC only maintains in progress or published or retired status, so other than published or retired status articles, status will be in progress.
                            if ( kb.Status__c != 'Published' &&  kb.Status__c != 'Retired') {
                                kb.Status__c = 'In Progress';                            
                            }
                            
                            kb.Id=kbMap.get(kb.KB_Article_No__c.toUpperCase()).id;
                            System.debug('in kb update list' + kb.KB_Article_No__c);
                            updateKBList.add(kb);
                            system.debug('updated kb: ' +kb);
                        }
                }
                if(updateKBList.size() > 0 ) {
                    update updateKBList;
                }
                message='For Case#' + caseObj.casenumber + ', Related KB Article are successfully refreshed, after click on Ok,  this window will close and Case window will automatically refresh.';  
            }catch(Exception e) {
                message='For Case#' + caseObj.casenumber + ', Related KB Article data refresh failed with error ' + e.getMessage() + ', after click on Ok,  this window will close and Case window will automatically refresh.';  
                system.debug(caseObj.casenumber  + ' case, KB Article refresh failed, ' + e.getMessage() );
                system.debug('response:#' + response + '#    stackTrace:' + e.getStackTraceString());
            }
        }else {
            message='For Case#' + caseObj.casenumber + ', No related KB Article to refresh. <br/>Please CLOSE window. ';  
        }
    }   
    public static String getSampleResponse() {
        String json=        '{'+
            '    "d": {'+
            '        "results": ['+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Yerramilli, Archana"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1023762",'+
            '                "CA_x0020_Doc_x0020_Title": "Test KB Creation in Chrome in QA ",'+
            '                "Workflow_x0020_Status": "Draft",'+
            '                "Modified": "2015-01-14T13:43:07Z"'+
            '            },'+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Yerramilli, Archana"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1095284",'+
            '                "CA_x0020_Doc_x0020_Title": "test",'+
            '                "Workflow_x0020_Status": "PUBLISHED",'+
            '                "Modified": "2015-09-03T19:56:32Z"'+
            '            },'+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Munnuru, Venu Gopal"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1061826",'+
            '                "CA_x0020_Doc_x0020_Title": "test 123",'+
            '                "Workflow_x0020_Status": "Draft",'+
            '                "Modified": "2015-10-13T08:44:04Z"'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        return json;
    }
}