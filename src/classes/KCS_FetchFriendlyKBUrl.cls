@RestResource(urlMapping='/fetch-kb-url')
global class KCS_FetchFriendlyKBUrl {
    
    global class KBUrlResponse {
        global String status;
        global String kbUrl; 
    }
    
    @HttpGet
    global static void fetchKBUrl() {
        String jsonResponse = null;
        String legacyId = RestContext.request.params.get('legacyId');
        RestResponse restResponse = RestContext.response;
        restResponse.addHeader('Content-Type', 'application/json');

        String url;
        if( String.isNotBlank(legacyId) ){
            List<Knowledge__kav> articleList =  [Select id,urlname ,ArticleNumber from Knowledge__kav 
                                                 where publishStatus='Online' AND IsVisibleInPkb = TRUE 
                                                 AND  CADocid__c=:legacyId];
            if( articleList != null && articleList.size() > 0 ){
                url = System.Label.siteURL + articleList[0].urlname.toLowerCase()+'/kb'+articleList[0].articlenumber; 
            }else{
                url= System.Label.KCS_Page_Not_Found ;
            }
        } else {
            url= System.Label.KCS_Page_Not_Found ;
        }
        KBUrlResponse response = new KBUrlResponse();
        response.status = 'success';
        response.kbUrl = url;
        jsonResponse = JSON.serialize(response);
        System.debug('jsonResponse:'+jsonResponse);
        restResponse.responseBody = blob.valueOf(jsonResponse);       
        return;        
    }
    
}