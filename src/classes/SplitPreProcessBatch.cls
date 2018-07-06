global class SplitPreProcessBatch Implements Database.Batchable<sObject>, Schedulable{
	
	global Database.queryLocator start(Database.BatchableContext bc)
	{
		String soql = 'select Id, User.PMFKey__c, UserId, TAQWhy__c, split0__LastSplitDate__c, ';
		soql = soql + 'TAQOA__c, TAQATA__c, ';
		soql = soql + 'TAQWhen__c, TAQAddl__c, ';
		soql = soql + 'TAQATA__r.TAQ_Account_Approved__r.Is_Latest_Record__c, TAQOA__r.Is_Latest_Record__c, ';
		soql = soql + 'OpportunityId, Opportunity.Id, Opportunity.AccountId, LastModifiedDate, Opportunity.LastModifiedDate, LastModifiedById, LastModifiedBy.Name ';
		soql = soql + 'from OpportunityTeamMember ';
		soql = soql + 'WHERE LastModifiedDate >= LAST_YEAR ';
		soql = soql + 'order by OpportunityId ';
		if(Test.isRunningTest())
		{
			soql = soql + ' LIMIT 1000 ';
		}
		return Database.getQueryLocator(soql);
	}
	
	global void execute(Database.batchableContext bc, List<OpportunityTeamMember> otms)
	{
		SplitPreProcessManager pm = new SplitPreProcessManager();
		pm.loadAll(otms);
		if(pm.otmMap.isEmpty()) return;		
		pm.saveChangedRecords();
	}

	global void finish(Database.batchableContext bc)
	{
		Split_Settings_Pre__c stgs = Split_Settings_Pre__c.getInstance();
		if(stgs != null && stgs.AutostartSplitBatch__c)
		{
			Type t = Type.forName('split0.SplitProcessorBatch');		
			Database.Batchable<sObject> b = (Database.Batchable<sObject>)t.newInstance();
			if(!Test.isRunningTest())
			Database.executeBatch(b, 5);
		}
	}

	global void execute(SchedulableContext sc) {
		SplitPreProcessBatch b = new SplitPreProcessBatch();
		if(!Test.isRunningTest()) Database.executeBatch(b, 1000);
	}
	
}