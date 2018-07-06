public class CaseRelatedArticleListController {
    public Case c {get;set;}
    public List<CaseArticleWrapper> caseArticleWrappers {get;set;}
    public List<SelectOption> newArticleTypes {get;set;}
    public String newArticleType {get;set;}
    public Boolean createButtonActive {get;set;}
    public Boolean isSearch {get;set;}
    public String searchString {get;set;}
    public List<CaseArticleWrapper> searchResults {get;set;}

    

    
    public CaseRelatedArticleListController(ApexPages.StandardController sc) {
        c = (Case)sc.getRecord();
        caseArticleWrappers = getCaseArticles(c.Id);
        newArticleTypes = getArticleTypeOptions();
        newArticleType = '';
        isSearch = false;
        searchResults = new List<CaseArticleWrapper>();

    }

    public List<CaseArticleWrapper> getCaseArticles(String caseId) {
        List<CaseArticleWrapper> caws = new List<CaseArticleWrapper>();
        List<CaseArticle> cas = [SELECT Id, 
                                        KnowledgeArticleId,
                                        CaseId,
                                        CreatedDate
                                 FROM CaseArticle
                                 WHERE CaseId = :caseId];

        List<String> articleIds = new List<String>();
        for (CaseArticle ca : cas) {
            articleIds.add(ca.KnowledgeArticleId);
        }
        Map<String, Knowledge__kav> kavsByArticleId = new Map<String, Knowledge__kav>();
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c, ValidationStatus from Knowledge__kav WHERE KnowledgeArticleId in :articleIds AND PublishStatus = 'Archived']) {
            kavsByArticleId.put(kav.KnowledgeArticleId, kav);
        }
        
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c, ValidationStatus from Knowledge__kav WHERE KnowledgeArticleId in :articleIds AND PublishStatus = 'Online']) {
            kavsByArticleId.put(kav.KnowledgeArticleId, kav);
        }

        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c, ValidationStatus from Knowledge__kav WHERE KnowledgeArticleId in :articleIds AND PublishStatus = 'Draft']) {
            kavsByArticleId.put(kav.KnowledgeArticleId, kav);
        }
        
        

        Map<String, KnowledgeArticle> kasByArticleId = new Map<String, KnowledgeArticle>();
        for (KnowledgeArticle ka : [SELECT Id, CaseAssociationCount FROM KnowledgeArticle WHERE Id in :articleIds]) {
            kasByArticleId.put(ka.Id, ka);
        }

        for (CaseArticle ca : cas) {
            CaseArticleWrapper caw = new CaseArticleWrapper(this);
            caw.ca = ca;
            caw.kav = kavsByArticleId.get(ca.KnowledgeArticleId);
            caw.ka = kasByArticleId.get(ca.KnowledgeArticleId);
            caws.add(caw);
        }
        return caws;
    }

    public List<SelectOption> getArticleTypeOptions() {
        List<SelectOption> sos = new List<SelectOption>();
        sos.add(new SelectOption('','Choose New Article Type'));
        for (RecordType rt : [SELECT Name from RecordType WHERE IsActive = true AND SObjectType = 'Knowledge__kav' AND Name != 'Generic']) {

            sos.add(new SelectOption(rt.Id, rt.Name));
        }
        return sos;
    }

    public PageReference createNewArticle() {
        if (!String.isBlank(newArticleType)) {
            String url = '/apex/CustomKnowledgeEdit?caseId=' + c.Id + '&recordTypeId=' + newArticleType;
            PageReference pr = new PageReference(url);
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public void makeCreateButtonActive() {
        if (!String.isBlank(newArticleType)) {
            createButtonActive = true;
        } else {
            createButtonActive = false;
        }
    }
    
    public void findArticles() {
        isSearch = true;
    }
    
    public void cancelFindArticles() {
        isSearch = false;
    }

    public void doSearch() {
        
        String searchTerm = '%' + searchString + '%';
        Map<String,Knowledge__kav> resMap = new Map<String,Knowledge__kav>();
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c from Knowledge__kav WHERE (Auto_Article_Numbers__c LIKE :searchTerm OR CADocid__c LIKE :searchTerm) AND PublishStatus = 'Archived' LIMIT 1000]) {
            resMap.put(kav.KnowledgeArticleId, kav);
        }
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c from Knowledge__kav WHERE (Auto_Article_Numbers__c LIKE :searchTerm OR CADocid__c LIKE :searchTerm) AND PublishStatus = 'Draft' LIMIT 1000]) {
            resMap.put(kav.KnowledgeArticleId, kav);
        }
        for (Knowledge__kav kav : [SELECT Id, KnowledgeArticleId, Title, Cause__c, ArticleNumber, PublishStatus,LastModifiedDate, Case__c from Knowledge__kav WHERE (Auto_Article_Numbers__c LIKE :searchTerm OR CADocid__c LIKE :searchTerm) AND PublishStatus = 'Online' LIMIT 1000]) {
            resMap.put(kav.KnowledgeArticleId, kav);
        }
        Integer i = 0;
        for (Knowledge__kav kav : resMap.values()) {
            if (i<500) {
                CaseArticleWrapper caw = new CaseArticleWrapper(this);
                caw.kav = kav;
                searchResults.add(caw);
            }
            i++;
        }

    }

    public void attachSelected() {
        List<CaseArticle> insertCAs = new List<CaseArticle>();
        for (CaseArticleWrapper caw : searchResults) {
            if (caw.attach) {
                CaseArticle ca = new CaseArticle(caseId = c.Id, knowledgearticleid=caw.kav.KnowledgeArticleId);
                insertCAs.add(ca);
            }
        }
        if (!insertCAs.isEmpty()) {
            insert insertCAs;
        }
        caseArticleWrappers = getCaseArticles(c.Id);
        isSearch = false;
    }




    public class CaseArticleWrapper {
        public CaseArticle ca {get;set;}
        public Knowledge__kav kav {get;set;}
        public KnowledgeArticle ka {get;set;}
        public CaseRelatedArticleListController controller {get;set;}
        public Boolean attach {get;set;}

        public CaseArticleWrapper(CaseRelatedArticleListController c) {
            controller = c;
        }

        public PageReference detach() {
            delete ca;
            controller.caseArticleWrappers = controller.getCaseArticles(controller.c.Id);
            return null;
        }
    }
}