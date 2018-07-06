public class AutomicDeleteArticlesBatch implements Database.Batchable<sObject>{

		String publishStatus;
		public AutomicDeleteArticlesBatch(String pStatus){
			publishStatus=pStatus;
		}
		public Database.QueryLocator start(Database.BatchableContext batchableContext){
			String query = 'select KnowledgeArticleId from Knowledge__kav where Legacy_Source__c=\'Automic\' and PublishStatus=\''+publishStatus+'\'';
			return Database.getQueryLocator(query);
		}

		public void execute(Database.BatchableContext batchableContext, List<Knowledge__kav> knowledgeObjectList){
			for(Knowledge__kav knowledgeObject : knowledgeObjectList){
				if(publishStatus.equalsIgnoreCase('Draft')){
					KbManagement.PublishingService.deleteDraftArticle(knowledgeObject.KnowledgeArticleId);
				}else if(publishStatus.equalsIgnoreCase('Online')){
					KbManagement.PublishingService.editOnlineArticle (knowledgeObject.KnowledgeArticleId, true);
					KbManagement.PublishingService.deleteDraftArticle(knowledgeObject.KnowledgeArticleId);
				}else if(publishStatus.equalsIgnoreCase('Archived')){
					KbManagement.PublishingService.deleteArchivedArticle(knowledgeObject.KnowledgeArticleId);
				}
			}
		}

		public void finish(Database.BatchableContext batchableContext){}
}