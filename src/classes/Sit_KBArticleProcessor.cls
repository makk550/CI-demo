public with sharing class Sit_KBArticleProcessor implements I {

    public interface I {
        void writeKbArticle(List<kbInfo> kbLinkData);
    }

    @TestVisible
    Layer7UtilCallout.I l7Service {get; set;}

    @TestVisible
    String baseUrl {get; set;}

    public class kbInfo{
        public Id kbArticleCaseid;
        public Id kbArticleId;
        public String kbNumber;
        public String caseId;
    }

    public Sit_KBArticleProcessor() {
        Layer7UtilCallout l7Service = new Layer7UtilCallout();
        this.l7Service = l7Service;

        this.baseUrl = l7Service.getLayer7BaseUrl() + '/kbAuthArticle';
    }

    public void writeKbArticle(List<kbInfo> kbLinkData){
        // validate we have data
        if(kbLinkData == null || kbLinkData.size() == 0){
            return;
        }

        //Build map of kbInfo objects with kb number as the key
        Map<String, kbInfo> kbInfoByKbNumber = new Map<String, kbInfo>();
        for(kbInfo kbLink : kbLinkData){
            kbInfoByKbNumber.put(kbLink.kbNumber.toUpperCase(), kbLink);
        }

        // Section 1 - Create KB Articles in Salesforce
        Map<Id, Kb_article__c> articlesFound = createKbArticles(kbInfoByKbNumber);


        // Section 2 - link KB Articles to Case
        Id caseId = kbLinkData[0].caseId;
        linkKbArticlesToCase(articlesFound, kbInfoByKbNumber, caseId);
        
    }

    private Map<Id, Kb_article__c> createKbArticles(Map<String, kbInfo> kbInfoByKbNumber) {
        //find articles already created in salesforce and enrich kbinfo with kb article ids
        enrichWithKbArticles(kbInfoByKbNumber);

        // create new KB Articles for any that do not exist in Salesforce
        List<String> kbArticleNumNotFound = new List<String>();
        for(KbInfo kbLink : kbInfoByKbNumber.values()){
            if(kbLink.kbArticleId == null){
                kbArticleNumNotFound.add(kbLink.kbNumber);
            }
        }
        if (kbArticleNumNotFound.size() > 0) {
            try {
                log.info('Validating KB Articles: ' + String.join(kbArticleNumNotFound, ', '));
                KbValidationResult[] validatedResults = validateKbArticles(kbArticleNumNotFound);
                log.debug(validatedResults);
                KB_Article__c[] articlesToInsert = new KB_Article__c[]{};
                for(KbValidationResult validatedResult : validatedResults){
                    if (validatedResult.isValid() && validatedResult.kbArticle.Id == null) {
                        articlesToInsert.add(validatedResult.kbArticle);
                    }
                }
                if(articlesToInsert.size() > 0) {
                    insert articlesToInsert;
                }
            } catch (KbArticleProcessorException ex) {
                log.error(ex);
            }
        }

        //after inserting new kb articles in salesforce, re-retrieve articles and enrich kbinfo with kb article ids
        return enrichWithKbArticles(kbInfoByKbNumber);
    }

    private Map<Id, Kb_article__c> enrichWithKbArticles(Map<String, kbInfo> kbInfoByKbNumber) {
        Map<Id, Kb_article__c> articlesFound = new Map<Id, Kb_article__c>([SELECT Id, KB_Article_No__c FROM KB_Article__c WHERE KB_Article_No__c IN : kbInfoByKbNumber.keyset()]);
        for(KB_Article__c article : articlesFound.values()){
            Kbinfo kbLink = kbInfoByKbNumber.get(article.KB_Article_No__c.toUpperCase());
            kbLink.kbArticleId = article.Id;
        }
        return articlesFound;
    }

    private void linkKbArticlesToCase(Map<Id, Kb_article__c> articlesFound, Map<String, kbInfo> kbInfoByKbNumber, Id caseId) {
        //Retreive the ids for kb articles that have already been linked to this case
        List<KB_Article_Case__c> linkedKbArticleCases = [Select Id, KB_Article__c, KB_Article__r.KB_Article_No__c from KB_Article_Case__c where Case__c = :caseId and KB_Article__c IN :articlesFound.keyset()];
        for(KB_Article_Case__c linkedKbArticleCase : linkedKbArticleCases){
            Kbinfo kbLink = kbInfoByKbNumber.get(linkedKbArticleCase.KB_Article__r.KB_Article_No__c.toUpperCase());
            kbLink.kbArticleCaseid = linkedKbArticleCase.Id;
        }

        //link kb articles to case
        List<KB_Article_Case__c> kbArticleCases = new List<KB_Article_Case__c>();
        for(kbinfo kbLink : kbInfoByKbNumber.values()){
             KB_Article_Case__c kbArticleCase = new KB_Article_Case__c(Case__c = kbLink.caseId, KB_Article__c = kbLink.KbArticleId);
             if(kbArticleCase.KB_Article__c != null && kbLink.kbArticleCaseid == null){
                kbArticleCases.add(kbArticleCase);
             }
        }
        insert kbArticleCases;

        // enrich kb info with id article to case link ids
        for(KB_Article_Case__c kbArticleCase : kbArticleCases ){
            Kb_article__c article = articlesFound.get(kbArticleCase.KB_Article__c);
            KbInfo kbLink = kbInfoByKbNumber.get(article.KB_Article_No__c.toUpperCase());
            kbLink.kbArticleCaseid = kbArticleCase.Id;
        }
    }

    private KbValidationResult[] validateKbArticles(String[] kbArticleNums) {
        KbValidationResult[] returnList = new KbValidationResult[]{};
        for (String kbArticleNum : kbArticleNums) {
            String endpoint = baseUrl + '?kbid='+kbArticleNum;
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endPoint);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(120000);

            String responseFromService = l7Service.processLayer7Services(req);
            if (serviceIsDown(responseFromService)) {
                throw new KbArticleProcessorException('ECM is not working in this environment.');
            }
            KbValidationResult kbArticle = parseResponse(responseFromService);
            returnList.add(kbArticle);
        }
        return returnList;
    }

    private Boolean serviceIsDown(String response) {
        return response.startsWith('<');
    }

    public class KbValidationResult {
        KB_Article__c kbArticle;
        String errorCode;
        String errorDescription;
        String errorMessage;
        String resBody;

        public boolean isValid(){
            return this.kbArticle.KB_Article_Title__c != null;
        }
    }

    public class KbArticleProcessorException extends Exception {}


    private KbValidationResult parseResponse(String resBody) {
        log.debug(resBody);
        KbValidationResult result = new KbValidationResult();
        result.resBody = resBody;
        KB_Article__c kbarticle = new KB_Article__c();
        result.kbArticle = kbArticle;

        JSONParser parser = JSON.createParser(resBody);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'Status__c') {
                        String status = parser.getText();
                        if (status == 'Published' || status == 'Retired') {
                            kbarticle.Status__c = parser.getText();
                        } else {
                            kbarticle.Status__c = 'In Progress';
                        }
                    } else if (text == 'KB_Article_Title__c') {
                        kbarticle.KB_Article_Title__c = parser.getText();
                    } else if (text == 'Author__c') {
                        kbarticle.Author__c = parser.getText();
                    }else if (text =='KB_Article_No__c'){
                        kbArticle.KB_Article_No__c = parser.getText().toUpperCase();
                    } else if (text == 'Modified_date') {
                        kbarticle.Status_Change_Date__c=parser.getDateTimeValue();
                    } else if (text == 'id') {
                        kbarticle.Id = parser.getText();
                    } else if (text == 'code') {
                        result.errorCode = parser.getText();
                    } else if (text == 'description') {
                        // error
                        result.errorDescription = parser.getText();
                    } else if (text == 'message') {
                        result.errorMessage = parser.getText();
                    }
                }
            }
        }
        log.debug(result);
        return result;
    }

}