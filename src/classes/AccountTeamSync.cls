global class AccountTeamSync
{
	webService static void syncAccountTeamToAccPlanWebService(Account a)
	{
		syncAccountTeamToAccPlanInternal(a);
	}
	
	private static void syncAccountTeamToAccPlanInternal(Account a)
	{
		List<SFDC_Acct_Plan__Share> insertlist = new List<SFDC_Acct_Plan__Share>();
		List<SFDC_Acct_Plan__Share> updatelist = new List<SFDC_Acct_Plan__Share>();
		List<SFDC_Acct_Plan__c> accountPlanList = [select Id from SFDC_Acct_Plan__c where Account__c= :a.Id];
		List<AccountTeamMember> accountTeamList = [select Id, AccountAccessLevel, UserId from AccountTeamMember where AccountId= :a.Id];
		for (SFDC_Acct_Plan__c accountPlan : accountPlanList)
		{				
			List<SFDC_Acct_Plan__Share> accountPlanShareList = [select Id, UserOrGroupId from SFDC_Acct_Plan__Share where ParentId= :accountPlan.Id];
			for (AccountTeamMember accountTeam : accountTeamList)
			{
				String accountTeamAccessLevel=accountTeam.AccountAccessLevel;
				Boolean ifExist=false;
				for (SFDC_Acct_Plan__Share accountPlanShare : accountPlanShareList)
				{
					if(accountTeam.UserId==accountPlanShare.UserOrGroupId)
					{
						ifExist=true;
						if(accountTeamAccessLevel=='Edit')
						{
							accountPlanShare.AccessLevel=accountTeamAccessLevel;
							updatelist.add(accountPlanShare);
						}
						break;
					}
				}
				if(!ifExist)
				{
					SFDC_Acct_Plan__Share newAccountPlanShare=new SFDC_Acct_Plan__Share(ParentId = accountPlan.Id, AccessLevel = accountTeamAccessLevel, UserOrGroupId= accountTeam.UserId);
					insertlist.add(newAccountPlanShare);
				}
			}
		}
		for (SFDC_Acct_Plan__c accountPlan : accountPlanList)
		{
			if(a.OwnerId!=accountPlan.OwnerId)
			{
				SFDC_Acct_Plan__Share newAccountPlanShare=new SFDC_Acct_Plan__Share(ParentId = accountPlan.Id, AccessLevel = 'Edit', UserOrGroupId= a.OwnerId);
				insertlist.add(newAccountPlanShare);
			}
		}

		insert insertlist;
		update updatelist;
		insertlist.clear();
		updatelist.clear();
	}
	
	public static testMethod void testAccountSyncTrigger() 
	{
		try 
		{
			String userId = //'005300000015ghB';
			'00530000000wdzY';
			//Sandbox yoon's id 
			//'005300000015ghB';
			Account acc = new Account(name='AccountTeamSyncTestRunAccount');
			insert acc;
			AccountTeamMember accTeam = new AccountTeamMember(AccountAccessLevel='Edit', UserId=userId, AccountId = acc.Id);
			insert accTeam;
			SFDC_Acct_Plan__c accPlan = new SFDC_Acct_Plan__c(Account__c=acc.Id, name='Test Acc Plan');
			insert accPlan;
			syncAccountTeamToAccPlanInternal(acc);
			
			//Finally clean the mess
			delete accPlan;
			delete accTeam;
			delete acc;
			
		} catch (System.DmlException e) 
		{
		}
	}
}