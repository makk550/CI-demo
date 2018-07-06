public class AutomicKBToKBLinkBatch  implements Database.Batchable<sObject>{

		public Database.QueryLocator start(Database.BatchableContext batchableContext){
			String query = 'select Additional_Information__c,Answer__c,Background__c, Cause__c, Content4__c, Environment__c, Instructions__c, Content3__c, Introduction__c, Content1__c, Question__c, Content2__c, Notes__c from Knowledge__kav where Legacy_Source__c=\'Automic\' and PublishStatus=\'Draft\'';
			return Database.getQueryLocator(query);
		}

		public void execute(Database.BatchableContext batchableContext, List<Knowledge__kav> knowledgeObjectList){
			for(Knowledge__kav knowledgeObject : knowledgeObjectList){
				knowledgeObject.Additional_Information__c = updateKBToKBLink(knowledgeObject.Additional_Information__c);
                knowledgeObject.Answer__c = updateKBToKBLink(knowledgeObject.Answer__c);
                knowledgeObject.Background__c = updateKBToKBLink(knowledgeObject.Background__c);
                knowledgeObject.Cause__c = updateKBToKBLink(knowledgeObject.Cause__c);
                knowledgeObject.Content4__c = updateKBToKBLink(knowledgeObject.Content4__c);
                knowledgeObject.Environment__c = updateKBToKBLink(knowledgeObject.Environment__c);
                knowledgeObject.Instructions__c = updateKBToKBLink(knowledgeObject.Instructions__c);
                knowledgeObject.Content3__c = updateKBToKBLink(knowledgeObject.Content3__c);
                knowledgeObject.Introduction__c = updateKBToKBLink(knowledgeObject.Introduction__c);
                knowledgeObject.Content1__c = updateKBToKBLink(knowledgeObject.Content1__c);
                knowledgeObject.Question__c = updateKBToKBLink(knowledgeObject.Question__c);
                knowledgeObject.Content2__c = updateKBToKBLink(knowledgeObject.Content2__c);
                
                knowledgeObject.Title = addLineBreak(knowledgeObject.Title);
                knowledgeObject.UrlName = addLineBreak(knowledgeObject.UrlName);
                knowledgeObject.Summary = addLineBreak(knowledgeObject.Summary);
                knowledgeObject.Keywords__c = addLineBreak(knowledgeObject.Keywords__c);
                knowledgeObject.Notes__c = addLineBreak(updateKBToKBLink(knowledgeObject.Notes__c));
                update knowledgeObject;
			}
		}

		public void finish(Database.BatchableContext batchableContext){}
    
    private String updateKBToKBLink(String data) {
		while(data.contains('https://automic.force.com/support/apex/CommunityArticleDetail?id=')){
			String automicId = data.substring(data.indexOf('https://automic.force.com/support/apex/CommunityArticleDetail?id=')+65, data.indexOf('https://automic.force.com/support/apex/CommunityArticleDetail?id=')+80);
			List<Knowledge__kav> knowledgeList = [select Id from Knowledge__kav where PublishStatus = 'Draft' and Legacy_Article_Id__c like : automicId];

            if(null != knowledgeList && String.isNotBlank(knowledgeList[0].Id)){
                String id = knowledgeList[0].Id;
				data = data.replace('https://automic.force.com/support/apex/CommunityArticleDetail?id='+automicId, 'https://ca--fsb1.cs78.my.salesforce.com/'+id.subString(0,15));
				System.Debug(' $$$$$$$$$$$$$$$'  + data);
			}else{
				data = data.replace('https://automic.force.com/support/apex/CommunityArticleDetail?id='+automicId, '#');
				System.Debug(' ******** ' + data);
			}
		}
		return data;
	}
    
    private String addLineBreak(String data) {
		if(data.contains('qqqq')){
			data = data.replace('qqqq', '\n\n');
		}else if(data.contains('qq')){
			data = data.replace('qq', '\n');
		}
		return data;
	}
}