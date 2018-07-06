global class KBCaseToCaseArticle implements Database.Batchable<sObject> {
	
	String query;
	
	global KBCaseToCaseArticle() {
		query = 'SELECT Id,Case__c,KB_Article__r.KB_Article_No__c FROM KB_Article_Case__c WHERE KB_Article__r.KB_Article_No__c != null AND Case__c != null';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<KB_Article_Case__c> scope) {
   		List<String> documentIds = new List<String>();
   		List<String> caseIds = new List<String>();
   		
   		for (KB_Article_Case__c kbcase : scope) {
   			system.debug(kbcase.Case__c);
   			documentIds.add(kbcase.KB_Article__r.KB_Article_No__c);
   			caseIds.add(kbcase.Case__c);
   		}
   		Map<String,String> artIdsByDocId = new Map<String,String>();
        for (Knowledge__kav article : [SELECT Id, KnowledgeArticleId, CADocid__c FROM Knowledge__kav WHERE PublishStatus = 'Archived' AND CADocid__c in :documentIds]) {
   			artIdsByDocId.put(article.CADocid__c, article.KnowledgeArticleId);
   		}
   		for (Knowledge__kav article : [SELECT Id, KnowledgeArticleId, CADocid__c FROM Knowledge__kav WHERE PublishStatus = 'Online' AND CADocid__c in :documentIds]) {
   			artIdsByDocId.put(article.CADocid__c, article.KnowledgeArticleId);
   		}
   		Map<String,Set<String>> existingArticlesByCase = new Map<String,Set<String>>();
   		for (CaseArticle ca : [SELECT Id, CaseId, KnowledgeArticleId FROM CaseArticle WHERE CaseId in :caseIds]) {
   			Set<String> articlesForCase = new Set<String>();
   			if (existingArticlesByCase.containsKey(ca.CaseId)) {
   				articlesForCase = existingArticlesByCase.get(ca.CaseId);
   			}
   			articlesForCase.add(ca.KnowledgeArticleId);
   			existingArticlesByCase.put(ca.CaseId, articlesForCase);
   		}

   		List<CaseArticle> casToInsert = new List<CaseArticle>();
   		for (KB_Article_Case__c kbcase : scope) {
   			if (artIdsByDocId.containsKey(kbcase.KB_Article__r.KB_Article_No__c)) {
   				String artId = artIdsByDocId.get(kbcase.KB_Article__r.KB_Article_No__c);
   				Set<String> articlesForCase = new Set<String>();
   				if (existingArticlesByCase.containsKey(kbcase.Case__c)) {
   					articlesForCase = existingArticlesByCase.get(kbcase.Case__c);
   				}
   				if (!articlesForCase.contains(artId)) {
   					CaseArticle ca = new CaseArticle(caseId=kbcase.Case__c,
                                         knowledgearticleid=artId);
   					casToInsert.add(ca);
   					system.debug('caseId ' + ca.caseId + ' articleId ' + ca.knowledgearticleid);
   				}
   			}
   		}
   		if (!casToInsert.isEmpty()) {
   			insert casToInsert;
            
   		}
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}