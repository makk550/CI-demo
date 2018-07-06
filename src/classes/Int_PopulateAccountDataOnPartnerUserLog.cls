public class Int_PopulateAccountDataOnPartnerUserLog {
	
	public static void populateAccountDataOnPartnerUserLog(List<Partner_User_Log__c> listOfPartnerLogs){
		
		Set<Id> setOfUsers = new Set<Id>();
		Set<Id> setOfUserAccountId = new Set<Id>();
		Map<Id,Id> mapOfUserAccountId = new Map<Id,Id>();
		Map<Id,Account> mapOfUserAccounts = new Map<Id,Account>();		
		
		//gather the Ids of the partner users created or updated.
		for(Partner_User_Log__c p: listOfPartnerLogs){
			setOfUsers.add(p.User__c);
		}
		
		for(User u: [select Id, AccountId from User where id in: setOfUsers]){
			mapOfUserAccountID.put(u.Id,u.AccountId);
		}
//		mapOfUserAccountID=new Map<Id,Id>([select Id, AccountId from User where id in: setOfUsers]);
		mapOfUserAccounts= new Map<Id,Account>([select GEO__c,Reseller_Type__c,Reseller_Disti_Regional_ID__c,
		CPMS_ID__c,Customer_Category__c from Account where Id in: mapOfUserAccountID.values()]);
		
		for(Partner_User_Log__c thisLog: listOfPartnerLogs){
			thisLog.Account_Region__c=mapOfUserAccounts.get(mapOfUserAccountID.get(thisLog.User__c)).GEO__c;
			thisLog.Account_Reseller_Type__c=mapOfUserAccounts.get(mapOfUserAccountID.get(thisLog.User__c)).Reseller_Type__c;
			thisLog.Reseller_Disti_Regional_ID__c=mapOfUserAccounts.get(mapOfUserAccountID.get(thisLog.User__c)).Reseller_Disti_Regional_ID__c;
			thisLog.CPMS_HQ_ID__c=mapOfUserAccounts.get(mapOfUserAccountID.get(thisLog.User__c)).CPMS_ID__c;
			thisLog.Account_Type__c=mapOfUserAccounts.get(mapOfUserAccountID.get(thisLog.User__c)).Customer_Category__c;
		}
	}

}