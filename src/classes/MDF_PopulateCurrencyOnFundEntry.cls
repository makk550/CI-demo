public class MDF_PopulateCurrencyOnFundEntry {
	
	public static void populateCurrencyOnFundEntry(List<SFDC_Budget_Entry__c> listOfEntries){
		
		Set<Id> listOfBudgetIds = new Set<Id>();
		Map<Id,SFDC_Budget__c> mapOfBudget=new Map<Id,SFDC_Budget__c>();
		
		for(SFDC_Budget_Entry__c thisEntry : listOfEntries)
			listOfBudgetIds.add(thisEntry.Budget__c);
			
		mapOfBudget= new Map<Id,SFDC_Budget__c>([select Id,CurrencyIsoCode from SFDC_Budget__c where Id in:listOfBudgetIds]);
		
		for(SFDC_Budget_Entry__c thisEntry : listOfEntries)
			thisEntry.CurrencyIsoCode=(mapOfBudget.get(thisEntry.Budget__c)).CurrencyIsoCode;
	}
}