public without sharing class Sit_IframeController {
    @TestVisible
    private Case myCase;

    public String searchTerm {
        get {
            String tempSub = myCase.Subject.replace('\\','\\\\');
            tempSub   = String.escapeSingleQuotes(tempSub);
            return  tempSub;
        }
    }

    public String product {
        get {
            SCKBProductMap__c[] queryProducts = [SELECT KB_Product_Name__c FROM SCKBProductMap__c WHERE SCProduct__c =: myCase.CA_Product_Controller__c LIMIT 1];
            if(queryProducts.size() > 0){
                return queryProducts[0].KB_Product_Name__c;
            }else{
                return myCase.CA_Product_Controller__r.Name;
            }

        }
    }

    @TestVisible
    private Sit_KBArticleProcessor.I kbArticleProcessor {
        get {
            if (kbArticleProcessor == null) {
                kbArticleProcessor = new Sit_KBArticleProcessor();
            }
            return kbArticleProcessor;
        }
        set;
    }

    public String knowledgeData {get; set;}

    public class KnowledgeInfo {
        public String kbId;
        public String title;
        public String url;
        public String sourceName;
    }

    public Sit_IframeController() {
    }

    public Sit_IframeController(ApexPages.StandardController stdController) {
        stdController.addFields(new String[]{
            'Subject',
            'CA_Product_Controller__r.Name',
            'CA_Product_Controller__c',
            'Id'
        });
        this.myCase = (Case)stdController.getRecord();
    }

    public void writeToCaseRelated(){
        List<KnowledgeInfo> articles;
        try {
            articles = (List<KnowledgeInfo>)JSON.deserialize(knowledgeData, List<KnowledgeInfo>.class);
        } catch (Exception ex) {
            log.warn('Ignoring bad input: ' + knowledgeData);
            return;
        }
        Map<String, Case_Related_Object__c> caseRelatedObjectsByUrl = new Map<String, Case_Related_Object__c>();

        //loop through articles to seperate knowledge base articles from the rest
        List<Sit_KBArticleProcessor.KbInfo> kbArticles = new List<Sit_KBArticleProcessor.KbInfo>();
        for(KnowledgeInfo article : articles){
            if(article.sourceName == 'Knowledge Base Articles'){
                Sit_KBArticleProcessor.KbInfo kbArticle = new Sit_KBArticleProcessor.KbInfo();
                kbArticle.kbNumber = article.kbID.toUpperCase();
                kbArticle.caseId = myCase.Id;
                kbArticles.add(kbArticle);
            }else{
                Case_Related_Object__c cro = buildCaseRelatedObject(article);
                caseRelatedObjectsByUrl.put(cro.Url__c, cro);
            }
        }

        Set<String> kbNumbersNotAdded = insertKbArticleLinks(kbArticles);

        //if there were any kbarticles not added, add them as a case related object instead
        if(kbNumbersNotAdded.size() > 0){
            for(KnowledgeInfo article: articles){
                if(kbNumbersNotAdded.contains(article.kbid.toUpperCase())){
                    Case_Related_Object__c cro = buildCaseRelatedObject(article);
                    caseRelatedObjectsByUrl.put(cro.URL__c, cro);
                }
             }
        }

         upsertCaseRelatedObjects(caseRelatedObjectsByUrl);
    }

    private Case_Related_Object__c buildCaseRelatedObject(KnowledgeInfo article) {
        Case_Related_Object__c tempArticle = new Case_Related_Object__c();
        tempArticle.Title__c = article.title;
        tempArticle.Source__c = article.sourceName;
        tempArticle.URL__c = article.url;
        tempArticle.CaseId__c = myCase.Id;
        return tempArticle;
    }

    // links KB articles to case, but only if the article exists in the database
    // return a list of kb numbers that were not inserted because the kb article did not exist
    private Set<String> insertKbArticleLinks(Sit_KBArticleProcessor.KbInfo[] kbArticles) {
        if(kbArticles.size() > 0){
            //RelateKBArticleToCase.writeKbArticle(kbArticles);
            kbArticleProcessor.writeKbArticle(kbArticles);
        }

        //check to see if any kbarticles were not added by checking to see if kbArticleCaseId has been populated
        Set<String> kbNumbersNotAdded = new Set<String>();
        for(Sit_KBArticleProcessor.KbInfo  kbArticleCase : kbArticles){
            if(kbArticleCase.kbArticleCaseid == null){
                kbNumbersNotAdded.add(kbArticleCase.kbNumber.toUpperCase());
            }
        }
        return kbNumbersNotAdded;
    }

    // relate articles to case by linking then in the case related object
    // if the article is already linked, update it to ensure the information is current
    private void upsertCaseRelatedObjects(Map<String, Case_Related_Object__c> caseRelatedObjectsByUrl) {
         Case_Related_Object__c[] caseRelatedObjectsToRemove = [SELECT Id, URL__c FROM Case_Related_Object__c WHERE URL__c IN :caseRelatedObjectsByUrl.keyset() AND CaseId__c = :myCase.Id];
         for(Case_Related_Object__c article: caseRelatedObjectsToRemove){
            Case_Related_Object__c croToUpsert = caseRelatedObjectsByUrl.get(article.URL__c);
            croToUpsert.Id = article.Id;
         }
         upsert caseRelatedObjectsByUrl.values();
    }
}