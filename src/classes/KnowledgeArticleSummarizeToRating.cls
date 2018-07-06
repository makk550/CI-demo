global class KnowledgeArticleSummarizeToRating implements Database.Batchable<sObject>, Schedulable{

	public static String JOB_TITLE = 'Job to stamp ratings with article details for reporting';
	public static String CRON_STRING = '0 0 3 * * ?'; // 3 AM daily

	public static void scheduleMe(){
		KnowledgeArticleSummarizeToRating sch = new KnowledgeArticleSummarizeToRating();

		if(Test.isRunningTest()){
			System.schedule('Test ' + JOB_TITLE + ' Test', CRON_STRING, sch);
		}else{
			System.schedule(JOB_TITLE, CRON_STRING, sch);
		}
	}

	public void execute(SchedulableContext sc){
		KnowledgeArticleSummarizeToRating sch = new KnowledgeArticleSummarizeToRating();
		Database.executeBatch(sch, 200); // integer is the size of the batch
	}

	public final String objects;

	public KnowledgeArticleSummarizeToRating() {

		objects = 'SELECT Id, Name,Author__c,Component_Names__c,Product_Names__c,Title__c FROM KBArticle_Rating__c WHERE Title__c = null';
		system.debug(objects);
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(objects);
	}

	global void execute(Database.BatchableContext BC, List<KBArticle_Rating__c> scope){ 
		List<KBArticle_Rating__c> updates = new List<KBArticle_Rating__c>();
		List<String> articleNums = new List<String>();
		for(KBArticle_Rating__c record : scope){
			articleNums.add(record.Name);
		}
		Map<String,Knowledge__kav> articles = new Map<String,Knowledge__kav>();
		List<Knowledge__kav> articleList = [SELECT Id,
		                                           ArticleNumber,
		                                           Title,
		                                           CreatedById,
		                                           Component_Names__c,
		                                           Product_Names__c
		                                    FROM Knowledge__kav
		                                    WHERE ArticleNumber in :articleNums
		                                    AND PublishStatus = 'Online'];

		for (Knowledge__kav article : articleList) {
			articles.put(article.ArticleNumber, article);
		}

		for (KBArticle_Rating__c record : scope) {
			if (articles.containsKey(record.Name)) {
				Knowledge__kav art = articles.get(record.Name);
				record.Author__c = art.CreatedById;
				record.Component_Names__c = art.Component_Names__c;
				record.Product_Names__c = art.Product_Names__c;
				record.Title__c = art.Title;
				updates.add(record);
			}
		}
		if (!updates.isEmpty()) {
			Database.SaveResult [] updateResult = Database.update(updates, false);
		}


	}

	global void finish(Database.BatchableContext BC){

	}
}